Date: Wed, 1 Mar 2017 10:43:38 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170301104337.GA28874@leverpostej>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org>
 <1488228186-110679-2-git-send-email-keescook@chromium.org>
 <1488270174.1747.11.camel@gmail.com>
 <CAGXu5jKvY1VRxBk_F9omixEBhaSTE18tfRWNcPUKhFk303v6iw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKvY1VRxBk_F9omixEBhaSTE18tfRWNcPUKhFk303v6iw@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC][PATCH 1/8] Introduce rare_write() infrastructure
To: Kees Cook <keescook@chromium.org>
Cc: Hoeun Ryu <hoeun.ryu@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andy Lutomirski <luto@kernel.org>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, "x86@kernel.org" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Tue, Feb 28, 2017 at 07:05:32AM -0800, Kees Cook wrote:
> On Tue, Feb 28, 2017 at 12:22 AM, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
> > On Mon, 2017-02-27 at 12:42 -0800, Kees Cook wrote:

> >> +/*
> >> + * Build "write rarely" infrastructure for flipping memory r/w
> >> + * on a per-CPU basis.
> >> + */
> >> +#ifndef CONFIG_HAVE_ARCH_RARE_WRITE
> >> +# define __wr_rare
> >> +# define __wr_rare_type
> >> +# define __rare_write_type(v)        typeof(v)
> >> +# define __rare_write_ptr(v) (&(v))
> >> +# define __rare_write(__var, __val)  ({              \
> >> +     __var = __val;                                  \
> >> +     __var;                                          \
> >> +})
> >> +# define rare_write_enable() do { } while (0)
> >> +# define rare_write_disable()        do { } while (0)
> >> +#else
> >> +# define __wr_rare           __ro_after_init
> >> +# define __wr_rare_type              const
> >> +# define __rare_write_type(v)        typeof((typeof(v))0)
> >> +# define __rare_write_ptr(v) ((__rare_write_type(v) *)&(v))
> >
> > Should we make __rare_write_ptr arch-specific so architectures can
> > convert the pointer to rw alias from ro address like this ? [1]
> >
> > #ifndef __arch_rare_write_ptr
> > # define __rare_write_ptr(v)    ((__rare_write_type(v) *)&(v))
> > #else
> > # define __rate_write_ptr(v)    __arch_rare_write_ptr
> > #endif
> 
> I think that was Mark's idea too, but I'm not sure to handle the
> complex cases of doing multiple updates at once (e.g. linked list
> updates, etc). 

Assuming there aren't that many places with complex updates, we could
allow code to explicitly do the map/unmap and use __rare_write_ptr
directly. That does mean that the list code has to be specialised for
__wr_rare, which is less than ideal.

That would also depend on what is __rw_rare in those cases, too.  i.e.
is it just the list_head for the list itself, the list_head of all
elements, or only some of them?

For the latter mixed case, the __rare_write_ptr() approach probably
doesn't work, and that rules out the mm-based approach, too, I guess. :/

> I think we're better doing a full disabling of RO protection, but
> there had been objections to this idea in the past, which is why I
> included the "complex" example, so I don't see a way around it.

My objection to that was that we can't implement CPU-local full
disabling of RO protection for the kernel page tables on some
architectures and configurations, e.g. arm64, or 32-bit arm with LPAE.

The RW alias write_write(var, val) approach only relies on what arches
already have to implement for userspace to work, so if we can figure out
how to make that work API-wise, we can probably implement that
generically with switch_mm() and {get,put}_user().

The only other way I can think to make this work would be to make a copy
of the whole swapper page tables, with the write-rarely data marked RW.
For arm64 at least, that'll be incredibly painful to keep in-sync with
the usual tables, in addition to being very expensive to switch to/from.

Thanks,
Mark.
