Return-Path: <SRS0=TgKr=NW=lists.openwall.com=kernel-hardening-return-21380-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A8CC432BE
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 17:58:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9803E60F9E
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 17:58:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9803E60F9E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 29968 invoked by uid 550); 31 Aug 2021 17:58:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29936 invoked from network); 31 Aug 2021 17:58:29 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10093"; a="198772606"
X-IronPort-AV: E=Sophos;i="5.84,367,1620716400"; 
   d="scan'208";a="198772606"
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,367,1620716400"; 
   d="scan'208";a="519809989"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k30/BvQJSNjMnJkmKRQysS+wEAi6wom9H+RYSmOaEVh5Kw/+SDSyAuf16ElXbmvUPyVbGkwZPuGrvqNPqJaI+7z1hcnumV2N3lNBz7ISTrRHdsNxZVdZb8F9qgU/UROEzWBqLahXpV2OfDBesPAR6leDQVvDykYVxvGMJ4IxArJ9kD/ylBrfUa2241w6jE0kqzuis8JDIiq7adpOgtnWcXrTEK1Idy20ZfWT0W8gXW4uhbhaiyw5WEyUaKBKLuvbIU3WGjtb3ikzBiM+GP/kAlYdjBhBY8LLdk+nygRK3feEnABv2Ait75h3fZXzFs/ycAnDZV7gHhUXn4w+rw+pjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JI9/wEW/44Zdc9f8YUTnI4VLsxpizYFWbgWSiyGelPM=;
 b=N7fm5GXywHneRd+cGX8XkzriD/6hdHH9Iy2t4iLPU4yWSk/DJWiKVye7mVb/OsbTzmb/9M0X+mPmOhxkMEHAt10A+duuUteKCtVe3szxbRTdiRplerJ0VrJbjEuQEiDQaFPXSy73C6QK/O/YyYWcMw8sq9MUvqxj1RniBa7/rplxxme847wC5tmoEaGlMX6Rw09Qnl4CLdyocWMg+nu3OkgwsbGCdgVPfXKGGU6UNTsWs5j9I6cwoU51qeE5l6/MgUoQ5ETuTqb/j2W8RlBh4f6Q5Wd9Y7S2e4l59lL42BB/9dPVELHYfPX2lwj+pZSXqNfF8xRuxTpZ0dehFm/Hqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JI9/wEW/44Zdc9f8YUTnI4VLsxpizYFWbgWSiyGelPM=;
 b=IDyZ36Io7dpIezpv4zQdRx10VrfOq166HdTqgAiXuTahnQ7HN3y46CD0Zk9bEOt17UEfpW+CwlthtNlnITZmWP+XMRQ90x2X8sEeciX83DefLDOoXwZeiM/ARHL+1R5AJwk182Sa5Z+GnR+xLrauE36A/SRTPE8O78WxvEU2tNE=
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
Subject: Re: [RFC PATCH v2 17/19] x86/mm/cpa: PKS protect direct map page
 tables
Thread-Topic: [RFC PATCH v2 17/19] x86/mm/cpa: PKS protect direct map page
 tables
Thread-Index: AQHXnftC1idj/sxjpECi31R8IraMbquNZfEAgACBlIA=
Date: Tue, 31 Aug 2021 17:58:04 +0000
Message-ID: <69aaf7209a560b6414c5ea839bd9a3800495050e.camel@intel.com>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
	 <20210830235927.6443-18-rick.p.edgecombe@intel.com>
	 <YS4A+F1H9MvyOeMV@kernel.org>
