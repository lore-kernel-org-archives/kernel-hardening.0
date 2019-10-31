Return-Path: <SRS0=QACG=YY=lists.openwall.com=kernel-hardening-return-17175-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF3ECA9EC7
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 00:06:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8715A20856
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 00:06:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=jms.id.au header.i=@jms.id.au header.b="AnCAfDD6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8715A20856
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jms.id.au
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17175-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25828 invoked by uid 550); 31 Oct 2019 00:06:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25794 invoked from network); 31 Oct 2019 00:06:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0li8VzqpFsQ/b63Xcg1C+N/uk9Yevq8DwZDh1ZCAyPg=;
        b=AnCAfDD6kapseXRPfRWQDvND9gyAVElPT6h62DxuGk1VF6vrQbrA1sXw/bMHkt9ycY
         yp6kuNymmX/ATYi8WGP7tfxs+V64ZKBAO+hQs6KWYth2G9QLwIs2F2puS+R4kOFZi8+j
         g9J/M23rZ39yYeXas5iRE8U/lSWKuIqe/XmdY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0li8VzqpFsQ/b63Xcg1C+N/uk9Yevq8DwZDh1ZCAyPg=;
        b=LPXcg5WCLSqJFadS/FOwN3eytk33tpRE4jUwCxEaK8dFS61XZ8Y3Ghw36VzHdzZrZQ
         3EfMOZNRPaRiNaH0Vo/xSMF99QFd0ig0FN9dELh48KE2Y1UKy8UfJPbjo/NIzNngxIr2
         F7Dke1uhqmO5qOj11dWyb/pklhg8w0XOp0Ivc8b0Z2h/rA0rBLWC7qEf/cxe0yBk3Kq+
         8NKJy6JZAN1e54wZM0lLKWQHstA/dQp4ahLUf1wM+AiqvhNq3Ll6EeFTKG/8kDgnjy9Y
         bs0i8XUYvfQfkxbAQtLdnS0B+H1VlnG9Ut1VirkZ7SrFgzd3Qw76XVRxYfIuDnhizAFw
         G7Cw==
X-Gm-Message-State: APjAAAWGXbY3YDG/qELVxHlrDPu7UGpikqDkj2Wn9LpO6wXmr/AdN1FC
	CWM49uIhwiNAW9kj5KsZf7KpfV+mjXIR2Tzo7Uc=
X-Google-Smtp-Source: APXvYqxp1tJqDjfdpxPoNT94F1nQa51ElslA+sMSYvW++gja95tY+RNagmDf2v3YySCW1F3BZflwcasyPdjX/DYa0WE=
X-Received: by 2002:a05:620a:1244:: with SMTP id a4mr2740405qkl.208.1572480361858;
 Wed, 30 Oct 2019 17:06:01 -0700 (PDT)
MIME-Version: 1.0
References: <20191030073111.140493-1-ruscur@russell.cc> <20191030073111.140493-6-ruscur@russell.cc>
In-Reply-To: <20191030073111.140493-6-ruscur@russell.cc>
From: Joel Stanley <joel@jms.id.au>
Date: Thu, 31 Oct 2019 00:05:49 +0000
Message-ID: <CACPK8XfOLfpq6Em7nPe7ef-5D2U-feN4A5u_+K=RrBGX2x=5ew@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] powerpc/configs: Enable STRICT_MODULE_RWX in skiroot_defconfig
To: Russell Currey <ruscur@russell.cc>
Cc: linuxppc-dev@lists.ozlabs.org, Christophe LEROY <christophe.leroy@c-s.fr>, 
	Michael Ellerman <mpe@ellerman.id.au>, ajd@linux.ibm.com, Daniel Axtens <dja@axtens.net>, 
	Nicholas Piggin <npiggin@gmail.com>, kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 30 Oct 2019 at 07:31, Russell Currey <ruscur@russell.cc> wrote:
>
> skiroot_defconfig is the only powerpc defconfig with STRICT_KERNEL_RWX
> enabled, and if you want memory protection for kernel text you'd want it
> for modules too, so enable STRICT_MODULE_RWX there.
>
> Signed-off-by: Russell Currey <ruscur@russell.cc>

Acked-by: Joel Stanley <joel@jms.id.au>

> ---
>  arch/powerpc/configs/skiroot_defconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/powerpc/configs/skiroot_defconfig b/arch/powerpc/configs/skiroot_defconfig
> index 1253482a67c0..719d899081b3 100644
> --- a/arch/powerpc/configs/skiroot_defconfig
> +++ b/arch/powerpc/configs/skiroot_defconfig
> @@ -31,6 +31,7 @@ CONFIG_PERF_EVENTS=y
>  CONFIG_SLAB_FREELIST_HARDENED=y
>  CONFIG_JUMP_LABEL=y
>  CONFIG_STRICT_KERNEL_RWX=y
> +CONFIG_STRICT_MODULE_RWX=y
>  CONFIG_MODULES=y
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_MODULE_SIG=y
> --
> 2.23.0
>
