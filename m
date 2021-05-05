Return-Path: <SRS0=fpih=KA=lists.openwall.com=kernel-hardening-return-21251-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE4BC433B4
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 21:58:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9126D613D8
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 21:58:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9126D613D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21251-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28461 invoked by uid 550); 5 May 2021 21:58:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28409 invoked from network); 5 May 2021 21:58:14 -0000
IronPort-SDR: t+JqClxH5jTGz4dHfPOWgoxiIwrkYsSTHS0PWIQ6lP6KhOFvnie8yh+X3+gK0q+rqhk5ZnngKb
 nIM88MZYF3hQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="259592022"
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="259592022"
IronPort-SDR: KjJOzMuqRlcls5wxXtixYOy+8QG8ACx/Bp+gKPmAiP/qBAZZkpFCCs4xcQ+asy3QXhe4UyKtbP
 /cQ93knP5XtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="469158302"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3B7lJtz8Gs5krDVgsQ30MaJ6E8yQLGRRg8NrVvhBQQ0AjMCKWPygQJDrEb3M2QdM3TuyN9KHLaXP3VsQzg3qapjS11xNGaYV5JM5Ou7lo2T7wiVkIky+R5LTGE3Xs9po0DvK6v1EUcs78RbCLJ3Oj3ZpVCtL2bTaqZ4FVk3ri1eDPzZWtmBKZ1SZbDEPPGCo5IqE3DAlbscdgigIHabr7hmfpkpDvDdkWbWPShgWW1sQ6AUmTGGO2sA0pVbkrxpX9bQCZSz5WH1++4MhNEpB8k0ibP9LzGx6Lpt42gP4o9BurD57Ipcuq4sdSJHFv/Ygc6y49L9IK1OE92UyXGMww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I7AItHEM6G5bO4X+SM8CS+W4gF5dDU2qZ3jWtY6ouUU=;
 b=WgW8WBKOLjxLKmIJtWpF9qXySjwY6aIfkzgM5wUs+Y4zpqmwGgcz3Gv4gYMtyd+QrEA4CUFz8e5NthWiBpuxlSO2BbiDEcserli9Tu+xAPA/q3+weBKDUE6/wHckmlAv1Rf3AdRWssC48PXBZ3Xg2NQANGFWHuxsV4hsRBdB0H9Un7miRQWq/Lvcsqd5KiDDx8TF6r5WepsVbvdhALEiAQAl60gRzzrz5QHHfRi3/MH5cjLcO/iLP+RIEoTujOefHDx0ELMjOAw1w7VJYKZIFIE2JEbj691kzUXbskWvBCmu1BCyRAaoJT9bmhhTMbvkxbtY0F+UiyBnZpavK34inQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I7AItHEM6G5bO4X+SM8CS+W4gF5dDU2qZ3jWtY6ouUU=;
 b=vuGDFDuXxgLfENzZV4i+gYueD7pnVnt8jmcGF/Lieh5OxDR+m/EnXVOUogAmyYOivMC5SuJaPVRQNaKogBjppXSeuj9KluweWG7JIDoI8jKC3SqoFpUkTukPqOJhZ6HOapLM6xvTu6LQS2RX3IaSZI0tVH0gbM1V4amfOuLFfO4=
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "peterz@infradead.org" <peterz@infradead.org>, "rppt@kernel.org"
	<rppt@kernel.org>
CC: "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "luto@kernel.org" <luto@kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Williams, Dan
 J" <dan.j.williams@intel.com>, "linux-hardening@vger.kernel.org"
	<linux-hardening@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH RFC 3/9] x86/mm/cpa: Add grouped page allocations
Thread-Topic: [PATCH RFC 3/9] x86/mm/cpa: Add grouped page allocations
Thread-Index: AQHXQUYjrHRaN7YNCESTntxXPP7WtqrUzCmAgAAQ+QCAAF30AIAANZiA
Date: Wed, 5 May 2021 21:57:17 +0000
Message-ID: <bb2a9aaedcd5d47ace719050fa06d7a21050cfc5.camel@intel.com>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
	 <20210505003032.489164-4-rick.p.edgecombe@intel.com>
	 <YJKKu7kMCtCuel2L@kernel.org>
	 <YJKY+Ccxfe9wD0iP@hirez.programming.kicks-ass.net>
	 <YJLnyJP755XAPZNX@kernel.org>
