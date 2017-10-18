MIME-Version: 1.0
In-Reply-To: <1508288088-31867-1-git-send-email-me@tobin.cc>
References: <1508288088-31867-1-git-send-email-me@tobin.cc>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 18 Oct 2017 02:59:17 +0200
Message-ID: <CAHmME9oGm3uHx40Qd=VfhhqPkh2mPy+cOqAodynnEONnKOe-3g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH v3] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Tobin,

You submitted v3 without replying to my v2 comments. I'll give a
condensed version of those here for convenience.

> diff --git a/include/linux/siphash.h b/include/linux/siphash.h
> +unsigned long siphash_1ulong(const unsigned long a, const siphash_key_t *key);

Don't add this function here. It's not the right signature anyway.
> +unsigned long siphash_1ulong(const unsigned long first, const siphash_key_t *key)
> +{

Likewise, remove this.

> +/* Maps a pointer to a 32 bit unique identifier. */
> +static char *ptr_to_id(char *buf, char *end, void *ptr, struct printf_spec spec)
> +{
> +       static siphash_key_t ptr_secret __read_mostly;
> +       static atomic_t have_key = ATOMIC_INIT(0);
> +       unsigned long hashval;
> +
> +        if (atomic_xchg(&have_key, 1) == 0)
> +               get_random_bytes(&ptr_secret, sizeof(ptr_secret));

This isn't safe. Initialize ptr_secret in the callback function
provided to add_random_ready_callback. Before ptr_secret is
initialized, you should simply return a stub literal string from that
function of something like "(pointer value)".

> +       hashval = siphash_1ulong((unsigned long)ptr, &ptr_secret);

Replace this with:

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
