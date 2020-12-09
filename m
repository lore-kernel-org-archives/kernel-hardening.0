Return-Path: <SRS0=qCCG=FN=lists.openwall.com=kernel-hardening-return-20555-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD80DC433FE
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Dec 2020 16:11:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D621823A02
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Dec 2020 16:11:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D621823A02
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20555-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28518 invoked by uid 550); 9 Dec 2020 16:09:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28479 invoked from network); 9 Dec 2020 16:09:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nqyEOFHVM5Ky3nbjp7naROpurgTB2x9ZG+Hz5wH8wPU=;
        b=enl+HYZfvbCMKTqutKGkL4DEIVorJ/taYS/JJw+IfqHlE5cVy/zslMzRYwk2VdL0wr
         s43qvZaWjhm/0laGuZtBRiui2gDEsXPAouZwsdj9LIev9pb2X/bwrRXUz4XQTOg3gVSD
         oU/wAXdv54FAHrtCWR59AqwHnZVb1iQ5qyFEXrsxKVlxFgEsa1wy3FjVzPGnpuhILmIW
         zeGKaFuVPAWhnS6yaQBw6k4xASuW/5YzXjkd2dqGVGtP6DkVDRKUww9R9SaonJ1JE+Q9
         lzNtBdhD0wjbRFTlp/UFs5dlfE7SYVAYipT8+m8J2FPZ6M4UOJscZl9ID0t64scrmJIq
         Nq6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nqyEOFHVM5Ky3nbjp7naROpurgTB2x9ZG+Hz5wH8wPU=;
        b=WUjG+nQvFfJM1r+ACSCA7OMa3KmZqUkhQJMk20WVp8wQfcHzoi3O571JgsPXT+munu
         SfrkCXB9xG/eiHNQJfPDQAo8b4jIFl/G8N5uDobdaNtBuyoSES7MqSYqMCPDe940dQ9l
         BelB5ZDXrVrx80H5Fw0QjHZML+CPAwyJwq43czq/Q9GZtqSWTEpA9vdkdbzyemY43lDm
         WjxXxehEzik/ykf16eVBdIA5GhTEAeICcLY8O/7RnzKIWT43Q19Se3JMWg6a8TeNOfNS
         Q9QSuU32f18/Poi4nXoizHHtkca435luWT6JZPqJGjkGdQAC8RhvIfW1y7kfIQ0bh1ue
         6GTQ==
X-Gm-Message-State: AOAM532YVHWKO37qMzCuCD8K+H0A2uxbCix4BzxuPAD6BcKLBfKR+MkX
	OT7eAJztL28MrpDHpUoFqj5RfojUvCS37gI72EmioQ==
X-Google-Smtp-Source: ABdhPJygyHjARSrnsdIbp51NuTL1nsIMlAfXLy2zaWgCIgwi3WqDnANYwazmXhxW1QwBlbPUShTlfc50yzUmoDM5q7s=
X-Received: by 2002:a67:4341:: with SMTP id q62mr2124127vsa.14.1607530169863;
 Wed, 09 Dec 2020 08:09:29 -0800 (PST)
MIME-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
 <CAK8P3a1WEAo2SEgKUEs3SB7n7QeeHa0=cx_nO==rDK0jjDArow@mail.gmail.com>
 <CABCJKueCHo2RYfx_A21m+=d1gQLR9QsOOxCsHFeicCqyHkb-Kg@mail.gmail.com>
 <CAK8P3a1Xfpt7QLkvxjtXKcgzcWkS8g9bmxD687+rqjTafTzKrg@mail.gmail.com> <CAK8P3a3O65m6Us=YvCP3QA+0kqAeEqfi-DLOJa+JYmBqs8-JcA@mail.gmail.com>
In-Reply-To: <CAK8P3a3O65m6Us=YvCP3QA+0kqAeEqfi-DLOJa+JYmBqs8-JcA@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 9 Dec 2020 08:09:18 -0800
Message-ID: <CABCJKud-4p2CnTyC5qjREL+Z_q8sD6cYE-0QU7poVKALgoVcNQ@mail.gmail.com>
Subject: Re: [PATCH v8 00/16] Add support for Clang LTO
To: Arnd Bergmann <arnd@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 8, 2020 at 1:02 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> On Tue, Dec 8, 2020 at 9:59 PM Arnd Bergmann <arnd@kernel.org> wrote:
> >
> > Attaching the config for "ld.lld: error: Never resolved function from
> >   blockaddress (Producer: 'LLVM12.0.0' Reader: 'LLVM 12.0.0')"
>
> And here is a new one: "ld.lld: error: assignment to symbol
> init_pg_end does not converge"

Thanks for these. I can reproduce the "Never resolved function from
blockaddress" issue with full LTO, but I couldn't reproduce this one
with ToT Clang, and the config doesn't have LTO enabled:

$ grep LTO 0x2824F594_defconfig
CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y

Is this the correct config file?

Sami
