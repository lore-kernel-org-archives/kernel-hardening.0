Return-Path: <SRS0=0e2a=NW=lists.openwall.com=kernel-hardening-return-21381-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86366C432BE
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 18:25:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A9B3060FE8
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 18:25:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A9B3060FE8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 8019 invoked by uid 550); 31 Aug 2021 18:25:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7978 invoked from network); 31 Aug 2021 18:25:39 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10093"; a="205764417"
X-IronPort-AV: E=Sophos;i="5.84,367,1620716400"; 
   d="scan'208";a="205764417"
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,367,1620716400"; 
   d="scan'208";a="645415645"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vf9p356qHEsew2hjTRNImP1svmciXjH0xyFsZeh3a3VFPyGpQz2R+wMqf84QvozLBH4xG1T5US5tLs/c8kXihX9JBwwfBghMjATBbO17u2/MmNBdmV3dHkoKFl01wTHbv+K9JYsznSiTNv99lSWwC+QWfFQAPaff/Ag+W20h3Kigwx8f/TXECNdSVxCuIM9SWkvUqNKUK7+5cJAkZ+upWwGnsOfUN1byvUHcuzdv+iyJPh8MKVKMAJywMKIJCJgXjewAM4WiDY53Kg07Ha+IChKcKWntMs57Q+PJ0gP/UgW19HjXPoUHLZ34WrJ7L8ertQIfrEwmwjst4gnqJ4Dt0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/tsRMZxyhACemVJEeC5+hscnfduCScFNuirvGwkrtbI=;
 b=QpiyUNOiZ6+biMmraMqIa0yC3RK7/rvGAsfCZ/OO8vhTu61ofbv3STQ2s6gmjoj1CKciNDb3cXHwKVW6xaOD8i2gvrO7lKPJEdrInk/TI0Y+w2O+vgyLq1hjXXz0BU5VqY9TLZi4azYgUXa5fEBGqbgp2Jx8bWJERo7HmPB99j9P8pTNRhEbztBf1CN3Gl8wnkOVcPFEzeRutR3aBqoK8PoHlLXJfE8jAd/bpxuwV4FgNUCmWaEX1mYbzf+YKAuYmhNTRiu4/VDa+UI6SgbDehJWoiSF+LJdicgm+HpxjOrTa+TuH8cHjdg+XurS2lF4QaYHqUN2bw3QfncDQon/ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/tsRMZxyhACemVJEeC5+hscnfduCScFNuirvGwkrtbI=;
 b=Oh5MzxrdygENN8cBP+37bCuPbIV1kUQTR5fkzf5AA6WOSMCXphk2CD+yylF3BETorojlxR26apd1UsAE65ahM6ed6a1DqGRrHUdnrH6+NvvU3wdE+x31RihcRtlPB3HghTaz8/yuI5QB5byLa3QToSjqryglkiguNe/VC9gUfFI=
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
Subject: Re: [RFC PATCH v2 11/19] mm/sparsemem: Use alloc_table() for table
 allocations
Thread-Topic: [RFC PATCH v2 11/19] mm/sparsemem: Use alloc_table() for table
 allocations
Thread-Index: AQHXnfs/1Ucvr9o/bE+2Qh+hHaGqGKuNT/OAgACfNAA=
Date: Tue, 31 Aug 2021 18:25:23 +0000
Message-ID: <f77f3312a1b17b8f8de2ccf0f40f9f19f4a9f151.camel@intel.com>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
	 <20210830235927.6443-12-rick.p.edgecombe@intel.com>
	 <YS3uhdT88XFvP9n3@kernel.org>
