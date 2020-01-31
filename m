Return-Path: <SRS0=M4EA=3U=lists.openwall.com=kernel-hardening-return-17642-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93281C33CB2
	for <kernel-hardening@archiver.kernel.org>; Fri, 31 Jan 2020 05:32:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E31F12067C
	for <kernel-hardening@archiver.kernel.org>; Fri, 31 Jan 2020 05:32:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="BDqsewvd";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rTtUs3Ob"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E31F12067C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17642-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1215 invoked by uid 550); 31 Jan 2020 05:32:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1172 invoked from network); 31 Jan 2020 05:32:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=fm1; bh=FNsMuvFx+h50FnF2XeP6GajNtS
	bj8MaRYeBlypo3DRc=; b=BDqsewvdGEQjWuHV8mzH5TLYSNwBsU5wQZNIF55t20
	eizgVcWCfS6ZREdmZvL5OzlXlRU6DhQ+PS4wuHnD7HOEG1kke4/yXrhPHCGbo2Wi
	bgSyC7v9wt3ngUhIrdy5r7GO4NJhDY8zpR+KuPfGVwV3rwyFpKEJHcbXmBgAb13H
	DSvTxGRMZM4A6GTB3hzpMqCdXZdyxWMJBAIUDEQgUWeL+rbjjV4Sa0DGGWVkzNns
	ApLJ3nivgbQi1UfQYXbfwycw0s43h3ZLXr/8nQK1T/NnXksxBneP1GAZM+P8N6T0
	TSVyfvId7seYVlNvpHZ/yCnhwcnucQHwlfhyk/J7PITg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=FNsMuvFx+h50FnF2X
	eP6GajNtSbj8MaRYeBlypo3DRc=; b=rTtUs3ObF0+87lIGId0MO4IRwfADjf3I3
	UOCQscH3/QbElEk9xfGM63M+KzsbPufhddxlmc4LiVv/mEvhpnkaE+7pFo94bVV5
	shsC9zWci4CPGa9onBPb/6hH0Cfgjngr6R7qR+qwvefv7aFIH76/z+/1AKDRGDK2
	hhqcqn6xuAGFsEZo3tuBBDy05OXKQGrVwQB+rstYagFTPf07+Ls81FEJxb6VP/fG
	K+BL4WHuTs7NqeZ2h9Z+ISOMh40C7FTrZcoPewGHQfpz+BYQQkM+5SoaPTn0qTtR
	90+7s/lCmjwVZYujLPtBepUpesUHwXEr4J62LiBCAFsv/3Ivonq5Q==
X-ME-Sender: <xms:27szXpsXtzx3YE7atDRuw5dA6yIHbbjeDf_74YenHZ3EPs8Mj7orWw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrfeelgdektdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephffvuf
    ffkffoggfgsedtkeertdertddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicu
    oehruhhstghurhesrhhushhsvghllhdrtggtqeenucfkphepuddvvddrleelrdekvddrud
    dtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprhhu
    shgtuhhrsehruhhsshgvlhhlrdgttg
X-ME-Proxy: <xmx:27szXvKauJN9NXVyPI9V0P6Ouzjt4wfN1ncDWZVm0R9rqffFq8R-tQ>
    <xmx:27szXgpI1e2YzyiyKCIupHVAsFN2s1LLwBunZj0m_bBXB3odv7lbKQ>
    <xmx:27szXqWbhpUC5fgMiI8xftmAbSYpF44FsYnaTvmFDcrKrfMGwS7HqQ>
    <xmx:3bszXn9V55gm-ya5jnLZ8lEQG9ThZWMUBSk-sscociwfQ5W9OPTtuQ>
From: Russell Currey <ruscur@russell.cc>
To: keescook@chromium.org
Cc: linux-kernel@vger.kernel.org,
	dja@axtens.net,
	mpe@ellerman.id.au,
	kernel-hardening@lists.openwall.com,
	linuxppc-dev@lists.ozlabs.org,
	christophe.leroy@c-s.fr,
	Russell Currey <ruscur@russell.cc>
Subject: [PATCH] lkdtm: Test KUAP directional user access unlocks on powerpc
Date: Fri, 31 Jan 2020 16:31:57 +1100
Message-Id: <20200131053157.22463-1-ruscur@russell.cc>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Kernel Userspace Access Prevention (KUAP) on powerpc supports
allowing only one access direction (Read or Write) when allowing access
to or from user memory.

