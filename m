Return-Path: <SRS0=aJWs=FG=lists.openwall.com=kernel-hardening-return-20511-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50408C64E8A
	for <kernel-hardening@archiver.kernel.org>; Wed,  2 Dec 2020 08:56:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 008F6221E9
	for <kernel-hardening@archiver.kernel.org>; Wed,  2 Dec 2020 08:56:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 008F6221E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20511-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21808 invoked by uid 550); 2 Dec 2020 08:56:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21761 invoked from network); 2 Dec 2020 08:56:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bo4g1VjjeNpD+m+0h54bDJSCv5eSt52W6wWRAK1/PYM=;
 b=uR0yYnVyuukvEXdXt9RpyTgABejcTt3QG6finUapNKgOUmOHa8nz0Tg6QBtcbYi9lNzMPBmLls8jN9J7veME++VXl4vnoze73i20vK0wvFfWdymFR3eZkdWvDUdJPj0Oe5+gHJFDCU4qn4Kifl1Uq2FADgd4GaMr9bp2GpXG3Uk=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.openwall.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;lists.openwall.com; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
X-CheckRecipientChecked: true
X-CR-MTA-CID: cc848dc2bf9ee73f
X-CR-MTA-TID: 64aa7808
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1/1/+BFQhLpclKryv/5T9Sqn2L1R9HY1wAPVRAxi8kcy1JI6QIOpY3Thq4jqB6JxAjn78UodcJq9wEaNlCMq+a5wrgK4J2dBTANCTdc5Mg51z4InKoyIUHa2ckirN9FhJw/GTabp+MU0SUiUol8yxvw/pnQNBMs4oRUGgVca/FLhW+msWhBK0nSBioEEEHkSU/a37HCKKP8Bkopj/DvQ02jzsRiL0GEnRjDaNdI91Nj8fPk13yzSk7roy5kjDPikG4eScSmoYaOQtOCZ+NL4v3Oy5PapvQzh2x3OvulxvcScl70KhuG7x40fAuRKg7oWYjn8eOPdXX3s+xtC7C1sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bo4g1VjjeNpD+m+0h54bDJSCv5eSt52W6wWRAK1/PYM=;
 b=aiszp8W6+gV9pf6VFMGKYbHYJZvH56b+uhhSJQTvrF9KJnnd6vzrBHf6rj3m0Lb1Ob7uy93M3e/9qjWBOQv6URfu/DO3bb9sY8oc2Ifz27Q8ZXfW+XUw/9PZ2Vcc+w/ndDH9H+Fz+EvvLa5R6+8qn4gPVa2v/Wl4gXr+b/PdshWYTU6lcUrL8RtVODUYrJW/4Te09S9TGArIh0iKN9qUbJGqxO8DbrlX4ijPzltPpRMGFAIopP9Tq8PK+tGloh/MN6F5JkMZ0OVeUUCJ4JyecbYXdCRhMgAK+hpN9PX4xJwp0VvQGNQ4L2gwbHN5lTVtrFTM/fPkQFtYct7dt1kBtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bo4g1VjjeNpD+m+0h54bDJSCv5eSt52W6wWRAK1/PYM=;
 b=uR0yYnVyuukvEXdXt9RpyTgABejcTt3QG6finUapNKgOUmOHa8nz0Tg6QBtcbYi9lNzMPBmLls8jN9J7veME++VXl4vnoze73i20vK0wvFfWdymFR3eZkdWvDUdJPj0Oe5+gHJFDCU4qn4Kifl1Uq2FADgd4GaMr9bp2GpXG3Uk=
Authentication-Results-Original: sourceware.org; dkim=none (message not
 signed) header.d=none;sourceware.org; dmarc=none action=none
 header.from=arm.com;
