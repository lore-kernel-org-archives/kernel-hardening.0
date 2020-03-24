Return-Path: <SRS0=eNXl=5J=lists.openwall.com=kernel-hardening-return-18156-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C9DCC43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:29:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 899B220774
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:29:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OFGVUo5v"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 899B220774
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18156-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19501 invoked by uid 550); 24 Mar 2020 15:29:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19465 invoked from network); 24 Mar 2020 15:29:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GEjRdfenMkp63VsokJpuSg83pLCvxbzC2FSqWHEQYfw=; b=OFGVUo5vk4dxUpApdVZkU8BtaQ
	SbDb4U6h4H8vwFCpBn0PUrNHWxpN2fsX3UasbiraFLSez4i3h4GGz4JxJA/7MJxTDTECX2ZPeQVoH
	jz7VnRWd6YKNJ8jHWNKOTJrOw1sgctncU3s5nYKrMNv6uyPvLPJHY24NSXSQxJ0++79MJKkYw5uA0
	p62F6zJ76k2Gncl+vao/z3heX66E/axz1gEnUkW3WrU0JZb/oTFYevV6WNnUOg5VQ+XekCiY7ORZK
	Ziq2cBiJ9doK25+WQxYl+tC5jwNh8GcI0Ef4xXBgruJG9aVMzvljAEeJ8uxN3Wk0fUrJdZ2PbPky+
	H8wRMSTQ==;
Date: Tue, 24 Mar 2020 16:29:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will@kernel.org>
Cc: Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Ingo Molnar <mingo@kernel.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jan Glauber <jglauber@marvell.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH v2] lib/refcount: Document interaction with PID_MAX_LIMIT
Message-ID: <20200324152905.GR20696@hirez.programming.kicks-ass.net>
References: <20200303105427.260620-1-jannh@google.com>
 <20200317222717.GF20788@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317222717.GF20788@willie-the-truck>

On Tue, Mar 17, 2020 at 10:27:18PM +0000, Will Deacon wrote:

> Acked-by: Will Deacon <will@kernel.org>
> 
> Peter -- would you be able to take this through -tip, please?

Got it, I'll stick it in locking/core.

Thanks!
