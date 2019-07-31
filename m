Return-Path: <SRS0=IYF8=V4=lists.openwall.com=kernel-hardening-return-16679-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9099C32751
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Jul 2019 19:55:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0A245206A3
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Jul 2019 19:55:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="D0j3gPNf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A245206A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16679-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27692 invoked by uid 550); 31 Jul 2019 19:55:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27649 invoked from network); 31 Jul 2019 19:55:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XQH6DtD99p5D5A2Hyn8PBXBBbgh/OsFLPK3dOA2m6w0=;
        b=D0j3gPNfwYG/QORkL2L2ZPIMe+d2wlGKm3iuL0frlg4Jw60UE2i1DeJYoK66LNwViD
         /uslP7+VIl3GyASKfQvxQVrNIydjooeHKULzn2TIRcK11KI4l5eH73W1shv6M+61tdYK
         VpsSF2zx9vf1YP/9nUVWVD12xt+n44YRjqsNc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XQH6DtD99p5D5A2Hyn8PBXBBbgh/OsFLPK3dOA2m6w0=;
        b=IOAbQUGCLhfwsjk4hgcjxro7rXoygCYfJNVRb30eeUmqhlAO/UbQogOzK8OtyZuRin
         PzapxAdjIOhkJpm5VYzzYtFIJyIywcYt9+M9XpP6BnNocEn/DHmyb6f0yM4WNk5bX7c1
         eGu7LXOpQf1VgsSAXM0MHlmrfxnVsKhx73RcCtt/L1crUB0iaiAXY7mLURIIIHE/vfzT
         dTwobzG8Kf9FG7S9Zp//oSiRdEt775UpWN/GSf3E81UM5MqauDEdwSLMWUX79Rr/qjsq
         6cRlcaBjAaxnTb5PXrApFc+izq/qvZsPobLGoHSgKLCceIQIlUnijHddFg6yzW/Dic2F
         RDMQ==
X-Gm-Message-State: APjAAAWCsIR+4EtuJhHfmO5goQ+clFHvlw98uYsELl2CMPLK16zvyGPz
	TNtlAkd/bsxwGN/mMgsuYCGHqQ==
X-Google-Smtp-Source: APXvYqxP3BgGFx4VkqKDdWWjJOJ/R1kCytw3dyW1aT3klfuCqTYn0xftGGczEAgdTr/U+7++jWcmlA==
X-Received: by 2002:a17:902:2a26:: with SMTP id i35mr120324409plb.315.1564602905395;
        Wed, 31 Jul 2019 12:55:05 -0700 (PDT)
Date: Wed, 31 Jul 2019 12:55:03 -0700
From: Kees Cook <keescook@chromium.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Rick Mark <rickmark@outlook.com>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Subject: Re: Hello Kernel Hardening
Message-ID: <201907311254.C1FED747C@keescook>
References: <BYAPR07MB5782E8E1F2105AD154035E10DADF0@BYAPR07MB5782.namprd07.prod.outlook.com>
 <20190731091818.GB29294@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731091818.GB29294@kroah.com>

On Wed, Jul 31, 2019 at 11:18:18AM +0200, Greg KH wrote:
> On Wed, Jul 31, 2019 at 06:52:04AM +0000, Rick Mark wrote:
> > Per the instructions in the get involved I'm here saying hello.
> > 
> > My name is Rick Mark, currently a security engineer at Dropbox in SF.

Hi Rick! Thanks for joining in the fun. :)

> > I've been toying around with various things I've found in the wild
> > over the years and recently put together this CC Attribution paper
> > 'Security Critical Kernel Object Confidentiality and Integrity'
> > (https://dbx.link/sckoci).
> 
> Link needs permissions to view it :(

Heh, same for me. Let us know when we can view it...

-- 
Kees Cook
