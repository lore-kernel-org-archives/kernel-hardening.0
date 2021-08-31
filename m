Return-Path: <SRS0=J7G7=NW=lists.openwall.com=kernel-hardening-return-21382-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A285C432BE
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 18:49:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2CBB761178
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 18:49:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2CBB761178
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 18217 invoked by uid 550); 31 Aug 2021 18:49:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18125 invoked from network); 31 Aug 2021 18:49:02 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10093"; a="218557374"
X-IronPort-AV: E=Sophos;i="5.84,367,1620716400"; 
   d="scan'208";a="218557374"
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,367,1620716400"; 
   d="scan'208";a="498402387"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWMb+W2dsjoFOnM8p8XDNwkgWRuMsv2gHAAGYJtYfPXdfVc8RxjTmmY4TMWOYJy3pt8nw4fP7qS8w99dLAfKlb4UI1zSnS8nDhoZBE6OAz+5uqrtlye48UA90B+Eb9uV4VBqmVut0FJqbgoqOcaov37Q3qClviOTW2trQrNr+RtBBWfBKL22b/eQXg3pk2EVJ9iJ/rXFpe1kkhcu/nyw2uNU50Vl469XRmsLGywsqBFnl1WFb7RkjNw9n01mvWMWu13zETR7Z0q2DY9Pl9cZLnndQ5zfdjYD91NtrDWVQ+lgzA1ad4y+VRLt0uz0Si2TB9KAQBmZy0ktErZQVHiBBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAA9H7YGnky3z2XP67+zvaGpZlIHd0G3iRLyO/d8tVU=;
 b=cTob3tSB/xx4btYgJL1C2befnZ7m4gTaxx2UpEspbmWyVbl3M8MdQJuA3ntBfBIH0mDuksp7i/j0UVziSGnakthpQObn+vsu1wfreNt8HnYHEZvSogasnNYNGWk26yK9hnj9Zq+x3w2+9177YczZlYSNwhVPI70IR2nHKMaGrWXJs5P0EKWqjFYtNoGgo/w8Z3gn4TBeY5EFpkkVeofRczAQSxIbogYMHWSyQDNmU3hPrdyRt6SHt64SAiDn18cCXQA/5Bd1xE7FifTH5iVfMQF2xMv3LX3ajWNwrFDNmsiloQv5qwKky5mvXzJ5T21yKn8/kGSaoNhdnyufc8lpjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAA9H7YGnky3z2XP67+zvaGpZlIHd0G3iRLyO/d8tVU=;
 b=BPw08L+5rCjfVwpK0JqnGZR1m9TaFOJsBhY2dytZp7cWOUY8coBPtadK+/n6xOMsRVSOXvMrhBMfGFRW6ojufh/gejG05oFdxhZad3f3udsoYIPs8NZq5kvAq6VfWxb3X+QIOEB0ywVBeUweFurOnN+8rGS0me3/OcSomhG/Vrw=
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
Subject: Re: [RFC PATCH v2 10/19] x86/mm: Use alloc_table() for fill_pte(),
 etc
Thread-Topic: [RFC PATCH v2 10/19] x86/mm: Use alloc_table() for fill_pte(),
 etc
Thread-Index: AQHXnfswONhEAZSe+EyfBEoz/4xDw6uNTcqAgACn6IA=
Date: Tue, 31 Aug 2021 18:48:47 +0000
Message-ID: <b78bc160a361a25ac0e6ca8ca8a3dfb376a140b1.camel@intel.com>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
	 <20210830235927.6443-11-rick.p.edgecombe@intel.com>
	 <YS3stfkkCLfqROx1@kernel.org>
