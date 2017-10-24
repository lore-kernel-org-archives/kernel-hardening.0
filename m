From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
References: <1508798008-1692-1-git-send-email-me@tobin.cc>
Date: Tue, 24 Oct 2017 21:25:20 +0200
In-Reply-To: <1508798008-1692-1-git-send-email-me@tobin.cc> (Tobin
	C. Harding's message of "Tue, 24 Oct 2017 09:33:28 +1100")
Message-ID: <87bmkw5owv.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH v7] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 24 2017, "Tobin C. Harding" <me@tobin.cc> wrote:

> +
> +/* Maps a pointer to a 32 bit unique identifier. */
> +static char *ptr_to_id(char *buf, char *end, void *ptr, struct printf_spec spec)
> +{
> +	unsigned int hashval;
> +
> +	if (static_branch_unlikely(&no_ptr_secret))
> +		return "(pointer value)";

Eh, you probably meant to call

  string(buf, end, "(pointer value)", some-appropriate-spec)

otherwise this will either crash very soon (when the following output
wants to overwrite that '(' in .rodata), or at the very least cause a
completely bogus eventual return value (if the "(pointer value)" string
happens to have an address > end, so that we don't actually attempt any
more printing).

Whether the given spec is suitable as some-appropriate-spec or one
should just use a fixed one I don't know.


The rest are just random thoughts/ramblings/questions, feel free to ignore.

Can one do some qemu magic to test the no_ptr_secret code path?

> +
> +#ifdef CONFIG_64BIT
> +	hashval = (unsigned int)siphash_1u64((u64)ptr, &ptr_secret);
> +#else
> +	hashval = (unsigned int)siphash_1u32((u32)ptr, &ptr_secret);
> +#endif
> +
> +	spec.field_width = 2 * sizeof(unsigned int);
> +	spec.flags = SMALL;
> +	spec.base = 16;
> +
> +	return number(buf, end, hashval, spec);
> +}

Maybe include SPECIAL in flags? I know that this is just meant to be
mostly-unique identifier and its not really a number, but it's still
weird to see a string of hex digits not preceded by 0x. Also, maybe use
.precision to get zero-padding instead of spaces?

I haven't followed the discussion too closely, but has it been
considered to exempt NULL from hashing?

Rasmus
