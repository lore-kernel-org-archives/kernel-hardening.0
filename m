Return-Path: <SRS0=sudE=EK=lists.openwall.com=kernel-hardening-return-20360-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AE7EC2D0A3
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Nov 2020 16:09:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9AA8C2080D
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Nov 2020 16:09:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="0zC723ce";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="0zC723ce"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9AA8C2080D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20360-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11990 invoked by uid 550); 4 Nov 2020 16:08:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11958 invoked from network); 4 Nov 2020 16:08:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJg9LWxDkBqnTvXChI+dbRR+BoThaIHNKZbwLF8Ms3s=;
 b=0zC723cewfcZxK/Ds/FXDZpof6cO/Hh8yNma4NeWPzeu5kIz7j6obZLSEwkAetJgt9W9zE2HNV06JHbpo3pA8iok5tji9vcXoBHAgtrbUBQNYEyrPhW5Me4oSn7uhho9LNP/oWes1i6Sxc7G6o+jrhuJGpKjeptTjtc8cGXBe+o=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.openwall.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;lists.openwall.com; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
X-CheckRecipientChecked: true
X-CR-MTA-CID: 39b346bc75defc7a
X-CR-MTA-TID: 64aa7808
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0zsXIb4N7EK8iQDeOIDuoGZkEpTJVGmTJKb+4LjlSICxQc6GqAtPkm3lG7s09uNmnih1QecLUYHbis0RkZG1SANz0tWj4yreSSYYgDgCzSUAI7UkXMKGrvxpipQhZFiYDeZxvhrcczmi856MQmpVUOLCInqRXYXyalsrvoE3F17e2q6gf/UYD4t+bGQPfNeLja0WTHqFvcY/3p27O1KCEzzrUHAMh26gu8d8ZJniQIOkDuldk5aK5zDcZ85jdjx5jqk/nfQWKzXAJE5/EATZr7Pa7EYS8Dc/h03TsBPQW3+CRMLWL5wtNgEXkss/ms4KzQRbSfeH5P67Hus5Hb8gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJg9LWxDkBqnTvXChI+dbRR+BoThaIHNKZbwLF8Ms3s=;
 b=frLO5qBnBud3Um6RPY/JFE+loA/Jbe1r+JVDnqKefVRQ+okz6NzOYl5y4Z3OXRnTWvXeCKbqjViwKKemvXDr1FRp60X+C6es6fp7Hr4z2Mx6YlPY8ODg4envsH+tl7ibxKaeKuL9b6+QZb3PKOi9GP+3sgSy6IsIaGmNeZ7dg4UgnoC+jMA3UFNkDjVT0cU6hFzWUFPn2i1EcxZ+tbXwIMmPn7ecv4upJ+dYNjkORy+YYMezh64QZ5GEGeHwGWhdmlAwMs+NcqDrrxSdk+MKhr+ieCQkkMtFd4hAwL8FKGxfZlYLvmi4r/gS0ema/jdyMPEh6U7nW1Aa8SRSRiC4+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJg9LWxDkBqnTvXChI+dbRR+BoThaIHNKZbwLF8Ms3s=;
 b=0zC723cewfcZxK/Ds/FXDZpof6cO/Hh8yNma4NeWPzeu5kIz7j6obZLSEwkAetJgt9W9zE2HNV06JHbpo3pA8iok5tji9vcXoBHAgtrbUBQNYEyrPhW5Me4oSn7uhho9LNP/oWes1i6Sxc7G6o+jrhuJGpKjeptTjtc8cGXBe+o=
Authentication-Results-Original: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=arm.com;
Date: Wed, 4 Nov 2020 16:08:10 +0000
From: Szabolcs Nagy <szabolcs.nagy@arm.com>
To: Topi Miettinen <toiwoton@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Florian Weimer <fweimer@redhat.com>, Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>, libc-alpha@sourceware.org,
	Jeremy Linton <jeremy.linton@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Salvatore Mesoraca <s.mesoraca16@gmail.com>,
	Lennart Poettering <mzxreary@0pointer.de>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH 0/4] aarch64: avoid mprotect(PROT_BTI|PROT_EXEC) [BZ
 #26831]
Message-ID: <20201104160810.GD24704@arm.com>
References: <cover.1604393169.git.szabolcs.nagy@arm.com>
 <20201103173438.GD5545@sirena.org.uk>
 <20201104092012.GA6439@willie-the-truck>
 <87h7q54ghy.fsf@oldenburg2.str.redhat.com>
 <d2f51a90-c5d6-99bd-35b8-f4fded073f95@gmail.com>
 <20201104143500.GC28902@gaia>
 <f595e572-40bc-a052-f3f2-763433d6762f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f595e572-40bc-a052-f3f2-763433d6762f@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.140.106.54]
