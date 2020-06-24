Return-Path: <SRS0=Cf8i=AF=lists.openwall.com=kernel-hardening-return-19099-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF830C433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 14:02:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 12CA920724
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 14:02:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 12CA920724
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19099-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24450 invoked by uid 550); 24 Jun 2020 14:02:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22234 invoked from network); 24 Jun 2020 12:52:50 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ImZMVmJ6KLEqHAgKJ4c32f0nuRv6OUnQsFfctRSAXJo=;
        b=rp63CXNNmJdvi7EOVw0W1SXMcaY8vfg8HjVrKLrYU/ZL/9ZzGzFZbZoPvKv7RH0OLA
         +n5w5IxJHUGqe4rStlPTTvwGWxZiykxAxp3KzvdFv/FKPaGB/wN21dSqCcFENC69ph/x
         rRMncFE30RREd2Qhg0zf8qkeS3FGYNStdjcUeIYJc1vD4ScaLo+siZSNnlGnyz7XF5II
         YyndAjAwxq/FI38Dl1iOngRMZ3BjXUz5c419ueTYAbkTQdL0+Md1UNrU5hKrGno7UxYV
         vS25NqcHdAbWbj0Ikwrke6OZQ2BTupDNJV8vvwZ4Qhz6RJrflS/8jcCcqrwymXqsD2sk
         APjQ==
X-Gm-Message-State: AOAM532lhE9x/ENXW+mxkgSlbH0BvG3mRAexMEHvzpleVOOaFLSpmxE5
	yrTNZdDPbH7HjYNoa5LdYjk=
X-Google-Smtp-Source: ABdhPJzddnf/uaOk9Rgp8vbxcf8lUTdU8rjuvn4Wiik8YZvkhsAy30AnlKe/2Lxzs/SCBU/Spfu6GQ==
X-Received: by 2002:a63:2a8a:: with SMTP id q132mr21027891pgq.279.1593003158753;
        Wed, 24 Jun 2020 05:52:38 -0700 (PDT)
Date: Wed, 24 Jun 2020 12:52:36 +0000
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
Subject: Re: [PATCH v2 2/5] ARM: vdso: Don't use gcc plugins for building
 vgettimeofday.c
Message-ID: <20200624125236.GF4332@42.do-not-panic.com>
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

But why is skipping it safe?

  Luis
