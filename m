Return-Path: <SRS0=SbUE=FN=lists.openwall.com=kernel-hardening-return-20550-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1510BC4361B
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Dec 2020 09:20:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4234223B6B
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Dec 2020 09:20:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4234223B6B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20550-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11998 invoked by uid 550); 9 Dec 2020 09:20:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11974 invoked from network); 9 Dec 2020 09:20:14 -0000
X-Gm-Message-State: AOAM530Oz0HosexCaJgzjsVxXdYo9ksGKcnEY1QI474NF6UmCINoMbxP
	i+AyKHAfl2NQ/2vl9IAZ6nGg2O7z0HRVxh/QQwk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1607505602;
	bh=sq+XLLMMI02zOMjuS3XQlCpve1fu802tRE6ExZV+b3g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mz1eKySbhCwGkbLV5t4HHdidZSNRp8ep2zj81vQ3dh0zvGWrkZC0vdC/U4Z5jPmAH
	 RsnTv6T8UkgUu3/DI8noayHdoA5IW63jffV5Yigv6x4ThqUS8S8XXZBgjRo6/2V22P
	 Neet2n07dy7/2tSKL+VrUxyP820lngLG2tooHpd+2HtBgqaq710EfFpFaqc523AR0p
	 aKPqdimRV+XlnE7kRLf2ZjBWup+qF8eoxeo74A3Zu9WXLDv+QFuqON9l++c0Zo8DMI
	 XEzYRXAuANnx15CcJncBhcD2Qvq/D17T937D5R9aqTdMwgRshpTexvfuqVGmqAwMey
	 nLGve9ysgUwXw==
X-Google-Smtp-Source: ABdhPJzy1WH7QEwYKyjZFMswZieiJpvEKVPf4nSKGRTcgXdAouLHKE27qdaJY2tvlSq5f0mibXd6i944QYu2cZlqE1k=
X-Received: by 2002:aca:44d:: with SMTP id 74mr1104225oie.4.1607505601280;
 Wed, 09 Dec 2020 01:20:01 -0800 (PST)
MIME-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
 <CAK8P3a1WEAo2SEgKUEs3SB7n7QeeHa0=cx_nO==rDK0jjDArow@mail.gmail.com>
 <CABCJKueCHo2RYfx_A21m+=d1gQLR9QsOOxCsHFeicCqyHkb-Kg@mail.gmail.com> <20201209045554.fxlzrmxknakl2gdr@google.com>
In-Reply-To: <20201209045554.fxlzrmxknakl2gdr@google.com>
From: Arnd Bergmann <arnd@kernel.org>
Date: Wed, 9 Dec 2020 10:19:44 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1p8yKMKXB1cUpy-5PjehJGPX0SPNEx4VsMmqgOeR6fZg@mail.gmail.com>
Message-ID: <CAK8P3a1p8yKMKXB1cUpy-5PjehJGPX0SPNEx4VsMmqgOeR6fZg@mail.gmail.com>
Subject: Re: [PATCH v8 00/16] Add support for Clang LTO
To: Fangrui Song <maskray@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Dec 9, 2020 at 5:56 AM 'Fangrui Song' via Clang Built Linux
<clang-built-linux@googlegroups.com> wrote:
> On 2020-12-08, 'Sami Tolvanen' via Clang Built Linux wrote:
> >On Tue, Dec 8, 2020 at 4:15 AM Arnd Bergmann <arnd@kernel.org> wrote:
> >> So far I have
> >> not managed to get a working build out of it, the main problem so far being
> >> that it is really slow to build because the link stage only uses one CPU.
> >> These are the other issues I've seen so far:
>
> ld.lld ThinLTO uses the number of (physical cores enabled by affinity) by default.

Ah, I see.  Do you know if it's also possible to do something like
-flto=jobserver
to integrate better with the kernel build system?

I tend to run multiple builds under a top-level makefile with 'make
-j30' in order
to use 30 of the 32 threads and leave the scheduling to jobserver instead of
the kernel. If the linker itself is multithreaded but the jobserver
thinks it is a
single thread, could end up with 30 concurrent linkers each trying to use
16 cores.

> >> - CONFIG_CPU_BIG_ENDIAN doesn't seem to work with lld, and LTO
> >>   doesn't work with ld.bfd.
> >>   I've added a CPU_LITTLE_ENDIAN dependency to
> >>   ARCH_SUPPORTS_LTO_CLANG{,THIN}
> >
> >Ah, good point. I'll fix this in v9.
>
> Full/Thin LTO should work with GNU ld and gold with LLVMgold.so built from
> llvm-project (https://llvm.org/docs/GoldPlugin.html ). You'll need to make sure
> that LLVMgold.so is newer than clang. (Newer clang may introduce bitcode
> attributes which are unrecognizable by older LLVMgold.so/ld.lld)

The current patch series requires LLD:

config HAS_LTO_CLANG
       def_bool y
       depends on CC_IS_CLANG && CLANG_VERSION >= 110000 && LD_IS_LLD

Is this something we should change then, or try to keep it simple with the
current approach, leaving LTO disabled for big-endian builds and hosts without
a working lld?

       Arnd
