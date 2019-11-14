Return-Path: <SRS0=oxfu=ZG=lists.openwall.com=kernel-hardening-return-17363-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC41C432C3
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 Nov 2019 11:43:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D608F206E1
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 Nov 2019 11:43:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="FO/M4bss"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D608F206E1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nxp.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17363-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7468 invoked by uid 550); 14 Nov 2019 11:43:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5302 invoked from network); 14 Nov 2019 01:29:46 -0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rwz0gnK9kehj6s6qJJ04eaKy58ZEsxuM5c2J3DlHsOoODoKNOodCoWw6nxj1xQ/4DZLHk40tT1d9gyWkaze9ZGHylgG9yowqjouXiRjNATkEt8KYBs0YKd0YOajXCpetOuj0ZIYgi764fWd75jHlG3bE0OwwHBBlGxHQMrYTvYUlTXcwKf1Xmz+ARkTU2kvMum2nVRW9z0WkEdMFT3elV8kn9ib1U730Pd1S3WgBKMOBJ3Jg6PGUz9Fv1wBUjT4/JuoUl4gxn6Wdp4m05eOfaH+4NltqFxCZbcCbHhD5WEXwjrIXeTIk/jTXS3KIqRx6Jb1vjiL8J5CggMymQszT/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHbv7wwzbbH+Z9HYCtUcRMGCTnhOg9WKX3/vEaqd2g0=;
 b=XWoxwKyBhTUxtGgTiA2SVXqx9SBisGDjvf2sNhKhmviTkq5OL9fsuZrcXcvFCvCMQEXk35bLTjMm/ArfEG9gnG97yVidorf/ss1HUGet8pp9qvR5y7eAMzWg50YdDEe/SioKjEyAlZVKl8CY8qWKVefZq8IXUYnEXdB5Bjt/eOXwAzdueYyLRJegSok/ATZ/uGVDoS0RchIsUJ1prNga66bzkzmjoWTMsAeAj5g+gHENNrH+2tj9K4eFuzAMW+DWYxRm17JZoEmZXOybgnnycLCOgHV31/X9WrWRpzBfynH4Bi3IfAQ2nUFl6wmvu6NIhS4X2FdCLEtR0LUR0pUSIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHbv7wwzbbH+Z9HYCtUcRMGCTnhOg9WKX3/vEaqd2g0=;
 b=FO/M4bsspFq6v+ZWZQ2BikpnFmF1c1+Zc3CiIiKMwgoLzHlXdNuGZATOKORNYQGZpMGsXSMMLeoR1kIciG+KVc/y8sERJBkmiwG+WWE6w6AAU9PO1ynZnSfDM7kDD61NXfcEVcSJIV3K4DmjEgyQQbpyqaMR9BMDKszlV4ytmIA=
From: Peng Fan <peng.fan@nxp.com>
To: "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>
CC: "keescook@chromium.org" <keescook@chromium.org>
Subject: contribute to KSPP
Thread-Topic: contribute to KSPP
Thread-Index: AdWaiYL+2RwBowSVSdiGpjJxtGed9Q==
Date: Thu, 14 Nov 2019 01:29:33 +0000
Message-ID:
 <AM0PR04MB4481EB76361DB1681D1F265488710@AM0PR04MB4481.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peng.fan@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5fef83ba-3a77-40e2-b436-08d768a21ab9
x-ms-traffictypediagnostic: AM0PR04MB4755:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs:
 <AM0PR04MB475591928FC4EAC470B22C8088710@AM0PR04MB4755.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report:
 SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(346002)(136003)(39850400004)(199004)(189003)(66946007)(74316002)(64756008)(66476007)(33656002)(76116006)(86362001)(186003)(8676002)(81156014)(55016002)(66556008)(7736002)(6306002)(9686003)(66446008)(6916009)(6436002)(2351001)(7116003)(52536014)(8936002)(81166006)(256004)(5640700003)(4326008)(305945005)(316002)(3480700005)(16799955002)(99286004)(102836004)(6116002)(3846002)(7696005)(6506007)(2906002)(44832011)(347745004)(71200400001)(26005)(5660300002)(966005)(4744005)(66066001)(14454004)(476003)(71190400001)(2501003)(25786009)(486006)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4755;H:AM0PR04MB4481.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 6WNC8MWXR4N+JePC6F+YBXVluXnluKXxZ+L+Of5BSwC6uV8onrU/qLe3zL8/Vn4TL+RaQbhyUMZ3DpscgErS7ot+GCGuANLhyOWIWZK3cz+8Om9cWE2FjiWsa2pDNG9KN1eQ9INtY+g0AhRRssHsikXdlA6MI/J/0adLUb0sFHEvW4vb5JDvvPc90di8DTQNCICa5sXFU0csalzb0oeY3ctguAil5q8rCdLsdbNixw6iBglcqBnuMDQAW8HwdFXy/FwQzYQ8PVNrzW28LNgFKj4ws+9mzmluTYmyJowNn4wxlbbksJTkUtB6YxhwvcGdG/+a48LW17x15BZ0OBDncixUjEyd5wH20ALXUhpFSp9qAs7uMnpfAj8kGf7YZAwUBmWUFzyCyx7IQWSeXWh3rMHRY2vERPiFgmLh61tygzxNNdl/vSCatNGSkS77wBd8MC69GwuF6j6Uz9luzm3jFasZhYFt/xDK/j33Crc6OF0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fef83ba-3a77-40e2-b436-08d768a21ab9
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 01:29:33.7053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6bIu8R8shzQkSiLojb/G0PZYsJxy4LfbOzHv0pp8lMP4aVJr/mhU6U7oMBFsZFuVrELlO7PTPk+dqVFNAA1iXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4755

Hi,

I work for NXP Linux Kernel team, my work are mostly ARM64/ARM SoC BSP,=20
embedded virtualization, bootloader development.

I came across KSPP, find this is an attractive project. And would
like to do some contribution.

Not sure https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/=
Work
is still up to date.

If you have any items not owned, please share me the info. Currently I am
going through the kernel items, such as the following form ARM/ARM64:
split thread_info off to kernel stack
move kernel stack to vmap area
KASLR for ARM
Protect ARM vector

Thanks,
Peng.

