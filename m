Return-Path: <SRS0=xiHb=KA=lists.openwall.com=kernel-hardening-return-21248-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A75D2C433ED
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 19:47:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 63FD9613AA
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 19:47:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 63FD9613AA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21248-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31859 invoked by uid 550); 5 May 2021 19:47:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31820 invoked from network); 5 May 2021 19:47:09 -0000
IronPort-SDR: xYv8eAk0hWuKqCVK3UkMX/qI0sc1VLFR32f7GECiT+fqg8kU3/pUwjagpmOfT8w3rqljm/yVv8
 YYLrirax1NNg==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="196262998"
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="196262998"
IronPort-SDR: HP1GZZrGCi7eyNQWbeavQcEezWj0jPCQGc1rZMkLmHwt8XX/B2ONsv/53JzvvESnTmpCYMe+SU
 /AU9wHhwmlwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="469098905"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jojLvPpSa8EBUVnM2kx6XZI3JEJYbprTByGkAYsumR4I06G2byyjmga5+4Zom38TLMgxuUnZGtGyvA2dLHKebEDdGyFhl30hHet1IiAtNj98r9at9N5AMSyGveAAgCbnXEH/FRsvzC/MMyHoFRYLFW+5u1SF6Nb7+IleQaTnpzLQF5fr7VP9/1MSRiwz8qBUxzLUdsugXWwBL869m6yBuy7QhQsrHQBKmK1ZLL+0Z/HNj1TtYihW+PfRAkdn8VTiCf8tRRL+Py1sUsIEMmQDAWRRiKKFrYnhtsPcFpcngRMJCLcnxlRp9BF4eH6rD2yZ5xJG+awJYcWILtqFxYX/lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KWF8zRddkDOmBWv4ZMIrqI0nG/JJ/vUJLv1UoTCthdM=;
 b=HkSnxVBHiL9F35e3XYcLFkjfhhMZFnIIgoM111Y3/WI+L+wQXSgq6oRrciuzs9MqeQUpVY7ZC16jkp9aI3SbustKBQr5UTkWrXYvHbB1cVf1fUkWn4Xl/INBw5Px9TY63KhLal8X20K71bMCz307YvJMqI0Dv4gBNFhWekc+b+kRCcs/rsTNi/mejkzPeSOS0O7+ai4dIWCd85OnuJEsmH39lHnD/rlZmxEir8+VW0Tz3rlOUrhu6OxzoNH8xMhs9PRvS/r2UJ7CDeNfP++/q/chhin/ugGHThBprgS7FZMZE1DRP5IsOhd4lN8LQ+XqboWshUqgDM5CWumZmBhhcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KWF8zRddkDOmBWv4ZMIrqI0nG/JJ/vUJLv1UoTCthdM=;
 b=yJOYzu8fm6mhLH8RHhFGixwCruAZk7f/f6LZUIu42R4iQXvxurgE2/PQyj/HSgUHyXLoLKgGMxvTn7Z/MTa++xQtHNajoYn4dJ2DuYGoKnq7HOWSy8ANIkIH0qz6UKC1VQIg4qJLM6rEGDd0pa4L4xTGkfajuHIbu2jOOZNGPR8=
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "peterz@infradead.org" <peterz@infradead.org>, "vbabka@suse.cz"
	<vbabka@suse.cz>
CC: "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "luto@kernel.org" <luto@kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "linux-hardening@vger.kernel.org"
	<linux-hardening@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH RFC 0/9] PKS write protected page tables
Thread-Topic: [PATCH RFC 0/9] PKS write protected page tables
Thread-Index: AQHXQUYg7uLEQArpKEKF+xaanI/X46rUu2+AgAANUgCAAINMgA==
Date: Wed, 5 May 2021 19:46:12 +0000
Message-ID: <7279fce7e4921be698b3dd33069355f5e8993c8d.camel@intel.com>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
	 <d01c7845-6f9c-6770-c861-e624c3e2bfc5@suse.cz>
	 <YJKH4HDuCGLArdmp@hirez.programming.kicks-ass.net>
