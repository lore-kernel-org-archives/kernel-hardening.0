Return-Path: <SRS0=kj6v=PJ=lists.openwall.com=kernel-hardening-return-21447-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 496F5C433EF
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 Oct 2021 00:30:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1A5FA60FF2
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 Oct 2021 00:30:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1A5FA60FF2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 28243 invoked by uid 550); 21 Oct 2021 00:30:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28210 invoked from network); 21 Oct 2021 00:30:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2+Cq1lLQXgVDQ845LTf3M22d1RkxoMhQhxMEK+UBsDM=;
        b=dbbp+eh6j6YwAfRzFrBO+P3WFg77d/06lYsfVz2bZbD7FPBMmZQ328rYqkQ3vk6XZn
         Ffo9DE+EbKOlPFfJzFPg2yJQlC9HOpV7QQUTygGzQjkQ0xET1de3DYrMOCiX3HSFzNTD
         4/AJhO6Zt3tm3Le47FlIrPSwBiamFsOWeyiIc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2+Cq1lLQXgVDQ845LTf3M22d1RkxoMhQhxMEK+UBsDM=;
        b=vXZRXxgAgEN5VPqipzs+5E0px5Aa7EAccQ8M3smLz5BvSzAJPOHwYOzTv35H2aAPA+
         ptPSSPTEA14Eb+f0yzweaJ0DVa8dwP0kgkAPNrmhargiIW9SOGmMhYJXWj+TifM221jz
         wiHSwinWebiQwGgPPuwMQQ/T0+r5sWpKSOR3xRL1C6FmgeBGj49iR1WDih6nHzoI52GR
         MOnQo6idY1FQ+cKtSEUGWjD9JvNL4JdW0kX0kA5EoYMt7D2XznPOMByU7QnM0f/BYEhu
         bcaFRGRHCUn49ZTcsjiEmEMxw+BstyiJEXK2pCl8qtm8uSGDDilpyDr81571remJNvlQ
         2MHQ==
X-Gm-Message-State: AOAM533uzqeMo8SqBORWgaO0LGacD8oVH+ZFlWr52XLDeucLNLjPTZR8
	GKEUdns4XFJgjTv1UoGEgEE2xQ==
X-Google-Smtp-Source: ABdhPJw3T10phFg9/dQG7ZbsyMouE2czYkdfSMNdDyCXMvw2AjXBIB49BYXr1YrccP9g8dTFS/fmrA==
X-Received: by 2002:a05:6a00:1142:b0:44d:d43a:ac5d with SMTP id b2-20020a056a00114200b0044dd43aac5dmr2101125pfm.30.1634776193200;
        Wed, 20 Oct 2021 17:29:53 -0700 (PDT)
Date: Wed, 20 Oct 2021 17:29:51 -0700
From: Kees Cook <keescook@chromium.org>
To: Jann Horn <jannh@google.com>
Cc: kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org
Subject: Re: An analysis of current and potential security mitigations based
 on a TIOCSPGRP exploit
Message-ID: <202110201527.743EEC05@keescook>
References: <616f01f5.1c69fb81.68920.23b8@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <616f01f5.1c69fb81.68920.23b8@mx.google.com>

Hi Jann!

On Tue, Oct 19, 2021 at 07:35:49PM +0200, jannh@google.com wrote:
> [...] I also want to thank Kees
> Cook (https://twitter.com/kees_cook) for providing feedback on an earlier
> version of this post (again, without implying that he necessarily agrees with
> everything), [...]

Thanks for sending this! It's going to make a great reference to aim
people at to help them understand why (and how) data-only attacks can
be so tricky to deal with. :)

I'll reply to the bits I'd commented on before with your earlier drafts,
now that it's published...

> Attack stage: Freeing the object's page to the page allocator
> [...]
> Attack stage: Reallocating the victim page as a pagetable
> [...]
> Note that nothing in this whole exploit requires us to leak any kernel-virtual
> or physical addresses, partly because we have an increment primitive instead of
> a plain write; and it also doesn't involve directly influencing the instruction
> pointer.

