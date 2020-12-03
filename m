Return-Path: <SRS0=QSZ5=FH=lists.openwall.com=kernel-hardening-return-20525-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 907A2C433FE
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Dec 2020 18:48:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 50B8F207B6
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Dec 2020 18:48:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 50B8F207B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20525-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31996 invoked by uid 550); 3 Dec 2020 18:48:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31943 invoked from network); 3 Dec 2020 18:48:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ah+rD4wk+k3lncQwfhIaQxiXkvEJG1Frpy4Nqe+0q0U=;
        b=SKhZH7li060XYzleaCahQbBQsMynLjFbQa3EhTv77mq3GHRmSi61KzLCOLC1Z4ksaj
         pSJDPGDFnV9Yx/X3ETP86ugtkVzY02GZAgoZstjnPNK8KrdI1fjRRRcqwKuLoZ+iGFnw
         Mfp9TStTmlP08QQnKRNmpPAPNNvtn/NE5MsBi6vL6DIXPVYtfI8exjpC70eIc1jAi6hr
         IWUJKbfX69GJkb8hVQ58bQnKSKy9x1UkfpKRekYoEUXT0JpoySwIrh8/YFahuMWMIznf
         +OWbSKuFcovO+Pj5wPAfXa07brxfPV5prt3FbyqI8tm/0XTPi+MmqG20rvrPzlHjF8XG
         lj8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ah+rD4wk+k3lncQwfhIaQxiXkvEJG1Frpy4Nqe+0q0U=;
        b=JDWkFywDP0WYV2Uxj7PjJmK9FA+Ugeq6Dax/I5v60GPGqDjUdQ6OJ6L418z8lrjfVj
         V8tOEqPk07MovhTCvRa8YCMPqhbbKuIMBdWIR5YP8aeAowU7JRABdV8GcflxQCp70xAR
         4U6SwOfMgPELH0iLGrDbtVRHlizFvMkXDK4wBN7t1mg5HmpzrtQR/sLTk0e6rftw96xJ
         LfqJc0t/PDionpcahimEXEMHwqE7FdZ+fYGLv/GKOZORMQRw0C6TCs4jhoF24UMvPPLK
         u7tS2MVbArDqC8lFYNCxUTaifx1GozQ76Q25FX+rHKlJWpOdKUKmltGAFsADJh1gZntX
         +LfA==
X-Gm-Message-State: AOAM531UGvjA5jv3+ySG4Xa0jF98yFIotvdM737UfMVX3ybrcfmP/dfR
	2Ea6EU92MBiRN/5USayB+pciCl4Skt+4vpqm0STxRA==
X-Google-Smtp-Source: ABdhPJwWZ3eYDNgK+tyHhs3o/e9jTvYAkoSVCUaRgclpcuqt9dH748zpq6nj5Jt+rgjXHu/FF8NKz82dnl1j7RfAePA=
X-Received: by 2002:a67:f74f:: with SMTP id w15mr696164vso.54.1607021279552;
 Thu, 03 Dec 2020 10:47:59 -0800 (PST)
MIME-Version: 1.0
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-15-samitolvanen@google.com> <202010141549.412F2BF0@keescook>
 <CAK7LNAT350QjusoYCQEHDdoxAfTZjj82xp86O1qoNF=0u0PN-g@mail.gmail.com>
In-Reply-To: <CAK7LNAT350QjusoYCQEHDdoxAfTZjj82xp86O1qoNF=0u0PN-g@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Thu, 3 Dec 2020 10:47:48 -0800
Message-ID: <CABCJKue4Gg7gGA3cgpP-uiThxR=5Qh2Pq+KctGJN_GtStpf9Fg@mail.gmail.com>
Subject: Re: [PATCH v6 14/25] kbuild: lto: remove duplicate dependencies from
 .mod files
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, PCI <linux-pci@vger.kernel.org>, 
	X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Dec 3, 2020 at 10:00 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> On Thu, Oct 15, 2020 at 7:50 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Mon, Oct 12, 2020 at 05:31:52PM -0700, Sami Tolvanen wrote:
> > > With LTO, llvm-nm prints out symbols for each archive member
> > > separately, which results in a lot of duplicate dependencies in the
> > > .mod file when CONFIG_TRIM_UNUSED_SYMS is enabled. When a module
> > > consists of several compilation units, the output can exceed the
> > > default xargs command size limit and split the dependency list to
> > > multiple lines, which results in used symbols getting trimmed.
> > >
> > > This change removes duplicate dependencies, which will reduce the
> > > probability of this happening and makes .mod files smaller and
> > > easier to read.
> > >
> > > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > > Reviewed-by: Kees Cook <keescook@chromium.org>
> >
> > Hi Masahiro,
> >
> > This appears to be a general improvement as well. This looks like it can
> > land without depending on the rest of the series.
>
> It cannot.
> Adding "sort -u" is pointless without the rest of the series
> since the symbol duplication happens only with Clang LTO.
>
> This is not a solution.
> "reduce the probability of this happening" well describes it.
>
> I wrote a different patch.

Great, thanks for looking into this. I'll drop this patch from the next version.

Sami
