Return-Path: <SRS0=R6KW=WX=lists.openwall.com=kernel-hardening-return-16805-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B9FC3A5A4
	for <kernel-hardening@archiver.kernel.org>; Tue, 27 Aug 2019 01:34:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BE8FB20850
	for <kernel-hardening@archiver.kernel.org>; Tue, 27 Aug 2019 01:34:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE8FB20850
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16805-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30210 invoked by uid 550); 27 Aug 2019 01:34:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30173 invoked from network); 27 Aug 2019 01:34:06 -0000
From: Michael Ellerman <mpe@ellerman.id.au>
To: Scott Wood <oss@buserror.net>
Cc: linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com, yebin10@huawei.com, thunder.leizhen@huawei.com, jingxiangfeng@huawei.com, fanchengyang@huawei.com, zhaohongjiang@huawei.com, Jason Yan <yanaijie@huawei.com>, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com, keescook@chromium.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v6 00/12] implement KASLR for powerpc/fsl_booke/32
In-Reply-To: <529fd908-42d6-f96f-daa2-9010f3035879@huawei.com>
References: <20190809100800.5426-1-yanaijie@huawei.com> <ed96199d-715c-3f1c-39db-10a569ba6601@huawei.com> <529fd908-42d6-f96f-daa2-9010f3035879@huawei.com>
Date: Tue, 27 Aug 2019 11:33:51 +1000
Message-ID: <878srf4cjk.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Jason Yan <yanaijie@huawei.com> writes:
> A polite ping :)
>
> What else should I do now?

That's a good question.

Scott, are you still maintaining FSL bits, and if so any comments? Or
should I take this.

cheers

> On 2019/8/19 14:12, Jason Yan wrote:
>> Hi Michael,
>>=20
>> Is there anything more I should do to get this feature meeting the=20
>> requirements of the mainline?
>>=20
>> Thanks,
>> Jason
>>=20
>> On 2019/8/9 18:07, Jason Yan wrote:
>>> This series implements KASLR for powerpc/fsl_booke/32, as a security
>>> feature that deters exploit attempts relying on knowledge of the locati=
on
>>> of kernel internals.
>>>
>>> Since CONFIG_RELOCATABLE has already supported, what we need to do is
>>> map or copy kernel to a proper place and relocate. Freescale Book-E
>>> parts expect lowmem to be mapped by fixed TLB entries(TLB1). The TLB1
>>> entries are not suitable to map the kernel directly in a randomized
>>> region, so we chose to copy the kernel to a proper place and restart to
>>> relocate.
>>>
>>> Entropy is derived from the banner and timer base, which will change=20
>>> every
>>> build and boot. This not so much safe so additionally the bootloader may
>>> pass entropy via the /chosen/kaslr-seed node in device tree.
>>>
>>> We will use the first 512M of the low memory to randomize the kernel
>>> image. The memory will be split in 64M zones. We will use the lower 8
>>> bit of the entropy to decide the index of the 64M zone. Then we chose a
>>> 16K aligned offset inside the 64M zone to put the kernel in.
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0 KERNELBASE
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |-->=C2=A0=C2=A0 64M=
=C2=A0=C2=A0 <--|
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 +---------------+=C2=
=A0=C2=A0=C2=A0 +----------------+---------------+
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |....|=C2=
=A0=C2=A0=C2=A0 |kernel|=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 +---------------+=C2=
=A0=C2=A0=C2=A0 +----------------+---------------+
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |----->=C2=A0=C2=A0 of=
fset=C2=A0=C2=A0=C2=A0 <-----|
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kernstart_virt_addr
>>>
>>> We also check if we will overlap with some areas like the dtb area, the
>>> initrd area or the crashkernel area. If we cannot find a proper area,
>>> kaslr will be disabled and boot from the original kernel.
>>>
>>> Changes since v5:
>>> =C2=A0 - Rename M_IF_NEEDED to MAS2_M_IF_NEEDED
>>> =C2=A0 - Define some global variable as __ro_after_init
>>> =C2=A0 - Replace kimage_vaddr with kernstart_virt_addr
>>> =C2=A0 - Depend on RELOCATABLE, not select it
>>> =C2=A0 - Modify the comment block below the SPDX tag
>>> =C2=A0 - Remove some useless headers in kaslr_booke.c and move is_secon=
d_reloc
>>> =C2=A0=C2=A0=C2=A0 declarationto mmu_decl.h
>>> =C2=A0 - Remove DBG() and use pr_debug() and rewrite comment above=20
>>> get_boot_seed().
>>> =C2=A0 - Add a patch to document the KASLR implementation.
>>> =C2=A0 - Split a patch from patch #10 which exports kaslr offset in=20
>>> VMCOREINFO ELF notes.
>>> =C2=A0 - Remove extra logic around finding nokaslr string in cmdline.
>>> =C2=A0 - Make regions static global and __initdata
>>>
>>> Changes since v4:
>>> =C2=A0 - Add Reviewed-by tag from Christophe
>>> =C2=A0 - Remove an unnecessary cast
>>> =C2=A0 - Remove unnecessary parenthesis
>>> =C2=A0 - Fix checkpatch warning
>>>
>>> Changes since v3:
>>> =C2=A0 - Add Reviewed-by and Tested-by tag from Diana
>>> =C2=A0 - Change the comment in fsl_booke_entry_mapping.S to be consiste=
nt
>>> =C2=A0=C2=A0=C2=A0 with the new code.
>>>
>>> Changes since v2:
>>> =C2=A0 - Remove unnecessary #ifdef
>>> =C2=A0 - Use SZ_64M instead of0x4000000
>>> =C2=A0 - Call early_init_dt_scan_chosen() to init boot_command_line
>>> =C2=A0 - Rename kaslr_second_init() to kaslr_late_init()
>>>
>>> Changes since v1:
>>> =C2=A0 - Remove some useless 'extern' keyword.
>>> =C2=A0 - Replace EXPORT_SYMBOL with EXPORT_SYMBOL_GPL
>>> =C2=A0 - Improve some assembly code
>>> =C2=A0 - Use memzero_explicit instead of memset
>>> =C2=A0 - Use boot_command_line and remove early_command_line
>>> =C2=A0 - Do not print kaslr offset if kaslr is disabled
>>>
>>> Jason Yan (12):
>>> =C2=A0=C2=A0 powerpc: unify definition of M_IF_NEEDED
>>> =C2=A0=C2=A0 powerpc: move memstart_addr and kernstart_addr to init-com=
mon.c
>>> =C2=A0=C2=A0 powerpc: introduce kernstart_virt_addr to store the kernel=
 base
