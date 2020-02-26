Return-Path: <SRS0=GuZW=4O=lists.openwall.com=kernel-hardening-return-17953-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B25C5C4BA0A
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 07:16:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 10A5C21556
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 07:16:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="AdvfF+DV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10A5C21556
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=axtens.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17953-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15942 invoked by uid 550); 26 Feb 2020 07:16:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15901 invoked from network); 26 Feb 2020 07:16:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=bUll3MF+KOORxkWKae6CeWZqF5RK093f70VhPi5nTaA=;
        b=AdvfF+DViD2Iihe2gGoCejFW6L9CR4CRCuvhd702kHXMW9aLKiXKfmFyTpucUBXYvN
         cEZRvzdUlmSDzOLcdBFaPWO/Gqx8canJLTZTZUnf4NBrmhRAHnjLBh4VPtK3yWqwsia0
         ED/nVdqp1ZBaUikJEfLHTuQiqHyge9lN9SdrA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=bUll3MF+KOORxkWKae6CeWZqF5RK093f70VhPi5nTaA=;
        b=m3I/yS2cXdkXtYn+NIGuyobCaHozhkzyAFmNJWukXefxBrfRyp+5hIKKXF0aZgS2+n
         nH/LGKxUaexASNZ+Jx/jZF340skdcVkZ9nOTMQpMS8ZlC4fzpYxAHmgHd7w2YLTdRRxu
         7H8Md8yB0hpiTnY6UkaE52GrPk626k63fs97+8qazZvyRVmHinxp1ol+4+S7xwoI0vqV
         c1yd4xZ4cm+K3ZzmN9sOUIujEaOLwjIxXsY1HP+sdt8mJziKpifYPrr29IvPGhh5Yk6z
         8OHsNFMCxYWsIuP0DIdjaDuIBiZp2FpUvlSJVnfyk2t46l0H6KYgwbgeSGDtpuNTS90H
         MKgw==
X-Gm-Message-State: APjAAAWT6rmsWsYacWEMM8iUfeb2AeAFAGc2bp8L39mK6pKIQwttGcBS
	TKnvdDn0zjKr9Zivol7ce0ULfA==
X-Google-Smtp-Source: APXvYqyTVYEdw3GG568w+1dNFzY9ZMbswpQ8Fc19s42h9JN/v4uscW8ujuBJbXp4NXq4DVrPra5Yow==
X-Received: by 2002:a17:902:bf49:: with SMTP id u9mr2644385pls.199.1582701390378;
        Tue, 25 Feb 2020 23:16:30 -0800 (PST)
From: Daniel Axtens <dja@axtens.net>
To: Jason Yan <yanaijie@huawei.com>, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, oss@buserror.net
Cc: linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com, Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v3 0/6] implement KASLR for powerpc/fsl_booke/64
In-Reply-To: <20200206025825.22934-1-yanaijie@huawei.com>
References: <20200206025825.22934-1-yanaijie@huawei.com>
Date: Wed, 26 Feb 2020 18:16:26 +1100
Message-ID: <87tv3drf79.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain

Hi Jason,

> This is a try to implement KASLR for Freescale BookE64 which is based on
> my earlier implementation for Freescale BookE32:
> https://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=131718
>
> The implementation for Freescale BookE64 is similar as BookE32. One
> difference is that Freescale BookE64 set up a TLB mapping of 1G during
> booting. Another difference is that ppc64 needs the kernel to be
> 64K-aligned. So we can randomize the kernel in this 1G mapping and make
> it 64K-aligned. This can save some code to creat another TLB map at
> early boot. The disadvantage is that we only have about 1G/64K = 16384
> slots to put the kernel in.
>
>     KERNELBASE
>
>           64K                     |--> kernel <--|
>            |                      |              |
>         +--+--+--+    +--+--+--+--+--+--+--+--+--+    +--+--+
>         |  |  |  |....|  |  |  |  |  |  |  |  |  |....|  |  |
>         +--+--+--+    +--+--+--+--+--+--+--+--+--+    +--+--+
>         |                         |                        1G
>         |----->   offset    <-----|
>
>                               kernstart_virt_addr
>
> I'm not sure if the slot numbers is enough or the design has any
> defects. If you have some better ideas, I would be happy to hear that.
>
> Thank you all.
>

Are you making any attempt to hide kernel address leaks in this series?
I've just been looking at the stackdump code just now, and it directly
prints link registers and stack pointers, which is probably enough to
determine the kernel base address:

                  SPs:               LRs:             %pS pointer
[    0.424506] [c0000000de403970] [c000000001fc0458] dump_stack+0xfc/0x154 (unreliable)
[    0.424593] [c0000000de4039c0] [c000000000267eec] panic+0x258/0x5ac
[    0.424659] [c0000000de403a60] [c0000000024d7a00] mount_block_root+0x634/0x7c0
[    0.424734] [c0000000de403be0] [c0000000024d8100] prepare_namespace+0x1ec/0x23c
[    0.424811] [c0000000de403c60] [c0000000024d7010] kernel_init_freeable+0x804/0x880

git grep \\\"REG\\\" arch/powerpc shows a few other uses like this, all
in process.c or in xmon.

Maybe replacing the REG format string in KASLR mode would be sufficient?

Regards,
Daniel


> v2->v3:
>   Fix build error when KASLR is disabled.
> v1->v2:
>   Add __kaslr_offset for the secondary cpu boot up.
>
> Jason Yan (6):
>   powerpc/fsl_booke/kaslr: refactor kaslr_legal_offset() and
>     kaslr_early_init()
>   powerpc/fsl_booke/64: introduce reloc_kernel_entry() helper
>   powerpc/fsl_booke/64: implement KASLR for fsl_booke64
>   powerpc/fsl_booke/64: do not clear the BSS for the second pass
>   powerpc/fsl_booke/64: clear the original kernel if randomized
>   powerpc/fsl_booke/kaslr: rename kaslr-booke32.rst to kaslr-booke.rst
>     and add 64bit part
>
>  .../{kaslr-booke32.rst => kaslr-booke.rst}    | 35 +++++++--
>  arch/powerpc/Kconfig                          |  2 +-
>  arch/powerpc/kernel/exceptions-64e.S          | 23 ++++++
>  arch/powerpc/kernel/head_64.S                 | 14 ++++
>  arch/powerpc/kernel/setup_64.c                |  4 +-
>  arch/powerpc/mm/mmu_decl.h                    | 19 ++---
>  arch/powerpc/mm/nohash/kaslr_booke.c          | 71 +++++++++++++------
>  7 files changed, 132 insertions(+), 36 deletions(-)
>  rename Documentation/powerpc/{kaslr-booke32.rst => kaslr-booke.rst} (59%)
>
> -- 
> 2.17.2
