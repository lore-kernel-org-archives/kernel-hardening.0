Return-Path: <SRS0=PYi1=FB=lists.openwall.com=kernel-hardening-return-20466-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD14C64E8A
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Nov 2020 13:22:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 981C922255
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Nov 2020 13:22:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="Ai4rrVEb";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="Ai4rrVEb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 981C922255
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20466-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19602 invoked by uid 550); 27 Nov 2020 13:22:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19567 invoked from network); 27 Nov 2020 13:22:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNhDXoIacsU34w/3BvmYpkHf4Z/z/9IrNSX8sg3eJMw=;
 b=Ai4rrVEbR5P0boFd6cuSuVZHXHC7jIWIr6j0VrY4gsiI97au396Biv7U6so79xRLz4cui4tD7kDBwPo8v0suW6XFUMY80pTE9N0n/XpZjCHp5H4LtTrNXp2iXcdsz99xKT/pnwunMuSVo6nQVnFUSlDvoECLSO6zZ5NW8d35igg=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.openwall.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;lists.openwall.com; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
X-CheckRecipientChecked: true
X-CR-MTA-CID: 40dd52e927242136
X-CR-MTA-TID: 64aa7808
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nKJ1A4jFkTZwRzjEfloDbnaFiZR1YOxRrPK4rz8Aoh9K2AtBdUvPmhQ6HFSv7y44ddmfXki1tIuIY7I48zuzC90xP/8nKtHqaCCyYpyIJydhf0CilyxPzd+JY0dRCF1LR/nfqN/OWEHuU+31t+ffFv7Zgl+V2RM5WIL+6ms4I79bISfi11TRw1TBj1LaquLlTEgOZzc6LCaDCkAPbdjjn121Wb4ZZGpMcbQvYtmSBwgiF12u/Jyd4mmKWqrHpihGJ6/WRA9DQDEGW0PASYKqPy6YW+RACJRjmH+GePZZQyGjtgg6Rhi0lU0iTvlLH1fKQOjsWMUpuQGTeFUmWqVPTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNhDXoIacsU34w/3BvmYpkHf4Z/z/9IrNSX8sg3eJMw=;
 b=BvWP7tGZSOZNttkIXg6IQYanOXe+Hk0NPXmuBKvXUIg47mXMosfqFD6d5CfJQztYf0ghJizBH0fxXiW12fEAUB9KKHVfZ0ZddeRg8EyBm6S+koZZuidvdyLzh/0E0l3FLxPhT9ITEXp7k0cMWZbG/ppUnNw0tsJZ5Ba75CkBMZFukHoWaVOvAK48Gk6053q9MReSfA7pH55GnW9wuT1PljO50WnURnWNtygEGFDZGZSIrxDiJx51utLyjiZ6iOgq7UeQolj5tS2n+ubtJsOYjhNXQlLuhkSC5JVSWafrkw/U7NtXNIC7RiOHfqH8lhQPbRDL3pwmbcqVWP34quyJtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNhDXoIacsU34w/3BvmYpkHf4Z/z/9IrNSX8sg3eJMw=;
 b=Ai4rrVEbR5P0boFd6cuSuVZHXHC7jIWIr6j0VrY4gsiI97au396Biv7U6so79xRLz4cui4tD7kDBwPo8v0suW6XFUMY80pTE9N0n/XpZjCHp5H4LtTrNXp2iXcdsz99xKT/pnwunMuSVo6nQVnFUSlDvoECLSO6zZ5NW8d35igg=
Authentication-Results-Original: sourceware.org; dkim=none (message not
 signed) header.d=none;sourceware.org; dmarc=none action=none
 header.from=arm.com;
