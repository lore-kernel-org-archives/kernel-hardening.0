Return-Path: <SRS0=oBo2=FB=lists.openwall.com=kernel-hardening-return-20464-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DADDC2D0E4
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Nov 2020 13:21:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C8C762222C
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Nov 2020 13:21:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="v2zbgEDQ";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="v2zbgEDQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8C762222C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20464-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15920 invoked by uid 550); 27 Nov 2020 13:21:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15888 invoked from network); 27 Nov 2020 13:21:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1jU0aMUj4QfK8EyRD8DvcTi5AwkXzK9UGUF9Nf79/g=;
 b=v2zbgEDQfnkZznT5ohEdE1fg1znGlFpYrUJMX6R5umj5T5vE1qTEZnPP+1Ki84gp4RFQ3XcppV0jtzfjnfegC4FpfiIUUlDnLB5FVCuYG0k41GFqPNpiC2D390y13h+gQQhLpR8f5/IpzzJQGI8R2ttVv6rmmJAYIcIDTc5eqRY=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.openwall.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;lists.openwall.com; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
X-CheckRecipientChecked: true
X-CR-MTA-CID: ae0120a5a66a482b
X-CR-MTA-TID: 64aa7808
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Epwm4JhQr0QvK1ShXqOrTtIVSSpyD2ikjdRanp1E5C5+eAAfvfgkmXxSD6I477wSRYryU153ejgUrAa0d42RJHH5A5wprF9wLpPAIAM43yfBQgC5Ezc3MpWMRjKhcM7iHm3ubcGymYbrLGZS7DnsoLmjl98MivistEqG+lzA2geX/V/QRxE3oSJpaZwqcNFU57Opa2wC2zNjeFOKVuaCiYzppFevFQaXLytzSc01wfmhPoLNlHpvGJiYHX3ZEJfe0f7TQIJA6eGtVnQNsuAi7u7AuQCeP2uUAeG/hu93vOQwFNMzrnG2tLRiaQypIBf82ogfUqFQlq/2ilFn9kcHFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1jU0aMUj4QfK8EyRD8DvcTi5AwkXzK9UGUF9Nf79/g=;
 b=n+Vrzwe2Iu52oJVldbv0ZPmgzJwxVYSocxzTKXfhMsfnB3ypsGjsjirkLfNMCbNtWeQfxVddRk73vhKRzg7XIKmvk1XCVBiSR4SyqvyZ4JdBjZvEG3Mo+dU4wC1FZNG0q3VUMDIXqa0rRE+PJfpLcKFXbPTuccAyDzaJeuSlD+UKm0d7DN5pU5agtPaMDRNHtzQbX7f+/UCnUEI1hqp0drdDsNfEzC432teEpABXOdg6nMPNzP9TWC4zPpKD4Pg5eL7IcZhDH7rv97fUvL/CSlPl48CmWjbiDlQA/2u8zyoS1e58Yb649vXyezH5J+KrvJQCHKxO8rGd9P1QTV+M3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1jU0aMUj4QfK8EyRD8DvcTi5AwkXzK9UGUF9Nf79/g=;
 b=v2zbgEDQfnkZznT5ohEdE1fg1znGlFpYrUJMX6R5umj5T5vE1qTEZnPP+1Ki84gp4RFQ3XcppV0jtzfjnfegC4FpfiIUUlDnLB5FVCuYG0k41GFqPNpiC2D390y13h+gQQhLpR8f5/IpzzJQGI8R2ttVv6rmmJAYIcIDTc5eqRY=
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
Subject: [PATCH v2 4/6] elf: Move note processing after l_phdr is updated
Date: Fri, 27 Nov 2020 13:20:56 +0000
Message-Id: <36d457074f389740b45afc4f9c6d124046f8352b.1606319495.git.szabolcs.nagy@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606319495.git.szabolcs.nagy@arm.com>
References: <cover.1606319495.git.szabolcs.nagy@arm.com>
Content-Type: text/plain
X-Originating-IP: [217.140.106.54]
X-ClientProxiedBy: LO2P265CA0434.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::14) To PR3PR08MB5564.eurprd08.prod.outlook.com
 (2603:10a6:102:87::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: abeb4e81-36a5-4584-5157-08d892d74e2b
X-MS-TrafficTypeDiagnostic: PA4PR08MB6014:|AM0PR08MB4276:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<AM0PR08MB4276537E3D1F36E74D368937EDF80@AM0PR08MB4276.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 4qFAq0tSahHcXScZ4dLCssSeJ3HuLehp2jF9u+cjWLCThQAxXvzNPSngtA+/7v7a4a/J6BgRmdPM3NSIRb5AaxbmFaZ+1eovTNMriswmoCO4RqooiK9C8KhlFpK22eoeD9TtMiOig2/H8gYyxB0J5HKzLXUCctteSrX4agThhYQ8Qd6a9+veyqePM58aY8t0DJyIg4KYL60WPdlsEdZLL+pRCmNlgoIkau3Ob9I8OB2DMRNe0+SjDheqwnKDteeYICA6jCYrxxYc0Jz+BxV/c/Gefvs40l9gwEjyUZ9KmHjv2iTE4aaVF18qCouJOf5ChJaogi/AcTZ/r9AqK2wgCW/KZxUw8aYWnYk9Hd0yyNzE1TNJTVWqtPRkOSLM2nsu
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5564.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(4326008)(54906003)(69590400008)(6916009)(6512007)(36756003)(6486002)(6666004)(316002)(478600001)(5660300002)(2616005)(86362001)(44832011)(2906002)(956004)(8936002)(16526019)(186003)(26005)(8676002)(66476007)(66946007)(6506007)(66556008)(52116002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData:
 =?us-ascii?Q?2sAd3LJe8SPRFyw/KkmDjGjzl+CVO6DqB15QnRoLKp+B8oLgCXE/y3WAWB2Q?=
 =?us-ascii?Q?PfOgm+O8O02cDjhpNAQWYjJfJYLOgNg5NqNGL3by1INuogOPF+r2UciVEa6q?=
 =?us-ascii?Q?bdWISfHx5++E6AzFrQSjJPnWKcwEvTiH5NKGwUqkAgkuI+bt7bsmR1DJbCoh?=
 =?us-ascii?Q?E1lwlEq1dKyT7sV7BqCDAvO7muFBK2YEo4OYc/NxMkYeCqhWqvG6ES3KHRRe?=
 =?us-ascii?Q?xShDqLitDJjYsaBlMXpWMnQ4DoB663yYfBl8XL5H6/jLEVCWDggl1h1bSzl3?=
 =?us-ascii?Q?D+S4rTl/P0PjE/tn0X2eONP0ZYzRCxuvHTeMGvxt02+m8xciaP2e+Ps/Oldl?=
 =?us-ascii?Q?EZrDy3bB6++vZH2IAG2en8FPOkuew0xitatSwyTswjb0BKgq5QE+ZE/ldzZi?=
 =?us-ascii?Q?nKWgVefliS6THEKvZgO4Pyr8+Odgiff+7LauNj3Nv/CmW8EmaCQuKMKDlSZt?=
 =?us-ascii?Q?GopT9cY0ij5KSHL1UWBPJ5lhez7nob93ekRg2/HZ1nUKcYCEbfCtS1SK0cS/?=
 =?us-ascii?Q?3WoL+q1aHcU3gZQYknNU+NJ/OPPooM/+V7poaZy+YKUmxnFICQ1AFOlvpSky?=
 =?us-ascii?Q?TNAI5vKO+iQPXbjczo9KcdkI5fMkrpkOC4tSufGBb+WHIEtLLz/a+Ilohz3w?=
 =?us-ascii?Q?iFo9nOX+3WheY6W49l3ULfVJTXH9wXBrbJE7s/Gj1HD/T+zqKlq1G/3lHevV?=
 =?us-ascii?Q?4iYmCmX3lRh8nIEBASmUcc1E3GzOLh9xEOHQF8Qj0rXqU/Y2cnXnfyPpw/sX?=
 =?us-ascii?Q?2pKkL8RCKxn/38qpy+cihaYE5aMrLqeycHy+pwI99h5B3vKo9Z5svCT4/2MI?=
 =?us-ascii?Q?9CCOyMtBowlwptQFlVNDXhECNk+LdlkMh9ykzuDbSPtAzY7IUFqWMLD/eSfi?=
 =?us-ascii?Q?Eg8RDjxlWvhuzP+hSTNLbJuwAtBWeV1CrLgowH7kwz0hd1Au0PnaqPc3XJNW?=
 =?us-ascii?Q?dxhpqzXd3mrb5/aWvJR1T0ePG+2hhCtNCvaFEqwtVyJFu6tW81jAXyIM2AfI?=
 =?us-ascii?Q?Im5q?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6014
Original-Authentication-Results: sourceware.org; dkim=none (message not signed)
 header.d=none;sourceware.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 VE1EUR03FT040.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e10275c7-e43e-4b10-7585-08d892d749e5
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Pno/A8Xvl+RO5kj2R+u9t0lCPLcSuVPaCcFzsmarDSAztUeKIg89+kBkEHMH7jpTxYaZn50Hte3fOsunEBWmnn5MztDJkwzpCD/R/vI7Wa7p/PZquzqqD9a4KoJ9nlDv8TFxNnfvjfbiQj0G6wdwmVvVg7AEpkXHjdqu07B8cFOpKKnPiS/w64QD2EGgE7Iv6C9Bi58kyBiIAw4vE0oHq92sQPEed59m+Lb1+eD/0zgBd8XerJwvRZj5afOwWAoWF58I84sdDbqmEkn0hRBI8SHf/VFhFbEGkXOzdvI18wovG3ItCRRubIC2/p7q3vblbtf5gBBwSuxxcMhqCwXkcSYLVFoN8ZuRUSGyKekIQbH/qnMH8pS4tpwmy71YmV/on0ECfImTDZSytET/tHDSojhl/Zz8MMHOJ2JutjcZ0lMlObqSbF4pVaCuzQccSB4K
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(46966005)(83380400001)(4326008)(316002)(69590400008)(5660300002)(44832011)(34206002)(82310400003)(107886003)(36756003)(16526019)(186003)(26005)(86362001)(6666004)(956004)(2616005)(6506007)(54906003)(478600001)(336012)(82740400003)(47076004)(2906002)(6512007)(8676002)(70586007)(8936002)(70206006)(81166007)(356005)(6486002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2020 13:21:09.8711
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: abeb4e81-36a5-4584-5157-08d892d74e2b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	VE1EUR03FT040.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4276

Program headers are processed in two pass: after the first pass
load segments are mmapped so in the second pass target specific
note processing logic can access the notes.

The second pass is moved later so various link_map fields are
set up that may be useful for note processing such as l_phdr.
The second pass should be before the fd is closed so that is
available.
---
 elf/dl-load.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/elf/dl-load.c b/elf/dl-load.c
index 9c71b7562c..b0d65f32cc 100644
--- a/elf/dl-load.c
+++ b/elf/dl-load.c
@@ -1268,21 +1268,6 @@ _dl_map_object_from_fd (const char *name, const char *origname, int fd,
 	l->l_map_start = l->l_map_end = 0;
 	goto call_lose;
       }
-
-    /* Process program headers again after load segments are mapped in
-       case processing requires accessing those segments.  Scan program
-       headers backward so that PT_NOTE can be skipped if PT_GNU_PROPERTY
-       exits.  */
-    for (ph = &phdr[l->l_phnum]; ph != phdr; --ph)
-      switch (ph[-1].p_type)
-	{
-	case PT_NOTE:
-	  _dl_process_pt_note (l, &ph[-1]);
-	  break;
-	case PT_GNU_PROPERTY:
-	  _dl_process_pt_gnu_property (l, &ph[-1]);
-	  break;
-	}
   }
 
   if (l->l_ld == 0)
@@ -1386,6 +1371,21 @@ cannot enable executable stack as shared object requires");
   if (l->l_tls_initimage != NULL)
     l->l_tls_initimage = (char *) l->l_tls_initimage + l->l_addr;
 
+  /* Process program headers again after load segments are mapped in
+     case processing requires accessing those segments.  Scan program
+     headers backward so that PT_NOTE can be skipped if PT_GNU_PROPERTY
+     exits.  */
+  for (ph = &l->l_phdr[l->l_phnum]; ph != l->l_phdr; --ph)
+    switch (ph[-1].p_type)
+      {
+      case PT_NOTE:
+	_dl_process_pt_note (l, &ph[-1]);
+	break;
+      case PT_GNU_PROPERTY:
+	_dl_process_pt_gnu_property (l, &ph[-1]);
+	break;
+      }
+
   /* We are done mapping in the file.  We no longer need the descriptor.  */
   if (__glibc_unlikely (__close_nocancel (fd) != 0))
     {
-- 
2.17.1

