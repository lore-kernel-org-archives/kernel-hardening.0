Return-Path: <SRS0=3Mjb=DR=lists.openwall.com=kernel-hardening-return-20166-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE42C433E7
	for <kernel-hardening@archiver.kernel.org>; Sat, 10 Oct 2020 00:01:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2C69F221FD
	for <kernel-hardening@archiver.kernel.org>; Sat, 10 Oct 2020 00:01:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mijmHtCM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C69F221FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20166-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12250 invoked by uid 550); 10 Oct 2020 00:01:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12217 invoked from network); 10 Oct 2020 00:01:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NyEG6unrPY9TR7tF+FNQAaLApT1kctBGIfqP3l5IFb4=;
        b=mijmHtCMvGsgDu4uYd7w3AkGuavHKsRtISq1sPYHXYFaJw1WU+TYM2fX64XYscUKFv
         oU1cjxRYTJM1zp/QWqADJjTuB9hPhK+ZKhKINQnaiff6eqCzhX5w5wrxbRlGrJ0vyWiv
         ro3O+Z6DBIysL9dvjFawfl9YpJ7VnqXVeFq0auogXHWgzG/yIY2Ex8Vg0F1RLU4QxqSG
         bPLvghG+BsOIiRJ7zUxm1IgTps9IY/HH1VRZFA09lds3Gl17NZfWxvoZiUPcmFwlV7So
         V3Y3SV5Dt+Y35HFON8xSJwLyPjVkAmtWcAvVa4XffcGawnjsCdKwV9RsaQRB1eOPndHI
         e4Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NyEG6unrPY9TR7tF+FNQAaLApT1kctBGIfqP3l5IFb4=;
        b=JsjsNwaeqYi4bgudxaAqszU8krB65UmcbriKC6cOhKMuzMGGiwwzdAGj2rphuOplfc
         mMQU3Sb04ldGe9hQAKF8z7FYhO2xX9OTLOLWaQ5X4YDznXa8Xod626ImrEYVsVS2Pk7K
         dR9OcWJ8+X7B3uXykdsHfp7Cjgw1ro5uwaUusfmk5zKrMrVJ9OKw1WZx5F6/CHSVKeHn
         vKQD+xlz31GEvjoP8TZrqdolUtkAcHnbwW37/UBOsTC2erZxpmxg3FX17vszIcnHe9AK
         ZDcxJGIfn0RNrNzcGirgABTqB6JK6WXgGyQRhi8ZTJ3EZgXmQIdLDKbSH2OpjRikvfFq
         YFLA==
X-Gm-Message-State: AOAM5308CLdNWH9sm2fnyCpT3sMWd7JkwKzIntXtTj/Bgl8ez6+sHR/A
	N0E/tKfwa84X3xIVa97tZ3MHgKl+bwwqk1p65yk7CQ==
X-Google-Smtp-Source: ABdhPJygCrm7pkL/BYEq335cylOsmwx8yyljt1uWu6UwT8l62xqSHabdTtXkuhnBI7dZHTHKXqo8112Hls6msX6/ovk=
X-Received: by 2002:a50:dec9:: with SMTP id d9mr1852468edl.145.1602288062227;
 Fri, 09 Oct 2020 17:01:02 -0700 (PDT)
MIME-Version: 1.0
References: <20201009161338.657380-1-samitolvanen@google.com>
 <20201009153512.1546446a@gandalf.local.home> <20201009210548.GB1448445@google.com>
 <20201009193759.13043836@oasis.local.home>
In-Reply-To: <20201009193759.13043836@oasis.local.home>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 9 Oct 2020 17:00:51 -0700
Message-ID: <CABCJKueGW5UeH1++ES7ZRDcAnZ6hV-tFVwt6usjcZUnR95YQPQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/29] Add support for Clang LTO
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 9, 2020 at 4:38 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 9 Oct 2020 14:05:48 -0700
> Sami Tolvanen <samitolvanen@google.com> wrote:
>
> > Ah yes, X86_DECODER_SELFTEST seems to be broken in tip/master. If you
> > prefer, I have these patches on top of mainline here:
> >
> >   https://github.com/samitolvanen/linux/tree/clang-lto
> >
> > Testing your config with LTO on this tree, it does build and boot for
> > me, although I saw a couple of new objtool warnings, and with LLVM=1,
> > one warning from llvm-objdump.
>
> Thanks, I disabled X86_DECODER_SELFTEST and it now builds.
>
> I forced the objdump mcount logic with the below patch, which produces:
>
> CONFIG_FTRACE_MCOUNT_RECORD=y
> CONFIG_FTRACE_MCOUNT_USE_OBJTOOL=y
>
> But I don't see the __mcount_loc sections being created.
>
> I applied patches 1 - 6.

Patch 6 is missing the part where we actually pass --mcount to
objtool, it's in patch 11 ("kbuild: lto: postpone objtool"). I'll fix
this in v6. In the meanwhile, please apply patches 1-11 to test the
objtool change. Do you have any thoughts about the approach otherwise?

Sami
