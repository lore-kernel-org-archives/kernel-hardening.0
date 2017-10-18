MIME-Version: 1.0
In-Reply-To: <1508215972-7769-1-git-send-email-me@tobin.cc>
References: <1508215972-7769-1-git-send-email-me@tobin.cc>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 18 Oct 2017 02:27:43 +0200
Message-ID: <CAHmME9oTM_yJZ6FnDoNJwXOaUD9C00NNN-2USaHawyfJ6CCsFw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Tobin,

Many comments in line below.

On Tue, Oct 17, 2017 at 6:52 AM, Tobin C. Harding <me@tobin.cc> wrote:
>
> diff --git a/include/linux/siphash.h b/include/linux/siphash.h
> index fa7a6b9cedbf..a9392568c8b8 100644
> --- a/include/linux/siphash.h
> +++ b/include/linux/siphash.h
> @@ -26,6 +26,8 @@ u64 __siphash_aligned(const void *data, size_t len, const siphash_key_t *key);
>  u64 __siphash_unaligned(const void *data, size_t len, const siphash_key_t *key);
>  #endif
>
> +unsigned long siphash_1ulong(const unsigned long a, const siphash_key_t *key);

This signature is incorrect, as siphash always returns a u64. The
caller should do the casting, not the actual function itself.
[However, see below. I don't think you should be touching this file.]

>  u64 siphash_1u64(const u64 a, const siphash_key_t *key);
>  u64 siphash_2u64(const u64 a, const u64 b, const siphash_key_t *key);
>  u64 siphash_3u64(const u64 a, const u64 b, const u64 c,
> diff --git a/lib/siphash.c b/lib/siphash.c
> index 3ae58b4edad6..63f4ff57c9ce 100644
> --- a/lib/siphash.c
> +++ b/lib/siphash.c
> @@ -116,6 +116,19 @@ EXPORT_SYMBOL(__siphash_unaligned);
>  #endif
>
>  /**
> + * siphash_1ulong - computes siphash PRF value
> + * @first: value to hash
> + * @key: the siphash key
> + */

Please match the template usage text of every single other function, like so:

* siphash_1ulong - compute 64-bit siphash PRF value of 1 unsigned long
* @first: first unsigned long
* @key: the siphash key

[However, see below. I don't think you should be touching this file.]


> +unsigned long siphash_1ulong(const unsigned long first, const siphash_key_t *key)

Return u64. [However, see below. I don't think you should be touching
this file.]

> +{
> +#ifdef CONFIG_64BIT
> +       return (unsigned long)siphash_1u64((u64)first, key);

Don't cast it here. [However, see below. I don't think you should be
touching this file.]

> +#endif

There's no point in making gcc's life harder. Use an #else for the
32-bit section. [However, see below. I don't think you should be
touching this file.]


> +       return (unsigned long)siphash_1u32((u32)first, key);

Also don't cast. [However, see below. I don't think you should be
touching this file.]

> +/* Maps a pointer to a 32 bit unique identifier. */
> +static char *ptr_to_id(char *buf, char *end, void *ptr, struct printf_spec spec)
> +{
> +       static siphash_key_t ptr_secret __read_mostly;
> +       static bool have_key = false;
> +       unsigned long hashval;
> +
> +       /* Kernel doesn't boot if we use get_random_once() */
> +       if (!have_key) {
> +               get_random_bytes(&ptr_secret, sizeof(ptr_secret));
> +               have_key = true;
> +       }

This is wrong. You need to either use get_random_bytes_wait, which you
can't actually do safely here. So, better, use
add_random_ready_callback to get a notification of when this is safe
to use. Before it's safe to use, simply return "(ptr value)" or some
similar stub.

> +
> +       hashval = siphash_1ulong((unsigned long)ptr, &ptr_secret);

As mentioned above with the [brackets], don't pollute
siphash.h/siphash.c with the helper, and just put the #ifdef stuff
here. That should make it much more clear what's going on and also
make it easier in the future to swap out the 32-bit function when
we're ready.

So, this looks like instead:

#ifdef CONFIG_64BIT
hashval = (unsigned long)siphash_1u64((u64)ptr, key);
#else
hashval = (unsigned long)siphash_1u32((u32)ptr, key);
#endif

However, in another thread, Linus mentioned that he'd prefer all the
obfuscated values actually be 32-bit. So, this then looks like:

unsigned int hashval;
...
#ifdef CONFIG_64BIT
hashval = (unsigned int)siphash_1u64((u64)ptr, key);
#else
hashval = (unsigned int)siphash_1u32((u32)ptr, key);
#endif


Looking forward to v3!

Thanks,
Jason
