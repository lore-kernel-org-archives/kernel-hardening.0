Return-Path: <SRS0=Qo1z=V6=lists.openwall.com=kernel-hardening-return-16692-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1410C19759
	for <kernel-hardening@archiver.kernel.org>; Fri,  2 Aug 2019 00:49:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 25D0F2084C
	for <kernel-hardening@archiver.kernel.org>; Fri,  2 Aug 2019 00:49:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25D0F2084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16692-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13942 invoked by uid 550); 2 Aug 2019 00:49:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13910 invoked from network); 2 Aug 2019 00:49:07 -0000
Subject: Re: [PATCH v3 00/10] implement KASLR for powerpc/fsl_booke/32
To: Diana Madalina Craciun <diana.craciun@nxp.com>, "mpe@ellerman.id.au"
	<mpe@ellerman.id.au>, "linuxppc-dev@lists.ozlabs.org"
	<linuxppc-dev@lists.ozlabs.org>, "christophe.leroy@c-s.fr"
	<christophe.leroy@c-s.fr>, "benh@kernel.crashing.org"
	<benh@kernel.crashing.org>, "paulus@samba.org" <paulus@samba.org>,
	"npiggin@gmail.com" <npiggin@gmail.com>, "keescook@chromium.org"
	<keescook@chromium.org>, "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"wangkefeng.wang@huawei.com" <wangkefeng.wang@huawei.com>,
	"yebin10@huawei.com" <yebin10@huawei.com>, "thunder.leizhen@huawei.com"
	<thunder.leizhen@huawei.com>, "jingxiangfeng@huawei.com"
	<jingxiangfeng@huawei.com>, "fanchengyang@huawei.com"
	<fanchengyang@huawei.com>, "zhaohongjiang@huawei.com"
	<zhaohongjiang@huawei.com>
References: <20190731094318.26538-1-yanaijie@huawei.com>
 <VI1PR0401MB2463844DD4A35EB3F0959C22FFDE0@VI1PR0401MB2463.eurprd04.prod.outlook.com>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <bc30b426-d7c6-c839-ebd2-a404465079a3@huawei.com>
Date: Fri, 2 Aug 2019 08:48:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <VI1PR0401MB2463844DD4A35EB3F0959C22FFDE0@VI1PR0401MB2463.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.203]
X-CFilter-Loop: Reflected



On 2019/8/1 22:36, Diana Madalina Craciun wrote:
> Hi Jason,
> 
> I have tested these series on a P4080 platform.
> 
> Regards,
> Diana

Diana, thank you so much.

So can you take a look at the code of this version and give a 
Reviewed-by or Tested-by?

Thanks,
Jason

