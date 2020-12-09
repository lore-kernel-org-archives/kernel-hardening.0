Return-Path: <SRS0=m1Q+=FN=lists.openwall.com=kernel-hardening-return-20558-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70EB0C433FE
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Dec 2020 17:52:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 71936225AA
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Dec 2020 17:52:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71936225AA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20558-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10164 invoked by uid 550); 9 Dec 2020 17:52:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10142 invoked from network); 9 Dec 2020 17:52:04 -0000
X-Gm-Message-State: AOAM532BYPIDLbb4nrEXXvBvPeU50lcZa11iyY/tOvxN4RA60034Tw5u
	fvzF2duF4bnV8+u0bkG2UeEXTqUvIpdQIK/5P/8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1607536312;
	bh=PkhafiKufzKb4ug4EZv6MWBGYou8NhXyEMjpgO/uc5E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nO+yHSD0aD/myoaEBloVJSGAXz/9Z9jr2v13Ie8CZZquSOaxn9x54EWCBKPspHYr9
	 C7ov27bcIKqHGqsw0G2b+SRoGTpaMyzBiPtAowkH+Ri14rs1FZxhzgI1YDBJU3B6Yh
	 wsPQInRPENeXuhDzJK8x93nWLhePtzQbjVQ4JCq8GZAw33D4KaIEBkodUp45W78tZY
	 oMFyQlU9exNc1aSWvJld48xqQbYIdgpTXz8nY/aMrldCE2NXZTQj2Tn4uTZWfo1B5Q
	 6pvYNvOpCKBRZd+m8zIp2GDb95NKAzMEotGY/d8IZOzA4HjydrO2M2hq91pKktRA4J
	 D4lKm4IJ0IP/Q==
X-Google-Smtp-Source: ABdhPJwZtZIjXcrCwL02Q3BtuaRQhJR6T9E0Dq/dAi3/J5U0ZXsANoGU6mTtSwfetrFJDwqXgvlouDcEx+44OiL8SQA=
X-Received: by 2002:aca:bd0b:: with SMTP id n11mr2533645oif.11.1607536311473;
 Wed, 09 Dec 2020 09:51:51 -0800 (PST)
MIME-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
 <CAK8P3a1WEAo2SEgKUEs3SB7n7QeeHa0=cx_nO==rDK0jjDArow@mail.gmail.com>
 <CAK8P3a2DYDCjkqf7oqWFfBT_=rjyJGgnh6kBzUkR8GyvxsB6uQ@mail.gmail.com> <CABCJKud7ZC7_rXVmrF5PnDOMZTJX9iB7uYAa03YF-dkEojnBxg@mail.gmail.com>
In-Reply-To: <CABCJKud7ZC7_rXVmrF5PnDOMZTJX9iB7uYAa03YF-dkEojnBxg@mail.gmail.com>
From: Arnd Bergmann <arnd@kernel.org>
Date: Wed, 9 Dec 2020 18:51:34 +0100
X-Gmail-Original-Message-ID: <CAK8P3a04nQwJkK-CPWNzvfKavZnHQYzKX5OGB7Rm3Ee_62oXhA@mail.gmail.com>
Message-ID: <CAK8P3a04nQwJkK-CPWNzvfKavZnHQYzKX5OGB7Rm3Ee_62oXhA@mail.gmail.com>
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

On Wed, Dec 9, 2020 at 5:25 PM 'Sami Tolvanen' via Clang Built Linux
<clang-built-linux@googlegroups.com> wrote:
>
> On Wed, Dec 9, 2020 at 4:36 AM Arnd Bergmann <arnd@kernel.org> wrote:
> >
> > On Tue, Dec 8, 2020 at 1:15 PM Arnd Bergmann <arnd@kernel.org> wrote:
> >
> >
> > It seems to happen because of CONFIG_TRIM_UNUSED_KSYMS,
> > which is a shame, since I think that is an option we'd always want to
> > have enabled with LTO, to allow more dead code to be eliminated.
>
> Ah yes, this is a known issue. We use TRIM_UNUSED_KSYMS with LTO in
> Android's Generic Kernel Image and the problem is that bitcode doesn't
> yet contain calls to these functions, so autoksyms won't see them. The
> solution is to use a symbol whitelist with LTO to prevent these from
> being trimmed. I suspect we would need a default whitelist for LTO
> builds.

A built-in allowlist sounds good to me. FWIW, in the randconfigs so far, I only
saw five symbols that would need to be on it:

memcpy(), memmove(), memset(), __stack_chk_fail() and __stack_chk_guard

       Arnd
