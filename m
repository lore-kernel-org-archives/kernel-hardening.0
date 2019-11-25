Return-Path: <SRS0=ccTn=ZR=lists.openwall.com=kernel-hardening-return-17436-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F64C432C0
	for <kernel-hardening@archiver.kernel.org>; Mon, 25 Nov 2019 14:04:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 03EA520679
	for <kernel-hardening@archiver.kernel.org>; Mon, 25 Nov 2019 14:04:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="rbMkgRHe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03EA520679
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nxp.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17436-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26066 invoked by uid 550); 25 Nov 2019 14:04:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32033 invoked from network); 25 Nov 2019 12:29:32 -0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=my9N6qAJ/1F8FNpEOgzlDk4cNyy2oiMu2WcVxp8Z5qzVfpMG41VS2jG7f/u2SSq9YHjfsL0B5N+oHlHZK+/5IuXciP7o7N02Tvr++dEvJ9MIu3QX+w572Qfg1G/EK6pIpf6OuEt17eAWNjvE3vCeMWEyaolCShj5ezPJxxgEA/weYpN0iVIfRdTTuV7zI8voUsQdIHzIQtoIgwLZ1EpkiA8AUBYxDwyQUGxibP7MNzb5JucZ6eovzYD0GqNVLyPc+/k1qcdXEOgW81kLFoAY0fgIBGYwtfxsXsvB+CqpqoXgPlbXYSuWQIYLY/x8D5K5aVwFaDJ40wr3Eqj3inVXHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ts0YklIPLohOicXeuxnLVCVR4IV2eDPSYD/hCwfKM9Y=;
 b=b43uBgdYOOIMHZDOiZ9dbyqmtd0lj7HczYM82DQQu23bn19t7nvZGQzulJTvba7iMORNRfJ8qb7s8XvVJC5iaBcw0LP8DnSSHJSe3IBAaxtMputsgXo+dlN87zcUeM5zGE5gQPbe3CBSjm7EufLRo1b65Peffow6W4AU4CmZjTJxI3lTPFiXAdwsRJKBxGofk1NSFYU0ZDYcb6DNZKClqphr4wFeBi2tXwWaKc256CptL8L28Tb2RtSYBlFT3S4/9zhgFmxj0LyI0JmPD1u4sha+Ewqbgr6xME9nHq0zymwBTjsCin1Xi/LjD3mxLQpjVNuPhZsdJg266uqcgCd8sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ts0YklIPLohOicXeuxnLVCVR4IV2eDPSYD/hCwfKM9Y=;
 b=rbMkgRHeQLyQ3+g1aJIJO+Ur1J5071pdtSoYjQn6FjyEW0vEllYoqKCnn7D+xvJrKHXGcmyhDx/xSFD02kd6xogUUWdTs0sBDXWKmn3EAjCDuB62IPsq07+3B+Yg1dLiOl+J/sRQaw7cbzdh9je1phz3CqYcjleMXBLQX+Gfz4U=
From: Peng Fan <peng.fan@nxp.com>
To: Kees Cook <keescook@chromium.org>
CC: "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>
Subject: RE: contribute to KSPP
Thread-Topic: contribute to KSPP
Thread-Index: AdWaiYL+2RwBowSVSdiGpjJxtGed9QDqmIEAAVX/C0A=
Date: Mon, 25 Nov 2019 12:29:19 +0000
Message-ID:
 <AM0PR04MB4481B25944FC346764E96219884A0@AM0PR04MB4481.eurprd04.prod.outlook.com>
References:
 <AM0PR04MB4481EB76361DB1681D1F265488710@AM0PR04MB4481.eurprd04.prod.outlook.com>
 <201911180912.B860362F@keescook>