>>> =C2=A0=C2=A0 powerpc/fsl_booke/32: introduce create_tlb_entry() helper
>>> =C2=A0=C2=A0 powerpc/fsl_booke/32: introduce reloc_kernel_entry() helper
>>> =C2=A0=C2=A0 powerpc/fsl_booke/32: implement KASLR infrastructure
>>> =C2=A0=C2=A0 powerpc/fsl_booke/32: randomize the kernel image offset
>>> =C2=A0=C2=A0 powerpc/fsl_booke/kaslr: clear the original kernel if rand=
omized
>>> =C2=A0=C2=A0 powerpc/fsl_booke/kaslr: support nokaslr cmdline parameter
>>> =C2=A0=C2=A0 powerpc/fsl_booke/kaslr: dump out kernel offset informatio=
n on panic
>>> =C2=A0=C2=A0 powerpc/fsl_booke/kaslr: export offset in VMCOREINFO ELF n=
otes
>>> =C2=A0=C2=A0 powerpc/fsl_booke/32: Document KASLR implementation
>>>
>>> =C2=A0 Documentation/powerpc/kaslr-booke32.rst=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 42 ++
>>> =C2=A0 arch/powerpc/Kconfig=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 11 +
>>> =C2=A0 arch/powerpc/include/asm/nohash/mmu-book3e.h=C2=A0 |=C2=A0 10 +
>>> =C2=A0 arch/powerpc/include/asm/page.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 7 +
>>> =C2=A0 arch/powerpc/kernel/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
=C2=A0 1 +
>>> =C2=A0 arch/powerpc/kernel/early_32.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +-
>>> =C2=A0 arch/powerpc/kernel/exceptions-64e.S=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 12 +-
>>> =C2=A0 arch/powerpc/kernel/fsl_booke_entry_mapping.S |=C2=A0 27 +-
>>> =C2=A0 arch/powerpc/kernel/head_fsl_booke.S=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 55 ++-
>>> =C2=A0 arch/powerpc/kernel/kaslr_booke.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 393 ++++++++++++++++++
>>> =C2=A0 arch/powerpc/kernel/machine_kexec.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 1 +
>>> =C2=A0 arch/powerpc/kernel/misc_64.S=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=
=A0 7 +-
>>> =C2=A0 arch/powerpc/kernel/setup-common.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 20 +
>>> =C2=A0 arch/powerpc/mm/init-common.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=
=A0 7 +
>>> =C2=A0 arch/powerpc/mm/init_32.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0=C2=A0 5 -
>>> =C2=A0 arch/powerpc/mm/init_64.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0=C2=A0 5 -
>>> =C2=A0 arch/powerpc/mm/mmu_decl.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0 11 +
>>> =C2=A0 arch/powerpc/mm/nohash/fsl_booke.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 8 +-
>>> =C2=A0 18 files changed, 572 insertions(+), 52 deletions(-)
>>> =C2=A0 create mode 100644 Documentation/powerpc/kaslr-booke32.rst
>>> =C2=A0 create mode 100644 arch/powerpc/kernel/kaslr_booke.c
>>>