In-Reply-To: <YJKH4HDuCGLArdmp@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.38.4 (3.38.4-1.fc33) 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.137.85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3de97852-3a0a-4c51-14cb-08d90ffe6fdb
x-ms-traffictypediagnostic: SN6PR11MB3325:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3325C90BBE7C50749485C9FCC9599@SN6PR11MB3325.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1xrZAw19L3/hxMJ2oQBl1dAyrQA0zNIiJRIJUHI3+TTf0xmK7D6NFezzJ5fIkYkDjivVIfL4NdcXiYVDJePi1c9KJzbwuKvYVZaluAeFbBw4mYN4KL0VJOI5MfUzCu165VBbARfK5fMWn363531LFvHJPJGYmpArzh7cXsBbnoRjWEI9Gg9zrwNdXbvKRF79ZvhdFEMxkYJMzNUCl6lU/Q1taiZrBllpD4M5wmaYTwVFhDJ91luNq0E5jJEsjgyq8oQ+UbxVQHqoQJC0Pa5XmYnB7JFSgWeg81Vg0rpoLA5PsfogR/KxzjDRzc+eOXjOOzm8olgKERL/noihTUnaf1NIrT9g5RHA8edjp9kSOjv16gKh48PppwMyQMHo/2IEWBR82OvNhphZdzno8jAregD7Q2kxFkybGZ8qjTSuwdLAGQAT46hDYZ3uJByr0nV+haLL43BOHUdrZL60TRHL9kPZGU36+oDUsum80+dtD7j+sHKRwegoL5X0ctkpN8XzaO0QtPPUutfG6mefeSwk3P+ho+t71nYLdHqW7obZ4zQ/4oDAGlqy4jt3ZnFWhZqHc8CR5kWuARC0Qc9LSRCH5hrzkdAuR3i3+Z0woXHv42I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(136003)(346002)(376002)(26005)(8936002)(66476007)(110136005)(64756008)(66556008)(316002)(54906003)(91956017)(83380400001)(2616005)(478600001)(66446008)(2906002)(36756003)(4326008)(71200400001)(186003)(8676002)(38100700002)(5660300002)(6506007)(53546011)(7416002)(86362001)(122000001)(6486002)(6512007)(76116006)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Wk9MclpJM3loV0FnL3dqSkdKVTA3UDRmWWRvQXFrUFc2TG51Z1BTVmFhZ0RT?=
 =?utf-8?B?Mnd0VWxTK2l1UUZjTDhxMllRbnlMUld4dllSY0hQWitpVVNPdWVLMXR5ZXRF?=
 =?utf-8?B?enRUTnRVcjduTGhweHFWd3kwTlRkVTNHOUwwU2VwTkp5SkpOWXJybitCUSto?=
 =?utf-8?B?Vk1zaFRKdEthYS8yZS9GREN3Y0tmWXhvRHBnZGdoZU40UWZha09GNjYvWWZQ?=
 =?utf-8?B?Vk1XQjRzWEFBYzdNYnRaY05wbmhzbHY4bEk5T3RPUCsvWSsyRm00dXUvOGhv?=
 =?utf-8?B?UnBVampYakc1MXAxRXNyY0ZnakpxYTNNNkQ1cmhvYjNhbmdNZUtYSzNZS1l2?=
 =?utf-8?B?c3JZN2VoZG1QNk4zaWNUNjNMQ2ZIWXdqbzVwK25rcTN0UmVKN21mZUhRMkRu?=
 =?utf-8?B?WVg4VDZqL3VmbytXT0YrZ01LQzJBOWcza0pJOWtlNFNLQlpMaVc5Mjg5d2w3?=
 =?utf-8?B?QmNtVnVRMDhla1NrWnlua2xvK1VjYm5VVndpMk1mOFRvcDg0d3FudHh3M0ZG?=
 =?utf-8?B?b3hyTmtrdDZHWW1RK0xIRDJrVHpMYXo2YzdpbjZ3a1lWSFlvT25VbmwvOThF?=
 =?utf-8?B?TTI3SXF2cnVBdWlxdEVzRmpyNDdzajcwYWkyU0tKL0hrUWFzZG13R2hpMkdH?=
 =?utf-8?B?OE04bmg1bXlOTTBIZUtHTFd0clBFa3pVNExlZnNkcFJIU3Iybi9NeWw4VnpY?=
 =?utf-8?B?blQ4M3pXb21Xa0EzR29obmdzTFJjK2YrWGZPTVIwT1hyVERsS0U2TFVRcC9F?=
 =?utf-8?B?b3pveGxYTEtlRU5IY1c5bENtVVBiUUxkb1ZvY3g3QUltU3RPa2pzVkNvL1ox?=
 =?utf-8?B?bG9JRzExOTN6K0lqVEFUNnNtMEdNSjdwYUo3YlNNSno0eE9XZm5KVmhhL3hQ?=
 =?utf-8?B?YzBORVV3RXAwdW1qMll0c2xhSUxtWXBESlNVbmFrUEdEbFE2UytjL2c5QVVp?=
 =?utf-8?B?NWJoTWYrNHpyYXJDanJ6SWowUEJCNytNRndBWUxGY1NQWGVzNmorVUxIUmlF?=
 =?utf-8?B?bEpNMTg3UzdPM3JrSWFwYjQ3cUxacXBBdFplemNwZnNDTmZmZllTQmVZRUtz?=
 =?utf-8?B?MmNjbCt1VWxnaTRrbFFBdzlkQ1pSbnlpTDVINURmczBZUkFpeDMxeWZyeCtJ?=
 =?utf-8?B?UDgxTzZ4VlVLcFNHS1l1NUhzTVpxcC9KbzZad2tHT1NiNktrSzI1MXhtay9P?=
 =?utf-8?B?RGoyQUVnRzA2VkNyclJjWUplTnV5TDYwVHVqTk84TnRvZjE4SXhFYnpEbWVm?=
 =?utf-8?B?MktaYjk4OXo5ODJyWVB1Q1kxWDJMRWRzWUc5RWJtejZ0djVyck1sQ1lxcXht?=
 =?utf-8?B?RGJuaUtPQmZsMXFtaFluYVNCbnlHTUU4R2pSK0M1dlplUlBLSk95TWdib3Zj?=
 =?utf-8?B?Z1BRTGJrS0l3N1BKaUNYSVFjczdkenlyU01xMzRMaHdGMlpDWFJCU3JxRHl0?=
 =?utf-8?B?RGdpS1lIK3Q3OHFrMTZ3RmFBdHFQN3VjU3dCbUUvS2NISjVpWUYxZGJzcVhG?=
 =?utf-8?B?Ny9aL3dUbVQ5SCtMclFYeFMvaGZxS2ltdk04NWFzNnNWRHh2cHFDMVBtL2hw?=
 =?utf-8?B?bjdVUEhwWE1KOVJmOGEwdGxUV2dvd29QYmVBZVBYczBUWkN1QjJFQWZnSG0x?=
 =?utf-8?B?c25tZkE5Qkk0bGpOblF4UmE4QnJPc21SOXlEelcrd3pFTXFHRXg4UUtld2xU?=
 =?utf-8?B?eGFQSnZQWkl4WUlqQzhPVFc0SWFRV1dTMnphMy9NQlBselVjNm54aXZ0dzFE?=
 =?utf-8?B?bDkyWVBJZkIxMXg2Nkdudk5CdHlmZkJ5cCtGRlE1S1lNMHhZeXBHUjRVRlJM?=
 =?utf-8?B?WFVRYXFwWnpxeGtaUDlLZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4908CABBE349904481BA779577E45C1C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3de97852-3a0a-4c51-14cb-08d90ffe6fdb
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2021 19:46:12.1704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pw3akE6GBB3V9DEmaQMUM1iPoS1E6LHhyBvc+cLjqDZdOI+KuW0gaiuso38bqFTVYuz2lOciExXaFek4Njh84BDNqAIzGLOtcYTbwZlnTZk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3325
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIxLTA1LTA1IGF0IDEzOjU2ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gV2VkLCBNYXkgMDUsIDIwMjEgYXQgMDE6MDg6MzVQTSArMDIwMCwgVmxhc3RpbWlsIEJh
YmthIHdyb3RlOg0KPiA+IE9uIDUvNS8yMSAyOjMwIEFNLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gDQo+ID4gPiBXaHkgdXNlIFBLUyBmb3IgdGhpcz8NCj4gPiA+ID09PT09PT09PT09PT09PT09
PT09PQ0KPiA+ID4gUEtTIGlzIGFuIHVwY29taW5nIENQVSBmZWF0dXJlIHRoYXQgYWxsb3dzIHN1
cGVydmlzb3IgdmlydHVhbA0KPiA+ID4gbWVtb3J5IA0KPiA+ID4gcGVybWlzc2lvbnMgdG8gYmUg
Y2hhbmdlZCB3aXRob3V0IGZsdXNoaW5nIHRoZSBUTEIsIGxpa2UgUEtVIGRvZXMNCj4gPiA+IGZv
ciB1c2VyIA0KPiA+ID4gbWVtb3J5LiBQcm90ZWN0aW5nIHBhZ2UgdGFibGVzIHdvdWxkIG5vcm1h
bGx5IGJlIHJlYWxseSBleHBlbnNpdmUNCj4gPiA+IGJlY2F1c2UgeW91IA0KPiA+ID4gd291bGQg
aGF2ZSB0byBkbyBpdCB3aXRoIHBhZ2luZyBpdHNlbGYuIFBLUyBoZWxwcyBieSBwcm92aWRpbmcg
YQ0KPiA+ID4gd2F5IHRvIHRvZ2dsZSANCj4gPiA+IHRoZSB3cml0YWJpbGl0eSBvZiB0aGUgcGFn
ZSB0YWJsZXMgd2l0aCBqdXN0IGEgcGVyLWNwdSBNU1IuDQo+ID4gDQo+ID4gSSBjYW4gc2VlIGlu
IHBhdGNoIDgvOSB0aGF0IHlvdSBhcmUgZmxpcHBpbmcgdGhlIE1TUiBhcm91bmQNCj4gPiBpbmRp
dmlkdWFsDQo+ID4gb3BlcmF0aW9ucyBvbiBwYWdlIHRhYmxlIGVudHJpZXMuIEluIG15IHBhdGNo
IEkgaG9va2VkIG1ha2luZyB0aGUNCj4gPiBwYWdlIHRhYmxlDQo+ID4gd3JpdGFibGUgdG8gb2J0
YWluaW5nIHRoZSBwYWdlIHRhYmxlIGxvY2sgKElJUkMgSSBoYWQgb25seSB0aGUgUFRFDQo+ID4g
bGV2ZWwgZnVsbHkNCj4gPiBoYW5kbGVkIHRob3VnaCkuIFdvbmRlciBpZiB0aGF0IHdvdWxkIGJl
IGJldHRlciB0cmFkZW9mZiBldmVuIGZvcg0KPiA+IHlvdXIgTVNSIGFwcHJvYWNoPw0KPiANCkht
bSwgSSBzZWUsIHRoYXQgY291bGQgcmVkdWNlIHRoZSBzcHJpbmtsaW5nIG9mIHRoZSBlbmFibGUv
ZGlzYWJsZQ0KY2FsbHMuIEl0IHNlZW1zIHNvbWUobW9zdD8pIG9mIHRoZSBrZXJuZWwgYWRkcmVz
cyBzcGFjZSBwYWdlIHRhYmxlDQptb2RpZmljYXRpb24gZG9uJ3QgdGFrZSB0aGUgcGFnZSB0YWJs
ZSBsb2NrcyB0aG91Z2ggc28gdGhvc2UgY2FsbGVycw0Kd291bGQgaGF2ZSB0byBjYWxsIHNvbWV0
aGluZyBlbHNlIHRvIGJlIGFibGUgdG8gd3JpdGUuDQoNCj4gVGhlcmUncyBhbHNvIHRoZSBISUdI
UFRFIGNvZGUgd2UgY291bGQgYWJ1c2UgdG8ga21hcCBhbiBhbGlhcyB3aGlsZQ0KPiB3ZSdyZSBh
dCBpdC4NCg0KRm9yIGEgbm9uLVBLUyBkZWJ1ZyBmZWF0dXJlPw0KDQpJdCBtaWdodCBmaXQgcHJl
dHR5IGVhc2lseSBpbnRvIENPTkZJR19ERUJVR19QQUdFQUxMT0Mgb24gdG9wIG9mIHRoaXMNCnNl
cmllcy4gZW5hYmxlL2Rpc2FibGVfcGd0YWJsZV93cml0ZSgpIGNvdWxkIHRha2UgYSBwb2ludGVy
IHRoYXQgaXMNCmlnbm9yZWQgaW4gUEtTIG1vZGUsIGJ1dCB0cmlnZ2VycyBhIGNwYSBjYWxsIGlu
IGENCkNPTkZJR19ERUJVR19QQUdFVEFCTEVfV1JJVEUgbW9kZS4NCg==
