Return-Path: <SRS0=akba=ZW=lists.openwall.com=kernel-hardening-return-17452-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 092D2C432C3
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 Nov 2019 16:54:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5047D2082E
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 Nov 2019 16:54:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="F/Kzqsus"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5047D2082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17452-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32370 invoked by uid 550); 30 Nov 2019 16:54:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32333 invoked from network); 30 Nov 2019 16:54:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S16QwN1PJCMUwwyc17ejUqn/u5LVGvSs9+4bN3omUNc=;
        b=F/KzqsusGPe7Zn0GUrXYjNAodrpEb9VoVg6jUn9pg7QHUSes9ytznoUiSAGY3Yin4+
         h9y27cgGOhuaRnO8J+iMoPKyPPiurN2hlKgyzr0qhf2Txv15ZH1PNE5nfvpPqrkhtUbw
         d+Fr4tU0rkGeKr+Q/zTzoed5fpSVko4UTrkVY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S16QwN1PJCMUwwyc17ejUqn/u5LVGvSs9+4bN3omUNc=;
        b=nKUEnJ1E6rRs7WmVyyEn/YT7P1DZLCrvdiDGSwyToITQA/ghbximxmqp7/mGq9sskP
         bbe9TxrB6ZMh/6MOg+ELyPwNzJ1cUjaWIoFxHX7j261vvXaGi49177Xa5gOGOiIw0NoS
         f3urIEnsDOvYjqIcHAixCXpomo2CfyQmbtneuwtjs7tVnHJGgTLpF7jEZ8x9A/xAMugM
         R2uL+SfWD4KKx39hzYP2xKaxSNSkDkGL/2FWYi4uipPY6OhgqLEZFps0YbJmCYnlyH3X
         bz5HtXfzL9jBVY9OdDxdDod3VhHouZhLh7ovEdFOwy4JiW6RyCVFkJ+NM2VWei3NdsQC
         zBbA==
X-Gm-Message-State: APjAAAVkqNUG/5mB8PFBOHZMAoSJjQjmXHyB6vN+/yePvJtkBQt9YHM4
	zzfgaOrdPuOf3DHeTWG2Uu0h2A==
X-Google-Smtp-Source: APXvYqw+/5iJg0WtA+4N3AeqRbX/HSrtVfbM6eVzp09WQVwdr6Lsmy0wnDLoENPMHu+zvrkZBGzAUQ==
X-Received: by 2002:a17:90a:30a4:: with SMTP id h33mr25192180pjb.50.1575132849541;
        Sat, 30 Nov 2019 08:54:09 -0800 (PST)
Date: Sat, 30 Nov 2019 08:54:07 -0800
From: Kees Cook <keescook@chromium.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kassad <aashad940@gmail.com>, kernel-hardening@lists.openwall.com
Subject: Re: Contributing to KSPP newbie
Message-ID: <201911300853.4F17BA5C@keescook>
References: <CA+OAcEM94aAcaXB17Z2q9_iMWVEepCR8SycY6WSTcKYd+5rCAg@mail.gmail.com>
 <20191129112825.GA27873@lakrids.cambridge.arm.com>
 <201911300846.E8606B5B2@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201911300846.E8606B5B2@keescook>

On Sat, Nov 30, 2019 at 08:48:23AM -0800, Kees Cook wrote:
> On Fri, Nov 29, 2019 at 11:29:13AM +0000, Mark Rutland wrote:
> > On Thu, Nov 28, 2019 at 11:39:11PM -0500, Kassad wrote:
> > > Hey Kees,
> > > 
> > > I'm 3rd university student interested in learning more about the linux kernel.
> > > I'm came across this subsystem, since it aligns with my interest in security.
> > > Do you think as a newbie this task https://github.com/KSPP/linux/issues/11 will
> > > be a good starting point?
> > 
> > I think this specific task (Disable arm32 kuser helpers) has already
> > been done, and the ticket is stale.
> 
> Oh, thank you! I entirely missed both of these commits. I've added
> notes to the bug and closed it.
> 
> > 
> > On arm CONFIG_KUSER_HELPERS can be disabled on kernels that don't need
> > to run on HW prior to ARMv6. See commit:
> > 
> >   f6f91b0d9fd971c6 ("ARM: allow kuser helpers to be removed from the vector page")
> > 
> > On arm64, CONFIG_KUSER_HELPERS can be disabled on any kernel. See
> > commit:
> > 
> >   1b3cf2c2a3f42b ("arm64: compat: Add KUSER_HELPERS config option")
> 
> (Typo: a1b3cf2c2a3f42b)

Typo typo: af1b3cf2c2a3f42bbb680812ff1bbd715ac8af69

> 
> -Kees
> 
> > 
> > Thanks,
> > Mark.
> 
> -- 
> Kees Cook

-- 
Kees Cook
