Return-Path: <SRS0=CfbP=5S=lists.openwall.com=kernel-hardening-return-18376-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D330FC43331
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 12:33:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2F4D320784
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 12:33:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="MeRx5SuW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="wtJ1zAtw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F4D320784
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18376-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10010 invoked by uid 550); 2 Apr 2020 12:32:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9839 invoked from network); 2 Apr 2020 12:32:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=IC4CZ7cDsvwu4
	MjDM02EbvbW7U/Owbfd2UpIOwKIbS4=; b=MeRx5SuWXz8VDDeZHg8J4VOJ7dGek
	cW8YzXWbMGDpmEbtiqNzAp0IdvzT9wRnzKTTj9i7eYRUlShtElxmB3YdM7udBF0n
	wjfwvUZKB58+Mk6NbGGvkVgPljU5PxQ5kZ1BQdgayKd17vPw0QKK8rRQ4FqY8Jmj
	TUjFj7HW5RbW2x4pGG9i2V/JZBFtRZVDxbz6ePWiHfXXN9Fegy/xaBvXaf+SdWGH
	22ML/IFGdTN3YCG9sAFAQRQVlcFOqhDRONG5or78d09L3G/U5XewP/ehRKR5255w
	4RdLLgEIMR+zviYCHZatvKAz54Gfol9Ts0ks/PXOVT+C8jZzrqBkwNmdw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=IC4CZ7cDsvwu4MjDM02EbvbW7U/Owbfd2UpIOwKIbS4=; b=wtJ1zAtw
	MHKk4EzNdyTS0TY5WM38vp+p3FK6qKBaMFt7tVE8HrzLD8aNGH2pI9bb9lyg20oc
	QfXGqmo8epEgA+NBzY0M3arECjvgtwxq6UKwaDhYvMskfL8rT9PNLiczCXIehF5Z
	qwvXVFimLBc7ZjHSZ3ObbFsqcbSw9ENMs33EguQl3r9B+pVg46+gEQJS//f3+H31
	f6q9XYk7XvA3lPEJIpTcA6JXTFyKg4JqZCh4CIqutJNmztzM1hRVwHMlQ/RHcQ16
	GbRgF1XgYA2DS7nFv/WQJGBNZ8I/AqyEN4HTNSRVrnUTQh0WQhhpOT+LVnyi6B5l
	I1zrGNMv4EvrMQ==
X-ME-Sender: <xms:OqWFXjGWDdeqqZXOVXuFA6GZ8kLva8ab2vq_I3KN8g_hVwBADMsjjw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdeggddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculddutddmnecujfgurhephffvufffkffojghfggfgsedtkeertdertddt
    necuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicuoehruhhstghurhesrhhushhsvg
    hllhdrtggtqeenucfkphepuddvuddrgeehrddvuddvrddvfeelnecuvehluhhsthgvrhfu
    ihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomheprhhushgtuhhrsehruhhsshgvlh
    hlrdgttg
X-ME-Proxy: <xmx:OqWFXgxx99e7G7lKKoUf3tugstNTBXVg13Odcj01DlQ6IgYZAHycpA>
    <xmx:OqWFXmmAXo8mpNSuMAIa2xL6n9GhuTI4-iAZsn0MvO1hrxxY6N6s_g>
    <xmx:OqWFXhEqEo7YIuAjjR-ruDLCSgJTxdbLRcpNtDgWqqoNB7L7bbbB7A>
    <xmx:OqWFXsm7vag6S4B2lPK6yfyCub4VJOtDIX_81kbT1d9K3_lt9uGPGQ>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: Christophe Leroy <christophe.leroy@c-s.fr>,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com,
	kbuild test robot <lkp@intel.com>,
	Russell Currey <ruscur@russell.cc>
Subject: [PATCH v8 6/7] powerpc/mm: implement set_memory_attr()
Date: Thu,  2 Apr 2020 19:40:51 +1100
Message-Id: <20200402084053.188537-6-ruscur@russell.cc>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200402084053.188537-1-ruscur@russell.cc>
References: <20200402084053.188537-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christophe Leroy <christophe.leroy@c-s.fr>

In addition to the set_memory_xx() functions which allows to change
the memory attributes of not (yet) used memory regions, implement a
set_memory_attr() function to:
- set the final memory protection after init on currently used
kernel regions.
- enable/disable kernel memory regions in the scope of DEBUG_PAGEALLOC.

Unlike the set_memory_xx() which can act in three step as the regions
are unused, this function must modify 'on the fly' as the kernel is
executing from them. At the moment only PPC32 will use it and changing
page attributes on the fly is not an issue.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Reported-by: kbuild test robot <lkp@intel.com>
[ruscur: cast "data" to unsigned long instead of int]
Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/include/asm/set_memory.h |  2 ++
 arch/powerpc/mm/pageattr.c            | 33 +++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/arch/powerpc/include/asm/set_memory.h b/arch/powerpc/include/asm/set_memory.h
index 64011ea444b4..b040094f7920 100644
--- a/arch/powerpc/include/asm/set_memory.h
+++ b/arch/powerpc/include/asm/set_memory.h
@@ -29,4 +29,6 @@ static inline int set_memory_x(unsigned long addr, int numpages)
 	return change_memory_attr(addr, numpages, SET_MEMORY_X);
 }
 
+int set_memory_attr(unsigned long addr, int numpages, pgprot_t prot);
+
 #endif
diff --git a/arch/powerpc/mm/pageattr.c b/arch/powerpc/mm/pageattr.c
index 2da3fbab6ff7..2fde1b195c85 100644
--- a/arch/powerpc/mm/pageattr.c
+++ b/arch/powerpc/mm/pageattr.c
@@ -79,3 +79,36 @@ int change_memory_attr(unsigned long addr, int numpages, long action)
 	return apply_to_existing_page_range(&init_mm, start, sz,
 					    change_page_attr, (void *)action);
 }
+
+/*
+ * Set the attributes of a page:
+ *
+ * This function is used by PPC32 at the end of init to set final kernel memory
+ * protection. It includes changing the maping of the page it is executing from
+ * and data pages it is using.
+ */
+static int set_page_attr(pte_t *ptep, unsigned long addr, void *data)
+{
+	pgprot_t prot = __pgprot((unsigned long)data);
+
+	spin_lock(&init_mm.page_table_lock);
+
+	set_pte_at(&init_mm, addr, ptep, pte_modify(*ptep, prot));
+	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
+
+	spin_unlock(&init_mm.page_table_lock);
+
+	return 0;
+}
+
+int set_memory_attr(unsigned long addr, int numpages, pgprot_t prot)
+{
+	unsigned long start = ALIGN_DOWN(addr, PAGE_SIZE);
+	unsigned long sz = numpages * PAGE_SIZE;
+
+	if (numpages <= 0)
+		return 0;
+
+	return apply_to_existing_page_range(&init_mm, start, sz, set_page_attr,
+					    (void *)pgprot_val(prot));
+}
-- 
2.26.0

