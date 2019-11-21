Return-Path: <SRS0=edhZ=ZN=lists.openwall.com=kernel-hardening-return-17410-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF05C432C0
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 Nov 2019 13:03:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8C403208A1
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 Nov 2019 13:03:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C403208A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=virtuozzo.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17410-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1897 invoked by uid 550); 21 Nov 2019 13:03:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31974 invoked from network); 21 Nov 2019 12:53:31 -0000
Subject: Re: [PATCH 1/3] ubsan: Add trap instrumentation option
To: Kees Cook <keescook@chromium.org>
Cc: Elena Petrova <lenaptr@google.com>,
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Dan Carpenter <dan.carpenter@oracle.com>,
 "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Arnd Bergmann
 <arnd@arndb.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
References: <20191120010636.27368-1-keescook@chromium.org>
 <20191120010636.27368-2-keescook@chromium.org>
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Message-ID: <35fa415f-1dab-b93d-f565-f0754b886d1b@virtuozzo.com>
Date: Thu, 21 Nov 2019 15:52:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191120010636.27368-2-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 11/20/19 4:06 AM, Kees Cook wrote:


> +config UBSAN_TRAP
> +	bool "On Sanitizer warnings, stop the offending kernel thread"

That description seems inaccurate and confusing. It's not about kernel threads.
UBSAN may trigger in any context - kernel thread/user process/interrupts... 
Probably most of the kernel code runs in the context of user process, so "stop the offending kernel thread"
doesn't sound right.



> +	depends on UBSAN
> +	depends on $(cc-option, -fsanitize-undefined-trap-on-error)
> +	help
> +	  Building kernels with Sanitizer features enabled tends to grow
> +	  the kernel size by over 5%, due to adding all the debugging
> +	  text on failure paths. To avoid this, Sanitizer instrumentation
> +	  can just issue a trap. This reduces the kernel size overhead but
> +	  turns all warnings into full thread-killing exceptions.

I think we should mention that enabling this option also has a potential to 
turn some otherwise harmless bugs into more severe problems like lockups, kernel panic etc..
So the people who enable this would better understand what they signing up for.

