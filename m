Return-Path: <SRS0=8BYn=BO=lists.openwall.com=kernel-hardening-return-19554-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 284BEC433DF
	for <kernel-hardening@archiver.kernel.org>; Tue,  4 Aug 2020 14:45:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8E9B6206DA
	for <kernel-hardening@archiver.kernel.org>; Tue,  4 Aug 2020 14:45:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E9B6206DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19554-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30025 invoked by uid 550); 4 Aug 2020 14:45:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30005 invoked from network); 4 Aug 2020 14:45:11 -0000
X-MC-Unique: GkYdxktHPX6Hq0f1q8Z5bg-1
From: David Laight <David.Laight@ACULAB.COM>
To: David Laight <David.Laight@ACULAB.COM>, 'Mark Rutland'
	<mark.rutland@arm.com>, "Madhavan T. Venkataraman"
	<madvenka@linux.microsoft.com>
CC: Andy Lutomirski <luto@kernel.org>, Kernel Hardening
	<kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Linux FS Devel
	<linux-fsdevel@vger.kernel.org>, linux-integrity
	<linux-integrity@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "LSM
 List" <linux-security-module@vger.kernel.org>, Oleg Nesterov
	<oleg@redhat.com>, X86 ML <x86@kernel.org>
Subject: RE: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Thread-Topic: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Thread-Index: AQHWamb6T+e4gDrzGEmP/30MMvDTCqkoApyQgAADJ0A=
Date: Tue, 4 Aug 2020 14:44:55 +0000
Message-ID: <23ded6dfcf284b15a3356c01a94029f8@AcuMS.aculab.com>
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
 <6540b4b7-3f70-adbf-c922-43886599713a@linux.microsoft.com>
 <CALCETrWnNR5v3ZCLfBVQGYK8M0jAvQMaAc9uuO05kfZuh-4d6w@mail.gmail.com>
 <46a1adef-65f0-bd5e-0b17-54856fb7e7ee@linux.microsoft.com>
 <20200731183146.GD67415@C02TD0UTHF1T.local>
 <86625441-80f3-2909-2f56-e18e2b60957d@linux.microsoft.com>
 <20200804135558.GA7440@C02TD0UTHF1T.local>
 <c898918d18f34fd5b004cd1549b6a99e@AcuMS.aculab.com>
In-Reply-To: <c898918d18f34fd5b004cd1549b6a99e@AcuMS.aculab.com>
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

PiA+ID4gSWYgeW91IGxvb2sgYXQgdGhlIGxpYmZmaSByZWZlcmVuY2UgcGF0Y2ggSSBoYXZlIGlu
Y2x1ZGVkLCB0aGUgYXJjaGl0ZWN0dXJlDQo+ID4gPiBzcGVjaWZpYyBjaGFuZ2VzIHRvIHVzZSB0
cmFtcGZkIGp1c3QgaW52b2x2ZSBhIHNpbmdsZSBDIGZ1bmN0aW9uIGNhbGwgdG8NCj4gPiA+IGEg
Y29tbW9uIGNvZGUgZnVuY3Rpb24uDQo+IA0KPiBObyBpZGVhIHdoYXQgbGliZmZpIGlzLCBidXQg
aXQgbXVzdCBzdXJlbHkgYmUgc2ltcGxlciB0bw0KPiByZXdyaXRlIGl0IHRvIGF2b2lkIG5lc3Rl
ZCBmdW5jdGlvbiBkZWZpbml0aW9ucy4NCj4gDQo+IE9yIGZpbmQgYSBib29rIGZyb20gdGhlIDE5
NjBzIG9uIGhvdyB0byBkbyByZWN1cnNpdmUNCj4gY2FsbHMgYW5kIG5lc3RlZCBmdW5jdGlvbnMg
aW4gRk9SVFJBTi1JVi4NCg0KRldJVyBpdCBpcyBwcm9iYWJseSBhcyBzaW1wbGUgYXM6DQoxKSBQ
dXQgYWxsIHRoZSAndmFyaWFibGVzJyB0aGUgbmVzdGVkIGZ1bmN0aW9uIGFjY2Vzc2VzIGludG8g
YSBzdHJ1Y3QuDQoyKSBBZGQgYSBmaWVsZCBmb3IgdGhlIGFkZHJlc3Mgb2YgdGhlICduZXN0ZWQn
IGZ1bmN0aW9uLg0KMykgUGFzcyB0aGUgYWRkcmVzcyBvZiB0aGUgc3RydWN0dXJlIGRvd24gaW5z
dGVhZCBvZiB0aGUNCiAgIGFkZHJlc3Mgb2YgdGhlIGZ1bmN0aW9uLg0KDQpJZiB5b3UgYXJlbid0
IGluIGNvbnRyb2wgb2YgdGhlIGNhbGwgc2l0ZXMgdGhlbiBhZGQgdGhlDQpzdHJ1Y3R1cmUgdG8g
YSBsaW5rZWQgbGlzdCBvbiBhIHRocmVhZC1sb2NhbCB2YXJpYWJsZS4NCg0KCURhdmlkDQoNCi0N
ClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBN
aWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxl
cykNCg==

