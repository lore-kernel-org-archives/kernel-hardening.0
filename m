Return-Path: <SRS0=MTA/=BB=lists.openwall.com=kernel-hardening-return-19406-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D25F4C433E2
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 14:40:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3184A2053B
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 14:40:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="m6/oHRfM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3184A2053B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19406-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24318 invoked by uid 550); 22 Jul 2020 14:40:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24295 invoked from network); 22 Jul 2020 14:40:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=16Y8bWUyysyD6RX/r5XeFDtXgEqasoaIb5QlD/Fn9gY=;
        b=m6/oHRfM8k+Nz9zcIKR0qeNOD5tEEwDyDId3PTGUUDN4p9UGsI0fn00KoI9/QyQ1v8
         apM4heGRp20HL1suh7bRv/oYHQT+8FbwsOEUGzspMxDK5to8xMCVJ1IVeG4ELQ8PRnvM
         UVLan5R8bzs3XxdU33aX86W1aVtTlW0hiqd8Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=16Y8bWUyysyD6RX/r5XeFDtXgEqasoaIb5QlD/Fn9gY=;
        b=H8zdCZli5nvDx+IL1ajuS+G5oJZAnXTnUn+OLrp/OfQA2sEBltSIgxf8jEDDLWkrQz
         4N2V75hShg00w858HOsdEbhcNZ5vBFoN3Wgl8FJuw3e5wQI1/q6mQP5jpeo2tnRYbwLI
         Qd74seszClb/DQA3fq9HJOwvmy++gnKkLpXT+3uI/LukyoFc3NN/6CgkJlL4NQcX7+Gj
         3zojjwvAiPph4H6YQ6N0vdzIziFPpnpMocQGFgAz+hnndn0+s8Z0sr1v8RKHj/L+zWQ1
         YZsmjm2N/WiEacE/IrrQKWHJPCdFBUi5HpbAWx1jEVY0D33bsUPtR8eDV7gCdq3xSxnt
         efTw==
X-Gm-Message-State: AOAM533mxc/YRKV7gRWBusSCE8+9qTOcmh/Y4SwdrAXcWK5ij3D0qh1M
	FtChZjMMoF+zU5/EZW0yi5o8kg==
X-Google-Smtp-Source: ABdhPJybf+F7pwNThVxNEaAxDjLaau/pl+1vyZd8ayI2jp7rUGVlHGz+ar7yf1UhbFootA15osR7TA==
X-Received: by 2002:aa7:9ac6:: with SMTP id x6mr3300pfp.326.1595428797861;
        Wed, 22 Jul 2020 07:39:57 -0700 (PDT)
Date: Wed, 22 Jul 2020 07:39:55 -0700
From: Kees Cook <keescook@chromium.org>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	live-patching@vger.kernel.org
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <202007220738.72F26D2480@keescook>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>

On Wed, Jul 22, 2020 at 11:27:30AM +0200, Miroslav Benes wrote:
> Let me CC live-patching ML, because from a quick glance this is something 
> which could impact live patching code. At least it invalidates assumptions 
> which "sympos" is based on.

In a quick skim, it looks like the symbol resolution is using
kallsyms_on_each_symbol(), so I think this is safe? What's a good
selftest for live-patching?

-- 
Kees Cook