Yup, it's a really nice walk-through on how to get deterministic control
over the allocations. The idea of quarantines came up before[1], and you
quickly showed how to defeat them. I wonder if there might still be a
solution near this idea, though. Gaining type-awareness and (as you'd
suggested before) pinning kernel address regions into specific types of
allocation (as you discuss later) seems promising.

> [...]
> Still, in practice, I believe that attack surface reduction mechanisms
> (especially seccomp) are currently some of the most important defense
> mechanisms on Linux.

We agree fully on this. :) I think MAC (e.g. SELinux) has a role here as
well; Android (which uses both) has shown very clearly how reachability
becomes a determining factor in limiting exploitation.

> Against bugs in source code: Compile-time locking validation
> [...]
> The one big downside is that this requires getting the development community
> for the codebase on board with the idea of backfilling and maintaining such
> annotations. And someone has to write the analysis tooling that can verify the
> annotations.

True, but this seems like a reasonable project -- all the things that
improve robustness have non-security benefits too. :)

> Against exploit primitives: Attack primitive reduction via syscall restrictions
> -------------------------------------------------------------------------------
> (Yes, I made up that name because I thought that capturing this under "Attack
> surface reduction" is too muddy.)

I don't think it needs to be limited to just "syscall restrictions".

> [...]
> Attack primitive reduction limits access to code that is suspected or known to
> provide (sometimes very specific) exploitation primitives. For example, one
> might decide to specifically forbid access to FUSE and userfaultfd for most
> code because of their utility for kernel exploitation, and, if one of those
> interfaces is truly needed, design a workaround that avoids exposing the attack
> primitive to userspace. This is different from attack surface reduction, where
> it often makes sense to permit access to any feature that a legitimate workload
> wants to use.

Agreed -- there are even things in the kernel that aren't exposed at all
to userspace that make attacks easier, and there's no reason to keep
them around. (e.g. the refactoring of struct_timer.) As I discuss later,
I think CFI falls into this category -- it tries to plug a C compiler
weakness, in the sense that current machine code cares not at all about
function prototypes. And while this doesn't matter for normally running
the code, it DOES matter when someone is trying to abuse the results.

> A nice example of an attack primitive reduction is the sysctl
> `vm.unprivileged_userfaultfd`, which was first introduced
> (https://git.kernel.org/linus/cefdca0a86be) so that userfaultfd can
> be made completely inaccessible to normal users and was then later
> adjusted(https://git.kernel.org/linus/d0d4730ac2e4) so that users can be
> granted access to part of its functionality without gaining the dangerous
> attack primitive.  (But if you can create unprivileged user namespaces, you
> can still use FUSE to get an equivalent effect.)

Right, and given further tightening, FUSE could go away too. Or maybe a
system isn't built with FUSE at all. Narrowing the scope will have a
meaningful impact on some subset of systems.

> Against oops-based oracles: Lockout or panic on crash
> [...]
> that. On the other hand, if some service crashes on a desktop system, perhaps
> that shouldn't cause the whole system to immediately go down and make you lose
> unsaved state - so `panic_on_oops` might be too drastic there.
> 
> A good solution to this might require a more fine-grained approach. [...]

I agree. This is a place where Linus's opinions are very strong[2], which
makes feature creation a bit of a minefield. :( I am open to ideas, and
would love to see things explored. There were some alternative approach
taken in the recent brute-force-defense series[3] and the proposed
pkill_on_warn patch[4].

> Against UAF access: Deterministic UAF mitigation
> [...]
> In my opinion, this demonstrates that while UAF mitigations do have a lot of
> value (and would have reliably prevented exploitation of this specific bug),
> **a use-after-free is just one possible consequence of the symptom class
> "object state confusion"** (which may or may not be the same as the bug class
> of the root cause). It would be even better to enforce rules on object states,
> and ensure that an object e.g. can't be accessed through a "refcounted"
> reference anymore after the refcount has reached zero and has logically
> transitioned into a state like "non-RCU members are exclusively owned by thread
> performing teardown" or "RCU callback pending, non-RCU members are
> uninitialized" or "exclusive access to RCU-protected members granted to thread
> performing teardown, other members are uninitialized". Of course, doing this as
> a runtime mitigation would be even costlier and messier than a reliable UAF
> mitigation; this level of protection is probably only realistic with at least
> some level of annotations and static validation.

I think that hardware memory tagging (e.g. ARM's MTE) will have a
big impact in this area. I remain nervous about there being enough bits
to provide sufficiently versioned access to memory, but I think clever
application of tagging can keep out the worst of the confusions.

> Against UAF access: Probabilistic UAF mitigation; pointer leaks
> [...]
> In both these cases, explicitly stripping tag bits would be an acceptable
> workaround because a pointer without tag bits still uniquely identifies a
> memory location; and given that these are very special interfaces that
> intentionally expose some degree of information about kernel pointers to
> userspace, it would be reasonable to adjust this code manually.

Please send a patch for this. :) (But seriously, any paths in the kernel
where tags should be cleared but aren't need to be fixed.)

> A somewhat more interesting example is the behavior of this piece of userspace
> code:
> [...]
> So the values we're seeing have been ordered based on the virtual address of
> the corresponding `struct file`; and SLUB allocates `struct file` from order-1
> [...]
> With that knowledge, we can transform those numbers a bit, to show the order in
> which objects were allocated inside each page (excluding pages for which we
> haven't seen all allocations):
> [...]
> And these sequences are almost the same, except that they have been rotated
> around by different amounts. This is exactly the SLUB freelist randomization
> scheme, as introduced in commit 210e7a43fa905
> (https://git.kernel.org/linus/210e7a43fa905)!
> [...]
> So in summary, we can bypass SLUB randomization for the slab from which `struct
> file` is allocated because someone used it as a lookup key in a specific type
> of data structure. This is already fairly undesirable if SLUB randomization is
> supposed to provide protection against some types of local attacks for all
> slabs.
> [...]
> If we introduce a probabilistic use-after-free mitigation that relies on
> attackers not being able to learn whether the uppermost bits of an object's
> address changed after it was reallocated, this data structure could also break
> that. This case is messier than things like `kcmp()` because here the address
> ordering leak stems from a standard data structure.

This is just horribly beautiful. I reminds me of[5], which shows how
/proc directory entries are stored in string length order. I have no
idea what the best approach to sanitizing this is going to be...

> Control Flow Integrity
> ----------------------
> **I want to explicitly point out that kernel Control Flow Integrity would have
> had no impact at all on this exploit strategy**. By using a data-only strategy,
> we avoid having to leak addresses, avoid having to find ROP gadgets for a
> specific kernel build, and are completely unaffected by any defenses that
> attempt to protect kernel code or kernel control flow. Things like getting
> access to arbitrary files, increasing the privileges of a process, and so on
> don't require kernel instruction pointer control.
> 
> 
> Like in my last blogpost on Linux kernel exploitation
> (https://googleprojectzero.blogspot.com/2020/02/mitigations-are-attack-surface-too.html)
> (which was about a buggy subsystem that an Android vendor added to their
> downstream kernel), to me, a data-only approach to exploitation feels very
> natural and seems less messy than trying to hijack control flow anyway.
> 
> 
> Maybe things are different for userspace code; but for attacks by userspace
> against the kernel, I don't currently see a lot of utility in CFI because it
> typically only affects one of many possible methods for exploiting a bug.
> (Although of course there could be specific cases where a bug can only be
> exploited by hijacking control flow, e.g. if a type confusion only permits
> overwriting a function pointer and none of the permitted callees make
> assumptions about input types or privileges that could be broken by changing
> the function pointer.)

I agree that CFI tends to be quite "late" in many attack scenarios,
but I think we don't agree on the value proposition. :) To use your
earlier terms, I view CFI as an "attack primitive reduction" method.

While it would be great to have a distinct way to just block the root
cause of flaws, it's not always possible to cover everything, so there
is a benefit it adding "attack primitive reduction" features. And, FWIW,
I think the kernel continues to take meaningful steps to squash these
"early" flaw sources, e.g. VLA removal, introduction of refcount_t,
FORTIFY_SOURCE, implicit-fallthrough removal, UBSAN_BOUNDS, etc. Working
on attack primitive reduction doesn't preclude working on making other
things more robust against failure.

Attack primitive reduction forces attacks into specific categories,
narrowing their scope/behavior in the process. (e.g. implementing
non-executable memory didn't stop all kernel exploits, but it forced
many attacks into the remaining writable+executable memory, making
these kinds of things tractable to audit (e.g. CONFIG_DEBUG_WX.) CFI in
particular strengthens the "intended" call graph as described in the C
source, compared to the prototype-agnostic "just call into an address"
that results after compilation. No, it is not perfect, but it does narrow
the avenue of attack, and allows for the creation of defenses that cover
the resulting gap.

> Making important data readonly
> [...]
> The problem I see with this approach is that a large portion of the things a
> kernel does are, in some way, critical to the correct functioning of the system
> and system security. MMU state management, task scheduling, memory allocation,
> filesystems
> (https://googleprojectzero.blogspot.com/2020/02/mitigations-are-attack-surface-too.html),
> page cache, IPC, ... - if any one of these parts of the kernel is corrupted
> sufficiently badly, an attacker will probably be able to gain access to all
> user data on the system, or use that corruption to feed bogus inputs into one
> of the subsystems whose own data structures are read-only.

Yes, given unlimited resources, even the narrowest of flaws can ultimately
lead to total system compromise. I don't think, however, that this is
a useful way to examine the benefit of defenses. Just like the rest of
software engineering, security defenses are evolutionary. There isn't
going to be a single fix that makes everything safe, but rather a series
of changes that break down the problem into smaller pieces that can be
dealt with progressively.

I think there is value in removing targets (especially PTEs) from the
writable-at-rest memory set: it's another attack surface reduction.
It seems like what you're saying is "the attack surface is so huge
there's no hope of actually removing enough surface to make a
difference."

I don't agree with this, though, since each attack surface has different
shapes and behaviors. Not all attacks provide the same levels of control
over the exposed pathological behavior available for abuse. And by forcing
some design on the memory accesses, we can challenge some of the beliefs
about how data structures should be classified -- we can start to carve
up the giant bucket of kernel heap memory into separate pieces with
documented security boundaries, etc.

And as I've suggested before, attack surface removal appears to have
meaningful impact on exploit development costs. For example, even
something as course-grained as CFG frustrated Tavis a while back. (I'm not
saying he couldn't have found a solution -- I know better -- but rather
that it was going to take more time and he didn't want to spend it then.)

> [...]
> I think that the current situation of software security could be dramatically
> improved - in a world where a little bug in some random kernel subsystem can
> lead to a full system compromise, the kernel can't provide reliable security
> isolation. Security engineers should be able to focus on things like buggy
> permission checks and core memory management correctness, and not have to spend
> their time dealing with issues in code that ought to not have any relevance to
> system security.

Agreed -- this is why shedding as much of C's dangers is where I've been
trying to focus recent efforts, and I've been delighted to see the Rust
efforts coming in to remove C entirely. :)

Thanks again for this excellent write-up!

-Kees

[1] https://lore.kernel.org/lkml/ace0028d-99c6-cc70-accf-002e70f8523b@linux.com/
[2] https://lore.kernel.org/lkml/CA+55aFy6jNLsywVYdGp83AMrXBo_P-pkjkphPGrO=82SPKCpLQ@mail.gmail.com/
[3] https://lore.kernel.org/lkml/20210307113031.11671-6-john.wood@gmx.com/
[4] https://lore.kernel.org/lkml/20210929185823.499268-1-alex.popov@linux.com/
[5] https://twitter.com/_monoid/status/1449321535869788162

-- 
Kees Cook
