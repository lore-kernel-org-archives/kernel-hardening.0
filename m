Return-Path: <SRS0=vsYs=V5=lists.openwall.com=kernel-hardening-return-16685-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 074DEC433FF
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Aug 2019 15:39:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 314E22080C
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Aug 2019 15:39:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="WyJXrGsm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 314E22080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nxp.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16685-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10210 invoked by uid 550); 1 Aug 2019 15:39:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32629 invoked from network); 1 Aug 2019 14:36:36 -0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYr2meXM69npODDLpXFK2I9B2npkCPXNSX6HmMpdgLAXbyDf+xxP6Qf3O4zyKnBzDGroP5sQTt8YgNAK9PkZbpC8nYCCeh3FYU7UrFuOPrQnn/0iLUq87ZL/e4SMVfmQeMkoDQtFbXY9ePTCVCTrmXGD1GZVa5DtV9NjlHzDy+LyOCNyRPUgAuKVHN0UTipdGn/ECsjxaWKOV9Lz5tpyFeCSsWMmD/54RAEudofd2XUCMJxU2tUljI+TvLK2idhayzYVYz7We5yYRDTQni2loR2+fp5ANgPaQymo/yHw0bS7H8OPBImW+0PNgAP4MoK/VZD46o4+yFXDk4H8hvqPiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R1j/xWNjVhtuG2exxoTdvMOB9LNEHw7+0yc17MrH46Y=;
 b=BZ4C5h4x87Vskxygq3frV3XK6+h0C3d39jLUi9pwlLSNFH/kDZxWy6f59MdDRQLi2cgurXBw0RhPnKoF/I8OOrOSsklf3Rl4Ci8uJrYmvpzHxZMEvgXzNoUxFq6s4P1Itzelwm9KoVdCpbdlaf/OOCW8Kw0GIRf7qyiV1Av/YKwmHEkEzhBvmJl+h4Hq5+Q0vPnx40e044jIUq2EBHAjyH/vX7r8Lp/HPx/Ba86AD6/LZ2qyZI28pYzLXzz3BmHIpriSw8JsSVZgT9T+VLbQf7YTxx94N+FRK810DDPtv9gIinl3fHaXKWMB1QHqez4X+tcoEIbi7eko2OSq1m788g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R1j/xWNjVhtuG2exxoTdvMOB9LNEHw7+0yc17MrH46Y=;
 b=WyJXrGsmn4FXQQJhe3tXVQLg5uWoTsJmf4S0nhZYY/9TSRaLjqcCphEq3808cIbbmP48SDyX81D1VXVRDlBfYtDSXd54c+1yJCBL/4z++HM+sPZj1tFCzKU6BFQmF4Tgl5Zb30XAEwwTD3hpJixZjtHOYxKxI1XmY6IxBUFvrjI=
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
	<fanchengyang@huawei.com>, "zhaohongjiang@huawei.com"
	<zhaohongjiang@huawei.com>
Subject: Re: [PATCH v3 00/10] implement KASLR for powerpc/fsl_booke/32
Thread-Topic: [PATCH v3 00/10] implement KASLR for powerpc/fsl_booke/32
Thread-Index: AQHVR4IOWsHaCjD120G4pOTxFRhTEA==
Date: Thu, 1 Aug 2019 14:36:23 +0000
Message-ID:
 <VI1PR0401MB2463844DD4A35EB3F0959C22FFDE0@VI1PR0401MB2463.eurprd04.prod.outlook.com>
References: <20190731094318.26538-1-yanaijie@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=diana.craciun@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72743461-46de-4921-e1ec-08d7168da0c2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam:
 BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2560;
