Return-Path: <SRS0=VIBL=BJ=lists.openwall.com=kernel-hardening-return-19492-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B95C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jul 2020 09:06:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 843CA2072A
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jul 2020 09:06:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z/OlMNCj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 843CA2072A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19492-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18133 invoked by uid 550); 30 Jul 2020 09:06:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18113 invoked from network); 30 Jul 2020 09:06:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596099983;
	bh=ieC3UQSH9xTQQlFP1mBTpQK8Jaet0JuMdqnPvTiLzSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z/OlMNCjgJjVCDEAUFFVbS7j9qnE79NsrCIar3YE+oLzkykZo4SyLPjtjBmvhhkcD
	 T9PkgtjWLgbnsiDPD6gD6YwuUd+7hajjK66mABoLrTUlc/yFV744DxvWyv+/e12Zv2
	 o7cXTtiuU4bHGqJbB2DKVrNBS9iI30MBTfDZpeMY=
Date: Thu, 30 Jul 2020 11:06:12 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: madvenka@linux.microsoft.com
Cc: kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, oleg@redhat.com,
	x86@kernel.org
Subject: Re: [PATCH v1 2/4] [RFC] x86/trampfd: Provide support for the
 trampoline file descriptor
Message-ID: <20200730090612.GA900546@kroah.com>
References: <aefc85852ea518982e74b233e11e16d2e707bc32>
 <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <20200728131050.24443-3-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728131050.24443-3-madvenka@linux.microsoft.com>

On Tue, Jul 28, 2020 at 08:10:48AM -0500, madvenka@linux.microsoft.com wrote:
> +EXPORT_SYMBOL_GPL(trampfd_valid_regs);

Why are all of these exported?  I don't see a module user in this
series, or did I miss it somehow?

EXPORT_SYMBOL* is only needed for symbols to be used by modules, not by
code that is built into the kernel.

thanks,

greg k-h
