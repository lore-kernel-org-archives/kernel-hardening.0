Return-Path: <SRS0=/qY9=FG=lists.openwall.com=kernel-hardening-return-20510-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DD0AC64E7C
	for <kernel-hardening@archiver.kernel.org>; Wed,  2 Dec 2020 08:56:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8EC50221E9
	for <kernel-hardening@archiver.kernel.org>; Wed,  2 Dec 2020 08:56:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8EC50221E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20510-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19901 invoked by uid 550); 2 Dec 2020 08:55:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19859 invoked from network); 2 Dec 2020 08:55:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NXffKCVdJsUjKE9yUrpY+buHuATx7T0FPdE9nZs50nw=;
 b=vSMTNbXrQU5lwa5eZUsj8zsbVBkCsrSg4o9mnBiB0hyEeAZRDUWimd+2CenBqpwq8XpmL6f0wvcRKveRBBVEEMFoFue4/XI73ekbfeyZwMCHC0w5JAbEBwED8WTrkLeuqLJVnL70cs/vzESWQ2H9ZjUxfKqJSXcV6xfMvyu5+GU=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.openwall.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;lists.openwall.com; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
X-CheckRecipientChecked: true
X-CR-MTA-CID: cc6684c77939eb35
X-CR-MTA-TID: 64aa7808
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E12fujD0czzKZF+/mnx/FUkpEgw6pnYl4yx77VuCXJQIWv/0hD1JLGepDHBN6iRd13QSPrCiv+rjt92W6xR0ruKqmlWvLBNKnQ1j+3t5d30B3lxLVnrzG0aYqGBsE3cWwX2A9DVIliVwfsykyVg6M58IQf6Zxt90g2Hg5kKadYtEx9GCv3DXfIg+uwHx8Dhmmt2PDnEaiV6c/4Bo3AoHtI51+86RXPh7XfjAr8vCkb/3mxR0gb7Ki1OA3zB5JV5xWx7QuZ3aE/boknhPOT1MKj0OcwFZtAsAhBlNOEpokc9N15I733Kzv9LNAX39m40wE6PinyZhaHa+ZZnFxoUGjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NXffKCVdJsUjKE9yUrpY+buHuATx7T0FPdE9nZs50nw=;
 b=Z4eSfQchURAByrWGoERGguHqXjUcbJV/AVExA+U3XTWM+86JEWE8osrzxHezhvL5EWdvYVqTSYzHBjvbiCFzPXCI/6kNQgij3krKVSfB/zjgwo8y8zxFaBHf8WSto7rCyEy7Oh3SjyyfdYpu2OSjdnBQf+hEVjkIhDHLNEudvEX0a0n3h2QqCN/EnxOngHbJEMwkpiyOEOVUOmNJ6uBDeh78pDbVuCfhnrAiTYqWrS0vPZgQ+AgzvM1oyKCJzlV5YF/ApGHWEap5Z6lcisO+0XIRqjq+dz8qFMddI8tcTnLWRBsvfoPuKWFz/jj5yefvOzP5CFUI7TivJRpPw1c8Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NXffKCVdJsUjKE9yUrpY+buHuATx7T0FPdE9nZs50nw=;
 b=vSMTNbXrQU5lwa5eZUsj8zsbVBkCsrSg4o9mnBiB0hyEeAZRDUWimd+2CenBqpwq8XpmL6f0wvcRKveRBBVEEMFoFue4/XI73ekbfeyZwMCHC0w5JAbEBwED8WTrkLeuqLJVnL70cs/vzESWQ2H9ZjUxfKqJSXcV6xfMvyu5+GU=
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
Subject: [PATCH v3 1/2] aarch64: align address for BTI protection [BZ #26988]
Date: Wed,  2 Dec 2020 08:55:14 +0000
Message-Id: <d460a4f7aa4d70cc205f08896ed50b31fcd992df.1606898457.git.szabolcs.nagy@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <ebce134991eae4261bbb32572a2062d3ca56e674.1606319495.git.szabolcs.nagy@arm.com>
References: <ebce134991eae4261bbb32572a2062d3ca56e674.1606319495.git.szabolcs.nagy@arm.com>
Content-Type: text/plain
X-Originating-IP: [217.140.106.54]
X-ClientProxiedBy: SA9PR13CA0048.namprd13.prod.outlook.com
 (2603:10b6:806:22::23) To PR3PR08MB5564.eurprd08.prod.outlook.com
 (2603:10a6:102:87::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9914e7d6-618a-41db-9b19-08d896a00e82
X-MS-TrafficTypeDiagnostic: PR2PR08MB5225:|DB8PR08MB5307:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<DB8PR08MB53072BF46EF467AE4BC72BF9EDF30@DB8PR08MB5307.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 XQm/MD2nC9jVAqH51R5remRXNMVEC+ZEC8vuP0FPtPiCjKDYxT4QJtW9W6xRWtUGwXiSBCjFPVgKw3kjSwHWeLeMVieRew979/C4K4+VzaDKfxN7rGstWPMzrUR95VP9qlVztwGR9E7+d9HNirN1YuXK1UmcR4WCRfGs2VtgiP2csdDOmNJ3wngbHEWDqogmIjAqLr+9zFALTCjVdYcLX7Cz4IkYjTOh0S0XkperrBQWCQe+ftzD2Q9zPe8azjoP5OwGyh4upVI7Bc6pBYxX45DSe+GyXPk7hUU8squfCQiUpKEUn8TIGMkyDFKrKPB4wQF5jEA9415q8fTA6jXhJPX2nE87pWMwJsJZz7Qtjb2ORxc3Q9p1jb5Grom5vzdn
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5564.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(366004)(39850400004)(396003)(6506007)(6512007)(2616005)(6916009)(2906002)(4326008)(86362001)(36756003)(44832011)(5660300002)(16526019)(316002)(956004)(83380400001)(26005)(52116002)(6666004)(8936002)(186003)(66476007)(478600001)(66946007)(69590400008)(66556008)(6486002)(8676002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData:
 =?us-ascii?Q?tf69SYnzRWkaNKv0ag04kv0/kv4K4DyvGgFFBvFHiU9lZ1p4dDN7IbD+YVxl?=
 =?us-ascii?Q?o1MoQfpB+MXuZJg5TkzM8ZaUUkWJrU6aMP21Msq7Sgf7dzi+lrQK9SSHY9H7?=
 =?us-ascii?Q?G8R3vQyFDXLCu9tZnsu+yR/BBIxjACQjDqprwu5PLf6Mg2YEZqE6FNf5Izas?=
 =?us-ascii?Q?PQpEKSdv759zyHFHJA/2e6Eq2j4wXcOcOPfImaH0V7/RT6ZhHkHTWkjjno25?=
 =?us-ascii?Q?SDbf2mPctb2PCC59uYaPL6UUrPdPKh+agt6r21+nt0zvOzR8qCevcY9L6S37?=
 =?us-ascii?Q?EwoeDXIJ/44A/zrAo521hfTZUK2DUoqZdImSU1Yvomj4/T3mOqaLNexGNiIi?=
 =?us-ascii?Q?CFJ/sqd/W6JNFvS1hH8RjxuzP1IbuTM89u+5E38I+L/JNNvBWcBUr8C6w9Rp?=
 =?us-ascii?Q?CSwLwisSke501wtPeN6X+jUhNMA4d+6mlfQVl4losBUKgsC/myANIZms1y4v?=
 =?us-ascii?Q?6iU/9Ma46PO6IlYFBOmxmScLy4nTOfIlvNcgVtSA/1v5/WVzW8ne/QH+kg6X?=
 =?us-ascii?Q?BTwVfZytHer0oBmYaGrxrBwFZYaWDb0lOtpbA59X6b1QFUq3nILm+yX+ayxo?=
 =?us-ascii?Q?YZZnCsF+PvjQ1MqAY+Qyt/7gnmYvjTBvVdbuFO+SLxPYQL28VMbdlMSD4wyu?=
 =?us-ascii?Q?VCXy5YuPYBdMKikmz8G5+9ckp9OT/GAD4xIoG2EcibtRjPNIlGWHmRnKbwJr?=
 =?us-ascii?Q?T9jrMEj8Wi6leg3lGnwqcMHbxrxpI+MTwAt7p+OA72VYyCgtgKjX23GlyvMT?=
 =?us-ascii?Q?HwSWXaEzzv+q77uVFRqlx/zsesjtSMFwLgshg6ai4+EijvRDIuGdvYpG0oB0?=
 =?us-ascii?Q?CtGPfpUrPnjYNhuihPz1C5Rp2B/Yf6KO9p5QZcxfx0p+lIEPIS3IAlabOuzq?=
 =?us-ascii?Q?eGcaQQe5AOJfmmdXLIfC8nQBdxYJ4C3PhQOAR6GFP3l4CAU8wcIa7iDw31lI?=
 =?us-ascii?Q?jW3bVEQerYkqISI3mqWq+iq8Wt5BkmqfcjJoLKaCSlctbPmUDxgCZ5Jt4n4t?=
 =?us-ascii?Q?tnYO?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR2PR08MB5225
Original-Authentication-Results: sourceware.org; dkim=none (message not signed)
 header.d=none;sourceware.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 VE1EUR03FT024.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a1bf3ed6-a11e-46b9-875a-08d896a003ba
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Ee8Jw87jw2qksJ8pH3cO6Go4MX02k1uoH82qAk/jKxdjDParUq2ph0Lv6Mhj5mRD0+2UjFryJcVdv9rfoHLCuGfwkOY5jNwlLyhk1XJPrUdUP4FmipOULyNHEf7jMuUBYus9180WoSwQuHslRcMVe4cyei2TkEGaCl28KrMA4FepCw1ujKAm6Ljn0lD0z7UbjEp32TTCUtIM2w5UtMik7VspR2t09VPiWtmYd66RR55wriTILerpssPQTKBmFJytOg4ZavPepTu2RlW2I9M+jBhvkUKxXNyMk/aXXzAAFpaDY6d+ym09mNbsY0JiKTT0K8fai89qkhWkfLg/8E/vlY+bX5eAdmxie8O7JLYEu/Vj5fszPgJVZcIWFaXj5IMWAlJFZBRrXn3EUA45WiY0aKa6gsNwWkX2NGZvDmaexhT+cJI6eJKf8h9ikq7DAg95
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(396003)(39850400004)(136003)(376002)(46966005)(8936002)(86362001)(82740400003)(36756003)(47076004)(4326008)(356005)(81166007)(34206002)(70586007)(70206006)(478600001)(6666004)(69590400008)(83380400001)(82310400003)(6486002)(26005)(8676002)(54906003)(16526019)(5660300002)(186003)(107886003)(2906002)(6512007)(2616005)(316002)(336012)(44832011)(956004)(6506007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2020 08:55:45.4029
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9914e7d6-618a-41db-9b19-08d896a00e82
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	VE1EUR03FT024.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5307

Handle unaligned executable load segments (the bfd linker is not
expected to produce such binaries, but other linkers may).

Computing the mapping bounds follows _dl_map_object_from_fd more
closely now.

Fixes bug 26988.
---
v3:
- split the last patch in two so this bug is fixed separately.
- pushed to nsz/btifix-v3 branch.

 sysdeps/aarch64/dl-bti.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/sysdeps/aarch64/dl-bti.c b/sysdeps/aarch64/dl-bti.c
index 8f4728adce..67d63c8a73 100644
--- a/sysdeps/aarch64/dl-bti.c
+++ b/sysdeps/aarch64/dl-bti.c
@@ -20,19 +20,22 @@
 #include <libintl.h>
 #include <ldsodefs.h>
 
-static int
+static void
 enable_bti (struct link_map *map, const char *program)
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
+	unsigned prot = PROT_EXEC | PROT_BTI;
 	if (phdr->p_flags & PF_R)
 	  prot |= PROT_READ;
 	if (phdr->p_flags & PF_W)
@@ -48,7 +51,6 @@ enable_bti (struct link_map *map, const char *program)
 				N_("mprotect failed to turn on BTI"));
 	  }
       }
-  return 0;
 }
 
 /* Enable BTI for MAP and its dependencies.  */
-- 
2.17.1

