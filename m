Return-Path: <SRS0=eqyS=KF=lists.openwall.com=kernel-hardening-return-21260-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1896C433ED
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 May 2021 19:39:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7432B613C2
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 May 2021 19:39:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7432B613C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21260-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24145 invoked by uid 550); 10 May 2021 19:38:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24112 invoked from network); 10 May 2021 19:38:56 -0000
IronPort-SDR: jSTzf4sMXafn701dKf7C5d37pAoZZ6VXmJrtwAlQxBgxXMUr8hTb1HkRWrOmpP5plEgpUi1y3u
 scuyKOPBXqSg==
X-IronPort-AV: E=McAfee;i="6200,9189,9980"; a="196180152"
X-IronPort-AV: E=Sophos;i="5.82,288,1613462400"; 
   d="scan'208";a="196180152"
IronPort-SDR: ayM66Z2/x4UaQL7uhuIaZ0ppXX4o45YQ5z4EQDJ34CCLQK8fcSzdB2qpQTRz9EH8z3W2mc8zbo
 LLhtso2ARJkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,288,1613462400"; 
   d="scan'208";a="621384321"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWPrJLCEdgnyGPI6d0VLc5us7yFZrQBwE7Ps1On0gNFL2xeKXF0/rc1fKBwnaLTOUDHUXxFD8IBcZBXIyq22sW4BgNyDobHHRUcHkGPOesEaRl2fDKlI08eimd9YkHGwzQRQZSO0AiJkQgj1NJ1I6Jv7pC4WTlysb0zpuKF8t42/FrARXpiNCIIwDjH1wEhdLmK15VzN4qM6ogk+6SfFA2NJk+4osG3B4P69CPD5ElgL3USprChRdyQmbCGXi44Ihsn8NZoDQ3UnT/DEc2SpOCXWMyczf3CJ+qrjeF1dITBSVccuFDJJN2c/MohXxQWVXgy6hYXeVQL5fLn1z75Y7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qLx9lDTXdJVZB1oLa618uinenpapUz9QJV+6MgIJTf0=;
 b=SyL1h2vSlmjDRw8AcOAuOg465YKfWZCnMpQFh1NwNPCDwaRNHE15FunEbxNP6g+NR2DvQHny48G/9laHA4zXJTQjpYcjXrhIye3urV7ieMqPjaN0xP2cdLYS3svGop4+P+T6vuxTw6wIMxWVMyISiSFS+MjBo/NcfeZ7yzUO3IyefZ521siT1TC0AmUUjGAToZYprFHnVfXhJnXimk5YNEEzugwD3oqEvNi+1zM75ksOqMTH1hQJ3xMn0qsPOgXHrcGvsHKspmlKd2uABq3afTp8fVjMr7H77lG4V0dh4SRBzZPlVVWYJN2VF1vjZ4c6oz8h0HRl2DJzTQU6vGg2WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qLx9lDTXdJVZB1oLa618uinenpapUz9QJV+6MgIJTf0=;
 b=B2VZ0jMHWwM/0PAl+1qRkm47l/avL0gcqYT9DTlrLapTlo5NaLkOdhPuhyE7u+MKXDW6l5csfe9n+KxeO6zNFJmuiBFn4Y1tvZu5mRHJbm2wJF073gyFYFg0FSLggkc1TLze/cKBaLAHZ3I1TlKUpff4UW3TGuGAOzEqP7eDzyE=
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "rppt@kernel.org" <rppt@kernel.org>
CC: "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "luto@kernel.org" <luto@kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, "Weiny,
 Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH RFC 3/9] x86/mm/cpa: Add grouped page allocations
Thread-Topic: [PATCH RFC 3/9] x86/mm/cpa: Add grouped page allocations
Thread-Index: AQHXQUYjrHRaN7YNCESTntxXPP7WtqrUzCmAgAAQ+QCAAF30AIAANZiAgAV7ToCAAjmbgA==
Date: Mon, 10 May 2021 19:38:37 +0000
Message-ID: <bcfe16c4b87c791b20aa1fb8090c01ed7ac4961a.camel@intel.com>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
	 <20210505003032.489164-4-rick.p.edgecombe@intel.com>
	 <YJKKu7kMCtCuel2L@kernel.org>
	 <YJKY+Ccxfe9wD0iP@hirez.programming.kicks-ass.net>
	 <YJLnyJP755XAPZNX@kernel.org>
	 <bb2a9aaedcd5d47ace719050fa06d7a21050cfc5.camel@intel.com>
	 <YJet66kzbb6UB5Qe@kernel.org>