x-ms-traffictypediagnostic: VI1PR0401MB2560:
x-microsoft-antispam-prvs:
 <VI1PR0401MB2560E5A77FDEDC43B55E37F3FFDE0@VI1PR0401MB2560.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report:
 SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(396003)(366004)(136003)(376002)(199004)(189003)(2906002)(53936002)(446003)(9686003)(14454004)(55016002)(74316002)(4326008)(476003)(3846002)(14444005)(66946007)(76176011)(6116002)(66476007)(25786009)(486006)(86362001)(68736007)(91956017)(66556008)(66446008)(64756008)(53546011)(2501003)(478600001)(7416002)(76116006)(6506007)(2201001)(52536014)(316002)(229853002)(6436002)(66066001)(6246003)(26005)(33656002)(110136005)(54906003)(99286004)(305945005)(71190400001)(5660300002)(102836004)(81166006)(7736002)(256004)(8936002)(71200400001)(186003)(8676002)(7696005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2560;H:VI1PR0401MB2463.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info:
 rDDQTg5OvWA7GSwZ05UaGnO4tNwVcZjyxgAueL6sf9TB/zng76XdJTcgSgAC1lexmiHoh0ZWIqDdUCPpRNOqltcdgZI+ckVsd4kgMPdD+8nH/9cqvQ9GKCZGJzKBmEzVhZykBqakuP07s5p+b9DGBa8CvWxaKvpCIRjoAGnojtDLnsIC7tpOJHfk7rtlEPSjV05xGJC7z7FoZIwv/2gswU0e/WCVL8F22jHXN9fEugFPmAvcnGBzH6b+M1TSKPQqAlInvzHgw3FLtrdvllGAw+SMXrPyCP0bnKzTZzCLC3ftotIhdnl29gIZ2t8Aastd6FjWeZjOt+9X557j9eIR1+MqfXq9irHQzcJb312shWHMW23V+XqENTSyaA5p3exRSlQ9yhto90LVgU1hNOB0+t91aaf5lLH+JJmPTfNyxZc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72743461-46de-4921-e1ec-08d7168da0c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 14:36:23.8810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: diana.craciun@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2560

Hi Jason,=0A=
=0A=
I have tested these series on a P4080 platform.=0A=
=0A=
Regards,=0A=
Diana=0A=
=0A=
=0A=
On 7/31/2019 12:26 PM, Jason Yan wrote:=0A=
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
> Changes since v2:=0A=
>  - Remove unnecessary #ifdef=0A=
>  - Use SZ_64M instead of0x4000000=0A=
>  - Call early_init_dt_scan_chosen() to init boot_command_line=0A=
>  - Rename kaslr_second_init() to kaslr_late_init()=0A=
>=0A=
> Changes since v1:=0A=
>  - Remove some useless 'extern' keyword.=0A=
>  - Replace EXPORT_SYMBOL with EXPORT_SYMBOL_GPL=0A=
>  - Improve some assembly code=0A=
>  - Use memzero_explicit instead of memset=0A=
>  - Use boot_command_line and remove early_command_line=0A=
>  - Do not print kaslr offset if kaslr is disabled=0A=
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
>  arch/powerpc/kernel/head_fsl_booke.S          |  55 ++-=0A=
>  arch/powerpc/kernel/kaslr_booke.c             | 427 ++++++++++++++++++=
=0A=
>  arch/powerpc/kernel/machine_kexec.c           |   1 +=0A=
>  arch/powerpc/kernel/misc_64.S                 |   5 -=0A=
>  arch/powerpc/kernel/setup-common.c            |  19 +=0A=
>  arch/powerpc/mm/init-common.c                 |   7 +=0A=
>  arch/powerpc/mm/init_32.c                     |   5 -=0A=
>  arch/powerpc/mm/init_64.c                     |   5 -=0A=
>  arch/powerpc/mm/mmu_decl.h                    |  10 +=0A=
>  arch/powerpc/mm/nohash/fsl_booke.c            |   8 +-=0A=
>  17 files changed, 558 insertions(+), 48 deletions(-)=0A=
>  create mode 100644 arch/powerpc/kernel/kaslr_booke.c=0A=
>=0A=
=0A=
