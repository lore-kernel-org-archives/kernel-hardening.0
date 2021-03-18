Return-Path: <SRS0=4Cdl=IQ=lists.openwall.com=kernel-hardening-return-20974-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04593C433DB
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Mar 2021 01:22:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9D31164E02
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Mar 2021 01:22:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D31164E02
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20974-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22122 invoked by uid 550); 18 Mar 2021 01:22:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22090 invoked from network); 18 Mar 2021 01:22:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EalAswFOAcFp0mMFCKv9AaiQ3ouyPCG+tDog26PGvcI=;
        b=TSffuJwrnV2vab8/yGoahUmuVCMDXKwUtsys3/bDoxiRWc2F+tAbiwWP2aKGYHhGV8
         gzbjPnRuubA6uxOalwf/Z67un8+OC/fwBeJ8Upsa2Pv1pu1E+PVITOIEVPFFO+PQW43A
         yV0DB8OU4s1DHxtjiTSy0K6Yf3Xh0c37cc+7Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EalAswFOAcFp0mMFCKv9AaiQ3ouyPCG+tDog26PGvcI=;
        b=IDj5rcU2dGCNGdDuu0s2hCegEInr6o0rBnAceNvMzIdpncM79frfRG5YDB70Rt/u5P
         xfGaao4yf7aMuVD2IXwFDjB60T7Sf/tIO5ARhIMsuqH/6QquUCigHDGB+7VKlS6YsBzh
         MWbY0OxTxDlHkNgU4D8/MShAcwByMFWSiDWZDK7RaitCRLjmFN2y/gpvlJQoQZ/XWKqM
         jWORzUg17VQlHROocFFXiHwEXG2G56KbyX5JQ3eisTx5ajqxlt8vAweq3n5PFQL+tTEF
         w7kicIks8ugzoOfA+kQVYvm11d06EbxsJw/EokQVo7N2C6Hc/kiaH+/XJJu6c/FhuHYi
         vohg==
X-Gm-Message-State: AOAM531qyyPK45IB9ddO2uIbnb+kMU25094ZnXjRssv30GrCI3fRkudq
	rkuWEeD5s4u9TQ5Bme+h2Ub1PA==
X-Google-Smtp-Source: ABdhPJyrmCLmGW63fx9n1OC+yYNO5rjvfb0Ce9xQhK2RMb98xMDnfa90K4TsbnB5zAo7scdsUzAUcw==
X-Received: by 2002:aa7:81cb:0:b029:1ee:5346:8f1d with SMTP id c11-20020aa781cb0000b02901ee53468f1dmr1683154pfn.4.1616030553695;
        Wed, 17 Mar 2021 18:22:33 -0700 (PDT)
Date: Wed, 17 Mar 2021 18:22:31 -0700
From: Kees Cook <keescook@chromium.org>
To: John Wood <john.wood@gmx.com>
Cc: Jann Horn <jannh@google.com>, Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, James Morris <jmorris@namei.org>,
	Shuah Khan <shuah@kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andi Kleen <ak@linux.intel.com>,
	kernel test robot <oliver.sang@intel.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v6 1/8] security: Add LSM hook at the point where a task
 gets a fatal signal
Message-ID: <202103171821.C851A2D189@keescook>
References: <20210307113031.11671-1-john.wood@gmx.com>
 <20210307113031.11671-2-john.wood@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210307113031.11671-2-john.wood@gmx.com>

On Sun, Mar 07, 2021 at 12:30:24PM +0100, John Wood wrote:
> Add a security hook that allows a LSM to be notified when a task gets a
> fatal signal. This patch is a previous step on the way to compute the
> task crash period by the "brute" LSM (linux security module to detect
> and mitigate fork brute force attack against vulnerable userspace
> processes).
> 
> Signed-off-by: John Wood <john.wood@gmx.com>

I continue to really like that this entire thing can be done from an LSM
with just this one extra hook. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
