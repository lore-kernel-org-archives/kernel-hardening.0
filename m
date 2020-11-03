Return-Path: <SRS0=G3CT=EJ=lists.openwall.com=kernel-hardening-return-20323-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7E0C2D0A3
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Nov 2020 10:26:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6E1AA206F8
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Nov 2020 10:26:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="Eq8WzEuB";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="Eq8WzEuB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E1AA206F8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20323-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13653 invoked by uid 550); 3 Nov 2020 10:26:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13629 invoked from network); 3 Nov 2020 10:26:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DA/uKEqYFIqv4yw/4vuKz0cdGhH9H2bnFuZnjVQ/Wbc=;
 b=Eq8WzEuB0TdDN9OLkTfgMfcLPE7sk9093wOs04dOGlFUd4eVfBKaQmommKTwuFZUUNS2wAKy6uRVxz32FZSGlegzEax/rIE2WhQfS8sLr25mxqDgTgPNkW0N0kSBGu5rO0vP7zhvvdou9rQjIGDMW1B5nKVGuEGPb5yVTUFnNAI=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.openwall.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;lists.openwall.com; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
X-CheckRecipientChecked: true
X-CR-MTA-CID: 1b7fbd5d4e494ead
X-CR-MTA-TID: 64aa7808
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KKyYgGMMKnI/dqhwGwOJ83t3I8qrN2728qtg6W6pgxyVz43txLL5KiRmC8aYXkqX40vaLyJnB9scgmb/1zfVv+1gFsafEaGWJarKMJNyvJpmVHJ22JegV/Wq+vbYLX6ensCQU/XkgN6OZJk1zit2nGbkQybbGCBpMeY6+n2iMPpuo8dd6K+mdB0w6/mTftgPBGp1bxe6HfwkOwVi8no5dicCqDeWJU+qEpmbNZPtcCua45ksq2FCEcoEznLVlb2c4EZy1YbkFJBMxlPkABZoRZ1EMEnHI4q06dX/PWRmNdPYi6PyDJAOISi9AeZtglV6qmMJDomeLKfl+6LOSIrLxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DA/uKEqYFIqv4yw/4vuKz0cdGhH9H2bnFuZnjVQ/Wbc=;
 b=Ki24zoZFsLrzrB/EJMZn407u9N0uDZdI7wCXYcogz4RwNpVa4kHUWH6nBLNlJJqZEbmxLN75FX7loYhTR30UwqgC/dPOOwSazJUeJM4nse0IAmtFftgJhahMdpQmbzQWarQ+YODYT8iu7vtDjPT5UiZ9w+FU1W4+6IhPeQ2aSWMKg79it2Ckl6gEAMDyH6AwmsC5U26SlMOgqJHWVKvehKKf0WII47+/s7AQL0+dptFfk40RuI1SojpfxQTEnjGfBF7egUDSdIV0fIeT1+YM9M2suCcmewzvwzRydXStJJ2Q6KshIbve5L0C4CFUl2s4VW7b6iuBS63CBYRrAELgvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DA/uKEqYFIqv4yw/4vuKz0cdGhH9H2bnFuZnjVQ/Wbc=;
 b=Eq8WzEuB0TdDN9OLkTfgMfcLPE7sk9093wOs04dOGlFUd4eVfBKaQmommKTwuFZUUNS2wAKy6uRVxz32FZSGlegzEax/rIE2WhQfS8sLr25mxqDgTgPNkW0N0kSBGu5rO0vP7zhvvdou9rQjIGDMW1B5nKVGuEGPb5yVTUFnNAI=
Authentication-Results-Original: sourceware.org; dkim=none (message not
 signed) header.d=none;sourceware.org; dmarc=none action=none
 header.from=arm.com;
From: Szabolcs Nagy <szabolcs.nagy@arm.com>
To: libc-alpha@sourceware.org
Cc: Jeremy Linton <jeremy.linton@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Florian Weimer <fweimer@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Salvatore Mesoraca <s.mesoraca16@gmail.com>,
	Lennart Poettering <mzxreary@0pointer.de>,
	Topi Miettinen <toiwoton@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org
