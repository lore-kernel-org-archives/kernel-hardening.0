Return-Path: <SRS0=w1lv=NW=lists.openwall.com=kernel-hardening-return-21378-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70BFEC4320E
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 17:56:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 20CBF61059
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 17:56:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 20CBF61059
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 25908 invoked by uid 550); 31 Aug 2021 17:55:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25873 invoked from network); 31 Aug 2021 17:55:51 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10093"; a="279545879"
X-IronPort-AV: E=Sophos;i="5.84,367,1620716400"; 
   d="scan'208";a="279545879"
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,367,1620716400"; 
   d="scan'208";a="645408297"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YcpeGUW/9EwZftHyjkAnvTf8ktPxEGhCrCbmPGoET3/a/sQgwymvbdHV3paiPhNDIj2YJPGM/R5xQX1AmYXPqVdD5rbIEKVHbxpJ/e7wSSS1bu5Zv0kwM1QLx5aKXwZ3iE/iqGtlJan7lThJYcK30jc5JjSjmvJyTC5f7ygBlYYd+LCaWUVxN4sw9Nvkn8Pp5mRsYBS4LWPku+xYTh4wE/73dmHLrv7zznPXfWWN7MEdiS04PwI/XBWc+YcSEUluyAM2LOs0CjleQ+YLsmFPQsl5NtSetxz4Vj0tDZz1YNOh5mfHUMY5K2XH+R5cLIU4riWaG+dYWL7Fu1Qur5F5yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4SDt1eAVFScwlfCesRmtqDG/pcAVWz4MZLo87sbNTRk=;
 b=IoOqQLM9ENXzy7LgcvhiPXaHeEAnjkDHUoVZbSWDc1amSYfQeBgtVnW5uh6zm7xBpbxxgWVK7Wr//kVRqPVe34foUPKGnGneew88TizlQpL3uf7O0fayg2aa3HN71bsF3My7VuJjI+AAabncXanO6zCNQY1hHaEYEEzgDCaIKGvFrz+WXYqnZ2kcFNQ8XMiSAwU0oI9V1GN+UrwcVYYtdZy+XV5uU2wXKmP/msMMf5leTltw6vHtmts9c/wNqjmiP0gcRC0GJwsMar5xj7KH5JGtGs4c1tS+Zj+voCAbw9LzkUr2tDVt9RaJmT/DKPTTGWwe7rV70bDjdHZOxen05Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4SDt1eAVFScwlfCesRmtqDG/pcAVWz4MZLo87sbNTRk=;
 b=AhFPFrzy3MYKtLzTnMjoTP8zjVJFg9TJEfxZMm/oPXFSX8dJwwiw4AIcxS9u9fT0FuhZIVmwBEHCWwaZ4R8NJeCyUwwe8agjzzDkr/tnnOQbCnlFwfN/mKNBbog8trV3i0YvJYGYOWpkfHPsRV78UFAs8+0sja9NUsYhoSzGva4=
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "peterz@infradead.org" <peterz@infradead.org>, "keescook@chromium.org"
	<keescook@chromium.org>, "rdunlap@infradead.org" <rdunlap@infradead.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "Lutomirski, Andy" <luto@kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "shakeelb@google.com" <shakeelb@google.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [RFC PATCH v2 18/19] x86/mm: Add PKS table soft mode
Thread-Topic: [RFC PATCH v2 18/19] x86/mm: Add PKS table soft mode
Thread-Index: AQHXnftBX/vcpSfYlUWInlizZDpM2KuM+o8AgADsMYA=
Date: Tue, 31 Aug 2021 17:55:17 +0000
Message-ID: <402a645ddb31326c80d6d0eb649813816eaa6634.camel@intel.com>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
	 <20210830235927.6443-19-rick.p.edgecombe@intel.com>
	 <052d20c6-347d-6340-1a62-d62bf53d3315@infradead.org>
