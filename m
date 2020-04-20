Return-Path: <SRS0=0xCh=6E=lists.openwall.com=kernel-hardening-return-18572-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A754EC3815B
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Apr 2020 17:48:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 09D0220857
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Apr 2020 17:48:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="GXRI4PIn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 09D0220857
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18572-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7649 invoked by uid 550); 20 Apr 2020 17:48:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7620 invoked from network); 20 Apr 2020 17:48:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q4Luph9bjUR+Gp2ezvaV6wES2xaIHfMicGZ5Eha18+I=;
        b=GXRI4PInUTtUMm78jGtgjATrvbZr7mvC9uO2/IV0glFIM8jmisWzRO4HTbPySF4d1O
         GWuqHjfb00loi9NzH+INM6AwCX4OoEKBLTWC1dkE/SDIg59HDNN5LW7ATSr0dtA8WD5w
         h8pHdanm2ZyCwCuUjoGXH/ynQspj7qlcqCYQ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q4Luph9bjUR+Gp2ezvaV6wES2xaIHfMicGZ5Eha18+I=;
        b=K8jRx7Tqa7aT9dOvL3wxzSLmYW77P7PwHM0ky0u4svVEA1RP8Hozc1JvCsVFfHZ+IS
         rVlG9I1jP7M/nYjtU/CngG1AcCtNbUtyMDReQtCA9DKp8RdPdw2Mj5oFF1jvNlQbm2yH
         BgT4JQxVVWSBhut/EsbbUR7AH9mXZGWE1aGEeEQVUiQytErMyupbKXpbFFZJBfnI+j21
         dJVM6psc3JM3n5cPOi3i3dhzX+9gl9OsuB/QKhDbVg6oXaz+gCOrnt2PIMa38L4WD3uu
         rhwf751naNrfCwMNkVqtdfYvPP0ZZhfTm84hKI8MX/kReBcBdbWXVeiJh5bM1ym9gLTZ
         Z0Ow==
X-Gm-Message-State: AGi0PuYbww8Gj/dw3YltdsHwtzQl2r05ctDCBb8xB5J5ypf8rQi3YO/Z
	vN5kdYTfFASf3naAG5mScPGEqA==
X-Google-Smtp-Source: APiQypIlqdHwV4TpkFSW47Z++mEoKRMoGEEDfMbXdZ0NOOBU9Wa+n6xGftMqzJcnXbkOXMMNsNnKIA==
X-Received: by 2002:a62:864b:: with SMTP id x72mr6072442pfd.305.1587404883243;
        Mon, 20 Apr 2020 10:48:03 -0700 (PDT)
Date: Mon, 20 Apr 2020 10:48:01 -0700
From: Kees Cook <keescook@chromium.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecomb@intel.com
Subject: Re: [PATCH 0/9] Function Granular Kernel Address Space Layout
 Randomization
Message-ID: <202004201046.600183D@keescook>
References: <20200415210452.27436-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415210452.27436-1-kristen@linux.intel.com>

On Wed, Apr 15, 2020 at 02:04:42PM -0700, Kristen Carlson Accardi wrote:
> Kristen Carlson Accardi (8):
>   objtool: do not assume order of parent/child functions
>   x86: tools/relocs: Support >64K section headers

Can these two patches land separately (i.e. "now")? CFI will need the
relocs fix too, so better to have this landed upstream for both
features. I see Josh's Ack in the first...

-- 
Kees Cook
