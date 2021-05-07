Return-Path: <SRS0=S0bN=KC=lists.openwall.com=kernel-hardening-return-21257-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D776C433B4
	for <kernel-hardening@archiver.kernel.org>; Fri,  7 May 2021 16:27:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 537766144F
	for <kernel-hardening@archiver.kernel.org>; Fri,  7 May 2021 16:27:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 537766144F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21257-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5980 invoked by uid 550); 7 May 2021 16:27:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5931 invoked from network); 7 May 2021 16:27:44 -0000
IronPort-SDR: JbfYuhgR7+4NsHdLI5ZCWSij/K9obxOGuk6qO5SBzW0gbDNhSWGJ4jhPlluztfKnTgfCco4yL+
 T3rQpP7+Q1Qg==
X-IronPort-AV: E=McAfee;i="6200,9189,9977"; a="260037549"
X-IronPort-AV: E=Sophos;i="5.82,281,1613462400"; 
   d="scan'208";a="260037549"
IronPort-SDR: Ri6BuNk9XhAE0cNck5O6Hcv3R6Zsq6jX4qeg3VBjpoF05y6OZDAo2MQHFET/bXC8UuNm7f5JNO
 6OY44v1I6iHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,281,1613462400"; 
   d="scan'208";a="453148188"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=btq/s7KfvIRUW8bdg0HE4O/3z1GvTRG0JUrap9eGe5HfM0yfHzcXNrMk2pYO63AdiUyM2lQ3SC3Wi1kGVRy5dL3m7mF0Jf6Wif+eU5k0UtxxFlZeDop06SvCAiwywqCRv2NoD5t6iNPsL6hwUn2nrIz5G6WOLX5HQu5wkFQf2ixgsb2IpQDEy0l8Tvj0H1Que8UjYz8T1d5BQLg+5NXfSFsnnaduI0dByrTMQk7b1xYF7ql/TdduoMO+tccBIseKV08eRhFybaahw6pFlr52fJKyEZ3oFJC2sv45OPN4GZQ7ACw3zAM4uQBp4E5QCcs9vyP7zoJVTD5yNaEXsFLfNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TaG8Xt34/b7FoBySChbBMNJ1b4kD6K8ZxxfeQCSs7Yk=;
 b=nntVMaXo7lVloG+ZYY/btRZyMW1P8TeDNHhB8knA4f2NI7CR4o7pQR4hsH2DvICkDwQlA0kz8+n0YCIJ6lVJRF9gN3YxphECCoWxLxYZvddnJ9xWWYC8+zyZwJpdt/NpMIUi2fxzyNJjUe+RPBZPTRhKRMCwnk3zGeys7vC2UAiN3QijmGiG8PrsmwElc39csUCQ3j78lD70K3Xf1C4UC/ytiKS1r08Yrntaf2kKPZDcTuo7Si5jSBuHOMxjZsfNOtar7kF70STFC4EYOAArsQQbXbwLyKIIz7ESsnOGJKQiEwE7UGukvz4/X/vjDucBmlQ3ibqvUqaVc33aqBkd+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TaG8Xt34/b7FoBySChbBMNJ1b4kD6K8ZxxfeQCSs7Yk=;
 b=ecXkFyEY05v8Eiqu+bJqtTJfKakZBjWbzzLqOn+AYt0/kYxYA9pJELnxgCOll/JwlSF0HpS4E4VRHBFm6V1hJIw15Kq56jy+9hKoKTjQgyD54RDYdAUMCAcO+I4axZ53a0TFyH/sHfwymvVKb5RZA6HkxxSM9dbTqAdSU1WCO3o=
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "shakeelb@google.com" <shakeelb@google.com>
CC: "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>, "luto@kernel.org" <luto@kernel.org>,
	"Hansen, Dave" <dave.hansen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, "Weiny,
 Ira" <ira.weiny@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH RFC 5/9] x86, mm: Use cache of page tables