In-Reply-To: <052d20c6-347d-6340-1a62-d62bf53d3315@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5908ba8f-40bd-4ef5-75a2-08d96ca87e5a
x-ms-traffictypediagnostic: SN6PR11MB3072:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3072133ED9810B52EF89940FC9CC9@SN6PR11MB3072.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NjZ3UH6Jp8coiu3pWYEO9/cQmJqU7lkIW20vgdrdN/Zxw2Hs3qv8glaE46fFsYnRIMIIba9Plx2aYVRprDDL0rpL1sVrO89SWqoUl2FSScS/cfoy1ZIf5VDHCLEK8kdgtvL4K4ga81FV08gnU/RrGqAJDLN3BK9UmdzHucuat5J7vycv4WF3qtPp0UTIePc3ilF2n128xDHkBrPncbriXqD5VYSX+aPXQht4uRuGltM/K5dr+EWkeNQ3mRNs2YsrZrn2V1LTc61iGFLw0BxKStfdXVKyJJPKf5/OehyhgfnzPn+UIiiTxeYgdxCeTujoNzzqwu+5MevXAW0fYunRGjegi4b92//6BGj/KL2YcfKh5u2kUljAYf75T47NKpnm8/XTlYZZH2I2IAm7EwFD563nY1cX+gly6EtHU84QeK6wHGaaX3wNWpIHJk0Lre3zZzByjCioTDUOCH69MYlYn6EuQkgKymaL89fJaoFOyW6VWORC6upVuaDpUiYmxxMFpUfZ1wpaQg0UUBv7nO1vaa5zLmLA6TXzqhvL3Ycsmx1vXjytvUv3L30tGHfVdHoJcFBk4Khip8ryqkYDADxKrMCD6sCQWG5bbEI6l7aL6JjOcwhDj8GknyMz2a0D95ezpsNMkHiF//My5FcO5BUHBsrhDlsylyQ5uB2tpeuF5D47a2RFI0fxYRl7ZcYYBVqqmpms+ibguZV1wroQ4LJpxGf3je67tK5gDemUPzy5sxoL0evAfuLIG9ogq8pOufsj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(478600001)(2906002)(8676002)(66476007)(38070700005)(6512007)(2616005)(4326008)(921005)(36756003)(6486002)(66946007)(53546011)(4744005)(316002)(71200400001)(54906003)(5660300002)(7416002)(186003)(76116006)(26005)(64756008)(66556008)(66446008)(8936002)(91956017)(38100700002)(122000001)(6506007)(110136005)(86362001)(83380400001)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b0RVc3FHNGhEL201LytUZHFyVURQK1JaMVZZMHBGY0hFamRKeXF4K3loSU9B?=
 =?utf-8?B?eVZaZWkyNDdYS3hFMzI3a3NlcmU4S3dxNGw2MUNnL1JGTExDUE5WbzRRNzNa?=
 =?utf-8?B?TzQxbFc5ekRVNHlBcm1pcVFEeTRJM21SUUc2T2FYWkhCUzE2TVBEOVNyejNn?=
 =?utf-8?B?WGR2Z2F0RW03NXhDamljbGNuaFd1VGEyWGxRWDRUeENkQ25aaDFtRWdrYjdZ?=
 =?utf-8?B?dVdUTndjWFMyN2IwT0l3Zmtla3J2VzdCQTR3UG1KNzNnSnVQS1JBOTh6OGxW?=
 =?utf-8?B?dUpNTzBjUUxRTVNVVFNpam1SV1R4Q2lhOEZ2YW5YekcrYWRPRFFSdDFNWWNQ?=
 =?utf-8?B?aFVMT2NDMDdlTG1KWGhKUnBoUk5iazZCOTZpYmtWU2FtUjJwb1dEMXNUSEtz?=
 =?utf-8?B?MmdkWFhtWmo5NnRsS3hIU0gwVmo3RDErREFSTjR3RFJ3SmlJenkvNlJDTm5r?=
 =?utf-8?B?Z0xmVEhkWVRqR1FzNDlOU2lUd0Y5WGVONlNldzNTVVkwTVJDOTV6R3hWRVky?=
 =?utf-8?B?SkgrVVZSWE9tbGVrRnY1c1RIb0NvRFJRWGpEdkkzekJnTlR0UDNYNFp0czlH?=
 =?utf-8?B?VXFVZUgrZlNSQmJ6dnE5QkV5SmVLdUVLMitVdjIzaVNGU1ViVXl5WXgvNzB4?=
 =?utf-8?B?YVNocTNxbkVSRExyMTRZR1B4UkRzSytvVEhsMHJrTkY3SnE5Z1p0L0gxV204?=
 =?utf-8?B?dmNOblYzUmVFQ2tSVU41OFcweVBoOXR3UktHNkZ4UmFMbmFJVllUQzcvaE1u?=
 =?utf-8?B?YkE5dXhCS0dOa2ZZQmMrTkhWazZrdXRyYXpsT00vTTdKWmNXYkNKd3FUaTRH?=
 =?utf-8?B?NlRnZElBMXRyWGprSnFkaUZyTnIwL1VDeGdMclVwU0RvQXZIK2N1YkFEeFF1?=
 =?utf-8?B?eWs2RnpaM0RmK2NiN0k4Njd3K0FhSmNlaDgwa2FxaHd5dUxjYVRwTkFTRGkv?=
 =?utf-8?B?S3o2NUkyb0Q3dnFLVjRIMVpTU1RRRzN4dXN4U3RHZ3N1UUFhNXRyNHl1L0tO?=
 =?utf-8?B?WnFJaG92dmE0L2h6WDFRc3RBbnBTRGI3WENocHpGdmhCNFZHbVFDb2x1MGRP?=
 =?utf-8?B?TE83NnpPcDQreC92UlhqcjA5aFcvTGt6MG5FWURlcTdYWkRadGdnOFNDS0RD?=
 =?utf-8?B?clZxU3l4eldUcHFqWmpkdjd0Y2wrY2xlK2tzNXdaTXNYVmxvNmJBVVd2Q0Z3?=
 =?utf-8?B?dSsvRUYvcW01TlhtUmJkazJLdXUrRU5JRUdHUHJzenBxZ2NaTVFPY1FyY1U4?=
 =?utf-8?B?WSswS0hibE1tNmdTb0ZBUWxJMXk4QllZK2VTMEZqdFU3eDdwdENUUmYyTE80?=
 =?utf-8?B?cWlqcGdZbkpzU3c3RjZkelpwMUZFL2VrMGphaGJBTmdMRXBvL2hHTWE1Wkh5?=
 =?utf-8?B?MFJhVE94RElMTGwwUkpPT3AzelhNUk9iSkE5U3BaNE1aT3VFOGtTWDdWYWNh?=
 =?utf-8?B?N29tY0xXVUhMTVVYR3k5VlNZQjNNM1JBck5rditTbGNGQnMvV3p4OHRhcDlY?=
 =?utf-8?B?VkJSaElFNUI5Rk1vZlBCbHFrTk43UitaaGJOVEppYTBXVWRIbGFrd2RrMHFt?=
 =?utf-8?B?Sk5MOGcyNmFGMFE1NXBNaGs1cW1kUXYzTUU3Z2k1bjIzSWNlNzJwUy9VODg5?=
 =?utf-8?B?RGFWUEVIRGdEVkgyM2M5OXl4Vm5tbks5NzgvMEpvd1VZV3RhZmh2NXpzSGlk?=
 =?utf-8?B?UXFKWm1hN252RHE0d2dhRXRlcU9DWGFXTnMweThyWnRZcWFSSjJ1WTJWc3Rt?=
 =?utf-8?B?ZnErSjlibVhYOHlYQStmc2hBV1RYWjhHRkVTWnAzOElyY3BGOEZoMDJkd0Z4?=
 =?utf-8?B?UjBkeWF4dU5XY3FNdDE2UT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <62345EED40A0224DAFDAEC89EE9861DA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5908ba8f-40bd-4ef5-75a2-08d96ca87e5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 17:55:17.8519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xym6VujxAuGJDSXE/2zSZ3F1kTazVJd/xCgZL9eREzqpOux9HdcVNYvFEvIpO9SANQ767O/Q6o/0C14ROvDFR+dTB5S4BuuFEMFgFxvOYX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3072
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIxLTA4LTMwIGF0IDIwOjQ5IC0wNzAwLCBSYW5keSBEdW5sYXAgd3JvdGU6DQo+
IE9uIDgvMzAvMjEgNDo1OSBQTSwgUmljayBFZGdlY29tYmUgd3JvdGU6DQo+ID4gZGlmZiAtLWdp
dCBhL0RvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUva2VybmVsLXBhcmFtZXRlcnMudHh0DQo+ID4g
Yi9Eb2N1bWVudGF0aW9uL2FkbWluLWd1aWRlL2tlcm5lbC1wYXJhbWV0ZXJzLnR4dA0KPiA+IGlu
ZGV4IDc5MDJmY2U3ZjFkYS4uOGJiMjkwZmVlNzdmIDEwMDY0NA0KPiA+IC0tLSBhL0RvY3VtZW50
YXRpb24vYWRtaW4tZ3VpZGUva2VybmVsLXBhcmFtZXRlcnMudHh0DQo+ID4gKysrIGIvRG9jdW1l
bnRhdGlvbi9hZG1pbi1ndWlkZS9rZXJuZWwtcGFyYW1ldGVycy50eHQNCj4gPiBAQCAtNDI1NCw2
ICs0MjU0LDEwIEBADQo+ID4gICAJbm9wdGkJCVtYODYtNjRdDQo+ID4gICAJCQlFcXVpdmFsZW50
IHRvIHB0aT1vZmYNCj4gPiAgIA0KPiA+ICsJbm9wa3N0YWJsZXMJW1g4Ni02NF0gRGlzYWJsZSBQ
S1MgcGFnZSB0YWJsZSBwcm90ZWN0aW9uDQo+ID4gKw0KPiA+ICsJcGtzdGFibGVzc29mdAlbWDg2
LTY0XSBXYXJuIGluc3RlYWQgb2Ygb29wcyBvbiBwa3MgdGFibGVzDQo+ID4gdmlvbGF0aW9ucw0K
PiANCj4gcHJlZmVyYWJseQkJICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgUEtTDQo+
IA0KU3VyZSwgdGhhbmtzLg0KPiA+ICsNCj4gPiAgIAlwdHkubGVnYWN5X2NvdW50PQ0KPiA+ICAg
CQkJW0tOTF0gTnVtYmVyIG9mIGxlZ2FjeSBwdHkncy4gT3ZlcndyaXRlcw0KPiA+IGNvbXBpbGVk
LWluDQo+ID4gICAJCQlkZWZhdWx0IG51bWJlci4NCj4gDQo+IA0K
