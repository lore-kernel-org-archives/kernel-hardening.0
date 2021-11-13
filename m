Return-Path: <SRS0=fOf7=QA=lists.openwall.com=kernel-hardening-return-21468-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A609DC433EF
	for <kernel-hardening@archiver.kernel.org>; Sat, 13 Nov 2021 18:15:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B3AFE60F46
	for <kernel-hardening@archiver.kernel.org>; Sat, 13 Nov 2021 18:15:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B3AFE60F46
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 12127 invoked by uid 550); 13 Nov 2021 18:14:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12092 invoked from network); 13 Nov 2021 18:14:58 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qJpFgDmQX4NgXIPsmsa3L8Op/10DaprZpinixut55a0=;
        b=LCUk/s3LYqfIUXrUQx/Yb4VZyelWsz0KqdfdG+VjpOaInIIT86zxTpBrHKbpggJdmi
         Mr0VsoJkSaC4LaL2WLLGoz6EkbrQSu3N6JGLaMt0UAiNVy9T7zw7YWT8cI/4Y+j9Gh0j
         orXp9UtNpzuGkV79Ur7qqHQ56DChjHNFEA+U0BY+iZAL/SbFtITkmaJidweK/hkqSL/l
         oKuINVjnb62OgSYsjSDifvq7VyorQuveQIsMppqd1lGxxz1RdN+BHywhhPFx8msnabYq
         5o43vVCSG2x2XOyQaVkk53vWS5u2Rxy4DAP446+r39sFY2G4qj2K8+kwgqE6eqGyFi31
         WieQ==
X-Gm-Message-State: AOAM530FyXBdu5iutOHYCiWTVDPnNTvnB0Roe9NBzuUsWAoUdKBWmgPr
	EJZkKIecBild4QbOBo+q1Dc=
X-Google-Smtp-Source: ABdhPJySvDqEIK8+A9iIm0gq0uH+YP8Ng3lmMG7/q64IpdcsRxTBcPM1NXj/RYt+u7AjGEpgcD8v+w==
X-Received: by 2002:a05:600c:4108:: with SMTP id j8mr27714558wmi.139.1636827286595;
        Sat, 13 Nov 2021 10:14:46 -0800 (PST)
Message-ID: <77b79f0c-48f2-16dd-1d00-22f3a1b1f5a6@linux.com>
Date: Sat, 13 Nov 2021 21:14:39 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 0/2] Introduce the pkill_on_warn parameter
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Paul McKenney <paulmck@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>,
 Joerg Roedel <jroedel@suse.de>, Maciej Rozycki <macro@orcam.me.uk>,
 Muchun Song <songmuchun@bytedance.com>,
 Viresh Kumar <viresh.kumar@linaro.org>, Robin Murphy <robin.murphy@arm.com>,
 Randy Dunlap <rdunlap@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 Petr Mladek <pmladek@suse.com>, Kees Cook <keescook@chromium.org>,
 Luis Chamberlain <mcgrof@kernel.org>, Wei Liu <wl@xen.org>,
 John Ogness <john.ogness@linutronix.de>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Alexey Kardashevskiy <aik@ozlabs.ru>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Jann Horn
 <jannh@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
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
 devel@lists.elisa.tech, Shuah Khan <shuah@kernel.org>,
 Lukas Bulwahn <lukas.bulwahn@gmail.com>
References: <20211027233215.306111-1-alex.popov@linux.com>
 <ac989387-3359-f8da-23f9-f5f6deca4db8@linux.com>
 <CAHk-=wgRmjkP3+32XPULMLTkv24AkA=nNLa7xxvSg-F0G1sJ9g@mail.gmail.com>
From: Alexander Popov <alex.popov@linux.com>
In-Reply-To: <CAHk-=wgRmjkP3+32XPULMLTkv24AkA=nNLa7xxvSg-F0G1sJ9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.11.2021 00:26, Linus Torvalds wrote:
> On Fri, Nov 12, 2021 at 10:52 AM Alexander Popov <alex.popov@linux.com> wrote:
>>
>> Hello everyone!
>> Friendly ping for your feedback.
> 
> I still haven't heard a compelling _reason_ for this all, and why
> anybody should ever use this or care?

Ok, to sum up:

Killing the process that hit a kernel warning complies with the Fail-Fast 
principle [1]. pkill_on_warn sysctl allows the kernel to stop the process when 
the **first signs** of wrong behavior are detected.

By default, the Linux kernel ignores a warning and proceeds the execution from 
the flawed state. That is opposite to the Fail-Fast principle.
A kernel warning may be followed by memory corruption or other negative effects, 
like in CVE-2019-18683 exploit [2] or many other cases detected by the SyzScope 
project [3]. pkill_on_warn would prevent the system from the errors going after 
a warning in the process context.

At the same time, pkill_on_warn does not kill the entire system like 
panic_on_warn. That is the middle way of handling kernel warnings.
Linus, it's similar to your BUG_ON() policy [4]. The process hitting BUG_ON() is 
killed, and the system proceeds to work. pkill_on_warn just brings a similar 
policy to WARN_ON() handling.

I believe that many Linux distros (which don't hit WARN_ON() here and there) 
will enable pkill_on_warn because it's reasonable from the safety and security 
points of view.

And I'm sure that the ELISA project by the Linux Foundation (Enabling Linux In 
Safety Applications [5]) would support the pkill_on_warn sysctl.
[Adding people from this project to CC]

I hope that I managed to show the rationale.

Best regards,
Alexander


[1]: https://en.wikipedia.org/wiki/Fail-fast
[2]: https://a13xp0p0v.github.io/2020/02/15/CVE-2019-18683.html
[3]: https://www.usenix.org/system/files/sec22summer_zou.pdf
[4]: http://lkml.iu.edu/hypermail/linux/kernel/1610.0/01217.html
[5]: https://elisa.tech/