X-ClientProxiedBy: LO2P265CA0140.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::32) To PR3PR08MB5564.eurprd08.prod.outlook.com
 (2603:10a6:102:87::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9bcea7a2-3a91-4351-5847-08d880dbe421
X-MS-TrafficTypeDiagnostic: PA4PR08MB6110:|VE1PR08MB5790:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<VE1PR08MB57906B103709381C48F6CFC5EDEF0@VE1PR08MB5790.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 eRDvAKnvuUN8LSsaY7Wed5Jy2FTi/ucBB8twfl3xFU+SIZ/AFelWpXHFQET4VOr6KqPImnDEbx4ksgPf4ZLvut7UWzIKSr2XuBjWtofOK379Va0JU/SyxwYrj6cAqlxlBzR0VGZfbhWmKvmqqIYjHzYW7/9Xzpphn7rbrqilh6asnOncAUNiJJ00+BFgI0grGRqX/S+EAG4E2YnCA9DB19DHnFb9umAQ3T0Zl/yv98lYhVlTY8zp6pAe2/IrSxnBfqI0USfrx7Ab2TY84KYwTrbhuBrK0wCOdiVhQndJID2kHu+tggtc1YOjt7z0A+j6LF3HSy91BtBxLLmiH2hWiOMYx5bpVHO3MGcHLQirZsHbwQXQiutdtiK0HL65qz0hjRvx/E8VSZEXDYXc/cKH36t3WaFo8RDRiDcUFr6DKUT1OvVy4mhodjf6a0n8NYT0NHhMsknKcdMYVfoPlUZs1g==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5564.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(54906003)(956004)(2616005)(86362001)(5660300002)(8886007)(2906002)(8936002)(186003)(26005)(16526019)(1076003)(36756003)(7416002)(8676002)(44832011)(83380400001)(4326008)(316002)(52116002)(33656002)(66946007)(66556008)(66476007)(55016002)(6916009)(7696005)(478600001)(83133001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData:
 scDUYs+Yv4uhYCKZH9t9N+P0Zngv37kPjysPacw5USUCg8sdv4MY5wce17g4H/965mY06CiOg6yfjhphz2w48k2b40y8e/NRLjuYRm5a9JQ4naV52kt/d5UuB9vJUocLBkbb0X6I2CTcxhwFrxLHbVBeyzPg1gsEFGqNvTJzvat5Ic0Wz/nYv1yE7YziY28j0YIVvPBlm/XtqE0ZNqbe+V1z7q8UeMEKIgl4LI2eTz+dbbqLG0ARHGzDKqEpoa5zFnhkPXa3/fPRBZYb3Bvhubhi9hWUxTIHOMHiRVGpBCJI2dX+fTA2TABqJB38GxVuhTezGFpwuZu6Xfa8LGvbOFIs8LXu9jLQztBP2UrTGnHHOIu6EcPICL5ts7Cbvk116jnxFnQtO0ejalv/uD/ZjrSSMwSYAVKoI6GCqByG3PwRFo9AmaoWGHXowPTM2jYtSTYJzQobyGSXjLVDHqwbCRMuA4WPUgLFyTlP1vaRyo97Irdm4dRzbfiS6th1gm+LfqKb6dS/oqEsWY5ErqasKeq61Ks6h/9fZ8QeUE2laxo74qQSpdGS7tpfBA/Qk4gBBEV8KK0Twh2Wb2RXINhxbr2JoqAbgdgc7rwoZJQBkJUYjslbg+spPA81TdaugJRNCrO2cCp9fuBBibSc/CvqXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6110
Original-Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 VE1EUR03FT020.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	91106ac1-7a74-4046-cf5d-08d880dbd47d
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5jL0lYigYUFbdfnpHMAupsKTVbn/LB9QkPTXSxTUeL4zo1bKmZhKVCkSqUoGz6B6vy5u3lb0cQ7d/3MNkpxkqj0LWeMjNtL04Uf9COmZxd8anOZqd1IozsKI8KrZtpI46TAhOcnGAyiS1dTLgR97dDSgYUvyawGcNu80XnWXUGxNdL97Mf4W8Yx1UMnsqdaODnLjyIK3J5MT+z/QYvS2bShIOx9Kas5M/+M9WFyHmBmVIfx8m2vqo/+VIdXI7B2vwoFCkBoby8mgqdgfgcCLpejNstqxRDjkmOUlmkY2+BVkaZknjnMueYTS0DfMMKAY4y/rZYO8/tC72hpdPIQ9o1bmvfWNa5Xojzm3TkRiWKNjoW91fuyNCnftxWw3RkIFVCQTgd3xdZiB9ujYMhYCcK1k8lds2jmqacymRP3/9K/MMv3KuBZbb9+vtTStTJr/UmMl3QM2zMD32w+QVpQKCt2kiMV+sFba3PDT4xHgc1uPikSYQ2FaA61PkjmdcR1i
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(46966005)(36756003)(36906005)(478600001)(316002)(16526019)(44832011)(4326008)(26005)(186003)(956004)(54906003)(82310400003)(8886007)(8676002)(8936002)(33656002)(107886003)(2616005)(1076003)(81166007)(356005)(70206006)(70586007)(336012)(47076004)(55016002)(83380400001)(6862004)(5660300002)(82740400003)(2906002)(86362001)(7696005)(83133001);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2020 16:08:38.5439
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bcea7a2-3a91-4351-5847-08d880dbe421
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	VE1EUR03FT020.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5790

The 11/04/2020 17:19, Topi Miettinen wrote:
> On 4.11.2020 16.35, Catalin Marinas wrote:
> > On Wed, Nov 04, 2020 at 11:55:57AM +0200, Topi Miettinen wrote:
> > > On 4.11.2020 11.29, Florian Weimer wrote:
> > > > * Will Deacon:
> > > > > Is there real value in this seccomp filter if it only looks at mprotect(),
> > > > > or was it just implemented because it's easy to do and sounds like a good
> > > > > idea?
> > > > 
> > > > It seems bogus to me.  Everyone will just create alias mappings instead,
> > > > just like they did for the similar SELinux feature.  See “Example code
> > > > to avoid execmem violations” in:
> > > > 
> > > >     <https://www.akkadia.org/drepper/selinux-mem.html>
> > [...]
> > > > As you can see, this reference implementation creates a PROT_WRITE
> > > > mapping aliased to a PROT_EXEC mapping, so it actually reduces security
> > > > compared to something that generates the code in an anonymous mapping
> > > > and calls mprotect to make it executable.
> > [...]
> > > If a service legitimately needs executable and writable mappings (due to
> > > JIT, trampolines etc), it's easy to disable the filter whenever really
> > > needed with "MemoryDenyWriteExecute=no" (which is the default) in case of
> > > systemd or a TE rule like "allow type_t self:process { execmem };" for
> > > SELinux. But this shouldn't be the default case, since there are many
> > > services which don't need W&X.
> > 
> > I think Drepper's point is that separate X and W mappings, with enough
> > randomisation, would be more secure than allowing W&X at the same
> > address (but, of course, less secure than not having W at all, though
> > that's not always possible).
> > 
> > > I'd also question what is the value of BTI if it can be easily circumvented
> > > by removing PROT_BTI with mprotect()?
> > 
> > Well, BTI is a protection against JOP attacks. The assumption here is
> > that an attacker cannot invoke mprotect() to disable PROT_BTI. If it
> > can, it's probably not worth bothering with a subsequent JOP attack, it
> > can already call functions directly.
> 
> I suppose that the target for the attacker is to eventually perform system
> calls rather than looping forever in JOP/ROP gadgets.
> 
> > I see MDWX not as a way of detecting attacks but rather plugging
> > inadvertent security holes in certain programs. On arm64, such hardening
> > currently gets in the way of another hardening feature, BTI.
> 
> I don't think it has to get in the way at all. Why wouldn't something simple
> like this work:

PROT_BTI is only valid on binaries that are BTI compatible.
to detect that, the load segments must be already mapped.

AT_BTI does not solve this: we want to be able to load legacy
elf modules. (a BTI enforcement setting may be useful where
incompatible modules are rejected, but that cannot be the
default for backward compatibility reasons.)

> 
> diff --git a/elf/dl-load.c b/elf/dl-load.c
> index 646c5dca40..12a74d15e8 100644
> --- a/elf/dl-load.c
> +++ b/elf/dl-load.c
> @@ -1170,8 +1170,13 @@ _dl_map_object_from_fd (const char *name, const char
> *origname, int fd,
>             c->prot |= PROT_READ;
>           if (ph->p_flags & PF_W)
>             c->prot |= PROT_WRITE;
> -         if (ph->p_flags & PF_X)
> +         if (ph->p_flags & PF_X) {
>             c->prot |= PROT_EXEC;
> +#ifdef PROT_BTI
> +           if (GLRO(dl_bti) & 1)
> +             c->prot |= PROT_BTI;
> +#endif
> +         }
>  #endif
>           break;
> 
> diff --git a/elf/dl-support.c b/elf/dl-support.c
> index 7704c101c5..22c7cc7b81 100644
> --- a/elf/dl-support.c
> +++ b/elf/dl-support.c
> @@ -222,7 +222,7 @@ __rtld_lock_define_initialized_recursive (,
> _dl_load_write_lock)
> 
> 
>  #ifdef HAVE_AUX_VECTOR
> -int _dl_clktck;
> +int _dl_clktck, _dl_bti;
> 
>  void
>  _dl_aux_init (ElfW(auxv_t) *av)
> @@ -294,6 +294,11 @@ _dl_aux_init (ElfW(auxv_t) *av)
>        case AT_RANDOM:
>         _dl_random = (void *) av->a_un.a_val;
>         break;
> +#ifdef PROT_BTI
> +      case AT_BTI:
> +       _dl_bti = (void *) av->a_un.a_val;
> +       break;
> +#endif
>        DL_PLATFORM_AUXV
>        }
>    if (seen == 0xf)
> 
> Kernel sets the aux vector to indicate that BTI should be enabled for all
> segments and main exe is already protected.
> 
> -Topi
