Return-Path: <SRS0=0mLm=QD=lists.openwall.com=kernel-hardening-return-21489-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5727C433F5
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Nov 2021 09:12:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E599461A4E
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Nov 2021 09:12:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E599461A4E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 6068 invoked by uid 550); 16 Nov 2021 09:12:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 6033 invoked from network); 16 Nov 2021 09:12:35 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fmDWsP6HIgDPZm0jsUsVahurpJpoutIi09vI45Vo0Wc=;
        b=FRHagvL6uaxn3o/BmI4Tcdodk+NfcEEL0MUUDkSTVzrgOownTh7EZp7fqYSrHZyEG1
         t8vebGw7SMit7K6j3Ctccq9L2oJyKcvU58Y+nxwBmJ50vhs6+N9p0mzf7mecU/Z3psKJ
         ykkn0FUkyi2gfEITvGtATAH+NfFTlVyiNVZTa5grjFHVJfrHIKarun+QlsKp0xhCRJwz
         loIPBYxqUSL4yncXwRoPtMNzppSrHszxiIFp6LjA54g3zaMzIrFlB7XKuGT4zDwIxIAo
         YkEf2irH1Q93f4nFvMR6slT9Uxik1mB3+t+2v1Bx+V+DLgzQ5zSWpCz3YXOCM8R5rrtM
         dwPA==
X-Gm-Message-State: AOAM532g1N23HyxtU3uRhKHEme51yehWt0jOMg1UoiUpdRSqTTij2wBe
	iUZIebfrgSMrzrIZkIbU+SY=
X-Google-Smtp-Source: ABdhPJxepms+HgoLFwnuhBFNqrvUhvNh4mcd7Wey0CxKrcVKLj1+P9n2pR6lZtm0ajXnCX83PK/xuw==
X-Received: by 2002:adf:d4c2:: with SMTP id w2mr7481224wrk.225.1637053944102;
        Tue, 16 Nov 2021 01:12:24 -0800 (PST)
Message-ID: <59534db5-b251-c0c8-791f-58aca5c00a2b@linux.com>
Date: Tue, 16 Nov 2021 12:12:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 0/2] Introduce the pkill_on_warn parameter
Content-Language: en-US
To: Kees Cook <keescook@chromium.org>, Steven Rostedt <rostedt@goodmis.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Paul McKenney <paulmck@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>,
 Joerg Roedel <jroedel@suse.de>, Maciej Rozycki <macro@orcam.me.uk>,
 Muchun Song <songmuchun@bytedance.com>,
 Viresh Kumar <viresh.kumar@linaro.org>, Robin Murphy <robin.murphy@arm.com>,
 Randy Dunlap <rdunlap@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 Petr Mladek <pmladek@suse.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Wei Liu <wl@xen.org>, John Ogness <john.ogness@linutronix.de>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Alexey Kardashevskiy <aik@ozlabs.ru>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Jann Horn
 <jannh@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Laura Abbott <labbott@kernel.org>,
 David S Miller <davem@davemloft.net>, Borislav Petkov <bp@alien8.de>,
 Arnd Bergmann <arnd@arndb.de>, Andrew Scull <ascull@google.com>,
 Marc Zyngier <maz@kernel.org>, Jessica Yu <jeyu@kernel.org>,
 Iurii Zaikin <yzaikin@google.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, Wang Qing <wangqing@vivo.com>,
 Mel Gorman <mgorman@suse.de>,
 Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
 Andrew Klychkov <andrew.a.klychkov@gmail.com>,
 Mathieu Chouquet-Stringer <me@mathieu.digital>,
 Daniel Borkmann <daniel@iogearbox.net>, Stephen Kitt <steve@sk2.org>,
 Stephen Boyd <sboyd@kernel.org>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Mike Rapoport <rppt@kernel.org>, Bjorn Andersson
 <bjorn.andersson@linaro.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 linux-hardening@vger.kernel.org,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 linux-arch <linux-arch@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, notify@kernel.org,
 main@lists.elisa.tech, safety-architecture@lists.elisa.tech,
 devel@lists.elisa.tech, Shuah Khan <shuah@kernel.org>
References: <20211027233215.306111-1-alex.popov@linux.com>
 <ac989387-3359-f8da-23f9-f5f6deca4db8@linux.com>
 <CAHk-=wgRmjkP3+32XPULMLTkv24AkA=nNLa7xxvSg-F0G1sJ9g@mail.gmail.com>
 <77b79f0c-48f2-16dd-1d00-22f3a1b1f5a6@linux.com>
 <CAKXUXMx5Oi-dNVKB+8E-pdrz+ooELMZf=oT_oGXKFrNWejz=fg@mail.gmail.com>
 <20211115110649.4f9cb390@gandalf.local.home>
 <202111151116.933184F716@keescook>
From: Alexander Popov <alex.popov@linux.com>
In-Reply-To: <202111151116.933184F716@keescook>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.11.2021 01:06, Kees Cook wrote:
> Hmm, yes. What it originally boiled down to, which is why Linus first
> objected to BUG(), was that we don't know what other parts of the system
> have been disrupted. The best example is just that of locking: if we
> BUG() or do_exit() in the middle of holding a lock, we'll wreck whatever
> subsystem that was attached to. Without a deterministic system state
> unwinder, there really isn't a "safe" way to just stop a kernel thread.
> 
> With this pkill_on_warn, we avoid the BUG problem (since the thread of
> execution continues and stops at an 'expected' place: the signal
> handler).
> 
> However, now we have the newer objection from Linus, which is one of
> attribution: the WARN might be hit during an "unrelated" thread of
> execution and "current" gets blamed, etc. And beyond that, if we take
> down a portion of userspace, what in userspace may be destabilized? In
> theory, we get a case where any required daemons would be restarted by
> init, but that's not "known".
> 
> The safest version of this I can think of is for processes to opt into
> this mitigation. That would also cover the "special cases" we've seen
> exposed too. i.e. init and kthreads would not opt in.
> 
> However, that's a lot to implement when Marco's tracing suggestion might
> be sufficient and policy could be entirely implemented in userspace. It
> could be as simple as this (totally untested):

I don't think that this userspace warning handling can work as pkill_on_warn.

1. The kernel code execution continues after WARN_ON(), it will not wait some 
userspace daemon that is polling trace events. That's not different from 
ignoring and having all negative effects after WARN_ON().

2. This userspace policy will miss WARN_ON_ONCE(), WARN_ONCE() and 
WARN_TAINT_ONCE() after the first hit.


Oh, wait...
I got a crazy idea that may bring more consistency in the error handling mess.

What if the Linux kernel had a LSM module responsible for error handling policy?
That would require adding LSM hooks to BUG*(), WARN*(), KERN_EMERG, etc.
In such LSM policy we can decide immediately how to react on the kernel error.
We can even decide depending on the subsystem and things like that.

(idea for brainstorming)

Best regards,
Alexander
