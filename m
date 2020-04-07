Return-Path: <SRS0=PIxb=5X=lists.openwall.com=kernel-hardening-return-18460-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45341C2BA1A
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Apr 2020 16:46:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 98EEB20730
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Apr 2020 16:46:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="U0uX9mwg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98EEB20730
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18460-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11582 invoked by uid 550); 7 Apr 2020 16:45:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11550 invoked from network); 7 Apr 2020 16:45:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=m+hJokxaXXSZ8OwwEQfbCXMH/+uV7ncsulhI4Dexs6k=;
        b=U0uX9mwgjZ8Z7tvVVlcqWOg8SqCB2gnRkzslTEmDZ2qjc4Ms9ZkcKriL3MCXNV5wlb
         JMIpyAOgV9tKJOztaHKDFdSTlVqulrb8AjqCkSsq9GY1pBqmpULE6Uwx2usNj6g1vTYC
         8KdddIU5TGWH5T+OAxoPfNwHn3xQN2hJ0sNd0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=m+hJokxaXXSZ8OwwEQfbCXMH/+uV7ncsulhI4Dexs6k=;
        b=AtBAdSPJ4FuDXyBb4ljZFqTRTprNXH1TDFEE7v9mDJ2mMwdHEgdk5r2U+dDUwdiS3q
         FqFy3C9UHaPbnUr/tAbSDYSiDVNKHM7ge0WjDoYFWsjC673mmIlutIyYanOz9cuM6G4K
         rWXLaH8OsFln3Hc/vCT1IGFlUzCPavrxWa8R40OI1rVpicIjvwSZEPUndxBJa7LohFYE
         rKnZsMQI/JjwDTc7rASotymVkYG/ew1ZdWcBfjIeGYXlmrT6mk7zl6jQ4i0zoIq5TZfz
         s7B+7D26DrOI8x+2frKJNsBpwfufwBlfzNHzQzIMsx1EuBV2RJuurQgx4b/KvV/e3gbo
         nY0Q==
X-Gm-Message-State: AGi0Puas8ORFncbq5RO1AvVzPHy41on2/UXJKU3pnUR85lK38h593kTB
	sehRWDovUdM55HSsjLeEJuma0A==
X-Google-Smtp-Source: APiQypKW/Q8EwN9hhHyu+fZCl8T2W6FOcwUK5arUv+dyXqzBZ4dh7vIeqvQxlUsMtsmsd9A+WR3UNw==
X-Received: by 2002:a17:90a:30c3:: with SMTP id h61mr270738pjb.18.1586277944571;
        Tue, 07 Apr 2020 09:45:44 -0700 (PDT)
Date: Tue, 7 Apr 2020 09:45:42 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Fr=E9d=E9ric_Pierret_=28fepitre=29?= <frederic.pierret@qubes-os.org>
Cc: re.emese@gmail.com, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gcc-common.h: 'params.h' has been dropped in GCC10
Message-ID: <202004070945.D6E095F7@keescook>
References: <20200407113259.270172-1-frederic.pierret@qubes-os.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200407113259.270172-1-frederic.pierret@qubes-os.org>

On Tue, Apr 07, 2020 at 01:32:59PM +0200, Frédéric Pierret (fepitre) wrote:
> Moreover, GCC10 complains about gimple definition. For example,
> doing a 'scripts/gcc-plugin.sh g++ g++ gcc' returns:
> 
> In file included from <stdin>:1:
> ./gcc-plugins/gcc-common.h:852:13: error: redefinition of ‘static bool is_a_helper<T>::test(U*) [with U = const gimple; T = const ggoto*]’
>   852 | inline bool is_a_helper<const ggoto *>::test(const_gimple gs)
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from ./gcc-plugins/gcc-common.h:125,
>                  from <stdin>:1:
> /usr/lib/gcc/x86_64-redhat-linux/10/plugin/include/gimple.h:1037:1: note: ‘static bool is_a_helper<T>::test(U*) [with U = const gimple; T = const ggoto*]’ previously declared here
>  1037 | is_a_helper <const ggoto *>::test (const gimple *gs)
>       | ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from <stdin>:1:
> ./gcc-plugins/gcc-common.h:859:13: error: redefinition of ‘static bool is_a_helper<T>::test(U*) [with U = const gimple; T = const greturn*]’
>   859 | inline bool is_a_helper<const greturn *>::test(const_gimple gs)
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from ./gcc-plugins/gcc-common.h:125,
>                  from <stdin>:1:
> /usr/lib/gcc/x86_64-redhat-linux/10/plugin/include/gimple.h:1489:1: note: ‘static bool is_a_helper<T>::test(U*) [with U = const gimple; T = const greturn*]’ previously declared here
>  1489 | is_a_helper <const greturn *>::test (const gimple *gs)
>       | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> A hacky way for solving this is to ignore them for GCC10.

Hi! Thanks for the patch. I don't think this is a hack: it's the right
thing to do here, yes? GCC 10 includes this helper in gimple.h, so we
can ifdef it out in gcc-common.h.

-Kees

> 
> Signed-off-by: Frédéric Pierret (fepitre) <frederic.pierret@qubes-os.org>
> ---
>  scripts/gcc-plugins/gcc-common.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/scripts/gcc-plugins/gcc-common.h b/scripts/gcc-plugins/gcc-common.h
> index 17f06079a712..9ad76b7f3f10 100644
> --- a/scripts/gcc-plugins/gcc-common.h
> +++ b/scripts/gcc-plugins/gcc-common.h
> @@ -35,7 +35,9 @@
>  #include "ggc.h"
>  #include "timevar.h"
>  
> +#if BUILDING_GCC_VERSION < 10000
>  #include "params.h"
> +#endif
>  
>  #if BUILDING_GCC_VERSION <= 4009
>  #include "pointer-set.h"
> @@ -847,6 +849,7 @@ static inline gimple gimple_build_assign_with_ops(enum tree_code subcode, tree l
>  	return gimple_build_assign(lhs, subcode, op1, op2 PASS_MEM_STAT);
>  }
>  
> +#if BUILDING_GCC_VERSION < 10000
>  template <>
>  template <>
>  inline bool is_a_helper<const ggoto *>::test(const_gimple gs)
> @@ -860,6 +863,7 @@ inline bool is_a_helper<const greturn *>::test(const_gimple gs)
>  {
>  	return gs->code == GIMPLE_RETURN;
>  }
> +#endif
>  
>  static inline gasm *as_a_gasm(gimple stmt)
>  {
> -- 
> 2.25.2
> 
> 

-- 
Kees Cook
