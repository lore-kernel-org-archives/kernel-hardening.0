Return-Path: <SRS0=TebB=CF=lists.openwall.com=kernel-hardening-return-19673-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 080C9C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 05:25:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2DA3D20786
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 05:25:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DA3D20786
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codefail.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19673-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 8186 invoked by uid 550); 27 Aug 2020 05:24:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8075 invoked from network); 27 Aug 2020 05:24:42 -0000
From: "Christopher M. Riedl" <cmr@codefail.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: kernel-hardening@lists.openwall.com
Subject: [PATCH v3 0/6] Use per-CPU temporary mappings for patching
Date: Thu, 27 Aug 2020 00:26:53 -0500
Message-Id: <20200827052659.24922-1-cmr@codefail.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
X-Originating-IP: 198.54.122.47
X-SpamExperts-Domain: o3.privateemail.com
X-SpamExperts-Username: out-03
Authentication-Results: registrar-servers.com; auth=pass (plain) smtp.auth=out-03@o3.privateemail.com
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: Combined (0.01)
X-Recommended-Action: accept
X-Filter-ID: Mvzo4OR0dZXEDF/gcnlw0fJi3Ojdyt5h9PLOIGvr3lipSDasLI4SayDByyq9LIhVBghYtpEuDn29
 fDjaafOyv0TNWdUk1Ol2OGx3IfrIJKyP9eGNFz9TW9u+Jt8z2T3Kq02yUY2BU41HLqp9U+7si8M8
 LdvJpZ7k99Lvu8YZXeI6p5bbhGYzvfahQ7X4A9L0Ye/JicEYVQv1wTfnWwJUGLoHT+TiZ2cHCmVO
 a6Hj9oiJnwMHUOtSt5IUSJa6HnS6JODXbtOodkPED+RkHjVGH2xZ/WG2ZLv5RT/cF5Q6687AHRjU
 JmjnvGEokRBTZJpViFKfD1jKgYfH+6S5qDVYoJU2GVfilQJSaX7ehrnJEB/bhw3Crbac1ieeuRax
 ITFpzO11BRKqT8B4uLrn7iz8uvLBMzbIQcSG8L0jOzL80Q1MxDcqDeEvahfPkDkTlH91LgaQnmF8
 H6pa6B8MTK1ligAJ9G0GMvMSOAhk0taEj8weJNI+C0vMCMVtmGEXbiaC3YEY+sq0ALsWxTj0qWKj
 35ixdMKk3BBfka4DffHpBWqkz6wxIGi04aIm8At0f8rObIE4IPBEuGByelw7CsYrZplKOaZVvWPN
 YKOkeGHVaNmpda9O3Jm3n4TasdFPGI49Ap/fepC1NisM+LESvgPZp60jiD6XqsJZtjQxlyCdsezj
 agBN88lVV9DZyVHyu83kFRA3eAVqquD0SMTqBT7kVWTnVC9cXCCs8iiOPvLvGxI1t5GaqW/eByjC
 /a4JzYI0tTHX0DLUbl+m5hodVFL8tfzmJxmVEJ3Gt5OBM/oetP/F4zH/akUxwpSQe0Z72IpD5v0x
 upj3x9Ek7RafJauJpU8IL9xGC9Aq1yswy54RHHeZI1J5rnsNXFl1Nrzse/fLYat3W1Qy2nqNI9ke
 0BM4ESs5mw8UZwIbwaQoUagpNuN48vZO5vqyKRzY1/C3LtRhfqb5R4VemuUI6bcEARsm0AHffUwf
 1Fe8+QQDoh1JX3JL6YEhoUUiZ+gDjRJBlVjGFjOk+oYG9HSSzX8ii5KOS3syFMyRibh35fUGz9A0
 wQ0EsJrzPSLMV4ckOwy/RJQMQij2rNMC/ijhnA2ohL4kJucUv81X66s2aS76WMD99KzHKlSFZnsN
 X9C2FSfjBOMW
X-Report-Abuse-To: spam@se5.registrar-servers.com

When compiled with CONFIG_STRICT_KERNEL_RWX, the kernel must create
temporary mappings when patching itself. These mappings temporarily
override the strict RWX text protections to permit a write. Currently,
powerpc allocates a per-CPU VM area for patching. Patching occurs as
follows:

	1. Map page of text to be patched to per-CPU VM area w/
	   PAGE_KERNEL protection
	2. Patch text
	3. Remove the temporary mapping

While the VM area is per-CPU, the mapping is actually inserted into the
kernel page tables. Presumably, this could allow another CPU to access
the normally write-protected text - either malicously or accidentally -
via this same mapping if the address of the VM area is known. Ideally,
the mapping should be kept local to the CPU doing the patching (or any
other sensitive operations requiring temporarily overriding memory
protections) [0].

x86 introduced "temporary mm" structs which allow the creation of
mappings local to a particular CPU [1]. This series intends to bring the
notion of a temporary mm to powerpc and harden powerpc by using such a
mapping for patching a kernel with strict RWX permissions.

