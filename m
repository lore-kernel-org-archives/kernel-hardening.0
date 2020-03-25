Return-Path: <SRS0=ZjnL=5K=lists.openwall.com=kernel-hardening-return-18220-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E80C43331
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Mar 2020 12:15:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D3D9B2076A
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Mar 2020 12:15:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=intel.onmicrosoft.com header.i=@intel.onmicrosoft.com header.b="CE6OPq90"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3D9B2076A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18220-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23767 invoked by uid 550); 25 Mar 2020 12:15:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23725 invoked from network); 25 Mar 2020 12:15:31 -0000
IronPort-SDR: d0AaceLsUcsDzhuiv1zzmUaySAvoaVwMTy1Im8k4affVHqS0lpzkwnhRuYp0l+SgEa1+eedLCQ
 pEfvTggpT0DA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: fshHeAjRpcY2QmeRHJ1oayCf+XifNxCDfJLwJiGn+cFX1tws7VlOKitEAEkmV6KGOdSn4NwC1R
 g3rl1BhCgTCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,304,1580803200"; 
   d="scan'208";a="420294717"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QrSSnE+xLd7T99TOEmQSdD8WXzwERX7NctpBhGfNGVyuGdsVE4cKTa8ME6JH/LRDsvlIxK7Hfw1gG/z2Y+486CY+D/vdfyZ+u3O1fomyMOMVwJTUVzqpSjUyogsxnREzgFbMrLcMNb1rwp6rbBCVYCc4w7lkEu2hzDPNCLZ3dwFRDXtdEPeal4ENH3mvwsJZWw3cMSqeTIbjBGnEBIWqOkLEWb3dYgTTyumgNB+nSPwftanfKUDuJkEDSWrb3dKVQPR3s7KTsi1Qffu6nu0LuLDILFkLdCwiV1fvTJt8KvHYvdudAjeT9JA6tNgTfyOQIgfPaTa++V+mOnka515kcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YrAe+ZxIvMfxBdnhr2CijWf5vpWwbAXFuv2S6UTzOZQ=;
 b=c7dkQtqz5QDI0tmn2NKblgeYmiIkfSw5FdmdhYPMIBfZD8Xb2HiiUbj/gmtIhb3s+hjKenhjNZAbdAxfU7cYR8cg2gAVYuCi8mrdmhqNWKw7nXAl8fbraoU9TGmgu3jwKiPbr/kpdZuz2EcvkCj9JA+25AbpOC6SbSk8Ig5Wq/sv1+1J21tVx2JHWx8bwvFUXEQ2umEOrHqEhTF4Rt9ogfUhq7eRuATOfYRr+R21XtyQU0gIerJscS6blOSW1v8fPA2+NOaTOxABzKY/i11whwZoU3APqSEEuMBVJAHzmIDZIGLdjoqZFcClTpr15efan7ewILdo6kWR+tnNT9Zeyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YrAe+ZxIvMfxBdnhr2CijWf5vpWwbAXFuv2S6UTzOZQ=;
 b=CE6OPq90eYLysvXzc521yPqnRiYrLoaO6yr2Ws6wXY8PB76eWoe+FVF8+XbOlsqOixkHEgyrZpuWWTbh2t1f3EfgcsDSIsQxVIfu7pzhmf+ZnhmFNY33qPCpWVvLkr8Ban4AGixxmDgAUCBAsKUbzzXoGQ/ulEjid4VwxMFB+gU=
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, the arch/x86 maintainers
	<x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, "Alexander
 Potapenko" <glider@google.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Linux-MM <linux-mm@kvack.org>, kernel
 list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 0/5] Optionally randomize kernel stack offset each
 syscall
Thread-Topic: [PATCH v2 0/5] Optionally randomize kernel stack offset each
 syscall
Thread-Index: AQHWAhtwq3buLIhNY0uHCAE/uJPRC6hYQiKAgAAbvoCAANt94A==
Date: Wed, 25 Mar 2020 12:15:12 +0000
Message-ID: <BL0PR11MB3281D8D615FA521401B8E320E7CE0@BL0PR11MB3281.namprd11.prod.outlook.com>
References: <20200324203231.64324-1-keescook@chromium.org>
 <CAG48ez3yYkMdxEEW6sJzBC5BZSbzEZKnpWzco32p-TJx7y_srg@mail.gmail.com>
 <202003241604.7269C810B@keescook>
In-Reply-To: <202003241604.7269C810B@keescook>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=elena.reshetova@intel.com; 
x-originating-ip: [193.210.230.89]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b4fbd89-f70c-4462-79a3-08d7d0b62bb6
x-ms-traffictypediagnostic: BL0PR11MB3220:
x-microsoft-antispam-prvs: <BL0PR11MB32207DC9ABA2DCEAE8BEF60BE7CE0@BL0PR11MB3220.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0353563E2B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(136003)(396003)(39860400002)(346002)(5660300002)(66946007)(6506007)(66476007)(7416002)(2906002)(26005)(52536014)(66556008)(64756008)(66446008)(33656002)(76116006)(55016002)(86362001)(81156014)(81166006)(8936002)(8676002)(9686003)(71200400001)(4326008)(478600001)(186003)(7696005)(54906003)(110136005)(316002)(4744005);DIR:OUT;SFP:1102;SCL:1;SRVR:BL0PR11MB3220;H:BL0PR11MB3281.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R0fHfiHe8IwDhu/PudqxvcDZ+HOwdID1+Ng9PLiwh0AO1XId7kD5n6/N6KkV53W4qA5fCWm1kMve7REZUR8b7tfsZ0qwzO1SbmzfzUQuTef3Q+RWQizkUkYOeFdNG9QLqnsGNyhhKpTeHHKHAoC4GFvWo4/fjB1EaC3+6oQRGRJcBSyXd9ZvKE2SnVVzKJZ7Zrd1BNOW8gk+0CDvQ1pE6PEAionQk/bCbpGWMP+cjfucQM5Iz8gOvPfOvt2jSzXH/ZVO2yeoHuhQzV8ijn20hPRMlKrV9A697E5gJICuCt6rqGUznVewzCHr1aUmYKoLmo3n21Xj6AA7+LQwriDcfqXX9+3uFAoupeeHwP8GgrAiYmz9N3XQHDgLpgpEqXlL2z+735Dt1q/0R88sYS8pxh9HILua5BGYthTXDBiP8bmt1Bi2Plg/wkUSdnnJenMP
x-ms-exchange-antispam-messagedata: /CNCpOp659D172WBicTizC4uCv6sPoROncMCkc7ljYWplLv4kJ8C/Ss7dwBTKoPT+B9cN+1DoEN/AQPs7mMyIYvDkPMoQMYW4Gi/KGoDUcdz3XyyuTKwfhNpVkmCtSxcrVO1oEa6sESZV3nQbrXr5A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b4fbd89-f70c-4462-79a3-08d7d0b62bb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2020 12:15:12.9820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9BUpkDalH6Xfnn9q/Z4fatBvI6iYdf5wUeTPr7aT+6vnesukWh+gAF4FEkKMS4KS4GMmteUqxdITni7Y6iZK8dHgLLKOWqP5PLikRjEu6Ew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3220
X-OriginatorOrg: intel.com


> > Also, are you sure that it isn't possible to make the syscall that
> > leaked its stack pointer never return to userspace (via ptrace or
> > SIGSTOP or something like that), and therefore never realign its
> > stack, while keeping some controlled data present on the syscall's
> > stack?

How would you reliably detect that a stack pointer has been leaked
to userspace while it has been in a syscall? Does not seem to be a trivial
task to me.=20

Best Regards,
Elena.=20
