Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 25 Oct 2016 12:05:59 +0300
From: Hans Liljestrand <ishkamiel@gmail.com>
Message-ID: <20161025090559.eqsll3d7y2ifdaug@thigreal>
References: <1476959131-6153-1-git-send-email-elena.reshetova@intel.com>
 <20161020131350.GA18331@thigreal>
 <CAGXu5jK1MNzM5Qi8o+HHekWm38n-WVPQ1Q3_EPpjYqE0kk8X0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jK1MNzM5Qi8o+HHekWm38n-WVPQ1Q3_EPpjYqE0kk8X0w@mail.gmail.com>
Subject: Re: [kernel-hardening] [RFC v2 PATCH 00/13] HARDENED_ATOMIC
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 24, 2016 at 03:38:23PM -0700, Kees Cook wrote:
> On Thu, Oct 20, 2016 at 6:13 AM, Hans Liljestrand <ishkamiel@gmail.com> wrote:
> > On Thu, Oct 20, 2016 at 01:25:18PM +0300, Elena Reshetova wrote:
> >> Changes since RFC v1:
> >>
> >>  - documentation added: Documentation/security/hardened-atomic.txt
> >>  - percpu-refcount diversion from PaX/Grsecurity explained better
> >>  - arch. independent base has full functional coverage for atomic,
> >>    atomic-long and atomic64 types.
> >>  - arch. independent base is better structured and organized
> >>  - lkdtm: tests are now defined using macros
> >>  - x86 implementation added for missing functions
> >>  - fixed trap handling on x86 and overall reporting
> >>  - many small polishing and fixes
> >>
> >> Open items:
> >>
> >>  - performance measurements: we are still waiting for numbers
> >>  - arch. independent implementation doesn't have coverage for
> >>    local_wrap_t type in cases when include/asm-generic/local.h
> >>    is not used (meaning architecture does provide its implementation
> >>    but does not yet provide *_wrap functions). We haven't yet
> >>    find a nice way of doing it in arch. independent definitions,
> >>    since some kernel code includes asm/local.h directly and we
> >>    are not sure where to place new definitions (new file under
> >>    inlcude/linux/local_wrap.h (to be inline with include/linux/
> >>    atomic.h) + definition of local_wrap_t to include/linux/types.h?)
> >>    Ideas and suggestions on this are very warlmy welcomed!
> >>
> >> Compilation and testing results:
> >>
> >>  - CONFIG_HARDENED_ATOMIC=y, arch=x86_64 or x86_32, full x86 coverage implementation: compiles, lkdtm atomic tests PASS
> >>  - CONFIG_HARDENED_ATOMIC=n, arch=x86_64 or x86_32, full x86 coverage implementation: compiles, feature not enabled, so tests not run
> >>  - CONFIG_HARDENED_ATOMIC=n, arch=x86_64 or x86_32, with x86 hardening implementation removed
> >>    (simulate not implemented for arch. case): compile does not yet pass due to issues with local_wrap_t decribed above
> >
> > As noted our current implementation fails on local_t without arch support (at
> > least in kernel/trace/ring_buffer.c where local_wrap_t is used). It seems that
> > local_t is almost never used, which is also what the related documentation
> > recommends (at Documentation/local_ops.txt). I would be inclined to drop local_t
> > support and switch the generic implementation to use atomic_long_wrap_t instead
> > of atomic_long_t.
> >
> > So my question is then, do we actually want to provide a protected version of
> > local_t, or can we just drop this support?
> 
> What is the combination of arch/CONFIG that causes local_t to fail?
> I'd prefer to retain coverage, but I don't quite understand where the
> problem is. It sounds like this is a header file issue? Should local.h
> get moved under asm-generic?

I'm not sure whether CONFIG matters, but essentially any arch with specific
local_t, but without HARDENED_ATOMIC support. So the errors can be produced on
x86 by including our patches without the x86 implementation. This produces
errors in kernel/trace/ring_buffer.c uses local_wrap_t that uses local_wrap_t.

What I think happens is that we provide the local_*wrap defines in
include/asm-generic/local.h, but the unpatched x86 local_h implementation
replaces that, and we're therefore left without the wrap version. So yes, I
think it's to do with how the headers get included, but I'm not sure how to fix
it.

> 
> >> This series brings the PaX/Grsecurity PAX_REFCOUNT
> >> feature support to the upstream kernel. All credit for the
> >> feature goes to the feature authors.
> >>
> >> The name of the upstream feature is HARDENED_ATOMIC
> >> and it is configured using CONFIG_HARDENED_ATOMIC and
> >> HAVE_ARCH_HARDENED_ATOMIC.
> >>
> >> This series only adds x86 support; other architectures are expected
> >> to add similar support gradually.
> >
> > I have some worries on the generic arch independent implementation of
> > atomic64_t/atomic64_wrap_t (include/asm-generic/atomic64.h). We provide _wrap
> > versions for atomic64, but protection is dependant on arch implementation and
> > config. That is, one could possibly implement HARDENED_ATOMIC support while
> > leaving atomic64_t unprotected depending on specific configs, for instance by
> > then defaulting to CONFIG_GENERIC_ATOMIC64 (in linuc/hardened/atomic.h:676). Or
> > maybe I'm just under-/overthinking this?
> 
> IIUC, ARMv6 builds could have GENERIC_ATOMIC64 and (once implemented)
> HARDENED_ATOMIC, so I think that combination is worth spending time
> on.

I'm not completely sure what you mean? Our current patchset doesn't implement
any protections for the generic atomic64, but rather relies on HARDENED_ATOMIC
enabled archs to provide a protected implementation. So currently any
HARDENED_ATOMIC archs cannot depend on GENERIC_ATOMIC64. Does this sound
reasonable?

> 
> > My concern is that this is a very easy place to include errors and
> > inconsistencies. We've been trying to cleanly fix this, but haven't really found
> > a satisfactory solution (e.g. one that actually works on different configs/arcs
> > and isn't a horrible mess). I recall that the hardened_atomic ARM implementation
> > already faced issues with atomic64, so this seems to be a real cause for
> > problems. Any suggestions on how to do this more cleanly?
> 
> I haven't looked too closely yet, though maybe Colin will have some
> thoughts as he looks at the ARM port.

Ok, that would probably be helpful. It would be good to get this cleanly done
from the start so it doesn't grow increasingly messy with every arch needing to
do incremental fixes/hacks as they get implemented.

> 
> > In contrast to local_t issue, atomic64_t is in fact directly used in several
> > places, including some that we patch to use atomic64_wrap_t. The atomic_(long)_t
> > implementation is also possibly intertwined with atomic64_t, so I doubt just
> > dropping bare atomic64_t protections is a viable solution.
> 
> Agreed.
> 
> > On that note, our lkdtm test are still lacking atomic64 tests, which would
> > probably be good idea to add.
> 
> Agreed, I'd like as much coverage as possible (especially if we have
> some fragile combinations).

Yes, we will get those added.

Best Regards,
-hans liljestrand
