Return-Path: <SRS0=81S5=BI=lists.openwall.com=kernel-hardening-return-19487-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D24C433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Jul 2020 08:36:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C068B20838
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Jul 2020 08:36:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C068B20838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19487-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20400 invoked by uid 550); 29 Jul 2020 08:36:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20380 invoked from network); 29 Jul 2020 08:36:48 -0000
X-MC-Unique: 2zI0R3XJNsWV7u6ffLfy4w-1
From: David Laight <David.Laight@ACULAB.COM>
To: "'Madhavan T. Venkataraman'" <madvenka@linux.microsoft.com>, "Andy
 Lutomirski" <luto@kernel.org>
CC: "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>, "linux-api@vger.kernel.org"
	<linux-api@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-integrity@vger.kernel.org"
	<linux-integrity@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>, "oleg@redhat.com" <oleg@redhat.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Thread-Topic: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Thread-Index: AQHWZOCQT+e4gDrzGEmP/30MMvDTCqkdFOrwgABBt1CAAORUsA==
Date: Wed, 29 Jul 2020 08:36:33 +0000
Message-ID: <a159f2e8417746fb88f31a97c6f366ba@AcuMS.aculab.com>
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <c23de6ec47614f489943e1a89a21dfa3@AcuMS.aculab.com>
 <f5cfd11b-04fe-9db7-9d67-7ee898636edb@linux.microsoft.com>
 <CALCETrUta5-0TLJ9-jfdehpTAp2Efmukk2npYadFzz9ozOrG2w@mail.gmail.com>
 <59246260-e535-a9f1-d89e-4e953288b977@linux.microsoft.com>
In-Reply-To: <59246260-e535-a9f1-d89e-4e953288b977@linux.microsoft.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64

RnJvbTogTWFkaGF2YW4gVC4gVmVua2F0YXJhbWFuDQo+IFNlbnQ6IDI4IEp1bHkgMjAyMCAxOTo1
Mg0KLi4uDQo+IHRyYW1wZmQgZmF1bHRzIGFyZSBpbnN0cnVjdGlvbiBmYXVsdHMgdGhhdCBnbyB0
aHJvdWdoIGEgZGlmZmVyZW50IGNvZGUgcGF0aCB0aGFuDQo+IHRoZSBvbmUgdGhhdCBjYWxscyBo
YW5kbGVfbW1fZmF1bHQoKS4gUGVyaGFwcywgaXQgaXMgdGhlIGhhbmRsZV9tbV9mYXVsdCgpIHRo
YXQNCj4gaXMgdGltZSBjb25zdW1pbmcuIENvdWxkIHlvdSBjbGFyaWZ5Pw0KDQpHaXZlbiB0aGF0
IHRoZSBleHBlY3RhdGlvbiBpcyBhIGZldyBpbnN0cnVjdGlvbnMgaW4gdXNlcnNwYWNlDQooZWcg
dG8gcGljayB1cCB0aGUgb3JpZ2luYWwgYXJndW1lbnRzIGZvciBhIG5lc3RlZCBjYWxsKQ0KdGhl
IChwcm9iYWJsZSkgdGhvdXNhbmRzIG9mIGNsb2NrcyB0YWtlbiBieSBlbnRlcmluZyB0aGUNCmtl
cm5lbCAoZXNwZWNpYWxseSB3aXRoIHBhZ2UgdGFibGUgc2VwYXJhdGlvbikgaXMgYSBtYXNzaXZl
DQpkZWx0YS4NCg0KSWYgZW50ZXJpbmcgdGhlIGtlcm5lbCB3ZXJlIGNoZWFwIG5vIG9uZSB3b3Vs
ZCBoYXZlIGFkZGVkDQp0aGUgRFNPIGZ1bmN0aW9ucyBmb3IgZ2V0dGluZyB0aGUgdGltZSBvZiBk
YXkuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkg
Um9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlv
biBObzogMTM5NzM4NiAoV2FsZXMpDQo=

