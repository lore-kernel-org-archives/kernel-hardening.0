Return-Path: <SRS0=5d9i=FP=lists.openwall.com=kernel-hardening-return-20602-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCDE9C4361B
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 19:46:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0F5B223ED2
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 19:46:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F5B223ED2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20602-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9477 invoked by uid 550); 11 Dec 2020 19:45:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9454 invoked from network); 11 Dec 2020 19:45:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/GVocl/rVAcj1v7+L3CkLflCJiE2AVxirIhrJAn4j9I=;
        b=j6wtErheo/tU7Bgku48rFUp7+QuVUNnuFvm4+WHjLO+i9TITt6lIvVcYuCxCt0D5zr
         wt0AqGeFiL6zD1PZM6gCCXzvqZCmIa/mMNBAdqSFaN90xNjhJxBt3cPjAeI6aGZWyh2J
         aSzsfOJAyVUGu2N9CG5xyUzYwQPoojIjTlLew37TXG9fk7FBD8M0fyRV8SBlrBG4iDLp
         hdt3jr/PR7ND8Pwa0r0z9+teI3oKNpBxdk2hZHnlSZV5SJEzv1YMCqE4WeKDguhdwStR
         TJ0XBRW4A15pEotatZWXTxkVaTA1/Jbuzi5G/kRABz7yIjkZiKyc5NFC2//8p9RdXKpP
         t8Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/GVocl/rVAcj1v7+L3CkLflCJiE2AVxirIhrJAn4j9I=;
        b=nR49zy3wEvdzQBdFowC7F7mbig0j/rj67XMjxpLPe0spgj6gDDzQZXoWstZCEqNf72
         dCQCQxsnc6xrHJ0s9ZW8o5tgCljYJC75rhBJYzZj55CqIxZvlY+WbceHLezjoS1pqVYo
         AdlwUgezNVt9ZWql3jeQ30n0s4ZMe8hR1ChV6ASHIYy69qJp/hXPmrI2fgzhT960iogL
         l7qrvwBdVZc/sDp2bqP8Mp6qyU4kvCs760Y36b1pPVuf25C6Afhvikg+1Yt8y3XmEebE
         BF2jh1GXc1Z4S2FaJRvVNQE1tDWhTd+ShJPGQ4h5gF19KceBHNg3HPH5x0mblknEJmMm
         7lQg==
X-Gm-Message-State: AOAM532HYHKezhPsVzh5LkLCT/8enjFb09FW3ezz6t6fILlyrtfQlvcg
	bc4l0Aw+sA3ZDpbU3EnE3G5sVdsujl2KAC54SdoKjQ==
X-Google-Smtp-Source: ABdhPJyLi3u5pazCd7AZxoxIsGKooQfv8JjHoQ0mQ2RZg34nU+hpk7lseJFZlqEgqXK4lYT7c3zTsqncnUueyDqfmpM=
X-Received: by 2002:a62:1896:0:b029:197:491c:be38 with SMTP id
 144-20020a6218960000b0290197491cbe38mr13208868pfy.15.1607715941064; Fri, 11
 Dec 2020 11:45:41 -0800 (PST)
MIME-Version: 1.0
References: <20201211184633.3213045-1-samitolvanen@google.com>
 <20201211184633.3213045-7-samitolvanen@google.com> <202012111131.E41AFFCDB@keescook>
 <CABCJKueCJhwRL1T1k6EYpUy_-Rj85K98iz5FO6K+dZLY25z8_Q@mail.gmail.com>
In-Reply-To: <CABCJKueCJhwRL1T1k6EYpUy_-Rj85K98iz5FO6K+dZLY25z8_Q@mail.gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 11 Dec 2020 11:45:30 -0800
Message-ID: <CAKwvOdnBQiUeXCH9U9Cc3_4-UtC+jepV_-yD6usJRSMYjpNFrQ@mail.gmail.com>
Subject: Re: [PATCH v9 06/16] kbuild: lto: add a default list of used symbols
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Kees Cook <keescook@chromium.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 11, 2020 at 11:40 AM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> On Fri, Dec 11, 2020 at 11:32 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Fri, Dec 11, 2020 at 10:46:23AM -0800, Sami Tolvanen wrote:
> > > --- /dev/null
> > > +++ b/scripts/lto-used-symbollist
> > > @@ -0,0 +1,5 @@
> > > +memcpy
> > > +memmove
> > > +memset
> > > +__stack_chk_fail
> > > +__stack_chk_guard
> > > --
> > > 2.29.2.576.ga3fc446d84-goog
> > >
> >
> > bikeshed: Should this filename use some kind of extension, like
> > lto-user-symbols.txt or .list, to make it more human-friendly?
>
> Sure, I can rename this in the next version. Does anyone have strong
> opinions about the name and/or extension?

.txt extension would be fine.

-- 
Thanks,
~Nick Desaulniers
