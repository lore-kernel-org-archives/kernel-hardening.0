Return-Path: <SRS0=qd4q=OU=lists.openwall.com=kernel-hardening-return-21400-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFAEFC4332F
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Sep 2021 18:20:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 05A6E61A10
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Sep 2021 18:20:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 05A6E61A10
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 28113 invoked by uid 550); 30 Sep 2021 18:20:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28081 invoked from network); 30 Sep 2021 18:20:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rRzmSQnYKN75Gg93YuIv+rBGX5i47OpZAXZvIJOPAT0=;
        b=lEQ8DLBf3vFDxlv1guB97pybHM/E5OgqqY7s5GW48JHxOcQmMFcVANRfaTHTtWIF9Y
         9kRwW6x+vjlSmmTqC0Stb7CrJ/tg3DjlMrf5MAtA7cjscqC+AIUITJ17K3S1fLhd9/Xb
         H6Q003Tl/g15SHWxlAxw0KfC0GrYBfK6GsZ94=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rRzmSQnYKN75Gg93YuIv+rBGX5i47OpZAXZvIJOPAT0=;
        b=l80g6wSiXShSbjwfBneCLthokuyHNRwtnvMfGVlwmCsOEugFiyEgmMmF8dpjPIggdH
         FJNxH7KICDVMoCxL1yBbIuMe/yNqQf2jFyGRvUTvP0FTmyKLK9x1goMCbtfN+eaGhvg6
         G1pNZLW9Fuu8BPpo7U0Va6bL/1OMAzfTs/jFzfU4vTn/dM43Nkw1yol966P/HQwH2oMx
         wQ9gkkKHh5Y4kSbFs07OOLEsmXKerrGrSWiCtP3ywidRWdf41uPJlA8HRDlLq7rxfUs9
         fvzyNnfo0HnwDmpxtuQOqXljQE9eDAF3bYDVA0HSqUSzh3JWk/SRHNXUURBktnorc5Gu
         rS+Q==
X-Gm-Message-State: AOAM5303G6NwC9oPXhrcx8sNA2C6BTgDg78U7LRHb7/kJx5IV7ycBANJ
	LYyjasrPnbifCArbHgwHU+p84A==
X-Google-Smtp-Source: ABdhPJyimYmtoacGEdurWEUSpaz+kvhw5xhIwlnWJodE7rV8ATefMii0ooqe8fOMpyVb9+6sAe5Wrw==
X-Received: by 2002:a17:903:2c2:b029:101:9c88:d928 with SMTP id s2-20020a17090302c2b02901019c88d928mr5409323plk.62.1633026036390;
        Thu, 30 Sep 2021 11:20:36 -0700 (PDT)
Date: Thu, 30 Sep 2021 11:20:34 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Popov <alex.popov@linux.com>
Cc: Dave Hansen <dave.hansen@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Paul McKenney <paulmck@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <202109301120.B7B8F3F8A@keescook>
References: <20210929185823.499268-1-alex.popov@linux.com>
 <323d0784-249d-7fef-6c60-e8426d35b083@intel.com>
 <202109291229.C64A1D9D@keescook>
 <cf6ada34-9854-b7ad-f671-52186da5abd0@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf6ada34-9854-b7ad-f671-52186da5abd0@linux.com>

On Thu, Sep 30, 2021 at 04:55:37PM +0300, Alexander Popov wrote:
> The kernel can hit warning and omit calling __warn() that prints the message.
> But pkill_on_warn action should be taken each time.
> 
> As I can understand now, include/asm-generic/bug.h defines three warning
> implementations:
>  1. CONFIG_BUG=y and the arch provides __WARN_FLAGS. In that case pkill_on_warn
> should be checked in report_bug() that you mention.
>  2. CONFIG_BUG=y and the arch doesn't have __WARN_FLAGS. In that case
> pkill_on_warn should be checked in warn_slowpath_fmt().
>  3. CONFIG_BUG is not set. In that case pkill_on_warn should not be considered.
> 
> Please, correct me if needed.

That looks correct to me, yes.

-- 
Kees Cook
