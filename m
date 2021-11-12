Return-Path: <SRS0=lZ1O=P7=lists.openwall.com=kernel-hardening-return-21466-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60DBEC433F5
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Nov 2021 21:26:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AE16B610FC
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Nov 2021 21:26:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AE16B610FC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 10208 invoked by uid 550); 12 Nov 2021 21:26:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10173 invoked from network); 12 Nov 2021 21:26:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ntZGBdiceWxX5bWKAyYQPAfUlf1Jy17/iBsUfaHjtvE=;
        b=WnpzkwgfwXofLeiX77Oe8YFgQJUod+ED3X+7zGSdhuhBdJ1F2P+TdKgmMLEdVL1SvZ
         /GS6JghHYzPxFbK4+NWebHaGgWNfR8ePRUJ+vL2ZwudXOMenfcKfNrB9ar+yxKCNchIc
         qL8+VW1E3C2BAaWeSIjvcK1Ufg0h/Rn5taTmc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ntZGBdiceWxX5bWKAyYQPAfUlf1Jy17/iBsUfaHjtvE=;
        b=pcy1VHAKMqK2BD/ZkFqPet6mxOIYz/AR0XXucXHmj15n3AT1k3T0YXwIBhF5jPo2fQ
         mn//AMwCKM4KW0r9ifRI1f+RixaGDWt2apW2wGXEP49x8P0Zj20+jfnR/Sn4XSEjQ8/Y
         WrrfXOfC2sbFDqUire7j3HotBIjllVDAZ47//4ap7JdoBqziB15trUXyX1qPOt1IIKxo
         hhrsQawg8zvT7UW4hAJ2sAS7LjIvYb3kvpAzV9KT1ju9jyQ2ecHicqsgPqvV/lsrR4iE
         jeeoOabSidi4rQyLhEEjOnIc28BvAckuNCIugh3mzhS+Yu+N85m8UdbxXzfI9enkuQW/
         Vi5w==
X-Gm-Message-State: AOAM532sFKgLxr83C8UCRPHtVJ6tHRU89o4u51gaNuiY5pfNmzAqaUur
	gc1ghDUXEBYocmjL6EDGQQY0oVZ8KWqfAHfYFxw=
X-Google-Smtp-Source: ABdhPJw2lCUXZvpm2sC1xqc0qdjbTsSoilES5cccvChCqvkMsaiu5OAnCu2mSkCS5B6ytqbVLRKEiQ==
X-Received: by 2002:a2e:9d05:: with SMTP id t5mr18802164lji.433.1636752391249;
        Fri, 12 Nov 2021 13:26:31 -0800 (PST)
X-Received: by 2002:adf:cf05:: with SMTP id o5mr22971280wrj.325.1636752379227;
 Fri, 12 Nov 2021 13:26:19 -0800 (PST)
MIME-Version: 1.0
References: <20211027233215.306111-1-alex.popov@linux.com> <ac989387-3359-f8da-23f9-f5f6deca4db8@linux.com>
In-Reply-To: <ac989387-3359-f8da-23f9-f5f6deca4db8@linux.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 12 Nov 2021 13:26:03 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgRmjkP3+32XPULMLTkv24AkA=nNLa7xxvSg-F0G1sJ9g@mail.gmail.com>
Message-ID: <CAHk-=wgRmjkP3+32XPULMLTkv24AkA=nNLa7xxvSg-F0G1sJ9g@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Introduce the pkill_on_warn parameter
To: Alexander Popov <alex.popov@linux.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Paul McKenney <paulmck@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Peter Zijlstra <peterz@infradead.org>, Joerg Roedel <jroedel@suse.de>, 
	Maciej Rozycki <macro@orcam.me.uk>, Muchun Song <songmuchun@bytedance.com>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Robin Murphy <robin.murphy@arm.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Petr Mladek <pmladek@suse.com>, Kees Cook <keescook@chromium.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Wei Liu <wl@xen.org>, John Ogness <john.ogness@linutronix.de>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Alexey Kardashevskiy <aik@ozlabs.ru>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Jann Horn <jannh@google.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Laura Abbott <labbott@kernel.org>, David S Miller <davem@davemloft.net>, Borislav Petkov <bp@alien8.de>, 
	Arnd Bergmann <arnd@arndb.de>, Andrew Scull <ascull@google.com>, Marc Zyngier <maz@kernel.org>, 
	Jessica Yu <jeyu@kernel.org>, Iurii Zaikin <yzaikin@google.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Wang Qing <wangqing@vivo.com>, 
	Mel Gorman <mgorman@suse.de>, Mauro Carvalho Chehab <mchehab+huawei@kernel.org>, 
	Andrew Klychkov <andrew.a.klychkov@gmail.com>, 
	Mathieu Chouquet-Stringer <me@mathieu.digital>, Daniel Borkmann <daniel@iogearbox.net>, Stephen Kitt <steve@sk2.org>, 
	Stephen Boyd <sboyd@kernel.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Mike Rapoport <rppt@kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-hardening@vger.kernel.org, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, notify@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, Nov 12, 2021 at 10:52 AM Alexander Popov <alex.popov@linux.com> wrote:
>
> Hello everyone!
> Friendly ping for your feedback.

I still haven't heard a compelling _reason_ for this all, and why
anybody should ever use this or care?

               Linus
