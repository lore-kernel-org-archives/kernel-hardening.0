Return-Path: <SRS0=jfKr=7W=lists.openwall.com=kernel-hardening-return-18944-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86581C433DF
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jun 2020 19:15:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D108F20734
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jun 2020 19:15:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="eHah8lXm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D108F20734
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18944-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1690 invoked by uid 550); 9 Jun 2020 19:15:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1670 invoked from network); 9 Jun 2020 19:15:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tGGQ3VocRYuP1AxRJCcf0YOuFdAQhDzmAD+bQaR7nDA=;
        b=eHah8lXm/9NdioI0IQB1zdteauOgwpHoUWv7l0ccJihSiEXHjtaYGtLsa46BXQHRf7
         Yv5rlSSlQSgQ0xLs6A13uJrWkHUd4+wvxefc11Rip7Zheaq+tjhgPtKEc60jT/XwgsLw
         pO9xQmpan/wYr/eEowfxeA5uFIlinxoaAc56M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tGGQ3VocRYuP1AxRJCcf0YOuFdAQhDzmAD+bQaR7nDA=;
        b=oshfbKFPmd2zgmBYPo7wvNYivfiuJUJ95Bt7MRehk29RTJxaedxUZSf48HCKYKLbj5
         DC8F9G0RAGdUVBMFmSI+iOpK0aHX0VuLmxgJcBbmHV1fk3TqrPsA53KtWCr+Nqjz80nc
         tZZXSCjVD0IXNTPKW6UDeQrDT6ddYK44CPRw3uXioF77kTr4epsb+g7HwvrE04zyYfji
         AbaZnLg3Qr+AVVx64c3je1D4RPKzzUEUtt7H6/pliEoS6px5Lrd+i1od7qe3FCJaDoiY
         8MUMx4FFlCSrQSh1M6HtN+EIVF4cAkwE4RoTDqU/97MhON7hIP0gZCrod6TGmckwZkpW
         1fSg==
X-Gm-Message-State: AOAM531KsMaEKG9qS+Zjumf9OV2jLM7s/qtqw/txa1jK2ovY33MnLoLL
	DKGywFDlV9CfPwkhFr5gv7FAoA==
X-Google-Smtp-Source: ABdhPJyMccFgBeerGRwQ2wfXEHGAf89Obho1rWhLY+bGl8E1JBTsrHPd/c8CjkZ038Wze8SEwIszmQ==
X-Received: by 2002:a63:2248:: with SMTP id t8mr25901047pgm.113.1591730105075;
        Tue, 09 Jun 2020 12:15:05 -0700 (PDT)
Date: Tue, 9 Jun 2020 12:15:02 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Popov <alex.popov@linux.com>
Cc: Emese Revfy <re.emese@gmail.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Thiago Jung Bauermann <bauerman@linux.ibm.com>,
	Luis Chamberlain <mcgrof@kernel.org>, Jessica Yu <jeyu@kernel.org>,
	Sven Schnelle <svens@stackframe.org>,
	Iurii Zaikin <yzaikin@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Collingbourne <pcc@google.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Alexander Monakov <amonakov@ispras.ru>,
	Mathias Krause <minipli@googlemail.com>,
	PaX Team <pageexec@freemail.hu>,
	Brad Spengler <spender@grsecurity.net>,
	Laura Abbott <labbott@redhat.com>,
	Florian Weimer <fweimer@redhat.com>,
	kernel-hardening@lists.openwall.com, linux-kbuild@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, gcc@gcc.gnu.org, notify@kernel.org
Subject: Re: [PATCH 0/5] Improvements of the stackleak gcc plugin
Message-ID: <202006091210.C139883AB@keescook>
References: <20200604134957.505389-1-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604134957.505389-1-alex.popov@linux.com>

On Thu, Jun 04, 2020 at 04:49:52PM +0300, Alexander Popov wrote:
> In this patch series I collected various improvements of the stackleak
> gcc plugin.

Thanks!

> Alexander Popov (5):
>   gcc-plugins/stackleak: Exclude alloca() from the instrumentation logic
>   gcc-plugins/stackleak: Use asm instrumentation to avoid useless
>     register saving

These look like they might need tweaks (noted in their separate
replies).

>   gcc-plugins/stackleak: Add 'verbose' plugin parameter
>   gcc-plugins/stackleak: Don't instrument itself

If you wanted to reorder the series and move these first, I could take
these into my tree right away (they're logically separate from the other
fixes).

>   gcc-plugins/stackleak: Don't instrument vgettimeofday.c in arm64 VDSO

This seems good -- though I'm curious about 32-bit ARM and the other
HAVE_GCC_PLUGINS architectures with vDSOs (which appears to be all of
them except um).

-- 
Kees Cook