A bug was recently found that showed that these one-way unlocks never
worked, and allowing Read *or* Write would actually unlock Read *and*
Write.  We should have a test case for this so we can make sure this
doesn't happen again.

Like ACCESS_USERSPACE, the correct result is for the test to fault.

At the time of writing this, the upstream kernel still has this bug
present, so the test will allow both accesses whereas ACCESS_USERSPACE
will correctly fault.

Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 drivers/misc/lkdtm/core.c  |  3 +++
 drivers/misc/lkdtm/lkdtm.h |  3 +++
 drivers/misc/lkdtm/perms.c | 43 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index ee0d6e721441..baef3c6f48d6 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -137,6 +137,9 @@ static const struct crashtype crashtypes[] = {
 	CRASHTYPE(EXEC_USERSPACE),
 	CRASHTYPE(EXEC_NULL),
 	CRASHTYPE(ACCESS_USERSPACE),
+#ifdef CONFIG_PPC_KUAP
+	CRASHTYPE(ACCESS_USERSPACE_KUAP),
+#endif
 	CRASHTYPE(ACCESS_NULL),
 	CRASHTYPE(WRITE_RO),
 	CRASHTYPE(WRITE_RO_AFTER_INIT),
diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
index c56d23e37643..406a3fb32e6f 100644
--- a/drivers/misc/lkdtm/lkdtm.h
+++ b/drivers/misc/lkdtm/lkdtm.h
@@ -57,6 +57,9 @@ void lkdtm_EXEC_RODATA(void);
 void lkdtm_EXEC_USERSPACE(void);
 void lkdtm_EXEC_NULL(void);
 void lkdtm_ACCESS_USERSPACE(void);
+#ifdef CONFIG_PPC_KUAP
+void lkdtm_ACCESS_USERSPACE_KUAP(void);
+#endif
 void lkdtm_ACCESS_NULL(void);
 
 /* lkdtm_refcount.c */
diff --git a/drivers/misc/lkdtm/perms.c b/drivers/misc/lkdtm/perms.c
index 62f76d506f04..2c9aa0114333 100644
--- a/drivers/misc/lkdtm/perms.c
+++ b/drivers/misc/lkdtm/perms.c
@@ -10,6 +10,9 @@
 #include <linux/mman.h>
 #include <linux/uaccess.h>
 #include <asm/cacheflush.h>
+#ifdef CONFIG_PPC_KUAP
+#include <asm/uaccess.h>
+#endif
 
 /* Whether or not to fill the target memory area with do_nothing(). */
 #define CODE_WRITE	true
@@ -200,6 +203,46 @@ void lkdtm_ACCESS_USERSPACE(void)
 	vm_munmap(user_addr, PAGE_SIZE);
 }
 
+/* Test that KUAP's directional user access unlocks work as intended */
+#ifdef CONFIG_PPC_KUAP
+void lkdtm_ACCESS_USERSPACE_KUAP(void)
+{
+	unsigned long user_addr, tmp = 0;
+	unsigned long *ptr;
+
+	user_addr = vm_mmap(NULL, 0, PAGE_SIZE,
+			    PROT_READ | PROT_WRITE | PROT_EXEC,
+			    MAP_ANONYMOUS | MAP_PRIVATE, 0);
+	if (user_addr >= TASK_SIZE) {
+		pr_warn("Failed to allocate user memory\n");
+		return;
+	}
+
+	if (copy_to_user((void __user *)user_addr, &tmp, sizeof(tmp))) {
+		pr_warn("copy_to_user failed\n");
+		vm_munmap(user_addr, PAGE_SIZE);
+		return;
+	}
+
+	ptr = (unsigned long *)user_addr;
+
+	/* Allowing "write to" should not allow "read from" */
+	allow_write_to_user(ptr, sizeof(unsigned long));
+	pr_info("attempting bad read at %px with write allowed\n", ptr);
+	tmp = *ptr;
+	tmp += 0xc0dec0de;
+	prevent_write_to_user(ptr, sizeof(unsigned long));
+
+	/* Allowing "read from" should not allow "write to" */
+	allow_read_from_user(ptr, sizeof(unsigned long));
+	pr_info("attempting bad write at %px with read allowed\n", ptr);
+	*ptr = tmp;
+	prevent_read_from_user(ptr, sizeof(unsigned long));
+
+	vm_munmap(user_addr, PAGE_SIZE);
+}
+#endif
+
 void lkdtm_ACCESS_NULL(void)
 {
 	unsigned long tmp;
-- 
2.25.0

