Return-Path: <SRS0=gmfl=WY=lists.openwall.com=kernel-hardening-return-16808-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5CC8C3A5A1
	for <kernel-hardening@archiver.kernel.org>; Wed, 28 Aug 2019 03:43:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3A6572080F
	for <kernel-hardening@archiver.kernel.org>; Wed, 28 Aug 2019 03:43:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A6572080F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=informatik.wtf
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16808-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16047 invoked by uid 550); 28 Aug 2019 03:43:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15800 invoked from network); 28 Aug 2019 03:42:59 -0000
From: "Christopher M. Riedl" <cmr@informatik.wtf>
To: linuxppc-dev@ozlabs.org,
	kernel-hardening@lists.openwall.com
Cc: ajd@linux.ibm.com
Subject: [PATCH v5 1/2] powerpc/xmon: Allow listing and clearing breakpoints in read-only mode
Date: Tue, 27 Aug 2019 22:46:12 -0500
Message-Id: <20190828034613.14750-2-cmr@informatik.wtf>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190828034613.14750-1-cmr@informatik.wtf>
References: <20190828034613.14750-1-cmr@informatik.wtf>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP

Read-only mode should not prevent listing and clearing any active
breakpoints.

Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
---
 arch/powerpc/xmon/xmon.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index d0620d762a5a..a98a354d46ac 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -1045,10 +1045,6 @@ cmds(struct pt_regs *excp)
 			set_lpp_cmd();
 			break;
 		case 'b':
-			if (xmon_is_ro) {
-				printf(xmon_ro_msg);
-				break;
-			}
 			bpt_cmds();
 			break;
 		case 'C':
@@ -1317,11 +1313,16 @@ bpt_cmds(void)
 	struct bpt *bp;
 
 	cmd = inchar();
+
 	switch (cmd) {
 #ifndef CONFIG_PPC_8xx
 	static const char badaddr[] = "Only kernel addresses are permitted for breakpoints\n";
 	int mode;
 	case 'd':	/* bd - hardware data breakpoint */
+		if (xmon_is_ro) {
+			printf(xmon_ro_msg);
+			break;
+		}
 		if (!ppc_breakpoint_available()) {
 			printf("Hardware data breakpoint not supported on this cpu\n");
 			break;
@@ -1349,6 +1350,10 @@ bpt_cmds(void)
 		break;
 
 	case 'i':	/* bi - hardware instr breakpoint */
+		if (xmon_is_ro) {
+			printf(xmon_ro_msg);
+			break;
+		}
 		if (!cpu_has_feature(CPU_FTR_ARCH_207S)) {
 			printf("Hardware instruction breakpoint "
 			       "not supported on this cpu\n");
@@ -1407,7 +1412,7 @@ bpt_cmds(void)
 			break;
 		}
 		termch = cmd;
-		if (!scanhex(&a)) {
+		if (xmon_is_ro || !scanhex(&a)) {
 			/* print all breakpoints */
 			printf("   type            address\n");
 			if (dabr.enabled) {
-- 
2.23.0

