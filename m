Return-Path: <SRS0=+M4Z=OW=lists.openwall.com=kernel-hardening-return-21410-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2793DC433F5
	for <kernel-hardening@archiver.kernel.org>; Sat,  2 Oct 2021 16:53:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4CEC561B00
	for <kernel-hardening@archiver.kernel.org>; Sat,  2 Oct 2021 16:53:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4CEC561B00
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 30642 invoked by uid 550); 2 Oct 2021 16:53:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30610 invoked from network); 2 Oct 2021 16:53:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7qMFTJ7wxvDKx7RqRNbyM5iYJL53fzpBAX1Z0cXGDYo=;
        b=BnC7AWn2t7U8hcMvbZB6+f8WRPJ/wlLxLWqJMBBFQqlt2pJ7o9Cq+PY7G8zlvkboG0
         +aMmZjmiZyWkpgq/2TNa5lv+hVLEInO3k7cx6j+7mNevTzx3z8dSx+JapPEMt+QE7qnM
         jYwoWfCyKbjfVLLEkVydAP4vUyV5gl74Dwa/U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7qMFTJ7wxvDKx7RqRNbyM5iYJL53fzpBAX1Z0cXGDYo=;
        b=MU1BiUvgwXxf5EjLTg1CDCaD1lmXhKLuREsQzTCVMjqow+DbXUDb4aK+e+4epRSUW8
         AQhjQuaEJ6U2PpPyroWFCz/sYFK+RrtA9XBLASTemjCFVAjUqvy7nmEh+fD4hqaJvf9c
         yZiGn8QxzYTMX3zXVnFL/iNux2NnufIAfct+uu8g6HViv6vFFewQZmtpGZjMwNx7zXHR
         qt391Z5UdG5raqnReoIVGTj0YPcl8kOYM93xPBRiMRjKwsXUaU29YMF/anEXzRQgJ4jD
         WhruQs1/muyM9iJOchCfpR9gGTCzhqACvIopkNuxM6Cu2JOsqx1Y2KWqZrnlRf4HV19B
         Fetg==
X-Gm-Message-State: AOAM53222q06i6XGbqIOlbfa50+bLNei2hPAq0NmmZx4pMFtnIxOhTfp
	M9KcIfuwhSl1SEW/fFdXgNsosq63VAUiwNxxNek=
X-Google-Smtp-Source: ABdhPJyeR3CInqFOIPGsMAKOl0mBASvSNdHeWLvbcDdj/65rU+phcPBNdAiQd9GXc08ag9711hfEKw==
X-Received: by 2002:a2e:b545:: with SMTP id a5mr4626865ljn.48.1633193599053;
        Sat, 02 Oct 2021 09:53:19 -0700 (PDT)
X-Received: by 2002:a2e:3309:: with SMTP id d9mr4559712ljc.249.1633193585297;
 Sat, 02 Oct 2021 09:53:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210929185823.499268-1-alex.popov@linux.com> <d290202d-a72d-0821-9edf-efbecf6f6cef@linux.com>
 <20210929194924.GA880162@paulmck-ThinkPad-P17-Gen-1> <YVWAPXSzFNbHz6+U@alley>
 <CAHk-=widOm3FXMPXXK0cVaoFuy3jCk65=5VweLceQCuWdep=Hg@mail.gmail.com> <ba67ead7-f075-e7ad-3274-d9b2bc4c1f44@linux.com>
In-Reply-To: <ba67ead7-f075-e7ad-3274-d9b2bc4c1f44@linux.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 2 Oct 2021 09:52:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=whrLuVEC0x+XzYUNV2de5kM-k39GkJWwviQNuCdZ0nfKg@mail.gmail.com>
Message-ID: <CAHk-=whrLuVEC0x+XzYUNV2de5kM-k39GkJWwviQNuCdZ0nfKg@mail.gmail.com>
Subject: Re: [PATCH] Introduce the pkill_on_warn boot parameter
To: Alexander Popov <alex.popov@linux.com>
Cc: Petr Mladek <pmladek@suse.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, 
	Joerg Roedel <jroedel@suse.de>, Maciej Rozycki <macro@orcam.me.uk>, 
	Muchun Song <songmuchun@bytedance.com>, Viresh Kumar <viresh.kumar@linaro.org>, 
	Robin Murphy <robin.murphy@arm.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Kees Cook <keescook@chromium.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Wei Liu <wl@xen.org>, John Ogness <john.ogness@linutronix.de>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Alexey Kardashevskiy <aik@ozlabs.ru>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Jann Horn <jannh@google.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will.deacon@arm.com>, 
	David S Miller <davem@davemloft.net>, Borislav Petkov <bp@alien8.de>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-hardening@vger.kernel.org, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, notify@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, Oct 2, 2021 at 4:41 AM Alexander Popov <alex.popov@linux.com> wrote:
>
> And what do you think about the proposed pkill_on_warn?

Honestly, I don't see the point.

If you can reliably trigger the WARN_ON some way, you can probably
cause more problems by fooling some other process to trigger it.

And if it's unintentional, then what does the signal help?

So rather than a "rationale" that makes little sense, I'd like to hear
of an actual _use_ case. That's different. That's somebody actually
_using_ that pkill to good effect for some particular load.

That said, I don't much care in the end. But it sounds like a
pointless option to just introduce yet another behavior to something
that should never happen anyway, and where the actual
honest-to-goodness reason for WARN_ON() existing is already being
fulfilled (ie syzbot has been very effective at flushing things like
that out).

                   Linus
