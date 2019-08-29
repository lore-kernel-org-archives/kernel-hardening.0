Return-Path: <SRS0=Nr+j=WZ=lists.openwall.com=kernel-hardening-return-16829-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C54CC3A59F
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Aug 2019 17:48:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B768922CF5
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Aug 2019 17:48:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="nvXZU0kl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B768922CF5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16829-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 8058 invoked by uid 550); 29 Aug 2019 17:48:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8021 invoked from network); 29 Aug 2019 17:48:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=90rdzfA3pQFTTD+WktPm5hw+SqSXSPzoFO0ejPyiLeQ=;
        b=nvXZU0kldmmMZp3VL246Oh/QBj4YT779VxETaJPpFYHPXJ9BYrRq3foTUldaV/pqyv
         DFfTp0bomcCAL58rraETjnr8sPv8dnSgqaRCxsUqBYSqpTjFfY29AOrVMPhfE0RON9H0
         w8Y+wJHk2y3MwxYfVQXQmG0CseTKPQBn1MvKU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=90rdzfA3pQFTTD+WktPm5hw+SqSXSPzoFO0ejPyiLeQ=;
        b=T+AGpVGhxyrX5wRSERezE6fm2BBCwHkbz+mgmRzjgO83MbwUwkZn7knBRCetEYIgtC
         YPxZfJOhpUlRR58spjU36KUCAXPpND9GENNas63uCXDgbG7y96Fd6vI8S33DeDFGYoeS
         D2qB2tAe3sFcoQJHIew63TeKP+g8I+AQRdkz5Lo2sT3rJynbxdbvk4Yg3r0HTKA6RD/q
         zeY0neUhYi3JHYeAb2GeEC81MT+m1FjiFLLXdc+0bql55LXTNKn0dirSOcAj2cAPFOWt
         XAMuz8H49uNhGIROAh+yj5xIYGf5l+c8/iUDdrC1cqbrX7UH0q1MJdQqp9cvxL6u2043
         gjYA==
X-Gm-Message-State: APjAAAW2qg/eUiGfme0t7K7rea78au69DjeaIlJsoAND4OUTCZVWpRQc
	X6Wm2upjy+sNTmz2WI9oUSoINg==
X-Google-Smtp-Source: APXvYqy65Ly3KOvta1q3yjixyorRLWYiltKYfxGEdKZHPogdneVuSW8XJmeoBqWPDMGusYqMegigeQ==
X-Received: by 2002:aa7:8498:: with SMTP id u24mr13196622pfn.61.1567100892560;
        Thu, 29 Aug 2019 10:48:12 -0700 (PDT)
Date: Thu, 29 Aug 2019 10:48:10 -0700
From: Kees Cook <keescook@chromium.org>
To: Alex Dewar <alex.dewar@gmx.co.uk>
Cc: re.emese@gmail.com, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v3] scripts/gcc-plugins: Add SPDX header for files
 without
Message-ID: <201908291047.CDE576721@keescook>
References: <20190824153036.21394-1-alex.dewar@gmx.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190824153036.21394-1-alex.dewar@gmx.co.uk>

On Sat, Aug 24, 2019 at 04:30:37PM +0100, Alex Dewar wrote:
> Replace boilerplate with approproate SPDX header. Vim also auto-trimmed
> whitespace from one line.
> [...]
> --- a/scripts/gcc-plugins/cyc_complexity_plugin.c
> +++ b/scripts/gcc-plugins/cyc_complexity_plugin.c
> @@ -1,6 +1,6 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
>  /*
>   * Copyright 2011-2016 by Emese Revfy <re.emese@gmail.com>
> - * Licensed under the GPL v2, or (at your option) v3

This isn't equivalent, I don't think. SPDX says "v2 and later" and
removed text says "v2 or v3".

-- 
Kees Cook
