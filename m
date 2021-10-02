Return-Path: <SRS0=dB78=OW=lists.openwall.com=kernel-hardening-return-21407-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A753FC433EF
	for <kernel-hardening@archiver.kernel.org>; Sat,  2 Oct 2021 11:42:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 863ED61242
	for <kernel-hardening@archiver.kernel.org>; Sat,  2 Oct 2021 11:41:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 863ED61242
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 24528 invoked by uid 550); 2 Oct 2021 11:41:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24487 invoked from network); 2 Oct 2021 11:41:50 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=9tDiOVgsOJM22Fe9m6y3O2Yzwc8y2p0M/sgl00e/dH4=;
        b=uwuGv0QUa/dngUcYQq0rHFzHnzL1T/aeneKj1ChjSM6H17gZv75b/sMNGAVhNpFp69
         /KTCG2mM5DN4o9N99fw8qBKGTgHKJhHS+DO+xmcXgXr4b2koyiYnkA19vI/4F8WLN7TV
         g74k+iqbOAJTLZmSMnXUWFsUdpT/P2yHGb1j4URFjVycJeTwtlEFR6YkN7NpWouFQ4CA
         apqfUMk2YOv3pWokEpXh0znomy+zAZtF7+6E1V0eKAPeVSkFzIthbBGXL7fqaStixhWv
         Bb+97sXKy1adAiTTpZKnffziLp9DUTAHBBYoWeEaik91GnTNcxTOj7TytzR4Ha/WGoO/
         Eh8A==
X-Gm-Message-State: AOAM531iI2qel8RxZD873yt9fDy/l3D3Y7tGf6DGIWGPNrVqfCKUr9gd
	AcjdHYv/I7DSrPrMh9fpLO4=
X-Google-Smtp-Source: ABdhPJxJ7mL8CuDeamuLJyE93IBziQGzJIvvcMtkhnIEfPrNJtB4lpsvJK/qZiDiTKzyLd8ktoP4LA==
X-Received: by 2002:a17:906:608e:: with SMTP id t14mr3627978ejj.441.1633174898735;
        Sat, 02 Oct 2021 04:41:38 -0700 (PDT)
Subject: Re: [PATCH] Introduce the pkill_on_warn boot parameter
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Petr Mladek <pmladek@suse.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, Jonathan Corbet
 <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>,
 Joerg Roedel <jroedel@suse.de>, Maciej Rozycki <macro@orcam.me.uk>,
 Muchun Song <songmuchun@bytedance.com>,
 Viresh Kumar <viresh.kumar@linaro.org>, Robin Murphy <robin.murphy@arm.com>,
 Randy Dunlap <rdunlap@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 Kees Cook <keescook@chromium.org>, Luis Chamberlain <mcgrof@kernel.org>,
 Wei Liu <wl@xen.org>, John Ogness <john.ogness@linutronix.de>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Alexey Kardashevskiy <aik@ozlabs.ru>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Jann Horn
 <jannh@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will.deacon@arm.com>,
 David S Miller <davem@davemloft.net>, Borislav Petkov <bp@alien8.de>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 linux-hardening@vger.kernel.org,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, notify@kernel.org
References: <20210929185823.499268-1-alex.popov@linux.com>
 <d290202d-a72d-0821-9edf-efbecf6f6cef@linux.com>
 <20210929194924.GA880162@paulmck-ThinkPad-P17-Gen-1> <YVWAPXSzFNbHz6+U@alley>
 <CAHk-=widOm3FXMPXXK0cVaoFuy3jCk65=5VweLceQCuWdep=Hg@mail.gmail.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <ba67ead7-f075-e7ad-3274-d9b2bc4c1f44@linux.com>
Date: Sat, 2 Oct 2021 14:41:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=widOm3FXMPXXK0cVaoFuy3jCk65=5VweLceQCuWdep=Hg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 01.10.2021 22:59, Linus Torvalds wrote:
> On Thu, Sep 30, 2021 at 2:15 AM Petr Mladek <pmladek@suse.com> wrote:
>>
>> Honestly, I am not sure if panic_on_warn() or the new pkill_on_warn()
>> work as expected. I wonder who uses it in practice and what is
>> the experience.
> 
> Afaik, there are only two valid uses for panic-on-warn:
> 
>  (a) test boxes (particularly VM's) that are literally running things
> like syzbot and want to report any kernel warnings
> 
>  (b) the "interchangeable production machinery" fail-fast kind of situation
> 
> So in that (a) case, it's literally that you consider a warning to be
> a failure case, and just want to stop. Very useful as a way to get
> notified by syzbot that "oh, that assert can actually trigger".
> 
> And the (b) case is more of a "we have 150 million machines, we expect
> about a thousand of them to fail for any random reason any day
> _anyway_ - perhaps simply due to hardware failure, and we'd rather
> take a machine down quickly and then perhaps look at why only much
> later when we have some pattern to the failures".
> 
> You shouldn't expect panic-on-warn to ever be the case for any actual
> production machine that _matters_. If it is, that production
> maintainer only has themselves to blame if they set that flag.
> 
> But yes, the expectation is that warnings are for "this can't happen,
> but if it does, it's not necessarily fatal, I want to know about it so
> that I can think about it".
> 
> So it might be a case that you don't handle, but that isn't
> necessarily _wrong_ to not handle. You are ok returning an error like
> -ENOSYS for that case, for example, but at the same time you are "If
> somebody uses this, we should perhaps react to it".
> 
> In many cases, a "pr_warn()" is much better. But if you are unsure
> just _how_ the situation can happen, and want a call trace and
> information about what process did it, and it really is a "this
> shouldn't ever happen" situation, a WARN_ON() or a WARN_ON_ONCE() is
> certainly not wrong.
> 
> So think of WARN_ON() as basically an assert, but an assert with the
> intention to be able to continue so that the assert can actually be
> reported. BUG_ON() and friends easily result in a machine that is
> dead. That's unacceptable.
> 
> And think of "panic-on-warn" as people who can deal with their own
> problems. It's fundamentally not your issue.  They took that choice,
> it's their problem, and the security arguments are pure BS - because
> WARN_ON() just shouldn't be something you can trigger anyway.

Thanks, Linus.
And what do you think about the proposed pkill_on_warn?

Let me quote the rationale behind it.

Currently, the Linux kernel provides two types of reaction to kernel warnings:
 1. Do nothing (by default),
 2. Call panic() if panic_on_warn is set. That's a very strong reaction,
    so panic_on_warn is usually disabled on production systems.

From a safety point of view, the Linux kernel misses a middle way of handling
kernel warnings:
 - The kernel should stop the activity that provokes a warning,
 - But the kernel should avoid complete denial of service.

From a security point of view, kernel warning messages provide a lot of useful
information for attackers. Many GNU/Linux distributions allow unprivileged users
to read the kernel log (for various reasons), so attackers use kernel warning
infoleak in vulnerability exploits. See the examples:
https://a13xp0p0v.github.io/2021/02/09/CVE-2021-26708.html
https://a13xp0p0v.github.io/2020/02/15/CVE-2019-18683.html
https://googleprojectzero.blogspot.com/2018/09/a-cache-invalidation-bug-in-linux.html

Let's introduce the pkill_on_warn parameter.
If this parameter is set, the kernel kills all threads in a process that
provoked a kernel warning. This behavior is reasonable from a safety point of
view described above. It is also useful for kernel security hardening because
the system kills an exploit process that hits a kernel warning.

Linus, how do you see the proper way of handling WARN_ON() in kthreads if
pkill_on_warn is enabled?

Thanks!

Best regards,
Alexander
