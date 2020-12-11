Return-Path: <SRS0=hhCK=FP=lists.openwall.com=kernel-hardening-return-20581-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4385BC433FE
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 17:46:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 514CF22D06
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 17:46:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 514CF22D06
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20581-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1248 invoked by uid 550); 11 Dec 2020 17:46:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1216 invoked from network); 11 Dec 2020 17:46:32 -0000
Date: Fri, 11 Dec 2020 17:46:16 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Szabolcs Nagy <szabolcs.nagy@arm.com>
Cc: libc-alpha@sourceware.org, Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
	Jeremy Linton <jeremy.linton@arm.com>,
	Mark Brown <broonie@kernel.org>,
	kernel-hardening@lists.openwall.com,
	Topi Miettinen <toiwoton@gmail.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/6] aarch64: avoid mprotect(PROT_BTI|PROT_EXEC) [BZ
 #26831]
Message-ID: <20201211174615.GB17458@gaia>
References: <cover.1606319495.git.szabolcs.nagy@arm.com>
 <20201203173006.GH2830@gaia>
 <20201207200338.GB24625@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207200338.GB24625@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Dec 07, 2020 at 08:03:38PM +0000, Szabolcs Nagy wrote:
> The 12/03/2020 17:30, Catalin Marinas wrote:
> > On Fri, Nov 27, 2020 at 01:19:16PM +0000, Szabolcs Nagy wrote:
> > > This is v2 of
> > > https://sourceware.org/pipermail/libc-alpha/2020-November/119305.html
> > > 
> > > To enable BTI support, re-mmap executable segments instead of
> > > mprotecting them in case mprotect is seccomp filtered.
> > > 
> > > I would like linux to change to map the main exe with PROT_BTI when
> > > that is marked as BTI compatible. From the linux side i heard the
> > > following concerns about this:
> > > - it's an ABI change so requires some ABI bump. (this is fine with
> > >   me, i think glibc does not care about backward compat as nothing
> > >   can reasonably rely on the current behaviour, but if we have a
> > >   new bit in auxv or similar then we can save one mprotect call.)
> > 
> > I'm not concerned about the ABI change but there are workarounds like a
> > new auxv bit.
> > 
> > > - in case we discover compatibility issues with user binaries it's
> > >   better if userspace can easily disable BTI (e.g. removing the
> > >   mprotect based on some env var, but if kernel adds PROT_BTI and
> > >   mprotect is filtered then we have no reliable way to remove that
> > >   from executables. this problem already exists for static linked
> > >   exes, although admittedly those are less of a compat concern.)
> > 
> > This is our main concern. For static binaries, the linker could detect,
> > in theory, potential issues when linking and not set the corresponding
> > ELF information.
> > 
> > At runtime, a dynamic linker could detect issues and avoid enabling BTI.
> > In both cases, it's a (static or dynamic) linker decision that belongs
> > in user-space.
> 
> note that the marking is tied to an elf module: if the static
> linker can be trusted to produce correct marking then both the
> static and dynamic linking cases work, otherwise neither works.
> (the dynamic linker cannot detect bti issues, just apply user
> supplied policy.)

My assumption is that the dynamic linker may become smarter and detect
BTI issues, if necessary.

Let's say we link together multiple objects, some of them with BTI
instructions, others without. Does the static linker generate a
.note.gnu.property section with GNU_PROPERTY_AARCH64_FEATURE_1_BTI? I
guess not, otherwise the .text section would have a mixture of functions
with and without landing pads.

In the dynamic linker case, if there are multiple shared objects where
some are missing BTI, I guess the dynamic linker currently invokes
mprotect(PROT_BTI) (or mmap()) on all objects with the corresponding
GNU_PROPERTY.

While I don't immediately see an issue with the dynamic loader always
turning on PROT_BTI based solely on the shared object it is linking in,
the static linker takes a more conservative approach. The dynamic linker
may not have a similar choice in the future if the kernel forced
PROT_BTI on the main executable. In both cases it was a user choice.

The dynamic loader itself is statically linked, so any potential
mismatch would have been detected at build time and the corresponding
GNU_PROPERTY unset.

> 1) if we consider bti part of the semantics of a marked module
> then it should be always on if the system supports it and
> ideally the loader of the module should deal with PROT_BTI.
> (and if the marking is wrong then the binary is wrong.)
> 
> 2) if we consider the marking to be a compatibility indicator
> and let userspace policy to decide what to do with it then the
> static exe and vdso cases should be handled by that policy too.

For static exe, we assume that the compatibility was checked at link
time. However, you are right on the vdso, we always turn BTI on. So it
can indeed be argued that the kernel already made the decision for (some
of) the user modules.

> (this makes sense if we expect that there are reasons to turn
> bti off for a process independently of markings. this requires
> the static linking startup code to do the policy decision and
> self-apply PROT_BTI early.)

We currently left this policy decision to the dynamic loader (mostly,
apart from vdso).

> the current code does not fit either case well, but i was
> planning to do (1). and ideally PROT_BTI would be added
> reliably, but a best effort only PROT_BTI works too, however
> it limits our ability to report real mprotect failures.

If we (kernel people) agree to set PROT_BTI on for the main executable,
we can expose a bit (in AT_FLAGS or somewhere) to tell the dynamic
loader that PROT_BTI is already on. I presume subsequent objects will be
mapped with mmap().

> > > - ideally PROT_BTI would be added via a new syscall that does not
> > >   interfere with PROT_EXEC filtering. (this does not conflict with
> > >   the current patches: even with a new syscall we need a fallback.)
> > 
> > This can be discussed as a long term solution.
> > 
> > > - solve it in systemd (e.g. turn off the filter, use better filter):
> > >   i would prefer not to have aarch64 (or BTI) specific policy in
> > >   user code. and there was no satisfying way to do this portably.
> > 
> > I agree. I think the best for now (as a back-portable glibc fix) is to
> > ignore the mprotect(PROT_EXEC|PROT_BTI) error that the dynamic loader
> > gets. BTI will be disabled if MDWX is enabled.
> 
> ok.
> 
> we got back to the original proposal: silently ignore mprotect
> failures. i'm still considering the mmap solution for libraries
> only: at least then libraries are handled reliably on current
> setups, but i will have to think about whether attack targets
> are mainly in libraries like libc or in executables.

I think ignoring the mprotect() error is the best we can do now. If we
add a kernel patch to turn PROT_BTI on together with an AT_FLAGS bit,
the user mprotect() would no longer be necessary.

In the absence of an AT_FLAGS bit, we could add PROT_BTI on the main exe
and backport the fix to when we first added BTI support. This way the
dynamic loader may just ignore the mprotect() altogether on the main
exe, assuming that people run latest stable kernels.

> > In the meantime, we should start (continue) looking at a solution that
> > works for both systemd and the kernel and be generic enough for other
> > architectures. The stateless nature of the current SECCOMP approach is
> > not suitable for this W^X policy. Kees had some suggestions here but the
> > thread seems to have died:
> >
> > https://lore.kernel.org/kernel-hardening/202010221256.A4F95FD11@keescook/
> 
> it sounded like better W^X enforcement won't happen any time soon.

Unfortunately, I think you are right here.

Anyway, looking for any other input from the kernel and systemd people.
If not, I'll post a patch at 5.11-rc1 turning PROT_BTI on for the main
exe and take it from there. I think such discussion shouldn't disrupt
the glibc fixes/improvements.

-- 
Catalin