From: Szabolcs Nagy <szabolcs.nagy@arm.com>
To: libc-alpha@sourceware.org
Cc: Mark Rutland <mark.rutland@arm.com>,
	kernel-hardening@lists.openwall.com,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-kernel@vger.kernel.org,
	Jeremy Linton <jeremy.linton@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Topi Miettinen <toiwoton@gmail.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 2/2] aarch64: Use mmap to add PROT_BTI instead of mprotect [BZ #26831]
Date: Wed,  2 Dec 2020 08:55:40 +0000
Message-Id: <7e800caa0485fec67b21ebab1e27bb23b2f0d971.1606898457.git.szabolcs.nagy@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <ebce134991eae4261bbb32572a2062d3ca56e674.1606319495.git.szabolcs.nagy@arm.com>
References: <ebce134991eae4261bbb32572a2062d3ca56e674.1606319495.git.szabolcs.nagy@arm.com>
Content-Type: text/plain
X-Originating-IP: [217.140.106.54]
X-ClientProxiedBy: LO2P265CA0345.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::21) To PR3PR08MB5564.eurprd08.prod.outlook.com
 (2603:10a6:102:87::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 52427b89-f070-4545-f7f6-08d896a019ed
X-MS-TrafficTypeDiagnostic: PR3PR08MB5644:|VI1PR08MB4190:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<VI1PR08MB419084FC2E25DFE8F7E0B285EDF30@VI1PR08MB4190.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 teIoYpkYojRI/jYUYuTkWXQf5GOXRSS2bpllNpYsSAsPClOX3OVjyCp2Uh32oooSxOCi77vFkN2xWjE5gSz8vlBd6gP85FObE6EmXyqhetwurUxpoUV1mK9wEmDniAxbxh2eHfkwON9nsCTI2fjeXryyUgT5CJgl1IsU7mI6ygF2ChXqmsHyChtHj4g/qpsLdTsETxlhBpA3KbP/0dqKAlnfcybwfXcZ1O5JC45tRvjdcoIztdKuzS66o/YC+mijWZluwsmxDn8VDpR3LL2gTC1jLNu/fEkilj69lDKj+1evtS46O9w3j1UorztSMsyrRxYCZ74NnfDMm+zrhfaTZxdL9/k8K4A7P2ol1r3ruW/UYkp6mBSAplhra/0v8d92
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5564.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(39850400004)(346002)(136003)(44832011)(956004)(2906002)(316002)(86362001)(8676002)(8936002)(54906003)(6666004)(36756003)(478600001)(66946007)(66476007)(66556008)(5660300002)(69590400008)(2616005)(52116002)(6512007)(4326008)(186003)(6486002)(16526019)(6506007)(6916009)(26005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData:
 =?us-ascii?Q?jWjZJ7jpYgfUVyQ90oifYa0y+saFIDNkgH2AZFtIuJg4GU19GLDb1HHGKm3r?=
 =?us-ascii?Q?0WFWH5auFkkLgXYSZKNRjsdmES3r+ltfzUobUxl9PLkaqxCEEjNi1+dT1eEN?=
 =?us-ascii?Q?K8P+1MaWg2Lchmz+vRp4ERFM0V5OFQ39q7RBfACr6nNl0LAIjMv/idohamA/?=
 =?us-ascii?Q?O/P0LQ0p9hVvAYfofrum0X7cx1ENvSuVWI0o0sCpZOEnB8mWIVFbYWjAJaXG?=
 =?us-ascii?Q?7rG1WRDSGQCy+q6BownUtb/6an3nbNzIHzJrmihjwdSBW+KR7AVu5N/JKJz5?=
 =?us-ascii?Q?rmXS1/VyrLoznqXd7rbj6CjnEZqGqYfQLDoTGfuZXz/XyNAtK4RmNsSQq28/?=
 =?us-ascii?Q?M2MM/AM63r01EWz4kXAIRr8+E9htuxfHMu2BTQRGZ5NjEawojZ/FOsQGAxzZ?=
 =?us-ascii?Q?FcZw2OlRvom9qtmodJEk4eA1C5wtjhn+FGZ8P6xdd+JpIC5+e08dh+5BAxPK?=
 =?us-ascii?Q?YVjsD8uIM5tpcA2mR8LDHlLcgVfPVw9q0sVz7r009/GD5eI1kBep5Snm+7or?=
 =?us-ascii?Q?Pb2Q2As+RAAz76N7WaaCXoYWQDEAadhT6I8lCiJMilKU/nmq3PvzpiByfR9T?=
 =?us-ascii?Q?C2jO2gZtq6KACYixmyCYALDQKKfWlTXQLZ50krQNfsAQ3zfn0B3sWI/+W2mz?=
 =?us-ascii?Q?KXYKlvEYZmzebZb8Igpiyc3QJ6TmCmsomMSTlwmZDgAaBcntdNuGB7UU8dos?=
 =?us-ascii?Q?E0jz9qlDFgLsjnEPKBt4mYHiGVJOiSiAmBwiVS4nrytRXBzXPSnaSoH65JjN?=
 =?us-ascii?Q?4GImTmHG4FumUtV7fALtOudtUyRncOn+heFjgpm1LmnY734IbD4qtzGwgYy9?=
 =?us-ascii?Q?XbnGmlFkV7x+FxWtSMwtz4VRqq+IKm+Iam5WngxbYKpP13Ks+T5tVuQVgXJA?=
 =?us-ascii?Q?WFs4qWfgYULnwfn/bHTuIxPPezEXMmFKtBlBZ14nfxAtXgRae23uWbCkeVAL?=
 =?us-ascii?Q?JexpcRaqOOqs/tjK9kn0gD3V8jb/muhDZXxd3zEvcWkwdRuEg0U5sXaDT7cN?=
 =?us-ascii?Q?v0Gd?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5644
Original-Authentication-Results: sourceware.org; dkim=none (message not signed)
 header.d=none;sourceware.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM5EUR03FT026.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d0817323-7a2e-48b1-7f54-08d896a00ed4
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rLHGCsv+SVDVtZfUU6y5IHrLPInJ3V0+q1y+YUVXdqYSwzh3gUkgILiOdX9MtmrCwRjj61jR90dUVBhozuyjpCnn1Xqcz9cigvV4RFGk0d0vE8qfONKCtotgR1z3H76uDIG2rEr8S0w2TVDC5/efiWLJo+FUkLa0qO2D25oMUUAuqyHqo+MdBI893PuuGMTqA/nLkO9mehEMRhQHvTzcBhApA6/hGlohGrqq2BWlwD90Q72GBcaFPIetZ3IN4PwFPg6nff3gLqRX7/PZIjlP62WGVGasWMAM6kpZeRI1JRHS1W63bFfIyK/txYqagbFhoJ7dQvVcH4AnPBd8xayXgG6+tqtT/z5EctbOAyhUeSAlVOz4/uX9dzKhoV3EKyTVWCLdcXRNmRd6wDV9cNkHrgR3D7+5St4GBrff3Zv1qrj68h9RFrJ7hw7sKXUw8ErE
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(376002)(39850400004)(136003)(396003)(46966005)(6506007)(336012)(81166007)(2616005)(478600001)(6666004)(70206006)(70586007)(5660300002)(956004)(44832011)(83380400001)(107886003)(54906003)(356005)(316002)(82740400003)(2906002)(86362001)(8676002)(47076004)(8936002)(69590400008)(36906005)(6512007)(34206002)(4326008)(186003)(82310400003)(26005)(6486002)(36756003)(16526019);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2020 08:56:04.6185
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52427b89-f070-4545-f7f6-08d896a019ed
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM5EUR03FT026.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4190

Re-mmap executable segments if possible instead of using mprotect
to add PROT_BTI. This allows using BTI protection with security
policies that prevent mprotect with PROT_EXEC.

If the fd of the ELF module is not available because it was kernel
mapped then mprotect is used and failures are ignored.  To protect
the main executable even when mprotect is filtered the linux kernel
 will have to be changed to add PROT_BTI to it.

The delayed failure reporting is mainly needed because currently
_dl_process_gnu_properties does not propagate failures such that
the required cleanups happen. Using the link_map_machine struct for
error propagation is not ideal, but this seemed to be the least
intrusive solution.

Fixes bug 26831.
---
v3:
- split the last patch in two.
- pushed to nsz/btifix-v3 branch.

 sysdeps/aarch64/dl-bti.c  | 54 ++++++++++++++++++++++++++-------------
 sysdeps/aarch64/dl-prop.h |  8 +++++-
 sysdeps/aarch64/linkmap.h |  2 +-
 3 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/sysdeps/aarch64/dl-bti.c b/sysdeps/aarch64/dl-bti.c
index 67d63c8a73..ff26c98ccf 100644
--- a/sysdeps/aarch64/dl-bti.c
+++ b/sysdeps/aarch64/dl-bti.c
@@ -19,9 +19,17 @@
 #include <errno.h>
 #include <libintl.h>
 #include <ldsodefs.h>
+#include <sys/mman.h>
 
-static void
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
   const size_t pagesz = GLRO(dl_pagesize);
   const ElfW(Phdr) *phdr;
@@ -41,19 +49,31 @@ enable_bti (struct link_map *map, const char *program)
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
@@ -61,16 +81,14 @@ _dl_bti_check (struct link_map *map, const char *program)
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

