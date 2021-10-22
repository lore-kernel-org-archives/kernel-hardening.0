Return-Path: <SRS0=c4Q/=PK=lists.openwall.com=kernel-hardening-return-21449-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09501C433F5
	for <kernel-hardening@archiver.kernel.org>; Fri, 22 Oct 2021 17:30:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3005D60FF2
	for <kernel-hardening@archiver.kernel.org>; Fri, 22 Oct 2021 17:30:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3005D60FF2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 22120 invoked by uid 550); 22 Oct 2021 17:30:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22088 invoked from network); 22 Oct 2021 17:30:33 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yhmb7SMolTFSFPkuCtUT1R9/SpbKWVlxH0z/5kxG25Q=;
        b=DdaVBgPnrxY5RZgGpD7GNez3axMXfYxyEeslR8F0h9YATWg3OEGjK7YJHxtXd73YKA
         l/ECMJF5MXudirG+dv9HztK9uznVNDOsd1tdvEs7XXSYZqHNmig7AjBB9LGZUOTdtgNW
         C4cXFoYHnLhVfUVV+8A0CKxXTnsAxAMwnMKGcDpWHhiK0Co/X2XTIzJ0aXUI2pDNOD4B
         yPLYah21XsxvuPrBPnDn7D5zxeeh8jF0TsnJoITrUXG7v6Lp/cPfHPwejNST732sf+lH
         r92xRUSg3jBdhCZPfzDvfPIEprxbB0QLjIjPij57a8EDDuDV2oa2xr77jSMK1oVrLTXi
         wfaQ==
X-Gm-Message-State: AOAM530ukIS0P6FeAlkKzdzLieeom0240wXuj302nXmIVxggsHIEHuL5
	Yy8ixoBrOgFpfjmGTgEKDAQ=
X-Google-Smtp-Source: ABdhPJx599sCveXhzPx/xzj7g4rGtKBwrNo9l+uSZOseIfrseHHHDJJYn54KfbvfhwYjKU6q64U4Cg==
X-Received: by 2002:a05:600c:4111:: with SMTP id j17mr30439519wmi.59.1634923822289;
        Fri, 22 Oct 2021 10:30:22 -0700 (PDT)
Message-ID: <23abb989-c20c-0dc0-019c-272beca8cee6@linux.com>
Date: Fri, 22 Oct 2021 20:30:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] Introduce the pkill_on_warn boot parameter
Content-Language: en-US
To: "Eric W. Biederman" <ebiederm@xmission.com>
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
 <ba67ead7-f075-e7ad-3274-d9b2bc4c1f44@linux.com>
 <CAHk-=whrLuVEC0x+XzYUNV2de5kM-k39GkJWwviQNuCdZ0nfKg@mail.gmail.com>
 <0e847d7f-7bf0-cdd4-ba6e-a742ce877a38@linux.com> <87zgrnqmlc.fsf@disp2133>
From: Alexander Popov <alex.popov@linux.com>
In-Reply-To: <87zgrnqmlc.fsf@disp2133>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.10.2021 22:48, Eric W. Biederman wrote:
> Especially as calling do_group_exit(SIGKILL) from a random location is
> not a clean way to kill a process.  Strictly speaking it is not even
> killing the process.
> 
> Partly this is just me seeing the introduction of a
> do_group_exit(SIGKILL) call and not likely the maintenance that will be
> needed.  I am still sorting out the problems with other randomly placed
> calls to do_group_exit(SIGKILL) and interactions with ptrace and
> PTRACE_EVENT_EXIT in particular.
> 
> Which is a long winded way of saying if I can predictably trigger a
> warning that calls do_group_exit(SIGKILL), on some architectures I can
> use ptrace and  can convert that warning into a way to manipulate the
> kernel stack to have the contents of my choice.
> 
> If anyone goes forward with this please use the existing oops
> infrastructure so the ptrace interactions and anything else that comes
> up only needs to be fixed once.

Hello Eric, hello everyone.

I learned the oops infrastructure and see that it's arch-specific.
The architectures have separate implementations of the die() function with 
different prototypes. I don't see how to use the oops infrastructure for killing 
all threads in a process that hits a kernel warning.

What do you think about doing the same as the oom_killer (and some other 
subsystems)? It kills all threads in a process this way:
   do_send_sig_info(SIGKILL, SEND_SIG_PRIV, current, PIDTYPE_TGID).

The oom_killer also shows a nice way to avoid killing init and kthreads:
	static bool oom_unkillable_task(struct task_struct *p)
	{
		if (is_global_init(p))
			return true;
		if (p->flags & PF_KTHREAD)
			return true;
		return false;
	}
I want to do something similar.

I would appreciate your comments.
Best regards,
Alexander
