Return-Path: <SRS0=Wg9k=BN=lists.openwall.com=kernel-hardening-return-19540-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F26C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Aug 2020 17:45:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A0E5920775
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Aug 2020 17:45:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="g6QLhlkT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0E5920775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19540-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11419 invoked by uid 550); 3 Aug 2020 17:45:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11399 invoked from network); 3 Aug 2020 17:45:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8VKCoo7Vmd7+mSWuTkGx9LAevVUhaDOReRxys5hawyY=;
        b=g6QLhlkTh78wPq19hgd3aCUUx0Imw7hHpDpHRoUNeo8fIu9NRFI4aUriW0Z9BZniQG
         YzPHxc2H1xDFqOxe+EWig27ebzxgINQXziK4Nb917fzY4xDxIZ66ACPlaTcIxxII7O3R
         WglKCd8y5damXG5BfnBTutACt6Bn2FSIsAjWU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8VKCoo7Vmd7+mSWuTkGx9LAevVUhaDOReRxys5hawyY=;
        b=pM/5RJMbaYQN5Xl3TSMHVdgkO+xTLHnOmvMr3/5YS9ZFsalKim7pFlsYaAb/ofrzi9
         IYdjlZ8rSFkPN41vEHGbxTIjcaCOYAeZ4A7Gqc94rL4mPsgUz1hbKD4EhKo/2c3C3PTR
         qX5o31oVnS+cwgqmd6J//YDreXEcWuNkgnoij5Aa9DMUa9NjNC8YaXP9mAITx0IW3gLB
         7ZIjmp2qfYMSfSjUlPF6YFzca5hVDp4lIHm9Lc8aqbBNjW95NEl674cfpPzHguZNIaK/
         aWygPa3WCThV3NIvrrUR3x5XjRds2chxJQP6oJyzqXVI+Tguod4N81ieC+Q75noropBx
         kuRA==
X-Gm-Message-State: AOAM530pdTALNUSa51pE7QQpRaw4m+C4pvpU4pbU7Xq6c48XL0IQKdVt
	0+BJZE7VfVYYzNb5P2yDKAZuz8Qfv8o=
X-Google-Smtp-Source: ABdhPJzGj8xXq4IjYCLnxux+Nc8xy7BtserkIGiDWL6WvrAEGhBWNwOQEcukf/40EE3PYPMrIuBRGw==
X-Received: by 2002:a17:90a:ca85:: with SMTP id y5mr430416pjt.87.1596476737437;
        Mon, 03 Aug 2020 10:45:37 -0700 (PDT)
Date: Mon, 3 Aug 2020 10:45:35 -0700
From: Kees Cook <keescook@chromium.org>
To: Evgenii Shatokhin <eshatokhin@virtuozzo.com>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>,
	Miroslav Benes <mbenes@suse.cz>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	live-patching@vger.kernel.org,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>, Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <202008031043.FE182E9@keescook>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <e9c4d88b-86db-47e9-4299-3fac45a7e3fd@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9c4d88b-86db-47e9-4299-3fac45a7e3fd@virtuozzo.com>

On Mon, Aug 03, 2020 at 02:39:32PM +0300, Evgenii Shatokhin wrote:
> There are at least 2 places where high-order memory allocations might happen
> during module loading. Such allocations may fail if memory is fragmented,
> while physically contiguous memory areas are not really needed there. I
> suggest to switch to kvmalloc/kvfree there.

While this does seem to be the right solution for the extant problem, I
do want to take a moment and ask if the function sections need to be
exposed at all? What tools use this information, and do they just want
to see the bounds of the code region? (i.e. the start/end of all the
.text* sections) Perhaps .text.* could be excluded from the sysfs
section list?

-- 
Kees Cook
