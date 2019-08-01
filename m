Return-Path: <SRS0=D5e1=V5=lists.openwall.com=kernel-hardening-return-16691-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E75EC19759
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Aug 2019 20:26:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BB2662087E
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Aug 2019 20:25:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="m6r5BoZC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB2662087E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16691-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10114 invoked by uid 550); 1 Aug 2019 20:25:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10082 invoked from network); 1 Aug 2019 20:25:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564691141;
	bh=6WH2vwf20NpWqVWIo2ROGaN3O0fKC92RWC72jcj+LH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m6r5BoZCHfshMdO1KzkhRDvwqRtMa6LUht6fFpiUzdluYGSVtGjyzWdQdOYIW6Xl1
	 823hceehwH8Fo/LqgyolgrRh36COU3Mfv2U7v0pa0XAP0uPf8kQQASRuqhi/9OQWWG
	 ixtJ2bTxw94JtHOsVfkFGbWWMRoLOivYAlCbCDf4=
Date: Thu, 1 Aug 2019 22:25:38 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Rick Mark <rickmark@outlook.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	"keescook@chromium.org" <keescook@chromium.org>
Subject: Re: Hello Kernel Hardening
Message-ID: <20190801202538.GA4383@kroah.com>
References: <20190731091818.GB29294@kroah.com>
 <BYAPR07MB5782A0925C97FBCB172BD3C0DADF0@BYAPR07MB5782.namprd07.prod.outlook.com>
 <20190801055413.GA24062@kroah.com>
 <BYAPR07MB57828912977C33ABC45E4E10DADE0@BYAPR07MB5782.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR07MB57828912977C33ABC45E4E10DADE0@BYAPR07MB5782.namprd07.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)


A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Thu, Aug 01, 2019 at 08:00:33PM +0000, Rick Mark wrote:
> Awesome,
> 
> Thanks Greg for the advice and welcome.

A bit more advice above on how the kernel developers handle email :)

> I'm already starting to put together one with Linaro / OP-TEE cross
> compiled for QEMU ARMv8.  I'll send it back out when it's working /
> not shameful enough to actually `git push` to a fork.

I would recommend reading the kernel development process documentation
as well, in the kernel source tree.  That will give you a good idea as
to how we work and how we handle reviewing patches (hint, we don't use
git trees for review).

good luck!

greg k-h
