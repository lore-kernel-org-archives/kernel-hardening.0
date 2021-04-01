Return-Path: <SRS0=Jxzl=I6=lists.openwall.com=kernel-hardening-return-21133-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 611F0C433B4
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 21:46:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6C11F610CE
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 21:46:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C11F610CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21133-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5688 invoked by uid 550); 1 Apr 2021 21:46:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5668 invoked from network); 1 Apr 2021 21:46:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=usJD8QXCUUQ3yDD19nRhcfJUMWYiKf+EiZNOMzSngU8=;
        b=G4ChGKwb73jivZgOdREGW7Jl/xK+07gkogP9+1kyu2QispNTwwRqLKZMdl/YtU/+Lt
         /6pS84xtYTduYfABsJSoN4e+N+/d5AQAGm1DhERFMawsMiwP/sKWF3z+8kShjCvWc2Xx
         J1qo99Tg1cz6t80SOTCoCClKVew6dbnE2D8Wo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=usJD8QXCUUQ3yDD19nRhcfJUMWYiKf+EiZNOMzSngU8=;
        b=e3hKhOafXcBmenzgZAps+IWdog7pLAmFoyPzehgS/0loO8VDyvwOIo6sTQNdnzeJPk
         bZd3Rcmevxhb0XvzKD6M1kvvXF/XWPfidPqWt6hxPmb3BxxZ2SUek1miWn8rHv/uBJzU
         RIh1wAOmQk0Uy9UsFnqXscVoW2C43JBpUQ0vhhayUj1pC3j7kh25cINvj/Nz83o7QGx4
         UQYQ3KuboBuBU2QxfPPiufoibaU/KFAbH+JgQBc0RHRsFrU/jUX8bdUeQEgqWX6S9FDH
         w0rHLN6XX51qUIYDJQMSQwGl54wvjPLS3PpS5Xk8SOJIf6AgTnQDg4nAF4HjjPCIypOa
         v03g==
X-Gm-Message-State: AOAM532Ciz4P420pz4rkSM/yIQFUgAvgC9hwBc6p54Bw26+OzpOmTaA2
	2ELkpdaZ/IE1oNj+qjimqu6C1Q==
X-Google-Smtp-Source: ABdhPJw2Igjg2dUPUc361qNdAsnz5koMvMjgAifwUOU3txfIVOmKgYERtvxS6R3TbAJ8ajqzLbNIRQ==
X-Received: by 2002:a63:2f03:: with SMTP id v3mr9286709pgv.408.1617313584551;
        Thu, 01 Apr 2021 14:46:24 -0700 (PDT)
Date: Thu, 1 Apr 2021 14:46:23 -0700
From: Kees Cook <keescook@chromium.org>
To: Roy Yang <royyang@google.com>
Cc: akpm@linux-foundation.org, alex.popov@linux.com,
	ard.biesheuvel@linaro.org, catalin.marinas@arm.com, corbet@lwn.net,
	david@redhat.com, elena.reshetova@intel.com, glider@google.com,
	jannh@google.com, kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, luto@kernel.org, mark.rutland@arm.com,
	peterz@infradead.org, rdunlap@infradead.org, rppt@linux.ibm.com,
	tglx@linutronix.de, vbabka@suse.cz, will@kernel.org, x86@kernel.org
Subject: Re: [PATCH v8 0/6] Optionally randomize kernel stack offset each
 syscall
Message-ID: <202104011442.B20F2BAFC@keescook>
References: <20210330205750.428816-1-keescook@chromium.org>
 <20210401191744.1685896-1-royyang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401191744.1685896-1-royyang@google.com>

On Thu, Apr 01, 2021 at 12:17:44PM -0700, Roy Yang wrote:
> Both Android and Chrome OS really want this feature; For Container-Optimized OS, we have customers
> interested in the defense too.

It's pretty close! There are a couple recent comments that need to be
addressed, but hopefully it can land if x86 and arm64 maintainers are
happy v10.

> Change-Id: I1eb1b726007aa8f9c374b934cc1c690fb4924aa3
> -- 
> 2.31.0.208.g409f899ff0-goog

And to let other folks know, I'm guessing this email got sent with git
send-email to try to get a valid In-Reply-To header, but I guess git
trashed the Subject and ran hooks to generate a Change-Id UUID.

I assume it's from following the "Reply instructions" at the bottom of:
https://lore.kernel.org/lkml/20210330205750.428816-1-keescook@chromium.org/
(It seems those need clarification about Subject handling.)

-- 
Kees Cook
