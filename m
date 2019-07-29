Return-Path: <SRS0=BXD+=V2=lists.openwall.com=kernel-hardening-return-16616-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E933EC433FF
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Jul 2019 14:38:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 14AB320578
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Jul 2019 14:38:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="mt/gTzcM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14AB320578
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nxp.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16616-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3644 invoked by uid 550); 29 Jul 2019 14:38:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25975 invoked from network); 29 Jul 2019 14:30:28 -0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dmzkZhD9rfo468Kfd7Mhc+h3vRlWO4Lvj7phir8E0BlgENE6BD9oVs9i81VxK76tzq18X/iHgzuqnABJ1M/IuaFA/k/VQpS5XaYb3AOtVHQsDQ3xJywQd+YKworz8IrcrpifZ3Gz1MIjwjJhmMQ8eWLWop4OWGJs6nIAYF+C4L9Q8IvCaGeEi+uVZk06ANJy17qOMY0WNnDVCT/RQIn61UHJz2bHRM3NRI6AI4lVwhcUFVeccSBn1pQZOI2VCMvQVN8cR/zO4Rj+h3F4VXjPBRbMIwP0x5db1qXaN+a9yplkVxZthg9Nzvpv4wj8+F/3sB2B0ZL8CGbSS6ydNfkr/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+wCdu3SvhhI5Nq9aA0GPKeBPlhpLiUeh0ZGbhj8Xt0=;
 b=G2fOYIDl2fdx7HrVBrWy1+foilcK4b2e1rop8KcziRLdG572ztrEpqy/lDaeSJ8zfdh1NwZdifzPgvD60fxbxRYdlu029O+6+1ElGxfIVzHCVPAag1IrH8/8jrmrLJNcG/Rbtz6Wg+KGgD0FEL9Gl66FABTnclqrE+sx4eBOXMdQmLVtZZEjabErOrvLJVQUqa8F6AoC/hbxCjbAyzuokC/snwiWT9j6TkT14+U+WuaG7gEqdVYYNGTEAyhF9nM9ONYvIR/IhDS9wfEUP08shGT0Q2KMVIBXHXr2qQ7hv9G9KZq37fvwDTVDqnzux94a2BflIRgXQe2JB0MdpmtakQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+wCdu3SvhhI5Nq9aA0GPKeBPlhpLiUeh0ZGbhj8Xt0=;
 b=mt/gTzcMcUYriI0vKZGE6+LrhRyvCos2qVmdmLzJsRlVmpxY9OYoEAYA6wf1tAVD2J2nO8hZ0UDqxaS0acnJhLCUb5SvMZWTgOxi7xNSGvK31jKJD2OZEkKHYbL//C12z+P7136OM7CCyP7zewlJpdDUMWVpKs4dfJGQ6YFvkJY=
From: Diana Madalina Craciun <diana.craciun@nxp.com>
To: Jason Yan <yanaijie@huawei.com>, "mpe@ellerman.id.au"
	<mpe@ellerman.id.au>, "linuxppc-dev@lists.ozlabs.org"
	<linuxppc-dev@lists.ozlabs.org>, "christophe.leroy@c-s.fr"
	<christophe.leroy@c-s.fr>, "benh@kernel.crashing.org"
	<benh@kernel.crashing.org>, "paulus@samba.org" <paulus@samba.org>,
	"npiggin@gmail.com" <npiggin@gmail.com>, "keescook@chromium.org"
	<keescook@chromium.org>, "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"wangkefeng.wang@huawei.com" <wangkefeng.wang@huawei.com>,
	"yebin10@huawei.com" <yebin10@huawei.com>, "thunder.leizhen@huawei.com"
	<thunder.leizhen@huawei.com>, "jingxiangfeng@huawei.com"
	<jingxiangfeng@huawei.com>, "fanchengyang@huawei.com"
	<fanchengyang@huawei.com>
Subject: Re: [RFC PATCH 00/10] implement KASLR for powerpc/fsl_booke/32
Thread-Topic: [RFC PATCH 00/10] implement KASLR for powerpc/fsl_booke/32
Thread-Index: AQHVPHQmPxsZ5ebrqkOb0IKUtKxd9g==
Date: Mon, 29 Jul 2019 14:30:15 +0000
Message-ID:
 <VI1PR0401MB24633E9C5475F8D50536C46FFFDD0@VI1PR0401MB2463.eurprd04.prod.outlook.com>
References: <20190717080621.40424-1-yanaijie@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=diana.craciun@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 078f2f98-c292-4f27-a3bb-08d7143145ef
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam:
 BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2272;
