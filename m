Return-Path: <SRS0=tQ/L=6F=lists.openwall.com=kernel-hardening-return-18597-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64018C54FCC
	for <kernel-hardening@archiver.kernel.org>; Tue, 21 Apr 2020 17:37:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B6750206D9
	for <kernel-hardening@archiver.kernel.org>; Tue, 21 Apr 2020 17:37:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b12RD4Q+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6750206D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18597-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11870 invoked by uid 550); 21 Apr 2020 17:37:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11835 invoked from network); 21 Apr 2020 17:37:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n8qVaalIidRR7pGSEV5tyf0PxDkGEOKDNCWi4IECU3E=;
        b=b12RD4Q+/eDpJ8K5uxx3pSY6Me2Hr6dzy4utDsv6A8bko7a9tF6XKrl99Wyd+r4v3o
         1FAauDl8St//AMNITUY9tZsFBfgz4ftqbQ5fB/3kktoonbKWQzk/vXiB1dcZbXwJvuLJ
         zbDi3tQ0Rc6Ux2LTauqIwmKTuwL3s74n3e448+IuMamMvRriWHwJe4zvddNeMa6JE8kc
         +xh4hvApNt+Ua8yeyeEQFSucdlfWVlGCQCBshWSoSJoywVwaM4kiy+MkepoFbfsD3GDU
         j4tyuKol3YM4UXG2E/dS1MwkuMKRwxjnLP/tDidFfAhnLOR/FQDb3VtUQ2OADDBJeJ5q
         LvFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n8qVaalIidRR7pGSEV5tyf0PxDkGEOKDNCWi4IECU3E=;
        b=i4x5mGcSCncF9EHvSrpqoKkK3bTdydVgm1sIZHFIUF/6196c4qNXQBhg/fbXe8FRrZ
         191g3Yt15FA47pymeuye2UveoQEmDg5WL/LQN4VWmU3WYvgjbKT3em2K7TMCnzMnbRAX
         3R1WysvllrYDlzRErdoGyk9QQ7XQzimd4rsTBv31Q8JVvOEtA35I9I4Z9zs4j4qpR5s0
         TyLrha1PwT0o37VEorm+YnPKh13CBuQnT5+vtyWrDxnsgB+yStN+qlOL0vFuan6W6Qsd
         /9cocb+LlHNuBjas5pi9xgOSXKXOTf0YJ2gOWw4mJFBioEQlbuFQJLzHvhlfL0C91fKL
         3Weg==
X-Gm-Message-State: AGi0PuZ1Eg7lucpavsvZ5Og4HAYbjwN2xm7QiMHucj86JH3nWw4gywNd
	0uyk3oiWGid+2JsDkGSkJVY=
X-Google-Smtp-Source: APiQypJtnl2nLcMt15nfPhna9D5nM3tB9NS63SlG2E8fT8j/LMpRKnWzfOwcDbTwgitenufmufCvGQ==
X-Received: by 2002:aa7:8593:: with SMTP id w19mr22839905pfn.97.1587490646870;
        Tue, 21 Apr 2020 10:37:26 -0700 (PDT)
From: Phong Tran <tranmanphong@gmail.com>
To: mark.rutland@arm.com,
	steve.capper@arm.com,
	steven.price@arm.com,
	will@kernel.org,
	keescook@chromium.org,
	greg@kroah.com
Cc: akpm@linux-foundation.org,
	alexios.zavras@intel.com,
	broonie@kernel.org,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	tglx@linutronix.de,
	Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH v2] arm64: add check_wx_pages debugfs for CHECK_WX
Date: Wed, 22 Apr 2020 00:35:58 +0700
Message-Id: <20200421173557.10817-1-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200307093926.27145-1-tranmanphong@gmail.com>
References: <20200307093926.27145-1-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

