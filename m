Date: Wed, 25 Apr 2018 10:59:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch V3 01/10] rslib: Add GFP aware init function
In-Reply-To: <CAGXu5jLUgNGW-SXY3L2fJrBV3PpmAH9uXFV87xmPe14BrYnWMw@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1804251059100.2082@nanos.tec.linutronix.de>
References: <20180422162345.004292133@linutronix.de> <20180422162512.363154748@linutronix.de> <20180425111617.2f4dc127@canb.auug.org.au> <CAGXu5jLUgNGW-SXY3L2fJrBV3PpmAH9uXFV87xmPe14BrYnWMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Kees Cook <keescook@chromium.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, LKML <linux-kernel@vger.kernel.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, Neil Brown <neilb@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 24 Apr 2018, Kees Cook wrote:
> On Tue, Apr 24, 2018 at 6:16 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > On Sun, 22 Apr 2018 18:23:46 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> >> +static inline struct rs_control *init_rs(int symsize, int gfpoly, int fcr,
> >> +                                      int prim, int nroots)
> >> +{
> >> +     return init_rs_gfp(symsize, gfpoly, fcr, prim, nroots, GFP_KERNEL);
> >> +}
> >> +
> >
> > The version of this patch that Kees has committed to his kspp tree in linux-next has
> >
> > #include <linux/slab.h>
> >
> > why not just
> >
> > #include <linux/types.h>        /* for gpf_t */
> > #include <linux/gpf.h>          /* for GFP_KERNEL */
> >
> > ?

Sure

> We could certainly switch to that. (Why doesn't gfp.h include types.h?)

Excellent question.

Thanks,

	tglx
