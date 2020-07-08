Return-Path: <SRS0=VX1M=AT=lists.openwall.com=kernel-hardening-return-19258-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0498EC433E0
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jul 2020 16:17:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 529A020786
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jul 2020 16:17:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="vMOgdCQ4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 529A020786
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19258-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23830 invoked by uid 550); 8 Jul 2020 16:17:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23798 invoked from network); 8 Jul 2020 16:17:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594225039;
	bh=f1paydPvqX5mmoQC/Q4NS+87DmSKuFrcvAhN61O4cqE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=vMOgdCQ4ZaXVWEYGO4yvTefmoEl44l3Ytbq9A268zygfOy5G/d3AA0EIcfkYFoo5M
	 1pTVrRlZgBLWvsu4vlj2XsX0D28htMzHJ2ska1mrH4E7MQWt2a3nYBOMx994JYp7UW
	 Udmt0wwCC5uU4MdBlMiqSWkxtLImoe/foWljS6Qc=
X-Gm-Message-State: AOAM533uVsah//e2Q50Wk/tiH0YIUVXgUm4G7Zyvi0kMIMPVDMY2dKVn
	McQkGm0EqSiEQAI/EVPgKfiDfDnGmmFTyWrbkQY=
X-Google-Smtp-Source: ABdhPJxecRpEvEPRMVMbo2s6nVaZxwYg5eNwh2bAx1ZEx7RL90ErAcNU5zXlYC7f6VanZkv7skq+sjlNi5EDHM1TgJs=
X-Received: by 2002:aca:d643:: with SMTP id n64mr7803399oig.33.1594225039226;
 Wed, 08 Jul 2020 09:17:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200626155832.2323789-1-ardb@kernel.org>
In-Reply-To: <20200626155832.2323789-1-ardb@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 8 Jul 2020 19:17:08 +0300
X-Gmail-Original-Message-ID: <CAMj1kXGMhmsJmwog6iC+r5Nhyx9QwQkbNdUPSD+UbgZyNvtyzQ@mail.gmail.com>
Message-ID: <CAMj1kXGMhmsJmwog6iC+r5Nhyx9QwQkbNdUPSD+UbgZyNvtyzQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] arm64/acpi: restrict AML opregion memory access
To: Linux ARM <linux-arm-kernel@lists.infradead.org>, James Morse <james.morse@arm.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, 
	Sudeep Holla <sudeep.holla@arm.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

(+ James)

On Fri, 26 Jun 2020 at 18:58, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> v2:
> - do a more elaborate check on the region, against the EFI memory map
>
> v3:
> - split into two patches
> - fallback to __ioremap() for ACPI reclaim memory, in case it is not covered
>   by the linear mapping (e.g., when booting a kdump kernel)
>
> Ard Biesheuvel (2):
>   arm64/acpi: disallow AML memory opregions to access kernel memory
>   arm64/acpi: disallow writeable AML opregion mapping for EFI code
>     regions
>

With some adult supervision from James (thanks!), I have given this a
spin myself with kexec under QEMU/kvm, to boot a crashkernel, and
everything works as expected.


>  arch/arm64/include/asm/acpi.h | 15 +---
>  arch/arm64/kernel/acpi.c      | 75 ++++++++++++++++++++
>  2 files changed, 76 insertions(+), 14 deletions(-)
>
> --
> 2.27.0
>
