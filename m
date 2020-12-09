Return-Path: <SRS0=9xHr=FN=lists.openwall.com=kernel-hardening-return-20553-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEBFCC4361B
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Dec 2020 10:31:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D47E323B5D
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Dec 2020 10:31:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D47E323B5D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20553-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17441 invoked by uid 550); 9 Dec 2020 10:31:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13959 invoked from network); 9 Dec 2020 05:23:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Tqs2Bz7msoUPZyObgWN3xF+h9p+l/eCjvEQpWbPSSU=;
        b=OxsOUIM85/FYIPIB2R8Z1zNH6hhLEXdXRuOIyltjsnOhdz5a0A9+eE5h1rpwrsrPQr
         1bXqCha3Xg+zai8ciecNwe/HLZ3kOOJP34uXiIE8cSOdtq2rNDHl9X6xyg/E9r9wlBvh
         PmbqoP3V2IMQ7i2Obc87ZNu55h0VtVcejwoZzw07sPSZggoVY09+XnnId1dIIrxpBqvD
         jLrlbGRCUmCESTmyCYxcy89c+6kuLUnt/ZQYafUPlcP9pJgaTXuHm50LIKQls5hoiude
         YACweNLn3mWmGyxYsuIAPBe1LR/5D4OrYpBsn36s47Sw7LuDo+GFIB6j9dcOyrWEgeju
         FFFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Tqs2Bz7msoUPZyObgWN3xF+h9p+l/eCjvEQpWbPSSU=;
        b=i4y1SYfAj0gkefK9ho/tXp+g3bbWZtqIFjxiGXwxN8F+lKAdb2tdCrfqAHV7v7JnnV
         Cpi0FUPtDiDiSh94iJQX/zcadc8rpfOQnWe4VhnCquoLM037iM4z18H84qNGjZT3RJ1s
         O7ZpJc7sdxM2WIvtibhAmJVdgnjdN5y59ANPTFygeESHrFMKsLLIpei/ca1gm4saoHuj
         tm7dMwN2En6cXtGFLcNGwgHhL066E5aQ2Lq1/+vus9g5ygvn+NdCEjYOe8IkG7UsEOb9
         5Qamp/30eUQfNcda+hbMP8dlqGMi38aMHgZuG7yIMSEyax6fwoeR9iiNdlqf/g0251Z0
         M/Fg==
X-Gm-Message-State: AOAM532PGjlgudFACik9qJRs1i89syDNsmOBKdzDElT7kVH93iZl9ZPZ
	mgkzpZW1k2zx/0Ptmj+LLrI67EmdziyMRQuFFVEOkQ==
X-Google-Smtp-Source: ABdhPJxqk+LGhDRPp0umcyl3h6fe4zAxBkF8KehhsBTBAZyCA/jdz6XKfvdMdjdIFiZftrcAFMyYhQT0xlTg5L2ZAXg=
X-Received: by 2002:a05:6a00:acc:b029:198:2ba6:c0f6 with SMTP id
 c12-20020a056a000accb02901982ba6c0f6mr782498pfl.53.1607491410514; Tue, 08 Dec
 2020 21:23:30 -0800 (PST)
MIME-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
 <CAK8P3a1WEAo2SEgKUEs3SB7n7QeeHa0=cx_nO==rDK0jjDArow@mail.gmail.com>
 <CABCJKueCHo2RYfx_A21m+=d1gQLR9QsOOxCsHFeicCqyHkb-Kg@mail.gmail.com>
 <CAK8P3a1Xfpt7QLkvxjtXKcgzcWkS8g9bmxD687+rqjTafTzKrg@mail.gmail.com> <CAK8P3a3O65m6Us=YvCP3QA+0kqAeEqfi-DLOJa+JYmBqs8-JcA@mail.gmail.com>
In-Reply-To: <CAK8P3a3O65m6Us=YvCP3QA+0kqAeEqfi-DLOJa+JYmBqs8-JcA@mail.gmail.com>
From: =?UTF-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>
Date: Tue, 8 Dec 2020 21:23:18 -0800
Message-ID: <CAFP8O3L35sj117VJeE3pUPE2H4++z2g48Gfd-8Ca=CUtP1LVWw@mail.gmail.com>
Subject: Re: [PATCH v8 00/16] Add support for Clang LTO
To: Arnd Bergmann <arnd@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 8, 2020 at 1:02 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> On Tue, Dec 8, 2020 at 9:59 PM Arnd Bergmann <arnd@kernel.org> wrote:
> >
> > Attaching the config for "ld.lld: error: Never resolved function from
> >   blockaddress (Producer: 'LLVM12.0.0' Reader: 'LLVM 12.0.0')"
>
> And here is a new one: "ld.lld: error: assignment to symbol
> init_pg_end does not converge"
>
>       Arnd
>

This is interesting. I changed the symbol assignment to a separate
loop in https://reviews.llvm.org/D66279
Does raising the limit help? Sometimes the kernel linker script can be
rewritten to be more friendly to the linker...
