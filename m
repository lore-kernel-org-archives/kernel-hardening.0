Return-Path: <SRS0=yLi6=FB=lists.openwall.com=kernel-hardening-return-20465-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50FA6C2D0E4
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Nov 2020 13:21:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1F3FB22242
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Nov 2020 13:21:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="rki/Ir58";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="rki/Ir58"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F3FB22242
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20465-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17769 invoked by uid 550); 27 Nov 2020 13:21:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17737 invoked from network); 27 Nov 2020 13:21:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBpOGzKrR218CsAMW7ki/EWPc6Uz5KXS+PBRk1M3+bg=;
 b=rki/Ir581+lLxNNmGwUMQO05FbHBw8o/NToB3tbMUOuOcnWLlQSZ4QKTtEmstxI4iel3dsaqo74fSa5t0RXgYJWq51fmxDCOIKKLisCResqS2jgR5w6rMJVarLA7ZdqT7MAcDgruswaYiIDeDHhO6b3YPe8cCRQfN+ZHw6TWH9M=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.openwall.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;lists.openwall.com; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
X-CheckRecipientChecked: true
X-CR-MTA-CID: af772a76cb38de87
X-CR-MTA-TID: 64aa7808
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ceuY7EflCuKkhAHmQ8DiMeZurh2vyKW7l8xQNd7dvFLnIKaRMZk50LQn5VfWJJRiNgcWt+owWYKQ1iOLuji5KM69XqjRSPZustAl5K60aP0YB5M4Ocmu9wgkrnX2EDJDDqy9xtpqUtAAtwBbF5CPeEM4MeeuQOIuCeWkPitz/yVQ07FzrgtqHlNxgCd3YNTQNf/pgHQsJzIEugNFWKZPT7xBpnLKcqt13ITkpOBjK8bnV752g3suasXbmq2sYILsR+pd68d1zZLT468srgUY48kOzymNHGU2r2v45eJ7KsWvRER1hgzKlkzqW8vfcAgUWsUdE9lb65dbS93JhaaLnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBpOGzKrR218CsAMW7ki/EWPc6Uz5KXS+PBRk1M3+bg=;
 b=hkzJ0so75df+2c/JlJMDolm0XKcgW5A6uZl14v19RWx9+g6n2gPXwa1gukMky8JonTPGyU2DBQEeIAUHnnb92PrSlrvkTumrq2Oh2DivdmwiM1jIvyUl+6/f4YWVzkqqJY6WI0GmBJeBD8R77VBD4OOTmKdSP1U8Nn25r6zzxHbXRuHCifn/ruArMwA6DHcAWj/MWGeSztTqXJ9T27qNh6rjGOuRUuT7LEqaqMFZenbWEp7y1Wdr9S124S8OXFb9/2I6OxDN6c/jfpM5+6K7FGG2wTYbQnQ9PPquv16jCDDdsnV90prQ4bnf4fdu4fF6x6uLYvhls0iQYNassSxFnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBpOGzKrR218CsAMW7ki/EWPc6Uz5KXS+PBRk1M3+bg=;
 b=rki/Ir581+lLxNNmGwUMQO05FbHBw8o/NToB3tbMUOuOcnWLlQSZ4QKTtEmstxI4iel3dsaqo74fSa5t0RXgYJWq51fmxDCOIKKLisCResqS2jgR5w6rMJVarLA7ZdqT7MAcDgruswaYiIDeDHhO6b3YPe8cCRQfN+ZHw6TWH9M=
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
Subject: [PATCH v2 5/6] elf: Pass the fd to note processing
Date: Fri, 27 Nov 2020 13:21:15 +0000
Message-Id: <a23246987ec0a8b307a9a171193464b74a7cb416.1606319495.git.szabolcs.nagy@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606319495.git.szabolcs.nagy@arm.com>
References: <cover.1606319495.git.szabolcs.nagy@arm.com>
Content-Type: text/plain
X-Originating-IP: [217.140.106.54]
X-ClientProxiedBy: DM6PR01CA0018.prod.exchangelabs.com (2603:10b6:5:296::23)
 To PR3PR08MB5564.eurprd08.prod.outlook.com (2603:10a6:102:87::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: db359400-eafe-44ab-835b-08d892d75e16
X-MS-TrafficTypeDiagnostic: PA4PR08MB6014:|DB7PR08MB3065:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<DB7PR08MB3065556BAC4FB32F3CF7A6C1EDF80@DB7PR08MB3065.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 ChnA9nbTd6Ke9iN2cUb1YDhb9FUR1mjCFjQo3SZXjPaQExKKsKXoQnw0j5zSx7ZRnh69YWuNXagC7yHRgxntr7OO3Vnqe0IpYuspE/taovZrHF2mu+5LrTG6hbX4ilYbLHj1vGQyJsMhpENFCxEiI7enAjdqaHRJCRlIgZPHjD8jqHZha75U7oM7esNBGKzP4aFpD5jVqM1e5ciQehGvo5Rbxe+ZudVcPsBRuRo515daX3VLNyOQIXfYNDEhM1RwBD+gpIPx/Vt5U1jSPaBRE4UloHjswgnagLywQRFvw/DMQnyLnse0KUK/cmL3MT1J76mHOZYPWUxFGlDFWdoEIkJ8Z8Xd/xjH2LkxHPtX5woCQSJJSHjolaApGUKPVHER
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5564.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(4326008)(54906003)(69590400008)(6916009)(6512007)(36756003)(6486002)(6666004)(316002)(478600001)(5660300002)(2616005)(86362001)(44832011)(2906002)(956004)(8936002)(16526019)(186003)(26005)(8676002)(66476007)(66946007)(6506007)(66556008)(52116002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData:
 =?us-ascii?Q?steav44q3620kaxrbs7+gVB1Li8QDGoSj0u+0lUpKXbPdZZLw7+t5LGgjwG4?=
 =?us-ascii?Q?o5OuE70GeRGTPiXu1tU8EezZ4/o34e889NLc1Pc/8vJ1dJXULPz3fJoi6tWD?=
 =?us-ascii?Q?M2BbTpCjNgdMOvwkVs7Mg/kFc1bIiJLmeKmY57bwiftoJRSj3dnoPIOtwHzF?=
 =?us-ascii?Q?r8V6uIzDZ+FQP/6/1tvOMt8/UcGuI96CQj6mfrH5FCvIhLWRXWesDRWvWXdX?=
 =?us-ascii?Q?VG6Zsefugaf03AcmRXDoDiWSyOJUeqFfxSLeAxk4wWuFQNpTN/IXAQWESN32?=
 =?us-ascii?Q?opiGfomSxjUdAtgyic3ABpEgFQ2NXw95aSj0WDZHHlHmcPqLNeHoNaVPUeeG?=
 =?us-ascii?Q?V8M+4RDjjQvndaikNiGFsFbQ8VOSckFq3owOoyqgY5BZ14ZuHfdrN7wl0o8E?=
 =?us-ascii?Q?Ooj7rS8KVacVDFq6U/C3QJUm80ljfn+fUkpCNxeiKITXiwrXbbsj+q18fyus?=
 =?us-ascii?Q?1RBUiiHoTmfPMIY4MK/GQXVZi0JoqVU/KnS5If9KeDE/JKugeD5ph9tTwqgm?=
 =?us-ascii?Q?VdiQM8tQ1W5DdZxzDoh0WHsR8qPYe9kMYHr5Uh1q11U27+cl8QcCMS5zMjz7?=
 =?us-ascii?Q?+reW14tI28ruOTNTi3g9R7ZT49hkE11+5QtSrdB4gPniUnu4QmMcZvFABJ9E?=
 =?us-ascii?Q?VRtLK8Z2KEFQPesLZ12R42w3I+uI+9cAm4Vb6ESwE/ARCGDpXuXR7XYNfu44?=
 =?us-ascii?Q?LCCnqLsN1GW4zvo4G8f1ekoFN9Owlt8LX6m7rC7act9JZRtqPUAYIZP0FMqD?=
 =?us-ascii?Q?mH3Gi0iCqrLAb9a9qC1V34zLuOFcQdmz0XNh3ppTIVUPOoiXzJNRQZtUc3Tz?=
 =?us-ascii?Q?R5kkL3cuJEyCUBR0NhNOEnz0OaE4/9m33rkpjxp+/qiefhIGD6TwG9ovoGUa?=
 =?us-ascii?Q?3HUB60jrLgmeDbTFLr7wP5fFYuxEd0hMaAGyW5Pam1uSTRBoEeWDbvqGIclF?=
 =?us-ascii?Q?HoLSJ2ICHjaEZv8K4sR0FaWwUN2eQzoHRZ0okrd8xor3YQ6A4t5NBnE8B2KC?=
 =?us-ascii?Q?ft5a?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6014
Original-Authentication-Results: sourceware.org; dkim=none (message not signed)
 header.d=none;sourceware.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM5EUR03FT025.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7714e35c-d348-4d9f-6b08-08d892d7592f
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QEnTMIoq+56x3H5bXSL0Uhr9YJDQZ4nNQ5wMaJ7DRn4+z3mJJzScwqeXxNUdTKy7KXDfsVxoBwCo4aR6GY5OZsBiBiEeMETZ7ILv0k60AYBuwAdWTjRkCfFSkI4qETMoZBHmgND/BMZn6/+7tjfDpVBvHVNuOjcBIBUIP3+9BQ/mhmL8kvqVOQDta/yEFhuZ3UERazSgDJbTArpXTfSpwjpBtFhVG1n45LRGVnjGhN4r5CUm3vhIxfWoHC6wyZs/IGy4SFh8Lq1IzUFXvw6EdivgdZvK+FdPIRcxWc4nRUO/OdcfedhkADhkfdgW6uocVS83Qj/5qABu03UU7+GlEfTYz3dQ+pDZOeciO760qIPNPOR45W2oCfAhdEyXVm6u7JNgRWuIYwCmu8avVeeOQNeMilKrcHBP63RbILPmknK/qaTySlwNY/7TpU3EGLtw
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(46966005)(2616005)(336012)(54906003)(47076004)(44832011)(316002)(2906002)(81166007)(82740400003)(69590400008)(186003)(356005)(26005)(36906005)(16526019)(83380400001)(8676002)(70206006)(86362001)(82310400003)(6506007)(6512007)(956004)(107886003)(36756003)(478600001)(8936002)(70586007)(34206002)(4326008)(5660300002)(6666004)(6486002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2020 13:21:36.6523
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db359400-eafe-44ab-835b-08d892d75e16
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM5EUR03FT025.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3065

To handle GNU property notes on aarch64 some segments need to
be mmaped again, so the fd of the loaded ELF module is needed.

When the fd is not available (kernel loaded modules), then -1
is passed.

The fd is passed to both _dl_process_pt_gnu_property and
_dl_process_pt_note for consistency. Target specific note
processing functions are updated accordingly.
---
 elf/dl-load.c              | 12 +++++++-----
 elf/rtld.c                 |  4 ++--
 sysdeps/aarch64/dl-prop.h  |  6 +++---
 sysdeps/generic/dl-prop.h  |  6 +++---
 sysdeps/generic/ldsodefs.h |  5 +++--
 sysdeps/x86/dl-prop.h      |  6 +++---
 6 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/elf/dl-load.c b/elf/dl-load.c
index b0d65f32cc..74039f22a6 100644
--- a/elf/dl-load.c
+++ b/elf/dl-load.c
@@ -837,10 +837,12 @@ _dl_init_paths (const char *llp, const char *source)
 
 /* Process PT_GNU_PROPERTY program header PH in module L after
    PT_LOAD segments are mapped.  Only one NT_GNU_PROPERTY_TYPE_0
-   note is handled which contains processor specific properties.  */
+   note is handled which contains processor specific properties.
+   FD is -1 for the kernel mapped main executable otherwise it is
+   the fd used for loading module L.  */
 
 void
-_dl_process_pt_gnu_property (struct link_map *l, const ElfW(Phdr) *ph)
+_dl_process_pt_gnu_property (struct link_map *l, int fd, const ElfW(Phdr) *ph)
 {
   const ElfW(Nhdr) *note = (const void *) (ph->p_vaddr + l->l_addr);
   const ElfW(Addr) size = ph->p_memsz;
@@ -887,7 +889,7 @@ _dl_process_pt_gnu_property (struct link_map *l, const ElfW(Phdr) *ph)
 	      last_type = type;
 
 	      /* Target specific property processing.  */
-	      if (_dl_process_gnu_property (l, type, datasz, ptr) == 0)
+	      if (_dl_process_gnu_property (l, fd, type, datasz, ptr) == 0)
 		return;
 
 	      /* Check the next property item.  */
@@ -1379,10 +1381,10 @@ cannot enable executable stack as shared object requires");
     switch (ph[-1].p_type)
       {
       case PT_NOTE:
-	_dl_process_pt_note (l, &ph[-1]);
+	_dl_process_pt_note (l, fd, &ph[-1]);
 	break;
       case PT_GNU_PROPERTY:
-	_dl_process_pt_gnu_property (l, &ph[-1]);
+	_dl_process_pt_gnu_property (l, fd, &ph[-1]);
 	break;
       }
 
diff --git a/elf/rtld.c b/elf/rtld.c
index c4ffc8d4b7..ec62567580 100644
--- a/elf/rtld.c
+++ b/elf/rtld.c
@@ -1540,10 +1540,10 @@ dl_main (const ElfW(Phdr) *phdr,
     switch (ph[-1].p_type)
       {
       case PT_NOTE:
-	_dl_process_pt_note (main_map, &ph[-1]);
+	_dl_process_pt_note (main_map, -1, &ph[-1]);
 	break;
       case PT_GNU_PROPERTY:
-	_dl_process_pt_gnu_property (main_map, &ph[-1]);
+	_dl_process_pt_gnu_property (main_map, -1, &ph[-1]);
 	break;
       }
 
diff --git a/sysdeps/aarch64/dl-prop.h b/sysdeps/aarch64/dl-prop.h
index b0785bda83..2016d1472e 100644
--- a/sysdeps/aarch64/dl-prop.h
+++ b/sysdeps/aarch64/dl-prop.h
@@ -35,13 +35,13 @@ _dl_open_check (struct link_map *m)
 }
 
 static inline void __attribute__ ((always_inline))
-_dl_process_pt_note (struct link_map *l, const ElfW(Phdr) *ph)
+_dl_process_pt_note (struct link_map *l, int fd, const ElfW(Phdr) *ph)
 {
 }
 
 static inline int
-_dl_process_gnu_property (struct link_map *l, uint32_t type, uint32_t datasz,
-			  void *data)
+_dl_process_gnu_property (struct link_map *l, int fd, uint32_t type,
+			  uint32_t datasz, void *data)
 {
   if (type == GNU_PROPERTY_AARCH64_FEATURE_1_AND)
     {
diff --git a/sysdeps/generic/dl-prop.h b/sysdeps/generic/dl-prop.h
index f1cf576fe3..df27ff8e6a 100644
--- a/sysdeps/generic/dl-prop.h
+++ b/sysdeps/generic/dl-prop.h
@@ -37,15 +37,15 @@ _dl_open_check (struct link_map *m)
 }
 
 static inline void __attribute__ ((always_inline))
-_dl_process_pt_note (struct link_map *l, const ElfW(Phdr) *ph)
+_dl_process_pt_note (struct link_map *l, int fd, const ElfW(Phdr) *ph)
 {
 }
 
 /* Called for each property in the NT_GNU_PROPERTY_TYPE_0 note of L,
    processing of the properties continues until this returns 0.  */
 static inline int __attribute__ ((always_inline))
-_dl_process_gnu_property (struct link_map *l, uint32_t type, uint32_t datasz,
-			  void *data)
+_dl_process_gnu_property (struct link_map *l, int fd, uint32_t type,
+			  uint32_t datasz, void *data)
 {
   return 0;
 }
diff --git a/sysdeps/generic/ldsodefs.h b/sysdeps/generic/ldsodefs.h
index b1da03cafe..89eab4719d 100644
--- a/sysdeps/generic/ldsodefs.h
+++ b/sysdeps/generic/ldsodefs.h
@@ -933,8 +933,9 @@ extern void _dl_rtld_di_serinfo (struct link_map *loader,
 				 Dl_serinfo *si, bool counting);
 
 /* Process PT_GNU_PROPERTY program header PH in module L after
-   PT_LOAD segments are mapped.  */
-void _dl_process_pt_gnu_property (struct link_map *l, const ElfW(Phdr) *ph);
+   PT_LOAD segments are mapped from file FD.  */
+void _dl_process_pt_gnu_property (struct link_map *l, int fd,
+				  const ElfW(Phdr) *ph);
 
 
 /* Search loaded objects' symbol tables for a definition of the symbol
diff --git a/sysdeps/x86/dl-prop.h b/sysdeps/x86/dl-prop.h
index 89911e19e2..4eb3b85a7b 100644
--- a/sysdeps/x86/dl-prop.h
+++ b/sysdeps/x86/dl-prop.h
@@ -145,15 +145,15 @@ _dl_process_cet_property_note (struct link_map *l,
 }
 
 static inline void __attribute__ ((unused))
-_dl_process_pt_note (struct link_map *l, const ElfW(Phdr) *ph)
+_dl_process_pt_note (struct link_map *l, int fd, const ElfW(Phdr) *ph)
 {
   const ElfW(Nhdr) *note = (const void *) (ph->p_vaddr + l->l_addr);
   _dl_process_cet_property_note (l, note, ph->p_memsz, ph->p_align);
 }
 
 static inline int __attribute__ ((always_inline))
-_dl_process_gnu_property (struct link_map *l, uint32_t type, uint32_t datasz,
-			  void *data)
+_dl_process_gnu_property (struct link_map *l, int fd, uint32_t type,
+			  uint32_t datasz, void *data)
 {
   return 0;
 }
-- 
2.17.1

