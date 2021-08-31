Return-Path: <SRS0=ApKu=NW=lists.openwall.com=kernel-hardening-return-21379-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63EDAC432BE
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 17:56:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 853FC60FED
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 17:56:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 853FC60FED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 27743 invoked by uid 550); 31 Aug 2021 17:56:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27698 invoked from network); 31 Aug 2021 17:56:12 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10093"; a="282249837"
X-IronPort-AV: E=Sophos;i="5.84,367,1620716400"; 
   d="scan'208";a="282249837"
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,367,1620716400"; 
   d="scan'208";a="541106752"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ai9bWnR3ZMqQXrwbnBPOWIvrJw0GRBnAdYFCTMS4e5LBoxjdmEXO80K15+smCaaV4VDCQACSAUwrXzq45lAFMUZiH6W4y9ZUhYSE52s38zVRDYw1u0rpknjpQUy8wNEu9vrU5NxDzW2ElDA5HgjAupzo45K0o0FRtA2qdsmVenuicaYitU85SdOdjgT0LDQtKViR1sKjPUFxqB1mHhdagFWu5fV2xFWgucuECcJAvCnlh8VgtZx7R9J+dAIw+tooXlz1edAbq6cpZZ09d5iuiqJR2p204zq7VX9xqF4QsdgGqX8Kqq3iluHG9/jy0Hw5F9kdcdCtpdlVIaJ6kXuT4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VV5IwSWLNBhi7co1JR1v0q8WhFRK2MNGvXEN9X6cWpI=;
 b=oMGhagy1Q1PYTLGfV5ncV5EyJFmcre2InB7HGw1HZKpv/fKid7WTeiSe8RU8OK3V/Mobot0f07LRNNbh39gh2hRnpOtyMn8DWq/ywyZc6TJHwaT8Bfz3BpalexKzvNw3osZZhXkD0kBzGS8mEN58uOBnbw0zTHoKJhmLbzyAX0OPRR7sZrUOT0fHNwQK/5LKnTjbEN4BEqYjCWdyKMukj/rhbwRHvZhvNW0mRpY2c+sWhUOVtaEjQ+2axZVt5ZqR9RVqUBbWeiRxZYMZ65NCDMNALfVmSz+BirHSUBw+jOomGD8MigW9TzxMg9324vq2+IWplJ4xAaKLPir5aRpHXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VV5IwSWLNBhi7co1JR1v0q8WhFRK2MNGvXEN9X6cWpI=;
 b=jRkKA2VLv5Y+K3R6z6P8CrO20ZxbhQKMypK7byi0KS3wCfXH2qXIFSz3P6SCtaHQ8VRwxBPpB6SBHlWCLqZtaSX8LOgmybwzpUO/jNkTk0VEMFe4nrfI1oJ01pN+WXNGUVx/n2MDbTF/BIT42bIkt2uVQhZWJHfOTjNA3vJf0dA=
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
Subject: Re: [RFC PATCH v2 16/19] x86/mm: Protect page tables with PKS
Thread-Topic: [RFC PATCH v2 16/19] x86/mm: Protect page tables with PKS
Thread-Index: AQHXnftAbvm9w68NXkO0PXpPwijKeKuNUBoAgACW0YA=
Date: Tue, 31 Aug 2021 17:55:54 +0000
Message-ID: <3fe91823df2b4a98b37c315bdab8325df6dd6288.camel@intel.com>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
	 <20210830235927.6443-17-rick.p.edgecombe@intel.com>
	 <YS3uphSSY/D3bt5f@kernel.org>
