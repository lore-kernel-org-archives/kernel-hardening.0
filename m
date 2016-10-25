Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1477428836.2263.70.camel@cvidal.org>
From: Colin Vidal <colin@cvidal.org>
Date: Tue, 25 Oct 2016 22:53:56 +0200
In-Reply-To: <CAEXv5_jk+2KOxL9UdZ5+6B8+JV2CBtNGi65a7ddtvxwUGmnPkA@mail.gmail.com>
References: <1476959131-6153-1-git-send-email-elena.reshetova@intel.com>
	 <20161020131350.GA18331@thigreal>
	 <CAGXu5jK1MNzM5Qi8o+HHekWm38n-WVPQ1Q3_EPpjYqE0kk8X0w@mail.gmail.com>
	 <20161025090559.eqsll3d7y2ifdaug@thigreal>
	 <1477415895.2263.43.camel@cvidal.org>
	 <CAEXv5_jk+2KOxL9UdZ5+6B8+JV2CBtNGi65a7ddtvxwUGmnPkA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC v2 PATCH 00/13] HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Elena Reshetova <elena.reshetova@intel.com>, David Windsor <dave@progbits.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2016-10-25 at 13:51 -0400, David Windsor wrote:
> On Tue, Oct 25, 2016 at 1:18 PM, Colin Vidal <colin@cvidal.org> wrote:
> > 
> > Hi Kees, Hans,
> > 
> > > 
> > > > 
> > > > > 
> > > > > > 
> > > > > > This series brings the PaX/Grsecurity PAX_REFCOUNT
> > > > > > feature support to the upstream kernel. All credit for the
> > > > > > feature goes to the feature authors.
> > > > > > 
> > > > > > The name of the upstream feature is HARDENED_ATOMIC
> > > > > > and it is configured using CONFIG_HARDENED_ATOMIC and
> > > > > > HAVE_ARCH_HARDENED_ATOMIC.
> > > > > > 
> > > > > > This series only adds x86 support; other architectures are expected
> > > > > > to add similar support gradually.
> > > > > 
> > > > > I have some worries on the generic arch independent implementation of
> > > > > atomic64_t/atomic64_wrap_t (include/asm-generic/atomic64.h). We provide _wrap
> > > > > versions for atomic64, but protection is dependant on arch implementation and
> > > > > config. That is, one could possibly implement HARDENED_ATOMIC support while
> > > > > leaving atomic64_t unprotected depending on specific configs, for instance by
> > > > > then defaulting to CONFIG_GENERIC_ATOMIC64 (in linuc/hardened/atomic.h:676). Or
> > > > > maybe I'm just under-/overthinking this?
> > > > 
> > > > IIUC, ARMv6 builds could have GENERIC_ATOMIC64 and (once implemented)
> > > > HARDENED_ATOMIC, so I think that combination is worth spending time
> > > > on.
> > > 
> > > I'm not completely sure what you mean? Our current patchset doesn't implement
> > > any protections for the generic atomic64, but rather relies on HARDENED_ATOMIC
> > > enabled archs to provide a protected implementation. So currently any
> > > HARDENED_ATOMIC archs cannot depend on GENERIC_ATOMIC64. Does this sound
> > > reasonable?
> > 
> > In the actual situation, you can use a architecture with
> > GENERIC_ATOMIC64 (imx_v6_v7_defconfig on arm for instance), and set
> > CONFIG_HARDENED_ATOMIC=y. That will broke the build. Therefore, we
> > should put a negative dependency between GENERIC_ATOMIC64 and
> > HAVE_ARCH_HARDENED_ATOMIC, in order to be sure that HARDENED_ATOMIC
> > cannot be set when GENERIC_ATOMIC64 is set.
> > 
> 
> This is starting to get out of hand.  I'm reviewing the situation now
> as it relates to local_wrap_t getting defined in certain
> circumstances, but not others, and have found that the dependency
> resolution scheme in HARDENED_ATOMIC is confusing.  I think we need to
> document this somewhere.  If not in-tree, then on this mailing list,
> at least.
> 
> If you have a solid understanding of what types get defined when
> architectural support for CONFIG_HARDENED_ATOMIC is enabled, where
> those types get defined (arch-specific vs. arch-independent code),
> would you mind writing something up here for all of us?  Also, it very
> well could be the case that this is easier than I'm making it out to
> be.  If so, just tell me and I'll go away.

