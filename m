Return-Path: <SRS0=A1dW=D5=lists.openwall.com=kernel-hardening-return-20252-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B0C3C388F7
	for <kernel-hardening@archiver.kernel.org>; Thu, 22 Oct 2020 20:02:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 807F620759
	for <kernel-hardening@archiver.kernel.org>; Thu, 22 Oct 2020 20:02:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="D87aIC6R"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 807F620759
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20252-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17790 invoked by uid 550); 22 Oct 2020 20:02:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17755 invoked from network); 22 Oct 2020 20:02:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cFPNRFtcPYYUxGQLBpZGVkGsffh0bPYUzGPf0AjIisE=;
        b=D87aIC6RhWXjIFC2wLTyA9sXgg4Ohi35vZlWc6IpsPweIMiuSuPWWV/GUDv5nHmJ85
         VZHEHdDU6+v2ffn1rfa3oGSzdn/lPafbEyay3hC42oYeNVfBehGnh2LHtq3E2bneQqHm
         5Cxx30ICp+zQTttpir5HjfH4xhmU5v7FgZ1Hg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cFPNRFtcPYYUxGQLBpZGVkGsffh0bPYUzGPf0AjIisE=;
        b=BjjailMxQ9la+8you6vBCxYnYQwM2hLtc5WqxYHtjFnKKP3hwWvRABEDVJ7Cw6OQ+U
         VilqX9DXFDkKEQqyqdM4A66ButPj+t/lWF33zyTeF1ENwXS+cHsVcDCrwJuXV+q1CcL2
         VQeb5BTbrlbrtPdyAiQiOQHciLTufumyyLQl4hh9yl5fud4O8Atkt9jIXf0EwIVzZCAE
         X2GAv5lo4QxhKreqOzkB1SVAPf7LB0syjrjkngVLzcsQ8X5HG22lxW1HaKl4X/WHU/Eb
         MbYTpmBrclLi8yyPxcQVsOVJ4dcBw6byOzF8N2tVcp51oQkWNvG9HQClKgwWfKY6jjJI
         U/pg==
X-Gm-Message-State: AOAM530fgPzLiMxOQslwPsH6JQP7YXrc1qSM/HYjFPh93BUqRqOpHlBg
	BIyVUxZG3d8p5Tzzni6MuNR7Xg==
X-Google-Smtp-Source: ABdhPJxzFj2lWZu9IdxGeO5ZLR3jud5fxKudfnSoE1lSnvp4GFCMO24w5hRAidupXxV/3pvyIOWiyQ==
X-Received: by 2002:a63:1457:: with SMTP id 23mr3631355pgu.24.1603396940642;
        Thu, 22 Oct 2020 13:02:20 -0700 (PDT)
Date: Thu, 22 Oct 2020 13:02:18 -0700
From: Kees Cook <keescook@chromium.org>
To: Topi Miettinen <toiwoton@gmail.com>
Cc: Szabolcs Nagy <szabolcs.nagy@arm.com>,
	Jeremy Linton <jeremy.linton@arm.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	libc-alpha@sourceware.org, systemd-devel@lists.freedesktop.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>, Dave Martin <dave.martin@arm.com>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Salvatore Mesoraca <s.mesoraca16@gmail.com>,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org
Subject: Re: BTI interaction between seccomp filters in systemd and glibc
 mprotect calls, causing service failures
Message-ID: <202010221256.A4F95FD11@keescook>
References: <8584c14f-5c28-9d70-c054-7c78127d84ea@arm.com>
 <20201022075447.GO3819@arm.com>
 <78464155-f459-773f-d0ee-c5bdbeb39e5d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78464155-f459-773f-d0ee-c5bdbeb39e5d@gmail.com>

On Thu, Oct 22, 2020 at 01:39:07PM +0300, Topi Miettinen wrote:
> But I think SELinux has a more complete solution (execmem) which can track
> the pages better than is possible with seccomp solution which has a very
> narrow field of view. Maybe this facility could be made available to
> non-SELinux systems, for example with prctl()? Then the in-kernel MDWX could
> allow mprotect(PROT_EXEC | PROT_BTI) in case the backing file hasn't been
> modified, the source filesystem isn't writable for the calling process and
> the file descriptor isn't created with memfd_create().

Right. The problem here is that systemd is attempting to mediate a
state change using only syscall details (i.e. with seccomp) instead of
a stateful analysis. Using a MAC is likely the only sane way to do that.
SELinux is a bit difficult to adjust "on the fly" the way systemd would
like to do things, and the more dynamic approach seen with SARA[1] isn't
yet in the kernel. Trying to enforce memory W^X protection correctly
via seccomp isn't really going to work well, as far as I can see.

Regardless, it makes sense to me to have the kernel load the executable
itself with BTI enabled by default. I prefer gaining Catalin's suggested
patch[2]. :)

[1] https://lore.kernel.org/kernel-hardening/1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com/
[2] https://lore.kernel.org/linux-arm-kernel/20201022093104.GB1229@gaia/

-- 
Kees Cook
