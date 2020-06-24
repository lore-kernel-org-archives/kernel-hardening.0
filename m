Return-Path: <SRS0=AFwn=AF=lists.openwall.com=kernel-hardening-return-19082-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80BA1C433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 04:52:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D27632078A
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 04:52:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SOQtldw9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D27632078A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19082-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5340 invoked by uid 550); 24 Jun 2020 04:52:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5320 invoked from network); 24 Jun 2020 04:52:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6f53wfu9QNcdQT3ZJDSOeI3w2U50C/xG0fFlCdqBwh8=;
        b=SOQtldw9KnegRbDuujQK6mSW72Ar+eCo9OL6sqQyLe4507FK6z15J0tVonL3ROJGKX
         jmUWzV1kGTM8ch5wLol9h8AUoGlp2vmbh9AfB5HB82Nf6nd9MDgTkfuVbQTqVcoi6m9O
         rflkv7LK/GEf+O4d4akCkHJ7Zge7ftnPwuhiE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6f53wfu9QNcdQT3ZJDSOeI3w2U50C/xG0fFlCdqBwh8=;
        b=RPf1DiqqrxdWb9CpPW4TyZqwRaut2VH4n8YGDvZvY89USA1sww6it60fXBZjxgZ50g
         CPmq2xlsUS+Tqzdl4dhTsxJ3XaHGdUScmUyUMlnrWLTwUQJZArZr4/MEpClsecfEBN/7
         WbuJEYefzvBIPNbLTB07g20WCE2ztvoXZFuZ3+M3RPVdLcTPkkunQrc9yjidPewtNDvS
         9OOO4dwmtVZ9ifWdGIIJt6YtnF+BxLewKZpyN9GuTXYSfJZF9TSEorLFHndJSTgzaMz/
         uLg0kypWgiWFZNJQF9+oJnIg2W1YvPVPzN5FMKg+E7q3tuAKpV41VZUL3hDxDaf4j2TU
         AWBQ==
X-Gm-Message-State: AOAM53070GVeOkm0oulw0Tu/7rntaBQ73UY2+ciqtd+GeG0mwp9WdvYs
	2B5d5rRHKACaiyepe4o4KSmh+A==
X-Google-Smtp-Source: ABdhPJwX4es65nYyfcxHOhK/hXQNs9Mgx96rrroztpO1dJ1CT4SWu7NO7yDI/cU1cNN8RdLutBMqkA==
X-Received: by 2002:a65:6710:: with SMTP id u16mr14011070pgf.45.1592974330709;
        Tue, 23 Jun 2020 21:52:10 -0700 (PDT)
Date: Tue, 23 Jun 2020 21:52:08 -0700
From: Kees Cook <keescook@chromium.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
	arjan@linux.intel.com, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	Tony Luck <tony.luck@intel.com>, linux-arch@vger.kernel.org
Subject: Re: [PATCH v3 05/10] x86: Make sure _etext includes function sections
Message-ID: <202006232152.733212868D@keescook>
References: <20200623172327.5701-1-kristen@linux.intel.com>
 <20200623172327.5701-6-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623172327.5701-6-kristen@linux.intel.com>

On Tue, Jun 23, 2020 at 10:23:22AM -0700, Kristen Carlson Accardi wrote:
> When using -ffunction-sections to place each function in
> it's own text section so it can be randomized at load time, the
> linker considers these .text.* sections "orphaned sections", and
> will place them after the first similar section (.text). In order
> to accurately represent the end of the text section and the
> orphaned sections, _etext must be moved so that it is after both
> .text and .text.* The text size must also be calculated to
> include .text AND .text.*
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
