Return-Path: <SRS0=c+FH=FN=lists.openwall.com=kernel-hardening-return-20557-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05677C4361B
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Dec 2020 16:25:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2853123B1F
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Dec 2020 16:25:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2853123B1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20557-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28114 invoked by uid 550); 9 Dec 2020 16:25:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28089 invoked from network); 9 Dec 2020 16:25:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6iPujSFaRf63ICzfMH9y30wFs4tc+8uoN3o287lcAKc=;
        b=nzPpXpurtim/Xt5h6cpZ0FcvFvOqsIz73uPe8GdrX81v6Uzipkco7k/pVTqqXga/3b
         t+MHYk2nyM/C5LzuujzPgJdof9Lw0igpw+9YIzcLX2aV9A7LWZuzXeyuxEEk0n6rnxmr
         aB75dnMFiO0VIGfeysS0gVynJ82rbBrfZklB+Bzln+JpuyM1FmY2SW0AVlvT8AFlHmcv
         +k2dhUROuMIdDtrfh/AYyNOH6SNMuuXgt6E9DSBT8poKxOx/tZH9KA6OYlO1moFwCsec
         UN8w6J3OR3+Eg9iTGgpIl1yYNJAoycddhbXwnLvbb6Sd+NqVgZFEd0Hm1D7SxRunGlrN
         MppQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6iPujSFaRf63ICzfMH9y30wFs4tc+8uoN3o287lcAKc=;
        b=J+6p+r+Sdq8uWHE2CVCw8/0ysJQQ9ATV3NZ8CVCRMamtpqsWy08NPyZ98f2wKRQDZ/
         cFnbWmxFGbdYNUN/W++W7Dj04fOU5/dciR+diMITcTOnv+s+DsrRu/goPpjVhe+S9qZh
         kdevo7CwMVerm8Ibddkagx08Nsz1qvPT53gUf3ywgqfQY5xotN0u3C8v193mekAL3WVJ
         r9q1DSoHXzFBhSfwGdE++5NMBTf8NZ7XQqoUB4RNLY/4++pPjU9SXeWqS3oJzaWiRKB1
         6+8dM6AC7UPerwQ5Mo+HRBq61hoTbEoD/wDrPtIP0/PjGm+7Vv9iBpZuHhyfuwZnsuNe
         9XSw==
X-Gm-Message-State: AOAM531SYlWF7KUfQjAgoQvu3a6lKEIqKg4GA3U04bxeOxiKKQ+xdocp
	l+W8fRvGa4+NVMT/fN196C9vSytFIQWwRbbSvUX65w==
X-Google-Smtp-Source: ABdhPJyTSS/IMLVSvJ+ApeZ9gBaaSGKG/HtQ8GyhKk+KWuIUDMry01JIQBMoQq94UvqMYjXmfFLduigKrpEFXyqQG0Y=
X-Received: by 2002:a67:2cc1:: with SMTP id s184mr2651932vss.23.1607531124951;
 Wed, 09 Dec 2020 08:25:24 -0800 (PST)
MIME-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
 <CAK8P3a1WEAo2SEgKUEs3SB7n7QeeHa0=cx_nO==rDK0jjDArow@mail.gmail.com> <CAK8P3a2DYDCjkqf7oqWFfBT_=rjyJGgnh6kBzUkR8GyvxsB6uQ@mail.gmail.com>
In-Reply-To: <CAK8P3a2DYDCjkqf7oqWFfBT_=rjyJGgnh6kBzUkR8GyvxsB6uQ@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 9 Dec 2020 08:25:13 -0800
Message-ID: <CABCJKud7ZC7_rXVmrF5PnDOMZTJX9iB7uYAa03YF-dkEojnBxg@mail.gmail.com>
Subject: Re: [PATCH v8 00/16] Add support for Clang LTO
To: Arnd Bergmann <arnd@kernel.org>
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

On Wed, Dec 9, 2020 at 4:36 AM Arnd Bergmann <arnd@kernel.org> wrote:
>
> On Tue, Dec 8, 2020 at 1:15 PM Arnd Bergmann <arnd@kernel.org> wrote:
> >
> > - one build seems to have dropped all symbols the string operations
> > from vmlinux,
> >   so while the link goes through, modules cannot be loaded:
> >  ERROR: modpost: "memmove" [drivers/media/rc/rc-core.ko] undefined!
> >  ERROR: modpost: "memcpy" [net/wireless/cfg80211.ko] undefined!
> >  ERROR: modpost: "memcpy" [net/8021q/8021q.ko] undefined!
> >  ERROR: modpost: "memset" [net/8021q/8021q.ko] undefined!
> >  ERROR: modpost: "memcpy" [net/unix/unix.ko] undefined!
> >  ERROR: modpost: "memset" [net/sched/cls_u32.ko] undefined!
> >  ERROR: modpost: "memcpy" [net/sched/cls_u32.ko] undefined!
> >  ERROR: modpost: "memset" [net/sched/sch_skbprio.ko] undefined!
> >  ERROR: modpost: "memcpy" [net/802/garp.ko] undefined!
> >  I first thought this was related to a clang-12 bug I saw the other day, but
> >  this also happens with clang-11
>
> It seems to happen because of CONFIG_TRIM_UNUSED_KSYMS,
> which is a shame, since I think that is an option we'd always want to
> have enabled with LTO, to allow more dead code to be eliminated.

Ah yes, this is a known issue. We use TRIM_UNUSED_KSYMS with LTO in
Android's Generic Kernel Image and the problem is that bitcode doesn't
yet contain calls to these functions, so autoksyms won't see them. The
solution is to use a symbol whitelist with LTO to prevent these from
being trimmed. I suspect we would need a default whitelist for LTO
builds.

Sami