In-Reply-To: <YS3uhdT88XFvP9n3@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7763b0fe-30e7-4168-274e-08d96cacb290
x-ms-traffictypediagnostic: SA0PR11MB4560:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB45603341A42BD3CD94E5E90BC9CC9@SA0PR11MB4560.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UugBchGDewGwU9AuxyJgZ/Pi2MdLAGsFfVeoIc1zsBUt6nU1UC9bmrpoIh2RvCvr5B2P8NYU3oieR2xTNbipM/GyvKPCLFJ8e7ro77SRyjgbY3bsL6u5E9hBSSPqSDU+zfrMGrwz78TAUW/s9lJVfUrLetBPCC9Gew7I8Do4j1cI+WB+gBvIQ3uIFHdTNFrfpQ5/+CWHPFourkoG04O4ktumP/JJ3K1iDGWhurQIy6Xii4SBL1e73RUpI2BGnbtGhzpSLEqJ3YESu2mxbU04EYSSVN/Yy1Xsb75dWr+wNGreCs8LnucckEHmQf7JQasjmKgfjoAy/rxwySjgRvxEKOB1Ekg9rHbaZH5oRFGxTJK5PoYXsAtmfF+6HZ66impa/BovrJM2vC62M2MFZtvaXH1ktEnTjUFAV2Z9rHJqxMU/d+R4Q68BjzrcRJWWTjKjgumQNMQ79AqXULLbwac6+B0zBUjMJ9P2raolitDk0pURW3bQNTuec0aBiKPktbW0+qiAr+I890jAorwPhb15zilbxzh91pgBt+fwoI7o3WL0OlMZPmQQfDJw4RRUM/TTpykhyjqSPxf7cAXo9Ov63/CtiuuDE6AKQ7DzWvOEvs8kP/u6BpJnB9TKB1kW3t3nwZW9gDqkpQfPSEnFVym0oDoxupKXMwC3z3jjlfDp99deChvASly5nOSvzxKnVwCG/OmdoaCvxsobFEJOUo6af+eRtCf/BKFa3Z3zopXXeA4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(38070700005)(7416002)(8676002)(38100700002)(2616005)(6506007)(6486002)(86362001)(4326008)(6916009)(2906002)(8936002)(478600001)(122000001)(83380400001)(316002)(5660300002)(66446008)(26005)(64756008)(54906003)(66946007)(71200400001)(66556008)(66476007)(186003)(76116006)(91956017)(36756003)(6512007)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eHZHMUV2cTNTaTNtN2R5cXR4K2ZxdXpCVjhxekI4RHdWYnFrcE4raWQ3ZEo5?=
 =?utf-8?B?ZWVHUm1QSm1jZkZyaUJScWhkTUlDVFpmR1Qwd1dzZ1lDWFFybzAzRWhOUDFn?=
 =?utf-8?B?L3hJaFZob000SWJKQVNwSWR1MFhwTGcvbnF6SFpXL0Y2U1hKOGVIbXBTYTRt?=
 =?utf-8?B?VlV1MmtUbkxidU9mRDMwWWJGeUx6R1lhbGJRR2E4VEg0dnFkbzJGZEdkZHdE?=
 =?utf-8?B?TVczdVB6dERqcnczUjdyL3drME05bTlxS0NUUjN4NGNVa041QmJpMEs3L015?=
 =?utf-8?B?TGQxZkxjMGh2WjVOek5ZUVdxdlRZVEI1S0hIZzRnai90L216QlY3bUZrb1Ri?=
 =?utf-8?B?ZkoveFlseFZNeG5lNzAxb3JMSHJRQTFFaDA0RncxbDVTUVIvZDZTTldMS0Z5?=
 =?utf-8?B?MTh3R2FSWXM4Q0hmS2VyWVYrTlQ0OVpBRjlKZjBsV05xZXRsN2k0ZStOT0o1?=
 =?utf-8?B?WmtOUU1QRzhXemN2K3l1SkhrNndnbmZ2SDI3aFp5dS9sSVRDeDJLYk1rdjJt?=
 =?utf-8?B?T2JnbVF3VDhva2hnb3dNSHBEVFFLblZRMGNJQmVONzB3UWtJclZKSmVhM2Zu?=
 =?utf-8?B?cjZ5MGxPeGxPUE5sZ1dydm9Uay92QzhvamdjcGhBSkNNSDBpcWdzZHAzM3Jk?=
 =?utf-8?B?QXk0SXRoZUVRa0FuNmpCSStWa1ZObHNxanlFUE4rNnVCN21zTHJ5bWlZcVV1?=
 =?utf-8?B?ZHJoZXpDOFNSVTBQbDNSNk5xRVR0ZGs2ZmRjSXBxUEdsQ0I0U3B0TGFjb29p?=
 =?utf-8?B?cXQ2ZHZteElvc0Q2NUdtUDdHNXplMVp3aEVYVmkyTytGTXJsNHBnREl6R3Vr?=
 =?utf-8?B?VTEvdXQ4QVNteEZFdlNCNXBCM3p4azlxRHBXeGVDWVkxaGQwY1RpbG5XYVY4?=
 =?utf-8?B?NCtDVDhKdXUyRWtCZ2dnL0pMVnBKSWNENEFOeVhPUEhPaHZqdFNtR3ZpeTFP?=
 =?utf-8?B?SGFpNzNLeUNCMTlVeEdFMzErUE9wN3BsN3lsVWZQK1RqcDcxbEJ1QTRZNXls?=
 =?utf-8?B?WWtkMFJBclZTQVo2NnFyWWtrOENLRUR1M2FVdGhOK0xmV2JPSkJGZDhUeWEv?=
 =?utf-8?B?SXZyZjFuMkdqR2pKWUZ3eVJEVmJuNkpWL3RrRkxGRjJJWC8zaFVaa0haUTRu?=
 =?utf-8?B?bUJHWFRrTFgzWkVjRnltcW9wd3FOSDJ2bUdSK293MDVhNm1iRXhGVTliZzRu?=
 =?utf-8?B?ZXVEMmRIcUdvNWMwRkgzdHNPQmJhTHhGektZdUlWS1I1b20vOUdFRjNrdGhw?=
 =?utf-8?B?M01HWFJyWXJlMWtlTVVGQTdwd1J5WlVkOTl6aTZOS2REYzAvSGZMK0JybExx?=
 =?utf-8?B?UWpTRzFtRTB5U1Y1Rk9pcmJkVVh1WVpSNFJpbGE3L0x1NXdPaFpoS0U1d3Jr?=
 =?utf-8?B?VXFJbm94U0FLME5pa0J4dm5USGU0V0NlYXd1RGtybXBCdlNzMDh6ZDVYQTJm?=
 =?utf-8?B?WkJMRTIzeEVHeDNNbDZYd0RDRWFrblhmVlltTVA4ZHI3OVRqTHNGY2tXc1E3?=
 =?utf-8?B?NDJqVUdGWlhtRnJYVXlRNGR5L3pqRnpFNzlBNmFZdjhTNWdrTTl3aHBYN0ZD?=
 =?utf-8?B?a0cvcUxnZGR5bjRhT0RyZUhPUmdQVFdvRlpXaTZwVEZ6QW16UVFxSFB1Wk5w?=
 =?utf-8?B?VHl6SWs4ZWhiRWRFRU4wTmpMalROeU51MThRUFBRZEQ4d2d2NXdiTEpTUkNP?=
 =?utf-8?B?amZxYStjVDV4OFRxazFIODloUnZSZHRQU3VRaUw1bUNRYVEzYkFXWVZJVTRQ?=
 =?utf-8?B?TUMxSmNDQjJ6a2lNSU9hS2c0UHo0WmJhNEhqV1JnS05TczBza2M0UHZjZ0Fj?=
 =?utf-8?B?YkQyQm16OHpYQ0JyR1piUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <15FCA186C927C2488CE5C7F36B608579@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7763b0fe-30e7-4168-274e-08d96cacb290
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 18:25:23.4233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MWMfH7T+Or0hx2oWkXxCR0YvufpabyvW60Qcz+fNmBgNEPg7cO8itnis7eoOYucKIbkMuniRhk5zLY0BQP1As+rvQk7U5estHJWwolgK1Ws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4560
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIxLTA4LTMxIGF0IDExOjU1ICswMzAwLCBNaWtlIFJhcG9wb3J0IHdyb3RlOg0K
PiBPbiBNb24sIEF1ZyAzMCwgMjAyMSBhdCAwNDo1OToxOVBNIC0wNzAwLCBSaWNrIEVkZ2Vjb21i
ZSB3cm90ZToNCjx0cmltPiANCj4gPiAtc3RhdGljIHZvaWQgKiBfX21lbWluaXQgdm1lbW1hcF9h
bGxvY19ibG9ja196ZXJvKHVuc2lnbmVkIGxvbmcNCj4gPiBzaXplLCBpbnQgbm9kZSkNCj4gPiAr
c3RhdGljIHZvaWQgKiBfX21lbWluaXQgdm1lbW1hcF9hbGxvY190YWJsZShpbnQgbm9kZSkNCj4g
PiAgew0KPiA+IC0Jdm9pZCAqcCA9IHZtZW1tYXBfYWxsb2NfYmxvY2soc2l6ZSwgbm9kZSk7DQo+
ID4gKwl2b2lkICpwOw0KPiA+ICsJaWYgKHNsYWJfaXNfYXZhaWxhYmxlKCkpIHsNCj4gPiArCQlz
dHJ1Y3QgcGFnZSAqcGFnZSA9IGFsbG9jX3RhYmxlX25vZGUoR0ZQX0tFUk5FTCB8DQo+ID4gX19H
RlBfWkVSTywgbm9kZSk7DQo+IA0KPiBUaGlzIGNoYW5nZSByZW1vdmVzIF9fR0ZQX1JFVFJZX01B
WUZBSUx8X19HRlBfTk9XQVJOIGZyb20gdGhlDQo+IG9yaWdpbmFsIGdmcA0KPiB2bWVtbWFwX2Fs
bG9jX2Jsb2NrKCkgdXNlZC4NCk9oLCB5ZWEgZ29vZCBwb2ludC4gSG1tLCBJIGd1ZXNzIGdyb3Vw
ZWQgcGFnZXMgY291bGQgYmUgYXdhcmUgb2YgdGhhdA0KZmxhZyB0b28uIFdvdWxkIGJlIGEgc21h
bGwgYWRkaXRpb24sIGJ1dCBpdCBzdGFydHMgdG8gZ3Jvdw0KdW5mb3J0dW5hdGVseS4NCg0KPiBO
b3Qgc3VyZSBfX0dGUF9SRVRSWV9NQVlGQUlMIGlzIHJlYWxseSBuZWVkZWQgaW4NCj4gdm1lbW1h
cF9hbGxvY19ibG9ja196ZXJvKCkNCj4gYXQgdGhlIGZpcnN0IHBsYWNlLCB0aG91Z2guDQpMb29r
cyBsaWtlIGR1ZSB0byBhIHJlYWwgaXNzdWU6DQowNTVlNGZkOTZlOTViMGVlZTBkOTJmZDU0YTI2
YmU3ZjBkM2JjYWQwDQoNCkkgdGhpbmsgaXQgc2hvdWxkIG5vdCBhZmZlY3QgUEtTIHRhYmxlcyBm
b3Igbm93LCBzbyBtYXliZSBJIGNhbiBtYWtlDQpzZXBhcmF0ZSBsb2dpYyBpbnN0ZWFkLiBJJ2xs
IGxvb2sgaW50byBpdC4gVGhhbmtzLg0KPiANCj4gTW9yZSBicm9hZGx5LCBtYXliZSBpdCBtYWtl
cyBzZW5zZSB0byBzcGxpdCBib290IHRpbWUgYW5kIG1lbW9yeQ0KPiBob3RwbHVnDQo+IHBhdGhz
IGFuZCB1c2UgcHhkX2FsbG9jKCkgZm9yIHRoZSBsYXR0ZXIuDQo+IA0KPiA+ICsNCj4gPiArCQlp
ZiAoIXBhZ2UpDQo+ID4gKwkJCXJldHVybiBOVUxMOw0KPiA+ICsJCXJldHVybiBwYWdlX2FkZHJl
c3MocGFnZSk7DQo+ID4gKwl9DQo+ID4gIA0KPiA+ICsJcCA9IF9fZWFybHlvbmx5X2Jvb3RtZW1f
YWxsb2Mobm9kZSwgUEFHRV9TSVpFLCBQQUdFX1NJWkUsDQo+ID4gX19wYShNQVhfRE1BX0FERFJF
U1MpKTsNCj4gDQo+IE9wcG9ydHVuaXN0aWNhbGx5IHJlbmFtZSB0byBfX2Vhcmx5b25seV9tZW1i
bG9ja19hbGxvYygpPyA7LSkNCj4gDQpIZWgsIEkgY2FuLiBKdXN0IGdyZXBwaW5nLCB0aGVyZSBh
cmUgc2V2ZXJhbCBvdGhlciBpbnN0YW5jZXMgb2YNCmZvb19ib290bWVtKCkgb25seSBjYWxsaW5n
IGZvb19tZW1ibG9jaygpIHBhdHRlcm4gc2NhdHRlcmVkIGFib3V0LiBPcg0KbWF5YmUgSSdtIG1p
c3NpbmcgdGhlIGRpc3RpbmN0aW9uLg0KDQo8dHJpbT4NCg==
