Return-Path: <SRS0=ZfsT=OU=lists.openwall.com=kernel-hardening-return-21397-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF16C433F5
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Sep 2021 13:56:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D53BE61440
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Sep 2021 13:56:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D53BE61440
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 25708 invoked by uid 550); 30 Sep 2021 13:55:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25671 invoked from network); 30 Sep 2021 13:55:54 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=XIBvChFKd70IQU/OaMjJCINVW+wyQl1HNkbZBhbOPoI=;
        b=uQS2gSh6yaVPaRSytJBRGZP1/m6dZqrS7vCrb0xEGFwyPKh2tlpzPqUkWNkQr72++Z
         QT/LanjdRr7bkUmyRWQ4OTudXK+eNUtO9Yofix3/kc0mZ71okWU0NU8VUFcCJLRv/Fvb
         OiWI+YnqTO8+gJ71OPdUXYDm6R/p6v6mEYEc+hL2YkTSEnqGr5AT6/D6ZRUYbMK4ufxJ
         6zKb1ICZWPPTVJJ59qCqc+aBlPBDWzoqtm3a29+uZK4wLzDjkTZCOpsa9t7vtANZkgaI
         4GJxKG6F7iL4ZZGTLY6dSt3R9Ohs6xOAKPrTXj7bcWUCojwMcc+dTDXg+mPFRH0xEynp
         Cdww==
X-Gm-Message-State: AOAM531BE4ZqN3RxtPuAsZhbQtT32vNUvw73WSILbtUXbUcx4K7Ne0OH
	vl6r3uTNPh1mjOfO1jWkWD0=
X-Google-Smtp-Source: ABdhPJyfiFxiOHTqszHIrDDHSj7cKIx9P6KR71PRpxnSn6DAWepMhnjvSct+GsB9xt+w+bIBcMmn/w==
X-Received: by 2002:a5d:64a3:: with SMTP id m3mr6461208wrp.157.1633010142527;
        Thu, 30 Sep 2021 06:55:42 -0700 (PDT)
Subject: Re: [PATCH] Introduce the pkill_on_warn boot parameter
To: Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Paul McKenney <paulmck@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Joerg Roedel <jroedel@suse.de>,
 Maciej Rozycki <macro@orcam.me.uk>, Muchun Song <songmuchun@bytedance.com>,
 Viresh Kumar <viresh.kumar@linaro.org>, Robin Murphy <robin.murphy@arm.com>,
 Randy Dunlap <rdunlap@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 Petr Mladek <pmladek@suse.com>, Luis Chamberlain <mcgrof@kernel.org>,
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
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, notify@kernel.org
References: <20210929185823.499268-1-alex.popov@linux.com>
 <323d0784-249d-7fef-6c60-e8426d35b083@intel.com>
 <202109291229.C64A1D9D@keescook>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <cf6ada34-9854-b7ad-f671-52186da5abd0@linux.com>
Date: Thu, 30 Sep 2021 16:55:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <202109291229.C64A1D9D@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 29.09.2021 23:06, Kees Cook wrote:
> On Wed, Sep 29, 2021 at 12:03:36PM -0700, Dave Hansen wrote:
>> On 9/29/21 11:58 AM, Alexander Popov wrote:
>>> --- a/kernel/panic.c
>>> +++ b/kernel/panic.c
>>> @@ -53,6 +53,7 @@ static int pause_on_oops_flag;
>>>  static DEFINE_SPINLOCK(pause_on_oops_lock);
>>>  bool crash_kexec_post_notifiers;
>>>  int panic_on_warn __read_mostly;
>>> +int pkill_on_warn __read_mostly;
> 
> I like this idea. I can't tell if Linus would tolerate it, though. But I
> really have wanted a middle ground like BUG(). Having only WARN() and
> panic() is not very friendly. :(

Ok, let's see.

Kees, could you also share your thoughts on the good questions by Petr Mladek in
this thread?

>>>  unsigned long panic_on_taint;
>>>  bool panic_on_taint_nousertaint = false;
>>>  
>>> @@ -610,6 +611,9 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
>>>  
>>>  	print_oops_end_marker();
>>>  
>>> +	if (pkill_on_warn && system_state >= SYSTEM_RUNNING)
>>> +		do_group_exit(SIGKILL);
>>> +
>>>  	/* Just a warning, don't kill lockdep. */
>>>  	add_taint(taint, LOCKDEP_STILL_OK);
>>>  }
>>
>> Doesn't this tie into the warning *printing* code?  That's better than
>> nothing, for sure.  But, if we're doing this for hardening, I think we
>> would want to kill anyone provoking a warning, not just the first one
>> that triggered *printing* the warning.
> 
> Right, this needs to be moved into the callers of __warn() (i.e.
> report_bug(), and warn_slowpath_fmt()), likely with some small
> refactoring in report_bug().

Yes, I see now. Thanks, Dave, Peter and Kees.
The kernel can hit warning and omit calling __warn() that prints the message.
But pkill_on_warn action should be taken each time.

As I can understand now, include/asm-generic/bug.h defines three warning
implementations:
 1. CONFIG_BUG=y and the arch provides __WARN_FLAGS. In that case pkill_on_warn
should be checked in report_bug() that you mention.
 2. CONFIG_BUG=y and the arch doesn't have __WARN_FLAGS. In that case
pkill_on_warn should be checked in warn_slowpath_fmt().
 3. CONFIG_BUG is not set. In that case pkill_on_warn should not be considered.

Please, correct me if needed.

Best regards,
Alexander