If you have CONFIG_HARDENED_ATOMIC, the type of atomic64_wrap_t is
struct atomic64_wrap_t, otherwise, it is just an alias (compatible) of
atomic64_t.

So, if CONFIG_GENERIC_ATOMIC64 is set, and CONFIG_HARDENED_ATOMIC is
set too, all macro definitions atomic_*_wrap in asm-generic/atomic64.h
will be reduced into atomic_*. But as CONFIG_HARDENED_ATOMIC is set,
the type of argument is atomic64_wrap_t (which is different and
incompatible with atomic64_t in that case). So the compile error is
obvious.

I think (someone else too, Mark if I remember?) that we should never
use "typedef atomic_t atomic_wrap_t" and so on for two main reasons :

- it avoid to mix atomic_t and atomic_wrap_t without error if
CONFIG_HARDENED_ATOMIC is unset

- it make the typing system of atomic_* much more clear: atomic*_wrap_t
is always a different type of atomic_t, and does not depends of a
compile option. Therefore, it would avoid dead-end like asm-
generic/atomic64.h

> > 
> > But it seems wired, or a pity, that HARDENED_ATOMIC is disabled on some
> > architecture just because code implementation issues, no?
> > 
> > > 
> > > > 
> > > > > 
> > > > > My concern is that this is a very easy place to include errors and
> > > > > inconsistencies. We've been trying to cleanly fix this, but haven't really found
> > > > > a satisfactory solution (e.g. one that actually works on different configs/arcs
> > > > > and isn't a horrible mess). I recall that the hardened_atomic ARM implementation
> > > > > already faced issues with atomic64, so this seems to be a real cause for
> > > > > problems. Any suggestions on how to do this more cleanly?
> > > > 
> > > > I haven't looked too closely yet, though maybe Colin will have some
> > > > thoughts as he looks at the ARM port.
> > > 
> > > Ok, that would probably be helpful. It would be good to get this cleanly done
> > > from the start so it doesn't grow increasingly messy with every arch needing to
> > > do incremental fixes/hacks as they get implemented.
> > 
> > Since GENERIC_ATOMIC64 is only on few architecture (arm, metatag,
> > microblaze, sparc, and perhaps mips?), I wonder if it would not be a
> > better idea to drop asm-generic/atomic64.h: it will induces a code
> > duplication, for sure, but avoid the wired situation above.
> > 
> > That said, I don't really understand how asm-generic/atomic64.h works:
> > it defines lot of extern functions (atomic64_add, for instance) and a
> > can't find the implementation in the arch directory (in sparc, for
> > instance)... Some ideas? It could be an interesting workaround: define
> > atomic64_*_wrap prototypes in asm-generic/atomic64.h, and each
> > architecture with GENERIC_ATOMIC64 must implement them.
> > 
> 
> I don't think anyone else understands, either.  It would be great to
> have some documentation of how this all works.

I just found it: lib/atomic64.c. Phew, no magics :-)

Perhaps the cleaner solution would be to define prototypes (of real
functions, not macros) of atomic64_*_wrap functions in asm-
generic/atomic64.h. If the arch has its own implementation of atomic64,
no problems (asm-generic/atomic64.h is not included), and if
CONFIG_GENERIC_ATOMIC64 is set, we just need to implements
atomic64_*_wrap functions (in a arch/lib/atomic64.c, for instance).

Thanks,

Colin
