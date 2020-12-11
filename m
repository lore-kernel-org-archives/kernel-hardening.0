Return-Path: <SRS0=m+KV=FP=lists.openwall.com=kernel-hardening-return-20580-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF24C4361B
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 15:34:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7E97A23121
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 15:34:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E97A23121
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20580-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27733 invoked by uid 550); 11 Dec 2020 15:34:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27689 invoked from network); 11 Dec 2020 15:34:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M03DEdjmlCMQHLuGnBWpmQguDLRH/JE9YKLvUgpRPPk=;
 b=g7+GBUPqRrlOla5lmXYz1A2zCQSbOG9McZEWTo6zFl1MISgZgHm+294EHthaivNMwX2+CJzCxGidERfrelEwqEvP8BBp7CFsBaP6PttTZTad59KNC1XuBh79LiqI1DVywZFwzBQY1E45DM8ZpAWFyrhkkKAeYcn6YFSnDZwZ6II=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.openwall.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;lists.openwall.com; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
X-CheckRecipientChecked: true
X-CR-MTA-CID: 1dd39a4dd3283706
X-CR-MTA-TID: 64aa7808
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JU+lj9oRPsYJhtOULEGrI4eLL6PmPJlUrb2ChCNBGy30KYeI83DyvgogeXiL/+L/ZinIfMgPH3GTkBYeqqZ/GGpabVQRIy6rPOt+X/t3xGkdf5sDhc0htU6ASjizgjN1rlyR+5I2SmEtKZ6poPiRjSdBtQwVFitmhKj2keSFpnlPe/Y6Z+tiML7YvFZVKZvb6i8CV3o3te7dfjhXGD4331fGaqXIoI7vX4HNKkkwalbEQ3JpTEQ3wDdxGbshawcxXfg6VzB0DVgbWNgbwJwGXffUUhDsP4172JHrdnq4lrOKmEPtHhdqclhfzij0h2sI0wWmckPu65UurfgQN71ZzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M03DEdjmlCMQHLuGnBWpmQguDLRH/JE9YKLvUgpRPPk=;
 b=Ht+80JMrYuCDMjtJlAn9I20pFwpBwlAf+9VJkKZHavjgRlvhqVuoYybpgT5EaIO+mv+mtt0yU3+dLxFpikAFcFCGTWY1UpPRIbpjsbYfZx6KG3K26Cp5TDVdJfXBNqe8+XpyT2+8usTixkzLM3DE9F8C89bp50K7vCQuCKhJPNvS7KJtgPamEznMYesxfTGwrjaiyKmA8KdEd3c5t5BCkGx3eoqURORRBOdoEkqDaKIuXWKybuRi9nIw7BLgc7S+5Wq1dKjX/v6tqsBG0YlB90qp50de9A2ioZ0k70OSLSKCJDV8uXXFtCT4dvg3G0Rh4+tMWbpEoyjr6AoHu1+Cgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M03DEdjmlCMQHLuGnBWpmQguDLRH/JE9YKLvUgpRPPk=;
 b=g7+GBUPqRrlOla5lmXYz1A2zCQSbOG9McZEWTo6zFl1MISgZgHm+294EHthaivNMwX2+CJzCxGidERfrelEwqEvP8BBp7CFsBaP6PttTZTad59KNC1XuBh79LiqI1DVywZFwzBQY1E45DM8ZpAWFyrhkkKAeYcn6YFSnDZwZ6II=
