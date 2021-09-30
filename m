Return-Path: <SRS0=C//l=OU=lists.openwall.com=kernel-hardening-return-21398-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD4CC433EF
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Sep 2021 15:09:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AB043615E5
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Sep 2021 15:09:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AB043615E5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 5966 invoked by uid 550); 30 Sep 2021 15:09:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5934 invoked from network); 30 Sep 2021 15:09:03 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=afuuRoWEct2MfL+JBgtz3aEAzNrXRi3zezmIOBkaE24=;
        b=lvcFA/S7JWWADN1bDI9yxUStOumWnlD9KyIAuRXaeKDug5JjQxXrcYI5heqPLVRARZ
         alh0AoFi9ITQ6QfW/4/MXJJyqV64FyYzdf3aalb8KFC06n4gaycnd39nZlcazpSCO+ti
         pDCxS6launE/Wx0o4SXfgexZBKnTb0EklFG2ihpEU4ZPBW9ws0LzPIuMxw0wqFpcmj7d
         R0Mulewenz0jp0iUEo5cu9zJPYb48dGcU1/G4VALNqrSMRZY5n+1qbjSnsm5sOvFCZ5i
         dnYT8z8lziryW4Y89/v4W2enA3rT4ojFJTHhGYnNgLx8HMbOvdXshNwMDL+txl8aMaQu
         TfoQ==
X-Gm-Message-State: AOAM530M0XDpuGwj3k7QTfPqxUckzWy1GmICpgKH3koUesoe7XPVoVlx
	t/uIsDNVz8wDNcC2wfpPGy8=
X-Google-Smtp-Source: ABdhPJzW5nYkwTBSU2KYkXIp9u2zCRW4OTzrnUusNVdJl5Z261PeSkrf26+tyN6r+fm0cRL41Z0nvw==
X-Received: by 2002:a17:906:f6cf:: with SMTP id jo15mr7441915ejb.244.1633014360379;
        Thu, 30 Sep 2021 08:06:00 -0700 (PDT)
Subject: Re: [PATCH] Introduce the pkill_on_warn boot parameter
To: Petr Mladek <pmladek@suse.com>, "Paul E. McKenney" <paulmck@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Andrew Morton <akpm@linux-foundation.org>,
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
 kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, notify@kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Dmitry Vyukov <dvyukov@google.com>
References: <20210929185823.499268-1-alex.popov@linux.com>
 <d290202d-a72d-0821-9edf-efbecf6f6cef@linux.com>
 <20210929194924.GA880162@paulmck-ThinkPad-P17-Gen-1> <YVWAPXSzFNbHz6+U@alley>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <a09c1d4d-1d5b-9092-ae3a-61bc22689dd2@linux.com>
Date: Thu, 30 Sep 2021 18:05:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YVWAPXSzFNbHz6+U@alley>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 30.09.2021 12:15, Petr Mladek wrote:
> On Wed 2021-09-29 12:49:24, Paul E. McKenney wrote:
>> On Wed, Sep 29, 2021 at 10:01:33PM +0300, Alexander Popov wrote:
>>> On 29.09.2021 21:58, Alexander Popov wrote:
>>>> Currently, the Linux kernel provides two types of reaction to kernel
>>>> warnings:
>>>>  1. Do nothing (by default),
>>>>  2. Call panic() if panic_on_warn is set. That's a very strong reaction,
>>>>     so panic_on_warn is usually disabled on production systems.
> 
> Honestly, I am not sure if panic_on_warn() or the new pkill_on_warn()
> work as expected. I wonder who uses it in practice and what is
> the experience.
> 
> The problem is that many developers do not know about this behavior.
> They use WARN() when they are lazy to write more useful message or when
> they want to see all the provided details: task, registry, backtrace.
> 
> Also it is inconsistent with pr_warn() behavior. Why a single line
> warning would be innocent and full info WARN() cause panic/pkill?
> 
> What about pr_err(), pr_crit(), pr_alert(), pr_emerg()? They inform
> about even more serious problems. Why a warning should cause panic/pkill
> while an alert message is just printed?

That's a good question.

I guess various kernel continuous integration (CI) systems have panic_on_warn
enabled.

[Adding Dmitry Vyukov to this discussion]

If we look at the syzbot dashboard [1] with the results of Linux kernel fuzzing,
we see the issues that appear as various kernel crashes and warnings.
We don't see anything from pr_err(), pr_crit(), pr_alert(), pr_emerg(). Maybe
these situations are not considered as kernel bugs that require fixing.

Anyway, from a security point of view, a kernel warning output is interesting
for attackers as an infoleak. The messages printed by pr_err(), pr_crit(),
pr_alert(), pr_emerg() provide less information.

[1]: https://syzkaller.appspot.com/upstream

> It somehow reminds me the saga with %pK. We were not able to teach
> developers to use it correctly for years and ended with hashed
> pointers.
> 
> Well, this might be different. Developers might learn this the hard
> way from bug reports. But there will be bug reports only when
> anyone really enables this behavior. They will enable it only
> when it works the right way most of the time.
> 
> 
>>>> From a safety point of view, the Linux kernel misses a middle way of
>>>> handling kernel warnings:
>>>>  - The kernel should stop the activity that provokes a warning,
>>>>  - But the kernel should avoid complete denial of service.
>>>>
>>>> From a security point of view, kernel warning messages provide a lot of
>>>> useful information for attackers. Many GNU/Linux distributions allow
>>>> unprivileged users to read the kernel log, so attackers use kernel
>>>> warning infoleak in vulnerability exploits. See the examples:
>>>>   https://a13xp0p0v.github.io/2020/02/15/CVE-2019-18683.html
>>>>   https://a13xp0p0v.github.io/2021/02/09/CVE-2021-26708.html
>>>>
>>>> Let's introduce the pkill_on_warn boot parameter.
>>>> If this parameter is set, the kernel kills all threads in a process
>>>> that provoked a kernel warning. This behavior is reasonable from a safety
>>>> point of view described above. It is also useful for kernel security
>>>> hardening because the system kills an exploit process that hits a
>>>> kernel warning.
>>>>
>>>> Signed-off-by: Alexander Popov <alex.popov@linux.com>
>>>
>>> This patch was tested using CONFIG_LKDTM.
>>> The kernel kills a process that performs this:
>>>   echo WARNING > /sys/kernel/debug/provoke-crash/DIRECT
>>>
>>> If you are fine with this approach, I will prepare a patch adding the
>>> pkill_on_warn sysctl.
>>
>> I suspect that you need a list of kthreads for which you are better
>> off just invoking panic().  RCU's various kthreads, for but one set
>> of examples.
> 
> I wonder if kernel could survive killing of any kthread. I have never
> seen a code that would check whether a kthread was killed and
> restart it.

The do_group_exit() function calls do_exit() from kernel/exit.c, which is also
called during a kernel oops. This function cares about a lot of special cases
depending on the current task_struct. Is it fine?

Best regards,
Alexander
