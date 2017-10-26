Date: Thu, 26 Oct 2017 13:58:38 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171026025838.GG12341@eros>
References: <1508986436-31966-1-git-send-email-me@tobin.cc>
 <1508986436-31966-3-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508986436-31966-3-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] Re: [PATCH V8 2/2] printk: hash addresses printed with %p
To: kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 26, 2017 at 01:53:56PM +1100, Tobin C. Harding wrote:
> Currently there are many places in the kernel where addresses are being
> printed using an unadorned %p. Kernel pointers should be printed using
> %pK allowing some control via the kptr_restrict sysctl. Exposing addresses
> gives attackers sensitive information about the kernel layout in memory.
> 
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
>  lib/vsprintf.c | 157 +++++++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 107 insertions(+), 50 deletions(-)
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 16a587aed40e..8f4aebd10c7e 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -33,6 +33,8 @@
>  #include <linux/uuid.h>
>  #include <linux/of.h>
>  #include <net/addrconf.h>
> +#include <linux/siphash.h>
> +#include <linux/compiler.h>
>  #ifdef CONFIG_BLOCK
>  #include <linux/blkdev.h>
>  #endif
> @@ -1344,6 +1346,57 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
>  }
>  
>  static noinline_for_stack
> +char *kernel_pointer(char *buf, char *end, const void *ptr,
> +		     struct printf_spec spec)
> +{
> +	spec.base = 16;
> +	spec.flags |= SMALL;
> +	if (spec.field_width == -1) {
> +		spec.field_width = 2 * sizeof(void *);
> +		spec.flags |= ZEROPAD;
> +	}
> +
> +	switch (kptr_restrict) {
> +	case 0:
> +		/* Always print %pK values */
> +		break;
> +	case 1: {
> +		const struct cred *cred;
> +
> +		/*
> +		 * kptr_restrict==1 cannot be used in IRQ context
> +		 * because its test for CAP_SYSLOG would be meaningless.
> +		 */
> +		if (in_irq() || in_serving_softirq() || in_nmi())
> +			return string(buf, end, "pK-error", spec);
> +
> +		/*
> +		 * Only print the real pointer value if the current
> +		 * process has CAP_SYSLOG and is running with the
> +		 * same credentials it started with. This is because
> +		 * access to files is checked at open() time, but %pK
> +		 * checks permission at read() time. We don't want to
> +		 * leak pointer values if a binary opens a file using
> +		 * %pK and then elevates privileges before reading it.
> +		 */
> +		cred = current_cred();
> +		if (!has_capability_noaudit(current, CAP_SYSLOG) ||
> +		    !uid_eq(cred->euid, cred->uid) ||
> +		    !gid_eq(cred->egid, cred->gid))
> +			ptr = NULL;
> +		break;
> +	}
> +	case 2:
> +	default:
> +		/* Always print 0's for %pK */
> +		ptr = NULL;
> +		break;
> +	}
> +
> +	return number(buf, end, (unsigned long)ptr, spec);
> +}
> +
> +static noinline_for_stack
>  char *netdev_bits(char *buf, char *end, const void *addr, const char *fmt)
>  {
>  	unsigned long long num;
> @@ -1591,6 +1644,54 @@ char *device_node_string(char *buf, char *end, struct device_node *dn,
>  	return widen_string(buf, buf - buf_start, end, spec);
>  }
>  
> +static bool have_filled_random_ptr_key;
> +static siphash_key_t ptr_key __read_mostly;
> +
> +static void fill_random_ptr_key(struct random_ready_callback *unused)
> +{
> +	get_random_bytes(&ptr_key, sizeof(ptr_key));
> +	WRITE_ONCE(have_filled_random_ptr_key, true);

This usage of WRITE_ONCE was suggested by Jason A. Donenfeld. I read
include/linux/compiler.h but was not able to grok it. Is this enough to
stop the compiler re-ordering these two statements? 

Or do I need to read Documentation/memory-barriers.txt [again]?

thanks,
Tobin.
