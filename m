Return-Path: <SRS0=d4Fa=AF=lists.openwall.com=kernel-hardening-return-19103-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 574C6C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 14:52:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A99CB20781
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 14:52:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="oOpZTa5+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A99CB20781
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19103-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21918 invoked by uid 550); 24 Jun 2020 14:52:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21869 invoked from network); 24 Jun 2020 14:52:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+LYpavnNuYqsfOkUttYqicpUlIfIv5Cp3lganI3VZyY=;
        b=oOpZTa5+wogd5Zo5i06YBiLJFA99TNpd/R+dpAjxia0I1HX72p/pYJ8+r7FI6VpwER
         kzA4slLqc797d9hmoYdf7UkLvHZBonG0ASsGwrh3JEmkqkxa0R9ukdqOi+fcffkssEzd
         F5YHRwr3LVOa1RW5jvA3hKVCIR9zUCv3CwZ08=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+LYpavnNuYqsfOkUttYqicpUlIfIv5Cp3lganI3VZyY=;
        b=iigY3EYZE7LtdK92nP4B7BkXHE+Og95hSlNkAlLuiGiAfe9ENaF6i2pGY9GyTnhcTZ
         Dx/yvGZNYTxpmpc0XRMseVxGKnhTSIB4V9D8dJMKX6HaqmZvSk27Eo2zD/lwym+7GcAX
         21GE9VaxCMvOxGil1yfFiGJcTh1gY9+TPPhsxbJJ04Q5vK3BaK/inGxC/51fT0jZLbmK
         XewmGWQq478LfMkA63rLv+Y5WIaM9BhN2tLawpCQC5eOgae5ibYB55Aij/q1Gt35mOIZ
         219PHFbv0iyYODRoS0ECC1lX+e0NwzvKuRdRxE0w9n5LLFgOHp5Zul0vbjWjEJ3Os/4P
         QHUg==
X-Gm-Message-State: AOAM5324IZiG1BdLqHPs3DhwBSvLntEQCEm8DOyKX1C7snK6XZbWI0gm
	sJcg+4r9kU9GrqGoSzmu6HYGUg==
X-Google-Smtp-Source: ABdhPJwjhADjsZkiUiV63C7UdjS0kr8znYCOvlhuYeRyXXM/eucbfSwVQB3WasGrTPrLaBRSEotjoQ==
X-Received: by 2002:a63:8b42:: with SMTP id j63mr22776554pge.131.1593010327982;
        Wed, 24 Jun 2020 07:52:07 -0700 (PDT)
Date: Wed, 24 Jun 2020 07:52:06 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Popov <alex.popov@linux.com>
Cc: Jann Horn <jannh@google.com>, Emese Revfy <re.emese@gmail.com>,
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
Subject: Re: [PATCH v2 1/5] gcc-plugins/stackleak: Don't instrument itself
Message-ID: <202006240751.30293A1@keescook>
References: <20200624123330.83226-1-alex.popov@linux.com>
 <20200624123330.83226-2-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624123330.83226-2-alex.popov@linux.com>

On Wed, Jun 24, 2020 at 03:33:26PM +0300, Alexander Popov wrote:
> There is no need to try instrumenting functions in kernel/stackleak.c.
> Otherwise that can cause issues if the cleanup pass of stackleak gcc plugin
> is disabled.
> 
> Signed-off-by: Alexander Popov <alex.popov@linux.com>
> Acked-by: Kees Cook <keescook@chromium.org>

Thanks! Applied to for-next/gcc-plugins.

-- 
Kees Cook