Thread-Topic: [PATCH RFC 5/9] x86, mm: Use cache of page tables
Thread-Index: AQHXQUYjun+WzMbt+kG/lp6eVw61HKrWx4EAgAFxrQA=
Date: Fri, 7 May 2021 16:27:27 +0000
Message-ID: <588d4b82a6cb47383e73e5d375b2b1766b4d3511.camel@intel.com>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
	 <20210505003032.489164-6-rick.p.edgecombe@intel.com>
	 <CALvZod7ieLEObX0y-7X+_zMwaVN5o0P-ZwZVLqCAK5ytQrNs9w@mail.gmail.com>
In-Reply-To: <CALvZod7ieLEObX0y-7X+_zMwaVN5o0P-ZwZVLqCAK5ytQrNs9w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.38.4 (3.38.4-1.fc33) 
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.139.86]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dda41096-0a63-4da0-9234-08d9117500ca
x-ms-traffictypediagnostic: SN6PR11MB2672:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2672EC7D4BEA691C6BAD4627C9579@SN6PR11MB2672.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6xMF/+9oldho/I0JEd7yMHso+0YvkDsG/A0rdPyTtwvYL4a3NYiG22HA49dCes1eTHne7IyZ3Raf2bijALvL9dsZXWVBaKaNfTAnNaQKKnWFm+EdvxZLQ8+GUYpMzSlF36GXIPQwqjsMUykqIgSIjcuROQQem+MnVH9nFmQkSRsJ/NWLyDdxmIIRoqBg+JyKwAWbjy7UStlhtnKupJrcKbifsEa+1ofpzndJoPrq4ekPkhoHu93KRyJGiie9tEtLg8wQQt0TodO0PxPCvu9iE1sd9K+zXfLE16835hYToSvdLn0TncFKDi9OjuWxIvJkm9tBrL/UwyE0OD4zMkjuMZoeavueweKXGCtCyty5nMSnfr3E0KlkKrjrNcxBAV8MZNhc0vTOM7qI7RpCXI9DkOFcddRYXjMPzH5X+sSHJKIk6SBNZfLwJ5NFdMe0e1aFcvJ911weEnknIVDomKazlnp2syvCe5YB8Waa0m0kzNLJTi+yIktXu03NffKp90Ng8CEKtpFYVmCoJQ+lCns022bi4Es01Qo6rYve5n87wZ2VNxttIrWD/4LHnhhZ96su/T9t5kMyS+OueIZnEZ6mA3JJpLnuq1rPsVLq5idR5DQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(346002)(39860400002)(396003)(376002)(6916009)(2616005)(66476007)(86362001)(4326008)(316002)(36756003)(53546011)(7416002)(6486002)(6506007)(54906003)(66446008)(64756008)(83380400001)(8936002)(91956017)(66946007)(76116006)(66556008)(5660300002)(2906002)(186003)(478600001)(71200400001)(4744005)(6512007)(8676002)(38100700002)(122000001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?SnRHcmhsVTlzNzMvNDJpaVhTTTgrVmVQcWJPbkxpT21WQnArd0Q2WUVkVlhx?=
 =?utf-8?B?VFBtcythMmw2SDk3d2g5RStIdE15c3JIYXFwUmp0TlVuWFpKais4d1pieG43?=
 =?utf-8?B?UzBXdExxS3Z2RW9JTDUxUUdMQTRmaDZUbjl5SjVGeDEzenhPZXdENVpVSnBx?=
 =?utf-8?B?V0V2V1hyRnpHTG0zUlY4UEdCZzV5VkhkOENEM283bGhzRk5LZFllZk1DUWVa?=
 =?utf-8?B?RXVRbk1DQ2JBc24wZytOYUNBZmcwQi85UDZrSUZrR3hHQ1dpRWtwUU5nZTZK?=
 =?utf-8?B?dUVnNVhzckZtbmw0TlRLTC9VTnRUUUZMWmFtdS9NOWUzU3Q2TTQrTEtWSi85?=
 =?utf-8?B?RHRPMGpKV3NCY1J6NE13K0JnS0VXcTVpa3oyeVZFazYwR2RUN0R0Q0lCRXNi?=
 =?utf-8?B?OTBBQ0k0bno1VTliZFRNLzF3SklhbFBLbDJCSVVUZXBqMDd3Q1ZBbWpITEFn?=
 =?utf-8?B?NjY4dnZENlFSMzNGeVRiUVl3RDFud1VkajVEVEZ4c2s2bWt4VkphaHpyQy9V?=
 =?utf-8?B?L0hDZ2pWa0l1bGNjNUNneW1memVrUUZTc0FhazVVVFBLWURGN3h2ZnJJOUxx?=
 =?utf-8?B?Y3hVT0NydDR1YnpFNnIweThheWJZVmd4N25QZHJRMlUrSGtsRWRQcUVvaHlE?=
 =?utf-8?B?SWRTQk5hZ3NTQW41QTVDL2RiM2RRd3JwOXNEeHJqenRUSTFJNnJLSVJCa3NV?=
 =?utf-8?B?U1p2cjVOUTBrTlRNdHFHYTdTRktBVUFzN1J6UkFWUkxYd204ZTNhTm9YTTkv?=
 =?utf-8?B?cGdONVdacVJXYndmSzV6K1ZTNjNKSndGWTMrYVlKSmRGOVh3RWdwT2h5WnpV?=
 =?utf-8?B?M29BODhXWTFrWmhvNnA1QTNsVUZkV25tSmJ0cmVHOVBmOVpiU0E2RVhJT1Rt?=
 =?utf-8?B?ZDZFdFlTckR6cDdubVYvMENiZm96Z2Y3UFM0M3NhcnI5U004V2crWHJzK2FI?=
 =?utf-8?B?UjlMQ0lpQzZ0VG85Zlg2bVhlTW1ZMTdWeTNPQXJqa01VRFBVKy8zQ3pINm9y?=
 =?utf-8?B?Vk1ZYnlwMVRLL0NBN0RJcG80V2JnKzhXM3lwVDE2cHRvNkt0ZGVZU09URit5?=
 =?utf-8?B?VEIyamVIMzBQdXZqbHJHZjlEdHNwNHhCWGw1S3lxNzZFNE1sWHpnL1BjNXRH?=
 =?utf-8?B?dEZoVnFVUXFXVVZRUmpXbVpHSjJQdEpkYnkzY2o0VTkvMFllbVJXeWNHVGty?=
 =?utf-8?B?QlhDTlp5OXNTRUZPbTJNeEtON0hHSnpiWHdnRGJvWnczRGZ4VmhlRzRLaC9p?=
 =?utf-8?B?NkcyNllmcFZGVUN0STI0TW8wb1VpTTQxV3ZUamVrM3RtOUI2RUl3MWRtV0FO?=
 =?utf-8?B?SlBHaFB2c2Z0MEJ6UjZ4anNMblo5aUpmdVA5ZUZnS0ZoZU9Pbzg2ZUlXeTB4?=
 =?utf-8?B?VnRLSXRFTUdqT2dlOGw4cEVnRis0bE9GSFBLcDBFT3dOTktPRmp2enVJVUsw?=
 =?utf-8?B?QWVxUWNIOW15elFZNm1tNlNZdTcyTmVDSlpXc3RpZmxvaFpIaWxBcXZiWldi?=
 =?utf-8?B?Y0RRckpRUGFoUldrcHB0akF1M1pybDVBM3RwTkpwTTFQcDdhU21QQkl6TzVL?=
 =?utf-8?B?VFRUemN6ejJ5KzVaTGk3MlNjdE4xemtWalQrK2lHdzFBUDlWQ2g4VGdQeTNM?=
 =?utf-8?B?c2NrU0kwSkVuYnZNRXNEMFEwNlNZQURaeU9WK0F5UzlwNGN6Y1VDeko5djA2?=
 =?utf-8?B?QW9ISW5HODl3V1lHbWtjeTFVVEhORXc4Q2hmVStaSU5qaERjaXNYZk1yTEpj?=
 =?utf-8?Q?M6yhMNjaJIk17kh0+nYMMGDfMLJ7QVjIW5d3hKi?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7479924C4599EF47AE6D00F10FD01996@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dda41096-0a63-4da0-9234-08d9117500ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2021 16:27:27.0697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: StoVTqiu6z7mxtMxMFEyPDrC8K+Fp9IH6n/wEB0ni8ptsxzJEU+oMysQpNpYP0+TJVcCt6+WY4tSOL1q43UYU0+8VyiUPptJQ9ZpaCpnBeY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2672
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIxLTA1LTA2IGF0IDExOjI0IC0wNzAwLCBTaGFrZWVsIEJ1dHQgd3JvdGU6DQo+
IE9uIFR1ZSwgTWF5IDQsIDIwMjEgYXQgNTozNiBQTSBSaWNrIEVkZ2Vjb21iZQ0KPiA8cmljay5w
LmVkZ2Vjb21iZUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiBbLi4uXQ0KPiA+ICsjaWZkZWYg
Q09ORklHX1BLU19QR19UQUJMRVMNCj4gPiArc3RydWN0IHBhZ2UgKmFsbG9jX3RhYmxlKGdmcF90
IGdmcCkNCj4gPiArew0KPiA+ICvCoMKgwqDCoMKgwqAgc3RydWN0IHBhZ2UgKnRhYmxlOw0KPiA+
ICsNCj4gPiArwqDCoMKgwqDCoMKgIGlmICghcGtzX3BhZ2VfZW4pDQo+ID4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIGFsbG9jX3BhZ2UoZ2ZwKTsNCj4gPiArDQo+ID4gK8Kg
wqDCoMKgwqDCoCB0YWJsZSA9IGdldF9ncm91cGVkX3BhZ2UobnVtYV9ub2RlX2lkKCksICZncGNf
cGtzKTsNCj4gPiArwqDCoMKgwqDCoMKgIGlmICghdGFibGUpDQo+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgcmV0dXJuIE5VTEw7DQo+ID4gKw0KPiA+ICvCoMKgwqDCoMKgwqAgaWYg
KGdmcCAmIF9fR0ZQX1pFUk8pDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbWVt
c2V0KHBhZ2VfYWRkcmVzcyh0YWJsZSksIDAsIFBBR0VfU0laRSk7DQo+ID4gKw0KPiA+ICvCoMKg
wqDCoMKgwqAgaWYgKG1lbWNnX2ttZW1fZW5hYmxlZCgpICYmDQo+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgIGdmcCAmIF9fR0ZQX0FDQ09VTlQgJiYNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqAg
IV9fbWVtY2dfa21lbV9jaGFyZ2VfcGFnZSh0YWJsZSwgZ2ZwLCAwKSkgew0KPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGZyZWVfdGFibGUodGFibGUpOw0KPiA+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHRhYmxlID0gTlVMTDsNCj4gPiArwqDCoMKgwqDCoMKgIH0NCj4g
PiArDQo+ID4gK8KgwqDCoMKgwqDCoCBWTV9CVUdfT05fUEFHRSgqKHVuc2lnbmVkIGxvbmcgKikm
dGFibGUtPnB0bCwgdGFibGUpOw0KPiANCj4gdGFibGUgY2FuIGJlIE5VTEwgZHVlIHRvIGNoYXJn
ZSBmYWlsdXJlLg0KDQpBcmdoLCB5ZXMuIFRoYW5rIHlvdS4gSSdsbCByZW1vdmUgdGhlIFZNX0JV
R19PTiwgaXQgd2FzIGxlZnQNCmFjY2lkZW50YWxseS4NCg==
