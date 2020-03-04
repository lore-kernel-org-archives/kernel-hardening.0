Return-Path: <SRS0=d/pm=4V=lists.openwall.com=kernel-hardening-return-18061-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A31D7C3F2CE
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Mar 2020 19:20:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 008492146E
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Mar 2020 19:20:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="nDBn0SdZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 008492146E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18061-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15429 invoked by uid 550); 4 Mar 2020 19:20:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15409 invoked from network); 4 Mar 2020 19:20:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cFsbFw0YKq63mN4kk6cHyhQWkj6+cfAUWsGxTYtg/zw=;
        b=nDBn0SdZFqEAWyplGDuVVyCUbVweD3UVmTUas+PF5dDOYARN/7YmBRHICsQ65dOabg
         1CV71i2U64XmzdBXXOUhdWzg3vyWxAZOcINdLaJ3/Dz245ZCnNgJv2yPIGfjoCB19RyP
         c0pOAlPq9+G9kihFmOZZfCArlHHOjP6Zlf8cc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cFsbFw0YKq63mN4kk6cHyhQWkj6+cfAUWsGxTYtg/zw=;
        b=H295NigepLEV4roHYtdpxlBeqKHSfzb30LK4hPgejubbL0wVZmYHl+MEy86d9LMiMj
         YAfPWFD0xb6wniHoNj86PmWwdAe2BaXqKa/UcCXyl1ytWUbZUOKQybX1bCKW8TC3vRno
         0r4b2r1/uZrd+VTaNjDz6ogz0Umm9WwUNuaJg/MXMRmOLAVVDJpJ1i1HHFNI0O25Ox4I
         u+KFwG7gDRasoro53xARawtRom+bBLwWMoSi74gGGBcSAklkFIIgT1Vgcd5JvxjXfqki
         NBWSDCGnCycS4neuID48eAYTD8kiMuq85dB9iBtaSL3tVa6bOwQPno3gcZgbhkxXOIb8
         sF3Q==
X-Gm-Message-State: ANhLgQ2uCYpCcGPyFSmM/I6GY1BAN/2E3FnjKKxIUtCKj8U3Trn81iY1
	21f9iJFtuzZbR7xa4JUG2nfY+dSn1MQ=
X-Google-Smtp-Source: ADFU+vsERHvXqGV8aFtywVWnXMjUcWC1vYectCwaYFeHWn/jwOMpVW9AoJbAkpp4EPWGbgor2R/Mww==
X-Received: by 2002:a17:906:bb03:: with SMTP id jz3mr3970217ejb.324.1583349599085;
        Wed, 04 Mar 2020 11:19:59 -0800 (PST)
X-Received: by 2002:a7b:c4cb:: with SMTP id g11mr5219880wmk.83.1583349596173;
 Wed, 04 Mar 2020 11:19:56 -0800 (PST)
MIME-Version: 1.0
References: <20200228000105.165012-1-thgarnie@chromium.org>
 <202003022100.54CEEE60F@keescook> <20200303095514.GA2596@hirez.programming.kicks-ass.net>
 <CAJcbSZH1oON2VC2U8HjfC-6=M-xn5eU+JxHG2575iMpVoheKdA@mail.gmail.com>
 <6e7e4191612460ba96567c16b4171f2d2f91b296.camel@linux.intel.com>
 <202003031314.1AFFC0E@keescook> <20200304092136.GI2596@hirez.programming.kicks-ass.net>
 <202003041019.C6386B2F7@keescook> <e60876d0-4f7d-9523-bcec-6d002f717623@zytor.com>
In-Reply-To: <e60876d0-4f7d-9523-bcec-6d002f717623@zytor.com>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Wed, 4 Mar 2020 11:19:44 -0800
X-Gmail-Original-Message-ID: <CAJcbSZHBB1u2Vq0jZKsmd0UcRj=aichxTtbGvbWgf8-g8WPa7w@mail.gmail.com>
Message-ID: <CAJcbSZHBB1u2Vq0jZKsmd0UcRj=aichxTtbGvbWgf8-g8WPa7w@mail.gmail.com>
Subject: Re: [PATCH v11 00/11] x86: PIE support to extend KASLR randomization
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, 
	Kristen Carlson Accardi <kristen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Juergen Gross <jgross@suse.com>, 
	Thomas Hellstrom <thellstrom@vmware.com>, "VMware, Inc." <pv-drivers@vmware.com>, 
	"Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Jiri Slaby <jslaby@suse.cz>, 
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Cao jin <caoj.fnst@cn.fujitsu.com>, Allison Randal <allison@lohutok.net>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	virtualization@lists.linux-foundation.org, 
	Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Mar 4, 2020 at 10:45 AM H. Peter Anvin <hpa@zytor.com> wrote:
>
> On 2020-03-04 10:21, Kees Cook wrote:
> > On Wed, Mar 04, 2020 at 10:21:36AM +0100, Peter Zijlstra wrote:
> >> But at what cost; it does unspeakable ugly to the asm. And didn't a
> >> kernel compiled with the extended PIE range produce a measurably slower
> >> kernel due to all the ugly?
> >
> > Was that true? I thought the final results were a wash and that earlier
> > benchmarks weren't accurate for some reason? I can't find the thread
> > now. Thomas, do you have numbers on that?

I have never seen a significant performance impact. Performance and
size is better on more recent versions of gcc as it has better
generation of PIE code (for example generation of switches).

> >
> > BTW, I totally agree that fgkaslr is the way to go in the future. I
> > am mostly arguing for this under the assumption that it doesn't
> > have meaningful performance impact and that it gains the kernel some
> > flexibility in the kinds of things it can do in the future. If the former
> > is not true, then I'd agree, the benefit needs to be more clear.
> >
>
> "Making the assembly really ugly" by itself is a reason not to do it, in my
> Not So Humble Opinion[TM]; but the reason the kernel and small memory models
> exist in the first place is because there is a nonzero performance impact of
> the small-PIC memory model. Having modules in separate regions would further
> add the cost of a GOT references all over the place (PLT is optional, useless
> and deprecated for eager binding) *plus* might introduce at least one new
> vector of attack: overwrite a random GOT slot, and just wait until it gets hit
> by whatever code path it happens to be in; the exact code path doesn't matter.
> From an kASLR perspective this is *very* bad, since you only need to guess the
> general region of a GOT rather than an exact address.

I agree that it would add GOT references and I can explore that more
in terms of performance impact and size. This patchset makes the GOT
readonly too so I don't think the attack vector applies.

>
> The huge memory model, required for arbitrary placement, has a very
> significant performance impact.

I assume you mean mcmodel=large, it doesn't use it. It uses -fPIE and
removes -mcmodel=kernel. It favors relative references whenever
possible.

>
> The assembly code is *very* different across memory models.
>
>         -hpa