From: Szabolcs Nagy <szabolcs.nagy@arm.com>
To: libc-alpha@sourceware.org
Cc: Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-kernel@vger.kernel.org,
	Jeremy Linton <jeremy.linton@arm.com>,
	Mark Brown <broonie@kernel.org>,
	kernel-hardening@lists.openwall.com,
	Topi Miettinen <toiwoton@gmail.com>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 6/6] aarch64: Use mmap to add PROT_BTI instead of mprotect [BZ #26831]
Date: Fri, 27 Nov 2020 13:21:41 +0000
Message-Id: <ebce134991eae4261bbb32572a2062d3ca56e674.1606319495.git.szabolcs.nagy@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606319495.git.szabolcs.nagy@arm.com>
References: <cover.1606319495.git.szabolcs.nagy@arm.com>
Content-Type: text/plain
X-Originating-IP: [217.140.106.54]
X-ClientProxiedBy: SN6PR04CA0108.namprd04.prod.outlook.com
 (2603:10b6:805:f2::49) To PR3PR08MB5564.eurprd08.prod.outlook.com
 (2603:10a6:102:87::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a31f6615-47ef-44cb-2ea1-08d892d76d49
X-MS-TrafficTypeDiagnostic: PA4PR08MB6014:|DB7PR08MB3372:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<DB7PR08MB33724EB98EC03DB10AAFCD1EEDF80@DB7PR08MB3372.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:497;OLM:497;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 BaBuPb9/YuYaqm6UJpQ+WP7akESjJp71I8Ow31uIMF1TpHrI2zvDRmlKv0AP4BLZGzpv+LS1h3GAR2sbXBMfIkim12QEmMtK4mZQV4jomdjZMkCiDKpKn3enGdI/Jzq+eYMaFWvGpPwyVrIi6NqCso8nydIiw0a/3ZWuVc4U0G6jYxKDCOdp5oo5yHHHRHZgr88CDSNxvzyny3xnZ6iYwqCSCHDQua0+t5hRuM+t5qFCJyEmrdaG5cYPNpuJSL+Qv255ei6omgWn9uUWeuPi6pj07Ezd2JhTmCIvIw+bKkNV9t3H1fIGm7F3BIrvKtYEwh3IFdSvsQ2O7mTHkKq5OzYhtR5VbhVMgwuanoWxUKm0dgZrL2ZBoO66TlGBAGmn
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5564.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(4326008)(54906003)(69590400008)(6916009)(6512007)(36756003)(6486002)(6666004)(316002)(478600001)(5660300002)(2616005)(86362001)(44832011)(2906002)(956004)(8936002)(16526019)(186003)(26005)(8676002)(66476007)(66946007)(6506007)(66556008)(52116002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData:
 =?us-ascii?Q?aBkv4e8QhDD/Lzlh8V/SyjUP8T5/lAC12SFWNYWmYVo5bKLLwRESK3gDvWTs?=
 =?us-ascii?Q?Y59yzqsNcMchEywEBLfj8NLUbKcNAcCPOvf4AyabEpV7XFjfGshbcuH8XxgX?=
 =?us-ascii?Q?GN6xGcwwFF78GFLxn9Ico3Ngh0hVDNEeaB2i8fusthlwqnIw4uYReM9+mCxs?=
 =?us-ascii?Q?Ke3qTHNIpalCN683Nhx6tAN40Ik5cFzBMgVdRp1lQOzFhteTnJ8okdrlfgJ5?=
 =?us-ascii?Q?TCSDD0V+oedtUKfDXDYgxk766oAJo8/XTxPLV49GKQT3S6Je2EStM+uG8w0O?=
 =?us-ascii?Q?SUpZ0lB52M1qb6Pc4EmOutbD93ipjgB2JOFpMFnWwo1W90xCv8Ge8tBfxEMb?=
 =?us-ascii?Q?q6Om/oXyYhli8u7bbX2FXJPlpFMFE1wH0zgG9UATUGqJuNEPu1nf1Rqj7Vh3?=
 =?us-ascii?Q?8X4UdrmlRFk7ExWSn6v/qijBNHhhRboPyJbqMW2hVF7slSbaWRIlDiW+umAv?=
 =?us-ascii?Q?90+9Z/5FWraNObzrhv3WYQwE/x7IkcflGLye/b1J63wePBufw8OqbxdZly9c?=
 =?us-ascii?Q?0Y2xNzJC70bsGUvstrpJY6xa7E0gsEJKkg0915tbbFTXhLKVMrIsEhfv+e8V?=
 =?us-ascii?Q?94woZjoKeZ2tsHoGOghExm+tmKvCpES9Bdyi7vJdxfYNj554Eh5k7gifKlEg?=
 =?us-ascii?Q?pNSSjLWk+8tELIAD6dYKYLXrvzxUd13waXvYu9nkjxWJe5b9VYoCkmEDL/tH?=
 =?us-ascii?Q?/Qd+srAmfIn+4/Had0HRKagUxL2KSk6tPwiKHU0inEjtJ8l8iUMb2ZdEFsg2?=
 =?us-ascii?Q?IeuHdYiUXoUhkUmEoe4w/xM5j93qwXkh6u0cz7Cyuo8fhfTGApNpRmQeheur?=
 =?us-ascii?Q?kndBTlJtl6X1Rd9fTfEunWkkWDzBoU+pNQHqLHf1MOoh8K3B7OPRxmA206TC?=
 =?us-ascii?Q?Wuhu+0arIQOH6MdPs/3ta0JtrDNEMOMkRnnWYZ2EspXNNUnKspZ5OkMalj7s?=
 =?us-ascii?Q?YuYn9452aHr+y3+UdHMisLslGgfUNoJN4dWS+xwpLiZzvJV6ZtlwQa4428w+?=
 =?us-ascii?Q?hWuZ?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6014
Original-Authentication-Results: sourceware.org; dkim=none (message not signed)
 header.d=none;sourceware.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 VE1EUR03FT010.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f345003f-ce57-4f90-ab51-08d892d768ff
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0YSEA4Nd/8rc2KvymwKnMIHD1QedblRwvN7MPWTxjlHzgwVNUzizQCX+vCenM0aoYOJHuRaUWjMQJvZFxR5/X1+IR1KbR9skXXN0cz8VcD2cwKQqRtSHyoFBSXZQpCY7dGsGaNNEyjmhNBodSC/BhKtHoaAIzcKaTueIJb0bZYmb3Q9pozFIJy3mveYRob0pPOsHf4Ah44vZx5k2JhGqmXcMZGXnSkdnftRmLoaQ5FA3sNVq8+SiGFXj2KfzhoiMjxHXDbg+aOe7xd7b1ivyPOYOT1zTRsvjRu/raFv04FqBKr8dxYWDwIXdZhvugpK4kPitLMTJOVefHDUMYO8Pw9SQxfDMgDYxHs3a+MIPZzyVhOB7WLtRtMEj0aWma2p9ehGIP+hq13fpEJ89k33rYXCdMjAYV0VJ1niOXAVaK0i+pDt2+5kRNqWbAAf0H1J/
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(376002)(39860400002)(46966005)(107886003)(26005)(6486002)(81166007)(5660300002)(36756003)(6506007)(83380400001)(8676002)(82740400003)(356005)(478600001)(70586007)(186003)(70206006)(4326008)(86362001)(47076004)(2906002)(69590400008)(34206002)(16526019)(2616005)(336012)(82310400003)(6512007)(956004)(54906003)(6666004)(316002)(44832011)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2020 13:22:02.0762
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a31f6615-47ef-44cb-2ea1-08d892d76d49
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	VE1EUR03FT010.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3372

Re-mmap executable segments if possible instead of using mprotect
to add PROT_BTI. This allows using BTI protection with security
policies that prevent mprotect with PROT_EXEC.

If the fd of the ELF module is not available because it was kernel
mapped then mprotect is used and failures are ignored.  To protect
the main executable even when mprotect is filtered the linux kernel
will have to be changed to add PROT_BTI to it.

Computing the mapping bounds follows _dl_map_object_from_fd more
closely now.

The delayed failure reporting is mainly needed because currently
_dl_process_gnu_properties does not propagate failures such that
the required cleanups happen. Using the link_map_machine struct for
error propagation is not ideal, but this seemed to be the least
intrusive solution.

Fixes bug 26831.
---
 sysdeps/aarch64/dl-bti.c  | 67 +++++++++++++++++++++++++--------------
 sysdeps/aarch64/dl-prop.h |  8 ++++-
 sysdeps/aarch64/linkmap.h |  2 +-
 3 files changed, 52 insertions(+), 25 deletions(-)

diff --git a/sysdeps/aarch64/dl-bti.c b/sysdeps/aarch64/dl-bti.c
index 8f4728adce..34b5294f92 100644
--- a/sysdeps/aarch64/dl-bti.c
+++ b/sysdeps/aarch64/dl-bti.c
@@ -19,39 +19,62 @@
 #include <errno.h>
 #include <libintl.h>
 #include <ldsodefs.h>
+#include <sys/mman.h>
 
-static int
-enable_bti (struct link_map *map, const char *program)
+/* See elf/dl-load.h.  */
+#ifndef MAP_COPY
+# define MAP_COPY (MAP_PRIVATE | MAP_DENYWRITE)
+#endif
+
+/* Enable BTI protection for MAP.  */
+
+void
+_dl_bti_protect (struct link_map *map, int fd)
 {
+  const size_t pagesz = GLRO(dl_pagesize);
   const ElfW(Phdr) *phdr;
-  unsigned prot;
 
   for (phdr = map->l_phdr; phdr < &map->l_phdr[map->l_phnum]; ++phdr)
     if (phdr->p_type == PT_LOAD && (phdr->p_flags & PF_X))
       {
-	void *start = (void *) (phdr->p_vaddr + map->l_addr);
-	size_t len = phdr->p_memsz;
+	size_t vstart = ALIGN_DOWN (phdr->p_vaddr, pagesz);
+	size_t vend = ALIGN_UP (phdr->p_vaddr + phdr->p_filesz, pagesz);
+	off_t off = ALIGN_DOWN (phdr->p_offset, pagesz);
+	void *start = (void *) (vstart + map->l_addr);
+	size_t len = vend - vstart;
 
-	prot = PROT_EXEC | PROT_BTI;
+	/* Add PROT_BTI.  */
+	unsigned prot = PROT_EXEC | PROT_BTI;
 	if (phdr->p_flags & PF_R)
 	  prot |= PROT_READ;
 	if (phdr->p_flags & PF_W)
 	  prot |= PROT_WRITE;
 
-	if (__mprotect (start, len, prot) < 0)
-	  {
-	    if (program)
-	      _dl_fatal_printf ("%s: mprotect failed to turn on BTI\n",
-				map->l_name);
-	    else
-	      _dl_signal_error (errno, map->l_name, "dlopen",
-				N_("mprotect failed to turn on BTI"));
-	  }
+	if (fd == -1)
+	  /* Ignore failures for kernel mapped binaries.  */
+	  __mprotect (start, len, prot);
+	else
+	  map->l_mach.bti_fail = __mmap (start, len, prot,
+					 MAP_FIXED|MAP_COPY|MAP_FILE,
+					 fd, off) == MAP_FAILED;
       }
-  return 0;
 }
 
-/* Enable BTI for MAP and its dependencies.  */
+
+static void
+bti_failed (struct link_map *l, const char *program)
+{
+  if (program)
+    _dl_fatal_printf ("%s: %s: failed to turn on BTI protection\n",
+		      program, l->l_name);
+  else
+    /* Note: the errno value is not available any more.  */
+    _dl_signal_error (0, l->l_name, "dlopen",
+		      N_("failed to turn on BTI protection"));
+}
+
+
+/* Report BTI protection failures for MAP and its dependencies.  */
 
 void
 _dl_bti_check (struct link_map *map, const char *program)
@@ -59,16 +82,14 @@ _dl_bti_check (struct link_map *map, const char *program)
   if (!GLRO(dl_aarch64_cpu_features).bti)
     return;
 
-  if (map->l_mach.bti)
-    enable_bti (map, program);
+  if (map->l_mach.bti_fail)
+    bti_failed (map, program);
 
   unsigned int i = map->l_searchlist.r_nlist;
   while (i-- > 0)
     {
       struct link_map *l = map->l_initfini[i];
-      if (l->l_init_called)
-	continue;
-      if (l->l_mach.bti)
-	enable_bti (l, program);
+      if (l->l_mach.bti_fail)
+	bti_failed (l, program);
     }
 }
diff --git a/sysdeps/aarch64/dl-prop.h b/sysdeps/aarch64/dl-prop.h
index 2016d1472e..e926e54984 100644
--- a/sysdeps/aarch64/dl-prop.h
+++ b/sysdeps/aarch64/dl-prop.h
@@ -19,6 +19,8 @@
 #ifndef _DL_PROP_H
 #define _DL_PROP_H
 
+extern void _dl_bti_protect (struct link_map *, int) attribute_hidden;
+
 extern void _dl_bti_check (struct link_map *, const char *)
     attribute_hidden;
 
@@ -43,6 +45,10 @@ static inline int
 _dl_process_gnu_property (struct link_map *l, int fd, uint32_t type,
 			  uint32_t datasz, void *data)
 {
+  if (!GLRO(dl_aarch64_cpu_features).bti)
+    /* Skip note processing.  */
+    return 0;
+
   if (type == GNU_PROPERTY_AARCH64_FEATURE_1_AND)
     {
       /* Stop if the property note is ill-formed.  */
@@ -51,7 +57,7 @@ _dl_process_gnu_property (struct link_map *l, int fd, uint32_t type,
 
       unsigned int feature_1 = *(unsigned int *) data;
       if (feature_1 & GNU_PROPERTY_AARCH64_FEATURE_1_BTI)
-	l->l_mach.bti = true;
+	_dl_bti_protect (l, fd);
 
       /* Stop if we processed the property note.  */
       return 0;
diff --git a/sysdeps/aarch64/linkmap.h b/sysdeps/aarch64/linkmap.h
index 847a03ace2..b3f7663b07 100644
--- a/sysdeps/aarch64/linkmap.h
+++ b/sysdeps/aarch64/linkmap.h
@@ -22,5 +22,5 @@ struct link_map_machine
 {
   ElfW(Addr) plt;	  /* Address of .plt */
   void *tlsdesc_table;	  /* Address of TLS descriptor hash table.  */
-  bool bti;		  /* Branch Target Identification is enabled.  */
+  bool bti_fail;	  /* Failed to enable Branch Target Identification.  */
 };
-- 
2.17.1

