Return-Path: <SRS0=H7PD=AF=lists.openwall.com=kernel-hardening-return-19104-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD39C433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 14:52:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DDAD720768
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 14:52:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="GFaiBnqg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDAD720768
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19104-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23724 invoked by uid 550); 24 Jun 2020 14:52:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23701 invoked from network); 24 Jun 2020 14:52:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u2t0csFbaqQQKHGsdu4Ps/0+902KB2yFco36m+qYijE=;
        b=GFaiBnqgZnNh4wd8OhfyJj+OLfayMLvp2cUErZCWyE0KhlI4GBJtkNGGjWUje6AqxO
         wKNzdJi720VA34rdPV/0XJ/7pZOCZmT0sTJyMQUrO/d0wFqp6jYj7o9RzGUQli+F2P60
         gHC0u+e67yC+7wO57Px8yJWfH46mIgubSpFls=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u2t0csFbaqQQKHGsdu4Ps/0+902KB2yFco36m+qYijE=;
        b=XiEEgm+6dUW9/tpWcV35HzETHDHY2zBB/AdoCSSPX9e1fzT1NtfLPrSlEPlLKt1FUv
         L7u5YGf419pPf7tsKdKOqKB9G7dn+L13Y38W0jhFBqOGLbbkISFBS6pm5ps0nYrqKeA+
         2KnFD2WWYrB+21cuapB3HgskzqgMzzYzx5TIK61etpdPTEQ01+Q//iY0YOwoZZ4ppcIJ
         UBYu/HjlX3VjcoJl7cXrdY/saQt1upVcVEhgCsVtzVh5uyk680SC88nZFAzBLJ7/fVN9
         JeeV6tfAjVnuYqL2uhNXPiTJh7xMY/XMMPT8lgFWRRgYPfnb40kXbnZb4XsEvmhaxfjv
         IynA==
X-Gm-Message-State: AOAM533LvUqSxeNop8OzwhxMet6jjbadbs3Pzu5zd3zivuUN70tI7i18
	hSegd8iZAwkPrjn54SmFR48sBg==
X-Google-Smtp-Source: ABdhPJzSKnjC6q0itcfYB9NBferTrDvxaLliakcW3kWkd4DyBl9K9bBpS0oiH3XZ4hWI1H7d0i4CAw==
X-Received: by 2002:a17:90a:1781:: with SMTP id q1mr27332225pja.24.1593010349195;
        Wed, 24 Jun 2020 07:52:29 -0700 (PDT)
Date: Wed, 24 Jun 2020 07:52:27 -0700
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
Subject: Re: [PATCH v2 2/5] ARM: vdso: Don't use gcc plugins for building
 vgettimeofday.c
Message-ID: <202006240752.9114041C@keescook>
References: <20200624123330.83226-1-alex.popov@linux.com>
 <20200624123330.83226-3-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624123330.83226-3-alex.popov@linux.com>

On Wed, Jun 24, 2020 at 03:33:27PM +0300, Alexander Popov wrote:
> Don't use gcc plugins for building arch/arm/vdso/vgettimeofday.c to
> avoid unneeded instrumentation.
> 
> Signed-off-by: Alexander Popov <alex.popov@linux.com>

Applied to for-next/gcc-plugins.

-- 
Kees Cook
