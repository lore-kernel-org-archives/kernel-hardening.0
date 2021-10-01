Return-Path: <SRS0=5T53=OV=lists.openwall.com=kernel-hardening-return-21406-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF07C433F5
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Oct 2021 19:59:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D043761ACF
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Oct 2021 19:59:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D043761ACF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 9749 invoked by uid 550); 1 Oct 2021 19:59:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9720 invoked from network); 1 Oct 2021 19:59:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=34EwS/c7N/DKv1m8EvMaKtne6wn9CIjoRSRa4pc1cBg=;
        b=hL82XCeLqL84r9ssYwmzBfBNJV5z4IPDVUUS0GvuTEDo7OylDGxwc9JsMHyUvY9UZL
         mbiZxKK4Xp9x9e7F23wlAo+rhwVdequbKRg0+MGQraSICNwRWtRezQwCuKlpN95gvdPm
         t9GQDZnq8evcMr4Fw+C936UTkn7d5w6kLh1y4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=34EwS/c7N/DKv1m8EvMaKtne6wn9CIjoRSRa4pc1cBg=;
        b=kyADDXZGvyUdQkINtya/AWnIeSOq5Z3zPk32rDmr8PhcKfhIX4a96hM7Sdwhu3n4wq
         3AJIPldl8Q0OU11oGf1WLoA9wYnUA5Y54GmQWkq35E5LF1MtGKUdDDLkbbVxIheURR54
         tqN8K16igQZKJVl7IXRMfpzHL7kXNBfczBRbl10jvgdk+kIJ3OeOw2FDPcyU5q5U0E9N
         fGj4cCj/nHsqt5NRp9+P7ZUmPzfNRORNchECPePS12nfE95xzR5uuqGpTA/zD/B6YocK
         7jke4WSdL6nVjHkQs2GonHhk6ZOs96dnEplRmdd1Nn1KR2vO34qNwtB8bAn58mcxya/9
         GqOQ==
X-Gm-Message-State: AOAM531eh1ftGjgLC3k41qcUoWGlyu6X7+flwK6PqZ67Sok9GJA2jpiS
	IJ/Oi/phSXqGKWChsyd4ixKuzTF7ZGrPzwTbE3U=
X-Google-Smtp-Source: ABdhPJxXisKo2o5z7hid7BhZo2FJdY4iOZv8UQHvnXBUCW2TLsTR40A/dGPHMLnpneNscH/ZnH15jg==
X-Received: by 2002:a50:e10c:: with SMTP id h12mr16163044edl.299.1633118368942;
        Fri, 01 Oct 2021 12:59:28 -0700 (PDT)
X-Received: by 2002:a05:6512:12c4:: with SMTP id p4mr7488858lfg.280.1633118356263;
 Fri, 01 Oct 2021 12:59:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210929185823.499268-1-alex.popov@linux.com> <d290202d-a72d-0821-9edf-efbecf6f6cef@linux.com>
 <20210929194924.GA880162@paulmck-ThinkPad-P17-Gen-1> <YVWAPXSzFNbHz6+U@alley>
In-Reply-To: <YVWAPXSzFNbHz6+U@alley>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Oct 2021 12:59:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=widOm3FXMPXXK0cVaoFuy3jCk65=5VweLceQCuWdep=Hg@mail.gmail.com>
Message-ID: <CAHk-=widOm3FXMPXXK0cVaoFuy3jCk65=5VweLceQCuWdep=Hg@mail.gmail.com>
Subject: Re: [PATCH] Introduce the pkill_on_warn boot parameter
To: Petr Mladek <pmladek@suse.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, Alexander Popov <alex.popov@linux.com>, 
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
	Steven Rostedt <rostedt@goodmis.org>, Thomas Garnier <thgarnie@google.com>, 
	Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Laura Abbott <labbott@redhat.com>, David S Miller <davem@davemloft.net>, Borislav Petkov <bp@alien8.de>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-hardening@vger.kernel.org, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, notify@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 30, 2021 at 2:15 AM Petr Mladek <pmladek@suse.com> wrote:
>
> Honestly, I am not sure if panic_on_warn() or the new pkill_on_warn()
> work as expected. I wonder who uses it in practice and what is
> the experience.

Afaik, there are only two valid uses for panic-on-warn:

 (a) test boxes (particularly VM's) that are literally running things
like syzbot and want to report any kernel warnings

 (b) the "interchangeable production machinery" fail-fast kind of situation

So in that (a) case, it's literally that you consider a warning to be
a failure case, and just want to stop. Very useful as a way to get
notified by syzbot that "oh, that assert can actually trigger".

And the (b) case is more of a "we have 150 million machines, we expect
about a thousand of them to fail for any random reason any day
_anyway_ - perhaps simply due to hardware failure, and we'd rather
take a machine down quickly and then perhaps look at why only much
later when we have some pattern to the failures".

You shouldn't expect panic-on-warn to ever be the case for any actual
production machine that _matters_. If it is, that production
maintainer only has themselves to blame if they set that flag.

But yes, the expectation is that warnings are for "this can't happen,
but if it does, it's not necessarily fatal, I want to know about it so
that I can think about it".

So it might be a case that you don't handle, but that isn't
necessarily _wrong_ to not handle. You are ok returning an error like
-ENOSYS for that case, for example, but at the same time you are "If
somebody uses this, we should perhaps react to it".

In many cases, a "pr_warn()" is much better. But if you are unsure
just _how_ the situation can happen, and want a call trace and
information about what process did it, and it really is a "this
shouldn't ever happen" situation, a WARN_ON() or a WARN_ON_ONCE() is
certainly not wrong.

So think of WARN_ON() as basically an assert, but an assert with the
intention to be able to continue so that the assert can actually be
reported. BUG_ON() and friends easily result in a machine that is
dead. That's unacceptable.

And think of "panic-on-warn" as people who can deal with their own
problems. It's fundamentally not your issue.  They took that choice,
it's their problem, and the security arguments are pure BS - because
WARN_ON() just shouldn't be something you can trigger anyway.

             Linus
