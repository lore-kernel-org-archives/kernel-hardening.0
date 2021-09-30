Return-Path: <SRS0=gZ3n=OU=lists.openwall.com=kernel-hardening-return-21403-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82247C433EF
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Sep 2021 18:36:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D75CA60041
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Sep 2021 18:36:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D75CA60041
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 5878 invoked by uid 550); 30 Sep 2021 18:36:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5846 invoked from network); 30 Sep 2021 18:36:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/gsG+dDfg+OEmiWFR9f128A++n69MzAw+gEWwpvDIp8=;
        b=VNu/trbhf4rcGgiRp4aVF6Dbtrkt79akhd6yrEfkZfun1GP5HxZ0L6MkNb3GGdZzqD
         D5qqS5NprqVDLe0eu1PukY8wmYjZcN5LiSA5bCPShIME6izBkbl72ztJ9Kh79ZmmwOw1
         aDflBwa5WWuEn0hC8XbqsTIRC7nfRnQMNAJGo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/gsG+dDfg+OEmiWFR9f128A++n69MzAw+gEWwpvDIp8=;
        b=5cqx1reDAF1VBjVeULPsXI+Tm5vPvrxua5pHeOnxwRatfvOHS9M4KOXk9iDGbharmk
         aqy4vQh2uKPShDZ+z/lYkP07IsRsV+njC60Cz8UrZQsMxr4BoDK78zb1sggn1xLIvhsB
         ZtI+Yq4o/IJY8YuEVpFCqxrWiijf/lruCbCoAHqShTL958uTyZtMaMaUn6MJMniqMvNj
         H1txH68vp2b+H+ygK0UIQlbHCDzg+17t7P2oJvwdgsJindcubMPIDeII4ceDonZUSjb3
         c2Nd+KNCKVl63c32Z9eJwrqSuShr4ViXHHkYMNr/9z/vhKJClGliMiSSYqQ89ksib/7o
         oFPg==
X-Gm-Message-State: AOAM532B5Ak4fusXYVgUAUwHGmctVkM2rfTv//ufX5hQoxkJnRak9MV1
	jEI+p0iVxH+MbtBpdM+nb95u/Q==
X-Google-Smtp-Source: ABdhPJy/VN7qqOla/6qjAbLdd2x2NzBnIjBETF+KYtliEJ0+Bw6n+RPnkokM4Wyn7Uc4E+RacBpj2A==
X-Received: by 2002:a62:3893:0:b0:44b:9369:5de5 with SMTP id f141-20020a623893000000b0044b93695de5mr5707789pfa.40.1633026987872;
        Thu, 30 Sep 2021 11:36:27 -0700 (PDT)
Date: Thu, 30 Sep 2021 11:36:26 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Popov <alex.popov@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Paul McKenney <paulmck@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Joerg Roedel <jroedel@suse.de>, Maciej Rozycki <macro@orcam.me.uk>,
	Muchun Song <songmuchun@bytedance.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, Petr Mladek <pmladek@suse.com>,
	Luis Chamberlain <mcgrof@kernel.org>, Wei Liu <wl@xen.org>,
	John Ogness <john.ogness@linutronix.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Alexey Kardashevskiy <aik@ozlabs.ru>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Jann Horn <jannh@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andy Lutomirski <luto@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Will Deacon <will.deacon@arm.com>,
	David S Miller <davem@davemloft.net>,
	Borislav Petkov <bp@alien8.de>, kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, notify@kernel.org
Subject: Re: [PATCH] Introduce the pkill_on_warn boot parameter
Message-ID: <202109301132.E29DB764E8@keescook>
References: <20210929185823.499268-1-alex.popov@linux.com>
 <d290202d-a72d-0821-9edf-efbecf6f6cef@linux.com>
 <20210929163143.aa8b70ac9d5cf0b628823370@linux-foundation.org>
 <de96ffec-bbd8-2724-9285-0867cd9a08a0@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de96ffec-bbd8-2724-9285-0867cd9a08a0@linux.com>

On Thu, Sep 30, 2021 at 09:27:43PM +0300, Alexander Popov wrote:
> On 30.09.2021 02:31, Andrew Morton wrote:
> > On Wed, 29 Sep 2021 22:01:33 +0300 Alexander Popov <alex.popov@linux.com> wrote:
> > 
> >> On 29.09.2021 21:58, Alexander Popov wrote:
> >> [...]
> >> If you are fine with this approach, I will prepare a patch adding the
> >> pkill_on_warn sysctl.
> > 
> > Why do we need a boot parameter?  Isn't a sysctl all we need for this
> > feature? 
> 
> I would say we need both sysctl and boot parameter for pkill_on_warn.
> That would be consistent with panic_on_warn, ftrace_dump_on_oops and
> oops/panic_on_oops.

If you want to change it at runtime, just make a sysctl: it will
be available as a bootparam since v5.8. See commit 3db978d480e2
("kernel/sysctl: support setting sysctl parameters from kernel command
line")

-- 
Kees Cook
