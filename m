Return-Path: <SRS0=dniW=7W=lists.openwall.com=kernel-hardening-return-18941-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C87C433E0
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jun 2020 18:47:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5696320734
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jun 2020 18:47:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="RRs1XpvK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5696320734
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18941-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17466 invoked by uid 550); 9 Jun 2020 18:47:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17444 invoked from network); 9 Jun 2020 18:47:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uJfu7VCoabwyy7XV4REVbfqvINHE8jJHSSQxXyuHXd8=;
        b=RRs1XpvKUrWcGC9rIH96xpb3pTK7Sz9Y478qOvPHNO4RLX043gSI9fVBKTbIjskAsD
         NYVbHiStuO9ZNyJZjm0N/3IRfTEgzEFthkAy/Nt63yzoJ0aFhLDWR5b0DOgY+O1mRVuG
         TpNIJcS9r6syyH23xPO0c25GxRl4Du26VqrsU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uJfu7VCoabwyy7XV4REVbfqvINHE8jJHSSQxXyuHXd8=;
        b=iIkcNRPhCIiuoOr6WedQDdG8bvyoRjiJxxxzO/HQb4v2N7hySV/84BbTDq+AWx42fU
         i9bu/x74TwvvMBBhqQEScb47i+m8eMzhHThA9ZwIcWL2SNP/thMWpYUWb9OpB7XY8CSZ
         v8e7FQRazmcQqd1lKDRhOo5nlgGHFmSG8Sqr8zvQ09CaPJlaX75Vt7KHTcOI2ZG1lYo5
         cVyllnvfnw0Jshn3h1iGN+WwcMVhFmctQwZG0Xtn0l0fwRq8GTJXC5rHvYCwUfPil4/C
         cbAbUS135f0aM7p+jBUKY+kUqQWvfZL0BQPlnoUvzCx6lqofMq1dSLC1Wx/i5g6SYw8R
         khJw==
X-Gm-Message-State: AOAM532udDERFv5JV0WGOr+bewjz6LtaXRid9LxLEG7iqfQuNdHXY1aP
	UJXwh27WJ1F/25gwAbwonOduJg==
X-Google-Smtp-Source: ABdhPJx/4VVBlneDG36Q/SLWPtFp+CtxwJnOIUCT1u2jRalyMTmf8uve0S/G2MJuu/H/na/+h9PhSA==
X-Received: by 2002:a17:90a:30a5:: with SMTP id h34mr6603724pjb.36.1591728450330;
        Tue, 09 Jun 2020 11:47:30 -0700 (PDT)
Date: Tue, 9 Jun 2020 11:47:28 -0700
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
Subject: Re: [PATCH 3/5] gcc-plugins/stackleak: Add 'verbose' plugin parameter
Message-ID: <202006091147.193047096C@keescook>
References: <20200604134957.505389-1-alex.popov@linux.com>
 <20200604134957.505389-4-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604134957.505389-4-alex.popov@linux.com>

On Thu, Jun 04, 2020 at 04:49:55PM +0300, Alexander Popov wrote:
> Add 'verbose' plugin parameter for stackleak gcc plugin.
> It can be used for printing additional info about the kernel code
> instrumentation.
> 
> For using it add the following to scripts/Makefile.gcc-plugins:
>   gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STACKLEAK) \
>     += -fplugin-arg-stackleak_plugin-verbose
> 
> Signed-off-by: Alexander Popov <alex.popov@linux.com>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
