Return-Path: <SRS0=tIic=ZN=lists.openwall.com=kernel-hardening-return-17413-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6ED6C432C0
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 Nov 2019 17:57:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EEE5F206CC
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 Nov 2019 17:57:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hG0sz14Y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EEE5F206CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17413-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20274 invoked by uid 550); 21 Nov 2019 17:57:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20239 invoked from network); 21 Nov 2019 17:57:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BsdpXUBK/+PDo/bGd1kVifJ4d8KCjaa55rIEdqK/BXE=;
        b=hG0sz14Yni3p0qWbUJNX13B9DuEdfLpP+nS/rEmsrX4M5OTRctvejjuqOfyrYI9zQq
         RpGH7ur7MB1V7e9yxodQEa3kY26yeKYqW96dSDjOPOueXGKD1T+hMSHo1msATxMJokHy
         DwFCc3rTLf34Ino8r6gOOFxERJ57Y0oA23sms=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BsdpXUBK/+PDo/bGd1kVifJ4d8KCjaa55rIEdqK/BXE=;
        b=NH3FozfmV8/2kWgTlq1yXklvLF4wznHDmSoLYZwBUqitFOEuuSVoHA/N0yqHqPrk2X
         lAKxEo2CtIQeNIEl5+rNUbjt0zpkIJhPAFV7wax+qpA47grAwKg8GkiTXLpvNEmRu79H
         zYamvWGo6HkL5xZT4cEBkEFtlOdeBIUcw+nuHGCm+veT5I96NDixZV3D4x5zilkr1kjH
         ig1FetxcS32haPFnLf+baQGJ65IIjmR+X8CYje6Px3R3/YKPMIJgiSVYWXITFAmALuAO
         4G6Sco2WzLRBGao7AeXS3PmxIdLQXaW4pX3g8HNCHXOmoa5UrjDDqhRy/aZiS8QYxkf5
         SmhA==
X-Gm-Message-State: APjAAAVkxG2sWIMg+Eowdi0oQrWbQyRDThFrv5vogKy4Id10mO930G3I
	iT2DmW5X1uoIeCuFi2hnri25BA==
X-Google-Smtp-Source: APXvYqyqyLTCo109VwURE2Z+5MDb30JwQiuSUJ4BxXSBWfsR0v3JOl8GeyYN9tpZZT008lgQyTI29w==
X-Received: by 2002:aa7:96c5:: with SMTP id h5mr12206977pfq.101.1574359057218;
        Thu, 21 Nov 2019 09:57:37 -0800 (PST)
Date: Thu, 21 Nov 2019 09:57:34 -0800
From: Kees Cook <keescook@chromium.org>
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Elena Petrova <lenaptr@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH 1/3] ubsan: Add trap instrumentation option
Message-ID: <201911210942.3C9F299@keescook>
References: <20191120010636.27368-1-keescook@chromium.org>
 <20191120010636.27368-2-keescook@chromium.org>
 <35fa415f-1dab-b93d-f565-f0754b886d1b@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35fa415f-1dab-b93d-f565-f0754b886d1b@virtuozzo.com>

On Thu, Nov 21, 2019 at 03:52:52PM +0300, Andrey Ryabinin wrote:
> On 11/20/19 4:06 AM, Kees Cook wrote:
> > +config UBSAN_TRAP
> > +	bool "On Sanitizer warnings, stop the offending kernel thread"

BTW, is there a way (with either GCC or Clang implementations) to
override the trap handler? If I could get the instrumentation to call
an arbitrarily named function, we could build a better version of this
that actually continued without the large increase in image size.

For example, instead of __builtin_trap(), call __ubsan_warning(), which
could be defined as something like:

static __always_inline void __ubsan_warning(void)
{
	WARN_ON_ONCE(1);
}

That would make the warning survivable without the overhead of all the
debugging structures, etc.

-- 
Kees Cook
