Return-Path: <SRS0=35iB=5X=lists.openwall.com=kernel-hardening-return-18453-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35323C2BB1D
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Apr 2020 10:16:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5ADC520644
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Apr 2020 10:16:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JeSo03Bg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5ADC520644
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18453-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5990 invoked by uid 550); 7 Apr 2020 10:16:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5955 invoked from network); 7 Apr 2020 10:16:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EboS50A6Jdj3Itp9c+B3adS9KCBsSrRq/whyaB+pjFQ=;
        b=JeSo03BgopngrGGWZWmfQ5SJ//2ldmuO+KVk65RQFeEHA9/Kx9TrnYdJJVmeD9zOm3
         uPN1tFa0qT2R8/lECn+op8ReGHh+TYP3VZSkw42Og6ZDyI/al9vwQRXyNOYtDWl+GRyl
         2t01uWU49luYmNx75CQr9cWxUDLaBSIydoLgBStNVp7r1rzGqEQ9V3xp/9q1EX7mBLiq
         9SUWFjzPu2vzRLriPODqBMDbfbUrX4fQfgRrDTiJnQX5tchNIXTLua4P8Yv7Mfq7ohl0
         py5kME7YVBmf3SwRLjCtLSWAx/CUVK9tKppDQqrgKweeyUQvPVqHY+eiPHQAYqgAkmj1
         qJeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EboS50A6Jdj3Itp9c+B3adS9KCBsSrRq/whyaB+pjFQ=;
        b=I4jgIFILPOJiKZLDHzapvBd5Y2/qz7LyIJpX8VBWJEe7uLgd0SkKy1lcMYqnIZP0fx
         xhRChlNRwCTF/dLHGW6s9Kbq8TT2UKEm5Uj/JSlHHmNKPWDhENUpcWTc/KGs9Zfwu9NR
         2RuO3fy/qXm2+tVWnpkmLfYcVeDClZpWWCXedD/h/H6tXK+pgxROJ98oOCq7Kfl3hIik
         /vCTCm1Fc1ZFNurdRM1D+9MjR6bVlXTpsi+5AYvavpIHsGXk2N6DCw6XUdfvjAFeVSx6
         YupKPv3actk5Zij6xvL343g6wBf6Id4WVHp7dK/qpb3tz2/l2rjY5Aa5vJauHqv0Vgmd
         2Yvw==
X-Gm-Message-State: AGi0PuYAlXoIDS+IXpr+/5M38ubZSKeWpmD9Q3CEyOsgNV974SgCbth8
	Xnh6l9j5B6ieXMToru9HygkDSyYGvArhfJboOmk=
X-Google-Smtp-Source: APiQypJkVf3xfs1XAwktJ/dvmYZQ3/dKnKkyU5j/ZqPgKSKm5cuE1gcyZgsfmBKZyEJFpTNHbWv3ZbeYMRDK88OVe6Q=
X-Received: by 2002:adf:aac5:: with SMTP id i5mr1816565wrc.285.1586254572268;
 Tue, 07 Apr 2020 03:16:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200406142045.32522-1-levonshe@gmail.com> <20200406142045.32522-2-levonshe@gmail.com>
 <202004061201.27B0972@keescook>
In-Reply-To: <202004061201.27B0972@keescook>
From: "Lev R. Oshvang ." <levonshe@gmail.com>
Date: Tue, 7 Apr 2020 13:16:00 +0300
Message-ID: <CAP22eLH8S7LQmFGTm0D3GncyXdNi=MccBFZpDPrWXTfQTYhx+w@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] security : hardening : prevent write to proces's
 read-only pages from another process
To: Kees Cook <keescook@chromium.org>
Cc: arnd@arndb.de, kernel-hardening@lists.openwall.com, 
	Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Kees,

The patch you referred to is scoped in /proc fs.

There is a chance that hackers may use other attack methods except procfs.
There is process_vm_writev syscall , /dev/mem.
An attacker can also hijack one of the process threads and write to
read-only pages.
I admit that I am the newbie and lack knowledge, but I think my
solution is more generic and protects from more possible attacks.
Second, you suggested to control it in run-time with a knob.
I think that configuration option I propose better fit embedded system needs.
There is no need in an embedded system to turn it on/off since there is no gdb.
(the same argument for a production system),  These systems are locked
down, and perhaps the proper place to put this option is in lockdown
LSM.
Thank you for your response.
Lev


