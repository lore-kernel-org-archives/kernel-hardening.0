Return-Path: <SRS0=/WyM=D6=lists.openwall.com=kernel-hardening-return-20259-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B392C4363A
	for <kernel-hardening@archiver.kernel.org>; Fri, 23 Oct 2020 18:05:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3E004241A4
	for <kernel-hardening@archiver.kernel.org>; Fri, 23 Oct 2020 18:05:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H446iHuF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E004241A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20259-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29953 invoked by uid 550); 23 Oct 2020 18:05:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29933 invoked from network); 23 Oct 2020 18:05:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z2CWJzY4MEDXxaHnxhlpdNlYwFX3Mo9zkPfuZorsI9Y=;
        b=H446iHuFmhIJ0PjfsWOZIKXkYAAiR/qMysy2kifq9bqj5rLg66KEEyAVqwEd6WbUps
         sED9acTBSiZNv81RCdLvgIloMgQLDb+aFM5BPO1vDUgmdb53vkLHOMlLeHPYF5J2GI/9
         Z+MbNrJoO74axniKTBHA3C1/D9nDIjz1K4lJHHNl2nRfv6LOv+lKtXlKdyYXYoGp5NB+
         7T7nAiEeuvoEbWogVAiqxDBfix5RG4KG371ZC7nDh6hwqBoQCAIdn40mLA4qNCiMwGEZ
         AovbwwbjEYw2V+/jU9UAf4YaXaxsLPa2O+0f0DuRvcHS0eEwto36FosnHGYs9K20Iwe3
         qTlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z2CWJzY4MEDXxaHnxhlpdNlYwFX3Mo9zkPfuZorsI9Y=;
        b=OGtAFub+5Ta4kjUigoifBwoBcCnifAmmo1tNwowGWTcNr/ayxHjidgCvmp5KVutGyh
         oOjp+n85/RdA/CSdbZQHI1y5C/FTKi7ClxTSFXbG0IgNOD7+ckLzJMuDJ8KIvCF8eZ/p
         sn7WFo5V8iJSEsNV0Ph/Sfn4saC6MfuhYeRmP5JcBOHKg27qHg6DeZ+YGQ45kiz9M6uB
         LPgllpjNUY+kBSysD0Z02ubKCXcrcUw3K/sOnbUDPPFAHXXnIB2fR0CsfWmul6wysPZM
         QE020dBuhDANHDqW/xiFrVrvPURY0SQCIcJfBde7iqgw4yeBas82nqWfTxOy8wfAJMBx
         o8YA==
X-Gm-Message-State: AOAM533YQzHTJ6jQ7Z84gmsJwgrGXsRnlxCm4NZYmRlaXSOCJCpJddSN
	QpUXEX2bgTsvZSJXrChkUGKQ9Cr926iMHsaGIu7jlg==
X-Google-Smtp-Source: ABdhPJwlSbFR06Dbf2v2Zs9Rk9xNmHPrLyORGSrOkf63VY1RitmJdrnqA+NYcyLnEJ0BT0Cjn2BIz92MfzdbNr+EW3s=
X-Received: by 2002:a63:70d:: with SMTP id 13mr3178657pgh.263.1603476294852;
 Fri, 23 Oct 2020 11:04:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez2baAvKDA0wfYLKy-KnM_1CdOwjU873VJGDM=CErjsv_A@mail.gmail.com>
 <20201015102216.GB2611@hirez.programming.kicks-ass.net> <20201015203942.f3kwcohcwwa6lagd@treble>
 <CABCJKufDLmBCwmgGnfLcBw_B_4U8VY-R-dSNNp86TFfuMobPMw@mail.gmail.com>
 <20201020185217.ilg6w5l7ujau2246@treble> <CABCJKucVjFtrOsw58kn4OnW5kdkUh8G7Zs4s6QU9s6O7soRiAA@mail.gmail.com>
 <20201021085606.GZ2628@hirez.programming.kicks-ass.net> <20201021093213.GV2651@hirez.programming.kicks-ass.net>
 <20201021212747.ofk74lugt4hhjdzg@treble> <20201022072553.GN2628@hirez.programming.kicks-ass.net>
 <20201023174822.GA2696347@google.com>
In-Reply-To: <20201023174822.GA2696347@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 23 Oct 2020 11:04:43 -0700
Message-ID: <CAKwvOdnovKJCv05wHLY28ngqkoR-mU_xoyVmv0rNzWE1C=SNMg@mail.gmail.com>
Subject: Re: [PATCH v6 22/25] x86/asm: annotate indirect jumps
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Jann Horn <jannh@google.com>, "the arch/x86 maintainers" <x86@kernel.org>, 
	Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 23, 2020 at 10:48 AM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> On Thu, Oct 22, 2020 at 09:25:53AM +0200, Peter Zijlstra wrote:
> > > There's a new linker flag for renaming duplicates:
> > >
> > >   https://sourceware.org/bugzilla/show_bug.cgi?id=26391
> > >
> > > But I guess that doesn't help us now.
> >
> > Well, depends a bit if clang can do it; we only need this for LTO builds
> > for now.
>
> LLD doesn't seem to support -z unique-symbol.

https://github.com/ClangBuiltLinux/linux/issues/1184
-- 
Thanks,
~Nick Desaulniers
