Return-Path: <SRS0=lWoj=57=lists.openwall.com=kernel-hardening-return-18502-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB45BC2BA19
	for <kernel-hardening@archiver.kernel.org>; Wed, 15 Apr 2020 19:34:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1040F2076D
	for <kernel-hardening@archiver.kernel.org>; Wed, 15 Apr 2020 19:34:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1040F2076D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=buserror.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18502-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7225 invoked by uid 550); 15 Apr 2020 19:34:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7193 invoked from network); 15 Apr 2020 19:34:15 -0000
Message-ID: <f91c90fde203ed87dcf206e795ee55ed67b5f641.camel@buserror.net>
From: Scott Wood <oss@buserror.net>
To: Jason Yan <yanaijie@huawei.com>, mpe@ellerman.id.au, 
 linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com,
 christophe.leroy@c-s.fr,  benh@kernel.crashing.org, paulus@samba.org,
 npiggin@gmail.com,  keescook@chromium.org,
 kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com, dja@axtens.net
Date: Wed, 15 Apr 2020 14:31:38 -0500
In-Reply-To: <20200330022023.3691-1-yanaijie@huawei.com>
References: <20200330022023.3691-1-yanaijie@huawei.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2601:449:8480:af0:12bf:48ff:fe84:c9a0
X-SA-Exim-Rcpt-To: yanaijie@huawei.com, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com, dja@axtens.net
X-SA-Exim-Mail-From: oss@buserror.net
Subject: Re: [PATCH v5 0/6] implement KASLR for powerpc/fsl_booke/64
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on baldur.buserror.net)

On Mon, 2020-03-30 at 10:20 +0800, Jason Yan wrote:
> This is a try to implement KASLR for Freescale BookE64 which is based on
> my earlier implementation for Freescale BookE32:
> 
https://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=131718&state=*
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
> v4->v5:
>   Fix "-Werror=maybe-uninitialized" compile error.
>   Fix typo "similar as" -> "similar to".
> v3->v4:
>   Do not define __kaslr_offset as a fixed symbol. Reference __run_at_load
> and
>     __kaslr_offset by symbol instead of magic offsets.
>   Use IS_ENABLED(CONFIG_PPC32) instead of #ifdef CONFIG_PPC32.
>   Change kaslr-booke32 to kaslr-booke in index.rst
>   Switch some instructions to 64-bit.
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
>  Documentation/powerpc/index.rst               |  2 +-
>  .../{kaslr-booke32.rst => kaslr-booke.rst}    | 35 ++++++-
>  arch/powerpc/Kconfig                          |  2 +-
>  arch/powerpc/kernel/exceptions-64e.S          | 23 +++++
>  arch/powerpc/kernel/head_64.S                 | 13 +++
>  arch/powerpc/kernel/setup_64.c                |  3 +
>  arch/powerpc/mm/mmu_decl.h                    | 23 +++--
>  arch/powerpc/mm/nohash/kaslr_booke.c          | 91 +++++++++++++------
>  8 files changed, 147 insertions(+), 45 deletions(-)
>  rename Documentation/powerpc/{kaslr-booke32.rst => kaslr-booke.rst} (59%)
> 

Acked-by: Scott Wood <oss@buserror.net>

-Scott


