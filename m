Return-Path: <SRS0=m6U3=OW=lists.openwall.com=kernel-hardening-return-21409-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7107C433EF
	for <kernel-hardening@archiver.kernel.org>; Sat,  2 Oct 2021 16:33:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E44F561A6F
	for <kernel-hardening@archiver.kernel.org>; Sat,  2 Oct 2021 16:33:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E44F561A6F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 18103 invoked by uid 550); 2 Oct 2021 16:33:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18071 invoked from network); 2 Oct 2021 16:33:35 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=XPPGkU56zJhC1We9hrBWJnpYMVu8F2L8QKrG+oAgNZA=;
        b=XBMc+T9ycSPOrVNggq/tbT2D8WNCTPPHiv2IaNatlwrp+gF8ZZ9VXVtshdLx9GV08x
         ZiRQAPkXD50Hn8Z6I8o1kxYE27V+nIVQMycQAURApJWH5qh6YmtwzTTJ6a5dY6Ao74Pf
         tctV0oWMyqjGuL74LhO365uVC4gplwKvCZU/2xzRgzrfaOXKTdGRsSBAvzv88ipwfBl0
         6IgY25WtWmFcdkmtDXMx3kqqOk6M8hyZV86S3sKQWq2OCQXVZRm8eGaffJP3y/npjSgc
         o4rUZsHbH2D5AFwuUf/ZDFn6/ax0QYdWzWYKcMIxWRTcPcq/nVuhr18BxF8jmuGS9QRL
         ioag==
X-Gm-Message-State: AOAM531cHNzy90djSqvnODse05acbLK0ZdeagBTu23ieyu2nNwN0NaAH
	AthxwSoUhltvWbO2FivQ8xU=
X-Google-Smtp-Source: ABdhPJxnblRp0iST3pjMz+7tehqv68lMCKl8gTtuCPWUtdqmj3LGMvYGXoO4MgsXUEEqgbn3pAhWlA==
X-Received: by 2002:a05:600c:1907:: with SMTP id j7mr10013673wmq.184.1633192403799;
        Sat, 02 Oct 2021 09:33:23 -0700 (PDT)
Subject: Re: [PATCH] Introduce the pkill_on_warn boot parameter
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Petr Mladek <pmladek@suse.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>,
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
 Dave Hansen <dave.hansen@linux.intel.com>, Will Deacon
 <will.deacon@arm.com>, David S Miller <davem@davemloft.net>,
 Borislav Petkov <bp@alien8.de>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 linux-hardening@vger.kernel.org,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, notify@kernel.org
References: <20210929185823.499268-1-alex.popov@linux.com>
 <d290202d-a72d-0821-9edf-efbecf6f6cef@linux.com>
 <20210929194924.GA880162@paulmck-ThinkPad-P17-Gen-1> <YVWAPXSzFNbHz6+U@alley>
 <CAHk-=widOm3FXMPXXK0cVaoFuy3jCk65=5VweLceQCuWdep=Hg@mail.gmail.com>
 <ba67ead7-f075-e7ad-3274-d9b2bc4c1f44@linux.com>
 <20211002081359.5de4e2b1@oasis.local.home>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <62cd30d5-0982-5074-969b-a4ae1ee188c3@linux.com>
Date: Sat, 2 Oct 2021 19:33:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211002081359.5de4e2b1@oasis.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 02.10.2021 15:13, Steven Rostedt wrote:
> On Sat, 2 Oct 2021 14:41:34 +0300
> Alexander Popov <alex.popov@linux.com> wrote:
> 
>> Currently, the Linux kernel provides two types of reaction to kernel warnings:
>>  1. Do nothing (by default),
>>  2. Call panic() if panic_on_warn is set. That's a very strong reaction,
>>     so panic_on_warn is usually disabled on production systems.
>>
>> >From a safety point of view, the Linux kernel misses a middle way of handling  
>> kernel warnings:
>>  - The kernel should stop the activity that provokes a warning,
>>  - But the kernel should avoid complete denial of service.
>>
>> >From a security point of view, kernel warning messages provide a lot of useful  
>> information for attackers. Many GNU/Linux distributions allow unprivileged users
>> to read the kernel log (for various reasons), so attackers use kernel warning
>> infoleak in vulnerability exploits. See the examples:
>> https://a13xp0p0v.github.io/2021/02/09/CVE-2021-26708.html
>> https://a13xp0p0v.github.io/2020/02/15/CVE-2019-18683.html
>> https://googleprojectzero.blogspot.com/2018/09/a-cache-invalidation-bug-in-linux.html
>>
>> Let's introduce the pkill_on_warn parameter.
>> If this parameter is set, the kernel kills all threads in a process that
>> provoked a kernel warning. This behavior is reasonable from a safety point of
>> view described above. It is also useful for kernel security hardening because
>> the system kills an exploit process that hits a kernel warning.
> 
> How does this help? It only kills the process that caused the warning,
> it doesn't kill the process that spawned it. This is trivial to get
> around. Just fork a process, trigger the warning (it gets killed) and
> then read the kernel log.
> 
> If this is your rationale, then I'm not convinced this helps at all.

Steven, as I understand, here you ask about the security implications of
pkill_on_warn (not about the safety implications that I mentioned).

Killing the exploit process that hit a warning is MUCH better than ignoring and
proceeding with execution. That may influence the stability of the exploits that
hit WARN_ON() or rely on WARN_ON() infoleak.

Exploit development is the constant struggle for attack stability. Exploiting a
heap memory corruption is especially painful when the kernel works with the
attacked slab caches in parallel with your exploit.

So when the kernel kills the exploit process, some of the WARN_ON() infoleak
data becomes obsolete; the attacker loses the execution in that particular
kernel task on that particular CPU. Moreover, restarting the exploit process
would bring a lot of noise to the system. That may decrease the attack stability
even more.

So killing the exploit process is the best option that we have here to distress
the attacker who uses the WARN_ON() infoleak technique. I.e. that is
probabilistic attack mitigation, which is reasonable for kernel safety as well.

I hope I managed to show this from the attacker's side.

Best regards,
Alexander
