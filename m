Return-Path: <SRS0=7AuK=DH=lists.openwall.com=kernel-hardening-return-20070-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F19C4727E
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Sep 2020 17:29:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7C54120706
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Sep 2020 17:29:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C54120706
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20070-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24251 invoked by uid 550); 30 Sep 2020 17:28:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19728 invoked from network); 30 Sep 2020 17:19:25 -0000
Date: Wed, 30 Sep 2020 18:19:08 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Linuxarm <linuxarm@huawei.com>
Subject: Re: [PATCH v3 1/2] arm64/acpi: disallow AML memory opregions to
 access kernel memory
Message-ID: <20200930171908.GA1732@gaia>
References: <20200626155832.2323789-1-ardb@kernel.org>
 <20200626155832.2323789-2-ardb@kernel.org>
 <20200928170216.00006ff2@huawei.com>
 <CAMj1kXH1LZ15gzfW+7X5A4dMCD33DqNLnVrnLRo1zpw1Ekg+Lw@mail.gmail.com>
 <20200928181755.000019bf@huawei.com>
 <CAMj1kXGLVgAc0u9pSy0cKkmQXntdqjkkoM5wpdwLiwZfKOXKPA@mail.gmail.com>
 <20200930102722.00000bff@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930102722.00000bff@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Jonathan,

On Wed, Sep 30, 2020 at 10:27:22AM +0100, Jonathan Cameron wrote:
> On Tue, 29 Sep 2020 11:29:48 +0200 Ard Biesheuvel <ardb@kernel.org> wrote:
> > Could you try the patch below? Since the memory holding the tables is
> > already memblock_reserve()d, we can just mark it NOMAP, and permit r/o
> > remapping of NOMAP regions.
> 
> Looks good.  Thanks.
> 
> Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Could you please try the updated patch that Ard posted. There are a few
minor differences:

https://lore.kernel.org/linux-acpi/20200929132522.18067-1-ardb@kernel.org/

Thanks.

-- 
Catalin