In-Reply-To: <YJLnyJP755XAPZNX@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.38.4 (3.38.4-1.fc33) 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.137.85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2ef5e80-0f25-4d23-870b-08d91010c028
x-ms-traffictypediagnostic: SN6PR11MB3232:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3232763AB0B702A3B0912857C9599@SN6PR11MB3232.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j1rBgIM0e59llNZTZSxMt1PQydfiHva/CfSt7GjoV6PurdNiEfdkjcmKSex6IybwyWkEjLCHpoIVW3D8/fjYabSmDcWbPvr9BqBwXPAmScUDmdcafYjNhieG7lw6EFegCDkUgyImdkTtTIcLZzo2mzfRJg6MmJqucqqO/0cOTyqVL2ctQHTVmym1sfi5fW/DWP3Dqj3LVhBB4+O5AdN/vOkOvTxrSzAvQ5FB5T+bZV31kjsTN4TW4wqEKcB04RTF7cBYU3Rj+HwP8ONSIgI/sziMzF5DY1yalx54Pf1RzqAZendktleq3vom3AFNaAi8/RIsltNpr9AudAMiPwHBHKSCYHFtPQtQiQWqNik63FiQgXqUq1f/JywJeNasth7zEgd8JiApD31WqUUJOrATFCiuUR8wndawYX8589trkHhHKFGY4JNwISWzzW3sLZCkcvEht9BjzJrphS+I8l5ZQJCLwodLn4kBbRUCMhr0cv8SdYPF+xsfcnlAe45kCycvt8+IvkXbSMvM8uvICXm+bpw+9bM8WEci6A7MmstbGnIMm4vZfBzM6+7CSzhVtn7l9jNK1fwwe13gqkOSnY3BY82ylC6F5jnzRGYEjcdFC8E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(346002)(366004)(39860400002)(66476007)(66946007)(6486002)(64756008)(66556008)(66446008)(83380400001)(6512007)(2906002)(186003)(8676002)(122000001)(478600001)(91956017)(86362001)(38100700002)(8936002)(71200400001)(76116006)(26005)(6506007)(110136005)(54906003)(7416002)(2616005)(4326008)(36756003)(316002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cGlza05kM3Bwa2JXYlNjb0NKY1Q4NjBnQ0VhTG44V2VMMUhwZldhWC9jMnlK?=
 =?utf-8?B?ZU02UE5SRXZBN2hvRHVqUGpkLzgxbVQxU2JZRElEN1B3TUNzcllraXYza0wr?=
 =?utf-8?B?bkVxNXRrSEdDclBLcmEyOFVtQm8yTGJvSzNMeWJIK21sVVl2K2dQYjFGK1JH?=
 =?utf-8?B?WCt0c0hwMml0TFdvOHZoenJlYW9uU0VZZzRSNW9GVkhlVWtIRUVMMTBYbk9r?=
 =?utf-8?B?QWtJVytEZXRlNnk1djFibVFwZE05ZkhOcEI5ekZ4ak4yb2orRWJHN1VQTGd5?=
 =?utf-8?B?b3VBRkd3OStlQkRaU0svOCsvV2tUV292MGE4eWYvR0txczdUeWtKM04zdWlv?=
 =?utf-8?B?M1pvb2VEaVNJM3FLdWwxcnk0bFJPaXhuWnBhMXU3bENQRFkwWG1QTjhaS2x2?=
 =?utf-8?B?SzdEbHpLaEVsdm9IeUhyWktuYnQrTW1DVDYwanJCbG1YNm5rMFMwSW5jaHRI?=
 =?utf-8?B?ZWdJUzNUZUJsNGN5Uy9UTzBrTXYvbTN6aERMVGVDL0U4V3VkOHA3R3hFTWYx?=
 =?utf-8?B?ZktaZXdiUSsraTZwZ0dnN1AyVHpVZ1A0T0VGeGp5Tyt1NVNHbUZuU05ESHRM?=
 =?utf-8?B?VVdOTkZhNGRxU0llelNxeU83ZFNPQkdaaGxPaTR0S3AvYkNETEkySE05RXJN?=
 =?utf-8?B?VjFrcW9lTytBcTlVbVJvTFhWMGFldjM4ZUp5dEt1bWQ2ajlKOUo1SEg4MkNk?=
 =?utf-8?B?c2crd2wwQ1VaTVNQWUFDS1lSdUR5YW94R1c0WWJaMWdoWmkzSkp3aFpqMFd2?=
 =?utf-8?B?TXZaM3RCU3pUN3JKbXVkSkN6dG9UTzJrNnRkNWlueWQ4M0hmTUlHdlV6M29h?=
 =?utf-8?B?L2N3OEFuNVF4dkhGelQzdDJWM0MyUE56M1RFTG1NckcxYmJPRjJ3ZzRvbHVL?=
 =?utf-8?B?RnNlN1FYWTdDdFpnV1p1ZjV1dTg4ajYvNVRYZ0s1bUtLNDc3K3ZFODlTcHRZ?=
 =?utf-8?B?d2NWRmlRbFVXak9obW8vNmpKQjJvWVFOaldCenllMG1lcnRZekxVKzdhL2tD?=
 =?utf-8?B?bHYxR3BQS3d4N0ZxOWRNay9HdVRjLytWTWtQUFZQWEtHLzVCUmVRWUZreHE5?=
 =?utf-8?B?THNqREVqbCtPNWZiMER4c3Z6N0tvYTI0UXYzbmRnTVY3Ynl4L0NwNVZ4Z2lR?=
 =?utf-8?B?SWQrdGNHRUN5NTZUb04xTmI1anVhakNRRndyM2oxb3p4ZGl0em5NOGZ1VXJm?=
 =?utf-8?B?RlVoZitCRFdZU1dYbk5haldQbDUxdUhNWnRma2x5Tjk2VTFTbk83a2hSeWRW?=
 =?utf-8?B?dGk3Y1B4N0pvNjI5ZnRFZUhqQTFRSnNxUjVjZGs4c3hHc0VuUytqTzZRT1Rm?=
 =?utf-8?B?N054eUM0VjdrYnl4Rzlpd2ExS2dLVzlsYVQzYVNxUkJ1dTM0QTlaNEI3RCtH?=
 =?utf-8?B?TUpybHloRkM1TUFCQWxlRHhPZnEveUV1ME5NMldoeUs1bERuZFU4LzRsQWRl?=
 =?utf-8?B?by9PelRBWHh0Z013M1FmY0wrUlVVdDZDZ2JlZzQzdkpkN3ZRQVE5UzFaUUdI?=
 =?utf-8?B?UkVKMVpkcmRqUjMrMHhjK1dzb1VrREVmWE4zQXl0VS8zZUxnWW91K01nU25Q?=
 =?utf-8?B?eGhlSVFYWTRWclJIVGdvN3NUeHFqcjI3aTh3alFvdjYvdVpmZjgzZDhDUlpZ?=
 =?utf-8?B?SFpJaHd6eXgvQWQ4SjZSanNlbi82MGUxd01OM21VN3B6c2gyVlNUKzJjR3NQ?=
 =?utf-8?B?cjZjQUtUOWFKMUpTMExsQUlLelVJWEpHWFNxTkdPUVkrbXNxYmRZSkpKODg2?=
 =?utf-8?B?ZitoQzBnZFJTVUk3WjhHRmhTVWJESG9MdnNsejU5RFFkYTZ1VVRuTXZMeXp2?=
 =?utf-8?B?OVB2ZFpvR0VHMHMvYTlUQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F16A183A82F90A43A4078360B22A2916@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2ef5e80-0f25-4d23-870b-08d91010c028
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2021 21:57:17.8418
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DPGC10dr1hbSG3xt/ZVTR1mK0jz/1+mtfQCxFL6AusvMH3KD0rUYRUicdnAYnNS3LHNq7MSPwQx/AUAiUCfnsrDkY2vKO/dV5bosMz2jNBw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3232
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIxLTA1LTA1IGF0IDIxOjQ1ICswMzAwLCBNaWtlIFJhcG9wb3J0IHdyb3RlOg0K
PiBPbiBXZWQsIE1heSAwNSwgMjAyMSBhdCAwMzowOToxMlBNICswMjAwLCBQZXRlciBaaWpsc3Ry
YSB3cm90ZToNCj4gPiBPbiBXZWQsIE1heSAwNSwgMjAyMSBhdCAwMzowODoyN1BNICswMzAwLCBN
aWtlIFJhcG9wb3J0IHdyb3RlOg0KPiA+ID4gT24gVHVlLCBNYXkgMDQsIDIwMjEgYXQgMDU6MzA6
MjZQTSAtMDcwMCwgUmljayBFZGdlY29tYmUgd3JvdGU6DQo+ID4gPiA+IEZvciB4ODYsIHNldHRp
bmcgbWVtb3J5IHBlcm1pc3Npb25zIG9uIHRoZSBkaXJlY3QgbWFwIHJlc3VsdHMNCj4gPiA+ID4g
aW4gZnJhY3R1cmluZw0KPiA+ID4gPiBsYXJnZSBwYWdlcy4gRGlyZWN0IG1hcCBmcmFjdHVyaW5n
IGNhbiBiZSByZWR1Y2VkIGJ5IGxvY2F0aW5nDQo+ID4gPiA+IHBhZ2VzIHRoYXQNCj4gPiA+ID4g
d2lsbCBoYXZlIHRoZWlyIHBlcm1pc3Npb25zIHNldCBjbG9zZSB0b2dldGhlci4NCj4gPiA+ID4g
DQo+ID4gPiA+IENyZWF0ZSBhIHNpbXBsZSBwYWdlIGNhY2hlIHRoYXQgYWxsb2NhdGVzIHBhZ2Vz
IGZyb20gaHVnZSBwYWdlDQo+ID4gPiA+IHNpemUNCj4gPiA+ID4gYmxvY2tzLiBEb24ndCBndWFy
YW50ZWUgdGhhdCBhIHBhZ2Ugd2lsbCBjb21lIGZyb20gYSBodWdlIHBhZ2UNCj4gPiA+ID4gZ3Jv
dXBpbmcsDQo+ID4gPiA+IGluc3RlYWQgZmFsbGJhY2sgdG8gbm9uLWdyb3VwZWQgcGFnZXMgdG8g
ZnVsZmlsbCB0aGUgYWxsb2NhdGlvbg0KPiA+ID4gPiBpZg0KPiA+ID4gPiBuZWVkZWQuIEFsc28s
IHJlZ2lzdGVyIGEgc2hyaW5rZXIgc3VjaCB0aGF0IHRoZSBzeXN0ZW0gY2FuIGFzaw0KPiA+ID4g
PiBmb3IgdGhlDQo+ID4gPiA+IHBhZ2VzIGJhY2sgaWYgbmVlZGVkLiBTaW5jZSB0aGlzIGlzIG9u
bHkgbmVlZGVkIHdoZW4gdGhlcmUgaXMgYQ0KPiA+ID4gPiBkaXJlY3QNCj4gPiA+ID4gbWFwLCBj
b21waWxlIGl0IG91dCBvbiBoaWdobWVtIHN5c3RlbXMuDQo+ID4gPiANCj4gPiA+IEkgb25seSBo
YWQgdGltZSB0byBza2ltIHRocm91Z2ggdGhlIHBhdGNoZXMsIEkgbGlrZSB0aGUgaWRlYSBvZg0K
PiA+ID4gaGF2aW5nIGENCj4gPiA+IHNpbXBsZSBjYWNoZSB0aGF0IGFsbG9jYXRlcyBsYXJnZXIg
cGFnZXMgd2l0aCBhIGZhbGxiYWNrIHRvIGJhc2ljDQo+ID4gPiBwYWdlDQo+ID4gPiBzaXplLg0K
PiA+ID4gDQo+ID4gPiBJIGp1c3QgdGhpbmsgaXQgc2hvdWxkIGJlIG1vcmUgZ2VuZXJpYyBhbmQg
Y2xvc2VyIHRvIHRoZSBwYWdlDQo+ID4gPiBhbGxvY2F0b3IuDQo+ID4gPiBJIHdhcyB0aGlua2lu
ZyBhYm91dCBhZGRpbmcgYSBHRlAgZmxhZyB0aGF0IHdpbGwgdGVsbCB0aGF0IHRoZQ0KPiA+ID4g
YWxsb2NhdGVkDQo+ID4gPiBwYWdlcyBzaG91bGQgYmUgcmVtb3ZlZCBmcm9tIHRoZSBkaXJlY3Qg
bWFwLiBUaGVuIGFsbG9jX3BhZ2VzKCkNCj4gPiA+IGNvdWxkIHVzZQ0KPiA+ID4gc3VjaCBjYWNo
ZSB3aGVuZXZlciB0aGlzIEdGUCBmbGFnIGlzIHNwZWNpZmllZCB3aXRoIGEgZmFsbGJhY2sNCj4g
PiA+IGZvciBsb3dlcg0KPiA+ID4gb3JkZXIgYWxsb2NhdGlvbnMuDQo+ID4gDQo+ID4gVGhhdCBk
b2Vzbid0IHByb3ZpZGUgZW5vdWdoIGluZm9ybWF0aW9uIEkgdGhpbmsuIFJlbW92aW5nIGZyb20N
Cj4gPiBkaXJlY3QNCj4gPiBtYXAgaXNuJ3QgdGhlIG9ubHkgY29uc2lkZXJhdGlvbiwgeW91IGFs
c28gd2FudCB0byBncm91cCB0aGVtIGJ5DQo+ID4gdGhlDQo+ID4gdGFyZ2V0IHByb3RlY3Rpb24g
Yml0cyBzdWNoIHRoYXQgd2UgZG9uJ3QgZ2V0IHRvIHVzZSA0ayBwYWdlcyBxdWl0ZQ0KPiA+IHNv
DQo+ID4gbXVjaC4NCj4gDQo+IFVubGVzcyBJJ20gbWlzc2luZyBzb21ldGhpbmcgd2UgYW55d2F5
IGhhbmQgb3V0IDRrIHBhZ2VzIGZyb20gdGhlDQo+IGNhY2hlIGFuZA0KPiB0aGUgbmVpZ2hib3Vy
aW5nIDRrIG1heSBlbmQgdXAgd2l0aCBkaWZmZXJlbnQgcHJvdGVjdGlvbnMuDQo+IA0KPiBUaGlz
IGlzIGFsc28gc2ltaWxhciB0byB3aGF0IGhhcHBlbnMgaW4gdGhlIHNldCBSaWNrIHBvc3RlZCBh
IHdoaWxlDQo+IGFnbyB0bw0KPiBzdXBwb3J0IGdyb3VwZWQgdm1hbGxvYyBhbGxvY2F0aW9uczoN
Cj4gDQoNCk9uZSBpc3N1ZSBpcyB3aXRoIHRoZSBzaHJpbmtlciBjYWxsYmFja3MuIElmIHlvdSBh
cmUganVzdCB0cnlpbmcgdG8NCnJlc2V0IGFuZCBmcmVlIGEgc2luZ2xlIHBhZ2UgYmVjYXVzZSB0
aGUgc3lzdGVtIGlzIGxvdyBvbiBtZW1vcnksIGl0DQpjb3VsZCBiZSBwcm9ibGVtYXRpYyB0byBo
YXZlIHRvIGJyZWFrIGEgbGFyZ2UgcGFnZSwgd2hpY2ggd291bGQgcmVxdWlyZQ0KYW5vdGhlciBw
YWdlLg0KDQpJIHRoaW5rIGZvciB2bWFsbG9jLCBldmVudHVhbGx5IGl0IHNob3VsZCBqdXN0IGhh
dmUgdGhlIGRpcmVjdCBtYXANCmFsaWFzIHVubWFwcGVkLiBUaGUgcmVhc29uIGl0IHdhcyBub3Qg
aW4gdGhlIGxpbmtlZCBwYXRjaCwgaXMganVzdCB0bw0KaXRlcmF0aXZlbHkgbW92ZSBpbiB0aGUg
ZGlyZWN0aW9uIG9mIGhhdmluZyBwZXJtaXNzaW9uZWQgdm1hbGxvY3MgYmUNCnVubWFwcGVkLg0K
DQo=
