Return-Path: <SRS0=lEOx=4O=lists.openwall.com=kernel-hardening-return-17933-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B1EC4BA0A
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:07:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BADEC20838
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:07:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="iAunlpGu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BADEC20838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=axtens.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17933-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13480 invoked by uid 550); 26 Feb 2020 06:07:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13440 invoked from network); 26 Feb 2020 06:07:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=wHnRWSkI/KPKw6tQwkKo0dZto1+RLrsK9CfP2hBdd44=;
        b=iAunlpGumDfMTCDwa2qDpliEwWgJJRKO4KOJHWiktC2X4lt65wcUnHSGHs3l6UP66Q
         d4Ocycbdkd/amh/DmSUexBB8vr8aDXUlPM5nn55YLs9ozjynb0f/G6A0DRUqp4fDNKUq
         72517XtJWuA4U0Cd0PsZA7s2vZe51bPW/k6s8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=wHnRWSkI/KPKw6tQwkKo0dZto1+RLrsK9CfP2hBdd44=;
        b=tcO1c+/Bd05SQIahyue0JUUhDQU2NWKz2c0ODZDiVWaUafukUe304wSq9tHDkEyz/q
         wmU5s7hQhsNdNhXzX5xip550iETKyGDDBXRWX4ZWmIFsIAG7Xp8duVQTEE/j15q39ppF
         UXIoe68iWZQ8jpQlSZBeI6oZLiyW5kscnQ7oJcFOGFeVC+qBK05U6m30+71VlUWFeHy+
         ljE1upXlJuT0qL0zA7YLrDmPtWeI/4ox6OtCKOjX+j59RQ3XiZmxAJwORn5IhUm3Rc7W
         GPgGznpaGVLx/HRT7CYo/5c5jPEHLjT2XuAfSatWtRhGufj+3apVIgVAGQ6xqJKtMkUI
         Odpw==
X-Gm-Message-State: APjAAAViO6fzUQFm3p9w8cBpHYw08pTyTNuXmH0YSAkdsgS6ZENnOulr
	5j70rQA0M5MF62Fc5k32ijJWIw==
X-Google-Smtp-Source: APXvYqy/xqWhxm0yEB7fap02Q6GRzScFy9XqEbLyCX3qDDPYVkQGakX1z25WIIR7ekand399s53kfA==
X-Received: by 2002:a63:4707:: with SMTP id u7mr2226588pga.221.1582697242816;
        Tue, 25 Feb 2020 22:07:22 -0800 (PST)
From: Daniel Axtens <dja@axtens.net>
To: Kees Cook <keescook@chromium.org>, Daniel Micay <danielmicay@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5/5] [RFC] mm: annotate memory allocation functions with their sizes
In-Reply-To: <202002251035.AD29F84@keescook>
References: <20200120074344.504-1-dja@axtens.net> <20200120074344.504-6-dja@axtens.net> <CA+DvKQJ6jRHZeZteqY7q-9sU8v3xacSPj65uac3PQfst4cKiMA@mail.gmail.com> <202002251035.AD29F84@keescook>
Date: Wed, 26 Feb 2020 17:07:18 +1100
Message-ID: <87wo89rieh.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain

Kees Cook <keescook@chromium.org> writes:

> On Fri, Feb 07, 2020 at 03:38:22PM -0500, Daniel Micay wrote:
>> There are some uses of ksize in the kernel making use of the real
>> usable size of memory allocations rather than only the requested
>> amount. It's incorrect when mixed with alloc_size markers, since if a
>> number like 14 is passed that's used as the upper bound, rather than a
>> rounded size like 16 returned by ksize. It's unlikely to trigger any
>> issues with only CONFIG_FORTIFY_SOURCE, but it becomes more likely
>> with -fsanitize=object-size or other library-based usage of
>> __builtin_object_size.
>
> I think the solution here is to use a macro that does the per-bucket
> rounding and applies them to the attributes. Keep the bucket size lists
> in sync will likely need some BUILD_BUG_ON()s or similar.

I can have a go at this but with various other work projects it has
unfortunately slipped way down the to-do list. So I've very happy for
anyone else to take this and run with it.

Regards,
Daniel

>
> -- 
> Kees Cook
