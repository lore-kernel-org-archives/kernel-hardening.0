Return-Path: <SRS0=S5bj=EJ=lists.openwall.com=kernel-hardening-return-20324-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE03C2D0A3
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Nov 2020 10:27:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 67C99206C0
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Nov 2020 10:27:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="QXrFOriD";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="QXrFOriD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67C99206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20324-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15572 invoked by uid 550); 3 Nov 2020 10:27:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15551 invoked from network); 3 Nov 2020 10:27:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2LGHS8npIN3aGe1xT1kK15btQCbisIo7d+nrOmvXU0=;
 b=QXrFOriDF8wUheK7MPfvfeNpEH5ELxFAciGJK9mtZw877QqT1v4kBtmz/rIsCucC8BaXJLunnRK6eU90XShkRxr7hIeyreKnYWWO+ofdush/D+chVhPDHg7V7gnn5QuXWvxmZkjPctPhULOjq6n3aWMukjTu9CG0nJ0uKSMk3JQ=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.openwall.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;lists.openwall.com; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
X-CheckRecipientChecked: true
X-CR-MTA-CID: e0d9a8a02e872d3c
X-CR-MTA-TID: 64aa7808
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FtiHxDxxfzlr3GOl7v7ohQxZsttt8jyMnW2iPZo+swkeyJLYuABDoPECRMJvMxx+b8D3VfhSi0VVAVHcpePw8ts/FARFieIdXAdyxXaK2BGFXaHr40DzyZn0/AT7MtOJ0yOM5c8Jx5sTwyB+ZfNJzORBnyWQCZIeN0tpfbbv/Dj873e8fSD4rwlUn7WvzL2t3DtJ9nmToXLWlZ2xxtXOYdvaXHTjInLXf7Tr+VgFqH61EMR7VAc+P+HAmtFCE2ewlrrH7WMIOi/XTEOely+TuVWxH5/0kE6KqUSAqRERaf+6Hl0DFbbvqi0PvVnPH1JO0DvmV6WggYs3dwv65MvIvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2LGHS8npIN3aGe1xT1kK15btQCbisIo7d+nrOmvXU0=;
 b=JXLlGTTIQsLfRgj2xwkObOaTy3ON/PNARxRB1jdYLzxVJbpIsnUT0aRf5WGeZ7BKuqPg3i2I9WvDs+wVg3ZL/zpacIEct7RAJb8UuI/oBCJ8A7U4f6RmPqX8iyWt50Ml8TLNQjm1p/osQ4QcGQMaUrEK2V0UMcM2gwOjkpAXy3N2wQaLLsvxE/u4FJPS/09gyJP1Yy5IeuSR6CwYC1TO53qcSrfeKXNkgpNJNkmE911BtRX78JFDG6rjnUVl7IA8UiWC3X0THxWqVKNwx9akmgTAz9nFr7KBWclV/EY6ut1Ot0ygBTo1GoFzricQdfwVP2W2djNWKDKfjBV9dETc1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2LGHS8npIN3aGe1xT1kK15btQCbisIo7d+nrOmvXU0=;
 b=QXrFOriDF8wUheK7MPfvfeNpEH5ELxFAciGJK9mtZw877QqT1v4kBtmz/rIsCucC8BaXJLunnRK6eU90XShkRxr7hIeyreKnYWWO+ofdush/D+chVhPDHg7V7gnn5QuXWvxmZkjPctPhULOjq6n3aWMukjTu9CG0nJ0uKSMk3JQ=
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
Subject: [PATCH 2/4] elf: Move note processing after l_phdr is updated [BZ #26831]
Date: Tue,  3 Nov 2020 10:26:18 +0000
Message-Id: <7b008fd34f802456db3731a043ff56683b569ff7.1604393169.git.szabolcs.nagy@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1604393169.git.szabolcs.nagy@arm.com>
References: <cover.1604393169.git.szabolcs.nagy@arm.com>
Content-Type: text/plain
X-Originating-IP: [217.140.106.54]
X-ClientProxiedBy: LO2P265CA0022.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::34) To PR3PR08MB5564.eurprd08.prod.outlook.com
 (2603:10a6:102:87::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 145055bf-8acc-4f82-451e-08d87fe30600
X-MS-TrafficTypeDiagnostic: PA4PR08MB6285:|AM9PR08MB6258:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<AM9PR08MB625895EE9FCA2241AB47C555ED110@AM9PR08MB6258.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 mlsiUh61bx5Crih3vA2Z4JW+a2wt3QsdhbSpnZqOyjqsM63KVmxW5XOr1X2TO3Dg1A9F/A/uNYels5NAdSLyJluaktIENrR8gRfaBbqFCjaXvg3Pr5iC9e1MFZzuDweG77qkYBvFpBgkhUuhUgmBaXdZVVG72PYO/tGE/mH+Ylhfe1YQcx1NTEsXSEGjFF5W65uAE3NjKpyWd2AY/T5lqqC+hdmimbYhOzU+uGgyPPFHS5MpKCl/vzUZ0TL1VGoR2vL2LZ+gu7viXGw9n3Dv1bx4tMYcrBFXB8lM92XEKjgA/g7mC2kQzxq4N7Swh6qgb3PwXYuRYp6ztJKEOlrv52Fke7/qLOZNWoPac2G0n1Gf34OgqdO8G6whwM1MgiDG
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5564.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(6506007)(36756003)(186003)(54906003)(478600001)(8936002)(6916009)(52116002)(316002)(4326008)(16526019)(26005)(69590400008)(86362001)(5660300002)(2616005)(44832011)(7416002)(956004)(8676002)(66476007)(66556008)(6512007)(83380400001)(6486002)(2906002)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData:
 m4/1TbY0scBRHWKeDmS23Ck/0jdSOWYCIpsJxujIy6Qhy5erw+FUqpuGY6k6Fqu8Z3r7jDCYMIhiJMlAZujBIULCskECo5/w5OxdqeHez9ZOFIrOWgJ1WcLJ4UxkK/8pHeE+HXr5xX4gJuoyOfhMNksHGc7kq2kENAuW+hThVJVx9HtsNa2V5MwT7m8I9JB03lS5o2ch7TM8TeYANislqEWiGxevhdEflqSTa7qqm9XgyjbFFMo29TZO/UG7cqoyXB08Q2nLLNqMIKdTyRQdpBAlyL1n1mCi3gxvXc1/cXmx8j5aBJHvFCuNrxAMqws4FAyHERpLdAXNtPwSGOAezm9WpTnuA0nawC/SWVR/fBLVt9BobCUCEK2wyqKDG5z0xbHWFcpLFOMfweXNoV3vkO1JCQHad2kbnmqTmFX03jyzKBC/2LK7X/EOuHXEk2zFoHWVPAxy99VHwM5i0j45YmA9m82ZdYmbxOLdWvlBtPa/SbuGJAiRhyxImq2X6bmkMHNjKG6O7m3Q/n0hMX5vsA/xIERm9cSk8gWUKQbaMhDEtn2Y9oBCzg0iqOWlyr9K3dDoAgG09PDcMG+uaMtq+wyGDP3FlBoj9DXHYvTRgFBTITKiyRAKR0lR7JoRnTYz7i//qDcF3Vt6153BFqUFcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6285
Original-Authentication-Results: sourceware.org; dkim=none (message not signed)
 header.d=none;sourceware.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM5EUR03FT043.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a88b4fed-4a14-4294-4b4f-08d87fe2ea23
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DGARO5lzvxPWvFOdbyHu6F0Y5/SGPbQHd7Ius2ukGIwECp40e/zhHTRr90wPB1GemN4WtXQ6CnqSaQlkG57IWairMbwtzoG3eKBfBXIsu9PlunWS8GWq1YmN8rD2YGdOY1dlR/l/IYq5QSvunrSh6zBTmAvMzEyEjKWnizOKCt2BNw8pkYL8XF6T3ebaz9Z+i4ZDzRK11RC47vJJAa1aXAUrbl3MvE/Bz4pZXzhu5LN6UHRKTuUxh43JovZy3Gx/wArbdaBl8+mD59mRlnuKnYAYQfbiKYohWqhbWdOgt4kWAEdoxsgMdSghoI4W/n/bYWNzhBEyRDSAMNVNqAZcvHowed7xmsr22N8dfzjdLRgbftADfk/2UcJlpDAKnKMX647ojlJChvStWTY3PmvUxLzszmPitwRMXMBq+NIUkv0=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(46966005)(316002)(356005)(107886003)(6666004)(6512007)(8936002)(8676002)(47076004)(54906003)(81166007)(36756003)(36906005)(82740400003)(70206006)(70586007)(336012)(6486002)(69590400008)(478600001)(4326008)(2616005)(44832011)(83380400001)(34206002)(26005)(5660300002)(2906002)(186003)(956004)(16526019)(82310400003)(6506007)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 10:27:09.5755
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 145055bf-8acc-4f82-451e-08d87fe30600
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM5EUR03FT043.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6258

Program headers are processed in two pass: after the first pass
load segments are mmapped so in the second pass target specific
note processing logic can access the notes.

The second pass is moved later so various link_map fields are
set up that may be useful for note processing such as l_phdr.
---
 elf/dl-load.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/elf/dl-load.c b/elf/dl-load.c
index ceaab7f18e..673cf960a0 100644
--- a/elf/dl-load.c
+++ b/elf/dl-load.c
@@ -1259,21 +1259,6 @@ _dl_map_object_from_fd (const char *name, const char *origname, int fd,
 				  maplength, has_holes, loader);
     if (__glibc_unlikely (errstring != NULL))
       goto call_lose;
-
-    /* Process program headers again after load segments are mapped in
-       case processing requires accessing those segments.  Scan program
-       headers backward so that PT_NOTE can be skipped if PT_GNU_PROPERTY
-       exits.  */
-    for (ph = &phdr[l->l_phnum]; ph != phdr; --ph)
-      switch (ph[-1].p_type)
-	{
-	case PT_NOTE:
-	  _dl_process_pt_note (l, fd, &ph[-1]);
-	  break;
-	case PT_GNU_PROPERTY:
-	  _dl_process_pt_gnu_property (l, fd, &ph[-1]);
-	  break;
-	}
   }
 
   if (l->l_ld == 0)
@@ -1481,6 +1466,21 @@ cannot enable executable stack as shared object requires");
     /* Assign the next available module ID.  */
     l->l_tls_modid = _dl_next_tls_modid ();
 
+  /* Process program headers again after load segments are mapped in
+     case processing requires accessing those segments.  Scan program
+     headers backward so that PT_NOTE can be skipped if PT_GNU_PROPERTY
+     exits.  */
+  for (ph = &l->l_phdr[l->l_phnum]; ph != l->l_phdr; --ph)
+    switch (ph[-1].p_type)
+      {
+      case PT_NOTE:
+	_dl_process_pt_note (l, fd, &ph[-1]);
+	break;
+      case PT_GNU_PROPERTY:
+	_dl_process_pt_gnu_property (l, fd, &ph[-1]);
+	break;
+      }
+
 #ifdef DL_AFTER_LOAD
   DL_AFTER_LOAD (l);
 #endif
-- 
2.17.1

