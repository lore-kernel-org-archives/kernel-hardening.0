Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 18 Nov 2016 11:10:59 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161118111059.GA1197@leverpostej>
References: <CAAseMr6Fae=4otZZX9HmO1YgehjsVmd+44G5RN7Wu8iF2+fruA@mail.gmail.com>
 <20161116151611.GD11228@leverpostej>
 <CAGXu5jJ1LwLJ-f1Fx=Mu278-eeeqC+JakrH_WPT99PcHTXzbpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ1LwLJ-f1Fx=Mu278-eeeqC+JakrH_WPT99PcHTXzbpA@mail.gmail.com>
Subject: Re: [kernel-hardening] patches for __write_rarely section
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 17, 2016 at 03:47:31PM -0800, Kees Cook wrote:
> On Wed, Nov 16, 2016 at 7:16 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Wed, Nov 16, 2016 at 10:39:38PM +0800, Gengjia Chen wrote:

> +               pax_open_kernel();
> +               const_cast(cdo->generic_packet) = cdrom_dummy_generic_packet;
> +               pax_close_kernel();

> > I've mentioned this elsewhere, but I don't think {open,close}_kernel()
> > works as an interface. Specifically, I don't believe it can be safely
> > and efficiently implemented for arm with LPAE, nor arm64.
> 
> I've seen similar objections from x86 maintainers.
> 
> > To cater for those it may be possible to use a temporary RW mapping
> > separate from the usual kernel mapping (e.g. in TTBR0 on arm64). It
> > should be possible to have an API that can use either approach, if
> > writers are suitable annotated.
> 
> Do you mean something besides a new fixmap?

Yes.

I think i mentioned this in passing at LSS. For arm64, my idea was to
have the RW mapping in its own mm, using the processes/idmap address
area. That way it will only be mapped per-thread as required. Other
architectures without something like domains should be able to do
something similar.

I believe the only additional part we need for that is something to
convert a pointer to its RW alias. See below for an example.

We already do both of these things on arm64 in other cases, e.g. for
temporarily mapping EFI runtime services, switching TTBR1 safely.

> As for annotation, this was something that came up during Kernel
> Summit too. It'd be nice to have a type-checked function of some kind
> that could be used. Maybe something like this (using the cdrom example
> above):
> 
>    rare_write(cdo, generic_packet, cdrom_dummy_generic_packet);

Something like that should be possible. Though I'd expect just var and
val as arguments, e.g.

	rare_write(cdo->generic_packet, cdrom_dummy_generic_packet);

With something like the below (assuming all helpers are inlined):

#define rare_write(__var, __val) ({				\
	typeof(var) *__rw_var;					\
	__some_typecheck_perhaps(__var, __val);			\
								\
	__rw_var = __rare_rw_ptr(&(__var));			\
								\
	__rare_rw_map();					\
	*__rw_var = (__val);					\
	__rare_rw_unmap();					\
								\
	__clobber_var_so_gcc_knows(__var);			\
})

... which should work in the case of a separate mapping, or
finer-grained per-thread permission controls (e.g. ARM domains, x86
pkeys).

... and the trivial case is simple enough:

#if !IS_ENABLED(WHATEVER_THIS_IS_CALLED)
#define __rare_rw_ptr(__p)	__p
#define __rare_rw_map()
#define __rare_rw_unmap()
#endif

Thanks,
Mark.
