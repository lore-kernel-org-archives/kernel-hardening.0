Return-Path: <SRS0=mpYU=FN=lists.openwall.com=kernel-hardening-return-20559-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F86C4361B
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Dec 2020 19:25:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6439723C31
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Dec 2020 19:25:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6439723C31
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20559-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24516 invoked by uid 550); 9 Dec 2020 19:24:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24493 invoked from network); 9 Dec 2020 19:24:53 -0000
X-Gm-Message-State: AOAM531VTcZTvtYBDHQDSjyQQdwlD1f2oC6EmBqVCJZxOYd6NYNcGyED
	FprQurS+y2+OHr2/DgZXzfBFupls7DSk8Fx5i20=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1607541880;
	bh=PZ3OfDYS58ZqvFY9CXvEZH4DVeL16HFv3jTodD2L44Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VIdtJMVmToMLsEqoyt3Bw07XE58IWwbXZOF/8vrKCAGHhqAdsjQZPJS4ga0NNbRG8
	 spLjREDJ4m3bTXixW4JfKn8XswUsOOLs2W9FkMCN+8Z3YFlyRmQSSNmHYmLYsCTxJD
	 zj0j4Ti2xsxMaim+W2o/IpIIHePjqUYsYAQemyp3ETe6u+EgUMbFRqz4LJTWkEkY3N
	 yX4xTcMaC0W5M9lOAIy2/yi5mhsM6Y6nT+IaGhBTpK2YLWIyyqcxfsxQlm4dbfRZ71
	 W8Vw21ekj4xBV3oG8wCADt5YbBnXr2ko3FbvYFKqtPvGaksKPDHteUs9DBPQtdgtsQ
	 AUPXqcO+wHU5g==
X-Google-Smtp-Source: ABdhPJxrF0JWWKfF8bdNN4CMhLw4IPsYEUqP84GKhCmRyu9bJHDs/0dxAJvZhfRzwJd+w8POtqSy2lbm6ieBc+qVqo4=
X-Received: by 2002:aca:44d:: with SMTP id 74mr2951158oie.4.1607541879572;
 Wed, 09 Dec 2020 11:24:39 -0800 (PST)
MIME-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
 <CAK8P3a1WEAo2SEgKUEs3SB7n7QeeHa0=cx_nO==rDK0jjDArow@mail.gmail.com>
 <CABCJKueCHo2RYfx_A21m+=d1gQLR9QsOOxCsHFeicCqyHkb-Kg@mail.gmail.com>
 <CAK8P3a1Xfpt7QLkvxjtXKcgzcWkS8g9bmxD687+rqjTafTzKrg@mail.gmail.com>
 <CAK8P3a3O65m6Us=YvCP3QA+0kqAeEqfi-DLOJa+JYmBqs8-JcA@mail.gmail.com> <CABCJKud-4p2CnTyC5qjREL+Z_q8sD6cYE-0QU7poVKALgoVcNQ@mail.gmail.com>
In-Reply-To: <CABCJKud-4p2CnTyC5qjREL+Z_q8sD6cYE-0QU7poVKALgoVcNQ@mail.gmail.com>
From: Arnd Bergmann <arnd@kernel.org>
Date: Wed, 9 Dec 2020 20:24:22 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0_QfKEQ=F_F9ZUaqzN7gGGGSrE6Zk=8+qxFgGap-X5OQ@mail.gmail.com>
Message-ID: <CAK8P3a0_QfKEQ=F_F9ZUaqzN7gGGGSrE6Zk=8+qxFgGap-X5OQ@mail.gmail.com>
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

On Wed, Dec 9, 2020 at 5:09 PM 'Sami Tolvanen' via Clang Built Linux
<clang-built-linux@googlegroups.com> wrote:
> On Tue, Dec 8, 2020 at 1:02 PM Arnd Bergmann <arnd@kernel.org> wrote:
> > On Tue, Dec 8, 2020 at 9:59 PM Arnd Bergmann <arnd@kernel.org> wrote:
> > >
> > > Attaching the config for "ld.lld: error: Never resolved function from
> > >   blockaddress (Producer: 'LLVM12.0.0' Reader: 'LLVM 12.0.0')"
> >
> > And here is a new one: "ld.lld: error: assignment to symbol
> > init_pg_end does not converge"
>
> Thanks for these. I can reproduce the "Never resolved function from
> blockaddress" issue with full LTO, but I couldn't reproduce this one
> with ToT Clang, and the config doesn't have LTO enabled:
>
> $ grep LTO 0x2824F594_defconfig
> CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y
>
> Is this the correct config file?

It is the right file, and so far this is the only defconfig on which I
see the "does not converge" error, so I don't have any other one.

I suspect this might be an issue in the version of lld that I have here
and unrelated to LTO, and I can confirm that I see the error
with LTO still disabled.

It seems to be completely random. I do see the bug on next-20201203
but not on a later one. I also tried bisecting through linux-next and
arrived at "lib: stackdepot: add support to configure STACK_HASH_SIZE",
which is almost certainly not related, other than just changing a few
symbols around.

      Arnd