In-Reply-To: <201911180912.B860362F@keescook>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peng.fan@nxp.com; 
x-originating-ip: [58.208.26.97]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e6d69144-3cb2-494e-bbf7-08d771a31843
x-ms-traffictypediagnostic: AM0PR04MB3956:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs:
 <AM0PR04MB3956CCEAAAD12ABA8108814B884A0@AM0PR04MB3956.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report:
 SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(39860400002)(136003)(346002)(51914003)(189003)(199004)(6436002)(8676002)(81156014)(55016002)(76116006)(74316002)(52536014)(81166006)(66446008)(4326008)(8936002)(86362001)(66066001)(478600001)(44832011)(229853002)(45080400002)(7736002)(7116003)(14454004)(966005)(5660300002)(6306002)(9686003)(347745004)(446003)(6916009)(256004)(2906002)(99286004)(71190400001)(7696005)(186003)(102836004)(76176011)(11346002)(33656002)(26005)(305945005)(66946007)(16799955002)(64756008)(66556008)(66476007)(25786009)(3480700005)(6246003)(3846002)(6116002)(71200400001)(316002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB3956;H:AM0PR04MB4481.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Gxx8etSS2pWua41yNQV6yG8KhK08+nYjUx5dm0GJxYX3fqPUm3DM5+djIIJdX1FRMiusIQ10UsbmYy6D+b3Qg4hdAogffYFa8NuOaSEU2CM3b155tsIC/e5A8G2bP2o5o4rqIQSCvf8XTlCSQWxE70sKKIDwxtkc80Pg6eomxxCaXChOdDQ35hNGJipx0sawhWc41d3Gn/90VUK+LcMIEn4PwCJGrD+QKYTRn+OcoocrJBd08T4hOpNs4PAlu3bdi3ep5SHppAhjNgZNSrpyF79HNfTW+ZWI3/hjWQI13nD6yKsPLSqG6NzKLT6R70vuNb4P+hZ3sxxbeUM5Xu6SfcB/tVpEYUvn0ay7r7dxN4zD4WnXJh7q3krnEXkSYekXZkfiA+xjFd4RW7GWtoYmoSr3L7oAnUETKLd4SyT6j20xE9NEIZuFIVar9ihOFt3E
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6d69144-3cb2-494e-bbf7-08d771a31843
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 12:29:19.6265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RrGqEtjoa8MBhViBoLXST1pY+Ja1D5IXbTotcSDjPtHgoODRT86J5+fRX9RVOIqNWno053fqHq5kzg6jB90qbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB3956

> Subject: Re: contribute to KSPP
>=20
> On Thu, Nov 14, 2019 at 01:29:33AM +0000, Peng Fan wrote:
> > Hi,
>=20
> Hi! Welcome to the list!
>=20
> > I work for NXP Linux Kernel team, my work are mostly ARM64/ARM SoC
> > BSP, embedded virtualization, bootloader development.
> >
> > I came across KSPP, find this is an attractive project. And would like
> > to do some contribution.
> >
> > Not sure
> > https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fker=
n
> >
> sec.org%2Fwiki%2Findex.php%2FKernel_Self_Protection_Project%2FWork&a
> mp
> > ;data=3D02%7C01%7Cpeng.fan%40nxp.com%7C7782ad728666475bb26008d7
> 6c4b09e1%
> >
> 7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C6370969418477903
> 73&amp;sd
> >
> ata=3DEBUM%2FyWtBoyGDjfxd0IMT9qsggxCE5gee3iqq%2FogrCU%3D&amp;re
> served=3D0
> > is still up to date.
>=20
> I've been slowly transitioning the TODO list to a github issue tracker
> here:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgithu=
b.
> com%2FKSPP%2Flinux%2Fissues%2F&amp;data=3D02%7C01%7Cpeng.fan%40n
> xp.com%7C7782ad728666475bb26008d76c4b09e1%7C686ea1d3bc2b4c6fa9
> 2cd99c5c301635%7C0%7C0%7C637096941847790373&amp;sdata=3DeNxRzzT
> cp%2BH75%2Fd8cF%2BgJTQR0YnTFNDXU5lxg%2BWTJLQ%3D&amp;reserved
> =3D0
>=20
> > If you have any items not owned, please share me the info. Currently I
> > am going through the kernel items, such as the following form ARM/ARM64=
:
> > split thread_info off to kernel stack
>=20
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgithu=
b.
> com%2FKSPP%2Flinux%2Fissues%2F1&amp;data=3D02%7C01%7Cpeng.fan%40
> nxp.com%7C7782ad728666475bb26008d76c4b09e1%7C686ea1d3bc2b4c6fa
> 92cd99c5c301635%7C0%7C0%7C637096941847790373&amp;sdata=3DLl3smB
> 1mFIjl49uTqE5bhVcW%2FGfZQtduysCf%2B9wja%2F4%3D&amp;reserved=3D0
>=20
> > move kernel stack to vmap area
>=20
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgithu=
b.
> com%2FKSPP%2Flinux%2Fissues%2F2&amp;data=3D02%7C01%7Cpeng.fan%40
> nxp.com%7C7782ad728666475bb26008d76c4b09e1%7C686ea1d3bc2b4c6fa
> 92cd99c5c301635%7C0%7C0%7C637096941847790373&amp;sdata=3DMA58H
> S7UotQfAW7BjDuD%2FcnQCnJnLNlIDvU0yPuVsOs%3D&amp;reserved=3D0
>=20
> > KASLR for ARM
>=20
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgithu=
b.
> com%2FKSPP%2Flinux%2Fissues%2F3&amp;data=3D02%7C01%7Cpeng.fan%40
> nxp.com%7C7782ad728666475bb26008d76c4b09e1%7C686ea1d3bc2b4c6fa
> 92cd99c5c301635%7C0%7C0%7C637096941847790373&amp;sdata=3D76EYxk
> RogOwPKnyNZzzqwdU%2Bd21vxdI6rPRN%2B5zqzkY%3D&amp;reserved=3D0
>=20
> > Protect ARM vector
>=20
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgithu=
b.
> com%2FKSPP%2Flinux%2Fissues%2F13&amp;data=3D02%7C01%7Cpeng.fan%4
> 0nxp.com%7C7782ad728666475bb26008d76c4b09e1%7C686ea1d3bc2b4c6f
> a92cd99c5c301635%7C0%7C0%7C637096941847790373&amp;sdata=3D17lmt
> wcM4DGWpNCLybY4%2Bv3uXc1pFSHkuJ%2BeV9vPDxM%3D&amp;reserved
> =3D0
>=20
>=20
> All four of those apply only to arm32. arm64 either has them already (fir=
st
> three), or it doesn't apply (protect vector, IIUC, is arm32-specific).
>=20
> I'm not aware of anyone working on those currently, so they would be very
> welcome! :)
>=20
> Thanks for reaching out!

Thanks for the detailed information. I'll give a look.

Thanks,
Peng.

>=20
> --
> Kees Cook
