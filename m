Return-Path: <SRS0=M0S/=DT=lists.openwall.com=kernel-hardening-return-20169-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D8ACC433DF
	for <kernel-hardening@archiver.kernel.org>; Mon, 12 Oct 2020 19:04:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 35BDC22248
	for <kernel-hardening@archiver.kernel.org>; Mon, 12 Oct 2020 19:04:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="NmUmPZg9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35BDC22248
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20169-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16146 invoked by uid 550); 12 Oct 2020 19:04:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16097 invoked from network); 12 Oct 2020 19:04:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QuVx9sAPms7htZv0saHN7NQDUb2yJw+Ga5qw85soIMU=;
        b=NmUmPZg9Idy7qVfkHwFPrkWRO7+IaMdKn+O81wwbBPAGCLOdlip6o6Z6qjN+yFiSlF
         NPzGraH0kimFmHLGUlTddXKmC3A+RqBHR7rXBgm90BX5CNq58BfBKuXC+ITmS68kUTCq
         59En7+OWY1GeSkZZ63PRBrf6Oea2CeZUYH364=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QuVx9sAPms7htZv0saHN7NQDUb2yJw+Ga5qw85soIMU=;
        b=rVke/6DXGOEqRAXJVRvVu/mJMqdksSY+AovOZw4/gE/HQUVhluefu3HXf8qc7ICcsz
         2F9ArB9YrLFR9XH9JG+iHbKUckefqX6iRJ7Fbk04C9kq6BYZUYKosDf1FJWyzBfNMVZR
         ZFHpQwQg6ObR5CX1/NKpd3LvUkqv6zDrRERk02z4shDj7SixbrFFyC4e1VEZSM7nGLBf
         gdR3Ez3UUE26q9LwpSi8h+zcTHX8X08+7cxstBfm6MLcTyzjEC+hi5oECd6DcC7/CmTo
         mLbDqpWdA5DlSeq9FInZEt3CIQLIb0r2DuGrA5Ce8sZGG+i+rlmnOSuoEYoT9lBoi74t
         +Gfg==
X-Gm-Message-State: AOAM532oOH8xELEOe9AflmTfnPCWICXgAH2xw8hsaiNPJ9TDusC+EQf9
	5HgQTiSTcQBACQ0s4QV3MDiA2A==
X-Google-Smtp-Source: ABdhPJwD+wj3NS7cqdsTNAN7U+IBKOAjHZ8WgflFeaZM9/aZMmfaPdCV93WkwTOUnOqlY3Tqy9Io7Q==
X-Received: by 2002:a62:7cd4:0:b029:152:5198:3f19 with SMTP id x203-20020a627cd40000b029015251983f19mr24870595pfc.31.1602529430348;
        Mon, 12 Oct 2020 12:03:50 -0700 (PDT)
Date: Mon, 12 Oct 2020 12:03:48 -0700
From: Kees Cook <keescook@chromium.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-hardening@vger.kernel.org
Subject: Re: Remove all strlcpy() uses in favor of strscpy() (#89)
Message-ID: <202010121201.6ED466E1C7@keescook>
References: <CABgxDoJwP+5Z3qUKuv3Tr=P24eGidk2cjO+yq0y_NwNmSbvQKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgxDoJwP+5Z3qUKuv3Tr=P24eGidk2cjO+yq0y_NwNmSbvQKA@mail.gmail.com>

On Sun, Oct 11, 2020 at 08:24:19AM +0200, Romain Perier wrote:
> That's just to let you know that I start to work on this task,
> I have also added a comment on the bugtracker.

Okay, great; thanks! I'll reply there; it looks like there are several
approaches that could be taken.

(For reference, this is https://github.com/KSPP/linux/issues/89 )

-- 
Kees Cook
