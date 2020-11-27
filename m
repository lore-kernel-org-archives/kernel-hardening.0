Return-Path: <SRS0=v/05=FB=lists.openwall.com=kernel-hardening-return-20463-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAAB2C63798
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Nov 2020 13:21:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A714C22245
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Nov 2020 13:21:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="ccRhqIZi";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="ccRhqIZi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A714C22245
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20463-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14125 invoked by uid 550); 27 Nov 2020 13:21:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14093 invoked from network); 27 Nov 2020 13:21:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4W8h42KC+tuve8tPTBuxxqbSUaADFodArmw0B4sZp4=;
 b=ccRhqIZi9UVo4l0UYwQ5++Is4eHPOXlA+3b5poxqiHO5dd512DUC7UgMEB0CS9ODpUfhavp4vpt3AVsWZXBBRGFBU524xIvgHVW5faL3ZzceRZjGzpe50Mtd5yRwwVG6dMqunCnWs0TONgafGaEPjLR6IMo8dMPN5oM3uJMXKDg=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.openwall.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;lists.openwall.com; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
X-CheckRecipientChecked: true
X-CR-MTA-CID: c722bb8456fde5d2
X-CR-MTA-TID: 64aa7808
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RdLqBmhKUuS1hsf5G5Ghty0uZZBkyD8vxTF22waWWH4hEkVvL/QFzWxyBh/LliRhK3ZF1wtrABqszxrhplkT3EFQxZPr/onlsHC1nX/aehBCuvAeEKSZcHH3omXTjDtUiA0uahbPG2JfhPaoGFQGMZAYpM3L/Grlh/e1PMW4oQV0wkSuTBM2ajn4ZE8yQNnpWRHf2/iFjb7SFGEq1SysvTQUQYBPw4/ZvReQhBwQTe8rlt3yX8V4gCf7o+X6aJO97gbCCMFMdcM90N86xzcnHE7nhw1WIl3ehcG6EFO5X46Kkl+ShPkzz8u3wMHgWIslBvXYJFGivEH3yeDk/79oHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4W8h42KC+tuve8tPTBuxxqbSUaADFodArmw0B4sZp4=;
 b=oQpWL0c5CrPlCUrwIZBCyM3WCFHFfOEpHEfbM5Roxsk7i51yzNDT2dfGKUjebf68dcglj3oiW7kbxXH/QccpJ4Qf+FR5NXmCVhX+TmOhIUwhUqI7eqmcue/IaSr+iY7CmpW9ZKi9z3oEfmtTqeMfqpOR7DGIJy52MArNtXMRSSrvhabOy6BnIxZKShAXq8kPkbnL5BBZm+agtYOudfXnL9vtdjoBgy9/Ch9KbAsJ937jlZHESqto4NBP7GZQ9/uftzwamBv4tDQkcofJLkOlFfdee80xLclSS7uuVUET4UaO0UBT9Lxfw+rTU94KRqvX0AMhN17FP4YMlrDDu7dA/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4W8h42KC+tuve8tPTBuxxqbSUaADFodArmw0B4sZp4=;
 b=ccRhqIZi9UVo4l0UYwQ5++Is4eHPOXlA+3b5poxqiHO5dd512DUC7UgMEB0CS9ODpUfhavp4vpt3AVsWZXBBRGFBU524xIvgHVW5faL3ZzceRZjGzpe50Mtd5yRwwVG6dMqunCnWs0TONgafGaEPjLR6IMo8dMPN5oM3uJMXKDg=
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
Subject: [PATCH v2 3/6] elf: Fix failure handling in _dl_map_object_from_fd
Date: Fri, 27 Nov 2020 13:20:29 +0000
Message-Id: <8ebf571196dd499c61983dbf53c94c68ebd458cc.1606319495.git.szabolcs.nagy@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606319495.git.szabolcs.nagy@arm.com>
References: <cover.1606319495.git.szabolcs.nagy@arm.com>
Content-Type: text/plain
X-Originating-IP: [217.140.106.54]
X-ClientProxiedBy: SA0PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:806:d3::28) To PR3PR08MB5564.eurprd08.prod.outlook.com
 (2603:10a6:102:87::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b2bbae7c-79d5-4226-a21e-08d892d74241
X-MS-TrafficTypeDiagnostic: PA4PR08MB6014:|PA4PR08MB6189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<PA4PR08MB6189EC5CE67340CAA0507B64EDF80@PA4PR08MB6189.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 wckCYhRrptvH2hDAGN//RAyND2YoofEg/92zhQ7sYK0lOQ2Jjb5usPsQRDTvlD1L0saDq+prR+YySojIqIr+tTiZEPeZKvmXEsE1B7WFt7aAjwMz4k+kV0Y+Wx9F1r3Mk4SO2lqXP4EC/Ogp8NkyYT1bpPl7wEEaQG2HyY0oOxubZRtUmPFEkHaNxFafO2s4JTf02neahrLDyE63g6LvUl6jx1Dvs8NfKdOOfqRBgZQOA5LBzTCZo/X4YmilR7WQr5WHZEhbG1I3XTZYTbL6rJKZsevwOdtL+LnMnDiOwtj/Jn1gGKlIoWh0FJYintTr/isrH0WYvyCPHgQZCGoO/qAEOAlPZxGqsHAwG9Xu2eE23FH0gc4VVW+3e1H9Xb5G
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5564.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(4326008)(54906003)(69590400008)(6916009)(6512007)(36756003)(6486002)(6666004)(316002)(478600001)(5660300002)(2616005)(86362001)(44832011)(2906002)(956004)(8936002)(16526019)(186003)(26005)(8676002)(66476007)(66946007)(6506007)(66556008)(52116002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData:
 =?us-ascii?Q?R4Yu4qh4lbx4/u1KQNldVSznsB/U3fxexII6Bdbq50gSBJj+Kk425A6yfbiD?=
 =?us-ascii?Q?7uVhGsOcpP7kTTcKZTCDGPrv//KbpyXCgAlC93yzju1Yhqw8TlZ4rkDIk+Ug?=
 =?us-ascii?Q?EW8D/bCCaQl+lgmhPd3R2DZKk9Ux2+kpi1PhYrY6jP2KzKU9iEwP7dC53lWp?=
 =?us-ascii?Q?zi4eEUyO7HJVcdaRTtumnevelG/0UqayNnKmH7FqMM+42j+UbXfT1dEHb2DW?=
 =?us-ascii?Q?v+XoyYmhaUgulzLwSvGLZOM1nQshQs+WdESnewIMM9bfWbWz6QosE8er4a3b?=
 =?us-ascii?Q?ZMxdvAtQBHdhnUfAC1VprnE0iKrfrvJPTfTNZafm6dJF+31yleBTmpPaX5xl?=
 =?us-ascii?Q?VyZQL5Dor2SmhaE4HtFs2xu34CfrvCZ2KaSikbI4C4HAyKkDQw3BFwJfj2Q7?=
 =?us-ascii?Q?NHBlXaR60WLkR/gMxYRM47AQJ+AntTVl70F4OAHHpStu/yh6XlyNl3z6rmjd?=
 =?us-ascii?Q?eQgSMExqifH/uerZiIOz3C6W6IDl9fty5pmB62vjOyDdac1vmcp75laBYkY2?=
 =?us-ascii?Q?e7N5lUNKxdiVXn1zQY9AGqJPpIWNjPrn9qWtkfOpkmiAC3a3e/b0Hla+bSIl?=
 =?us-ascii?Q?wD4fZYe810GDKyTBomcJCObuKqYZL8MvhErlo1RL5SKRef8GH0eGZmfxoKi1?=
 =?us-ascii?Q?3E6CGTbyMXrEV4DsKGlYiHOJOqK/0dMFNz0cdWxTATcVsPgI+zqrikft0WmT?=
 =?us-ascii?Q?RtT20PtSSwU5Fa74+cekZiY1Uz8rLBlDv9WDA3OY4IhomgzZhRyGD84H3az8?=
 =?us-ascii?Q?9Y6cYMvBj/CZgfgWTZnauVgH1mlqvjzgvT7hz+jqa4aIN9A+PGzVZuzfHp1Q?=
 =?us-ascii?Q?ehFSsasWhFYBjO8+mMW13Y/SV5ChI5586gVeTWamTbCznCrZzGdLOi0iMtbU?=
 =?us-ascii?Q?0emQ2SmOuAnGuEibN839vY+Sa+VOS2LvvUiOlhE+jxDC9dH0CCc9W8H5xpLy?=
 =?us-ascii?Q?6KuKcaCQfmt+RpvUT/BGG/0AFh6Y92eIk0PZ/fU237yCfWucCNvb8xuq84cO?=
 =?us-ascii?Q?5NQn?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6014
Original-Authentication-Results: sourceware.org; dkim=none (message not signed)
 header.d=none;sourceware.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM5EUR03FT026.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9dc536e2-20e4-4c3a-86a4-08d892d73e03
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gWEGroco8MVR7e6rnoXNwN6L6mSDvp/s4Y9pOaZF5WNZdHEqYvHye9lUES/cfZvTXjgVz7tf6wjg3kcscmVwb15Wuiev9GkDa8VQGGFiDbfJs1L7K9xyrDuyDrOxF7kniGGmh17YYIlMlKveUwtB0fJC3EvrHdxl73AkhKqKTeuPlyfDqd6yBOpuDdQ4z9IdjYavgDtVsgwHmyakcj0AHErWSMOgzUsxUkRrLdEko6er3H51HAhDNngkv368WU8cT+0pVXaiDANoKm+dmYaCUxGut/VO0uHFee5+0ZHAX/sJYTy43TgluDaw63xMcKvZKl5EmTKNLQmp81mhXZ5L6nFtyq9vJabSCmgNKWfY5CJbpHus4pzj6u1d9CUzdqEnr7aMu1O7eg7nEexdq3ipQaPcgXvnkz8BlQPfn1Itrk0GX/O1yVo1Y2K4jpUWjwgU
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(136003)(39860400002)(46966005)(6666004)(16526019)(83380400001)(186003)(336012)(47076004)(54906003)(478600001)(4326008)(36906005)(956004)(44832011)(2616005)(6486002)(6512007)(316002)(26005)(6506007)(8936002)(69590400008)(8676002)(82740400003)(107886003)(5660300002)(86362001)(70206006)(36756003)(34206002)(81166007)(2906002)(82310400003)(70586007)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2020 13:20:49.9097
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b2bbae7c-79d5-4226-a21e-08d892d74241
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM5EUR03FT026.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6189

There are many failure paths that call lose to do local cleanups
in _dl_map_object_from_fd, but it did not clean everything.

Handle l_phdr, l_libname and mapped segments in the common failure
handling code.

There are various bits that may not be cleaned properly on failure
(e.g. executable stack, tlsid, incomplete dl_map_segments).
---
 elf/dl-load.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/elf/dl-load.c b/elf/dl-load.c
index 21e55deb19..9c71b7562c 100644
--- a/elf/dl-load.c
+++ b/elf/dl-load.c
@@ -914,8 +914,15 @@ lose (int code, int fd, const char *name, char *realname, struct link_map *l,
   /* The file might already be closed.  */
   if (fd != -1)
     (void) __close_nocancel (fd);
+  if (l != NULL && l->l_map_start != 0)
+    _dl_unmap_segments (l);
   if (l != NULL && l->l_origin != (char *) -1l)
     free ((char *) l->l_origin);
+  if (l != NULL && !l->l_libname->dont_free)
+    free (l->l_libname);
+  if (l != NULL && l->l_phdr_allocated)
+    free ((void *) l->l_phdr);
+
   free (l);
   free (realname);
 
@@ -1256,7 +1263,11 @@ _dl_map_object_from_fd (const char *name, const char *origname, int fd,
     errstring = _dl_map_segments (l, fd, header, type, loadcmds, nloadcmds,
 				  maplength, has_holes, loader);
     if (__glibc_unlikely (errstring != NULL))
-      goto call_lose;
+      {
+	/* Mappings can be in an inconsistent state: avoid unmap.  */
+	l->l_map_start = l->l_map_end = 0;
+	goto call_lose;
+      }
 
     /* Process program headers again after load segments are mapped in
        case processing requires accessing those segments.  Scan program
@@ -1294,14 +1305,6 @@ _dl_map_object_from_fd (const char *name, const char *origname, int fd,
       || (__glibc_unlikely (l->l_flags_1 & DF_1_PIE)
 	  && __glibc_unlikely ((mode & __RTLD_OPENEXEC) == 0)))
     {
-      /* We are not supposed to load this object.  Free all resources.  */
-      _dl_unmap_segments (l);
-
-      if (!l->l_libname->dont_free)
-	free (l->l_libname);
-
-      if (l->l_phdr_allocated)
-	free ((void *) l->l_phdr);
 
       if (l->l_flags_1 & DF_1_PIE)
 	errstring
@@ -1392,6 +1395,9 @@ cannot enable executable stack as shared object requires");
   /* Signal that we closed the file.  */
   fd = -1;
 
+  /* Failures before this point are handled locally via lose.
+     No more failures are allowed in this function until return.  */
+
   /* If this is ET_EXEC, we should have loaded it as lt_executable.  */
   assert (type != ET_EXEC || l->l_type == lt_executable);
 
-- 
2.17.1

