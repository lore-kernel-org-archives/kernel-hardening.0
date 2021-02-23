Return-Path: <SRS0=xohh=HZ=lists.openwall.com=kernel-hardening-return-20810-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 653D0C433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Feb 2021 00:56:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 657A664E2E
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Feb 2021 00:56:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 657A664E2E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20810-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25608 invoked by uid 550); 23 Feb 2021 00:56:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24552 invoked from network); 23 Feb 2021 00:56:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1614041786;
	bh=3pY5WFu1Ga0y3dwlJnmXoQgzLy9gOhz0VuznV36Gg24=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cXK+vcvBZwqwIZytW45gLGGcfHwosMNnQY8yLN+O4lHN4LdEddmh/wGvYOlAKwcwa
	 Z9IYeD78H/LYAVskG/VV9SEBvJGmtfDQ6WMuf/gY+rsK7c4TDGeuv+hQJEmN6/krSN
	 FGK+V/YQt5EigKGfBBbvi59IHiLBoVbk4Qbg5yIcD2cdSyogc8b1xCVYk9/L1BbSRn
	 EHCMMPzPavUFexmxBzEcMpPuQQg3LmjNXmnN+/GK7LjBpGli2FF+vKZxxnPvvGF3we
	 rkc4hKp+Fyh8dPavWrzhHjl2o7+qAf5ZLuC9vQ4jTFCtH8m9+AX55QSPo3FOSSEbJF
	 xlsaJaqjAo7xg==
Date: Mon, 22 Feb 2021 16:56:23 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com,
 Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/20] devlink: Manual replacement of the deprecated
 strlcpy() with return values
Message-ID: <20210222165623.12e31597@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210222151231.22572-4-romain.perier@gmail.com>
References: <20210222151231.22572-1-romain.perier@gmail.com>
	<20210222151231.22572-4-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Feb 2021 16:12:14 +0100 Romain Perier wrote:
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 737b61c2976e..7eb445460c92 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -9461,10 +9461,10 @@ EXPORT_SYMBOL_GPL(devlink_port_param_value_changed);
>  void devlink_param_value_str_fill(union devlink_param_value *dst_val,
>  				  const char *src)
>  {
> -	size_t len;
> +	ssize_t len;
>  
> -	len = strlcpy(dst_val->vstr, src, __DEVLINK_PARAM_MAX_STRING_VALUE);
> -	WARN_ON(len >= __DEVLINK_PARAM_MAX_STRING_VALUE);
> +	len = strscpy(dst_val->vstr, src, __DEVLINK_PARAM_MAX_STRING_VALUE);
> +	WARN_ON(len == -E2BIG);

WARN_ON(len < 0) ?
