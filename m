Return-Path: <SRS0=9TPF=NW=lists.openwall.com=kernel-hardening-return-21383-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E39A3C4320A
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 19:10:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 12EA16103D
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 19:10:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 12EA16103D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 28156 invoked by uid 550); 31 Aug 2021 19:09:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28120 invoked from network); 31 Aug 2021 19:09:53 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10093"; a="216702887"
X-IronPort-AV: E=Sophos;i="5.84,367,1620716400"; 
   d="scan'208";a="216702887"
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,367,1620716400"; 
   d="scan'208";a="510043522"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3Ym8WXrmBc4PXqUJUBMMvEaE9zr6SwmF7ng4LTGRxRwaElB4DP/bm83IxkNloGTcmzrKJyvlqkJgXe+gynEYD99v26y4pwVRZZ6zDKRWnH54vsTZ01v4Zer/AKtkGKkiRoefUIVQ1NeL89gIXyxpXZiRliFwBFxOnWjyPf0C6GEAu2hgrq5/BzgqRlAWOfR1pl50ElecctKDAdthik7krWvB+A7yBUtrEtHcvjv4Gtq0WYovy0Y0LRmbBaMec2pVJaTd824ZBo+Y+vrQBZs8zq9THaUtMp4uXFxR1SopXJOeoWZmThjYC8LkmHrnqI1PLPoCkJMjsRRDBTYwuXR+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qu8jUeUrsBlLXGr8Huxh5wGR+oR/KdfM//tH7ufbnZs=;
 b=TPghluRC6IqOahzFLiqXByvMIfwgyudSeLBkgr0g4G+CONDg0C4NJcz3yXd8J2IVSPXSRVVnWYOQL0FIVud1IoW3or5fiUVjgRPmpKvH/P6mL5emvQfpAmWTf3dpVt9r9tDcOM/U2Ka2ihOwLre/rUEniMAjSWWA8E4/ZJm5ZKpMwLI+Ndd8sy+RgkJF1odQO25jJ0AL58YZ5J/4A+AX90TEGB1ACzP1USqBPDHtfgJo8yxGCMDzEWRuct9wMplZ/tcFwowl3aIrFnHZiOMs0IPfxO01SsMfP3wI2H9OT1cQjRZuO+/VBrUXuq9HnvT14LlXesVfwVpAz33JpEM9Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qu8jUeUrsBlLXGr8Huxh5wGR+oR/KdfM//tH7ufbnZs=;
 b=cuHkufWbDSBgTUxKDIAveUZ/EYxrGYn+fhsfl8EgTjuo24EsflXUrZSmr8j6su9V/0/6SBkNlweueEBMieGhH76IQ8rMpQH/6dSP+bKwdFb/Mlq4ipKbziylvjqXzxUwy+F5KMSRVpoqi3TI4quUL7zbP8bpOkt9CHF0d0QmlLk=
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "rppt@kernel.org" <rppt@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "keescook@chromium.org"
	<keescook@chromium.org>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"Lutomirski, Andy" <luto@kernel.org>, "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "shakeelb@google.com" <shakeelb@google.com>
Subject: Re: [RFC PATCH v2 05/19] x86, mm: Use cache of page tables
Thread-Topic: [RFC PATCH v2 05/19] x86, mm: Use cache of page tables
Thread-Index: AQHXnfsu5iVgl9DJvESbwS1BLBN02auNS5yAgACv0gA=
Date: Tue, 31 Aug 2021 19:09:19 +0000
Message-ID: <d7e9e00b2cdab115fa9d6bc83549d6f37b3bf043.camel@intel.com>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
	 <20210830235927.6443-6-rick.p.edgecombe@intel.com>
	 <YS3q4Q+ybxweHoLK@kernel.org>
