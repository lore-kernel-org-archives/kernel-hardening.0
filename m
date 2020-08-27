Return-Path: <SRS0=JNrq=CF=lists.openwall.com=kernel-hardening-return-19675-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB25C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 05:25:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 600D520786
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 05:25:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 600D520786
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codefail.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19675-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9401 invoked by uid 550); 27 Aug 2020 05:24:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8156 invoked from network); 27 Aug 2020 05:24:44 -0000
From: "Christopher M. Riedl" <cmr@codefail.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: kernel-hardening@lists.openwall.com
Subject: [PATCH v3 1/6] powerpc: Add LKDTM accessor for patching addr
Date: Thu, 27 Aug 2020 00:26:54 -0500
Message-Id: <20200827052659.24922-2-cmr@codefail.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200827052659.24922-1-cmr@codefail.de>
References: <20200827052659.24922-1-cmr@codefail.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
X-Originating-IP: 198.54.122.47
X-SpamExperts-Domain: o3.privateemail.com
X-SpamExperts-Username: out-03
Authentication-Results: registrar-servers.com; auth=pass (plain) smtp.auth=out-03@o3.privateemail.com
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: Combined (0.02)
X-Recommended-Action: accept
X-Filter-ID: Mvzo4OR0dZXEDF/gcnlw0fJi3Ojdyt5h9PLOIGvr3lipSDasLI4SayDByyq9LIhVRtFk8wMgP0ig
 M48okS0WxUTNWdUk1Ol2OGx3IfrIJKyP9eGNFz9TW9u+Jt8z2T3Kq02yUY2BU41HLqp9U+7si8M8
 LdvJpZ7k99Lvu8YZXeI6p5bbhGYzvfahQ7X4A9L0Ye/JicEYVQv1wTfnWwJUGLoHT+TiZ2cHCmVO
 a6Hj9ogla7ZdP44ErCUYDeNW3waCJODXbtOodkPED+RkHjVGH2xZ/WG2ZLv5RT/cF5Q6687AHRjU
 JmjnvGEokRBTZJpViFKfD1jKgYfH+6S5qDVYoB9IP+wAx5V73ybNly/cw9Dbhw3Crbac1ieeuRax
 ITFpzO11BRKqT8B4uLrn7iz8uvLBMzbIQcSG8L0jOzL80Q1MxDcqDeEvahfPkDkTlH91LgaQnmF8
 H6pa6B8MTK1ligAJ9G0GMvMSOAhk0taEj8weJNI+C0vMCMVtmGEXbiaC3YEY+sq0ALsWxTj0qWKj
 35ixdMKk3BBfka4DffHpBWqkz6wxIGi04aIm8At0f8rObIE4IPBEuGByelw7CsYrZplKOaZVvWPN
 YKOkeGHVaNmpda9O3Jm3n4TasdFPGI49Ap/fepC1NisM+LESvgPZp60jiD6XqsJZtjQxlyCdsezj
 agBN88lVV9DZyVHyu83kFRA3eAVqquD0SMTqBT7kVdbWKEjcOn5Sao0omnAkSP01t5GaqW/eByjC
 /a4JzYI0tTHX0DLUbl+m5hodVFL8tfzmJxmVEJ3Gt5OBM/oetP/F4zH/akUxwpSQe0Z72IpD5v0x
 upj3x9Ek7RafJauJpU8IL9xGC9Aq1yswy54RHHfHitWALqOUbaMN01UqsrL68FmGdBjTJq9+UaM6
 AyHQsys5mw8UZwIbwaQoUagpNuN48vZO5vqyKRzY1/C3LtRhfqb5R4VemuUI6bcEARsm0AHffUwf
 1Fe8+QQDoh1JX3JL6YEhoUUiZ+gDjRJBlVjGFjOk+oYG9HSSzX8ii5KOS3syFMyRibh35fUGz9A0
 wQ0EsJrzPSLMV4ckOwy/RJQMQij2rNMC/ijhnA2ohL4kJucUv81X66s2aS76WMD99KzHKlSFZnsN
 X9C2FSfjBOMW
X-Report-Abuse-To: spam@se5.registrar-servers.com

When live patching a STRICT_RWX kernel, a mapping is installed at a
"patching address" with temporary write permissions. Provide a
LKDTM-only accessor function for this address in preparation for a LKDTM
test which attempts to "hijack" this mapping by writing to it from
another CPU.

Signed-off-by: Christopher M. Riedl <cmr@codefail.de>
---
 arch/powerpc/include/asm/code-patching.h | 4 ++++
 arch/powerpc/lib/code-patching.c         | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/powerpc/include/asm/code-patching.h b/arch/powerpc/include/asm/code-patching.h
index eacc9102c251..7216d6a6bb0a 100644
--- a/arch/powerpc/include/asm/code-patching.h
+++ b/arch/powerpc/include/asm/code-patching.h
@@ -187,4 +187,8 @@ static inline unsigned long ppc_kallsyms_lookup_name(const char *name)
 				 ___PPC_RA(__REG_R1) | PPC_LR_STKOFF)
 #endif /* CONFIG_PPC64 */
 
+#if defined(CONFIG_LKDTM) && defined(CONFIG_STRICT_KERNEL_RWX)
+unsigned long read_cpu_patching_addr(unsigned int cpu);
+#endif
+
 #endif /* _ASM_POWERPC_CODE_PATCHING_H */
diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
index 8c3934ea6220..85d3fdca9452 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -46,6 +46,13 @@ int raw_patch_instruction(struct ppc_inst *addr, struct ppc_inst instr)
 #ifdef CONFIG_STRICT_KERNEL_RWX
 static DEFINE_PER_CPU(struct vm_struct *, text_poke_area);
 
+#ifdef CONFIG_LKDTM
+unsigned long read_cpu_patching_addr(unsigned int cpu)
+{
+	return (unsigned long)(per_cpu(text_poke_area, cpu))->addr;
+}
+#endif
+
 static int text_area_cpu_up(unsigned int cpu)
 {
 	struct vm_struct *area;
-- 
2.28.0

