Return-Path: <SRS0=z1wY=WZ=lists.openwall.com=kernel-hardening-return-16818-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DATE_IN_PAST_03_06,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4619C3A59F
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Aug 2019 12:05:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0796122CF5
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Aug 2019 12:05:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0796122CF5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=buserror.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16818-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25785 invoked by uid 550); 29 Aug 2019 12:05:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10053 invoked from network); 28 Aug 2019 22:01:05 -0000
Message-ID: <457508f39b96caab15ed4bf7ff0d586ffdc850f8.camel@buserror.net>
From: Scott Wood <oss@buserror.net>
To: Jason Yan <yanaijie@huawei.com>
Cc: wangkefeng.wang@huawei.com, keescook@chromium.org, 
	kernel-hardening@lists.openwall.com, thunder.leizhen@huawei.com, 
	linux-kernel@vger.kernel.org, npiggin@gmail.com, jingxiangfeng@huawei.com, 
	diana.craciun@nxp.com, paulus@samba.org, zhaohongjiang@huawei.com, 
	fanchengyang@huawei.com, linuxppc-dev@lists.ozlabs.org, yebin10@huawei.com
Date: Wed, 28 Aug 2019 11:44:48 -0500
In-Reply-To: <de603506-5c4e-4ca3-bd77-e3a69af9faef@huawei.com>
References: <20190809100800.5426-1-yanaijie@huawei.com>
	 <20190809100800.5426-7-yanaijie@huawei.com>
	 <20190828045454.GB17757@home.buserror.net>
	 <de603506-5c4e-4ca3-bd77-e3a69af9faef@huawei.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2601:449:8400:7293:12bf:48ff:fe84:c9a0
X-SA-Exim-Rcpt-To: yanaijie@huawei.com, wangkefeng.wang@huawei.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, thunder.leizhen@huawei.com, linux-kernel@vger.kernel.org, npiggin@gmail.com, jingxiangfeng@huawei.com, diana.craciun@nxp.com, paulus@samba.org, zhaohongjiang@huawei.com, fanchengyang@huawei.com, linuxppc-dev@lists.ozlabs.org, yebin10@huawei.com
X-SA-Exim-Mail-From: oss@buserror.net
Subject: Re: [PATCH v6 06/12] powerpc/fsl_booke/32: implement KASLR
 infrastructure
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on baldur.buserror.net)

On Wed, 2019-08-28 at 19:03 +0800, Jason Yan wrote:
> 
> On 2019/8/28 12:54, Scott Wood wrote:
> > On Fri, Aug 09, 2019 at 06:07:54PM +0800, Jason Yan wrote:
> > > +/*
> > > + * To see if we need to relocate the kernel to a random offset
> > > + * void *dt_ptr - address of the device tree
> > > + * phys_addr_t size - size of the first memory block
> > > + */
> > > +notrace void __init kaslr_early_init(void *dt_ptr, phys_addr_t size)
> > > +{
> > > +	unsigned long tlb_virt;
> > > +	phys_addr_t tlb_phys;
> > > +	unsigned long offset;
> > > +	unsigned long kernel_sz;
> > > +
> > > +	kernel_sz = (unsigned long)_end - KERNELBASE;
> > 
> > Why KERNELBASE and not kernstart_addr?
> > 
> 
> Did you mean kernstart_virt_addr? It should be kernstart_virt_addr.

Yes, kernstart_virt_addr.  KERNELBASE will be incorrect if the kernel was
loaded at a nonzero physical address without CONFIG_PHYSICAL_START being
adjusted to match.

-Scott


