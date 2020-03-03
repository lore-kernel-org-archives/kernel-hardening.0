Return-Path: <SRS0=DrLM=4U=lists.openwall.com=kernel-hardening-return-18055-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E83C3F2C6
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Mar 2020 21:09:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7610520848
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Mar 2020 21:09:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fOl9x86g"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7610520848
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18055-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19811 invoked by uid 550); 3 Mar 2020 21:09:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19778 invoked from network); 3 Mar 2020 21:09:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fwR7Sl83KeOsQT2W/DAwpFl0ZV6iw1v764tWAtDVZSg=;
        b=fOl9x86ga//EGU5D5JLMkKF+bt8LyTcxJBIWZ2dGr89Mpzz9sg46dz3Z9WXg5spuRf
         +5KkAM260XOqr4hFezfI0dAMkVHm2QrNAdvp27/d0QuCbfShXZU0mrxDKnCkuSp5mQ49
         k9DQfKig4a/pE10r0ArWlycQSAwDX+FIKAyW8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fwR7Sl83KeOsQT2W/DAwpFl0ZV6iw1v764tWAtDVZSg=;
        b=BY6ymeWbXUYMcg9J/DzVRm54kSPPdHPVvCP94rhLSEUSdx/RVwEL/SB98r/cLXQE5c
         cjU6JKo/zvp0PXQ9l088eRZfVAGtMNCKQZaOQVMSSyWTZolT8QcCPedsrAEEGl75uN23
         LsEiNFnFMSpR4eIeNcLNKuu1YNOkFM6+29kt1iuVtlZTQcipaRRbDcsu+4//KLzuKm8I
         IdrXZFN3ITq8fikYSUNzEv5N+eL6hTdk3oSfGxyu94OZvfR26ZqdyYD8/Hbpgpfv9Zac
         msHPjbpcCxxYAekDJ0gUmNXiBPCrcn/m3NG/T0hLfodnBg9AyPYqcHyJk7mjWdGEgzWk
         sTig==
X-Gm-Message-State: ANhLgQ2yahJXZeL4g+xIDKo5zowt6o9FI8BchGryHGMJolv4h78UZ/PL
	fiiBMPTzJDaNAGIi9Ef2n9cgMg==
X-Google-Smtp-Source: ADFU+vt03b0iuZ1w20LE5zwsZxme9o61Zd37p0buS3FKRP9h1g71JeHZkeIPeVEiUTWSKQkmQDa2bw==
X-Received: by 2002:a17:902:9a42:: with SMTP id x2mr6295193plv.194.1583269768021;
        Tue, 03 Mar 2020 13:09:28 -0800 (PST)
Date: Tue, 3 Mar 2020 13:09:26 -0800
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
Subject: Re: [PATCH v2] lib/refcount: Document interaction with PID_MAX_LIMIT
Message-ID: <202003031309.FBE806C@keescook>
References: <20200303105427.260620-1-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303105427.260620-1-jannh@google.com>

On Tue, Mar 03, 2020 at 11:54:27AM +0100, Jann Horn wrote:
> Document the circumstances under which refcount_t's saturation mechanism
> works deterministically.
> 
> Signed-off-by: Jann Horn <jannh@google.com>

Acked-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees

> 
> Notes:
>     v2:
>      - write down the math (Kees)
> 
>  include/linux/refcount.h | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/refcount.h b/include/linux/refcount.h
> index 0ac50cf62d062..0e3ee25eb156a 100644
> --- a/include/linux/refcount.h
> +++ b/include/linux/refcount.h
> @@ -38,11 +38,24 @@
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
> + * With the current PID limit, if no batched refcounting operations are used and
> + * the attacker can't repeatedly trigger kernel oopses in the middle of refcount
> + * operations, this makes it impossible for a saturated refcount to leave the
> + * saturation range, even if it is possible for multiple uses of the same
> + * refcount to nest in the context of a single task:
> + *
> + *     (UINT_MAX+1-REFCOUNT_SATURATED) / PID_MAX_LIMIT =
> + *     0x40000000 / 0x400000 = 0x100 = 256
> + *
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
