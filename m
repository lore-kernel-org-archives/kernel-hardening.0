Return-Path: <SRS0=YZIH=AF=lists.openwall.com=kernel-hardening-return-19151-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6931EC433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 23:06:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B632820738
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 23:06:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v4eMG/3r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B632820738
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19151-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11896 invoked by uid 550); 24 Jun 2020 23:06:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11864 invoked from network); 24 Jun 2020 23:06:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=shst53ZJE1d+vIhz2clceIGi2VB/auhmYdgL62EAsJA=;
        b=v4eMG/3rTtJikwtUeVEWC+d0Ch65aCTzn2lI4XytauNvCzrEjxfgA6aO+yV6VxXBx3
         mb6CDo0wNoFZ1v4nkYj+/6EWy37Ni5nLIOMzCNLEZ2dadozowAf9iZnCoXAn7+HLcyE9
         RoOT6e38CrOgiSMwqrLKdO8N7M+/LB2H0MPGEArcqToIp05l+M0z0UH0D4sz1uNsTgmt
         9mmpfTiacr3PdC/F4zU2Yb9SYNEeuuG0ifqnJKaNC2BdOBDaQw26XwaMnJ0wHebahY7x
         fvvlvTbNep+cdAWoA5BqhP7JrVtoCYLEUqHK25wchmImEauPU24++/TQpkcZFXvICfaj
         +O3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=shst53ZJE1d+vIhz2clceIGi2VB/auhmYdgL62EAsJA=;
        b=Jh+wk+Dk1upX4iNScHoITbN4voxOjuANT0xFYmFOJ2rCPSZ4yYRU7PzqnQC50Sz9Ue
         Re8psG4OODiKnlr0d1I2s9FGeuEGJhCR/la7+Ci04et/hErMWnwpOYE8trKJvzdX4w/5
         GelLbKxFRboWOQ191maFGdlCigTZxvalNLwG0IyrbQPebW8VojMecWp37CZMhwVu8U/o
         qzKwKAdDUbR7NLHfCzIn3v1hxzXH6iXEesRD7wKxeenQiWYcF81L9fI6Zhz4RATHQHci
         N41JWahCcB/RO580EPomFaYGG1tdW+4/OAqQZQzqnkQDkKmJK75ee7V1nKF9RkEXcLxD
         LuEA==
X-Gm-Message-State: AOAM530nRTjSfz+MKZNUCWDnvJkuOoAkZJYE6UFRmKTv+2IK6kv00a69
	rPL513uMlwHHqec9/K6x46dy+h2jue6NdtRbHPdYdg==
X-Google-Smtp-Source: ABdhPJxZs7Ep0+V5E2sSAX0aVY+ZMKk8PTjnuF9HO3m5vxhQOU6AbFmmPJG+dflauBb0xhpYFgB/b9UTwA/KqW822v8=
X-Received: by 2002:a17:902:fe8b:: with SMTP id x11mr30115455plm.179.1593039960944;
 Wed, 24 Jun 2020 16:06:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-18-samitolvanen@google.com> <CAKwvOdnEbCfYZ9o=OF51oswyqDvN4iP-9syWUDhxfueq4q0xcw@mail.gmail.com>
 <20200624215231.GC120457@google.com>
In-Reply-To: <20200624215231.GC120457@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 24 Jun 2020 16:05:48 -0700
Message-ID: <CAKwvOdnWfhU7n0VfoydC7epJPrj+ASZzyNRpBCNuvT_5E+=FcQ@mail.gmail.com>
Subject: Re: [PATCH 17/22] arm64: vdso: disable LTO
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jun 24, 2020 at 2:52 PM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> On Wed, Jun 24, 2020 at 01:58:57PM -0700, 'Nick Desaulniers' via Clang Built Linux wrote:
> > On Wed, Jun 24, 2020 at 1:33 PM Sami Tolvanen <samitolvanen@google.com> wrote:
> > >
> > > Filter out CC_FLAGS_LTO for the vDSO.
> >
> > Just curious about this patch (and the following one for x86's vdso),
> > do you happen to recall specifically what the issues with the vdso's
> > are?
>
> I recall the compiler optimizing away functions at some point, but as
> LTO is not really needed in the vDSO, it's just easiest to disable it
> there.

Sounds fishy; with extern linkage then I would think it's not safe to
eliminate functions.  Probably unnecessary for the initial
implementation, and something we can follow up on, but always good to
have an answer to the inevitable question "why?" in the commit
message.
-- 
Thanks,
~Nick Desaulniers