In-Reply-To: <YJet66kzbb6UB5Qe@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.38.4 (3.38.4-1.fc33) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.137.85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82f19c32-5f5e-4699-e04f-08d913eb3544
x-ms-traffictypediagnostic: SN6PR11MB3517:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3517F1C58BDFD21F3C032E48C9549@SN6PR11MB3517.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: atjbe8bYwreg5NG3vuOI0lP11IN948GhmhOkFwaRN+VYPl66bBpsW25tpGt3aKgOEWTrs6svTnwDkaRGi5l9bHnfRM5qtrveaZ5HvC0Lff3yBH+Ue9bJHU6UaDTnVao/25aQs7UpC7baDweDzAolVJWbqxBuhlViV0alS2IEm5PZ+D/Iivvzq7ZqXS3MMd0m0jYf8F+nnOchvmgE9cYztDAMXnuB5VKkSqSmFfq+oWPo1kyrmxaIKUhXAT61N8z6PluEPuA4mI1vTt7D6ghYT4FJUQ9iHGdfc23x1amX9tU5kMMtgaydkdHWcmNvZwm8O+Iax2lhTN9gwdt+sdLS2kRbKQXMEDGKwFBCQC+y34rZMw5IXQlimYxhI67sAKFJIFU4dkGJyeKcH0qa5s3vGnhqaf9akGnGmLuWZvchm7AfPOwjOw2khE4cJuszY0yetKGGP3s7Qu83hItWXilSol0HhSwKnX9ITd9nbqQZl0KFeu7sZ2/4XN7C3tWGis25KfTDl0P/zOxA7Qw0s3p4MSOWtoCMfx/OqTi328Zl6gklWjuomp94qxaC/LVzkobAw6N1nCoH4JlTuHmGrY9MOfbSm77luGArj9E70aH/mQ4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(366004)(136003)(396003)(122000001)(66556008)(8676002)(38100700002)(66446008)(71200400001)(186003)(64756008)(8936002)(26005)(66476007)(6512007)(66946007)(4326008)(83380400001)(478600001)(7416002)(2906002)(2616005)(6486002)(6506007)(36756003)(316002)(76116006)(6916009)(86362001)(54906003)(91956017)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?S0U1UGhvVGlSNDd4U0F1bHQvb0xVaDJRUjl1SVpETWRsNDh6ZU80cENtYUo1?=
 =?utf-8?B?cUlLckhuRjA0eEpuQWFscDFOWmU3eXh5WGJ1OXJlSXlDTjV2enZEelQ3S2d1?=
 =?utf-8?B?YWVra3VSTkdsL1lIbkhYYzQ1alIwcWd2Q3VmZjdGRTA0UVF4YjRqQUdFNTZx?=
 =?utf-8?B?VUxnT253a2pva1ZoS056ZXVkcnU0R01uaWw3M1Rjc216YnlCZ3NaWXdoSEJn?=
 =?utf-8?B?ZDZwZlM3TnVQT1UvT2I2T2czT2pxQXI4dE8zeU9iNFlVSWpVb1Z2SXZlcXZx?=
 =?utf-8?B?L3VmNE02U3VhdHhFL0RadVlXOUt4STI1MStmemtEeHVwQVllWDZ2VEs5U1Q4?=
 =?utf-8?B?dVdBeGhPcCtvd0VkYVhGMUY2TmdmRlI5d08rWUtobFlPRGtuMXhZYmVnVm5x?=
 =?utf-8?B?K2R1bXdrR2hOd3BhTXZRTE96WkU4VDc4RlN1cVNxNGxjUmJWSXY0WjgvbnBk?=
 =?utf-8?B?RmIzMzBRdDRhTjNCMis3Y3hQeE9NVnUvYnZUa0dRRlVEOUdCeSs4T0svVWtq?=
 =?utf-8?B?OVloOWhGRW9PdS95MjF6OHppdWtHRGNIMEpLRjlOL1JHNEcwd0FxbGVaTm91?=
 =?utf-8?B?MForSVJPQVNua001RGY1ODhONHJjTDkvbm80dUlVUEpzRjNsK0lqMzE3cHVC?=
 =?utf-8?B?SzJudHJERCt2bUNkZllmRXJFM2htcDdFK1VQZjBJbjNGMit4djcvbWhJWm9E?=
 =?utf-8?B?ZDVLNjdVcXFvYW02aDdkSHVoZVRHNDJhWU5DUVM5Z3Qza0FEaUFqTEdxT3ZL?=
 =?utf-8?B?WjlSREZhL2llUm5sdWwxZW11Rlk2OU9BM1BtRlQ1aUlxSVJYcEF5RXJJNllt?=
 =?utf-8?B?cHk3RGY3aGFneFRCUlQrYk5LRDNwTnlydi9CNlRWTVREcWdJcnJldGdoemZK?=
 =?utf-8?B?V3greTdrdUh2WXlOZjZIRzN3N0J4b1hhZWFhYTQveFZxQ1hmNVY3d2lrRXJk?=
 =?utf-8?B?cE5ycHR1S3lQTVNiVVl1ZFdzVENQbTJSWm40T1l3Zk1iejVrWnFKaVJlRnFh?=
 =?utf-8?B?UnhpU2ZVS0MyRWQ0ZVkvcEFUZC9iRDdTN2tTUGFjcmtIZlJmOFlLZlN5V0pV?=
 =?utf-8?B?aDlaTytwVFJYMk1qemVmSmczM3FOZmJuT0tjRk9zNFVUaEVCSC9mWWxMLzNW?=
 =?utf-8?B?Y3AzRmZubkYxc2NDdnRGREpHcWtKR21sOFAvWkdlWmVWUXJ4Zzd5RTQzZmdJ?=
 =?utf-8?B?OGU0b2k5Z0FxZENGOXBkY01EdXprRE9IYnBZMTFCUHIyZUNNK0NtQ2NlZFFB?=
 =?utf-8?B?T3pBdVRLYnhTSFdjeXI3Y0RmWWpOZTEvUzE0WXY1bC8zRExYS044dlRRb1Bj?=
 =?utf-8?B?SUQrYkh6VlhlV0p6Y0NPUFVobDg2U0VyVUdBb3ZPRFJKQ2pIMzVWNFNqTTVV?=
 =?utf-8?B?bWIrL0Yvems3YStoZTVXM0dQTEVBL25mZHJqM2x2N2JZd05mSkcvNUhtTDZW?=
 =?utf-8?B?Y1c5VVpFang0ZWJJTldDTGh1c0RxQUxlRXdWb1ZDd0g4bnhmNWxZMHM2RkQ1?=
 =?utf-8?B?aFpUNEtXZXNDRXlrS25RRjlNS0ROejFDOWNKZ0srM1Mva1NQZWJ2UEZoWmRO?=
 =?utf-8?B?WnVDd21USmlGbHI0ZlYrK3ZwOW53akFVLzhUVmpTRkE1MXBUSmJjb1M2eTh4?=
 =?utf-8?B?US9jMmUrejV0dUNKTytEUVJDRTJFR2djMHg5U29BeGdzSkZPYjRhZ3JDUE1B?=
 =?utf-8?B?WHFaYTZRamxudytibWdKbmFlZUtxWDJpRk9XL2ExajdBVlFPTHpMQ2FUWXJT?=
 =?utf-8?B?YkFKQUFySjV2ZzcwZk1RU1NmK2RZOUp6QkFndFFaR09MaEJmNStvQTdCMlVZ?=
 =?utf-8?B?VVpJYWJINHRvL2lodnVPQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <06FA6407F727F043853C159CC74E1B16@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f19c32-5f5e-4699-e04f-08d913eb3544
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2021 19:38:38.0645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: frjL2FaHbvUp/XTm34W4DUXedkGrvzFGT5DhbrjgyKIbEd1Lct1Ec6XleIwzxmCXoNU/WI8O71V1rpG4SGE7kGGVCOtplt90Q8UGe2mKojM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3517
X-OriginatorOrg: intel.com

