Return-Path: <SRS0=OgAr=YX=lists.openwall.com=kernel-hardening-return-17172-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF32CA9EC5
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 18:44:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C2F2620856
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 18:44:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WK/lVblA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2F2620856
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17172-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15611 invoked by uid 550); 30 Oct 2019 18:43:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15579 invoked from network); 30 Oct 2019 18:43:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iL1b2/dZuwewbYecquyIQ6Ntyu37Tn/9b5T127ehj8U=;
        b=WK/lVblAh7BulbtEispzUnAVVHPJYdMhwReGBIqHEtusyFdsxppXUugyB5tQaE8qaj
         96ch8RuSFp/yAeFHMIrWO4RXU8/fNntKr1knCfRXvCSv1uBShRg4OkAbrEXPlnNY+XWb
         Pm6iG9ZRZp8DuzEXuvDj9m/1Ar6HfsRBMCGiU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iL1b2/dZuwewbYecquyIQ6Ntyu37Tn/9b5T127ehj8U=;
        b=fO+bUGma8WJNZJVBM5s6EXdGkXsnY63xU4W1w8b0X/GqKyu6ktG7zbXOas0mPSuhzp
         nPE/c8sek1+eBcud0yJX5e3ZBlKnUVMqr3jF6yF2yVdIAwR65X5sU+HLKrf0jsy2WkoQ
         wSn8iHjiQx0QzdJFV7g+/tz40pZFHeg5B2iMCE0a8PBMv/NmMiIbCDWkY4m/EkQxYtxZ
         zy4tRWhKXMYWoH6kLsRk0XrAQRK0alkEjwr/4V4LQdo0JTWaT+BpuC5NzOXHNh0XDqWu
         tKo89/Y0ZQGH/5q02w0eqU87QSpmV80XudpYmI9jMEqcBjoifIt54eIKBX2EZSrZ35V1
         ooKw==
X-Gm-Message-State: APjAAAU0s85hDlXzZBLsYJkCngXB73+p5iMZlFTCUdbNWq72w6raEfOi
	lgtJUwKKNuUweh4UDvolpehy8A==
X-Google-Smtp-Source: APXvYqw5tNLHWw12J82IOIHnZ6DckC3H6m86Mqkez1zDPbawAcwK9ve9deD8ot/TTbSaihDt6cXKIA==
X-Received: by 2002:a63:fb4f:: with SMTP id w15mr859409pgj.403.1572461023577;
        Wed, 30 Oct 2019 11:43:43 -0700 (PDT)
Date: Wed, 30 Oct 2019 11:43:41 -0700
From: Kees Cook <keescook@chromium.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org,
	christophe.leroy@c-s.fr, joel@jms.id.au, ajd@linux.ibm.com,
	dja@axtens.net, npiggin@gmail.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v4 0/4] Implement STRICT_MODULE_RWX for powerpc
Message-ID: <201910301143.C54F8C15@keescook>
References: <20191014051320.158682-1-ruscur@russell.cc>
 <201910291601.F161FBBAB2@keescook>
 <87zhhjf5pl.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zhhjf5pl.fsf@mpe.ellerman.id.au>

On Wed, Oct 30, 2019 at 11:16:22AM +1100, Michael Ellerman wrote:
> Kees Cook <keescook@chromium.org> writes:
> > On Mon, Oct 14, 2019 at 04:13:16PM +1100, Russell Currey wrote:
> >> v3 cover letter here:
> >> https://lists.ozlabs.org/pipermail/linuxppc-dev/2019-October/198023.html
> >> 
> >> Only minimal changes since then:
> >> 
> >> - patch 2/4 commit message update thanks to Andrew Donnellan
> >> - patch 3/4 made neater thanks to Christophe Leroy
> >> - patch 3/4 updated Kconfig description thanks to Daniel Axtens
> >
> > I continue to be excited about this work. :) Is there anything holding
> > it back from landing in linux-next?
> 
> I had some concerns, which I stupidly posted in reply to v3:
> 
>   https://lore.kernel.org/linuxppc-dev/87pnio5fva.fsf@mpe.ellerman.id.au/

Ah-ha! Thanks; I missed that. :)

-- 
Kees Cook
