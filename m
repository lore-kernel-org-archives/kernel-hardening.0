Return-Path: <SRS0=xm4c=4T=lists.openwall.com=kernel-hardening-return-18044-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3376EC3F2D1
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Mar 2020 22:38:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 814AF20848
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Mar 2020 22:38:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="GjfdZfC1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 814AF20848
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18044-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7762 invoked by uid 550); 2 Mar 2020 22:38:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7711 invoked from network); 2 Mar 2020 22:38:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vMvtD7yXrueh3vfUHlByM8qY7eCzHyinRu2E+qXaOss=;
        b=GjfdZfC1QiuMpLpPsnZEuquo4oHOa6dHmIj6OqZDUbNT7AclNTgp0O4svXm4SryVJt
         Olz68E/9hj1IIa7jv4bNLsvw2rAtQJ7hTpi0ZlT45hPzFXva4B3s2ep3nII4TGhQndrc
         lRyYcirIVSu4/s+87HgtYyVQvIRweobi5fik8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vMvtD7yXrueh3vfUHlByM8qY7eCzHyinRu2E+qXaOss=;
        b=rNp6mQmQZSv82k4+p+bKpaXDf/Bp9JhlYayF6nlszP8PqB5Fgr3uFSa73KGg8PAvI1
         q3JlgnyP0IIKz86YuVN9bxOtGyarUYPVPmBgDxenN1x8qWO2F2myJaUYH+gZj88TE+6m
         GiUBQi61wH3Xc7NiM8f7/2KIiLrjKB/CBxu7if7IFOsEh08FIIlbzFebpbauxceaArGn
         sgge7mcEHZwAvzqeFCFVJ5/B2hhNv3QtkPIaAXKYu8+zka4tPAvL/Ao9QMQ/EADJk2Uy
         CHmb+CVc7O0wZn4BQBcrWSIfrjjw/r3/8Fm1JwlBQFM0UPWDF9bDUhYRCgHxqX86OzVn
         flAA==
X-Gm-Message-State: ANhLgQ0/cwxcLJZ7ce98ucGHa6NxFwd7/OJiwLX7d6rnyhDmbFpzPyKP
	dohqjeB7lw4+D+AZAU48ZRBtRw==
X-Google-Smtp-Source: ADFU+vu+LBEKzP0lHq5FZPqaf5eomvXFSkF432SpPtfLA/ZzVKEhYND7T51KsXHbjKA27j0gEiLnKQ==
X-Received: by 2002:a63:564d:: with SMTP id g13mr1025563pgm.157.1583188668690;
        Mon, 02 Mar 2020 14:37:48 -0800 (PST)
Date: Mon, 2 Mar 2020 14:37:46 -0800
From: Kees Cook <keescook@chromium.org>
To: Jann Horn <jannh@google.com>
Cc: Will Deacon <will@kernel.org>, Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jan Glauber <jglauber@marvell.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH] lib/refcount: Document interaction with PID_MAX_LIMIT
Message-ID: <202003021434.713F5559@keescook>
References: <20200302195352.226103-1-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302195352.226103-1-jannh@google.com>

On Mon, Mar 02, 2020 at 08:53:52PM +0100, Jann Horn wrote:
> Document the circumstances under which refcount_t's saturation mechanism
> works deterministically.
> 
> Signed-off-by: Jann Horn <jannh@google.com>

Acked-by: Kees Cook <keescook@chromium.org>

With one note below...

> ---
>  include/linux/refcount.h | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/refcount.h b/include/linux/refcount.h
> index 0ac50cf62d062..cf14db393d89d 100644
> --- a/include/linux/refcount.h
> +++ b/include/linux/refcount.h
> @@ -38,11 +38,20 @@
>   * atomic operations, then the count will continue to edge closer to 0. If it
>   * reaches a value of 1 before /any/ of the threads reset it to the saturated
>   * value, then a concurrent refcount_dec_and_test() may erroneously free the
> - * underlying object. Given the precise timing details involved with the
> - * round-robin scheduling of each thread manipulating the refcount and the need
> - * to hit the race multiple times in succession, there doesn't appear to be a
> - * practical avenue of attack even if using refcount_add() operations with
> - * larger increments.
> + * underlying object.
> + * Linux limits the maximum number of tasks to PID_MAX_LIMIT, which is currently
> + * 0x400000 (and can't easily be raised in the future beyond FUTEX_TID_MASK).

Maybe just to clarify and make readers not have to go search the source:

	"... beyond FUTEX_TID_MASK, which is UAPI defined as 0x3fffffff)."

and is it worth showing the math on this, just to have it clearly
stated?

-Kees

> + * With the current PID limit, if no batched refcounting operations are used and
> + * the attacker can't repeatedly trigger kernel oopses in the middle of refcount
> + * operations, this makes it impossible for a saturated refcount to leave the
> + * saturation range, even if it is possible for multiple uses of the same
> + * refcount to nest in the context of a single task.
> + * If hundreds of references are added/removed with a single refcounting
> + * operation, it may potentially be possible to leave the saturation range; but
> + * given the precise timing details involved with the round-robin scheduling of
> + * each thread manipulating the refcount and the need to hit the race multiple
> + * times in succession, there doesn't appear to be a practical avenue of attack
> + * even if using refcount_add() operations with larger increments.
>   *
>   * Memory ordering
>   * ===============
> 
> base-commit: 98d54f81e36ba3bf92172791eba5ca5bd813989b
> -- 
> 2.25.0.265.gbab2e86ba0-goog
> 

-- 
Kees Cook
