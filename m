Return-Path: <SRS0=1sfw=5N=lists.openwall.com=kernel-hardening-return-18272-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC292C43331
	for <kernel-hardening@archiver.kernel.org>; Sat, 28 Mar 2020 21:53:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 23D762073E
	for <kernel-hardening@archiver.kernel.org>; Sat, 28 Mar 2020 21:53:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Rq3TMeuP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23D762073E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18272-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9360 invoked by uid 550); 28 Mar 2020 21:53:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9340 invoked from network); 28 Mar 2020 21:53:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NCEn6jiYkuBInipnn6zCj3DDSQcSKN3aqUSzXbErLKE=;
        b=Rq3TMeuPbUxxPHxnu2HIoc61sTFjgLQaNuXNOiePL7aKZf69jQ+dFmmXivkyriybNW
         vgQPzAGLknpxdaaBjXnKSMKfGascpAM2sveRdm1tiga7RQ5eBW5zwWegcXEF3OuBmBHO
         GYik2IFuQR2m0KTYbl2FbSa8Eqyejs4hrgep4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NCEn6jiYkuBInipnn6zCj3DDSQcSKN3aqUSzXbErLKE=;
        b=fjn/4IHDQrSTlSHt5BMXgzR0E3yck8P5hpZSVjt4mHcg6Yl+N7AqtZnw4xFA4/0Nmw
         2BBczXbr1zrtqYYVQLLKT/rThm0Z6c6ktQBRdYXQtd07SQ5fldFysriX66knr0Zvft8P
         cAN7yCK91lV2bSiLS1sHrEV9GPwwTxnzRvEEyXZYqdjUa+kvA4gnpaA7aeqi2Athp3Z3
         3Ix6xyAlG9C2IOm9cBYmCK3Vxm0fYHzHKSUKhhE1oKqruYVPvm8bgqNyQdboIv7st9vS
         4Khk8giTmi6ieVj/atGUMI9eero/D2UdDuPCe7IgqrU1JDel+gNgDOxn9Ckv6RAnVdkb
         0xew==
X-Gm-Message-State: ANhLgQ2tGcTITLmH5Wgar3uW3ZjhIVyKTHUNkeZTXzQ0yFXanAzip0WS
	5KEAYvPdX0qPIpFBVwcdUh4SVA==
X-Google-Smtp-Source: ADFU+vuQs9Pb6Y6ncTb5sBNwy1tSr0+fCbtZKLnv4G2coXixK0YG2/jVjP1gF9qzdCIgU8SdYOki7g==
X-Received: by 2002:a17:90a:368f:: with SMTP id t15mr7297208pjb.23.1585432376997;
        Sat, 28 Mar 2020 14:52:56 -0700 (PDT)
Date: Sat, 28 Mar 2020 14:52:55 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Security Module <linux-security-module@vger.kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Daniel Micay <danielmicay@gmail.com>,
	Djalal Harouni <tixxdz@gmail.com>,
	"Dmitry V . Levin" <ldv@altlinux.org>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	"J . Bruce Fields" <bfields@fieldses.org>,
	Jeff Layton <jlayton@poochiereds.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v10 8/9] proc: use human-readable values for hidehid
Message-ID: <202003281451.88C7CBD23C@keescook>
References: <20200327172331.418878-1-gladkov.alexey@gmail.com>
 <20200327172331.418878-9-gladkov.alexey@gmail.com>
 <202003281321.A69D9DE45@keescook>
 <20200328211453.w44fvkwleltnc2m7@comp-core-i7-2640m-0182e6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200328211453.w44fvkwleltnc2m7@comp-core-i7-2640m-0182e6>

On Sat, Mar 28, 2020 at 10:14:53PM +0100, Alexey Gladkov wrote:
> On Sat, Mar 28, 2020 at 01:28:28PM -0700, Kees Cook wrote:
> > On Fri, Mar 27, 2020 at 06:23:30PM +0100, Alexey Gladkov wrote:
> > > [...]
> > > +	if (!kstrtouint(param->string, base, &result.uint_32)) {
> > > +		ctx->hidepid = result.uint_32;
> > 
> > This need to bounds-check the value with a call to valid_hidepid(), yes?
> 
> The kstrtouint returns 0 on success and -ERANGE on overflow [1].

No, I mean, hidepid cannot be just any uint32 value. It must be in the
enum. Is that checked somewhere else? It looked like the call to
valid_hidepid() was removed.

-- 
Kees Cook
