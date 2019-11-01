Return-Path: <SRS0=tLB8=YZ=lists.openwall.com=kernel-hardening-return-17249-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C43CA9ECF
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 22:36:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6DC57217D9
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 22:36:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bli3xmuB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DC57217D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17249-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30044 invoked by uid 550); 1 Nov 2019 22:36:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30024 invoked from network); 1 Nov 2019 22:36:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VOVEnixRZLxQkCHgEpMJYKVl9naG8q4Bhsey3a4BJyw=;
        b=Bli3xmuBt9/GwnfhQ+WLZeBpC+LGylrKEihKmG9wDJcaF6w3L/ZQ8vt3GI4YPWXFJQ
         5Om7iCdkbv/lP18+LV92eRVs401olXcWreQAxfwPfepVtiVSDh9+nHAn2/3d+gfz9UVm
         yMWAVezWZJNqsbBLHANyYxJW6QpG5vniX1o53MF1dl5bc0zwLsqDDWKMYaMNZ47JDbyE
         v0XCStgcgsGwANfNW7O2l7MqWzWiGoQksAS9QIjgoVFUAhEy6735xDLs92DbjUK8gYCH
         q+fHcZwm6Ytrc4SrW8PPtsChFVdCSMaGofeTewgiaGn6jHXy73Odpndaqn2pcpxNkMKy
         K1qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VOVEnixRZLxQkCHgEpMJYKVl9naG8q4Bhsey3a4BJyw=;
        b=psL9f3qhp6ZirO81wBCPR9JzyKNRqfYybz4SdYOkl3k20VU0zAOPusr4VeYvaR3mV2
         zkRz/HmGVvvjEbtGypCZ5PrlU2B7YdrqxOllDDTuJQv93XVzJUsS6JROuD48oQYy2PDG
         uGw0him6pd6C7P6dlwAlrxFrBB0tlQ8gueb6yEUlkcVEyv6TxM0WOqyhb+OdKWXVS+Pw
         4OMi2yFuL1JqzUojUl2EDBWyNezn7U8CO34dU/k8s4ux5rlT0zimGXEL2vzWOAs0yocX
         LounRS+502mShob3iQIvdlheuHfeGDCYSMU4XswmkW3V3+6bbP8nyP6jflm35J8K0kz7
         EIwg==
X-Gm-Message-State: APjAAAWPnyFB00BS3LHY6fGjxEl+3uNQlwmCWJhjw80dkFaH2Bl8H43c
	whDq4+sMuxUKMhTDifFkpKDkyOsjWaNl2Jsm3Do=
X-Google-Smtp-Source: APXvYqy3a3LpygwD50Ud81Z6exZF+LaVqLS3Tw+hEBAZP5UzR+Yt5u6jie3UaWjeMgSpzygcRllXXMsmSmfSgwH5eE4=
X-Received: by 2002:a2e:8852:: with SMTP id z18mr9873721ljj.230.1572647776833;
 Fri, 01 Nov 2019 15:36:16 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191101221150.116536-1-samitolvanen@google.com> <20191101221150.116536-6-samitolvanen@google.com>
In-Reply-To: <20191101221150.116536-6-samitolvanen@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 1 Nov 2019 23:36:05 +0100
Message-ID: <CANiq72=Z285XTHguDoL5Eq_7XRcounmBfscquFPRWk3BH5kLvA@mail.gmail.com>
Subject: Re: [PATCH v4 05/17] add support for Clang's Shadow Call Stack (SCS)
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Nov 1, 2019 at 11:12 PM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> This change adds generic support for Clang's Shadow Call Stack,
> which uses a shadow stack to protect return addresses from being
> overwritten by an attacker. Details are available here:
>
>   https://clang.llvm.org/docs/ShadowCallStack.html
>
> Note that security guarantees in the kernel differ from the
> ones documented for user space. The kernel must store addresses
> of shadow stacks used by other tasks and interrupt handlers in
> memory, which means an attacker capable reading and writing
> arbitrary memory may be able to locate them and hijack control
> flow by modifying shadow stacks that are not currently in use.
>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

Cheers,
Miguel
