Return-Path: <SRS0=JIRZ=2J=lists.openwall.com=kernel-hardening-return-17511-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD461C43603
	for <kernel-hardening@archiver.kernel.org>; Thu, 19 Dec 2019 16:35:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 192BE2053B
	for <kernel-hardening@archiver.kernel.org>; Thu, 19 Dec 2019 16:35:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="XYNY/1ju"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 192BE2053B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17511-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5578 invoked by uid 550); 19 Dec 2019 16:35:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5558 invoked from network); 19 Dec 2019 16:35:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q6MJKY5kaJhdcPD2Yij+K4j3QBznO/FzqxPRwZHg2tA=;
        b=XYNY/1juioQpuXWDwItjvluLKzqTb1s+LUDJh70eT+FynV6pmhNjrfR8rKpTN0Y4Vq
         95LNMIm35iIung4zroafpJpZMFHIQW6gyl0nMe0sXzlo0Usj/osB8dJgXFazZDihbiKk
         TXHN/eqPdNOFXyC7+ATLgVoMdiY/9k9+NozPc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q6MJKY5kaJhdcPD2Yij+K4j3QBznO/FzqxPRwZHg2tA=;
        b=fPUHImxnFY/dUkkQlUiOLfCcyTQS4uIwsDNN8QvHAPaTNusbiYdLMcGz/mT2OZxyjT
         Vss74HbkgZ8SMpzG+9kR9fdS4jGWL/fmWRo3b7GdmOfGTLWiXD2XhzzV9OKm5xeD3DMv
         8aXzUrpF4C/Gzjth/P2Zqwnfu+QXTGQ/uDWkuSDPPfOJGpdjYH2wmygL4v9trMhZIh8f
         Fd52k5VZlZJcECQpe/gtHBffUpn6BZev2v2pPj0T/y34SlfSbmF5RPVEvcP+xrKVfjvg
         TScAVhsHbV43ClR8/thzvw4lfBnuBs0vCoFb+7o0hfks1p0u7I1unZH7VgfXSVnIARLt
         qRsA==
X-Gm-Message-State: APjAAAWrv40IddPb2h7DVscytHjRFv/QbBsSec8O7bl5IsJpJze0JhW8
	mL+x9vhC7tKtg2b6ixkMP2kpId5aiko=
X-Google-Smtp-Source: APXvYqwSGoRLwdkus3DWrFFpgTd3QNwog3pu9tvMapy2inX5YysavnCRMGziqtn1WZmSJCGcZ/ApAw==
X-Received: by 2002:a05:6402:12d1:: with SMTP id k17mr10194862edx.291.1576773339937;
        Thu, 19 Dec 2019 08:35:39 -0800 (PST)
X-Received: by 2002:adf:ee92:: with SMTP id b18mr10865736wro.281.1576773336863;
 Thu, 19 Dec 2019 08:35:36 -0800 (PST)
MIME-Version: 1.0
References: <20191205000957.112719-1-thgarnie@chromium.org> <20191219133452.GM2827@hirez.programming.kicks-ass.net>
In-Reply-To: <20191219133452.GM2827@hirez.programming.kicks-ass.net>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Thu, 19 Dec 2019 08:35:25 -0800
X-Gmail-Original-Message-ID: <CAJcbSZEubkFN0BLugoBm8fsPrNWxfFCDytC3nYUepr74dQFS=w@mail.gmail.com>
Message-ID: <CAJcbSZEubkFN0BLugoBm8fsPrNWxfFCDytC3nYUepr74dQFS=w@mail.gmail.com>
Subject: Re: [PATCH v10 00/11] x86: PIE support to extend KASLR randomization
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Kristen Carlson Accardi <kristen@linux.intel.com>, Kees Cook <keescook@chromium.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	"H. Peter Anvin" <hpa@zytor.com>, "the arch/x86 maintainers" <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	Juergen Gross <jgross@suse.com>, Thomas Hellstrom <thellstrom@vmware.com>, 
	"VMware, Inc." <pv-drivers@vmware.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, 
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Will Deacon <will@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Jiri Slaby <jslaby@suse.cz>, 
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexios Zavras <alexios.zavras@intel.com>, 
	Allison Randal <allison@lohutok.net>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	virtualization@lists.linux-foundation.org, 
	Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Dec 19, 2019 at 5:35 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Wed, Dec 04, 2019 at 04:09:37PM -0800, Thomas Garnier wrote:
> > Minor changes based on feedback and rebase from v9.
> >
> > Splitting the previous serie in two. This part contains assembly code
> > changes required for PIE but without any direct dependencies with the
> > rest of the patchset.
>
> ISTR suggestion you add an objtool pass that verifies there are no
> absolute text references left. Otherwise we'll forever be chasing that
> last one..

Correct, I have a reference in the changelog saying I will tackle in
the next patchset because we still have non-pie references in other
places but the fix is a bit more complex (for exemple per-cpu) and not
included in this phase. I will add a better explanation in the next
message for patch v11.
