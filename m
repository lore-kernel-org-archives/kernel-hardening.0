Return-Path: <SRS0=xsVT=YP=lists.openwall.com=kernel-hardening-return-17095-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF2A2CA9EA0
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Oct 2019 23:29:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1D75F2086D
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Oct 2019 23:29:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D75F2086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=buserror.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17095-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9582 invoked by uid 550); 22 Oct 2019 23:29:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9550 invoked from network); 22 Oct 2019 23:29:43 -0000
Message-ID: <51ee13bc7ced50c3aa1a7ac9335bea16651db684.camel@buserror.net>
From: Scott Wood <oss@buserror.net>
To: Jason Yan <yanaijie@huawei.com>, mpe@ellerman.id.au, 
 linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com,
 christophe.leroy@c-s.fr,  benh@kernel.crashing.org, paulus@samba.org,
 npiggin@gmail.com,  keescook@chromium.org,
 kernel-hardening@lists.openwall.com
Cc: wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org, 
 jingxiangfeng@huawei.com, zhaohongjiang@huawei.com,
 thunder.leizhen@huawei.com,  yebin10@huawei.com
Date: Tue, 22 Oct 2019 18:22:47 -0500
In-Reply-To: <0543af6f-df4a-81ff-41fe-c81959568859@huawei.com>
References: <20190920094546.44948-1-yanaijie@huawei.com>
	 <9c2dd2a8-83f2-983c-383e-956e19a7803a@huawei.com>
	 <c4769b34-95f6-81b9-4856-50459630aa0d@huawei.com>
	 <38141b946f3376ce471e46eaf065e357ac540354.camel@buserror.net>
	 <90bb659a-bde4-3b8e-8f01-bf22d7534f44@huawei.com>
	 <34ef1980887c8a6d635c20bdaf748bb0548e51b5.camel@buserror.net>
	 <0543af6f-df4a-81ff-41fe-c81959568859@huawei.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2601:449:8480:af0:12bf:48ff:fe84:c9a0
X-SA-Exim-Rcpt-To: yanaijie@huawei.com, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org, jingxiangfeng@huawei.com, zhaohongjiang@huawei.com, thunder.leizhen@huawei.com, yebin10@huawei.com
X-SA-Exim-Mail-From: oss@buserror.net
Subject: Re: [PATCH v7 00/12] implement KASLR for powerpc/fsl_booke/32
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on baldur.buserror.net)

On Mon, 2019-10-21 at 11:34 +0800, Jason Yan wrote:
> 
> On 2019/10/10 2:46, Scott Wood wrote:
> > On Wed, 2019-10-09 at 16:41 +0800, Jason Yan wrote:
> > > Hi Scott,
> > > 
> > > On 2019/10/9 15:13, Scott Wood wrote:
> > > > On Wed, 2019-10-09 at 14:10 +0800, Jason Yan wrote:
> > > > > Hi Scott,
> > > > > 
> > > > > Would you please take sometime to test this?
> > > > > 
> > > > > Thank you so much.
> > > > > 
> > > > > On 2019/9/24 13:52, Jason Yan wrote:
> > > > > > Hi Scott,
> > > > > > 
> > > > > > Can you test v7 to see if it works to load a kernel at a non-zero
> > > > > > address?
> > > > > > 
> > > > > > Thanks,
> > > > 
> > > > Sorry for the delay.  Here's the output:
> > > > 
> > > 
> > > Thanks for the test.
> > > 
> > > > ## Booting kernel from Legacy Image at 10000000 ...
> > > >      Image Name:   Linux-5.4.0-rc2-00050-g8ac2cf5b4
> > > >      Image Type:   PowerPC Linux Kernel Image (gzip compressed)
> > > >      Data Size:    7521134 Bytes = 7.2 MiB
> > > >      Load Address: 04000000
> > > >      Entry Point:  04000000
> > > >      Verifying Checksum ... OK
> > > > ## Flattened Device Tree blob at 1fc00000
> > > >      Booting using the fdt blob at 0x1fc00000
> > > >      Uncompressing Kernel Image ... OK
> > > >      Loading Device Tree to 07fe0000, end 07fff65c ... OK
> > > > KASLR: No safe seed for randomizing the kernel base.
> > > > OF: reserved mem: initialized node qman-fqd, compatible id fsl,qman-
> > > > fqd
> > > > OF: reserved mem: initialized node qman-pfdr, compatible id fsl,qman-
> > > > pfdr
> > > > OF: reserved mem: initialized node bman-fbpr, compatible id fsl,bman-
> > > > fbpr
> > > > Memory CAM mapping: 64/64/64 Mb, residual: 12032Mb
> > > 
> > > When boot from 04000000, the max CAM value is 64M. And
> > > you have a board with 12G memory, CONFIG_LOWMEM_CAM_NUM=3 means only
> > > 192M memory is mapped and when kernel is randomized at the middle of
> > > this 192M memory, we will not have enough continuous memory for node
> > > map.
> > > 
> > > Can you set CONFIG_LOWMEM_CAM_NUM=8 and see if it works?
> > 
> > OK, that worked.
> > 
> 
> Hi Scott, any more cases should be tested or any more comments?
> What else need to be done before this feature can be merged?

I've just applied it and sent a pull request.

-Scott


