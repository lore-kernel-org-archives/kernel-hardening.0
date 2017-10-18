MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1508362242-12857-1-git-send-email-me@tobin.cc>
References: <1508362242-12857-1-git-send-email-me@tobin.cc>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 18 Oct 2017 15:31:16 -0700
Message-ID: <CAGXu5jK_uybeGXT3AzKGYA7k4pV4YZ02S+EEybDyD5_uiJn4hw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 18, 2017 at 2:30 PM, Tobin C. Harding <me@tobin.cc> wrote:
> Currently there are many places in the kernel where addresses are being
> printed using an unadorned %p. Kernel pointers should be printed using
> %pK allowing some control via the kptr_restrict sysctl. Exposing addresses
> gives attackers sensitive information about the kernel layout in memory.

Is it intended for %pK to be covered by the hash as well? (When a
disallowed user is looking at %pK output, like kallsyms, the same hash
is seen for all values, rather than just zero -- I assume since the
value hashed is zero.)

> We can reduce the attack surface by hashing all addresses printed with
> %p. This will of course break some users, forcing code printing needed
> addresses to be updated.
>
> For what it's worth, usage of unadorned %p can be broken down as
> follows (thanks to Joe Perches).
>
> $ git grep -E '%p[^A-Za-z0-9]' | cut -f1 -d"/" | sort | uniq -c
>    1084 arch
>      20 block
>      10 crypto
>      32 Documentation
>    8121 drivers
>    1221 fs
>     143 include
>     101 kernel
>      69 lib
>     100 mm
>    1510 net
>      40 samples
>       7 scripts
>      11 security
>     166 sound
>     152 tools
>       2 virt
>
> Add function ptr_to_id() to map an address to a 32 bit unique identifier.
>
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> ---
>
> V5:
>  - Remove spin lock.
>  - Add Jason A. Donenfeld to CC list by request.
>  - Add Theodore Ts'o to CC list due to comment on previous version.
>
> V4:
>  - Remove changes to siphash.{ch}
>  - Do word size check, and return value cast, directly in ptr_to_id().
>  - Use add_ready_random_callback() to guard call to get_random_bytes()
>
> V3:
>  - Use atomic_xchg() to guard setting [random] key.
>  - Remove erroneous white space change.
>
> V2:
>  - Use SipHash to do the hashing.
>
> The discussion related to this patch has been fragmented. There are
> three threads associated with this patch. Email threads by subject:
>
> [PATCH] printk: hash addresses printed with %p
> [PATCH 0/3] add %pX specifier
> [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options
>
>  lib/vsprintf.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 63 insertions(+), 3 deletions(-)
>
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 86c3385b9eb3..14d4c6653384 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -33,6 +33,7 @@
>  #include <linux/uuid.h>
>  #include <linux/of.h>
>  #include <net/addrconf.h>
> +#include <linux/siphash.h>
>  #ifdef CONFIG_BLOCK
>  #include <linux/blkdev.h>
>  #endif
> @@ -1591,6 +1592,63 @@ char *device_node_string(char *buf, char *end, struct device_node *dn,
>         return widen_string(buf, buf - buf_start, end, spec);
>  }
>
> +static siphash_key_t ptr_secret __read_mostly;
> +static atomic_t have_key = ATOMIC_INIT(0);
> +
> +static void initialize_ptr_secret(void)
> +{
> +       if (atomic_read(&have_key) == 1)
> +               return;
> +
> +       get_random_bytes(&ptr_secret, sizeof(ptr_secret));
> +       atomic_set(&have_key, 1);
> +}
> +
> +static void schedule_async_key_init(struct random_ready_callback *rdy)
> +{
> +       initialize_ptr_secret();
> +}
> +
> +/* Maps a pointer to a 32 bit unique identifier. */
> +static char *ptr_to_id(char *buf, char *end, void *ptr, struct printf_spec spec)
> +{
> +       static struct random_ready_callback random_ready;
> +       unsigned int hashval;
> +       int err;
> +
> +       if (atomic_read(&have_key) == 0) {
> +               random_ready.owner = NULL;
> +               random_ready.func = schedule_async_key_init;
> +
> +               err = add_random_ready_callback(&random_ready);
> +
> +               switch (err) {
> +               case 0:
> +                       return "(pointer value)";
> +
> +               case -EALREADY:
> +                       initialize_ptr_secret();
> +                       break;
> +
> +               default:
> +                       /* shouldn't get here */
> +                       return "(ptr_to_id() error)";
> +               }
> +       }
> +
> +#ifdef CONFIG_64BIT
> +       hashval = (unsigned int)siphash_1u64((u64)ptr, &ptr_secret);
> +#else
> +       hashval = (unsigned int)siphash_1u32((u32)ptr, &ptr_secret);
> +#endif
> +
> +       spec.field_width = 2 + 2 * sizeof(unsigned int); /* 0x + hex */
> +       spec.flags = SPECIAL | SMALL | ZEROPAD;

I don't think this should have SPECIAL. We end up changing things like
kallsyms (which didn't have 0x before) and printing with double 0x's:

        seq_printf(m, " 0x%pK", mod->core_layout.base);
...
# cat /proc/modules
test_module 16384 0 - Live 0x0xdf81cfb6

> +       spec.base = 16;
> +
> +       return number(buf, end, hashval, spec);
> +}
> +
>  int kptr_restrict __read_mostly;
>
>  /*
> @@ -1703,6 +1761,9 @@ int kptr_restrict __read_mostly;
>   * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
>   * function pointers are really function descriptors, which contain a
>   * pointer to the real address.
> + *
> + * Default behaviour (unadorned %p) is to hash the address, rendering it useful
> + * as a unique identifier.
>   */
>  static noinline_for_stack
>  char *pointer(const char *fmt, char *buf, char *end, void *ptr,
> @@ -1858,14 +1919,13 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>                         return device_node_string(buf, end, ptr, spec, fmt + 1);
>                 }
>         }
> -       spec.flags |= SMALL;
> +
>         if (spec.field_width == -1) {
>                 spec.field_width = default_width;
>                 spec.flags |= ZEROPAD;
>         }
> -       spec.base = 16;
>
> -       return number(buf, end, (unsigned long) ptr, spec);
> +       return ptr_to_id(buf, end, ptr, spec);
>  }
>
>  /*
> --
> 2.7.4
>

Getting closer! Thanks for continuing to work on it. :)

-Kees

-- 
Kees Cook
Pixel Security
