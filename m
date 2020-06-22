Return-Path: <SRS0=VFlK=AD=lists.openwall.com=kernel-hardening-return-19043-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C3D7C433DF
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 21:26:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6BC6A20732
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 21:26:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="J00hIsrX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6BC6A20732
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19043-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5969 invoked by uid 550); 22 Jun 2020 21:26:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5931 invoked from network); 22 Jun 2020 21:26:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+fGVHQGbJSfeZpDFh+8/BeMq0iFulsSXIRYour5Vm0w=;
        b=J00hIsrXU7lUbB9T6uH+6OCvgVWQVpgD3QI0ZPH4Hk8LTAUfUiRewvjxyBQzGiD1ve
         iFnCJBgzFqit6FhHqe5BM8n1JJmg8rHtVkq3RtopnM4OgUUVSs4z5vEKGujmdV8eaHzg
         QPi3H0BTKGLlJqCPNPE+nQs3/vQLHDYWXLkWY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+fGVHQGbJSfeZpDFh+8/BeMq0iFulsSXIRYour5Vm0w=;
        b=tDOQ7Jk+TjdXqUbM0+UvCCZ3ypcvxaKaj3OQ//hqyBe+HwoVSdUwauy+6wiD4gT0tk
         ml6Lv9ZnchB7QSNCQLP90111nOrsOmuqULraZWbNx37FbpwiQE9si3B35+U0REEybwx0
         uf5kJ3W60djjfCxZg4pZwSJ8XX/twGetwzuRiNDJ62SLtFWOfXS1Ojq3Lt7LOjqCweqb
         eO3Ahs4gIiX88dEEMVKk9pmjiMSEgN3iLVbaDH95WvgsxNVXNYbMpVqc58TkCDFM/BkY
         du7KpweHoEATcxJhUSSLyYYYKBpXS0mVDqGFofyvMIxE/Y1X3Gzmdf9/pMKE+LVN5uI3
         73qw==
X-Gm-Message-State: AOAM532bcF4Jq4sEf+DNi8vNe+9fmKAdgS/aJZrFBRulj983C+8mBcqA
	BglTy7K2dsz4+NqaMFYcz9q6wg==
X-Google-Smtp-Source: ABdhPJz9FSwoUGnk0FK8dRtqojR7DRsccJU6Ok7KN9Xp0A18XOCuQ0Au72MfAI1gfeRNqQL2b31VvQ==
X-Received: by 2002:aa7:8a4c:: with SMTP id n12mr22059315pfa.326.1592861187688;
        Mon, 22 Jun 2020 14:26:27 -0700 (PDT)
Date: Mon, 22 Jun 2020 14:26:25 -0700
From: Kees Cook <keescook@chromium.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>, kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/5] stack: Optionally randomize kernel stack offset
 each syscall
Message-ID: <202006221425.805E17B67@keescook>
References: <20200622193146.2985288-1-keescook@chromium.org>
 <20200622193146.2985288-4-keescook@chromium.org>
 <87a7b943-ed15-8521-773e-c182a37ee61e@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a7b943-ed15-8521-773e-c182a37ee61e@infradead.org>

On Mon, Jun 22, 2020 at 12:40:49PM -0700, Randy Dunlap wrote:
> On 6/22/20 12:31 PM, Kees Cook wrote:
> > This provides the ability for architectures to enable kernel stack base
> > address offset randomization. This feature is controlled by the boot
> > param "randomize_kstack_offset=on/off", with its default value set by
> > CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT.
> > 
> > Co-developed-by: Elena Reshetova <elena.reshetova@intel.com>
> > Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> > Link: https://lore.kernel.org/r/20190415060918.3766-1-elena.reshetova@intel.com
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  Makefile                         |  4 ++++
> >  arch/Kconfig                     | 23 ++++++++++++++++++
> >  include/linux/randomize_kstack.h | 40 ++++++++++++++++++++++++++++++++
> >  init/main.c                      | 23 ++++++++++++++++++
> >  4 files changed, 90 insertions(+)
> >  create mode 100644 include/linux/randomize_kstack.h
> 
> Please add documentation for the new kernel boot parameter to
> Documentation/admin-guide/kernel-parameters.txt.

Oops, yes. Thanks for the reminder!

(I wonder if checkpatch can notice "+early_param" and suggest the Doc
update hmmm)

-- 
Kees Cook