On Mon, Apr 6, 2020 at 10:16 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Apr 06, 2020 at 05:20:41PM +0300, Lev Olshvang wrote:
> > The purpose of this patch is produce hardened kernel for Embedded
> > or Production systems.
> >
> > Typically debuggers, such as gdb, write to read-only code [text]
> > sections of target process.(ptrace)
> > This kind of page protectiion violation raises minor page fault, but
> > kernel's fault handler allows it by default.
> > This is clearly attack surface for adversary.
> >
> > The proposed kernel hardening configuration option checks the type of
> > protection of the foreign vma and blocks writes to read only vma.
> >
> > When enabled, it will stop attacks modifying code or jump tables, etc.
> >
> > Code of arch_vma_access_permitted() function was extended to
> > check foreign vma flags.
> >
> > Tested on x86_64 and ARM(QEMU) with dd command which writes to
> > /proc/PID/mem in r--p or r--xp of vma area addresses range
> >
> > dd reports IO failure when tries to write to adress taken from
> > from /proc/PID/maps (PLT or code section)
>
> So, just to give some background here: the reason for this behavior is
> so debuggers can insert software breakpoints in the .text section (0xcc)
> etc. This is implemented with the "FOLL_FORCE" flag, and an attempt to
> remove it was made here:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8ee74a91ac30
> but it was later reverted (see below).
>
> There have been many prior discussions about this behavior, and a
> good thread (which I link from https://github.com/KSPP/linux/issues/37
> "Block process from writing to its own /proc/$pid/mem") is this one:
> https://lore.kernel.org/lkml/CAGXu5j+PHzDwnJxJwMJ=WuhacDn_vJWe9xZx+Kbsh28vxOGRiA@mail.gmail.com/
>
> For details on the revert see:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f511c0b17b08
>
> All this said, I think this feature would still be nice to have,
> available with some kind of knob to control it. Do you get the
> results you were expecting from just re-applying 8ee74a91ac30? If
> so, that's a much smaller change, and a single place to apply
> a knob. It would likely be best implemented with a sysctl and a
> static_branch(). A possible example for this can be seen here:
> https://lore.kernel.org/lkml/20200324203231.64324-4-keescook@chromium.org/
> Though it doesn't use a sysctl. (And perhaps this feature needs to be a
> per-process setting like "dumpable", but let's start simple with a
> system-wide control.)
>
> Can you test the FOLL_FORCE removal and refactor things to use a
> static_branch() instead?
>
> -Kees
>
> > Signed-off-by: Lev Olshvang <levonshe@gmail.com>
> > ---
> >  include/asm-generic/mm_hooks.h |  5 +++++
> >  security/Kconfig               | 10 ++++++++++
> >  2 files changed, 15 insertions(+)
> >
> > diff --git a/include/asm-generic/mm_hooks.h b/include/asm-generic/mm_hooks.h
> > index 4dbb177d1150..6e1fcce44cc2 100644
> > --- a/include/asm-generic/mm_hooks.h
> > +++ b/include/asm-generic/mm_hooks.h
> > @@ -25,6 +25,11 @@ static inline void arch_unmap(struct mm_struct *mm,
> >  static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
> >               bool write, bool execute, bool foreign)
> >  {
> > +#ifdef CONFIG_PROTECT_READONLY_USER_MEMORY
> > +     /* Forbid write to PROT_READ pages of foreign process */
> > +     if (write && foreign && (!(vma->vm_flags & VM_WRITE)))
> > +             return false;
> > +#endif
> >       /* by default, allow everything */
> >       return true;
> >  }
> > diff --git a/security/Kconfig b/security/Kconfig
> > index cd3cc7da3a55..d92e79c90d67 100644
> > --- a/security/Kconfig
> > +++ b/security/Kconfig
> > @@ -143,6 +143,16 @@ config LSM_MMAP_MIN_ADDR
> >         this low address space will need the permission specific to the
> >         systems running LSM.
> >
> > +config PROTECT_READONLY_USER_MEMORY
> > +     bool "Protect read only process memory"
> > +     help
> > +       Protects read only memory of process code and PLT table
> > +       from possible attack through /proc/PID/mem or through /dev/mem.
> > +       Refuses to insert and stop at debuggers breakpoints (prtace,gdb)
> > +       Mostly advised for embedded and production system.
> > +       Stops attempts of the malicious process to modify read only memory of another process
> > +
> > +
> >  config HAVE_HARDENED_USERCOPY_ALLOCATOR
> >       bool
> >       help
> > --
> > 2.17.1
> >
>
> --
> Kees Cook
