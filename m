Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 27 Oct 2016 12:08:43 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161027110742.GD27135@leverpostej>
References: <1476802761-24340-1-git-send-email-colin@cvidal.org>
 <1476802761-24340-3-git-send-email-colin@cvidal.org>
 <20161025091807.GX19531@linaro.org>
 <1477407767.2263.22.camel@cvidal.org>
 <20161026072423.GB19531@linaro.org>
 <1477470016.2263.87.camel@cvidal.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1477470016.2263.87.camel@cvidal.org>
Subject: Re: [kernel-hardening] Re: [RFC 2/2] arm: implementation for
 HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, David Windsor <dave@progbits.org>, Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 26, 2016 at 10:20:16AM +0200, Colin Vidal wrote:
> > My point is that _wrap would be the last suffix of the names of all
> > the functions including _relaxed variants for consistency.
> > 
> > Say, Elena's atomic-long.h defines:
> > ===8<===
> > #define ATOMIC_LONG_ADD_SUB_OP(op, mo, suffix)                          \
> > static inline long                                                      \
> > atomic_long_##op##_return##mo##suffix(long i, atomic_long##suffix##_t *l)\
> > {                                                                       \
> >         ATOMIC_LONG_PFX(suffix##_t) *v = (ATOMIC_LONG_PFX(suffix##_t) *)l;\
> >                                                                         \
> >         return (long)ATOMIC_LONG_PFX(_##op##_return##mo##suffix)(i, v);\
> > }
> > ATOMIC_LONG_ADD_SUB_OP(add,,)
> > ATOMIC_LONG_ADD_SUB_OP(add, _relaxed,)
> >   ...
> > #ifdef CONFIG_HARDENED_ATOMIC
> > ATOMIC_LONG_ADD_SUB_OP(add,,_wrap)
> >   ...
> > ===>8===
> > 
> > It would naturally lead to "atomic_long_add_relaxed_wrap" although
> > this function is not actually defined here.
> > 
> 
> I understand your point, and the need of consistency. "_wrap" is
> appended to any "user" function of the atomic system, and it is
> mandatory to have a consistant name for it, I fully agree.
> 
> However, in the internal implementation of atomic, "_relaxed" is
> appended to any function that will be bounded by memory barriers.
> Therefore, a name like "atomic_add_return_wrap_relaxed" makes it easy
> to see that this function will be embedded in another one. On the other
> hand "atomic_add_return_relaxed_wrap" is less clear, since it suggest
> that is a "user" function. I would involve a kind on inconsistency on
> the naming of relaxed functions.
> 
> That said, I really don't know which is the "best" naming... :-)

Given it looks like there's at least one necessary round of bikeshedding, it
would be best to discuss this with the usual atomic maintainers included, so as
to avoid several more rounds over subsequent postings. i.e.

[mark@leverpostej:~/src/linux]% ./scripts/get_maintainer.pl -f \
	include/asm-generic/atomic.h \
	include/asm-generic/atomic-long.h \
	include/linux/atomic.h
Arnd Bergmann <arnd@arndb.de> (maintainer:GENERIC INCLUDE/ASM HEADER FILES)
Ingo Molnar <mingo@kernel.org> (commit_signer:8/11=73%)
Peter Zijlstra <peterz@infradead.org> (commit_signer:6/11=55%,authored:5/11=45%,added_lines:491/671=73%,removed_lines:186/225=83%)
Frederic Weisbecker <fweisbec@gmail.com> (commit_signer:3/11=27%,authored:3/11=27%,added_lines:42/671=6%,removed_lines:21/225=9%)
Boqun Feng <boqun.feng@gmail.com> (commit_signer:1/11=9%,authored:1/11=9%)
Chris Metcalf <cmetcalf@ezchip.com> (commit_signer:1/11=9%)
Davidlohr Bueso <dave@stgolabs.net> (authored:1/11=9%,added_lines:128/671=19%)
linux-arch@vger.kernel.org (open list:GENERIC INCLUDE/ASM HEADER FILES)
linux-kernel@vger.kernel.org (open list)

Thanks,
Mark.
