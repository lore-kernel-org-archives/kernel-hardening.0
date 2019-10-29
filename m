Return-Path: <SRS0=mmQm=YW=lists.openwall.com=kernel-hardening-return-17152-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6724CA9EAE
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Oct 2019 21:30:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 18A2F21734
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Oct 2019 21:30:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="PrZ2AGRr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 18A2F21734
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17152-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 6029 invoked by uid 550); 29 Oct 2019 21:30:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 6006 invoked from network); 29 Oct 2019 21:30:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TqdJq1f/qIhweQts5AB1HeIVb9O7ywkFDNZusrXv0ac=;
        b=PrZ2AGRroeNtw796hVMPeML+80GYP6QyWEsnxgND+dc9gtx/OHg/KPAYFlRg85KJB2
         ZrrwSetq2naXw50GkCSuX6vr2qTerRqUQrvbdlAbZ7OpLfmXRmRnVUmKMOZGBMfYn7il
         34bQ7dLn6c6ccLIfSOQk8ypMzkskCSknF9H20=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TqdJq1f/qIhweQts5AB1HeIVb9O7ywkFDNZusrXv0ac=;
        b=cuZ24h9oKVqq8oUTEK5AWWlTCwnJ8QEmV4Pgt0L67zPo6Md8uEdm7OdjX85OnVve/H
         iBGB75qGK0NwxWAu1aM52aXxV4/O6Ti2KC25aJAZJ1kHElJDo/VVy+QxE4ZsY6HmR9xN
         tcs+Ihikr+4wJEHiJVlvV+6XgusaQDGVAVmV6KXyXZJFrtsqeCknGL2WsopiNQ+ZpGB3
         3ImU11LTZBs1VDEYWf6SmLRSkwm1d23SQ40Bi+ZNXT4YlEYLba6qykaO/vPnANM2Gj+2
         7Yjk5REdczmpFLzYX/C8GKA0Ptw+4LM0RCuUMtT2DLzhTmOPWM+9W8bTdu0UAM6XP57g
         13sg==
X-Gm-Message-State: APjAAAVVEOxOANjQdbnRVXUgeExnSn5a06AoeArtOgzfCqPavS5hCVV6
	LG/M88/BFP6HflneDPWaMkoofmyxn6E=
X-Google-Smtp-Source: APXvYqxnTu1TcbtvdQdCP8dDQXvWLSU1MHUroIgPJ3u8A3RsMXd94/dCLAk7L1VxfE53GVj9vbR5Bw==
X-Received: by 2002:a17:906:2989:: with SMTP id x9mr5534079eje.318.1572384606367;
        Tue, 29 Oct 2019 14:30:06 -0700 (PDT)
X-Received: by 2002:a1c:28d4:: with SMTP id o203mr6068671wmo.147.1572384604588;
 Tue, 29 Oct 2019 14:30:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190730191303.206365-9-thgarnie@chromium.org> <20190809173003.GG2152@zn.tnic>
In-Reply-To: <20190809173003.GG2152@zn.tnic>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Tue, 29 Oct 2019 14:29:53 -0700
X-Gmail-Original-Message-ID: <CAJcbSZGfHDthCz4h_h19zGN5Mb9yC+2FCfKs7-rfCuF=G9rP3w@mail.gmail.com>
Message-ID: <CAJcbSZGfHDthCz4h_h19zGN5Mb9yC+2FCfKs7-rfCuF=G9rP3w@mail.gmail.com>
Subject: Re: [PATCH v9 08/11] x86/boot/64: Adapt assembly for PIE support
To: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Kristen Carlson Accardi <kristen@linux.intel.com>, Kees Cook <keescook@chromium.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Juergen Gross <jgross@suse.com>, Peter Zijlstra <peterz@infradead.org>, 
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Maran Wilson <maran.wilson@oracle.com>, Feng Tang <feng.tang@intel.com>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Aug 9, 2019 at 10:29 AM Borislav Petkov <bp@alien8.de> wrote:
>
> chOn Tue, Jul 30, 2019 at 12:12:52PM -0700, Thomas Garnier wrote:
> > Change the assembly code to use only relative references of symbols for the
> > kernel to be PIE compatible.
> >
> > Early at boot, the kernel is mapped at a temporary address while preparing
> > the page table. To know the changes needed for the page table with KASLR,
>
> These manipulations need to be done regardless of whether KASLR is
> enabled or not. You're basically accomodating them to PIE.
>
> > the boot code calculate the difference between the expected address of the
>
> calculates
>
> > kernel and the one chosen by KASLR. It does not work with PIE because all
> > symbols in code are relatives. Instead of getting the future relocated
> > virtual address, you will get the current temporary mapping.
>
> Please avoid "you", "we" etc personal pronouns in commit messages.
>
> > Instructions were changed to have absolute 64-bit references.
>
> From Documentation/process/submitting-patches.rst:
>
>  "Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
>   instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
>   to do frotz", as if you are giving orders to the codebase to change
>   its behaviour."

Sorry for the late reply, busy couple months.

I will integrate your feedback in v10. Thanks.

>
> Thx.
>
> --
> Regards/Gruss,
>     Boris.
>
> Good mailing practices for 400: avoid top-posting and trim the reply.
