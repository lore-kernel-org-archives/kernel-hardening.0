Return-Path: <SRS0=L9/5=V5=lists.openwall.com=kernel-hardening-return-16683-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0011DC19759
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Aug 2019 05:54:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3BF872089E
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Aug 2019 05:54:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fq+zeya4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BF872089E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16683-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14266 invoked by uid 550); 1 Aug 2019 05:54:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14231 invoked from network); 1 Aug 2019 05:54:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564638856;
	bh=vPTm0+7/hJa5qvqjNs2fHzMIJZdDsPyySouLphJObn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fq+zeya4CNUjM3Gmbxdia375Y1Bt7/nmJsV425xelOsoXWJ6pZfHWFI6unosdVn8U
	 rLqOMFxsz44WOhVYCmdbhm1hetOn5Pn+nOGz/Offl1svoPLB/MFIsk7b4zXJQ9StIF
	 KF0OHqko2agV1waWYFQJ51pwE1NkclPnG2iWkizY=
Date: Thu, 1 Aug 2019 07:54:13 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Rick Mark <rickmark@outlook.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Subject: Re: Hello Kernel Hardening
Message-ID: <20190801055413.GA24062@kroah.com>
References: <20190731091818.GB29294@kroah.com>
 <BYAPR07MB5782A0925C97FBCB172BD3C0DADF0@BYAPR07MB5782.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BYAPR07MB5782A0925C97FBCB172BD3C0DADF0@BYAPR07MB5782.namprd07.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)

On Wed, Jul 31, 2019 at 08:33:59PM +0000, Rick Mark wrote:
> Sorry, didn’t realize the Dropbox link shortener required login.  Full link:
> 
> 
> https://paper.dropbox.com/doc/Security-Critical-Kernel-Object-Confidentiality-and-Integrity-akFs9yNQ8YxLKP3BEaHZ8

That works better, thanks!

As always, why not knock up a working prototype of your idea first and
post it?  That's how we work with kernel development.  Lots of people
have random ideas, but to see if they actually work you need a working
patch.

good luck!

greg k-h
