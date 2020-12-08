Return-Path: <SRS0=Fj/H=FM=lists.openwall.com=kernel-hardening-return-20541-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B5EBC4361B
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Dec 2020 13:55:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A68B023A53
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Dec 2020 13:55:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A68B023A53
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20541-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3272 invoked by uid 550); 8 Dec 2020 13:55:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3249 invoked from network); 8 Dec 2020 13:55:24 -0000
X-Gm-Message-State: AOAM5303zVwMb2deVx32JGzBxRzDs4vroncxuZk3ULdobxT2o457y9k4
	9wn8nWnKO3+EHpIZqBF3R0Ut6qH8xG5hiis47o4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1607435711;
	bh=aMUeJmcHjLR1mxPMY4lSg5wm08l9vr2Dq3J8KhZCHss=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=N6+VRiKj1w/sHG04FJYJajgruVEl0d0kXpByOymHxPthCNLPJiukFzJ0fV2Fks4F3
	 f3OYCjwUjrh0Mlf1Q4sJGjiuG+CSXHTbFZTkrqCv+RKCMWkLCdkoGeXDRPUxmeCutZ
	 PvCcGNK3GKImyzLMtrB2yTw7+GoV0yDqsIR4dn7IMy5VKyojDA4DfYN2ZEygwOrw5h
	 yf899Lyg8XrtlHlrasiYJQpQD5/jtisPkmLxhy3aBeoCxaov7xm4Im/ELWLRl42Ocw
	 cizq88EGMi2nzasl/XChEgEAvqZzmNujCnkYUHPFgAM4zpJ9J9XBeHGGlR89vy8Yhi
	 rTnMXtxRGJrBQ==
X-Google-Smtp-Source: ABdhPJw84bKjNW6pc9lV2J+47WEe1njStGFQFPiO39biuyycOb/7NnBSKOzxngL0mEe4vYZqUHtN+LSV3ssbam6y5lc=
X-Received: by 2002:a1c:b4c4:: with SMTP id d187mr3984205wmf.38.1607435710266;
 Tue, 08 Dec 2020 05:55:10 -0800 (PST)
MIME-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com> <CAK8P3a1WEAo2SEgKUEs3SB7n7QeeHa0=cx_nO==rDK0jjDArow@mail.gmail.com>
In-Reply-To: <CAK8P3a1WEAo2SEgKUEs3SB7n7QeeHa0=cx_nO==rDK0jjDArow@mail.gmail.com>
From: Arnd Bergmann <arnd@kernel.org>
Date: Tue, 8 Dec 2020 14:54:28 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0AyciKoHzrgtaLxP9boo8WqZCe8YfPBzGPQ14PW_2KgQ@mail.gmail.com>
Message-ID: <CAK8P3a0AyciKoHzrgtaLxP9boo8WqZCe8YfPBzGPQ14PW_2KgQ@mail.gmail.com>
Subject: Re: [PATCH v8 00/16] Add support for Clang LTO
To: Sami Tolvanen <samitolvanen@google.com>
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

On Tue, Dec 8, 2020 at 1:15 PM Arnd Bergmann <arnd@kernel.org> wrote:
> On Tue, Dec 1, 2020 at 10:37 PM 'Sami Tolvanen' via Clang Built Linux <clang-built-linux@googlegroups.com> wrote:
>
> - many builds complain about thousands of duplicate symbols in the kernel, e.g.
>   ld.lld: error: duplicate symbol: qrtr_endpoint_post
>  >>> defined in net/qrtr/qrtr.lto.o
>  >>> defined in net/qrtr/qrtr.o
>  ld.lld: error: duplicate symbol: init_module
>  >>> defined in crypto/842.lto.o
>  >>> defined in crypto/842.o
>  ld.lld: error: duplicate symbol: init_module
>  >>> defined in net/netfilter/nfnetlink_log.lto.o
>  >>> defined in net/netfilter/nfnetlink_log.o
>  ld.lld: error: duplicate symbol: vli_from_be64
>  >>> defined in crypto/ecc.lto.o
>  >>> defined in crypto/ecc.o
>  ld.lld: error: duplicate symbol: __mod_of__plldig_clk_id_device_table
>  >>> defined in drivers/clk/clk-plldig.lto.o
>  >>> defined in drivers/clk/clk-plldig.o

A small update here: I see this behavior with every single module
build, including 'tinyconfig' with one module enabled, and 'defconfig'.

I tuned the randconfig setting using KCONFIG_PROBABILITY=2:2:1
now, which only enables a few symbols. With this I see faster build
times (obvioulsy), aroudn 30 seconds per kernel, and all small builds
with CONFIG_MODULES disabled so far succeed.
It appears that the problems I saw originally only happen for larger
configurations, or possibly a combination of Kconfig options that don't
happen that often on randconfig builds with low
KCONFIG_PROBABILITY.

      Arnd