Subject: [PATCH 1/4] elf: Pass the fd to note processing [BZ #26831]
Date: Tue,  3 Nov 2020 10:25:58 +0000
Message-Id: <31936e4acedb265ad49d04f7789bef09d6578448.1604393169.git.szabolcs.nagy@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1604393169.git.szabolcs.nagy@arm.com>
References: <cover.1604393169.git.szabolcs.nagy@arm.com>
Content-Type: text/plain
X-Originating-IP: [217.140.106.54]
X-ClientProxiedBy: SN6PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:805:de::32) To PR3PR08MB5564.eurprd08.prod.outlook.com
 (2603:10a6:102:87::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 49168d11-3278-4feb-4f42-08d87fe2e926
X-MS-TrafficTypeDiagnostic: PA4PR08MB6223:|VE1PR08MB5229:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<VE1PR08MB52295E999E7E50D303A8D8D1ED110@VE1PR08MB5229.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 AaxZiJ7jdnYp8oYD2ZDBf5QY4DECjO04ey3y7RDl0oTDJTGmqCY+xJtoeab1SQ/opSeIsmOdH95B6FXKdajRMViBb6frjEKss63aZKt6svL+EwUnYdDYtQa9c+GZsbJJhRzQzQxLR500HnSBqbA1vqByjX1zi4EWyFnhAwsrHgOoVYuiSW3qC+pHZrMbnyd/YdqiVcv8tIP9ZUtNWc3Qs7W6rVqSo4fr93kioTeb+kgoYW5D2ysQFwTyhqtgBSvbMGNqdna38Kk6x1cZC3ts6J9vxdHxltY8oD2I0wznGuA5cvBr2sP4vBTAk4UGe7B2VkNJwFCYd6nBmyrFT5o99pVug4VYnL5i03uDM78aIdLVY85JdEF+I2l1GkHqHl8v
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5564.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(5660300002)(2906002)(66556008)(6506007)(8676002)(66946007)(478600001)(54906003)(66476007)(6666004)(6486002)(4326008)(6916009)(6512007)(69590400008)(186003)(16526019)(2616005)(7416002)(36756003)(956004)(8936002)(86362001)(44832011)(83380400001)(52116002)(316002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData:
 sDODfNVK6I1Y/maSwD9fiqG+WsIIHDnTIDBUyAnsUO3P9ydzjO8R2e3ZHV6s3M+/aeO8WwB5dyZpuEa+CnFqYwJf4+df5QhbII+ZXY7FEAQsH120aHjz1GRbFAv3ftwh2udUaQbBtzWZDCPjNCPl6SMgucF2FCyXAIj/PaGF5skh/5+mhok/QsBP1LHtQhdk9y18xLf30TZXUCcZ5mcjrFe6viDgSWbjvB6R2rhHqtS/iTOixIa/KWzSoIdaY5Lo9cfss+5D5FGaycYr4sderddscABk9SD1cOGahFxf8a7lERQpCQMSyVSpv4mWweFo811P3SAFTrQu1GXFk77hQnIVMj7eoydL/vzATdYpc1i44otgFkMGkRJQy2lH4wjaX7BvApHbxoEvsUQ5S9ky+Bvx45tzPIh2dSNn8kv794dojyEOU8nv8MJg5uKyRcEF3DhFJlbtNbeRJfTVxiD/qtOcALiPGhprsvxXMOfuxgIU5xgsdW341fhSywjjnAxIeaIsLrSgy6obGJAfnq61CWIM3NJ5FT41eRnZbEeL3+k9Y2WT62vRWY21dKX4Jfw0niZ7luXX8KNJvBt+lKNXLyqotlGjHZnfeK/ZIGJUKilvH3VSP5DdgjG4UecSp0rC9GAEHFkWIDbmHAv17cVF0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6223
Original-Authentication-Results: sourceware.org; dkim=none (message not signed)
 header.d=none;sourceware.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5EUR03FT015.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8914356f-c88b-4471-257d-08d87fe2e2d7
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	s5HRwqG9gUAwTW9y1X/jXHhEMqVgP/nwZts3UANnljlCMhzicGG/Ar5X5LPTdKl4n0BHQCdE/4HPJWQWCXO/WKRGIvDcTCMQuSez67Clr95uvlbi8zM/9DXVdijQkB2eeG179TWUEaVr46SRkmVEUtNxd2YMr9XhhtkyBd1V2Zl1JuKD6Jhh1uh1w/uW/XgDChTf/McHg4lJMRZDxjPkN9OcyBnhdm584U75LkwSPJn+VTN8olivZcgI98zr95PGxwXPMyI/HjNR6SL6fP4dwPnfEsa/PAABOPR3qQ7pGGHBt4iHFGLUMRs6Kb7qIt/CPg5xGkwvFNOft8vVnFWAxwQkr6D7I8QL0BT5c5JNeoo5zepbCCynKslefmXPIsVW0MtlaDYUhB4XnZYZ+DjSjpisKSwrYCGJTofEpv4jRPG6wnV5eXwivh2g4iX11TlY
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(46966005)(86362001)(478600001)(186003)(6666004)(36756003)(44832011)(107886003)(6486002)(2906002)(54906003)(356005)(316002)(83380400001)(16526019)(70586007)(336012)(8936002)(69590400008)(70206006)(26005)(82740400003)(2616005)(956004)(82310400003)(4326008)(8676002)(6506007)(81166007)(47076004)(6512007)(34206002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 10:26:22.3803
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49168d11-3278-4feb-4f42-08d87fe2e926
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5EUR03FT015.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5229

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
index f3201e7c14..ceaab7f18e 100644
--- a/elf/dl-load.c
+++ b/elf/dl-load.c
@@ -861,10 +861,12 @@ lose (int code, int fd, const char *name, char *realname, struct link_map *l,
 
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
@@ -911,7 +913,7 @@ _dl_process_pt_gnu_property (struct link_map *l, const ElfW(Phdr) *ph)
 	      last_type = type;
 
 	      /* Target specific property processing.  */
-	      if (_dl_process_gnu_property (l, type, datasz, ptr) == 0)
+	      if (_dl_process_gnu_property (l, fd, type, datasz, ptr) == 0)
 		return;
 
 	      /* Check the next property item.  */
@@ -1266,10 +1268,10 @@ _dl_map_object_from_fd (const char *name, const char *origname, int fd,
       switch (ph[-1].p_type)
 	{
 	case PT_NOTE:
-	  _dl_process_pt_note (l, &ph[-1]);
+	  _dl_process_pt_note (l, fd, &ph[-1]);
 	  break;
 	case PT_GNU_PROPERTY:
-	  _dl_process_pt_gnu_property (l, &ph[-1]);
+	  _dl_process_pt_gnu_property (l, fd, &ph[-1]);
 	  break;
 	}
   }
diff --git a/elf/rtld.c b/elf/rtld.c
index 5d117d0d2c..6ba918338b 100644
--- a/elf/rtld.c
+++ b/elf/rtld.c
@@ -1531,10 +1531,10 @@ dl_main (const ElfW(Phdr) *phdr,
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
index 382eeb9be0..702cb0f488 100644
--- a/sysdeps/generic/ldsodefs.h
+++ b/sysdeps/generic/ldsodefs.h
@@ -925,8 +925,9 @@ extern void _dl_rtld_di_serinfo (struct link_map *loader,
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

