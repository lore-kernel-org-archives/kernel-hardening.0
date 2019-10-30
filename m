Return-Path: <SRS0=sUJ+=YX=lists.openwall.com=kernel-hardening-return-17156-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3027ACA9EAE
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 00:16:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7842120856
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 00:16:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="llcQOlMd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7842120856
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17156-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13715 invoked by uid 550); 30 Oct 2019 00:16:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13675 invoked from network); 30 Oct 2019 00:16:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
	s=201909; t=1572394583;
	bh=pBaC0E9LYlY/85OHfeGNEyHFZDoW+RSt2lY9wSrx+io=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=llcQOlMdkDElups34dq04jnjl2wvUAAqkBkrmQyp7Jgm9A5516SvjV7Z7nZvVXDXZ
	 IS+l3zdcaE53fLM+7n7H8PMif/SnIZb0TPc9aynYj8l/L74QztinVgr4dwkZOuB/PH
	 Xlf3q/xZXVIuW0UvBbF0NgCBbFvlimSBI5CxqzJvPm6kmwvQPVPwGh/gE+eJw52+82
	 4CuJPkhN0AbTvqvVH+u2wePRGAQCzoHXvVK6Tmf+/FW8zk57Yz3PYZRkQmT8sEzw+E
	 9GamddbrCZH/ZbTS+jTy5ff0VrgW3raDjn1siNem8Tq4xctRY4qQ54L89O2aKrPEAe
	 R0LT01Rh4EsOw==
From: Michael Ellerman <mpe@ellerman.id.au>
To: Kees Cook <keescook@chromium.org>, Russell Currey <ruscur@russell.cc>
Cc: linuxppc-dev@lists.ozlabs.org, christophe.leroy@c-s.fr, joel@jms.id.au, ajd@linux.ibm.com, dja@axtens.net, npiggin@gmail.com, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v4 0/4] Implement STRICT_MODULE_RWX for powerpc
In-Reply-To: <201910291601.F161FBBAB2@keescook>
References: <20191014051320.158682-1-ruscur@russell.cc> <201910291601.F161FBBAB2@keescook>
Date: Wed, 30 Oct 2019 11:16:22 +1100
Message-ID: <87zhhjf5pl.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain

Kees Cook <keescook@chromium.org> writes:
> On Mon, Oct 14, 2019 at 04:13:16PM +1100, Russell Currey wrote:
>> v3 cover letter here:
>> https://lists.ozlabs.org/pipermail/linuxppc-dev/2019-October/198023.html
>> 
>> Only minimal changes since then:
>> 
>> - patch 2/4 commit message update thanks to Andrew Donnellan
>> - patch 3/4 made neater thanks to Christophe Leroy
>> - patch 3/4 updated Kconfig description thanks to Daniel Axtens
>
> I continue to be excited about this work. :) Is there anything holding
> it back from landing in linux-next?

I had some concerns, which I stupidly posted in reply to v3:

  https://lore.kernel.org/linuxppc-dev/87pnio5fva.fsf@mpe.ellerman.id.au/

cheers
