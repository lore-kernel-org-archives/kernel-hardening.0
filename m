Return-Path: <SRS0=vWBR=ZN=lists.openwall.com=kernel-hardening-return-17411-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD030C432C0
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 Nov 2019 13:03:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 399E22089D
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 Nov 2019 13:03:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 399E22089D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=virtuozzo.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17411-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3269 invoked by uid 550); 21 Nov 2019 13:03:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32239 invoked from network); 21 Nov 2019 12:55:08 -0000
Subject: Re: [PATCH 2/3] ubsan: Split "bounds" checker from other options
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
 <20191120010636.27368-3-keescook@chromium.org>
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Message-ID: <06a84afd-bc97-d2b5-3129-d23473f7acb5@virtuozzo.com>
Date: Thu, 21 Nov 2019 15:54:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191120010636.27368-3-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit



On 11/20/19 4:06 AM, Kees Cook wrote:
> In order to do kernel builds with the bounds checker individually
> available, introduce CONFIG_UBSAN_BOUNDS, with the remaining options
> under CONFIG_UBSAN_MISC.
> 
> For example, using this, we can start to expand the coverage syzkaller is
> providing. Right now, all of UBSan is disabled for syzbot builds because
> taken as a whole, it is too noisy. This will let us focus on one feature
> at a time.
> 
> For the bounds checker specifically, this provides a mechanism to
> eliminate an entire class of array overflows with close to zero
> performance overhead (I cannot measure a difference). In my (mostly)
> defconfig, enabling bounds checking adds ~4200 checks to the kernel.
> Performance changes are in the noise, likely due to the branch predictors
> optimizing for the non-fail path.
> 
> Some notes on the bounds checker:
> 
> - it does not instrument {mem,str}*()-family functions, it only
>   instruments direct indexed accesses (e.g. "foo[i]"). Dealing with
>   the {mem,str}*()-family functions is a work-in-progress around
>   CONFIG_FORTIFY_SOURCE[1].
> 
> - it ignores flexible array members, including the very old single
>   byte (e.g. "int foo[1];") declarations. (Note that GCC's
>   implementation appears to ignore _all_ trailing arrays, but Clang only
>   ignores empty, 0, and 1 byte arrays[2].)
> 
> [1] https://github.com/KSPP/linux/issues/6
> [2] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=92589
> 
> Suggested-by: Elena Petrova <lenaptr@google.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Andrey Ryabinin <aryabinin@virtuozzo.com>