In-Reply-To: <YS3q4Q+ybxweHoLK@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ec1bf07-8eab-4977-ac43-08d96cb2d5ea
x-ms-traffictypediagnostic: SA2PR11MB4827:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB482716F7CA6E4F3AA580D9A8C9CC9@SA2PR11MB4827.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y/UYJtqfzaNQEMdADjoQYghC6IEPIcaWU6tWeXc6z9dba64EsGIz26mFTrJsNkJWJ4boFE8UXl5I82XVXoqkRMX1A9h/ihh/1xtYYlWFdMArv6B5IuLQeLShVAWM+6IZlnY4z9y7TopQyKyaGF4zLBPZ9asPqyd+93e8GYVXbpGHB7nGKI7HTNMA4s37Tbtf/Q7+N+rEGrCVNvqxrJefQVgt4ZePHl3P2CrfWJnaSmZkZywALmDiZzu7IG8fXJSX+3FskSEkW/DM/C2aiucJnsU910Ft9Bwb3+n+np+Ga5xVap3sndGuX2ZLG5LXXmJYqv+hjdn/Lvvt19cDDupDoFkLFufFs5UvAJVl1aL1ATJfr2TganZqDspGDasKIi4s/92KFxQapZpad/PnyNdoZzQXfvAKR9yLd2lFK2hljqef0/cHAvQbTsYNLboIRMc0GerCae6cmHPw//+7H7JwDQvh2WmAfxncltl3MtlUPG5kd34sI2pOlDL4lLrDWhgKJYi7Lj+rRyT4GQr8DAhQaTSxfd991Pbg/Um/5CLWq5m9la6PHlpo7nTMD+C6iO/oXG3oWwOaWU/CcD8rpC6HiywiTFOC3OggULXZqmZno/h8ftnBlO/+lPLn/skbw1UHJfE5LzmQN5ixi+W+rkC9tOoBatqGVenvqT00r0kD+gQxQfe/ZL99Ka1N9vVSn5iuHvyc6ncUkBLerY82OEdFfQ6XxmMRb7h8kq+4ohBWs2E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(396003)(136003)(376002)(26005)(6512007)(6506007)(5660300002)(478600001)(86362001)(36756003)(4326008)(2906002)(8936002)(54906003)(7416002)(64756008)(6486002)(66476007)(316002)(186003)(91956017)(2616005)(66946007)(38100700002)(6916009)(66556008)(76116006)(66446008)(83380400001)(122000001)(38070700005)(8676002)(71200400001)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RldaVzJIYkVRZDdwYkw3M3BBbTR2SWQ0dFg0NEJ5VXo3UW9WMFhjSEhnc3hN?=
 =?utf-8?B?NHdHVVVtaHhrWVNZTGthN3loZUVxRzhFc2VEMHRwNGhnRExsTkJ2SjdyVEhl?=
 =?utf-8?B?Tmxoc3dCdExXaktsdTVmWndTU0FqQyt4azJpQ1F6ajlubThYWTF4K2Nkd0FT?=
 =?utf-8?B?RFBGY01MRzZlZDRMVHkySjZuclR5Zm0wbmhWcDYzY1lkN3pPdVVtVHBheXZI?=
 =?utf-8?B?K1dUVFg0ZXZBeFUxVnBPTXlTS1dmd1BVdzBDQ3lGcmYxclM4eVgrait2TGs3?=
 =?utf-8?B?bTBOU0J3VFk2NUxzMTZGVWlyNFVuZWNNeUVRNzhTQm03M3BEOWpiN3RKU1J6?=
 =?utf-8?B?MVVHVzczVWpDYk43d2JjMGF2Rkk0Rk5RYk9Sbm4rMFpCQlNUMnJSNkhPait6?=
 =?utf-8?B?TlBkeFZCNVE1ZjV6SHVOY0tsOVRJWmNmYzRUdTdJU2lGc1ZiNThFUDY1QWg3?=
 =?utf-8?B?a0k0aFlkS01xa1doWWdrall6NjVVSHprS0c0VUhrdWd2V001L24vS2ZpMkUy?=
 =?utf-8?B?cGlaY3FnMDZzend0a20rMUc4aGs1VU9UMGNuVGhqL1ZCN2c1NWp2Ui81aFlT?=
 =?utf-8?B?QmkxWFptczRFNjJQODRvWnRWM0tWQThGaHk0Umg5WXRqb1BLQXVWQndWckZk?=
 =?utf-8?B?WWs0SjROUTB0eEE3M05JaWZvNW1mY0VlRENqWnpvT2VKbnFoMjMxSi84SGJj?=
 =?utf-8?B?bE0wS2FLclFpWUlTYWs1V2JKWmJjT0E3amROazhPeElETWE4TmdreXk3NWhP?=
 =?utf-8?B?MnI5VkVRa0VGV1FIQS9mYUd4cVF6ZkdDVUplSnkwS0dPa3VXTEtVb2RwcVl2?=
 =?utf-8?B?eDU2cEV3azlNWjJONEw3VGZocFBIOHFlN1pIRUlWLzMzYUJxQ2ZpNTZneFFZ?=
 =?utf-8?B?VndKdVhsbmZlK2lOTWVwRjNKMWl6TTBGcHlxRzZqeWhNc3lacElaUUozM3VN?=
 =?utf-8?B?ZUYzdGVZMWwwRXRhL1puU05WUUN2MnBsaHpwZFVFU2ZUSFplZEZ5NDZETExh?=
 =?utf-8?B?U2JvTTllZTNjbVJ5TXJseGdCM3Rxa1YwWnFsc0hjQTFqWEdCemJPOGdDK3Bp?=
 =?utf-8?B?ZXdNMkpnZnlFTkV4cjdmaTZjOEdiR2duZUVzMnZ6TzBBQXB3OUtlVUxJUU8v?=
 =?utf-8?B?OHBiTUZ2K2Jvc0Vhb1Z4dWlUS25hRXNiWnVTdkN0eGpxcXpRMzhLZTNZZDU5?=
 =?utf-8?B?blFVR0JWb1R0a3o5bmRPU1RmZmVTa3NqT1A5QlRoWmtXai9vM1pLR2M5SE9s?=
 =?utf-8?B?RnJjR1RMeUI5cWRnM2pDNEloKy92NXRuRG1Td1FvQm94VXFjaUVFT0ZWb3VI?=
 =?utf-8?B?cFhUaGt2dVp5SU5ZaEdNUDhESkVyV2RmTno1UkQvQ3U2N0MvUURlUEhTNldH?=
 =?utf-8?B?UEFZTmI3K2JBT3g1RlJ2VGdnakRuNC9zSkRHYmkrRStxc1pSWm00ZG9wYkZD?=
 =?utf-8?B?eHJkZVExK0VVVmNmMjU4RWRBSXZDZDZQMUZtNHp0TWVhdWhHRGZxenpCSGk2?=
 =?utf-8?B?VWNHVE1yU0ExS095MkYySTduK2dQc0xiR0N2TWMxTExyUmRIeEM2ckU0VlJO?=
 =?utf-8?B?MlhxbWZXdlkrVW0xMjdNQWZqYzhLbldhTUthTGtDTGVBZmRWeE5TWEkyTWlr?=
 =?utf-8?B?bnZlZHB6ZzNwend3aFQrZVpDZ2xHaXVsVS9yeWZUQlNpNXZINklVdzZlUzAz?=
 =?utf-8?B?SHdMaW9NY003czZ2L0RRTjB6NUtOcjVCaGgyLzk2aW9ERFhndHpXZFg1L1Ir?=
 =?utf-8?B?dkxNamFCU1o1RHUyR29ma0FvMWMzZ3lucXU5OEpxNFhDY2J4aVhhVnlOY3Er?=
 =?utf-8?B?UDJDZHkxS29TWVVMdmw0dz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <56F824050DBD3D409E922145B19FDA13@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ec1bf07-8eab-4977-ac43-08d96cb2d5ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 19:09:19.6691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: epUhT/Dv1sWt54RMsR55CwCCmQPedpDEyVhHNTJQnBJ90Gx/vKDfaOvgpZXR2zS+9JtlW673qjNTr9WrA+pPwsChc6FtoVMWExvYHr9FrRg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4827
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIxLTA4LTMxIGF0IDExOjQwICswMzAwLCBNaWtlIFJhcG9wb3J0IHdyb3RlOg0K
PiBPbiBNb24sIEF1ZyAzMCwgMjAyMSBhdCAwNDo1OToxM1BNIC0wNzAwLCBSaWNrIEVkZ2Vjb21i
ZSB3cm90ZToNCjx0cmltPg0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS9wZ2FsbG9jLmgNCj4gPiBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3BnYWxsb2MuaA0KPiA+
IGluZGV4IGM3ZWM1YmI4ODMzNC4uMWZmMzA4ZWE3NmNkIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gv
eDg2L2luY2x1ZGUvYXNtL3BnYWxsb2MuaA0KPiA+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNt
L3BnYWxsb2MuaA0KPiA+IEBAIC03LDYgKzcsMTAgQEANCj4gPiAgI2luY2x1ZGUgPGxpbnV4L3Bh
Z2VtYXAuaD4NCj4gPiAgDQo+ID4gICNkZWZpbmUgX19IQVZFX0FSQ0hfUFRFX0FMTE9DX09ORQ0K
PiA+ICsjaWZkZWYgQ09ORklHX1BLU19QR19UQUJMRVMNCj4gPiArI2RlZmluZSBfX0hBVkVfQVJD
SF9GUkVFX1RBQkxFDQo+ID4gKyNkZWZpbmUgX19IQVZFX0FSQ0hfQUxMT0NfVEFCTEUNCj4gDQo+
IEkgdGhpbmsgb25lIGRlZmluZSB3b3VsZCBzdWZmaWNlLiBJZiB3ZSdkIGV2ZXIgaGF2ZSBhbiBh
cmNoaXRlY3R1cmUNCj4gdGhhdA0KPiBjYW4gaW1wbGVtZW50IG9ubHkgb25lIG9mIHRob3NlLCB3
ZSB1cGRhdGUgdGhlIGlmZGVmZXJ5IGluDQo+IGFzbS1nZW5lcmljL3BnYWxsb2MuaA0KPiANCkdv
b2QgcG9pbnQsIEknbGwgY2hhbmdlIGl0Lg0KDQo+ID4gKyNlbmRpZg0KPiA+ICAjZGVmaW5lIF9f
SEFWRV9BUkNIX1BHRF9GUkVFDQo+ID4gICNpbmNsdWRlIDxhc20tZ2VuZXJpYy9wZ2FsbG9jLmg+
DQo+ID4gIA0KPiA+IEBAIC0xNjIsNyArMTY2LDcgQEAgc3RhdGljIGlubGluZSB2b2lkIHA0ZF9m
cmVlKHN0cnVjdCBtbV9zdHJ1Y3QNCj4gPiAqbW0sIHA0ZF90ICpwNGQpDQo+ID4gIAkJcmV0dXJu
Ow0KPiA+ICANCj4gPiAgCUJVR19PTigodW5zaWduZWQgbG9uZylwNGQgJiAoUEFHRV9TSVpFLTEp
KTsNCj4gPiAtCWZyZWVfcGFnZSgodW5zaWduZWQgbG9uZylwNGQpOw0KPiA+ICsJZnJlZV90YWJs
ZSh2aXJ0X3RvX3BhZ2UocDRkKSk7DQo+ID4gIH0NCj4gPiAgDQo+ID4gIGV4dGVybiB2b2lkIF9f
X3A0ZF9mcmVlX3RsYihzdHJ1Y3QgbW11X2dhdGhlciAqdGxiLCBwNGRfdCAqcDRkKTsNCj4gDQo+
IC4uLg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9hc20tZ2VuZXJpYy9wZ2FsbG9jLmgg
Yi9pbmNsdWRlL2FzbS0NCj4gPiBnZW5lcmljL3BnYWxsb2MuaA0KPiA+IGluZGV4IDAyOTMyZWZh
ZDNhYi4uZTU3NmMxOWFiYzhjIDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvYXNtLWdlbmVyaWMv
cGdhbGxvYy5oDQo+ID4gKysrIGIvaW5jbHVkZS9hc20tZ2VuZXJpYy9wZ2FsbG9jLmgNCj4gPiBA
QCAtMiwxMSArMiwyNiBAQA0KPiA+ICAjaWZuZGVmIF9fQVNNX0dFTkVSSUNfUEdBTExPQ19IDQo+
ID4gICNkZWZpbmUgX19BU01fR0VORVJJQ19QR0FMTE9DX0gNCj4gPiAgDQo+ID4gKyNpbmNsdWRl
IDxsaW51eC9tbS5oPg0KPiA+ICsNCj4gDQo+IFdoeSBpcyB0aGlzIHJlcXVpcmVkPw0KPiANCj4g
PiAgI2lmZGVmIENPTkZJR19NTVUNCj4gPiAgDQo+ID4gICNkZWZpbmUgR0ZQX1BHVEFCTEVfS0VS
TkVMCShHRlBfS0VSTkVMIHwgX19HRlBfWkVSTykNCj4gPiAgI2RlZmluZSBHRlBfUEdUQUJMRV9V
U0VSCShHRlBfUEdUQUJMRV9LRVJORUwgfCBfX0dGUF9BQ0NPVU5UKQ0KPiA+ICANCj4gPiArI2lm
bmRlZiBfX0hBVkVfQVJDSF9BTExPQ19UQUJMRQ0KPiA+ICtzdGF0aWMgaW5saW5lIHN0cnVjdCBw
YWdlICphbGxvY190YWJsZShnZnBfdCBnZnApDQo+ID4gK3sNCj4gPiArCXJldHVybiBhbGxvY19w
YWdlKGdmcCk7DQo+ID4gK30NCj4gPiArI2Vsc2UgLyogX19IQVZFX0FSQ0hfQUxMT0NfVEFCTEUg
Ki8NCj4gPiArZXh0ZXJuIHN0cnVjdCBwYWdlICphbGxvY190YWJsZShnZnBfdCBnZnApOw0KPiA+
ICsjZW5kaWYgLyogX19IQVZFX0FSQ0hfQUxMT0NfVEFCTEUgKi8NCj4gPiArDQo+ID4gKyNpZmRl
ZiBfX0hBVkVfQVJDSF9GUkVFX1RBQkxFDQo+ID4gK2V4dGVybiB2b2lkIGZyZWVfdGFibGUoc3Ry
dWN0IHBhZ2UgKik7DQo+ID4gKyNlbmRpZiAvKiBfX0hBVkVfQVJDSF9GUkVFX1RBQkxFICovDQo+
ID4gKw0KPiA+ICAvKioNCj4gPiAgICogX19wdGVfYWxsb2Nfb25lX2tlcm5lbCAtIGFsbG9jYXRl
IGEgcGFnZSBmb3IgUFRFLWxldmVsIGtlcm5lbA0KPiA+IHBhZ2UgdGFibGUNCj4gPiAgICogQG1t
OiB0aGUgbW1fc3RydWN0IG9mIHRoZSBjdXJyZW50IGNvbnRleHQNCj4gDQo+IC4uLg0KPiANCj4g
PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9tbS5oIGIvaW5jbHVkZS9saW51eC9tbS5oDQo+
ID4gaW5kZXggYzEzYzdhZjdjYWQzLi5hYjYzZDVhMjAxY2IgMTAwNjQ0DQo+ID4gLS0tIGEvaW5j
bHVkZS9saW51eC9tbS5oDQo+ID4gKysrIGIvaW5jbHVkZS9saW51eC9tbS5oDQo+ID4gQEAgLTIz
MjcsNiArMjMyNywxMyBAQCBzdGF0aWMgaW5saW5lIGJvb2wgcHRsb2NrX2luaXQoc3RydWN0IHBh
Z2UNCj4gPiAqcGFnZSkgeyByZXR1cm4gdHJ1ZTsgfQ0KPiA+ICBzdGF0aWMgaW5saW5lIHZvaWQg
cHRsb2NrX2ZyZWUoc3RydWN0IHBhZ2UgKnBhZ2UpIHt9DQo+ID4gICNlbmRpZiAvKiBVU0VfU1BM
SVRfUFRFX1BUTE9DS1MgKi8NCj4gPiAgDQo+ID4gKyNpZm5kZWYgQ09ORklHX1BLU19QR19UQUJM
RVMNCj4gPiArc3RhdGljIGlubGluZSB2b2lkIGZyZWVfdGFibGUoc3RydWN0IHBhZ2UgKnRhYmxl
X3BhZ2UpDQo+ID4gK3sNCj4gPiArCV9fZnJlZV9wYWdlcyh0YWJsZV9wYWdlLCAwKTsNCj4gPiAr
fQ0KPiA+ICsjZW5kaWYgLyogQ09ORklHX1BLU19QR19UQUJMRVMgKi8NCj4gPiArDQo+IA0KPiBD
YW4ndCB0aGlzIGxpdmUgaW4gYXNtLWdlbmVyaWMvcGdhbGxvYy5oPw0KPiBUaGVuIHlvdSB3b24n
dCBuZWVkIHRvIGluY2x1ZGUgbGludXgvbW0uaCB0aGVyZS4NClNvbWUgYXJjaGl0ZWN0dXJlcyBj
b3VsZG4ndCBmaW5kIGl0IGluIGFzbS1nZW5lcmljL3BnYWxsb2MuaC4gVGhlcmUgaXMNCnNvbWUg
b3RoZXIgcGFnZSB0YWJsZSBzdHVmZiBpbiBsaW51eC9tbS5oIHNvIGRpZG4ndCBzZWVtIHRvbyBz
dHJhbmdlLg0KDQo+IA0KPiA+ICBzdGF0aWMgaW5saW5lIHZvaWQgcGd0YWJsZV9pbml0KHZvaWQp
DQo+ID4gIHsNCj4gPiAgCXB0bG9ja19jYWNoZV9pbml0KCk7DQo+ID4gQEAgLTIzMzcsNyArMjM0
NCw2IEBAIHN0YXRpYyBpbmxpbmUgYm9vbA0KPiA+IHBndGFibGVfcHRlX3BhZ2VfY3RvcihzdHJ1
Y3QgcGFnZSAqcGFnZSkNCj4gPiAgew0KPiA+ICAJaWYgKCFwdGxvY2tfaW5pdChwYWdlKSkNCj4g
PiAgCQlyZXR1cm4gZmFsc2U7DQo+ID4gLQlfX1NldFBhZ2VUYWJsZShwYWdlKTsNCj4gDQo+IFRo
aXMgY2hhbmdlIGlzIG9ubHkgdmFsaWQgd2hlbiBfX0hBVkVfQVJDSF9BTExPQ19UQUJMRSBpcyBz
ZXQuDQpBcmdoLCB0aGFua3MuIE92ZXJhbGwgc29sdXRpb24gc2hvdWxkIHN0aWxsIHdvcmsgSSB0
aGluay4gSSdsbCByZXdvcmsNCml0IHRvIHN1cHBvcnQgYm90aC4NCg0KPiANCj4gPiAgCWluY19s
cnV2ZWNfcGFnZV9zdGF0ZShwYWdlLCBOUl9QQUdFVEFCTEUpOw0KPiA+ICAJcmV0dXJuIHRydWU7
DQo+ID4gIH0NCj4gPiBAQCAtMjM0NSw3ICsyMzUxLDYgQEAgc3RhdGljIGlubGluZSBib29sDQo+
ID4gcGd0YWJsZV9wdGVfcGFnZV9jdG9yKHN0cnVjdCBwYWdlICpwYWdlKQ0KPiA+ICBzdGF0aWMg
aW5saW5lIHZvaWQgcGd0YWJsZV9wdGVfcGFnZV9kdG9yKHN0cnVjdCBwYWdlICpwYWdlKQ0KPiA+
ICB7DQo+ID4gIAlwdGxvY2tfZnJlZShwYWdlKTsNCj4gPiAtCV9fQ2xlYXJQYWdlVGFibGUocGFn
ZSk7DQo+ID4gIAlkZWNfbHJ1dmVjX3BhZ2Vfc3RhdGUocGFnZSwgTlJfUEFHRVRBQkxFKTsNCj4g
PiAgfQ0KPiA+ICANCj4gDQo+IA0K
