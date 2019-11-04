Return-Path: <SRS0=tBgR=Y4=lists.openwall.com=kernel-hardening-return-17261-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78DFECA9EB5
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 Nov 2019 16:43:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C120C2089C
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 Nov 2019 16:43:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PjhxObLS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C120C2089C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17261-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16125 invoked by uid 550); 4 Nov 2019 16:43:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16102 invoked from network); 4 Nov 2019 16:43:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z61Nf+IXfPnYSf/CB16houpRDee1KdZw1ehNvN59rnE=;
        b=PjhxObLSYnDarkuAbAcbN/xcMBh9/RLTTwOBpfJMobbA2sy11V60GhbV1hoQ3TnrVQ
         MIGqkV7apEXKziLYFAgmPcnR7gDQ1QIfFx/fgaFfieqf9BvRpo2jDlght+XCs8RdEaeA
         x8ARi7tdM/WujTuWotF0tyekaX2W6yMiIuW12MuP0uaNGXCLGc9wvXUnbz0dJin1Q31V
         ddXKsHwKyEREN9TPTpjsetiMHoYvt7iPZtSmkRC9qkz3ySM678YNrAr5VbKNNH+CjtlH
         7GUkM+JblIdOMXy6FxStWdstKENAqGAK8jaJpNvnDfUZEztTCL3vbhro+Z+9dJyt/fJF
         aZjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z61Nf+IXfPnYSf/CB16houpRDee1KdZw1ehNvN59rnE=;
        b=uRT594ZyqXvWjrFR7W7ZOOcRFl3sLlZcyi5QJdmQFLuOWe6ZfeyHu+C/mc8SH5ooza
         VjDy4LOBhS2jlMfM7TKqBHGYua9+0cb712jVSmWA6asHgGw7/SCPRBCI7oN4To+CWhtk
         qf7bQaCAgHKayUUx53DUuyY6/kMtOF0MRNTCngahBye7FavrzOi7J4f8tqoBiL7lG2sR
         LG6aBxaG1cQGQ41hytHWGO3AwFZQQ+zIPaDxusRCtqX9+IpyUEmeiR/5sB7RljYzyjCk
         3CfbQIqsWBchhoMEkaLe04CzXLgfAHzhHxbrvOae3cDuprQv99RAGMLNVdc+YBCQx/MN
         mqbw==
X-Gm-Message-State: APjAAAXeH0bgESO8Tv03DbMM/CiSw9TfuRoGxBbNy1POQ5YnAgDvAmDX
	m9fjpUt5EYWsBeJ5Z0eAFmZlBoFvSU8wxzTW3X7cJQ==
X-Google-Smtp-Source: APXvYqyDVcfgLDeXQC3A5gJNX8/wN+mjRR+GghpG8/3JWVcJW3k8DuwIYEezXPcXMkAZs+NIu3TLNRNVKUeU+c1tML4=
X-Received: by 2002:a05:6102:36a:: with SMTP id f10mr8580793vsa.44.1572885775766;
 Mon, 04 Nov 2019 08:42:55 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191101221150.116536-1-samitolvanen@google.com> <20191101221150.116536-7-samitolvanen@google.com>
 <791fc70f7bcaf13a89abaee9aae52dfe@www.loen.fr>
In-Reply-To: <791fc70f7bcaf13a89abaee9aae52dfe@www.loen.fr>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 4 Nov 2019 08:42:43 -0800
Message-ID: <CABCJKuegREpQiJCY01B_=nsNJFFCkyxxp63tQOPT=h+yAPifyA@mail.gmail.com>
Subject: Re: [PATCH v4 06/17] scs: add accounting
To: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <dave.martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Jann Horn <jannh@google.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 4, 2019 at 5:13 AM Marc Zyngier <maz@kernel.org> wrote:
> Is there any reason why you're not consistently using only one of
> "#if IS_ENABLED(...)" or "#ifdef ...", but instead a mix of both?

This is to match the style already used in each file. For example,
fs/proc/meminfo.c uses #ifdef for other configs in the same function,
and include/linux/mmzone.h uses #if IS_ENABLED(...).

Sami
