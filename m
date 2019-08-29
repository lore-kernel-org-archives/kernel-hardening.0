Return-Path: <SRS0=OAtx=WZ=lists.openwall.com=kernel-hardening-return-16823-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DABB2C3A59F
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Aug 2019 12:06:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 20E9B2166E
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Aug 2019 12:06:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="q1HORZW0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20E9B2166E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=axtens.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16823-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31851 invoked by uid 550); 29 Aug 2019 12:05:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11547 invoked from network); 29 Aug 2019 06:40:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=ORK7X7Ak0hv9l57pH4NKaklPes9OoYBlRdCvb9W3dTo=;
        b=q1HORZW0OWUjI/oO7K00q9t+5S+cjgOt8RQe/7PnPWJMWD9OhqHBvLnu4qgDe/tVT/
         gTg+qo2wqsSu9VsdHm7FxWpN0UtNKq45SLZlnHpeGQuaC8HD1/H2wu36mcgAqbKSvIu0
         vkouxC4mK+bdT56ChNbGZAgyewi1tZ9h+qpfE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ORK7X7Ak0hv9l57pH4NKaklPes9OoYBlRdCvb9W3dTo=;
        b=LXIG4Rl9tO8oQSqc8RKjesHIPBQh+gtcXXD9pDdfMIw5UiYLsgofCTTGuTcc7Eft4O
         nXT/6J71LLx0RciaY7xorztliDKU6A06Md3g4CpJyRoRh0FlSBwUuGBn1p/AeOwEmR3s
         KXUrtY8houBpmBr4cOxn4MWNX5sGENNuPeEdXhA2Uty2lD1pnpD2AD5THRnDxH5pjiwP
         bPV4fcLZA3psqwjhNt77zvElbrpveHJER/toKCC7dW7S7yAWjP+FFtpWUSkDuE1Jb4KM
         e4PhZqo674HcmZBtp1uxaJXryDDciCvfa07f6kqfgxUCM8BN0vzKcvWsjJNXALzBOBGV
         R0YQ==
X-Gm-Message-State: APjAAAViOOzeo1UjCOwJLtaD5e6+0Y1ZA6fcai8K3lEQLZC8SLkz5Me3
	Ud8du8c/n5xfIugVGQHAfEKJjQ==
X-Google-Smtp-Source: APXvYqxDJtWozUOTxlziw7Ld/8on+Ta0l+4nJ5okDn71QH5EXiS01UtjM/Lq+WdusL28oQRhpF6Dwg==
X-Received: by 2002:a17:902:a50a:: with SMTP id s10mr8198619plq.108.1567060808510;
        Wed, 28 Aug 2019 23:40:08 -0700 (PDT)
From: Daniel Axtens <dja@axtens.net>
To: "Christopher M. Riedl" <cmr@informatik.wtf>, linuxppc-dev@ozlabs.org, kernel-hardening@lists.openwall.com
Cc: ajd@linux.ibm.com
Subject: Re: [PATCH v5 1/2] powerpc/xmon: Allow listing and clearing breakpoints in read-only mode
In-Reply-To: <20190828034613.14750-2-cmr@informatik.wtf>
References: <20190828034613.14750-1-cmr@informatik.wtf> <20190828034613.14750-2-cmr@informatik.wtf>
Date: Thu, 29 Aug 2019 16:40:03 +1000
Message-ID: <87ef14v5j0.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain

Hi Chris,

> Read-only mode should not prevent listing and clearing any active
> breakpoints.

I tested this and it works for me:

Tested-by: Daniel Axtens <dja@axtens.net>

> +		if (xmon_is_ro || !scanhex(&a)) {

It took me a while to figure out what this line does: as I understand
it, the 'b' command can also be used to install a breakpoint (as well as
bi/bd). If we are in ro mode or if the input after 'b' doesn't scan as a
hex string, print the list of breakpoints instead. Anyway, I'm now
happy with it, so:

Reviewed-by: Daniel Axtens <dja@axtens.net>

Regards,
Daniel

>  			/* print all breakpoints */
>  			printf("   type            address\n");
>  			if (dabr.enabled) {
> -- 
> 2.23.0
