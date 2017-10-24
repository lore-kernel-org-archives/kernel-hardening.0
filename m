Date: Wed, 25 Oct 2017 10:57:55 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171024235755.GA15832@eros>
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
> 
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
> 
> I haven't followed the discussion too closely, but has it been
> considered to exempt NULL from hashing?

This comment uncovers a problem with the pointer() functions handling of a NULL pointer
argument.

If we do the %p hashing, 64 bit addresses to 32 bit identifiers, but NULL pointers are printed with
the width based on the size of the pointer then tabular output is likely going to break.

This is likely broken already, even if it has not been noticed because, for example, a MAC address
string is printed as

    xx:xx:xx:xx:xx:xx	(17 characters)

but the NULL version "(null)" has field_width of 16 on 64 bit architectures and 8 on 32 bit architectures.

The code in question is;

static noinline_for_stack
char *pointer(const char *fmt, char *buf, char *end, void *ptr,
	      struct printf_spec spec)
{
	const int default_width = 2 * sizeof(void *);

	if (!ptr && *fmt != 'K') {
		/*
		 * Print (null) with the same width as a pointer so it makes
		 * tabular output look nice.
		 */
		if (spec.field_width == -1)
			spec.field_width = default_width;
		return string(buf, end, "(null)", spec);
	}
....

This check and print "(null)" is at the wrong level of abstraction. If we want tabular output to be
correct for _all_ pointer specifiers then spec.field_width (for NULL) should be set to match whatever
field_width is used in the associated output function. Removing the NULL check above would require
NULL checks adding to at least; 

resource_string()
bitmap_list_string()
bitmap_string()
mac_address_string()
ip4_addr_string()
ip4_addr_string_sa()
ip6_addr_string_sa()
uuid_string()
netdev_bits()
address_val()
dentry_name()
bdev_name()
ptr_to_id()

This is not a trivial change (at least for me) because whatever format is chosen to represent NULL
for each function needs testing.

My question is; Should this be done at all or is it too trivial to matter? And if it should, should
it be done as a separate patch [set], either before or after the %p hashing or should the whole
thing be worked together into a single patch set?


thanks,
Tobin.