Authentication-Results-Original: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=arm.com;
Date: Fri, 11 Dec 2020 15:33:34 +0000
From: Szabolcs Nagy <szabolcs.nagy@arm.com>
To: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Cc: libc-alpha@sourceware.org, Mark Rutland <mark.rutland@arm.com>,
	kernel-hardening@lists.openwall.com,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-kernel@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Topi Miettinen <toiwoton@gmail.com>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/6] aarch64: Fix missing BTI protection from
 dependencies [BZ #26926]
Message-ID: <20201211153334.GF24625@arm.com>
References: <cover.1606319495.git.szabolcs.nagy@arm.com>
 <8756cc1083eb4cd93d3766cd39b2f34b6623bbcb.1606319495.git.szabolcs.nagy@arm.com>
 <f077a6d5-082c-c3a5-ce07-71b87a70dc12@linaro.org>
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <f077a6d5-082c-c3a5-ce07-71b87a70dc12@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.140.106.54]
X-ClientProxiedBy: LO2P123CA0052.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::16) To PR3PR08MB5564.eurprd08.prod.outlook.com
 (2603:10a6:102:87::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cc47fc8d-bec9-41e6-4df6-08d89dea2b10
X-MS-TrafficTypeDiagnostic: PR3PR08MB5787:|PA4PR08MB6048:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<PA4PR08MB60489DE376906B41776E57C5EDCA0@PA4PR08MB6048.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 WyBCQ9Z7JYB7OJVKW/W7Mej6Tp1dRTMpXmTn9GlZGXtQrWpbVgqFxWx2Pgb4hWRX/KwegpA9WA1VPeh0NBTc+P3lRNCsenE1JbRKTc5f3ghKO7XkYKeoaCZ3fG7/FbdvfXJIjffW9Gg1gFHA1Qs/zT0zqaY02asHkYOCt4Bss1tQLPISd4wdyClilcX/bcDtoIY7Pxn/nPBHcUjLGIKgafyFcdVksGIEhp6/J19KuKy1GHZ55aT5AiIGVdcOlb3VU7tr1zopBILrsrqMV5NCWCkJgtyDkuZV0Dfwz5MN/bFB+w1Zek8n1t00YWmxo0zjd2QdDWl3pKw/Pdpmb2M3dlRPKbsHIdJqOE4pTX0xnOrMBLEvJPLwHv4oH/OSaRu2
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5564.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(66556008)(86362001)(316002)(66946007)(36756003)(66476007)(66616009)(6916009)(54906003)(33656002)(8886007)(4326008)(44144004)(55016002)(478600001)(2906002)(44832011)(956004)(2616005)(53546011)(33964004)(52116002)(7696005)(1076003)(235185007)(8936002)(5660300002)(8676002)(186003)(16526019)(26005)(2700100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData:
 =?utf-8?B?Q0FoUTd4WFpPTzR5NTBjejFXbDF4dERXalNnQWVZY1hEcnpxU2gza2dTeVBq?=
 =?utf-8?B?cTVIYWRKTEVZYklDQ1p6SFhaRG1lZzEzdWoveGY0eDVuamRXR3ZkY1pycE1y?=
 =?utf-8?B?d2txamU2RXM5UUdlL3grblU0ZnU2RmNFNy9hc2hUa1JNaFhHWEIwd2xJSlM0?=
 =?utf-8?B?QVR1S1hyZHpzWWRCc0prMVE1NytVdjdaR2NzRUd4d205Y0g3QW1xUzBrcFJp?=
 =?utf-8?B?MmsvQ1kwY0Z5ck5aeVFRYSt5WEwwc0ozT2QzcWJEeXVTSHhXQkpDMS9oZG5r?=
 =?utf-8?B?anBjdE5GSE01c08wWHVoaWhwMFh1d3BOS09lSWdobXd6M3NHMEJPQTR2N1VZ?=
 =?utf-8?B?NFlUZ1RCRVVCZ0g4d0puNWw5amtEVTJvWGlseDNRRXdSeDRKU2pSQ216a0RW?=
 =?utf-8?B?Ky9WVXVWS3ZjREh0T2NjUnp0SFRMQzhBZHpyOEUra08rN1ZybHNLRk9WTmJX?=
 =?utf-8?B?OVNIRTFjcWI5NS95OGcxRTlVeWlZK0xuV0VhU1BVR3J5RElhRE1yL0ZaTFAy?=
 =?utf-8?B?cGc1TTVSWmdRbHgwU3gzd2MzUVFudlcxU3VKV2IwNFpZc1ZkNTR1OENYMVBp?=
 =?utf-8?B?SnpTUGZDS1U0NURoSllCR254eHd1cXhuYm9MYlBuMEx1NUVpUUlZSXppcXFp?=
 =?utf-8?B?b0tuam02aHRDMDlWUkdrNzJ5Q1FwSHB3Y2RZdmJyUFBMZ2JsY1drUHZNaENF?=
 =?utf-8?B?WGVVYWErU1YwTmVRYWVYanpvMU5XUjZWNmQwUjhZdGVDaXdzZzBOZ1BuTm1m?=
 =?utf-8?B?QktpZ21RNytaRE5wVXk3QlJjVkFORjN4ay9mUThRVVlGWnRSUVV3UllzTHV6?=
 =?utf-8?B?bkh5Q2U0MmZmcDl5MUFCTTdaS1Q0dTZkQWdrYjEvUENXei8zTUhOdEtCZjU4?=
 =?utf-8?B?N2ovdU9zSS9vSkR4c2xrN0FGZ0RFSER0cFZnVlFtaG0ra1pHeFF5dm4yTVNI?=
 =?utf-8?B?eG5OODh2UElRdlp2dmFlOTl3Z3MyQmVXQjZURzhzQzkwcjl0OGVUMUsrd21v?=
 =?utf-8?B?aFQ3NzQwbnIzdlVyelFYQ1d4d3YvQVhvN2JOV0Q2WUFuOXpFNnZYZzAzT0Fk?=
 =?utf-8?B?QjFLRDdsYnRmRnk0TTRpM3M5NVVaRHlaRFlSQlMrVEF5dzVkZzFmQ2pUV3Jm?=
 =?utf-8?B?SEd3SXMzREZEOWMwSTlpanFRcW9OR0YzM2dBTW9kMDNnZGE4cXRkYmRva1Bi?=
 =?utf-8?B?NGxyNnhRRzRVVVhtYzdlMzhUeFlXZlV1Rm1KVW1wNFU1bXJxR3hwekZHODdo?=
 =?utf-8?B?WFJ0eUxDNXhWSzMvKzZLVU5QQ2p2M2l0MEN3UmJNOVF0UENrZGM2dWpaZmJw?=
 =?utf-8?Q?bdaRGF1Nfy2UM1G6eoVx4lLE2W6mc184gi?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5787
Original-Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5EUR03FT041.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f4c32ce0-4f3a-47c2-ccbc-08d89dea20f3
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rfJQ7Pii6XdNQAHbuC/nGo1jXkHMSfz7YFik19ns8gjanJQS9WMT9EaF6zIp/Ypax08RxjHSLkNrfZamYKK8/dkAnsUcTaLJP+Z+iUzeHbXj/jedW4rGzPEt9iJQu/QH85/svQelhUZDfXd80JcHZJ6xXQpXikrWZPN327n0LoeqyEARCzSk1lKmkhFCptjMgdh52yBLOmcG/LVZMy10dAaiVgBVMa29ynrlczeqmSPJatQT6rYjfg06kHXi7fuGu43RU6jSJsRP7BGPz/I4VLJrSsex9+hVQOl7B+XGjHTAB0lCEysw0uTh2bd5ehUcdKVwt6elAsj8PnWO4oLwWg+DJkhtOjQvkDCyfn8ly000t1dlTCv1WEU4ecGJw7+jWjPG0EWIJtq+cz9tKNylos/pbmmYO+aUSMOU69cyKZs=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(46966005)(53546011)(7696005)(316002)(82740400003)(36756003)(47076004)(107886003)(2616005)(956004)(16526019)(1076003)(82310400003)(356005)(2906002)(8936002)(54906003)(70586007)(44144004)(336012)(8676002)(5660300002)(235185007)(44832011)(86362001)(26005)(81166007)(6862004)(55016002)(70206006)(478600001)(186003)(8886007)(33964004)(66616009)(33656002)(4326008)(2700100001);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2020 15:33:54.3262
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc47fc8d-bec9-41e6-4df6-08d89dea2b10
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5EUR03FT041.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6048

--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

The 12/10/2020 14:51, Adhemerval Zanella wrote:
> On 27/11/2020 10:19, Szabolcs Nagy via Libc-alpha wrote:
> > The _dl_open_check and _rtld_main_check hooks are not called on the
> > dependencies of a loaded module, so BTI protection was missed on
> > every module other than the main executable and directly dlopened
> > libraries.
> > 
> > The fix just iterates over dependencies to enable BTI.
> > 
> > Fixes bug 26926.
> 
> LGTM, modulus the argument name change.
> 
> I also think it would be better to add a testcase, for both DT_NEEDED
> and dlopen case.

thanks, i committed this with fixed argument name as attached.

i plan to do tests later once i understand the BTI semantics
(right now it's not clear if in the presence of some W^X
policy BTI may be silently ignored or not).

--OgqxwSJOaUobr8KG
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-aarch64-Fix-missing-BTI-protection-from-dependencies.patch"

From 72739c79f61989a76b7dd719f34fcfb7b8eadde9 Mon Sep 17 00:00:00 2001
From: Szabolcs Nagy <szabolcs.nagy@arm.com>
Date: Fri, 20 Nov 2020 15:27:06 +0000
Subject: [PATCH] aarch64: Fix missing BTI protection from dependencies [BZ #26926]

The _dl_open_check and _rtld_main_check hooks are not called on the
dependencies of a loaded module, so BTI protection was missed on
every module other than the main executable and directly dlopened
libraries.

The fix just iterates over dependencies to enable BTI.

Fixes bug 26926.
---
 sysdeps/aarch64/dl-bti.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/sysdeps/aarch64/dl-bti.c b/sysdeps/aarch64/dl-bti.c
index 196e462520..56c097210a 100644
--- a/sysdeps/aarch64/dl-bti.c
+++ b/sysdeps/aarch64/dl-bti.c
@@ -51,11 +51,24 @@ enable_bti (struct link_map *map, const char *program)
   return 0;
 }
 
-/* Enable BTI for L if required.  */
+/* Enable BTI for L and its dependencies.  */
 
 void
 _dl_bti_check (struct link_map *l, const char *program)
 {
-  if (GLRO(dl_aarch64_cpu_features).bti && l->l_mach.bti)
+  if (!GLRO(dl_aarch64_cpu_features).bti)
+    return;
+
+  if (l->l_mach.bti)
     enable_bti (l, program);
+
+  unsigned int i = l->l_searchlist.r_nlist;
+  while (i-- > 0)
+    {
+      struct link_map *dep = l->l_initfini[i];
+      if (dep->l_init_called)
+	continue;
+      if (dep->l_mach.bti)
+	enable_bti (dep, program);
+    }
 }
-- 
2.17.1


--OgqxwSJOaUobr8KG--
