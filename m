Return-Path: <SRS0=iQ0R=XT=lists.openwall.com=kernel-hardening-return-16928-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 152CAC432C1
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Sep 2019 16:22:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 596D220872
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Sep 2019 16:22:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="O8zGPIRb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 596D220872
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16928-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22370 invoked by uid 550); 24 Sep 2019 16:22:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22335 invoked from network); 24 Sep 2019 16:22:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B/ALc/qTcQ4k/eCkDMCHCUlzu+44O0snaF71bHOvSBA=;
        b=O8zGPIRb6udzS8CeK12mIGTdihD/nbhSG3mye5euKo6yGM6boWQd3/J/ShzdWlhmUH
         3WBrBWZeqFa1y+iW4YT406eldU8YVPHi9w8OUNYhOwaDdqYG3u4b8q66J2P2/ebkbu6N
         JcQboVDtKw2Zwq/BUkz4IQOCXLe8MqkKZ++0w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B/ALc/qTcQ4k/eCkDMCHCUlzu+44O0snaF71bHOvSBA=;
        b=qfxloSjhFDbZxp4a+9p6C9It9zC428AI++2XTu/iUy+h/UMXrxCCe5txMUfuQ/dt/g
         rvA5dxYi4MFLxiDFdy0QtU9sVx7HeD+0vwPgSq/ChdzKgTClSpMHSwpR0S4QP0NVh/gN
         5UzCDngYpwbpO+gKJ3HVZW7bsiJJfNadMGtJarfU14/cQhMvzf9H8q8U9gDVj5Zk0Lnp
         xog1vBB5P+IeA/rKW9NTzPrOeEM6sA8lLbtHK8v4STvWnQCQxvSrZXEFAYPdA50wVy+O
         kxgsVCWHTmXniJ4cJdpkwZI/92XhqJYe4CaNSmbMv1vtYkNoxMY10bFOc142tYO8Jpea
         UJAQ==
X-Gm-Message-State: APjAAAXKNioBz8NB6Ig7WQJ1pI0RUH1WulbyNAtvIIfN7cnz3XyBLfSa
	nXJqdyqZ9p2PDu719yx78tKb0g==
X-Google-Smtp-Source: APXvYqz6f0NZvQy5yYrKu6cts+T4A5fOIBUPykaVdTiHtcZ+MGdIGC42Mo2ufzIwEq03ic6ykQZRoA==
X-Received: by 2002:a17:90a:b012:: with SMTP id x18mr966430pjq.118.1569342132377;
        Tue, 24 Sep 2019 09:22:12 -0700 (PDT)
Date: Tue, 24 Sep 2019 09:22:10 -0700
From: Kees Cook <keescook@chromium.org>
To: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
Cc: pankaj.bharadiya@gmail.com, andriy.shevchenko@linux.intel.com,
	kernel-hardening@lists.openwall.com, akpm@linux-foundation.org,
	mayhs11saini@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] linux/kernel.h: Add sizeof_member macro
Message-ID: <201909240920.AE3CD67E87@keescook>
References: <20190924105839.110713-1-pankaj.laxminarayan.bharadiya@intel.com>
 <20190924105839.110713-2-pankaj.laxminarayan.bharadiya@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924105839.110713-2-pankaj.laxminarayan.bharadiya@intel.com>

On Tue, Sep 24, 2019 at 04:28:35PM +0530, Pankaj Bharadiya wrote:
> At present we have 3 different macros to calculate the size of a
> member of a struct:
>   - SIZEOF_FIELD
>   - FIELD_SIZEOF
>   - sizeof_field
> 
> To bring uniformity in entire kernel source tree let's add
> sizeof_member macro.
> 
> Replace all occurrences of above 3 macro's with sizeof_member in
> future patches.
> 
> Signed-off-by: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
> ---
>  include/linux/kernel.h | 9 +++++++++
>  1 file changed, 9 insertions(+)

Since stddef.h ends up needing this macro, and kernel.h includes
stddef.h, why not put this macro in stddef.h instead? Then the
open-coded version of it in stddef (your last patch) can use
sizeof_member()?

Otherwise, yes, looks good. (Though I might re-order the patches so the
last patch is the tree-wide swap -- then you don't need the exclusions,
I think?)

-Kees

> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 4fa360a13c1e..0b80d8bb3978 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -79,6 +79,15 @@
>   */
>  #define round_down(x, y) ((x) & ~__round_mask(x, y))
>  
> +/**
> + * sizeof_member - get the size of a struct's member
> + * @T: the target struct
> + * @m: the target struct's member
> + * Return: the size of @m in the struct definition without having a
> + * declared instance of @T.
> + */
> +#define sizeof_member(T, m) (sizeof(((T *)0)->m))
> +
>  /**
>   * FIELD_SIZEOF - get the size of a struct's field
>   * @t: the target struct
> -- 
> 2.17.1
> 

-- 
Kees Cook
