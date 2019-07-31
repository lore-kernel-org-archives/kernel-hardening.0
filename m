Return-Path: <SRS0=aKl5=V4=lists.openwall.com=kernel-hardening-return-16658-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PI_HELLO,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B4C3C433FF
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Jul 2019 09:08:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BAFB92067D
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Jul 2019 09:08:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="PKee4cb1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BAFB92067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=outlook.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16658-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27849 invoked by uid 550); 31 Jul 2019 09:08:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22382 invoked from network); 31 Jul 2019 06:52:17 -0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wn/goPn64A4+1+18YjO1Iykvl0b88IvyEbogrzeVq6H+MjICPvsuu5aimHEvi+VY1qmbXWclaogQ8bnra4ij3xMmOkWHsjCrjWussllyhCYDepj49HifqlwICkDI/0eTRFYmyzWQVNWNs8OpvTyoJtAWtvFLLhkXv8WCCZ47G3QUU6R1q5xEvyWbD8AoJ8CPnBj6sgkuPQjiRlctJ1/3CRmsB1JlMX/cuhWffFe405ByEFE4J5xSzE3FV7HrT0BVdT13LrMN2J/+T88u3ND+/KRXKbMtf19qDPW0HDxMqHknEEl5oW3U2QROgeocoMOeAn9vL9jY3t22OsDMA+EK7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RTKUmJbZo2eVdUeO5EJe+Lt45GfxlGIsIybj0Ni4P8M=;
 b=TXWA7UVqEVDVhJEoaie5t6Rser/jmx12ix7yt0MU5bCmoGp9sgGbwKWFYN45ZZbEk2s4I0gBYAW5TlJnqSisMxzNHXRc+XmwIvP7OJVl16Zo7PwIE/IPaxu92J2XwolxBVvqrYITlr2kzwCNIzK2xrvkSz4ifgluunbvtHQfbkMVmkYtbpmD+2L0/wmyYc8oXDUEDy5CLDXD6OFk+ObYYTfMGFzSsHd7MfNCbmWeUjs301G4K+aGIuKwNYArkeleqRAgZl/6K6VAUk0GeWtb+ThBfpwr9K9HOCLfojvJkt94k1x6n35YbV0M70X7M3D9Z72vbpgxwjJ+wUulhxVr6g==
ARC-Authentication-Results: i=1; mx.microsoft.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RTKUmJbZo2eVdUeO5EJe+Lt45GfxlGIsIybj0Ni4P8M=;
 b=PKee4cb1hMbhc+n2OeFlC0IaKDpb5m5LFMpU7Bqbes6E/IQH2my2vfQ8JRqcRyP1o6tXjdWljDYaUH7vENdQ7SKLwCTz88WkgshYqfSQDmKgxFFvxHYZNu3++AlbqUGfMW5L1/xyqA7o2ar2o5rmDWW3HNjYE9rZUexW7wK6/7AZKpYSmPaxjMbVrn6xmUIle7DRuHjnWPGLCHAh8akRgPwEodc7HA8S4LJuUUxDOzqOTPsG/x+d/iygOGJREAEghNvP5S/WRyjrr/2gqGpZt6E04ct7pluLfzAMtS/ZtxRh+Ikq4r74uL01HJBXfmrXmstsoHCUos9GLx55DRVSWA==
From: Rick Mark <rickmark@outlook.com>
To: "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>
Subject: Hello Kernel Hardening
Thread-Topic: Hello Kernel Hardening
Thread-Index: AQHVR0Nydh2VCNrgZESrXztbaUphuQ==
Date: Wed, 31 Jul 2019 06:52:04 +0000
Message-ID:
 <BYAPR07MB5782E8E1F2105AD154035E10DADF0@BYAPR07MB5782.namprd07.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-incomingtopheadermarker:
 OriginalChecksum:ED85CE06DE5580F6EA993B918503F2BCCA473D3565417FF864D4D6EA327E845D;UpperCasedChecksum:C969A264BDA80CF792627EB4FB50650725251F603216FBE84CF060783E3921A6;SizeAsReceived:6544;Count:41
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn: [5HlJP2MYmyEYgJRj13FOZCTZWjIK+6TN]
x-ms-publictraffictype: Email
x-incomingheadercount: 41
x-eopattributedmessage: 0
x-microsoft-antispam:
 BCL:0;PCL:0;RULEID:(2390118)(5050001)(7020095)(20181119110)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031322404)(2017031323274)(2017031324274)(1601125500)(1603101475)(1701031045);SRVR:BY2NAM01HT079;
x-ms-traffictypediagnostic: BY2NAM01HT079:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-message-info:
 xxV8APOjQLzQvsoc3aVIfcGkmfg7Vr3aKz2z8OOurNvcJmOBK8bk2gP7M0cX1irg1eV9ZhgcurpFRYirCh2Rka1MfaCNBPckFcoXUC+UmoHhWUCfNtr9SM8+/B6lolE/XUhsHIkkFuoUjq3TvzAtHy7N214EyX5pfti05KEkZjjoOByy+xqf1FAQeJOJit5q
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: cd259281-8d5f-4c4e-7c65-08d7158398fc
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 06:52:04.7197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2NAM01HT079

Per the instructions in the get involved I'm here saying hello.=0A=
=0A=
My name is Rick Mark, currently a security engineer at Dropbox in SF.=0A=
=0A=
I've been toying around with various things I've found in the wild=0A=
over the years and recently put together this CC Attribution paper=0A=
'Security Critical Kernel Object Confidentiality and Integrity'=0A=
(https://dbx.link/sckoci).=0A=
=0A=
I've been playing with a reference implementation and filling out=0A=
the paper as I go, so I'm here to add a new area of defense to the=0A=
Linux kernel.  If you find the work interesting, I'm happy to have=0A=
people sherpa me though the kernel contribution process, help with=0A=
implementing the reference or production version or even just=0A=
co-authors to help with the paper.=0A=
=0A=
Best=0A=
R=
