Return-Path: <SRS0=2W5J=25=lists.openwall.com=kernel-hardening-return-17553-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C115C282DD
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jan 2020 17:39:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 620A520692
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jan 2020 17:39:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="GTNCpgnT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 620A520692
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17553-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5668 invoked by uid 550); 8 Jan 2020 17:39:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5634 invoked from network); 8 Jan 2020 17:39:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bKjvwLoHlC29TnvYqxLfJzXQCusKrCOIAaFwwH7cSJ0=;
        b=GTNCpgnTvYnInEtO3QFpRZVybeL6CBYzJJx27ePUFw0/SafUvNxEYcOYQfvASQ6xqX
         6j+5vDN0aFTy3n2vQk6NkoWpkjjM2jUwkxQaSbL/wj3TBgA2VXvX2hZcLRoUwLWwSopL
         JoZOKKbVLSYcz5PbBGPmd9fCF6ZxmqIR6YilM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bKjvwLoHlC29TnvYqxLfJzXQCusKrCOIAaFwwH7cSJ0=;
        b=qaGYL6dQCC9UMWRbdIq2kTKlI7I8A8FRR7SFgYsBtoaQZrn6Cu2jxtcVLtH8K+8xx0
         i7F5IZlilLKhKvHY7N1b+l08x98MktQKuqrYWn/60xcnqmk2fx/si5tRNnpbqrz2Kx3/
         ybKEh0EjhbWcohrJyQq2bZmt+dPg/dPnNtZ7BZ37RQ22KIARBjXKKY5cS/Kb0dan9lPI
         5Uzck2tChk+IzjT+8LBh/WK8XCHtHvUVh2XRjE4ewtX3cs+ISFOmuvNEK8OUv6/CKVE0
         z9St8bJ32vzxp0ldijmZ+s7ZP6OSlA9LD9P2myEu6Lxza+R2Rtv7rJ/8UXUUdYgaBj12
         tnTA==
X-Gm-Message-State: APjAAAXb1fwFADxqFgZyVqVKNVeSDcFh3svuplh0LnARVffJUfGbUKgd
	p2fIqEHX8pzzXvJF8a8Iy2C0mg==
X-Google-Smtp-Source: APXvYqxdgwKREsz1YZeH4VDxSzla/QubcfkdDOAeGwicuj/jBB+4Si/iUY0qR/AhKo7jBTllsOCHfg==
X-Received: by 2002:a65:63ce:: with SMTP id n14mr6602246pgv.282.1578505169677;
        Wed, 08 Jan 2020 09:39:29 -0800 (PST)
Date: Wed, 8 Jan 2020 09:39:27 -0800
From: Kees Cook <keescook@chromium.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Tianlin Li <tli@digitalocean.com>, kernel-hardening@lists.openwall.com,
	Alex Deucher <alexander.deucher@amd.com>, David1.Zhou@amd.com,
	David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/2] drm/radeon: have the callers of set_memory_*() check
 the return value
Message-ID: <202001080936.A36005F1@keescook>
References: <20200107192555.20606-1-tli@digitalocean.com>
 <b5984995-7276-97d3-a604-ddacfb89bd89@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b5984995-7276-97d3-a604-ddacfb89bd89@amd.com>

On Wed, Jan 08, 2020 at 01:56:47PM +0100, Christian König wrote:
> Am 07.01.20 um 20:25 schrieb Tianlin Li:
> > Right now several architectures allow their set_memory_*() family of
> > functions to fail, but callers may not be checking the return values.
> > If set_memory_*() returns with an error, call-site assumptions may be
> > infact wrong to assume that it would either succeed or not succeed at
> > all. Ideally, the failure of set_memory_*() should be passed up the
> > call stack, and callers should examine the failure and deal with it.
> > 
> > Need to fix the callers and add the __must_check attribute. They also
> > may not provide any level of atomicity, in the sense that the memory
> > protections may be left incomplete on failure. This issue likely has a
> > few steps on effects architectures:
> > 1)Have all callers of set_memory_*() helpers check the return value.
> > 2)Add __must_check to all set_memory_*() helpers so that new uses do
> > not ignore the return value.
> > 3)Add atomicity to the calls so that the memory protections aren't left
> > in a partial state.
> > 
> > This series is part of step 1. Make drm/radeon check the return value of
> > set_memory_*().
> 
> I'm a little hesitate merge that. This hardware is >15 years old and nobody
> of the developers have any system left to test this change on.

If that's true it should be removed from the tree. We need to be able to
correctly make these kinds of changes in the kernel.

> Would it be to much of a problem to just add something like: r =
> set_memory_*(); (void)r; /* Intentionally ignored */.

This seems like a bad idea -- we shouldn't be papering over failures
like this when there is logic available to deal with it.

> Apart from that certainly a good idea to add __must_check to the functions.

Agreed!

-Kees

-- 
Kees Cook
