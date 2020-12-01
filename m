Return-Path: <SRS0=MrW9=FF=lists.openwall.com=kernel-hardening-return-20487-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAEF0C64E7A
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Dec 2020 19:52:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C08E32151B
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Dec 2020 19:52:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MU1J+Qtj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C08E32151B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20487-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1437 invoked by uid 550); 1 Dec 2020 19:52:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1409 invoked from network); 1 Dec 2020 19:52:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zJhY8u/xgI3NwUsMsFhtkWUYc2YVhnaebCX5nl2Ru6Q=;
        b=MU1J+QtjrMYect596h5eTpeHLQFqd4jbXkWpVSHILQafJ7WMP2JUuLbw0ninWQShV1
         Eh1Oe/+AnHFQzAMXF+YolY5+IBS2Npa01AwORUkDKXWV9fN6mS0YrWE5aM6a3pZYPx6S
         JLerU25sXGp+vfE+oYX7kBAjMthNKxUcPBJv4x/QoiEHeCXBcp3zAnCtjXZmaSO6WA2s
         HCB+4snvQenMBOz4d/v8seIQWfzmgrh8oq6LB4iz4kseuvkRm/7U5F/adejklVLvC9oT
         HdfZ7iGJOuo4/PghZ//tjUdn1EGf0Y+yB9oLCUzML8c2pG3EpRP8Bmp/oVwP0eJ/gaA0
         55pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zJhY8u/xgI3NwUsMsFhtkWUYc2YVhnaebCX5nl2Ru6Q=;
        b=gMZkInIk+19puDIolfffMJn/iKO6xP8F1eIz7zk6y3GPMypcwRmm0hr1zhNhVbX+SP
         ZEBfSvsMFTboFR5ijIBBGrBYRnSY+gVdyCjYnmNtUFW3AGdOp6bGUrTzhqZD1ENWSpFj
         wNS04ge4qSPy1IhCIFjIy32fDMPwHRFCe1wN9Ab0fnhFktsUTpW8Ua7ALu8ra4OpsbE6
         KYBuYjCIGtJ6Ok88yC8+O/GOfixUIwJgnV4PszRIBGm7CQM/dOTZkkALn2jQ7ZPh5fWB
         XBzQB2++rUJPaRjK6AkMlyDkJr8MyBeiaANWaui2pb9VjFit5lSYda+B68Nhu4ljjJLB
         L5DQ==
X-Gm-Message-State: AOAM531dcRfmRUMj7j0SfzQvfsDDWG9tBpANPtYTZ83VLCpJ8VWxP82B
	/v7JdKAAUDVfLLZDgUWbaAszHcD4Gmucro2QzQYaUg==
X-Google-Smtp-Source: ABdhPJx3Xdxr6ftEvN+BqvqUknUxbXtsaIoy9RJVA4UseQm3v6s7H1av1h3KcgjU/+t+wKVVMgBfbefs2TutGOwyb1w=
X-Received: by 2002:a62:1896:0:b029:197:491c:be38 with SMTP id
 144-20020a6218960000b0290197491cbe38mr3997304pfy.15.1606852312900; Tue, 01
 Dec 2020 11:51:52 -0800 (PST)
MIME-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
 <20201130120130.GF24563@willie-the-truck> <202012010929.3788AF5@keescook>
In-Reply-To: <202012010929.3788AF5@keescook>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 1 Dec 2020 11:51:41 -0800
Message-ID: <CAKwvOdkcfg9ae_NyctS+3E8Ka5XqHXXAMJ4aUYHiC=BSph9E2A@mail.gmail.com>
Subject: Re: [PATCH v7 00/17] Add support for Clang LTO
To: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 1, 2020 at 9:31 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Nov 30, 2020 at 12:01:31PM +0000, Will Deacon wrote:
> > Hi Sami,
> >
> > On Wed, Nov 18, 2020 at 02:07:14PM -0800, Sami Tolvanen wrote:
> > > This patch series adds support for building the kernel with Clang's
> > > Link Time Optimization (LTO). In addition to performance, the primary
> > > motivation for LTO is to allow Clang's Control-Flow Integrity (CFI) to
> > > be used in the kernel. Google has shipped millions of Pixel devices
> > > running three major kernel versions with LTO+CFI since 2018.
> > >
> > > Most of the patches are build system changes for handling LLVM bitcode,
> > > which Clang produces with LTO instead of ELF object files, postponing
> > > ELF processing until a later stage, and ensuring initcall ordering.
> > >
> > > Note that v7 brings back arm64 support as Will has now staged the
> > > prerequisite memory ordering patches [1], and drops x86_64 while we work
> > > on fixing the remaining objtool warnings [2].
> >
> > Sounds like you're going to post a v8, but that's the plan for merging
> > that? The arm64 parts look pretty good to me now.
>
> I haven't seen Masahiro comment on this in a while, so given the review
> history and its use (for years now) in Android, I will carry v8 (assuming
> all is fine with it) it in -next unless there are objections.

I had some minor stylistic feedback on the Kconfig changes; I'm happy
for you to land the bulk of the changes and then I follow up with
patches to the Kconfig after.
-- 
Thanks,
~Nick Desaulniers
