Return-Path: <SRS0=blXI=YD=lists.openwall.com=kernel-hardening-return-17004-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E0E9C4360C
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Oct 2019 17:44:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8F20A20659
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Oct 2019 17:44:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XAvcCIPN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F20A20659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17004-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9465 invoked by uid 550); 10 Oct 2019 17:44:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9433 invoked from network); 10 Oct 2019 17:44:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=Z/Xo90rzmSfZRsrgT0oiI8BPLh39hTG/m3xFpUxe7nQ=; b=XAvcCIPNXZ2bSN6u+QooRLoDm
	pa0K2Fp7KPn4WkQlLoLictTYV0lMKtwZNLm0kcZhiUEYiF6xyz62G40j+Q28E5sr76s5x0A/C7mdP
	YvLcc6+CEwf2W1sQoeuOSIG9g3JYZWl0bsO+oki9Ez06xOcI1HyMqXE0zr6GuKhn0Sg535VNvQATK
	i/77r5QsFBHTR8NrxTF8NRXzUQ6WSiLDYik884CA5+Ef9Nfl+H8/KIKIoQiR0pLsMuxruL9whTxKH
	yPFDvoe+CeRnb5nYvFW2Aac0P5nNIniT6nfgE8o7UP8Ie/cHTQ05tZbUXrq8iqa4BX5g+FuRlrj+X
	NksvWo3VA==;
Date: Thu, 10 Oct 2019 10:44:13 -0700
From: Matthew Wilcox <willy@infradead.org>
To: Christopher Lameter <cl@linux.com>
Cc: Shyam Saini <mayhs11saini@gmail.com>, linux-mm@kvack.org,
	kernel-hardening@lists.openwall.com,
	Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] slab: Redefine ZERO_SIZE_PTR to include ERR_PTR range
Message-ID: <20191010174413.GT32665@bombadil.infradead.org>
References: <20191010103151.7708-1-mayhs11saini@gmail.com>
 <alpine.DEB.2.21.1910101418500.27284@www.lameter.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1910101418500.27284@www.lameter.com>
User-Agent: Mutt/1.12.1 (2019-06-15)

On Thu, Oct 10, 2019 at 02:22:40PM +0000, Christopher Lameter wrote:
> On Thu, 10 Oct 2019, Shyam Saini wrote:
> 
> > This will help error related to ERR_PTR stand out better.
> 
> Maybe make ZERO_SIZE_PTR an ERRNO value instead? Then allow ERR_PTRs to be
> used instead of ZERO_SIZE_PTRs
> 
> ERRNO_ZERO_OBJECT
> 
> or something like that?

I was wondering about something like that too, but allocating zero bytes
isn't actually an error, and if we have code that does something like:

	void *p = my_funky_alloc(size, ...);

	if (IS_ERR(p))
		return PTR_ERR(p);

then we might get this errno returned to userspace.

The change is definitely worth thinking about.