The first, second, and third patches implement an LKDTM test
"proof-of-concept" which exploits the potential vulnerability (ie. the
mapping during patching is exposed in kernel page tables and accessible
by other CPUS). The LKDTM test is somewhat "rough" in that it uses a
brute-force approach - I am open to any suggestions and/or ideas to
improve this. Currently, the LKDTM test passes with this series on
POWER8 (hash) and POWER9 (radix, hash) and fails without this series
(ie. the temporary mapping for patching is exposed to CPUs other than
the patching CPU).

The test is also implemented on x86_64 where it passes with a current
tree and fails only when using a tree prior to the temporary mappings. I
have such a tree here which intentionally fails:
https://github.com/cmr-informatik/linux/tree/x86_64-non-percpu-lkdtm

The fourth patch introduces the temporary mm struct and API for powerpc
along with a new function to retrieve a current hw breakpoint.

The fifth patch uses the `poking_init` init hook added by the x86
patches to initialize a temporary mm and patching address. The patching
address is randomized between PAGE_SIZE and DEFAULT_MAP_WINDOW-PAGE_SIZE.
The upper limit is necessary due to how the hash MMU operates - by default
the space above DEFAULT_MAP_WINDOW is not available. For now, both hash
and radix randomize inside this range. The number of possible random
addresses is dependent on PAGE_SIZE and limited by DEFAULT_MAP_WINDOW.

Bits of entropy with 64K page size on BOOK3S_64:

	bits of entropy = log2(DEFAULT_MAP_WINDOW_USER64 / PAGE_SIZE)

	PAGE_SIZE=64K, DEFAULT_MAP_WINDOW_USER64=128TB
	bits of entropy = log2(128TB / 64K)
	bits of entropy = 31

Randomization occurs only once during initialization at boot.

The sixth patch replaces the VM area with the temporary mm in the
patching code. The page for patching has to be mapped PAGE_SHARED with
the hash MMU since hash prevents the kernel from accessing userspace
pages with PAGE_PRIVILEGED bit set. On the radix MMU the page is mapped
with PAGE_KERNEL which has the added benefit that we can skip KUAP. 

Tested on Blackbird (8-core POWER9) w/ Hash (`disable_radix`) and Radix
MMUs, QEMU (TCG) POWER8 and POWER9, POWER8 VM.

Tested LKDTM test (passing and failing situations) on QEMU x86_64.

v3:	* Rebase on linuxppc/next:
	  commit 9123e3a74ec7 ("Linux 5.9-rc1")
	* Move temporary mm implementation into code-patching.c where it
	  belongs
	* Implement LKDTM hijacker test on x86_64 (on IBM time oof)
	* Do not use address zero for the patching address in the
	  temporary mm (thanks @dja for pointing this out!)
	* Wrap the LKDTM test w/ CONFIG_SMP as suggested by Christophe
	  Leroy
	* Comments to clarify PTE pre-allocation and patching addr
	  selection

v2:	* Rebase on linuxppc/next:
	  commit 105fb38124a4 ("powerpc/8xx: Modify ptep_get()")
	* Always dirty pte when mapping patch
	* Use `ppc_inst_len` instead of `sizeof` on instructions
	* Declare LKDTM patching addr accessor in header where it
	  belongs	

v1:	* Rebase on linuxppc/next (4336b9337824)
	* Save and restore second hw watchpoint
	* Use new ppc_inst_* functions for patching check and in LKDTM
	  test

rfc-v2:	* Many fixes and improvements mostly based on extensive feedback and
          testing by Christophe Leroy (thanks!).
	* Make patching_mm and patching_addr static and mode '__ro_after_init'
	  to after the variable name (more common in other parts of the kernel)
	* Use 'asm/debug.h' header instead of 'asm/hw_breakpoint.h' to fix
	  PPC64e compile
	* Add comment explaining why we use BUG_ON() during the init call to
	  setup for patching later
	* Move ptep into patch_mapping to avoid walking page tables a second
	  time when unmapping the temporary mapping
	* Use KUAP under non-radix, also manually dirty the PTE for patch
	  mapping on non-BOOK3S_64 platforms
	* Properly return any error from __patch_instruction
	* Do not use 'memcmp' where a simple comparison is appropriate
	* Simplify expression for patch address by removing pointer maths
	* Add LKDTM test


[0]: https://github.com/linuxppc/issues/issues/224
[1]: https://lore.kernel.org/kernel-hardening/20190426232303.28381-1-nadav.amit@gmail.com/



Christopher M. Riedl (6):
  powerpc: Add LKDTM accessor for patching addr
  x86: Add LKDTM accessor for patching addr
  Add LKDTM test to hijack a patch mapping (powerpc,x86_64)
  powerpc: Introduce temporary mm
  powerpc: Initialize a temporary mm for code patching
  powerpc: Use a temporary mm for code patching

 arch/powerpc/include/asm/code-patching.h |   4 +
 arch/powerpc/include/asm/debug.h         |   1 +
 arch/powerpc/kernel/process.c            |   5 +
 arch/powerpc/lib/code-patching.c         | 239 +++++++++++++++--------
 arch/x86/include/asm/text-patching.h     |   4 +
 arch/x86/kernel/alternative.c            |   7 +
 drivers/misc/lkdtm/core.c                |   1 +
 drivers/misc/lkdtm/lkdtm.h               |   1 +
 drivers/misc/lkdtm/perms.c               | 146 ++++++++++++++
 9 files changed, 322 insertions(+), 86 deletions(-)

-- 
2.28.0

