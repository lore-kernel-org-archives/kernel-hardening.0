Return-Path: <SRS0=/eib=AZ=lists.openwall.com=kernel-hardening-return-19309-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F96C433E3
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Jul 2020 17:54:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9A20E225A9
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Jul 2020 17:54:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rw2Ooa/4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A20E225A9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19309-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25789 invoked by uid 550); 14 Jul 2020 17:54:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25754 invoked from network); 14 Jul 2020 17:54:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=45xI8rEeWi7QXFwrqKcRbpSWjjoJSS/Qt/Ikgj5NGNk=;
        b=Rw2Ooa/4ydY2kuipZY7t3EHXuDLvDsaolNVYTbOw/NHk5Jj0yTma+nZMIhm0RimdW1
         4JfbmJtFIImxCLNF7Likd5JJ75qLUq1nUBH2EITFJdGdoeazyFh1iNO8AUdKQSjKGvkb
         vWPL6G0Ys/dM88zsh00Mm3C64zTOwNylvBlKCSCyQZmVrKUl2gs/OaYNb00wcMR4DAe7
         HqLTQu9936MuMSL6GVU2YNVrqJKkGAGTgtOqKFRzuK+QyPeCSCgh+hD/dBEIkV1NTSF1
         di8HEi1g5AXgcdN3uU8s7dqxHfQFyrPIIaOX6UfyK+tDEjX6rN6ML4r7djGwSQ0peH3h
         HIsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=45xI8rEeWi7QXFwrqKcRbpSWjjoJSS/Qt/Ikgj5NGNk=;
        b=LeuPrP9xAwAV+4eN1XCkQUD2spHXE4MHZNLqv3BI0y7BPLV9BGQDAS50bi1JyidsFD
         JHV0OMEpwOZmz59AJIe3TSSUh3Ik3e5RrvmrX1SpCRQX1tHv7hGDM9DUt+JneAo4gOuM
         z/HEb7TOUuSoHFF6WOsr4HvdDOOAVlui1RqyXVmuspkiWCX9a5ktv/Sms6GhzEZeMg5l
         IkkJ5+eEzqVs8jwOuhhyig1vVmkJmoJAKHdQMlQYMJlllV9qgmCAUh15a/Sp19M4TFXW
         g6bTFkYsPA92Hrb8mkGdkzlCiLaG67WluPsgyyczet7J/iiSVHJD+BeGv8bb+yaNaZ29
         OI2A==
X-Gm-Message-State: AOAM531wLp9O1w3Wex7Soz7Ru/9B8ESmxbF2TKIHF3IjRPiSaycbWn/d
	3bKYaG3E3GCe49B8EWEjOjO+CIAFLGOWAV3ZwbKmmQ==
X-Google-Smtp-Source: ABdhPJwcIBhuWQSJnb22Hu6ykmJZrRn50yho0jiA1jzvQkDPRjZ5DnsFPHJW6iYaLbzuW2WylixGSW07GgQyW7nvEuA=
X-Received: by 2002:a17:90a:21ef:: with SMTP id q102mr6056117pjc.101.1594749253773;
 Tue, 14 Jul 2020 10:54:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
 <671d8923-ed43-4600-2628-33ae7cb82ccb@molgen.mpg.de> <CA+icZUXPB_C1bjA13zi3OLFCpiZh+GsgHT0y6kumzVRavs4LkQ@mail.gmail.com>
 <20200712184041.GA1838@Ryzen-9-3900X.localdomain> <CA+icZUWyqb8jdzTAophvBKuX3e2NvG7vQPnMW+SRW5v0PmU7TA@mail.gmail.com>
In-Reply-To: <CA+icZUWyqb8jdzTAophvBKuX3e2NvG7vQPnMW+SRW5v0PmU7TA@mail.gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 14 Jul 2020 10:54:02 -0700
Message-ID: <CAKwvOdnFxihNnGYTsowzEbtMvb-pwv9pHNo-tihD2h74LX+H+g@mail.gmail.com>
Subject: Re: [PATCH 00/22] add support for Clang LTO
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>, Paul Menzel <pmenzel@molgen.mpg.de>, 
	Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Will Deacon <will@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Clang-Built-Linux ML <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jul 14, 2020 at 2:44 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> On Sun, Jul 12, 2020 at 8:40 PM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
> > Lastly, for the future, I would recommend grabbing b4 to easily apply
> > patches (specifically full series) from lore.kernel.org.
> >
> > https://git.kernel.org/pub/scm/utils/b4/b4.git/
> > https://git.kernel.org/pub/scm/utils/b4/b4.git/tree/README.rst
> >
> > You could grab this series and apply it easily by either downloading the
> > mbox file and following the instructions it gives for applying the mbox
> > file:
> >
> > $ b4 am 20200624203200.78870-1-samitolvanen@google.com
> >
> > or I prefer piping so that I don't have to clean up later:
> >
> > $ b4 am -o - 20200624203200.78870-1-samitolvanen@google.com | git am
> >
>
> It is always a pleasure to read your replies and enrich my know-how
> beyond Linux-kernel hacking :-).
>
> Thanks for the tip with "b4" tool.
> Might add this to our ClangBuiltLinux wiki "Command line tips and tricks"?
>
> - Sedat -
>
> [1] https://github.com/ClangBuiltLinux/linux/wiki/Command-line-tips-and-tricks

Good idea, done.

-- 
Thanks,
~Nick Desaulniers