In-Reply-To: <YS3stfkkCLfqROx1@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e9226e3-765d-4052-92e4-08d96caff7bb
x-ms-traffictypediagnostic: SA2PR11MB5035:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB50359C725F45394E9E884FF2C9CC9@SA2PR11MB5035.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q5jrOeWTW2akjuQvm+D2zyw2Xt/4OHF3FGdbGSAMnRhJ6i8PsChVVU5Fxpk8wU8Tw7sihzjjG0vItVYqkdb1I6MJVTSS7UaH0Xb+pKgkYtdOa9Qfdeo39mn9Kf7M+mRvnipGr7nSGGCzta08Ql+g/bZavZ4+5lhJ1XmIXYvTBuGQWWM92Nv6nEZL2KldSRxZ2RvKUha/zGebw45hodzGrn/+ymSuHsLLjVEm/03Z3hCDL3YTwz1CTyO9bIjO3NF/eG2UK9gsapS/P4OKotjz6wAIa+MtdFJ/Y+izpJVR+Y3Sz2z3xI37vCmQ534Ttykgz/j18rvRi78wmtQRbAAErDFaXUehxWxHfXP7VfQ/mUjdAADNXsKE5dVtjzbGdgVMlv7Ooa4JJrXJH2CWvyfRvWJL10dSIJu+494JYWOcIEb8EQc4j+TmlxLxwLp/i+hmMjblCDI7Mtf4YXOX/DbrAEVhVjirlc49Kj80rjwIXidiwmfDPqZD2qgZmioSGknXX8N8bYZBN+VDB8TjHF7BnzNDIubWGV7gLkxXDzX1OgRIq9pp4VabrzD9uxhY6gyVCpFAvdJzRQLi1PqlwkmSjK0dVzWqCgZH2qAGMS/FvAy7EMYE1PNTzQz3FCAAN4mPkJbo3EyhQ33H41mmgRPLZsrm/FnriAVtTqXOf/Ufnyc/ZXW3Pe9xnBOnR7+971C7uzGPhkFhCjkX/Zvl3qlsqwx/NZV75YUUKdRkLWyladM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(346002)(39860400002)(136003)(6512007)(64756008)(2906002)(71200400001)(122000001)(2616005)(186003)(66946007)(4326008)(8676002)(83380400001)(6486002)(8936002)(66556008)(91956017)(478600001)(76116006)(7416002)(38100700002)(54906003)(36756003)(86362001)(38070700005)(6916009)(316002)(26005)(5660300002)(66476007)(66446008)(6506007)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bDJOeStKMDIyZ0JQY0lpQUN4QlBDeWhPSlhPeEZmZHNnMEdrNjM1VmtFK1Fw?=
 =?utf-8?B?UUY0cHRtWCtyUEVKdy9IYkt4Z285SFVac1MxcjJKR0hodlFvOXRSbXlhUldI?=
 =?utf-8?B?Ky9Hd1lzWmZrVHpiNWdWMzBKVWpEUjE5UTJlL3lWRzZxWmVmRVM5SklxUEta?=
 =?utf-8?B?bE0wUTUxZElOaHJ5OUkyYWtFN1p4eVBiRHJCd2VDRk5MdTVxUFhERTg1bldM?=
 =?utf-8?B?OWZ0WmR5SktVeHdHU0RXeGkvZmNZNEhmQ2IwZXhqT21MOVpiU3VqUTRXNlR6?=
 =?utf-8?B?S2NjYlo4RFIrT1BzQ0tmNFVrU0xjalNjMGVuV203ekM5cUphSVpjZlliVHNC?=
 =?utf-8?B?SmkwZGhVd2FtMERTamM5VUlvbGZZbDI4akt1Vkg1WEdVUkliRHRMU05OTzJM?=
 =?utf-8?B?Z21BM29WTFNsSnFKOFJtZ0JGU1lCTUZTQVBKdkcvR21IWWZPSDhtNngvQUtL?=
 =?utf-8?B?MmlkTWpsYVZ0dFRZVUZXOExqRCtiQmcxRENlT3pyUHRxS09KMGZQMmN1d0ph?=
 =?utf-8?B?S2J3S21FamNsYXdKYWJjV2xyTThuZ3NzaENFUGJ6d3RPUU5vd3IxQzRmN0ZI?=
 =?utf-8?B?cllGcFJMOUdHZnhKU1lpN1ZVRzhTL1NjSTNVWDdxRTNrSUpIVklTOFdJd3BS?=
 =?utf-8?B?cTFKQ0xoRlhTRS81ZkF0R2JTNnl6YXljQ2UyaTNCYmZiUmZOYzJ5NWREUnhP?=
 =?utf-8?B?QlFIRGMyWnJGdXpjc2w4QlNMMnBtQUxRaEVwYi9xVWFwcVlDWFF0ZUplaXZq?=
 =?utf-8?B?ZDhqV1UrZHNxSVF5Y1F4Ty9jOXU5blBuREdxYktkVGtKdjJ5a3k4Vll2Mjhm?=
 =?utf-8?B?cXhUN3RmNlEyaFJuYmlYUmZ4NkliT2xuZG5KQmZsNFVkTXFiMlJ5bVdqa2xH?=
 =?utf-8?B?bFNqZnNpMW1veEZVWWc0U3RUWW4xSVZUNEtwcjBla2FKOGYwMGo1SkRwL0wx?=
 =?utf-8?B?Ryt3ZElsNkE3MWhaUE5kZU9WblovYnN3eGtzK1NsL3BUS1RpQkZIOU41UEpB?=
 =?utf-8?B?ZEtDR2VGd2VDTzZkUmR5eHE2UmZzaHFxcEk0ZElhTHRpNUptcmVybyt6bDZC?=
 =?utf-8?B?RFBkMDMzOWl5T3VhY1QzOTJTZU5YRE1GcGxNUVhoRmNUVHZ5eHZiN0c3eWxr?=
 =?utf-8?B?NTI5aHZOcWgwZWswT09QZlZIaHp3Z1VCMU1YR2lSZ09LdVNGRURWNHNwTk1z?=
 =?utf-8?B?d3AyNlRXVkIxK2Q3RGtuOW1MdUl4bE95RGZSdEpjUWYzVnZRV3AzSHhpVFZt?=
 =?utf-8?B?aEJSR0xiTmIzR04xY1ZBTldvcm1YN2dLRmlXYVBrRzViMEpOMDdVQVJMK0lr?=
 =?utf-8?B?VjhpSUNDVStTMzA0OXcvRHlTY1M1TEg1UUszS04waXUvZ2dpN1ZSb3lERTR6?=
 =?utf-8?B?N2FhdllCenk1NFdOK1NnTGtLZmVmNUJWWUs2V3Y0b2pvUnpWYk5oL1U3MDRO?=
 =?utf-8?B?NWpPRlRHY0ZCOFpjNTdOeTJUcm1yUzR3dDU3dGZjQUdHakQ1K0NnREpJSFpJ?=
 =?utf-8?B?ZmdUZnZEdy9zSkFUSFFFSWVIY2F4MmpOeDVGOVl1Um9ValYrWWJCYms5SWJJ?=
 =?utf-8?B?d2xqaFJJTkpqZXprQy9mYy8zWUdDWTlmMDMwejJNbS9UOUZ5QkNSMDUrQ0pU?=
 =?utf-8?B?RXRRektiMkRoZnpsSEIrU3Awcm9lRXpFOExwUEJPVWFRR2lZbDFWQ3BocHJH?=
 =?utf-8?B?YjFmNXNaOTUzSTBGVG0wd1JlcGoyL1NWRlEzSTdkYlJ4bWRSTkIwWUlMdFNC?=
 =?utf-8?B?dGlkbU8wYmtDYzhMV0dtNXZUWW0vVTl4SXMzNDdKcXZBb2JGamhxaFprRkVV?=
 =?utf-8?B?Ukt1NVJuWExKZENjUHJGdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F58B8F5E3873A84586714396A4248219@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e9226e3-765d-4052-92e4-08d96caff7bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 18:48:47.9198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZazAhJO+SiaFeQRvypemhxh9D8KYGVDCRx8U6vmxNPPh8TPjSCBlTEXcu8nagqFE2K31nae2U/BrFfucXjZ35CGbGZey56b2G2OmI6QjqJM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5035
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIxLTA4LTMxIGF0IDExOjQ3ICswMzAwLCBNaWtlIFJhcG9wb3J0IHdyb3RlOg0K
PiBPbiBNb24sIEF1ZyAzMCwgMjAyMSBhdCAwNDo1OToxOFBNIC0wNzAwLCBSaWNrIEVkZ2Vjb21i
ZSB3cm90ZToNCj4gPiBmaWxsX3B0ZSgpLCBzZXRfcHRlX3ZhZGRyKCksIGV0YyBhbGxvY2F0ZSBw
YWdlIHRhYmxlcyB3aXRoDQo+ID4gc3BwX2dldHBhZ2UoKS4gVXNlIGFsbG9jX3RhYmxlKCkgZm9y
IHRoZXNlIGFsbG9jYXRpb25zIGluIG9yZGVyIHRvDQo+ID4gZ2V0DQo+ID4gdGFibGVzIGZyb20g
dGhlIGNhY2hlIG9mIHByb3RlY3RlZCBwYWdlcyB3aGVuIG5lZWRlZC4NCj4gDQo+ICANCj4gSSBj
YW4ndCBzYXkgSSB0cmFja2VkIGFsbCB0aGUgdXNlcnMgb2Ygc2V0X3B0ZV92YWRkcigpLCBidXQg
SSBkb24ndA0KPiBzZWUgYQ0KPiBmdW5kYW1lbnRhbCByZWFzb24gd2h5IHNwcF9nZXRwYWdlKCkg
d291bGQgbmVlZCBHRlBfQVRPTUlDLg0KWWVhLCBJIGNvdWxkbid0IGZpbmQgd2h5IGl0IHdhcyBk
b25lIHRoYXQgd2F5IGluIHRoZSBmaXJzdCBwbGFjZSwgYW5kDQp0aGVyZSB3ZXJlIGFsbW9zdCB0
b28gbWFueSBjYWxsZXJzIHRvIGF1ZGl0LiBJIGd1ZXNzIEkgY291bGQgcm9sbCB1cCBteQ0Kc2xl
ZXZlcyBhbiBhdWRpdCBpdCBhbGwsIGJ1dCBpdHMgbm90IGZvb2xwcm9vZi4gT3IgcHV0IGEgd2Fy
biBmb3INCmF0b21pYyBjb250ZXh0IGFuZCBwdWxsIGFsbCBvZiB0aGUgR0ZQX0FUT01JQyBjb2Rl
IGlmIGl0IGRvZXNuJ3QgZ2V0DQp0cmlnZ2VyZWQgYWZ0ZXIgYXdoaWxlLiBBbHNvIHNlZW1zIHdl
aXJkIHRoYXQgaXQganVzdCBwYW5pY3MgaGVyZSBpZg0KdGhlIGFsbG9jYXRpb24gZmFpbHMuDQoN
Cj4gIEV2ZW4gaWYgdGhlcmUNCj4gaXMgYSBjYWxsZXIgb2Ygc2V0X3B0ZV92YWRkcigpIHRoYXQg
Y2Fubm90IHNsZWVwLCBpdCBzZWVtcyB0aGF0IHBhZ2UNCj4gdGFibGVzDQo+IGNhbiBiZSBwcmVw
b3B1bGF0ZWQgc28gdGhhdCBzZXRfcHRlX3ZhZGRyKCkgd2lsbCBub3QgbmVlZCB0byBhbGxvY2F0
ZQ0KPiBhbnl0aGluZy4gIA0KSG1tLCBjb3VsZCB3b3JrIGZvciB0aGUgZml4bWFwIGNhbGxlcnMg
SSBndWVzcyAobWF5YmUgYWxyZWFkeSBoYXBwZW5pbmcNCmluIHByYWN0aWNlKS4gWGVuIGFuZCBh
IGZldyBvdGhlciB0aGluZ3Mgc2VlbXMgdG8gdXNlIHRoaXMgZm9yIG5vbi0NCmZpeG1hcCB0aGlu
Z3MsIGJ1dCBpdCdzIGR1cmluZyBpbml0IGFuZCBlYXNpZXIgdG8gYXVkaXQuDQoNCg==
