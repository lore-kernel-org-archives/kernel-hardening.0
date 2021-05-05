Return-Path: <SRS0=fGe+=KA=lists.openwall.com=kernel-hardening-return-21250-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A90FCC433ED
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 21:54:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A2556613D6
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 21:54:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2556613D6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21250-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25880 invoked by uid 550); 5 May 2021 21:54:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25845 invoked from network); 5 May 2021 21:54:41 -0000
IronPort-SDR: UxcUcn567e8kohN3wiGmlHD7OiptKpflzq7+mhr/3CryZZP/B+fvWk+K2LZP6gOUK+5sy7pPa6
 p56uND16LJHQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="197950855"
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="197950855"
IronPort-SDR: aiTSdIX6JAT/NoiNKc23Pw/MFWzDue2xMpJUw/qaKM0dhlaw4qPhucJCPcMyhkQUAa9a7epzb0
 yJCPI8p0MmiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="469157523"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBmd6asthwSK34khRy340sT6dX1wcsa8W/oAHDQUDgKZ9fhwCqM+GG6MGDntug3SxetPfkpQm9ak8pixWmeVWDs8GoTgOFyN64CpZKAg8XDrPhtTCEM+dqvVNZl61MXF0HE3Vkn5aSXzsxcVHfSuxt1J3rL0ESPmSvC15iaDM0UspeFYFdfcsEr6YyTKFZ/7JE5mPhw8eEnyYRI8Fkrnyq2f3vYRKvHjBnC7lKgCrH/Rmly0Q+eLQ1SCHakKka++MjmPnPbxcrrNm+x+28Jtvv726Gz1zCx/012JhlY6WOBnb2Bgo/iGO3GVqOZnlNjQzWHrrdCOXgVhTRevtF5MLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=njZ/Hn1WX2TO8/0jUsKkSFYrCWO1QB7m3lVEqU7IfM4=;
 b=JdSGh52j6jeSjpxeO8LCrAyqEp4pjCQv/pocZSxQBrfshA1WEWLK3HApPeW8+JtYPXgUW3duzsJZm6D09P5xujDrGcEWgY0oREpUo4JQDc8N7YOTJvdXRPx7nltp3fHMpRhOCkPnfypJJO7VDeC+EpbrEKGHWj0j2cm6v0xWaOsj4twylKpCvouCE+CBZCzt/TVgsYlhrDXPqMYbIFVsMlOAIsBBz3XzyKDatdyQAR/+in4ez7A5N547BnGNaZtsGyGQwCEdhAf7AYiEz+m7yJSIY1/uVz/Eq546zGnI1xlLATTcDT1hSdGSeoiUk8VapAagfAOysY/ihsp0h/XHBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=njZ/Hn1WX2TO8/0jUsKkSFYrCWO1QB7m3lVEqU7IfM4=;
 b=WinJAIX7TxVmF7iyhpkQYy/vSTGMVNpzG3rqvn3Xi2z7dOJKXh0Ob/NwFLpSNBnVxY384XfV7b/6sBzYU03moGsNpMJFVPUtB5WbFxFdKdq+fO3+pIPb695oZ7G6AtH2zMOY4xUrQO6O8K43T5FL5LEH6CAlXlvzMSMO9iI7Ubg=
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
Subject: Re: [PATCH RFC 5/9] x86, mm: Use cache of page tables
Thread-Topic: [PATCH RFC 5/9] x86, mm: Use cache of page tables
Thread-Index: AQHXQUYjun+WzMbt+kG/lp6eVw61HKrUlUCAgAA3G4CAABOZAIAAj+sA
Date: Wed, 5 May 2021 21:54:25 +0000
Message-ID: <588ab9ec4751e060068c1af213e5a170f7d4284e.camel@intel.com>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
	 <20210505003032.489164-6-rick.p.edgecombe@intel.com>
	 <YJJcqyrMEJipbevT@hirez.programming.kicks-ass.net>
	 <YJKK5RUMOzv488DO@kernel.org>
	 <YJKbVueq3nqXwnip@hirez.programming.kicks-ass.net>
