Date: Wed, 25 Oct 2017 08:52:48 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171024215248.GJ1429@eros>
References: <1508798008-1692-1-git-send-email-me@tobin.cc>
 <87bmkw5owv.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bmkw5owv.fsf@rasmusvillemoes.dk>
Subject: [kernel-hardening] Re: [PATCH v7] printk: hash addresses printed with %p
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 24, 2017 at 09:25:20PM +0200, Rasmus Villemoes wrote:
> On Tue, Oct 24 2017, "Tobin C. Harding" <me@tobin.cc> wrote:
> 
> > +
> > +/* Maps a pointer to a 32 bit unique identifier. */
> > +static char *ptr_to_id(char *buf, char *end, void *ptr, struct printf_spec spec)
> > +{
> > +	unsigned int hashval;
> > +
> > +	if (static_branch_unlikely(&no_ptr_secret))
> > +		return "(pointer value)";
> 
> Eh, you probably meant to call
> 
>   string(buf, end, "(pointer value)", some-appropriate-spec)

Good catch, thanks.

> otherwise this will either crash very soon (when the following output
> wants to overwrite that '(' in .rodata), or at the very least cause a
> completely bogus eventual return value (if the "(pointer value)" string
> happens to have an address > end, so that we don't actually attempt any
> more printing).
> 
> Whether the given spec is suitable as some-appropriate-spec or one
> should just use a fixed one I don't know.
> 
> 
> The rest are just random thoughts/ramblings/questions, feel free to ignore.
> 
> Can one do some qemu magic to test the no_ptr_secret code path?
> 
> > +
> > +#ifdef CONFIG_64BIT
> > +	hashval = (unsigned int)siphash_1u64((u64)ptr, &ptr_secret);
> > +#else
> > +	hashval = (unsigned int)siphash_1u32((u32)ptr, &ptr_secret);
> > +#endif
> > +
> > +	spec.field_width = 2 * sizeof(unsigned int);
> > +	spec.flags = SMALL;
> > +	spec.base = 16;
> > +
> > +	return number(buf, end, hashval, spec);
> > +}
> 
> Maybe include SPECIAL in flags? I know that this is just meant to be
> mostly-unique identifier and its not really a number, but it's still
> weird to see a string of hex digits not preceded by 0x. Also, maybe use
> .precision to get zero-padding instead of spaces?

Perhaps we should be using special_hex_number() instead of number().

        return special_hex_number(buf, end, hashval, sizeof(unsigned int));

In reply to a previous version of this patch

 [PATCH v5] printk: hash addresses printed with %p

Kees Cook wrote

    > +       spec.field_width = 2 + 2 * sizeof(unsigned int); /* 0x + hex */
    > +       spec.flags = SPECIAL | SMALL | ZEROPAD;
    
    I don't think this should have SPECIAL. We end up changing things like
    kallsyms (which didn't have 0x before) and printing with double 0x's:
    
            seq_printf(m, " 0x%pK", mod->core_layout.base);
    ...
    # cat /proc/modules
    test_module 16384 0 - Live 0x0xdf81cfb6
    
This was true of that version because of a bug in the implementation (later pointed out by Kees). So
now we don't break kallsyms if we use special_hex_number (implying SPECIAL) since output using %pK
is unchanged by this patch. We do however break approximately 1867 call sites that make calls like
this; 

	printf("0x%p", some_pointer);

This whole effort is based on the fact that usage of %p is broken already, it would seem that adding
formatting to the print string is even more broken (since that is what the spec is for).

Since we have already agreed that it's worth breaking all the %p call sites, then the extra breakage
of having a bunch of '0x0x' outputs to fix does not seem too much of an added burden. We are going
to potentially have to look at all the %p call sites anyways, why not start with the '0x0x' subset.

> I haven't followed the discussion too closely, but has it been
> considered to exempt NULL from hashing?

Another good thought, thanks Rasmus!


thanks,
Tobin.
