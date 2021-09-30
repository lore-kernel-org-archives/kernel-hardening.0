Return-Path: <SRS0=Bkm/=OU=lists.openwall.com=kernel-hardening-return-21401-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7970DC433EF
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Sep 2021 18:28:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A1E30611C0
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Sep 2021 18:28:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A1E30611C0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 32218 invoked by uid 550); 30 Sep 2021 18:28:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32164 invoked from network); 30 Sep 2021 18:28:01 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=kXiXFZ9ry/i2aqEPHzEKtrxgwY/jrLKAjIEmqjjgomU=;
        b=xgQxmgYzBSzQYB02HIpjLOQAWMSy+2NBXGsDB0ZnG44BC9HWU1z32IFa6LbdlZSYwx
         VM4K1T1derDTmsmbBVJzxk4LBFztcDbzoIKiwIzMaZs22m0yMmTGd7FGYL2sCa5ky2p9
         46XktzMrGg7hXLoQC2QbfaZz95ECn7/eUk/DS9kPxIRDrCfLP3qo7pSORKW+h6YWG8N4
         ugSM4KVvPcVsLNFWDHOMf6w0If84uT8Po44dQhV0umb8LZMxzB23RaiL6rZkm+XA9fYn
         ODwQBlnzL3usYJ9Pculq+kxxKV1hZlHXMOdizwHJ/erslpzcup9cVSKQALbSG6XjOHNn
         MyaA==
X-Gm-Message-State: AOAM532iEEl9L7wR07jCpqsOCIC6gjhAQQ9FUes/DQMXjHY2MM9wHseY
	1psd63zUD9OVOBrLbYaW3ic=
X-Google-Smtp-Source: ABdhPJxj9CMxn1KKITdh+ZI6jqK3Mxh13R5dPHWbok7gCHp0kQp4Dn7qOlUIxuEm9oWnhfLUfVVvVA==
X-Received: by 2002:a17:906:c4a:: with SMTP id t10mr771534ejf.371.1633026470564;
        Thu, 30 Sep 2021 11:27:50 -0700 (PDT)
Subject: Re: [PATCH] Introduce the pkill_on_warn boot parameter
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Paul McKenney <paulmck@kernel.org>,
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
 Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will.deacon@arm.com>,
 David S Miller <davem@davemloft.net>, Borislav Petkov <bp@alien8.de>,
 kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, notify@kernel.org
References: <20210929185823.499268-1-alex.popov@linux.com>
 <d290202d-a72d-0821-9edf-efbecf6f6cef@linux.com>
 <20210929163143.aa8b70ac9d5cf0b628823370@linux-foundation.org>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <de96ffec-bbd8-2724-9285-0867cd9a08a0@linux.com>
Date: Thu, 30 Sep 2021 21:27:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210929163143.aa8b70ac9d5cf0b628823370@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 30.09.2021 02:31, Andrew Morton wrote:
> On Wed, 29 Sep 2021 22:01:33 +0300 Alexander Popov <alex.popov@linux.com> wrote:
> 
>> On 29.09.2021 21:58, Alexander Popov wrote:
>>> Currently, the Linux kernel provides two types of reaction to kernel
>>> warnings:
>>>  1. Do nothing (by default),
>>>  2. Call panic() if panic_on_warn is set. That's a very strong reaction,
>>>     so panic_on_warn is usually disabled on production systems.
>>>
>>> From a safety point of view, the Linux kernel misses a middle way of
>>> handling kernel warnings:
>>>  - The kernel should stop the activity that provokes a warning,
>>>  - But the kernel should avoid complete denial of service.
>>>
>>> From a security point of view, kernel warning messages provide a lot of
>>> useful information for attackers. Many GNU/Linux distributions allow
>>> unprivileged users to read the kernel log, so attackers use kernel
>>> warning infoleak in vulnerability exploits. See the examples:
>>>   https://a13xp0p0v.github.io/2020/02/15/CVE-2019-18683.html
>>>   https://a13xp0p0v.github.io/2021/02/09/CVE-2021-26708.html
>>>
>>> Let's introduce the pkill_on_warn boot parameter.
>>> If this parameter is set, the kernel kills all threads in a process
>>> that provoked a kernel warning. This behavior is reasonable from a safety
>>> point of view described above. It is also useful for kernel security
>>> hardening because the system kills an exploit process that hits a
>>> kernel warning.
>>>
>>> Signed-off-by: Alexander Popov <alex.popov@linux.com>
>>
>> This patch was tested using CONFIG_LKDTM.
>> The kernel kills a process that performs this:
>>   echo WARNING > /sys/kernel/debug/provoke-crash/DIRECT
>>
>> If you are fine with this approach, I will prepare a patch adding the
>> pkill_on_warn sysctl.
> 
> Why do we need a boot parameter?  Isn't a sysctl all we need for this
> feature? 

I would say we need both sysctl and boot parameter for pkill_on_warn.
That would be consistent with panic_on_warn, ftrace_dump_on_oops and
oops/panic_on_oops.

> Also, 
> 
> 	if (pkill_on_warn && system_state >= SYSTEM_RUNNING)
> 		do_group_exit(SIGKILL);
> 
> - why do we care about system_state?  An explanatory code comment
>   seems appropriate.
> 
> - do we really want to do this in states > SYSTEM_RUNNING?  If so, why?

A kernel warning may occur at any moment.
I don't have a deep understanding of possible side effects on early boot stages.
So I decided that at least it's safer to avoid interfering before SYSTEM_RUNNING.

Best regards,
Alexander

