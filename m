Return-Path: <SRS0=UOyW=BH=lists.openwall.com=kernel-hardening-return-19479-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02123C433E8
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jul 2020 17:17:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5128720809
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jul 2020 17:17:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="KPnMEN7i"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5128720809
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19479-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3294 invoked by uid 550); 28 Jul 2020 17:16:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3271 invoked from network); 28 Jul 2020 17:16:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595956604;
	bh=FPl2g9z95O/j9qakMr1cGWs3U8+LQVfszTzNisgkf+I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KPnMEN7iCF/xEO6QsEaxqYO2GzTsDtB7AMcRLK6l/UjK4oIn/F4JOGSXZUvYW44s1
	 jEFlyTCl3P3MEFUQeNfubHYCCc9zG74UqQBTODvN2LzJ4uy4XxTnjTnNBbEJ2yMVj4
	 PZjnIsRaELUQ0yXk6Deqthsuj/8xNzoMTptFK1So=
X-Gm-Message-State: AOAM532q9RZ0bVU+5qIIDfwBroSFE76WttS15JYlWROjs7+ySblERbHL
	NnT6e1Vw444xwuQ6eVaRjUksVAOK1oxSHKCrM2W3IA==
X-Google-Smtp-Source: ABdhPJwu7N9kRRQbUR+VvYTCTVOAiGMuB+0+ywLntE8sEkStNuXDIJbnbwFAt4moiWmwHpSI57u5zJetZtfyZAKrhS8=
X-Received: by 2002:a1c:de86:: with SMTP id v128mr4734767wmg.36.1595956603047;
 Tue, 28 Jul 2020 10:16:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <c23de6ec47614f489943e1a89a21dfa3@AcuMS.aculab.com> <f5cfd11b-04fe-9db7-9d67-7ee898636edb@linux.microsoft.com>
In-Reply-To: <f5cfd11b-04fe-9db7-9d67-7ee898636edb@linux.microsoft.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Tue, 28 Jul 2020 10:16:32 -0700
X-Gmail-Original-Message-ID: <CALCETrUta5-0TLJ9-jfdehpTAp2Efmukk2npYadFzz9ozOrG2w@mail.gmail.com>
Message-ID: <CALCETrUta5-0TLJ9-jfdehpTAp2Efmukk2npYadFzz9ozOrG2w@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
To: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc: David Laight <David.Laight@aculab.com>, 
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, 
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "oleg@redhat.com" <oleg@redhat.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jul 28, 2020 at 9:32 AM Madhavan T. Venkataraman
<madvenka@linux.microsoft.com> wrote:
>
> Thanks. See inline..
>
> On 7/28/20 10:13 AM, David Laight wrote:
> > From:  madvenka@linux.microsoft.com
> >> Sent: 28 July 2020 14:11
> > ...
> >> The kernel creates the trampoline mapping without any permissions. When
> >> the trampoline is executed by user code, a page fault happens and the
> >> kernel gets control. The kernel recognizes that this is a trampoline
> >> invocation. It sets up the user registers based on the specified
> >> register context, and/or pushes values on the user stack based on the
> >> specified stack context, and sets the user PC to the requested target
> >> PC. When the kernel returns, execution continues at the target PC.
> >> So, the kernel does the work of the trampoline on behalf of the
> >> application.
> > Isn't the performance of this going to be horrid?
>
> It takes about the same amount of time as getpid(). So, it is
> one quick trip into the kernel. I expect that applications will
> typically not care about this extra overhead as long as
> they are able to run.

What did you test this on?  A page fault on any modern x86_64 system
is much, much, much, much slower than a syscall.

--Andy
