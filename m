Return-Path: <SRS0=Sxyv=BJ=lists.openwall.com=kernel-hardening-return-19493-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36383C433E1
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jul 2020 13:09:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 96B7B2074B
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jul 2020 13:09:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96B7B2074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19493-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27990 invoked by uid 550); 30 Jul 2020 13:09:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27970 invoked from network); 30 Jul 2020 13:09:38 -0000
X-MC-Unique: OWiDeMRKNgyfXRUgU29ZSg-1
From: David Laight <David.Laight@ACULAB.COM>
To: 'Andy Lutomirski' <luto@kernel.org>, "madvenka@linux.microsoft.com"
	<madvenka@linux.microsoft.com>
CC: Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API
	<linux-api@vger.kernel.org>, linux-arm-kernel
	<linux-arm-kernel@lists.infradead.org>, Linux FS Devel
	<linux-fsdevel@vger.kernel.org>, linux-integrity
	<linux-integrity@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "LSM
 List" <linux-security-module@vger.kernel.org>, Oleg Nesterov
	<oleg@redhat.com>, X86 ML <x86@kernel.org>
Subject: RE: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Thread-Topic: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Thread-Index: AQHWZQT/T+e4gDrzGEmP/30MMvDTCqkgFteg
Date: Thu, 30 Jul 2020 13:09:24 +0000
Message-ID: <b9879beef3e740c0aeb1af73485069a8@AcuMS.aculab.com>
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
In-Reply-To: <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64

PiBUaGlzIGlzIHF1aXRlIGNsZXZlciwgYnV0IG5vdyBJ4oCZbSB3b25kZXJpbmcganVzdCBob3cg
bXVjaCBrZXJuZWwgaGVscA0KPiBpcyByZWFsbHkgbmVlZGVkLiBJbiB5b3VyIHNlcmllcywgdGhl
IHRyYW1wb2xpbmUgaXMgYW4gbm9uLWV4ZWN1dGFibGUNCj4gcGFnZS4gIEkgY2FuIHRoaW5rIG9m
IGF0IGxlYXN0IHR3byBhbHRlcm5hdGl2ZSBhcHByb2FjaGVzLCBhbmQgSSdkDQo+IGxpa2UgdG8g
a25vdyB0aGUgcHJvcyBhbmQgY29ucy4NCj4gDQo+IDEuIEVudGlyZWx5IHVzZXJzcGFjZTogYSBy
ZXR1cm4gdHJhbXBvbGluZSB3b3VsZCBiZSBzb21ldGhpbmcgbGlrZToNCj4gDQo+IDE6DQo+IHB1
c2hxICVyYXgNCj4gcHVzaHEgJXJiYw0KPiBwdXNocSAlcmN4DQo+IC4uLg0KPiBwdXNocSAlcjE1
DQo+IG1vdnEgJXJzcCwgJXJkaSAjIHBvaW50ZXIgdG8gc2F2ZWQgcmVncw0KPiBsZWFxIDFiKCVy
aXApLCAlcnNpICMgcG9pbnRlciB0byB0aGUgdHJhbXBvbGluZSBpdHNlbGYNCj4gY2FsbHEgdHJh
bXBvbGluZV9oYW5kbGVyICMgc2VlIGJlbG93DQoNCkZvciBuZXN0ZWQgY2FsbHMgKHdoZXJlIHRo
ZSB0cmFtcG9saW5lIG5lZWRzIHRvIHBhc3MgdGhlDQpvcmlnaW5hbCBzdGFjayBmcmFtZSB0byB0
aGUgbmVzdGVkIGZ1bmN0aW9uKSBJIHRoaW5rIHlvdQ0KanVzdCBuZWVkIGEgcGFnZSBmdWxsIG9m
Og0KCW1vdgkkMCwgc2NyYXRjaF9yZWc7IGptcCB0cmFtcG9saW5lX2hhbmRsZXINCgltb3YJJDEs
IHNjcmF0Y2hfcmVnOyBqbXAgdHJhbXBvbGluZV9oYW5kbGVyDQpZb3UgbmVlZCBhbiB1bnVzZWQg
cmVnaXN0ZXIsIG9uIHg4Ni02NCBJIHRoaW5rIGJvdGgNCnIxMCBhbmQgcjExIGFyZSBhdmFpbGFi
bGUuDQpPbiBpMzg2IEkgdGhpbmsgZWF4IGNhbiBiZSB1c2VkLg0KSXQgbWlnaHQgZXZlbiBiZSB0
aGF0IHRoZSBmaXJzdCBhcmd1bWVudCByZWdpc3RlciBpcw0KYXZhaWxhYmxlIC0gaWYgdGhhdCBp
cyB1c2VkIHRvIHBhc3MgaW4gdGhlIHN0YWNrIGZyYW1lLg0KDQpUaGUgdHJhbXBvbGluZV9oYW5k
bGVyIHRoZW4gdXNlcyB0aGUgcGFzc2VkIGluIHZhbHVlDQp0byBpbmRleCBhbiBhcnJheSBvZiBz
dGFjayBmcmFtZSBhbmQgZnVuY3Rpb24gcG9pbnRlcnMNCmFuZCBqdW1wcyB0byB0aGUgcmVhbCBm
dW5jdGlvbi4NCllvdSBuZWVkIHRvIGhvbGQgZXZlcnl0aGluZyBpbiBfX3RocmVhZCBkYXRhLg0K
QW5kIG1heWJlIGJlIGFibGUgdG8gYWxsb2NhdGUgYW4gZXh0cmEgcGFnZSBmb3IgZGVlcGx5DQpu
ZXN0ZWQgY29kZSBwYXRocyAoZWcgcmVjdXJzaXZlIG5lc3RlZCBmdW5jdGlvbnMpLg0KDQpZb3Ug
bWlnaHQgdGhlbiBuZWVkIGEgZHJpdmVyIHRvIGNyZWF0ZSB5b3UgYSBzdWl0YWJsZQ0KZXhlY3V0
YWJsZSBwYWdlLiBTb21laG93IHlvdSBuZWVkIHRvIHBhc3MgaW4gdGhlIGFkZHJlc3MNCm9mIHRo
ZSB0cmFtcG9saW5lX2hhbmRsZXIgYW5kIHRoZSBudW1iZXIgZm9yIHRoZSBmaXJzdCBmYXVsdC4N
Ckl0IG5lZWQgdG8gcGFzcyBiYWNrIHRoZSAnc3RyaWRlJyBvZiB0aGUgYXJyYXkgYW5kIG51bWJl
cg0Kb2YgZWxlbWVudHMgY3JlYXRlZC4NCg0KQnV0IGlmIHlvdSBjYW4gdGFrZSB0aGUgY29zdCBv
ZiB0aGUgcGFnZSBmYXVsdCwgdGhlbg0KeW91IGNhbiBpbnRlcnByZXQgdGhlIGV4aXN0aW5nIHRy
YW1wb2xpbmUgaW4gdXNlcnNwYWNlDQp3aXRoaW4gdGhlIHNpZ25hbCBoYW5kbGVyLg0KVGhpcyBp
cyB0d28ga2VybmVsIGVudHJ5L2V4aXRzLg0KDQpBcmJpdHJhcnkgSklUIGlzIGEgZGlmZmVyZW50
IHByb2JsZW0gZW50aXJlbHkuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFr
ZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwg
VUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