In-Reply-To: <YS3uphSSY/D3bt5f@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2025b736-e005-46e9-2b7c-08d96ca89421
x-ms-traffictypediagnostic: SA2PR11MB4972:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB49722EA04564AE5ABA9EA1D8C9CC9@SA2PR11MB4972.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4Toxs+Vn1jhqJJFVM8xk3QnWsmAnbCPaQm6NsZqiJcZxh9V49zesnQolyJ8uGAOrbGgCR4U3ziXtFoW4bHr+4vxeLNZzjQzIvQxmtFQL5xDLjEw+tXUmUjWCwfXtlGSSOvDyN+RDske21q7rYu/cXrNU8hJH+X+zgbVMUsMDoafuL09wmnm7TrFFIN+5nXmSI7nPe5A/cUSJylcUFdQWFC/9qr1JtzhWcHZ7Cl5TKV2lOiAB2KBLjsI/sE68q6oeDvxVZ6rCLnyQbKBBPW/Vp/zMz9SG5npSBGAs2rBPiB8f/ON9M/cGgmgcu7yTaMTO9GdjhV5X/Fm52Gv9ZbcSHcHJ7r2VLKdTehyrg88FNcrwDOoSfpxj85BkxqTzGcSwjvM3EjcLW1U1+QOLJDoLGAwLLhLEY0B3+m/xlQGgW0+9i08UqhdOERHXciPOuQ8qBPr5J+ljOENsNFWejQ/2172brSERwzuDeaNzUkSsmIsa8/yYtb9hBHdOaSr5jD/HwyxXMtnrml/6pIUrTOlJhw9CV+vWPQbJOdfBj3zXnECBF027JMnyi5F+jU9a0BMshQPy88nX3I8zz/R2HpR+AbCE6i6QvhDYJKETDC8211uJZvXXaVxgqkLuiI6tJYKPL+4OYopXX+Bj61O3riIwKk1tF0S2T3nbpoLmV2PwRwuNx2T8+I0Au+8AWbNYpQMXk4LyQINvAlo0PbHiYjd6GbvubORtcxJhpepeBucCVeI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(396003)(376002)(346002)(66946007)(6486002)(91956017)(38070700005)(54906003)(86362001)(316002)(64756008)(36756003)(76116006)(38100700002)(8936002)(2906002)(122000001)(7416002)(66556008)(186003)(83380400001)(2616005)(66446008)(71200400001)(6916009)(8676002)(6512007)(66476007)(4326008)(6506007)(478600001)(5660300002)(26005)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RDFQWEVOcmtSWGh1bzlLaE5VSHI1OGhaNVVMUnU4TEhwYzlLWXFqWjJVZGtB?=
 =?utf-8?B?WFZ0WmM5bW9nVlNkeWhYY1ZEWnBGWjVKd1ZHek9FV0ZNbU5VbXVSa1VZdlhS?=
 =?utf-8?B?NHgzajlMZmJwN1FmYUlCeGc0YkVLOXZPcC9Tbk1seGNOUDNvaWlreDUzRXF3?=
 =?utf-8?B?OXdQOVZhaVhNNWhiOEJHN0FtRjdQSUVuVlZJMWgwdjZab0o0VFlVVER4dGxy?=
 =?utf-8?B?N0xMb0JkbmVoZlpnUjlubzVRUHhETDdGVktwbnlubFp0dkcrcWZXMUxDZURl?=
 =?utf-8?B?ckFUcVJyV1FrR2x0My9qTW1HQldjWS9JamdQWll6MTByQS92Qjh1Q1JyeTdB?=
 =?utf-8?B?dDBsamwrSlJNMUFsM1hsbTMwMXV5WXZnek0wYm5BWlM1TVZsVXRkc1RJeTdK?=
 =?utf-8?B?U01UcG11S3M0d2tLbWQ5K01MTC9aUENvRXp6S1RlNnVMOXRjK3JGR0RLYkVQ?=
 =?utf-8?B?SUo2TEJUK3dobGZHSjhMZHUrL1VsU0loU21mMmxtN2FLRTVFa21jSit0YW9k?=
 =?utf-8?B?SGc3M1JHT3BXSG5TQk5HNFRSODY4RktTTFo5amRiNnlVcGNiSHdJUHppdXBQ?=
 =?utf-8?B?RkpVT0FZNmhsN2VyTXpoN0dYbFRNNENXOFNBaCs2OG9nOUQzMXZ6SFVBSmxa?=
 =?utf-8?B?eXhQbVRsNG8xL2JFb0NLQ2xmQ2NrNXRFdFJCY2dTNGtCQlNBOUlQaEg4VnE4?=
 =?utf-8?B?UjFCb0lISWpEMkdaM2txd1NlZzlUSmRnTVhCWnd3M0pNMHhkZXp1MTMzdlNy?=
 =?utf-8?B?dGJrY2FsY3R3ZFNLSmZWMXlwcnFDOG51ZGVac0wyNGhYMGd0WGFpMDdqQ0pY?=
 =?utf-8?B?RW5QT2l6OU5TZGhmWTFqeHhnTm1wdmVTMkVoRFZyWjgzR3ZzYkNSV3NYKzN4?=
 =?utf-8?B?M29TZVhnSkZjZnNHalZCTGVvMFYwWThpcnJsalJ0aE9CVFdwVy9QZDdUZnJW?=
 =?utf-8?B?OEdnRWpNWEl4Y2xtRHFKK0d6VEM2Zm42U1ZkdUxSMFVzR3dUYlAvUTJWYjZN?=
 =?utf-8?B?UWx3OGN2TDdSckl2NlQvWFlIbEt6VEJnRWxVSEMyaU1Hc2lCbTJvWU4vQU9q?=
 =?utf-8?B?VVVRdHZEWjhoSlVoQXhzTTUxYXREc1NVMThKaFNOajBFajZ0ODZSeXdCRDhw?=
 =?utf-8?B?SUdtRS91c3VtRGFHOUFLcXR6ZTZtWTE4NFFTcUgxVGdPQWVXMDdBT3dpek1i?=
 =?utf-8?B?VThyRUNlZFFCNnFBc1M2Wlh6MERyMWVLUi9UbVhKa2VDU3ZDMFdBQXlnMTYv?=
 =?utf-8?B?Q09vdzJObzhXRmNZSlNrWk9UNm1rU0pNWnlJL1NjUG45ajBpSmxWWWs5eThH?=
 =?utf-8?B?YUUvZlNTaTAvOCtnV2FXOXVoaUgyclcrMEhQSmczNWMvay9zaytjMUw2ejBz?=
 =?utf-8?B?WnpXOEFzSUtGUWdFQlI5emdnUlV4RUxFaUxGbTZLeVp6Wi9RREpmMDQ2cGo1?=
 =?utf-8?B?Smo2Z0xMTzRwbStPcVdOYys0TFlpM3QzOW1acFpnK2JKYUNvc0hwSmorMHEx?=
 =?utf-8?B?YWZzMUpNYjd1R0Q5a1hJVFkyL3NjQi9MRXA3Yi9HendpcGYyYmd1MTg2UmlF?=
 =?utf-8?B?NVdjb2JsRTA0NGhTM29Vc1Y5bEVQUWgyOW1qOUxCMTVxbU5PbW9GbVJyQld5?=
 =?utf-8?B?N3grbDdpQlp5cmRLZWFLZzBGUlFqY1JSa1hJRThheWNTYUsrUytYUE92UFN2?=
 =?utf-8?B?Rzgzd284ays2NlNLbHpDZjFETVNYMlRPa05FdytqY1Y2U2d0dkhoSVZsMEFl?=
 =?utf-8?B?N1oydEN2K2NuKzNjdHV2TVcwWDlvanVhczZhQkdmTi9YVjFSQjdPdG9CaGFv?=
 =?utf-8?B?bXNCekFlU0tRS2lKSzNJZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BECC03734B520C438FB0698D25B03607@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2025b736-e005-46e9-2b7c-08d96ca89421
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 17:55:54.3434
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G28uan9KwIsSAS1hdrk4U183iCRwEIYSirehYSYYzDvhtotD+q+6Myq7tfRmzoaed9vjjvbT+BWOddkOhZlwcHA7yoVzuiAVYE1IbzC0cE8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4972
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIxLTA4LTMxIGF0IDExOjU2ICswMzAwLCBNaWtlIFJhcG9wb3J0IHdyb3RlOg0K
PiBPbiBNb24sIEF1ZyAzMCwgMjAyMSBhdCAwNDo1OToyNFBNIC0wNzAwLCBSaWNrIEVkZ2Vjb21i
ZSB3cm90ZToNCj4gPiBXcml0ZSBwcm90ZWN0IHBhZ2UgdGFibGVzIHdpdGggUEtTLiBUb2dnbGUg
d3JpdGVhYmlsaXR5IGluc2lkZSB0aGUNCj4gPiBwZ3RhYmxlLmggZGVmaW5lZCBwYWdlIHRhYmxl
IG1vZGlmaWN0aW9uIGZ1bmN0aW9ucy4NCj4gPiANCj4gPiBEbyBub3QgcHJvdGVjdCB0aGUgZGly
ZWN0IG1hcCBwYWdlIHRhYmxlcyBhcyBpdCBpcyBtb3JlIGNvbXBsaWNhdGVkDQo+ID4gYW5kDQo+
ID4gd2lsbCBjb21lIGluIGEgbGF0ZXIgcGF0Y2guDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTog
UmljayBFZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+
ICBhcmNoL3g4Ni9ib290L2NvbXByZXNzZWQvaWRlbnRfbWFwXzY0LmMgfCAgNSArKw0KPiA+ICBh
cmNoL3g4Ni9pbmNsdWRlL2FzbS9wZ3RhYmxlLmggICAgICAgICAgfCAxOCArKysrKystDQo+ID4g
IGFyY2gveDg2L2luY2x1ZGUvYXNtL3BndGFibGVfNjQuaCAgICAgICB8IDMzICsrKysrKysrKyst
LQ0KPiA+ICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9wa2V5c19jb21tb24uaCAgICAgfCAgMSAtDQo+
ID4gIGFyY2gveDg2L21tL3BndGFibGUuYyAgICAgICAgICAgICAgICAgICB8IDcxDQo+ID4gKysr
KysrKysrKysrKysrKysrKysrKy0tLQ0KPiA+ICBhcmNoL3g4Ni9tbS9wa2V5cy5jICAgICAgICAg
ICAgICAgICAgICAgfCAgMSArDQo+ID4gIGluY2x1ZGUvbGludXgvcGtleXMuaCAgICAgICAgICAg
ICAgICAgICB8ICAxICsNCj4gPiAgbW0vS2NvbmZpZyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHwgIDYgKysrDQo+ID4gIDggZmlsZXMgY2hhbmdlZCwgMTIzIGluc2VydGlvbnMoKyksIDEz
IGRlbGV0aW9ucygtKQ0KPiANCj4gIA0KPiAuLi4NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL21tL0tj
b25maWcgYi9tbS9LY29uZmlnDQo+ID4gaW5kZXggNDE4NGQwYTc1MzFkLi4wZjhlODU5NWEzOTYg
MTAwNjQ0DQo+ID4gLS0tIGEvbW0vS2NvbmZpZw0KPiA+ICsrKyBiL21tL0tjb25maWcNCj4gPiBA
QCAtODQ1LDYgKzg0NSwxMiBAQCBjb25maWcgQVJDSF9FTkFCTEVfU1VQRVJWSVNPUl9QS0VZUw0K
PiA+ICAJZGVmX2Jvb2wgeQ0KPiA+ICAJZGVwZW5kcyBvbiBQS1NfVEVTVCB8fCBHRU5FUkFMX1BL
U19VU0VSDQo+ID4gIA0KPiA+ICtjb25maWcgUEtTX1BHX1RBQkxFUw0KPiA+ICsJYm9vbCAiUEtT
IHdyaXRlIHByb3RlY3RlZCBwYWdlIHRhYmxlcyINCj4gPiArCXNlbGVjdCBHRU5FUkFMX1BLU19V
U0VSDQo+ID4gKwlkZXBlbmRzIG9uICFISUdITUVNICYmICFYODZfUEFFICYmIFNQQVJTRU1FTV9W
TUVNTUFQDQo+IA0KPiBIbW0sIHdoeSBpcyB0aGlzIHg4Ni1vbmx5IGZlYXR1cmUgaXMgaW4gbW0v
S2NvbmZpZz8NCj4gDQpZZXMsIHRoaXMgc2hvdWxkIG1vdmUsIHRoYW5rcy4gSXJhIGRpZCBzb21l
IEtjb25maWcgcmUtYXJyYW5naW5nIGluIHBrcw0KY29yZSB2NyB0aGF0IHNob3VsZCBtYWtlIHRo
aXMgZWFzeSBub3cuDQoNCj4gPiArCWRlcGVuZHMgb24gQVJDSF9IQVNfU1VQRVJWSVNPUl9QS0VZ
Uw0KPiA+ICsNCj4gPiAgY29uZmlnIFBFUkNQVV9TVEFUUw0KPiA+ICAJYm9vbCAiQ29sbGVjdCBw
ZXJjcHUgbWVtb3J5IHN0YXRpc3RpY3MiDQo+ID4gIAloZWxwDQo+ID4gLS0gDQo+ID4gMi4xNy4x
DQo+ID4gDQo+IA0KPiANCg==
