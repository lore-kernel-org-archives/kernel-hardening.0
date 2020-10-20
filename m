Return-Path: <SRS0=ftsN=D3=lists.openwall.com=kernel-hardening-return-20227-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B466C4363A
	for <kernel-hardening@archiver.kernel.org>; Tue, 20 Oct 2020 16:42:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7DABF206CA
	for <kernel-hardening@archiver.kernel.org>; Tue, 20 Oct 2020 16:42:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tfuJ2Gp2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DABF206CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20227-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7418 invoked by uid 550); 20 Oct 2020 16:42:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7368 invoked from network); 20 Oct 2020 16:42:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I0Me8GLYPnUizRcS83SCdg5n9DP3MyuxXWUGsX9kdwo=;
        b=tfuJ2Gp25HcoLn6vQzFg/FlpBDVrTJM4WZSgfzcc71/zuwb0Z8cOnvVDcVg7AvWetz
         GCQc0hSrAqL9XyYGWEdE/WHErNG5NwiM5gYRiS/Dma7YyZ/uKKX0UQEqHNOvUsToYLEz
         gKcG3ooORmkHxsVLC8HexjR4k1Iznz7r+NHxCur1rf47A9/IRfzPLMW3d2G8bvCcT2ua
         LC6mV4VONnO5tXddBXbeMhC7r6Dkb5arC6K3ULSyW0F38DmQpJCAKkbfL8iqCrcvV/Ow
         nKYxKk27OmxwFsD/yIPmnbHjMCB59eESmtQhAD9oGOfpAr11KUzuq5JDZ3PzBnCnMGHt
         HqQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I0Me8GLYPnUizRcS83SCdg5n9DP3MyuxXWUGsX9kdwo=;
        b=jov3n5frKQkLSpZ0XhsRLPbH+addF1vNWEZE2Nwm4C9dMz4dWrajUxoIDCu9iGEn+J
         dd1xBQqwBMu2CcK3egRS4P1SNHmOTSLSL+VAMsu+8xAQlR4JPYZDziYRwP9Vx8ZMbn5X
         XCASVmmiEGJAYLinxksizDXSBOaokWhwQnVQdvfB5TiOexgqsbL2/eiXPAmB6gOP4SJQ
         RPv+Yn4iRvHhFElf52q/A1K30YoUEd+Ib5C+BQLv4tepw+/tLWhx7PtF5Vq2zmANwvQp
         IfEaXImiKqUPTtd+bCRZI/k9v2N+7/WNNHeHcW19WEW7BHezEn7eNlPbrQLVUZr/Khmi
         EVRA==
X-Gm-Message-State: AOAM533hgamqMGgOmhotc9ukb8cvq4FfJEvE0AfcAbXtRIe43x8dz6M4
	Pp2KFU95jbPyoFEA8f6yUxqZcCxFwoYtzoXsgoOR9Q==
X-Google-Smtp-Source: ABdhPJwmj1gLFyiZCwLnUyczZ5AtIrV1PckIn++9ZnSSTXEbEsuDOOrXLOt8ass9IoAu0owy+lwv/OR68pPkcbeDkWE=
X-Received: by 2002:aa7:c390:: with SMTP id k16mr3866300edq.40.1603212136160;
 Tue, 20 Oct 2020 09:42:16 -0700 (PDT)
MIME-Version: 1.0
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-14-samitolvanen@google.com> <202010141548.47CB1BC@keescook>
In-Reply-To: <202010141548.47CB1BC@keescook>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Tue, 20 Oct 2020 09:42:05 -0700
Message-ID: <CABCJKuf8=2A5fAY0rEZAWBw7q-PO8iFvmubGy4bj6GLZ7k8c9g@mail.gmail.com>
Subject: Re: [PATCH v6 13/25] kbuild: lto: merge module sections
To: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Oct 14, 2020 at 3:49 PM Kees Cook <keescook@chromium.org> wrote:
> In looking at this again -- is this ifdef needed? Couldn't this be done
> unconditionally? (Which would make it an independent change...)

No, I suppose it's not needed. I can drop the ifdef from the next version.

Sami