T24gU3VuLCAyMDIxLTA1LTA5IGF0IDEyOjM5ICswMzAwLCBNaWtlIFJhcG9wb3J0IHdyb3RlOg0K
PiBPbiBXZWQsIE1heSAwNSwgMjAyMSBhdCAwOTo1NzoxN1BNICswMDAwLCBFZGdlY29tYmUsIFJp
Y2sgUCB3cm90ZToNCj4gPiBPbiBXZWQsIDIwMjEtMDUtMDUgYXQgMjE6NDUgKzAzMDAsIE1pa2Ug
UmFwb3BvcnQgd3JvdGU6DQo+ID4gPiBPbiBXZWQsIE1heSAwNSwgMjAyMSBhdCAwMzowOToxMlBN
ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToNCj4gPiA+ID4gT24gV2VkLCBNYXkgMDUsIDIw
MjEgYXQgMDM6MDg6MjdQTSArMDMwMCwgTWlrZSBSYXBvcG9ydCB3cm90ZToNCj4gPiA+ID4gPiBP
biBUdWUsIE1heSAwNCwgMjAyMSBhdCAwNTozMDoyNlBNIC0wNzAwLCBSaWNrIEVkZ2Vjb21iZQ0K
PiA+ID4gPiA+IHdyb3RlOg0KPiA+ID4gPiA+ID4gRm9yIHg4Niwgc2V0dGluZyBtZW1vcnkgcGVy
bWlzc2lvbnMgb24gdGhlIGRpcmVjdCBtYXANCj4gPiA+ID4gPiA+IHJlc3VsdHMNCj4gPiA+ID4g
PiA+IGluIGZyYWN0dXJpbmcNCj4gPiA+ID4gPiA+IGxhcmdlIHBhZ2VzLiBEaXJlY3QgbWFwIGZy
YWN0dXJpbmcgY2FuIGJlIHJlZHVjZWQgYnkNCj4gPiA+ID4gPiA+IGxvY2F0aW5nDQo+ID4gPiA+
ID4gPiBwYWdlcyB0aGF0DQo+ID4gPiA+ID4gPiB3aWxsIGhhdmUgdGhlaXIgcGVybWlzc2lvbnMg
c2V0IGNsb3NlIHRvZ2V0aGVyLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBDcmVhdGUgYSBz
aW1wbGUgcGFnZSBjYWNoZSB0aGF0IGFsbG9jYXRlcyBwYWdlcyBmcm9tIGh1Z2UNCj4gPiA+ID4g
PiA+IHBhZ2UNCj4gPiA+ID4gPiA+IHNpemUNCj4gPiA+ID4gPiA+IGJsb2Nrcy4gRG9uJ3QgZ3Vh
cmFudGVlIHRoYXQgYSBwYWdlIHdpbGwgY29tZSBmcm9tIGEgaHVnZQ0KPiA+ID4gPiA+ID4gcGFn
ZQ0KPiA+ID4gPiA+ID4gZ3JvdXBpbmcsDQo+ID4gPiA+ID4gPiBpbnN0ZWFkIGZhbGxiYWNrIHRv
IG5vbi1ncm91cGVkIHBhZ2VzIHRvIGZ1bGZpbGwgdGhlDQo+ID4gPiA+ID4gPiBhbGxvY2F0aW9u
DQo+ID4gPiA+ID4gPiBpZg0KPiA+ID4gPiA+ID4gbmVlZGVkLiBBbHNvLCByZWdpc3RlciBhIHNo
cmlua2VyIHN1Y2ggdGhhdCB0aGUgc3lzdGVtIGNhbg0KPiA+ID4gPiA+ID4gYXNrDQo+ID4gPiA+
ID4gPiBmb3IgdGhlDQo+ID4gPiA+ID4gPiBwYWdlcyBiYWNrIGlmIG5lZWRlZC4gU2luY2UgdGhp
cyBpcyBvbmx5IG5lZWRlZCB3aGVuIHRoZXJlDQo+ID4gPiA+ID4gPiBpcyBhDQo+ID4gPiA+ID4g
PiBkaXJlY3QNCj4gPiA+ID4gPiA+IG1hcCwgY29tcGlsZSBpdCBvdXQgb24gaGlnaG1lbSBzeXN0
ZW1zLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IEkgb25seSBoYWQgdGltZSB0byBza2ltIHRocm91
Z2ggdGhlIHBhdGNoZXMsIEkgbGlrZSB0aGUgaWRlYQ0KPiA+ID4gPiA+IG9mDQo+ID4gPiA+ID4g
aGF2aW5nIGENCj4gPiA+ID4gPiBzaW1wbGUgY2FjaGUgdGhhdCBhbGxvY2F0ZXMgbGFyZ2VyIHBh
Z2VzIHdpdGggYSBmYWxsYmFjayB0bw0KPiA+ID4gPiA+IGJhc2ljDQo+ID4gPiA+ID4gcGFnZQ0K
PiA+ID4gPiA+IHNpemUuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gSSBqdXN0IHRoaW5rIGl0IHNo
b3VsZCBiZSBtb3JlIGdlbmVyaWMgYW5kIGNsb3NlciB0byB0aGUgcGFnZQ0KPiA+ID4gPiA+IGFs
bG9jYXRvci4NCj4gPiA+ID4gPiBJIHdhcyB0aGlua2luZyBhYm91dCBhZGRpbmcgYSBHRlAgZmxh
ZyB0aGF0IHdpbGwgdGVsbCB0aGF0DQo+ID4gPiA+ID4gdGhlDQo+ID4gPiA+ID4gYWxsb2NhdGVk
DQo+ID4gPiA+ID4gcGFnZXMgc2hvdWxkIGJlIHJlbW92ZWQgZnJvbSB0aGUgZGlyZWN0IG1hcC4g
VGhlbg0KPiA+ID4gPiA+IGFsbG9jX3BhZ2VzKCkNCj4gPiA+ID4gPiBjb3VsZCB1c2UNCj4gPiA+
ID4gPiBzdWNoIGNhY2hlIHdoZW5ldmVyIHRoaXMgR0ZQIGZsYWcgaXMgc3BlY2lmaWVkIHdpdGgg
YQ0KPiA+ID4gPiA+IGZhbGxiYWNrDQo+ID4gPiA+ID4gZm9yIGxvd2VyDQo+ID4gPiA+ID4gb3Jk
ZXIgYWxsb2NhdGlvbnMuDQo+ID4gPiA+IA0KPiA+ID4gPiBUaGF0IGRvZXNuJ3QgcHJvdmlkZSBl
bm91Z2ggaW5mb3JtYXRpb24gSSB0aGluay4gUmVtb3ZpbmcgZnJvbQ0KPiA+ID4gPiBkaXJlY3QN
Cj4gPiA+ID4gbWFwIGlzbid0IHRoZSBvbmx5IGNvbnNpZGVyYXRpb24sIHlvdSBhbHNvIHdhbnQg
dG8gZ3JvdXAgdGhlbQ0KPiA+ID4gPiBieQ0KPiA+ID4gPiB0aGUNCj4gPiA+ID4gdGFyZ2V0IHBy
b3RlY3Rpb24gYml0cyBzdWNoIHRoYXQgd2UgZG9uJ3QgZ2V0IHRvIHVzZSA0ayBwYWdlcw0KPiA+
ID4gPiBxdWl0ZQ0KPiA+ID4gPiBzbw0KPiA+ID4gPiBtdWNoLg0KPiA+ID4gDQo+ID4gPiBVbmxl
c3MgSSdtIG1pc3Npbmcgc29tZXRoaW5nIHdlIGFueXdheSBoYW5kIG91dCA0ayBwYWdlcyBmcm9t
IHRoZQ0KPiA+ID4gY2FjaGUgYW5kDQo+ID4gPiB0aGUgbmVpZ2hib3VyaW5nIDRrIG1heSBlbmQg
dXAgd2l0aCBkaWZmZXJlbnQgcHJvdGVjdGlvbnMuDQo+ID4gPiANCj4gPiA+IFRoaXMgaXMgYWxz
byBzaW1pbGFyIHRvIHdoYXQgaGFwcGVucyBpbiB0aGUgc2V0IFJpY2sgcG9zdGVkIGENCj4gPiA+
IHdoaWxlDQo+ID4gPiBhZ28gdG8NCj4gPiA+IHN1cHBvcnQgZ3JvdXBlZCB2bWFsbG9jIGFsbG9j
YXRpb25zOg0KPiA+ID4gDQo+ID4gDQo+ID4gT25lIGlzc3VlIGlzIHdpdGggdGhlIHNocmlua2Vy
IGNhbGxiYWNrcy4gSWYgeW91IGFyZSBqdXN0IHRyeWluZyB0bw0KPiA+IHJlc2V0IGFuZCBmcmVl
IGEgc2luZ2xlIHBhZ2UgYmVjYXVzZSB0aGUgc3lzdGVtIGlzIGxvdyBvbiBtZW1vcnksDQo+ID4g
aXQNCj4gPiBjb3VsZCBiZSBwcm9ibGVtYXRpYyB0byBoYXZlIHRvIGJyZWFrIGEgbGFyZ2UgcGFn
ZSwgd2hpY2ggd291bGQNCj4gPiByZXF1aXJlDQo+ID4gYW5vdGhlciBwYWdlLg0KPiANCj4gSSBk
b24ndCBmb2xsb3cgeW91IGhlcmUuIE1heWJlIEkndmUgbWlzcmVhZCB0aGUgcGF0Y2hlcyBidXQg
QUZBSVUgdGhlDQo+IGxhcmdlDQo+IHBhZ2UgaXMgYnJva2VuIGF0IGFsbG9jYXRpb24gdGltZSBh
bmQgNGsgcGFnZXMgcmVtYWluIDRrIHBhZ2VzDQo+IGFmdGVyd2FyZHMuDQoNClllYSB0aGF0J3Mg
cmlnaHQuDQoNCkkgdGhvdWdodCBQZXRlciB3YXMgc2F5aW5nIGlmIHRoZSBwYWdlIGFsbG9jYXRv
ciBncm91cGVkIGFsbCBvZiB0aGUNCnNhbWUgcGVybWlzc2lvbiB0b2dldGhlciBpdCBjb3VsZCBv
ZnRlbiBsZWF2ZSB0aGUgZGlyZWN0IG1hcCBhcyBsYXJnZQ0KcGFnZXMsIGFuZCBzbyB0aGUgcGFn
ZSBhbGxvY2F0b3Igd291bGQgaGF2ZSB0byBrbm93IGFib3V0IHBlcm1pc3Npb25zLg0KDQpTbyBJ
IHdhcyBqdXN0IHRyeWluZyB0byBzYXksIHRvIGxlYXZlIGxhcmdlIHBhZ2VzIG9uIHRoZSBkaXJl
Y3QgbWFwLA0KdGhlIHNocmlua2VyIGhhcyB0byBoYW5kbGUgYnJlYWtpbmcgYSBwYWdlIHdoaWxl
IGZyZWVpbmcgYSBzaW5nbGUgcGFnZS4NClNvIHRoYXQgd291bGQgaGF2ZSB0byBiZSBhZGRyZXNz
ZWQgdG8gZ2V0IGxhcmdlIHBhZ2VzIHdpdGggcGVybWlzc2lvbnMNCmluIHRoZSBmaXJzdCBwbGFj
ZS4NCg0KSXQgZG9lc24ndCBzZWVtIGltcG9zc2libGUgdG8gc29sdmUgSSBndWVzcywgc28gbWF5
YmUgbm90IGFuIGltcG9ydGFudA0KcG9pbnQuIEl0IGNvdWxkIG1heWJlIGp1c3QgaG9sZCBhIHBh
Z2UgaW4gcmVzZXJ2ZS4NCg0KTm93IHRoYXQgSSB0aGluayBhYm91dCBpdCwgc2luY2UgdGhpcyBQ
S1MgdGFibGVzIHNlcmllcyBob2xkcyBhbGwNCnBvdGVudGlhbGx5IG5lZWRlZCBkaXJlY3QgbWFw
IHBhZ2UgdGFibGVzIGluIHJlc2VydmUsIGl0IHNob3VsZG4ndA0KYWN0dWFsbHkgYmUgYSBwcm9i
bGVtIGZvciB0aGlzIGNhc2UuIFNvIHRoaXMgY291bGQgbGVhdmUgdGhlIFBLUyB0YWJsZXMNCnBh
Z2VzIGFzIGxhcmdlIG9uIHRoZSBkaXJlY3QgbWFwLg0KDQo+IEluIG15IHVuZGVyc3RhbmRpbmcg
dGhlIHByb2JsZW0gd2l0aCBhIHNpbXBsZSBzaHJpbmtlciBpcyB0aGF0IGV2ZW4NCj4gaWYgd2UN
Cj4gaGF2ZSB0aGUgZW50aXJlIDJNIGZyZWUgaXQgaXMgbm90IGJlaW5nIHJlaW5zdGF0ZWQgYXMg
Mk0gcGFnZSBpbiB0aGUNCj4gZGlyZWN0DQo+IG1hcHBpbmcuDQoNClllYSwgdGhhdCBpcyBhIGRv
d25zaWRlIHRvIHRoaXMgc2ltcGxlIHNocmlua2VyLiANCg0K