follow the suggestion from
https://github.com/KSPP/linux/issues/35

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
Change since v1:
- Update the Kconfig help text
- Don't check the return value of debugfs_create_file()
- Tested on QEMU aarch64
root@qemuarm64:~# zcat /proc/config.gz | grep PTDUMP
CONFIG_GENERIC_PTDUMP=y
CONFIG_PTDUMP_CORE=y
CONFIG_PTDUMP_DEBUGFS=y
root@qemuarm64:~# uname -a
Linux qemuarm64 5.7.0-rc2-00001-g20ddb383c313 #3 SMP PREEMPT Tue Apr 21 23:18:56 +07 2020 aarch64 GNU/Linux
root@qemuarm64:~# echo 1 > /sys/kernel/debug/check_wx_pages
[   63.261868] Checked W+X mappings: passed, no W+X pages found
---
 arch/arm64/Kconfig.debug        |  5 ++++-
 arch/arm64/include/asm/ptdump.h |  2 ++
 arch/arm64/mm/dump.c            |  1 +
 arch/arm64/mm/ptdump_debugfs.c  | 18 ++++++++++++++++++
 4 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index a1efa246c9ed..cd82c9d3664a 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -48,7 +48,10 @@ config DEBUG_WX
 	  of other unfixed kernel bugs easier.
 
 	  There is no runtime or memory usage effect of this option
-	  once the kernel has booted up - it's a one time check.
+	  once the kernel has booted up - it's a one time check at
+	  boot, and can also be triggered at runtime by echo "1" to
+	  "check_wx_pages". The "check_wx_pages" is available only with
+	  CONFIG_PTDUMP_DEBUGFS is enabled.
 
 	  If in doubt, say "Y".
 
diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
index 38187f74e089..c90a6ec6f59b 100644
--- a/arch/arm64/include/asm/ptdump.h
+++ b/arch/arm64/include/asm/ptdump.h
@@ -24,9 +24,11 @@ struct ptdump_info {
 void ptdump_walk(struct seq_file *s, struct ptdump_info *info);
 #ifdef CONFIG_PTDUMP_DEBUGFS
 void ptdump_debugfs_register(struct ptdump_info *info, const char *name);
+void ptdump_check_wx_init(void);
 #else
 static inline void ptdump_debugfs_register(struct ptdump_info *info,
 					   const char *name) { }
+static inline void ptdump_check_wx_init(void) { }
 #endif
 void ptdump_check_wx(void);
 #endif /* CONFIG_PTDUMP_CORE */
diff --git a/arch/arm64/mm/dump.c b/arch/arm64/mm/dump.c
index 860c00ec8bd3..60c99a047763 100644
--- a/arch/arm64/mm/dump.c
+++ b/arch/arm64/mm/dump.c
@@ -378,6 +378,7 @@ static int ptdump_init(void)
 #endif
 	ptdump_initialize();
 	ptdump_debugfs_register(&kernel_ptdump_info, "kernel_page_tables");
+	ptdump_check_wx_init();
 	return 0;
 }
 device_initcall(ptdump_init);
diff --git a/arch/arm64/mm/ptdump_debugfs.c b/arch/arm64/mm/ptdump_debugfs.c
index d29d722ec3ec..6b0aa16cb17b 100644
--- a/arch/arm64/mm/ptdump_debugfs.c
+++ b/arch/arm64/mm/ptdump_debugfs.c
@@ -20,3 +20,21 @@ void ptdump_debugfs_register(struct ptdump_info *info, const char *name)
 {
 	debugfs_create_file(name, 0400, NULL, info, &ptdump_fops);
 }
+
+static int check_wx_debugfs_set(void *data, u64 val)
+{
+	if (val != 1ULL)
+		return -EINVAL;
+
+	ptdump_check_wx();
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(check_wx_fops, NULL, check_wx_debugfs_set, "%llu\n");
+
+void ptdump_check_wx_init(void)
+{
+	debugfs_create_file("check_wx_pages", 0200, NULL,
+			NULL, &check_wx_fops) ? 0 : -ENOMEM;
+}
-- 
2.20.1

