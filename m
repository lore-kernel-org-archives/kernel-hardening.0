Return-Path: <SRS0=AJyJ=AF=lists.openwall.com=kernel-hardening-return-19100-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9813AC433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 14:02:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0054820724
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 14:02:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0054820724
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19100-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26192 invoked by uid 550); 24 Jun 2020 14:02:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22378 invoked from network); 24 Jun 2020 12:53:19 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LW+cEvL5rxny3qTajLMBWIwk08EKQ6OtW1sh3tGLLCE=;
        b=SwlALUBjM1+ZG2aNp5NYL4X957j2/EuHJ1i+RXeSEK+bGUTvUDodJlhkT/TYikjXry
         F8447oklPrMQXIBRGvFamqWEdn/HZxP6qunIVAJ+dS3a6o4MMy4Oeob9Il6TXSqIDnQu
         chbAGq8+reKRsMiTS5wMlJLWlQvPJwC2xzF6TIraJ7lfYTcKGBc0tdgDk+nuFrH7OCiT
         SZst3nJfLYsDRmHicH8w6KiqeTBH6BrpKUJEKu+XrywHp7vwXSBMOddcGklPo/Vt7cQC
         hYxBUukTIad251SEh+Qh1KtHbPNF4kLviN1wlobP7e1FrUy2XEi0qS67m/OiTXMHh0nW
         eoFg==
X-Gm-Message-State: AOAM531+9YPiWErGxJcRSsjr6L47dbdDSZWX01ju5w4eeeFr0EweXvn/
	2llYaC4pgzDTptOsCjh2n/M=
X-Google-Smtp-Source: ABdhPJydf2a/ChBdgFCHlq0WCNjf8N9Yo8suilvVTsKI3Zox/8CKs38PB/PLjTY9T+3M/14w9UJfpg==
X-Received: by 2002:a17:90a:ab88:: with SMTP id n8mr20426086pjq.34.1593003187201;
        Wed, 24 Jun 2020 05:53:07 -0700 (PDT)
Date: Wed, 24 Jun 2020 12:53:05 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: Alexander Popov <alex.popov@linux.com>
Cc: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
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
Message-ID: <20200624125305.GG4332@42.do-not-panic.com>
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

Would be nice if we instead could pass an argument to make which lets
us enable this.

  Luis