x-ms-traffictypediagnostic: VI1PR0401MB2272:
x-microsoft-antispam-prvs:
 <VI1PR0401MB22727C6BC38B9DE504EFFAA1FFDD0@VI1PR0401MB2272.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report:
 SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(189003)(199004)(91956017)(8676002)(446003)(66946007)(7736002)(7696005)(486006)(76116006)(476003)(2906002)(81156014)(81166006)(52536014)(71190400001)(55016002)(3846002)(66066001)(33656002)(256004)(14444005)(76176011)(64756008)(66556008)(9686003)(6116002)(66446008)(71200400001)(66476007)(53936002)(2201001)(14454004)(99286004)(305945005)(229853002)(6436002)(7416002)(2501003)(68736007)(8936002)(4326008)(110136005)(54906003)(86362001)(478600001)(5660300002)(186003)(102836004)(6246003)(6506007)(53546011)(25786009)(316002)(26005)(74316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2272;H:VI1PR0401MB2463.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info:
 q7M8rIkdoFNPpU/P2Oy9SYKAFR2WdSN/U5EtI4DErjW55sbqkLsSLM7Vr4zXxfZmKStqHBuMT6vMC9+vKVz3C7KJpGAGkP+yQ6W+NBCLgjLTHzSOyfMctRZ4ZJXZr7X1KsGzsb6dJf8jRcBzvr0r7lN6d45WDsjGt4bDhD9mRVLW6b0f4ruav0l0+ax8g4z++l6eP1gZ5JZUW+EmUi9n+7UDpGsuvsFTV6knugPZZrNZEk8UShXJBC0NRUDB3uL9CWLXnJCVFT1TzO4FqdHnDo4HsixAsrVagmZskTxMhRrcCxbgz8P/5T6JYdiLP1J1cLCev9HnLy0KrzfmGYKueIl+hDXXIM0akzgUe798PsN5fyZndUS/4FRAuEcTPZlIV5g4X/qtC986hLStS2wDdY+ijvB0FkX5Nd56KqMoHg8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 078f2f98-c292-4f27-a3bb-08d7143145ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 14:30:15.4829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: diana.craciun@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2272

Reviewed-by: Diana Craciun <diana.craciun@nxp.com>=0A=
Tested-by: Diana Craciun <diana.craciun@nxp.com>=0A=
=0A=
=0A=
On 7/17/2019 10:49 AM, Jason Yan wrote:=0A=
> This series implements KASLR for powerpc/fsl_booke/32, as a security=0A=
> feature that deters exploit attempts relying on knowledge of the location=
=0A=
> of kernel internals.=0A=
>=0A=
> Since CONFIG_RELOCATABLE has already supported, what we need to do is=0A=
> map or copy kernel to a proper place and relocate. Freescale Book-E=0A=
> parts expect lowmem to be mapped by fixed TLB entries(TLB1). The TLB1=0A=
> entries are not suitable to map the kernel directly in a randomized=0A=
> region, so we chose to copy the kernel to a proper place and restart to=
=0A=
> relocate.=0A=
>=0A=
> Entropy is derived from the banner and timer base, which will change ever=
y=0A=
> build and boot. This not so much safe so additionally the bootloader may=
=0A=
> pass entropy via the /chosen/kaslr-seed node in device tree.=0A=
>=0A=
> We will use the first 512M of the low memory to randomize the kernel=0A=
> image. The memory will be split in 64M zones. We will use the lower 8=0A=
> bit of the entropy to decide the index of the 64M zone. Then we chose a=
=0A=
> 16K aligned offset inside the 64M zone to put the kernel in.=0A=
>=0A=
>     KERNELBASE=0A=
>=0A=
>         |-->   64M   <--|=0A=
>         |               |=0A=
>         +---------------+    +----------------+---------------+=0A=
>         |               |....|    |kernel|    |               |=0A=
>         +---------------+    +----------------+---------------+=0A=
>         |                         |=0A=
>         |----->   offset    <-----|=0A=
>=0A=
>                               kimage_vaddr=0A=
>=0A=
> We also check if we will overlap with some areas like the dtb area, the=
=0A=
> initrd area or the crashkernel area. If we cannot find a proper area,=0A=
> kaslr will be disabled and boot from the original kernel.=0A=
>=0A=
> Jason Yan (10):=0A=
>   powerpc: unify definition of M_IF_NEEDED=0A=
>   powerpc: move memstart_addr and kernstart_addr to init-common.c=0A=
>   powerpc: introduce kimage_vaddr to store the kernel base=0A=
>   powerpc/fsl_booke/32: introduce create_tlb_entry() helper=0A=
>   powerpc/fsl_booke/32: introduce reloc_kernel_entry() helper=0A=
>   powerpc/fsl_booke/32: implement KASLR infrastructure=0A=
>   powerpc/fsl_booke/32: randomize the kernel image offset=0A=
>   powerpc/fsl_booke/kaslr: clear the original kernel if randomized=0A=
>   powerpc/fsl_booke/kaslr: support nokaslr cmdline parameter=0A=
>   powerpc/fsl_booke/kaslr: dump out kernel offset information on panic=0A=
>=0A=
>  arch/powerpc/Kconfig                          |  11 +=0A=
>  arch/powerpc/include/asm/nohash/mmu-book3e.h  |  10 +=0A=
>  arch/powerpc/include/asm/page.h               |   7 +=0A=
>  arch/powerpc/kernel/Makefile                  |   1 +=0A=
>  arch/powerpc/kernel/early_32.c                |   2 +-=0A=
>  arch/powerpc/kernel/exceptions-64e.S          |  10 -=0A=
>  arch/powerpc/kernel/fsl_booke_entry_mapping.S |  23 +-=0A=
>  arch/powerpc/kernel/head_fsl_booke.S          |  61 ++-=0A=
>  arch/powerpc/kernel/kaslr_booke.c             | 439 ++++++++++++++++++=
=0A=
>  arch/powerpc/kernel/machine_kexec.c           |   1 +=0A=
>  arch/powerpc/kernel/misc_64.S                 |   5 -=0A=
>  arch/powerpc/kernel/setup-common.c            |  23 +=0A=
>  arch/powerpc/mm/init-common.c                 |   7 +=0A=
>  arch/powerpc/mm/init_32.c                     |   5 -=0A=
>  arch/powerpc/mm/init_64.c                     |   5 -=0A=
>  arch/powerpc/mm/mmu_decl.h                    |  10 +=0A=
>  arch/powerpc/mm/nohash/fsl_booke.c            |   8 +-=0A=
>  17 files changed, 580 insertions(+), 48 deletions(-)=0A=
>  create mode 100644 arch/powerpc/kernel/kaslr_booke.c=0A=
>=0A=
=0A=
