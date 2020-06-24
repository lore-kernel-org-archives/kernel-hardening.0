Return-Path: <SRS0=FI+a=AF=lists.openwall.com=kernel-hardening-return-19101-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49BFFC433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 14:41:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9C5C320738
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 14:41:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="LdqUQaQQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C5C320738
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19101-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13731 invoked by uid 550); 24 Jun 2020 14:41:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13711 invoked from network); 24 Jun 2020 14:41:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fbp7umasnXh+ke7N+beUAyOfPReUM2Tp6A+dzgB7eMs=;
        b=LdqUQaQQ73lvg2EH4zB5b0fAHY6pDsTgO5VkTlBIIFPTWFDt6KEfeGjsb0w6+bZ9Ow
         NITWE6F0NiNBcydTH1X5G5v/4LVNjJl2xkptnKSgFVRZwIBSdg7/4DIa9E/LMGsAb6fD
         enidR4CvnWPaAtnjb4zwOOo4tT4QsgRPZnifk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fbp7umasnXh+ke7N+beUAyOfPReUM2Tp6A+dzgB7eMs=;
        b=KRQvz57x8Y96KUt5MM+bHyOti2gVgEB1rAj+TW/eG/75ppIu6igipYD+Rbvi14dBGo
         EVgQPHgATxA8KDdh7jMH9j/amxjI83H30ST1htXJcbl+GT38EuRU2CL0+N7L8Z6uFD7W
         YkXemZdiGOjJp8C/qs3oZZtE7Kv0dfB5DHTMvmIRE9S2Vs26PK5wJetO7GxoqYkJF/DK
         K12cbYr8gpie+4+vpiyr6cOSMFGej1jIHueaTKOpXGK3bKgxgH9nKeF0yB8/vHyWyxBq
         k8kUvFnJlrXlrmMyonVVa1MhnPtFP8cZdXlLJqOl9XAp0j2Jpg2lxKCOt01OCrh7pvVc
         rihA==
X-Gm-Message-State: AOAM532yZPMTsc5jpousc0bKSHv2SVfB0RA8n2KzULE9a6VthrPOIb8u
	GpOrXR92KOFnD5wm+QUfoqMm1g==
X-Google-Smtp-Source: ABdhPJyLzb6qwq/8MBqHXf8uzinIy/tV8mWrOCrHPE7Fwn5qlWt9b5nzHsWE+x0soPiCSmy2JH0LLA==
X-Received: by 2002:a17:90a:7185:: with SMTP id i5mr2257473pjk.175.1593009678562;
        Wed, 24 Jun 2020 07:41:18 -0700 (PDT)
Date: Wed, 24 Jun 2020 07:41:16 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Popov <alex.popov@linux.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Jann Horn <jannh@google.com>,
	Emese Revfy <re.emese@gmail.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Thiago Jung Bauermann <bauerman@linux.ibm.com>,
	Jessica Yu <jeyu@kernel.org>, Sven Schnelle <svens@stackframe.org>,
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
Message-ID: <202006240740.5AF6369E53@keescook>
References: <20200624123330.83226-1-alex.popov@linux.com>
 <20200624123330.83226-6-alex.popov@linux.com>
 <20200624125305.GG4332@42.do-not-panic.com>
 <d7b118c1-0369-9aef-bd34-afc9bafc7e7b@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7b118c1-0369-9aef-bd34-afc9bafc7e7b@linux.com>

On Wed, Jun 24, 2020 at 04:09:20PM +0300, Alexander Popov wrote:
> On 24.06.2020 15:53, Luis Chamberlain wrote:
> > On Wed, Jun 24, 2020 at 03:33:30PM +0300, Alexander Popov wrote:
> >> Add 'verbose' plugin parameter for stackleak gcc plugin.
> >> It can be used for printing additional info about the kernel code
> >> instrumentation.
> >>
> >> For using it add the following to scripts/Makefile.gcc-plugins:
> >>   gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STACKLEAK) \
> >>     += -fplugin-arg-stackleak_plugin-verbose
> > 
> > Would be nice if we instead could pass an argument to make which lets
> > us enable this.
> 
> This feature is useful only for debugging stackleak gcc plugin.
> 
> The cflag that enables it is similar to -fplugin-arg-structleak_plugin-verbose,
> which is used for debugging the structleak plugin.
> 
> This debugging feature clutters the kernel build output, I don't think that many
> people will use it. So IMO creating a separate argument for make is not really
> needed.

Yup, agreed. The precedent for plugin verbosity is via CONFIGs. They're
not really general purpose enough to justify a "make" argument.

-- 
Kees Cook
