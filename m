Return-Path: <SRS0=LcBO=AF=lists.openwall.com=kernel-hardening-return-19105-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA66FC433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 14:53:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3968220768
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 14:53:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hpP80aWo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3968220768
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19105-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24566 invoked by uid 550); 24 Jun 2020 14:53:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24546 invoked from network); 24 Jun 2020 14:53:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OPWu0TeNvD4ujFH7IT6Yq/7QVWt6mn1sVW+hYIGa3/c=;
        b=hpP80aWoVCRlVHrXGBwyfL+RPDRXCMe7ZswUMGPPdIckNU+/eQLVr51wJYXeK84tS8
         2WCDJZSZTwtxrmhRVEOIBcnY26CQPqWU3uVdGunp0mR0o+2LoNpU5OTOKcg3KoQqUP/D
         FsCCqiNuvarAC7Prd/cfAOwQBwApsIR4mQjPw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OPWu0TeNvD4ujFH7IT6Yq/7QVWt6mn1sVW+hYIGa3/c=;
        b=GE1kt4WVMihPjz8eiiv+bx2bDA35Ys6xZXrbtom1CMJI2InKBls9+uMrhuYfWDSTpV
         OCnPuEwFmjG89xfVLZhnbcfxx12ly0EchEnAPwwIfpUVXpdfDpxw6KNDoLONDT71JHk0
         0l/5wHTkT5jYIKh2j1+P0BKqYTul/2auQtMtMW7mvO4sug8juJiN+EWncgqU/+ZdJdE7
         bKgFDaw7DDTfB4Gn4tGKNryFF9+MlUxDo6kWPB1stzv+VEIRND6MGHtsvRhw8xNTO4GB
         B9Lh+NRhWMKUidDuqF6TEp2hCxjMoXhsbRsGLXhiAFAJ1Y6eVuuwRpoupI3INtEurnBN
         ErOw==
X-Gm-Message-State: AOAM530lBia2ejtQ0rbtA5GVfgBPeCHXy4RoIT8cTMGXt11Op59UDEOk
	vnLmWo3b35XhXovcHf6rgsYWhg==
X-Google-Smtp-Source: ABdhPJwkPoYDkU43oyjXTZ3o3ijQjsdZRoWueUiZxBpfidz8te1WzS0FHYIMG6I55iroLY/YVnEmig==
X-Received: by 2002:a17:90a:f508:: with SMTP id cs8mr26450593pjb.16.1593010406141;
        Wed, 24 Jun 2020 07:53:26 -0700 (PDT)
Date: Wed, 24 Jun 2020 07:53:24 -0700
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
Subject: Re: [PATCH v2 5/5] gcc-plugins/stackleak: Add 'verbose' plugin
 parameter
Message-ID: <202006240753.8C62F5A@keescook>
References: <20200624123330.83226-1-alex.popov@linux.com>
 <20200624123330.83226-6-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624123330.83226-6-alex.popov@linux.com>

On Wed, Jun 24, 2020 at 03:33:30PM +0300, Alexander Popov wrote:
> Add 'verbose' plugin parameter for stackleak gcc plugin.
> It can be used for printing additional info about the kernel code
> instrumentation.
> 
> For using it add the following to scripts/Makefile.gcc-plugins:
>   gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STACKLEAK) \
>     += -fplugin-arg-stackleak_plugin-verbose
> 
> Signed-off-by: Alexander Popov <alex.popov@linux.com>

Applied to for-next/gcc-plugins.

-- 
Kees Cook