In-Reply-To: <YJKbVueq3nqXwnip@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.38.4 (3.38.4-1.fc33) 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.137.85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af440eb9-2cda-488f-5cb5-08d910105945
x-ms-traffictypediagnostic: SA2PR11MB5178:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB51787CC8606CAA90CC82CE0EC9599@SA2PR11MB5178.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HX5B3Jyc4kC0+Ru2AJNYEFirad4CExddhrkkQX57e0ZypwvQ2PzAGo7rf3gWH0NCSbOZynxuAlQBjqjdfnC1q+butRaC+yco3XVsYjApQhZWhk7fUKa5Mne91Y1Gvqk3j/O5F/RBq2gKA+4RVyGI86Tag4yK+qPdPEjO4FPppEupBJPArwAms+8MIjcv2A7C47drYEQXlHMOjzBK9USdDxCOZYz+tIhXNOBGpZXdIt/xZE8eH/ZtNIWcp5UzR8i6bRy0B2lAsSx0+xjH6zkXDcZX+Yhg/iuW1LDhimuQNHv6qyz1A3aHgVSZpemzkfGK+FMW3Ft8uyNyTWpm7PLY15AwFz6z5d7AiIbkPHkwZKtwv4t+PGKAo5XDxZ1Ts14awg6Eliz2SqRdOeesT2eFYZQ+Ppkg7nKWU2LyYKWjwdfiY5Y1qX4CfbA2uvLtoJAwn7Gj4qKjtPihvrmaJfo7NDNC2UiBcngPwKvx/w8+LUspr2whx7uzsCj7e8mN0WioWjdsSR+KPYHCcuVnzyMxO5riJ0Dl9gUmMRdqmVMEk7mtiNNA8//f5jmTpC26QUPKGEhrs3ydG2vuSqB68JMJ3YJ7tCooikAD3nAku0+RXdw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(346002)(136003)(376002)(66556008)(5660300002)(2616005)(66476007)(122000001)(38100700002)(6512007)(6506007)(2906002)(36756003)(110136005)(4326008)(8676002)(54906003)(316002)(7416002)(8936002)(86362001)(26005)(6486002)(71200400001)(76116006)(66446008)(66946007)(64756008)(91956017)(186003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?aEVMR3g2cStudEE0aURaOFlldGQ0UUZrNytNM2p3MXJqMm9SSVduN1ozWVNY?=
 =?utf-8?B?OHRFazJoYXVlbGdVSnpRV3ZXd3BHQ1RYRW5zakZtcTRVSCtMZUh3MmtHcGNJ?=
 =?utf-8?B?SFVydFhYdzg3R0xIVHBYT2k5ZTJWNGJzVFJqajNyVHBvREUvOWhGbXdUZ2w0?=
 =?utf-8?B?RGNPb2hiRldNQTlMKzZxeWtGaitjRXl3cklKZmNLOVBibzZ5d0E4bXhhWEp6?=
 =?utf-8?B?MkNiak9aWDgxRjM2UlE2cnVwSVpDbUZUWnFwWmxubEZHNFd5d3hGWDdBZVg2?=
 =?utf-8?B?dkdhb2lveEl2OHRqUlJ6YjZVNW5ERlZ6Uyt1NWZ4SjVuRHpQU25qK3FuYXd3?=
 =?utf-8?B?ZEtjKzFUR3hZVkZ2V3hhU2NlSUtUTkpYdUYxNkdmNi8rNG8vNjNVNWpuQ1Rm?=
 =?utf-8?B?ZUtJaUxOdXk0ZXI3Yk9aL3N6cythNXhnbmdUUGdNUkE1VkZ6aFlJSTFaNlp6?=
 =?utf-8?B?NktLcXVuZ2lPeXJ6WVEwVWtIamlKa3lLeEdxVjRucStRZkNwSHdxeDR4RGh3?=
 =?utf-8?B?NkxJZ3JRaXdvMUh2c21qNVFGVVJHU3M3UXhPVnNMa0c3MEV3UElUUm5mZXhh?=
 =?utf-8?B?VHRUdmtOR1ZoL21DYkRsOXhsdjhROW1LM09Id3FxR1Y5RmlvR1FFaUI2ZGN3?=
 =?utf-8?B?d3ZPMUIwdDRHUUlZRjZNM2J4SjY4NjI0TGNkekM4MkxGKzk2MDVWWUJua1Vh?=
 =?utf-8?B?czhoVzlWSDB0Sk5jS3ZDa2k4eVRhWGpTUDArOHFxZHVjR2tuVTk4OVZzeDlZ?=
 =?utf-8?B?dHhNYkc0WitIRkdMZ1VDcHNaUzlIMzI5Um9sZ2Z6K28xcGZxUURVNDJuSUVn?=
 =?utf-8?B?QzU2bURGRGxpV0NpZHFLUkN2SERpMFp2YmRiNTlKSEppOVMzN2k0amtqQXFL?=
 =?utf-8?B?VmkrTWxNaXpUQ1haV2tmSkg1Z0lRSmx0UW5XaTZ3OFdFd3plbEdRWDd4NUlW?=
 =?utf-8?B?WVg0THhFRlJaTk85M2tXQ0tsRGN1UnJqaE41cENGNjJaZ0srZXEvWVhuWkNV?=
 =?utf-8?B?OS96b0ZhNnNUeUhsYmtMQnhJUzNuVnE1R053enROcUZYSWhSVkVUYmFERlNR?=
 =?utf-8?B?NmEzM3BkL29ZRE95ZHcrSURBOG0zbHpwbEFMRjMvdzRxZEZzRUJ3OWpOQnE4?=
 =?utf-8?B?U0NDMXhUc2x3UVNCUnFXbCs5bG9ubXFhcU44OGlOT2JWWFV2ckg2UjF3U3VY?=
 =?utf-8?B?V3NXejFZRGxHc1VOUVhtYWl5RzNidXg5MU5tbmlGTENVOGoyVGMyWGRmZ2hV?=
 =?utf-8?B?V3pjUHZ1Q0cvNXJ2K2JkQ1AzSUxtbWNoUE9QQ1lsUzhiczYzSDlKTHBYMWE3?=
 =?utf-8?B?RU8zMGxrOHRVYnl6UDBkQ3BxaFNhZjd2UWwrc1lIQ0FIZUxmQStoaWM0VmJn?=
 =?utf-8?B?RXNtTVNPb1pCZjNrTUpmOVRMNzl3dFhPbGgyVFVaWm1LODRGMGJjUm9xRjNT?=
 =?utf-8?B?c3EwQjRlWERSc3JQSDVZRkVmTDM4UzVHaEVHc1pNOGcvWWRRcGJtTDRwenAw?=
 =?utf-8?B?dHBxRnZIVFFmV1JUQmhhNEhZby9DaFkxTURLNS9zZ0dGdEdVVnU4c2tRbXZN?=
 =?utf-8?B?Q3FKaFRQRFpHdnJnN3lmalpDTmtESlZLb0JPL0xhanVnRkN3NFpnMkszamZI?=
 =?utf-8?B?TllqOXk3c2hyVWJXQWhlY1M4K243K0lXM1Z5aUFOejRhUmVhNFlMNVpQay9L?=
 =?utf-8?B?NmV0OXdYUjdOMG9WL054NHo3VEcrS2tGWXozOG1yRE50eDFlcE8yY3VqQVVL?=
 =?utf-8?B?NDRxWGpIdnNLMmZaaE1MMlBSREc3a3VvcGFRM0g0SllmT2xkQ0FiZ2MzWGhX?=
 =?utf-8?B?VE1MTnloUStkWGxoQXNJQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <086E83162EF397409CF5642FA6416C7B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af440eb9-2cda-488f-5cb5-08d910105945
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2021 21:54:25.1325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vX5jlLxWFsBDRdVN03Jr+ObU1l7azPbz2h4rhN2cLIgnpfWFd6fGeRxVTyFPKYi5Dy4yUHdjqUlJb0dca6DfTczgObPiCNgpjS0rUfVl4Wk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5178
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIxLTA1LTA1IGF0IDE1OjE5ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gV2VkLCBNYXkgMDUsIDIwMjEgYXQgMDM6MDk6MDlQTSArMDMwMCwgTWlrZSBSYXBvcG9y
dCB3cm90ZToNCj4gPiBPbiBXZWQsIE1heSAwNSwgMjAyMSBhdCAxMDo1MTo1NUFNICswMjAwLCBQ
ZXRlciBaaWpsc3RyYSB3cm90ZToNCj4gPiA+IE9uIFR1ZSwgTWF5IDA0LCAyMDIxIGF0IDA1OjMw
OjI4UE0gLTA3MDAsIFJpY2sgRWRnZWNvbWJlIHdyb3RlOg0KPiA+ID4gPiBAQCAtNTQsNiArOTgs
OCBAQCB2b2lkIF9fX3B0ZV9mcmVlX3RsYihzdHJ1Y3QgbW11X2dhdGhlciAqdGxiLA0KPiA+ID4g
PiBzdHJ1Y3QgcGFnZSAqcHRlKQ0KPiA+ID4gPiDCoHsNCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDC
oHBndGFibGVfcHRlX3BhZ2VfZHRvcihwdGUpOw0KPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgcGFy
YXZpcnRfcmVsZWFzZV9wdGUocGFnZV90b19wZm4ocHRlKSk7DQo+ID4gPiA+ICvCoMKgwqDCoMKg
wqDCoC8qIFNldCBQYWdlIFRhYmxlIHNvIHN3YXAga25vd3MgaG93IHRvIGZyZWUgaXQgKi8NCj4g
PiA+ID4gK8KgwqDCoMKgwqDCoMKgX19TZXRQYWdlVGFibGUocHRlKTsNCj4gPiA+ID4gwqDCoMKg
wqDCoMKgwqDCoHBhcmF2aXJ0X3RsYl9yZW1vdmVfdGFibGUodGxiLCBwdGUpOw0KPiA+ID4gPiDC
oH0NCj4gPiA+ID4gwqANCj4gPiA+ID4gQEAgLTcwLDEyICsxMTYsMTYgQEAgdm9pZCBfX19wbWRf
ZnJlZV90bGIoc3RydWN0IG1tdV9nYXRoZXINCj4gPiA+ID4gKnRsYiwgcG1kX3QgKnBtZCkNCj4g
PiA+ID4gwqDCoMKgwqDCoMKgwqDCoHRsYi0+bmVlZF9mbHVzaF9hbGwgPSAxOw0KPiA+ID4gPiDC
oCNlbmRpZg0KPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgcGd0YWJsZV9wbWRfcGFnZV9kdG9yKHBh
Z2UpOw0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqAvKiBTZXQgUGFnZSBUYWJsZSBzbyBzd2FwIG5v
d3MgaG93IHRvIGZyZWUgaXQgKi8NCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgX19TZXRQYWdlVGFi
bGUodmlydF90b19wYWdlKHBtZCkpOw0KPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgcGFyYXZpcnRf
dGxiX3JlbW92ZV90YWJsZSh0bGIsIHBhZ2UpOw0KPiA+ID4gPiDCoH0NCj4gPiA+ID4gwqANCj4g
PiA+ID4gwqAjaWYgQ09ORklHX1BHVEFCTEVfTEVWRUxTID4gMw0KPiA+ID4gPiDCoHZvaWQgX19f
cHVkX2ZyZWVfdGxiKHN0cnVjdCBtbXVfZ2F0aGVyICp0bGIsIHB1ZF90ICpwdWQpDQo+ID4gPiA+
IMKgew0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqAvKiBTZXQgUGFnZSBUYWJsZSBzbyBzd2FwIG5v
d3MgaG93IHRvIGZyZWUgaXQgKi8NCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgX19TZXRQYWdlVGFi
bGUodmlydF90b19wYWdlKHB1ZCkpOw0KPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgcGFyYXZpcnRf
cmVsZWFzZV9wdWQoX19wYShwdWQpID4+IFBBR0VfU0hJRlQpOw0KPiA+ID4gPiDCoMKgwqDCoMKg
wqDCoMKgcGFyYXZpcnRfdGxiX3JlbW92ZV90YWJsZSh0bGIsIHZpcnRfdG9fcGFnZShwdWQpKTsN
Cj4gPiA+ID4gwqB9DQo+ID4gPiA+IEBAIC04Myw2ICsxMzMsOCBAQCB2b2lkIF9fX3B1ZF9mcmVl
X3RsYihzdHJ1Y3QgbW11X2dhdGhlciAqdGxiLA0KPiA+ID4gPiBwdWRfdCAqcHVkKQ0KPiA+ID4g
PiDCoCNpZiBDT05GSUdfUEdUQUJMRV9MRVZFTFMgPiA0DQo+ID4gPiA+IMKgdm9pZCBfX19wNGRf
ZnJlZV90bGIoc3RydWN0IG1tdV9nYXRoZXIgKnRsYiwgcDRkX3QgKnA0ZCkNCj4gPiA+ID4gwqB7
DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoC8qIFNldCBQYWdlIFRhYmxlIHNvIHN3YXAgbm93cyBo
b3cgdG8gZnJlZSBpdCAqLw0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqBfX1NldFBhZ2VUYWJsZSh2
aXJ0X3RvX3BhZ2UocDRkKSk7DQo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqBwYXJhdmlydF9yZWxl
YXNlX3A0ZChfX3BhKHA0ZCkgPj4gUEFHRV9TSElGVCk7DQo+ID4gPiA+IMKgwqDCoMKgwqDCoMKg
wqBwYXJhdmlydF90bGJfcmVtb3ZlX3RhYmxlKHRsYiwgdmlydF90b19wYWdlKHA0ZCkpOw0KPiA+
ID4gPiDCoH0NCj4gPiA+IA0KPiA+ID4gVGhpcywgdG8gbWUsIHNlZW1zIGxpa2UgYSByZWFsbHkg
d2VpcmQgcGxhY2UgdG8gX19TZXRQYWdlVGFibGUoKSwNCj4gPiA+IHdoeQ0KPiA+ID4gY2FuJ3Qg
d2UgZG8gdGhhdCBvbiBhbGxvY2F0aW9uPw0KPiA+IA0KPiA+IFdlIGNhbGwgX19DbGVhclBhZ2VU
YWJsZSgpIGF0IHBndGFibGVfcHh5X3BhZ2VfZHRvcigpLCBzbyBhdCBsZWFzdA0KPiA+IGZvciBw
dGUNCj4gPiBhbmQgcG1kIHdlIG5lZWQgdG8gc29tZWhvdyB0ZWxsIHJlbGVhc2VfcGFnZXMoKSB3
aGF0IGtpbmQgb2YgcGFnZQ0KPiA+IGl0IHdhcy4NCj4gDQo+IEh1cnBoLCByaWdodCwgYnV0IHRo
ZW4gdGhlIGFkZGVkIGNvbW1lbnQgaXMgbWlzbGVhZGluZzsNCj4gcy9TZXQvUmVzZXQvZy4NCj4g
U3RpbGwgSSdtIHRoaW5raW5nIHRoYXQgaWYgd2UgZG8gdGhlc2UgYWxsb2NhdG9ycywgbW92aW5n
IHRoZQ0KPiBzZXQvY2xlYXINCj4gdG8gdGhlIGFsbG9jYXRvciB3b3VsZCBiZSB0aGUgbW9zdCBu
YXR1cmFsIHBsYWNlLCBwZXJoYXBzIHdlIGNhbg0KPiByZW1vdmUNCj4gdGhlbSBmcm9tIHRoZSB7
YyxkfXRvci4NCg0KSG1tLCB5ZXMuIEkgZ3Vlc3MgdGhlcmUgY291bGQgYmUganVzdCB4ODYgc3Bl
Y2lmaWMgdmVyc2lvbnMgb2YgdGhlDQpjdG9yL2R0b3IgdGhhdCBkb24ndCBzZXQgdGhlIGZsYWcu
IFNlZW1zIGxpa2UgaXQgc2hvdWxkIHdvcmsgYW5kIGJlDQpsZXNzIGNvbmZ1c2luZy4gVGhhbmtz
Lg0KDQoNCg==
