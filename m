Return-Path: <SRS0=tGnc=V5=lists.openwall.com=kernel-hardening-return-16690-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93260C19759
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Aug 2019 20:15:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E08D52084C
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Aug 2019 20:15:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ZkklR3uF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E08D52084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16690-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1880 invoked by uid 550); 1 Aug 2019 20:14:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1822 invoked from network); 1 Aug 2019 20:14:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ijIfaB/u8ohpmn4mM5slg76T9xTiwfAQK+gE07HS2Gs=;
        b=ZkklR3uFxHP6Y8XTx6VYhj4O+6IWJ8wZ86vYmsLdLmL9Kl9ScF36BtA/WhBpEYQrP+
         MWMssjtZ2f8XwT3s1JU8L4q/1Y9Sq9fJvEklvCBLMowpUpIAQEsMTJ1/QuOD8zGMDjgy
         OSpC84q4u6JX0fauLOvOvcFmIWe96B95fH8BM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ijIfaB/u8ohpmn4mM5slg76T9xTiwfAQK+gE07HS2Gs=;
        b=BJ4Kl0k27Efh8FqQvOO+wnUyUuNMK450SYI6M9ZsWfEvkiapt5o+MEupFQoABrqto7
         HCF8ho8mXSmmwEAUHJ0bV76R3jE3gFk0kKQeOx0E+aeTvdBW+L76OXPmg6Obm3Eb8ZW7
         ZZssnu55eeGMiVgAkGgsd6INzQHKu+5yN+31fKdvPKV2jnBdqe/ka7VObSOfPL+O3iFR
         yX9/k7jOSLCnXiC/3wyuZZDJFgdzKMqxtAFqi/RZyrTNzcCxI8t6BhaIoooKNR93tYXI
         7511jYs6YS5kHSf1bchpZMB1uoz3F0WGLlej/Z2M1KmM+jlWRAhFo0NA/qBOtbmKZ1u0
         h9RA==
X-Gm-Message-State: APjAAAV6Q/d9V0St4jGYReW8DNvCbfmVlbomVKB1Jr/LsqzHaOKDAr8f
	bW73XdbJ4gr3icDkcXDiOh7wwQ==
X-Google-Smtp-Source: APXvYqw6KayZdXN0sKQZvPI5VVbd86mPViT8uDgiznq11fw4KURCPEvYA4XepGza1hvaDP9r3y3Uvw==
X-Received: by 2002:a17:902:9307:: with SMTP id bc7mr123619972plb.183.1564690485486;
        Thu, 01 Aug 2019 13:14:45 -0700 (PDT)
Date: Thu, 1 Aug 2019 13:14:43 -0700
From: Kees Cook <keescook@chromium.org>
To: Robin Lindner <robin.lindner1@t-online.de>
Cc: re.emese@gmail.com, kernel-hardening@lists.openwall.com,
	Alexander Popov <alex.popov@linux.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation patch (gcc-plugins kernel)
Message-ID: <201908011311.A06FB03C6C@keescook>
References: <ebb6d995-a356-bc01-074b-6154a283e299@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebb6d995-a356-bc01-074b-6154a283e299@t-online.de>

On Thu, Aug 01, 2019 at 09:30:58AM +0200, Robin Lindner wrote:
> Cleaned documentation comment up. I removed the "TODO" because it was very old.

Hi, please send these patches "normally" (cc maintainers, include lkml,
inline not attachments, etc):
https://www.kernel.org/doc/html/latest/process/submitting-patches.html

> ---
>  scripts/gcc-plugins/stackleak_plugin.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/scripts/gcc-plugins/stackleak_plugin.c b/scripts/gcc-plugins/stackleak_plugin.c
> index dbd37460c573e..d8ba12c3bb238 100644
> --- a/scripts/gcc-plugins/stackleak_plugin.c
> +++ b/scripts/gcc-plugins/stackleak_plugin.c
> @@ -144,8 +144,6 @@ static unsigned int stackleak_instrument_execute(void)
>  	 *
>  	 * Case in point: native_save_fl on amd64 when optimized for size
>  	 * clobbers rdx if it were instrumented here.
> -	 *
> -	 * TODO: any more special cases?
>  	 */
>  	if (is_leaf &&
>  	    !TREE_PUBLIC(current_function_decl) &&

As to the content of the patch, let's also CC Alexander...

Are there no more special cases?

-- 
Kees Cook
