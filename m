Return-Path: <SRS0=h1qc=32=lists.openwall.com=kernel-hardening-return-17704-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9989BC2D0B1
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 12:39:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ECCCC20661
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 12:39:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="QKfLxKf+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECCCC20661
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17704-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1345 invoked by uid 550); 6 Feb 2020 12:39:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1325 invoked from network); 6 Feb 2020 12:39:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0yCsXDZ7Hq3Ej7Od8dbrQEEhSu2aGFReqoIYO2djUlc=;
        b=QKfLxKf+NoFm4DBjWkoWWiW7eX2dRqD3gS03sqW2v3ztdidPcYvxnTJ0QoKe9UqRO+
         o/jdO2CEZgQmKz+y8gJ47hiCcEIM82IGPom5ZNAFWuZ9886t6iz8A8vuo6BPFxwInoJb
         bV6TQsivro3RT8xFE/8oWapetPU7B7vg22Vys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0yCsXDZ7Hq3Ej7Od8dbrQEEhSu2aGFReqoIYO2djUlc=;
        b=k8Cn/3HhhSRu/Eq67Y2P9tiQ8Wc+TQTJXTOo6OlLRnAgEbKf+SAS3UgXqyxMygsYE5
         pt9hEZFYPimXQh9zpfGjzeeVokuJOk8vnIaqruhkUVxTc/nxQudjUNwsPPnR+DyCBBju
         b82tnPZOtwcjHNUEBYe64v5mxIIbpy3ScA1EoDaQLxp5cKfTie/pda3MyWgUVOQWHKYC
         sJ6sYH0voUG7aeipAnp6CW0FZXg2Ru27WFtwyI28XVw7bkkbhrsuJ9etxMq9TJdR7I4c
         +IOCqXQeSYQ4WRloTwRNMbjZSyKFdEnANiuSwr7dw3iU/YDPR2LzvlneH1wZ3Hzd/KB1
         GHNA==
X-Gm-Message-State: APjAAAVVgnLmRkkLi/077sY4Wl+dHfQhkTmskWpfeuLlNoYT6kjDE2+q
	xT7C99HRpyjMVDIuolyY4mqVdQ==
X-Google-Smtp-Source: APXvYqynAxkaa1Q44AfR1w48j/Y6VPFRGOmR/85OyfO88x0+FLS7Y1TERPYpEugEag+KWDetTLeoOg==
X-Received: by 2002:a05:6830:1251:: with SMTP id s17mr30044739otp.108.1580992735002;
        Thu, 06 Feb 2020 04:38:55 -0800 (PST)
Date: Thu, 6 Feb 2020 04:38:52 -0800
From: Kees Cook <keescook@chromium.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 01/11] modpost: Support >64K sections
Message-ID: <202002060438.C2C977F8@keescook>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-2-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205223950.1212394-2-kristen@linux.intel.com>

On Wed, Feb 05, 2020 at 02:39:40PM -0800, Kristen Carlson Accardi wrote:
> According to the ELF specification, if the value of st_shndx
> contains SH_XINDEX, the actual section header index is too
> large to fit in the st_shndx field and you should use the
> value out of the SHT_SYMTAB_SHNDX section instead. This table
> was already being parsed and saved into symtab_shndx_start, however
> it was not being used, causing segfaults when the number of
> sections is greater than 64K. Check the st_shndx field for
> SHN_XINDEX prior to using.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>

Looking at "readelf" output continues to make me laugh. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