In-Reply-To: <YS4A+F1H9MvyOeMV@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc0b1302-b84e-4448-1ef3-08d96ca8e1b4
x-ms-traffictypediagnostic: SN6PR11MB3120:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3120C92D6416A8B62D0407E0C9CC9@SN6PR11MB3120.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ABRw6zGipbpEtyX9uwatQ+jipYmaGDEOGet6YCLD5kb4rkpTB+8yECG1+KY9d7diEzDx//Wc3qMsjUq+Yrcr1J5XQTGGIEQiTP9kyIEFItYr9ELL6w9XciCeM7am8aba+2LnJF5QO5jXOI/JyvFo3CUT/VqUODclHDkCixryE4NTg8BAhe3xDVbfRGIUa/cP0pJx5oK27iUJh9cG80PJ7TN2r5t9Xx/jUNfw1dXed7eTVA431KuKt5wo706SsPfpDdrIM62V2NidkpIpMitoVBXGWSfiqDxANPY7YVvEujQ1B/ldmBKm1Up5l4+9dE9KSYbYE+yav1DMlodDzPDwXOBdcTY/rW6kPmUmDzIkQ1ezq/Rz4G9R0gZJb0ErHQ3bJqZ7DKK84YEddhjh9RmQWdmZvirXefWvA1fexhGes527AYd/kgL0lewrkYzbcCpN18usuHkcSMixSo+nzfnaYOF8dEeJIZHCbC5Mv3ycbllwwy8y8venY6PMupsCiQwPH7chT9IVWaKA4ln4a7grg1vAq1gMIpw/63FVy75hszHHiHLFI6ervAR4pXZo3tgar/e0b9JyEOXhX9NpZmCXEH9VQJA6N0SlcQkqMieskyRKONWiwl7Rsy5i6Qwx1IkAn3gmAVyYcWPAEdjsT0S19cfOqJPzg0I7KMXPCosPuXtBvVLp3WhZYAM9rTeCGYoLraTd+vCrtM+rKkStVJMJ45ptqs9N14vm/oboxtlEVT0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39850400004)(346002)(366004)(38070700005)(83380400001)(91956017)(2616005)(86362001)(38100700002)(76116006)(66476007)(54906003)(66446008)(66946007)(36756003)(2906002)(316002)(6486002)(64756008)(66556008)(478600001)(8676002)(122000001)(6916009)(26005)(7416002)(71200400001)(6506007)(5660300002)(6512007)(8936002)(186003)(4326008)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Nm9MYmFPMXA4S0k0UWxVV28rTVk4Zkg1YU9ldGFkUW9EMTVFR1hCTWNKb3o1?=
 =?utf-8?B?RDZjWE9rblQraHdkY3dENTZNTVB3cExBV3c3a25rb2VScG9lcU81VGJwTit0?=
 =?utf-8?B?TWJRc1lrVXAvbmxiMHd6TWpLWlcreHlCSm9yQnRvaytWOGZTQ3NlTUo1MTZ2?=
 =?utf-8?B?WnB1VnVzQXlpQnQxT2RPK1g1Yko5RFZPbGlKTVhoczNWc0NlaExucDVNcHVL?=
 =?utf-8?B?Qk5mZ1JpZ0NNbUZuVVNYQlR5RDJVcGNCdDgwRXkyYVR6MWFYSnpSZXJJSGNT?=
 =?utf-8?B?R0xvVS9lWitrdnhMWWtrMnJlVUFSbUtLelZmY1J5dngyUUxlcjhMMmRvbEh0?=
 =?utf-8?B?azY0bmVDOWRGclphVHFWSTBva0JRQXdtUUJDbjVRYkRIb1BCTkxKalVvOXp1?=
 =?utf-8?B?Ry95SXpmemN2MnJqbmx0a1Vob05KMkYwb2F5Qmc5dlk1ckZGTHlaZGFnc2dp?=
 =?utf-8?B?NEhuSEc5TVZKZklnR0tvRndVVGViakNXSkcvMGFJQkhDZ2NaVlpUNFRxRk84?=
 =?utf-8?B?S3RVbnkzRVZDcXhocWNsUm44UkhZZGJNSjUvbXhIWjRVdWtqRCtVTWtqTVV3?=
 =?utf-8?B?L0VsenRrdy9TbW4xQ3ZteWRtR1J1dDVUbzVkUEt4MWcvellSV2U5SU03dEJo?=
 =?utf-8?B?S0FlU3FVb1ZDcng2cmxnZDZhZHJKMEtSZnU4REFGODJ3M0VuQURUTEJyMzRD?=
 =?utf-8?B?RDFSZHVHNlJPOWJnSU5EK1pGVVRiMml3NW9Zay8rYzFJblFreko3RDNCVjRK?=
 =?utf-8?B?WHI2am9jT2lNT2pycXVmdGh3d3FQZHRJL0Y5LzlLZmZ3cmp6WVV0UVMxclF4?=
 =?utf-8?B?Zm5mN0YyUXNBY1dvUWppWFhmRk5PaXVEZnBleXAxYlNRQWo0MUJ2RkE2VkMx?=
 =?utf-8?B?dTJ6UjBzSCtBTE0vUWxQSGFuNUxzOWdSSjNWM2FlRVczZDdhWERaYmQ0ZXNu?=
 =?utf-8?B?aDcwdlFMc000aUwyYlN4c29JeWI5V3ZIS1VGcFpMZkZHUkVUNW9HSTBDdysv?=
 =?utf-8?B?SkZQdUloeURnQzYwRzRqVHlwTjY1N2w1cGkzR1pKbU1wZk1LT2E0WEl1QThQ?=
 =?utf-8?B?VC9WcFgvNTRZai9KSkVLY2NMZncxYzNVQ1gvb0lkdGdEaFRiVUNTMGN5YzVj?=
 =?utf-8?B?cTBoS3hxbnNST2V2R1dpN0lBOHAwKzBpajE2YndlZHdqWmc0YUFBQS8vblF5?=
 =?utf-8?B?SXpncUpiQjlZeUNSQVBXVE42WTZoZG9uQ0twc1FHWDJ4L1hKQnZ2WlAxU2dY?=
 =?utf-8?B?bEtmOTU2Y3BGS3ZUR3hEdTArSVBZdlVRVldCdzhRUkRWS2R6dDVKQWNMMmJ5?=
 =?utf-8?B?NzE4czNWeStmTnFYVEJkbVlKTmpFZnVMdFhrTXZGajFSY3FESXAzK2ZDUDdo?=
 =?utf-8?B?V21RT0xTNFZVbnpYZkZOLzRESmdJU2EwTE1GeFdUN1Jpa0NONW1wdDZ3YWhj?=
 =?utf-8?B?NjA1L2NRR0lJOXhZak9zOHhCRlhPMUU5MHNhOTZhbUJHMGJRUmdrRTlZWEEx?=
 =?utf-8?B?ZllDOFdDRHNUME1ZYnRacEJSYy9obEc5NXhBcy94REhVbnMrUFFMc1pGRUwy?=
 =?utf-8?B?T0F4R2tSNVBjd3I1dkpSbU45L0pSVks4SzN6QlY1VTZSWnBYREtzTWZFWVJn?=
 =?utf-8?B?eDR3NFFqMkRvZ0R4NXVmTndaMWFvZVh5TktqK09WUXQweXd6WGJwUk1hUktU?=
 =?utf-8?B?Rm52bGxDR3ZmUktTOG9oMDN2K3FheUtMVHJ1aGZSdndMYk4yekZZaXcwMHVn?=
 =?utf-8?B?dkVDdFE4LzBsTkhCMHBYUzhBRmhycDZFN3FPM1pYSzBhTkF1UFMxRDk2ckNE?=
 =?utf-8?B?b3h6d21CUGhZbnFpQkluZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <71758F83623BD24F8BA4D832BA196431@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc0b1302-b84e-4448-1ef3-08d96ca8e1b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 17:58:04.5080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: in+MkeXoIBgebEBC9sAm/XF2AE73CSCx0306qJDvyDgdabEenXD3DED54wpPLL0/oK4tYmOErxZJ49BehNep+N86GVw+2Z/djx5KpksId4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3120
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIxLTA4LTMxIGF0IDEzOjE0ICswMzAwLCBNaWtlIFJhcG9wb3J0IHdyb3RlOg0K
dHJpbQ0KPiA+ICsvKg0KPiA+ICsgKiBJZiBwcmUgYm9vdCwgcmVzZXJ2ZSBsYXJnZSBwYWdlcyBm
cm9tIG1lbW9yeSB0aGF0IHdpbGwgYmUNCj4gPiBtYXBwZWQuIEl0J3Mgb2sgdGhhdCB0aGlzIGlz
IG5vdA0KPiA+ICsgKiBtYXBwZWQgYXMgUEtTLCBvdGhlciBpbml0IGNvZGUgaW4gQ1BBIHdpbGwg
aGFuZGxlIHRoZQ0KPiA+IGNvbnZlcnNpb24uDQo+ID4gKyAqLw0KPiA+ICtzdGF0aWMgdW5zaWdu
ZWQgaW50IF9faW5pdCByZXNlcnZlX3ByZV9ib290KHU2NCBzdGFydCwgdTY0IGVuZCkNCj4gPiAr
ew0KPiA+ICsgICAgIHU2NCBjdXIgPSBtZW1ibG9ja19maW5kX2luX3JhbmdlKHN0YXJ0LCBlbmQs
IEhQQUdFX1NJWkUsDQo+ID4gSFBBR0VfU0laRSk7DQo+ID4gKyAgICAgaW50IGk7DQo+IA0KPiBQ
bGVhc2UgdXNlIG1lbWJsb2NrX3BoeXNfYWxsb2NfcmFuZ2UoKSBoZXJlLg0KT2ggeWVhLCB0aGF0
J3MgYmV0dGVyLiBUaGFua3MuDQoNCj4gQmVzaWRlcywgaXQgc2VlbXMgdGhpcyByZXNlcnZlZCBw
YWdlcyBhcmUgbm90IGFjY2Vzc2VkIHVudGlsDQo+IGxhdGVfaW5pdGNhbGwNCj4gdGltZSwgc28g
dGhlcmUgaXMgbm8gbmVlZCB0byBsaW1pdCB0aGUgYWxsb2NhdGlvbiB0byBhbHJlYWR5IG1hcHBl
ZA0KPiBhcmVhcywNCj4gbWVtYmxvY2tfYWxsb2NfcmF3KCkgd291bGQgc3VmZmljZS4NClRoZSBw
YWdlIGl0c2VsZiBpcyB1c2VkIGZvciB0aGUgbGxpc3Rfbm9kZS4gSSBkaWRuJ3Qgc2VlIGFuIGVh
c3kgd2F5IHRvDQpnZXQgYSBzbWFsbGVyIGFsbG9jYXRlIGF0IHRoaXMgdGltZS4gSSBndWVzcyBp
dCBjb3VsZCB1c2UgbGVzcyBtYXBwZWQNCm1lbW9yeSBieSBqdXN0IHVzaW5nIGEgZmV3IG1hcHBl
ZCBwYWdlcyBmb3Igc29tZSBzdHJ1Y3RzIHRvIGtlZXAgdGhlDQpsaXN0IG91dHNpZGUgb2YgdGhl
IHVubWFwcGVkIHBhZ2VzLCBidXQgaXQgYmVjb21lcyBtb3JlIGNvbXBsZXguDQoNCj4gDQo+ID4g
Kw0KPiA+ICsgICAgIGlmICghY3VyKQ0KPiA+ICsgICAgICAgICAgICAgcmV0dXJuIDA7DQo+ID4g
KyAgICAgbWVtYmxvY2tfcmVzZXJ2ZShjdXIsIEhQQUdFX1NJWkUpOw0KPiA+ICsgICAgIGZvciAo
aSA9IDA7IGkgPCBIUEFHRV9TSVpFOyBpICs9IFBBR0VfU0laRSkNCj4gPiArICAgICAgICAgICAg
IGFkZF9kbWFwX3RhYmxlKCh1bnNpZ25lZCBsb25nKV9fdmEoY3VyICsgaSkpOw0KPiA+ICsgICAg
IHJldHVybiBIUEFHRV9TSVpFOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICsvKiBJZiBwb3N0IGJvb3Qs
IG1lbWJsb2NrIGlzIG5vdCBhdmFpbGFibGUuIEp1c3QgcmVzZXJ2ZSBmcm9tDQo+ID4gb3RoZXIg
bWVtb3J5IHJlZ2lvbnMgKi8NCj4gPiArc3RhdGljIHVuc2lnbmVkIGludCBfX2luaXQgcmVzZXJ2
ZV9wb3N0X2Jvb3Qodm9pZCkNCj4gPiArew0KPiA+ICsgICAgIHN0cnVjdCBwYWdlICpwYWdlID0g
YWxsb2NfdGFibGUoR0ZQX0tFUk5FTCk7DQo+ID4gKw0KPiA+ICsgICAgIGlmICghcGFnZSkNCj4g
PiArICAgICAgICAgICAgIHJldHVybiAwOw0KPiA+ICsNCj4gPiArICAgICBhZGRfZG1hcF90YWJs
ZSgodW5zaWduZWQgbG9uZylwYWdlX2FkZHJlc3MocGFnZSkpOw0KPiANCj4gYWRkX2RtYXBfdGFi
bGUoKSBjYWxscyB1c2UgY2FzdGluZyBldmVyeXdoZXJlLCBtYXliZSBtYWtlIGl0DQo+IGFkZF9k
bWFwX3RhYmxlKHZvaWQgKik/DQo+IA0KWWVhLCBJJ2xsIGdpdmUgaXQgYSB0cnkuIEl0IHdhcyBv
biBteSB0b2RvIGxpc3QsIGJ1dCBzb21laG93IGdvdA0KZm9yZ290dGVuLg0KDQo+ID4gKw0K
