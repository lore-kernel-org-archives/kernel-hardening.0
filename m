Return-Path: <SRS0=VB16=FF=lists.openwall.com=kernel-hardening-return-20505-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC9BC83019
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Dec 2020 21:40:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ABF9520870
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Dec 2020 21:40:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LlVOL6rc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ABF9520870
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20505-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27867 invoked by uid 550); 1 Dec 2020 21:38:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27791 invoked from network); 1 Dec 2020 21:38:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pUrtE9bCHLR1tahsqjwEvkYE/b4ecWVyJ0MZJXEWDmk=;
        b=LlVOL6rcXHeSwM5BfXBlegfhvMNR6VZLsv8rQyvwqckYHKPxMBEs8sd4bBTAM/NLL3
         QfSrVdpBBi9HSJdB+f6fk0mhQ0BxaAKNFB0n1aU5/sn8CKof8rf6tGib5lo7AwsjVbtO
         gqVtBXLMhiTbrGlloNzu8T6tvpiz27BbcOnycLdGlVz2ugezRzd2JMoM2BqA3hcR6vKi
         EJm05Ay+yi6Dx/TQFmeOHCJIzxbERp6ltaL44JwVtSGrFOpvIsL8fv3iWmKklSxL111V
         30zMFkTFejU9xFkfvhVP0U7UVLEYPZ6PBtQsmlZrIayJ+SsfsJck0mktwWBdnyqd60yN
         cBiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pUrtE9bCHLR1tahsqjwEvkYE/b4ecWVyJ0MZJXEWDmk=;
        b=RI+RES8xVG5cKqWMxpxPmgDxaKea3i6EvU1oMRsM/TSBE575kxiJ8MTZUrw2uqRZl9
         9OvYfq+WzZpqn76ye7MZYGQtFVvPBa8NJIrFi+5wneuDJm/vxbhUGVg1iipSJS7bjtC8
         0+tW0gErH7OUaOieMzlXN+197Hz9LWFcD5yVl4oyylA6hwYdcaXSL95v8kMqtAN9TPxU
         AJ79GaAJcEXRQ4FPh5r2/ygsq471mLcvU5lZlxTI6R5vdnpr1gCbniL0e60eK8y1dR4u
         ghCcxj0cJcuJTVdhYbmcky3Oh565xX776qyoSjs23IzeA0SX4npuuy4ZK7qG84CGX1OA
         gRVw==
X-Gm-Message-State: AOAM530SV/ARKHZqjXEx198q0cfewznEynKcsw/dLsLezSxkwHYYb9nD
	cfevhoDcqp4L3Fl3is/4yaA0WynUtHCLx8ImV2Jjzg==
X-Google-Smtp-Source: ABdhPJyZHamjyZPb6fRzG5c1CShB2WPqyseO+WRJb2mo1g11IDe33LiL+wOMY00AgUGmgDLmQlcIjPJL3fjLk1JEgqs=
X-Received: by 2002:a67:f74f:: with SMTP id w15mr4961669vso.54.1606858708924;
 Tue, 01 Dec 2020 13:38:28 -0800 (PST)
MIME-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
 <20201130120130.GF24563@willie-the-truck> <202012010929.3788AF5@keescook> <CAKwvOdkcfg9ae_NyctS+3E8Ka5XqHXXAMJ4aUYHiC=BSph9E2A@mail.gmail.com>
In-Reply-To: <CAKwvOdkcfg9ae_NyctS+3E8Ka5XqHXXAMJ4aUYHiC=BSph9E2A@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Tue, 1 Dec 2020 13:38:17 -0800
Message-ID: <CABCJKudBfoE-Ya6_ZuS4d+DqOWObhFFU1bNe_NpfHroLvfOiyQ@mail.gmail.com>
Subject: Re: [PATCH v7 00/17] Add support for Clang LTO
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Kees Cook <keescook@chromium.org>, Will Deacon <will@kernel.org>, 
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

On Tue, Dec 1, 2020 at 11:51 AM 'Nick Desaulniers' via Clang Built
Linux <clang-built-linux@googlegroups.com> wrote:
>
> On Tue, Dec 1, 2020 at 9:31 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Mon, Nov 30, 2020 at 12:01:31PM +0000, Will Deacon wrote:
> > > Hi Sami,
> > >
> > > On Wed, Nov 18, 2020 at 02:07:14PM -0800, Sami Tolvanen wrote:
> > > > This patch series adds support for building the kernel with Clang's
> > > > Link Time Optimization (LTO). In addition to performance, the primary
> > > > motivation for LTO is to allow Clang's Control-Flow Integrity (CFI) to
> > > > be used in the kernel. Google has shipped millions of Pixel devices
> > > > running three major kernel versions with LTO+CFI since 2018.
> > > >
> > > > Most of the patches are build system changes for handling LLVM bitcode,
> > > > which Clang produces with LTO instead of ELF object files, postponing
> > > > ELF processing until a later stage, and ensuring initcall ordering.
> > > >
> > > > Note that v7 brings back arm64 support as Will has now staged the
> > > > prerequisite memory ordering patches [1], and drops x86_64 while we work
> > > > on fixing the remaining objtool warnings [2].
> > >
> > > Sounds like you're going to post a v8, but that's the plan for merging
> > > that? The arm64 parts look pretty good to me now.
> >
> > I haven't seen Masahiro comment on this in a while, so given the review
> > history and its use (for years now) in Android, I will carry v8 (assuming
> > all is fine with it) it in -next unless there are objections.
>
> I had some minor stylistic feedback on the Kconfig changes; I'm happy
> for you to land the bulk of the changes and then I follow up with
> patches to the Kconfig after.

These are included in v8, which I just sent out.

Sami
