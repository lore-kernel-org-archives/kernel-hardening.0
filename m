Return-Path: <SRS0=ts1m=H2=lists.openwall.com=kernel-hardening-return-20823-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACF4C433E6
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Feb 2021 20:17:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 00E7B60202
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Feb 2021 20:17:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00E7B60202
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20823-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11561 invoked by uid 550); 24 Feb 2021 20:17:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11533 invoked from network); 24 Feb 2021 20:17:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ylNlgfdcvRYOD6kXq/95XnGE6RgCAMqXvQ1uBMMg7TU=;
        b=RhNsZyzXgtTZGyid5j7nVxfjC5vdc5cxSATcD8rc+cg00YD/Uu1qopgE0wLckdrrfh
         AMbMPE6l42p5jtO2qEMlB6RBoiy/u6oeOfBKxB9YDRU+CyIdVN+OqiFMfONkZ5OBUyJT
         pYqWHcQ9YjSGTuxG6MK2ztRqiuOxyxd7MkbB895Aoxto9JgmmfUqRh2iu5hVc54oWKUI
         Gq97bliEvUmmhPnIPYtuOBB/ESNbs1xmeQ5jhfh/sAVUw4iaxufO7htAed0SwH5o4oJe
         scdddBN+FqryhHDKlk8OmTM346/xXlWpfcKrSkUNbd9PEEnxF6oU6vnbhOaAA+zbLoP9
         RTHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ylNlgfdcvRYOD6kXq/95XnGE6RgCAMqXvQ1uBMMg7TU=;
        b=EhO5p09pUmyUXBRF4CM5wAR/dV35DORSdM48r1CSjnbwXGKn/WQ4nszw/FomDsWhDC
         VqQQ6NTSagrOEBAiCW9aZKUsPa6jL+Xih7WgmSkPW90T6LbsyI7q2NfJigQoZYFm00kZ
         qT2ybczMs3D3hqDRuAYnfwrl3li2rqBCSbaERpoVEdSU9mD7kPPWg6qMhsKtO4jKu/Y+
         2w7vB6vvV9ITdTK0Vh7EA8GkoFDilVnr0YODkV2H1DAseV3I5b0BWVxF5l8Y3PzVTMU8
         s8SGOtQpyzEjiFRufWxTu55lnimQ4TaEJ2lgMCm1x+O8QHPHPlSzOj9GK8pBvlBlPXwQ
         hl1w==
X-Gm-Message-State: AOAM530ojkZJMhTKU2pcdFZ0z2eogpAbaq7Cx74fV/2/Qha8a96nPy5w
	gHDYi+gfxAz/UUm+eNh28Aw=
X-Google-Smtp-Source: ABdhPJzDBcW556aZO7mgeeunZgHfhSVx/5GFriwJvwVEbAj9sOwTknCGBEak65KhGzHJp7g/DrTp8Q==
X-Received: by 2002:aca:ad0d:: with SMTP id w13mr3743625oie.170.1614197845430;
        Wed, 24 Feb 2021 12:17:25 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 24 Feb 2021 12:17:23 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-parisc@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: Re: [PATCH v9 01/16] tracing: move function tracer options to
 Kconfig (causing parisc build failures)
Message-ID: <20210224201723.GA69309@roeck-us.net>
References: <20201211184633.3213045-1-samitolvanen@google.com>
 <20201211184633.3213045-2-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211184633.3213045-2-samitolvanen@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Fri, Dec 11, 2020 at 10:46:18AM -0800, Sami Tolvanen wrote:
> Move function tracer options to Kconfig to make it easier to add
> new methods for generating __mcount_loc, and to make the options
> available also when building kernel modules.
> 
> Note that FTRACE_MCOUNT_USE_* options are updated on rebuild and
> therefore, work even if the .config was generated in a different
> environment.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

With this patch in place, parisc:allmodconfig no longer builds.

Error log:
Arch parisc is not supported with CONFIG_FTRACE_MCOUNT_RECORD at scripts/recordmcount.pl line 405.
make[2]: *** [scripts/mod/empty.o] Error 2

Due to this problem, CONFIG_FTRACE_MCOUNT_RECORD can no longer be
enabled in parisc builds. Since that is auto-selected by DYNAMIC_FTRACE,
DYNAMIC_FTRACE can no longer be enabled, and with it everything that
depends on it.

Bisect log attached.

Guenter

---
# bad: [414eece95b98b209cef0f49cfcac108fd00b8ced] Merge tag 'clang-lto-v5.12-rc1-part2' of git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux
# good: [b12b47249688915e987a9a2a393b522f86f6b7ab] Merge tag 'powerpc-5.12-1' of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux
git bisect start '414eece95b98' 'b12b47249688'
# bad: [f6e1e1d1e149802ed4062fa514c2d184d30aacdf] Merge tag 'gfs2-for-5.12' of git://git.kernel.org/pub/scm/linux/kernel/git/gfs2/linux-gfs2
git bisect bad f6e1e1d1e149802ed4062fa514c2d184d30aacdf
# bad: [79db4d2293eba2ce6265a341bedf6caecad5eeb3] Merge tag 'clang-lto-v5.12-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux
git bisect bad 79db4d2293eba2ce6265a341bedf6caecad5eeb3
# good: [9d5032f97e9e0655e8c507ab1f43237e31520b00] dt-bindings: mediatek: mt8192: Fix dt_binding_check warning
git bisect good 9d5032f97e9e0655e8c507ab1f43237e31520b00
# good: [f81f213850ca84b3d5e59e17d17acb2ecfc24076] Merge tag 'for-linus-5.12-1' of git://github.com/cminyard/linux-ipmi
git bisect good f81f213850ca84b3d5e59e17d17acb2ecfc24076
# bad: [112b6a8e038d793d016e330f53acb9383ac504b3] arm64: allow LTO to be selected
git bisect bad 112b6a8e038d793d016e330f53acb9383ac504b3
# bad: [3578ad11f3fba07e64c26d8db68cfd3dde28c59e] init: lto: fix PREL32 relocations
git bisect bad 3578ad11f3fba07e64c26d8db68cfd3dde28c59e
# bad: [22d429e75f24d114d99223389d6ba7047e952e32] kbuild: lto: limit inlining
git bisect bad 22d429e75f24d114d99223389d6ba7047e952e32
# bad: [dc5723b02e523b2c4a68667f7e28c65018f7202f] kbuild: add support for Clang LTO
git bisect bad dc5723b02e523b2c4a68667f7e28c65018f7202f
# bad: [3b15cdc15956673ba1551d79bceae471436ac6a9] tracing: move function tracer options to Kconfig
git bisect bad 3b15cdc15956673ba1551d79bceae471436ac6a9
# first bad commit: [3b15cdc15956673ba1551d79bceae471436ac6a9] tracing: move function tracer options to Kconfig
