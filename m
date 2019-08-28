Return-Path: <SRS0=0zWl=WY=lists.openwall.com=kernel-hardening-return-16812-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9050EC3A5A1
	for <kernel-hardening@archiver.kernel.org>; Wed, 28 Aug 2019 13:01:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BF2FB22CF8
	for <kernel-hardening@archiver.kernel.org>; Wed, 28 Aug 2019 13:01:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF2FB22CF8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16812-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30710 invoked by uid 550); 28 Aug 2019 13:01:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30675 invoked from network); 28 Aug 2019 13:01:47 -0000
From: Michael Ellerman <mpe@ellerman.id.au>
To: Scott Wood <oss@buserror.net>
Cc: linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com, yebin10@huawei.com, thunder.leizhen@huawei.com, jingxiangfeng@huawei.com, fanchengyang@huawei.com, zhaohongjiang@huawei.com, Jason Yan <yanaijie@huawei.com>, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com, keescook@chromium.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v6 00/12] implement KASLR for powerpc/fsl_booke/32
In-Reply-To: <827cc152757906a0ebc04bbe56cdf44683721eb4.camel@buserror.net>
References: <20190809100800.5426-1-yanaijie@huawei.com> <ed96199d-715c-3f1c-39db-10a569ba6601@huawei.com> <529fd908-42d6-f96f-daa2-9010f3035879@huawei.com> <878srf4cjk.fsf@concordia.ellerman.id.au> <827cc152757906a0ebc04bbe56cdf44683721eb4.camel@buserror.net>
Date: Wed, 28 Aug 2019 23:01:28 +1000
Message-ID: <87h861v3yv.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain

Scott Wood <oss@buserror.net> writes:
> On Tue, 2019-08-27 at 11:33 +1000, Michael Ellerman wrote:
>> Jason Yan <yanaijie@huawei.com> writes:
>> > A polite ping :)
>> > 
>> > What else should I do now?
>> 
>> That's a good question.
>> 
>> Scott, are you still maintaining FSL bits, 
>
> Sort of... now that it's become very low volume, it's easy to forget when
> something does show up (or miss it if I'm not CCed).  It'd probably help if I
> were to just ack patches instead of thinking "I'll do a pull request for this
> later" when it's just one or two patches per cycle.

Yep, understand. Just sending acks is totally fine if you don't have
enough for a pull request.

cheers
