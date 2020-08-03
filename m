Return-Path: <SRS0=s+gq=BN=lists.openwall.com=kernel-hardening-return-19537-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 280CFC433DF
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Aug 2020 16:58:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 82E1720722
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Aug 2020 16:58:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82E1720722
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19537-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18102 invoked by uid 550); 3 Aug 2020 16:58:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18064 invoked from network); 3 Aug 2020 16:58:01 -0000
X-MC-Unique: AfxWu5hnN66AhufCIfqZ2Q-1
From: David Laight <David.Laight@ACULAB.COM>
To: "'Madhavan T. Venkataraman'" <madvenka@linux.microsoft.com>, "'Mark
 Rutland'" <mark.rutland@arm.com>
CC: Andy Lutomirski <luto@kernel.org>, Kernel Hardening
	<kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Linux FS Devel
	<linux-fsdevel@vger.kernel.org>, linux-integrity
	<linux-integrity@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "LSM
 List" <linux-security-module@vger.kernel.org>, Oleg Nesterov
	<oleg@redhat.com>, X86 ML <x86@kernel.org>
Subject: RE: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Thread-Topic: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Thread-Index: AQHWZ2jYT+e4gDrzGEmP/30MMvDTCqkmD9qggABvyICAAB4gEA==
Date: Mon, 3 Aug 2020 16:57:47 +0000
Message-ID: <f87f84e466a041fbabd2bba84f4592a5@AcuMS.aculab.com>
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
 <6540b4b7-3f70-adbf-c922-43886599713a@linux.microsoft.com>
 <CALCETrWnNR5v3ZCLfBVQGYK8M0jAvQMaAc9uuO05kfZuh-4d6w@mail.gmail.com>
 <46a1adef-65f0-bd5e-0b17-54856fb7e7ee@linux.microsoft.com>
 <20200731183146.GD67415@C02TD0UTHF1T.local>
 <a3068e3126a942c7a3e7ac115499deb1@AcuMS.aculab.com>
 <7fdc102e-75ea-6d91-d2a3-7fe8c91802ce@linux.microsoft.com>
In-Reply-To: <7fdc102e-75ea-6d91-d2a3-7fe8c91802ce@linux.microsoft.com>
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

RnJvbTogTWFkaGF2YW4gVC4gVmVua2F0YXJhbWFuDQo+IFNlbnQ6IDAzIEF1Z3VzdCAyMDIwIDE3
OjAzDQo+IA0KPiBPbiA4LzMvMjAgMzoyNyBBTSwgRGF2aWQgTGFpZ2h0IHdyb3RlOg0KPiA+IEZy
b206IE1hcmsgUnV0bGFuZA0KPiA+PiBTZW50OiAzMSBKdWx5IDIwMjAgMTk6MzINCj4gPiAuLi4N
Cj4gPj4+IEl0IHJlcXVpcmVzIFBDLXJlbGF0aXZlIGRhdGEgcmVmZXJlbmNlcy4gSSBoYXZlIG5v
dCB3b3JrZWQgb24gYWxsIGFyY2hpdGVjdHVyZXMuDQo+ID4+PiBTbywgSSBuZWVkIHRvIHN0dWR5
IHRoaXMuIEJ1dCBkbyBhbGwgSVNBcyBzdXBwb3J0IFBDLXJlbGF0aXZlIGRhdGEgcmVmZXJlbmNl
cz8NCj4gPj4gTm90IGFsbCBkbywgYnV0IHByZXR0eSBtdWNoIGFueSByZWNlbnQgSVNBIHdpbGwg
YXMgaXQncyBhIHByYWN0aWNhbA0KPiA+PiBuZWNlc3NpdHkgZm9yIGZhc3QgcG9zaXRpb24taW5k
ZXBlbmRlbnQgY29kZS4NCj4gPiBpMzg2IGhhcyBuZWl0aGVyIFBDLXJlbGF0aXZlIGFkZHJlc3Np
bmcgbm9yIG1vdmVzIGZyb20gJXBjLg0KPiA+IFRoZSBjcHUgYXJjaGl0ZWN0dXJlIGtub3dzIHRo
YXQgdGhlIHNlcXVlbmNlOg0KPiA+IAljYWxsCTFmDQo+ID4gMToJcG9wCSVyZWcNCj4gPiBpcyB1
c2VkIHRvIGdldCB0aGUgJXBjIHZhbHVlIHNvIGlzIHRyZWF0ZWQgc3BlY2lhbGx5IHNvIHRoYXQN
Cj4gPiBpdCBkb2Vzbid0ICd0cmFzaCcgdGhlIHJldHVybiBzdGFjay4NCj4gPg0KPiA+IFNvIFBJ
QyBjb2RlIGlzbid0IHRvbyBiYWQsIGJ1dCB5b3UgaGF2ZSB0byB1c2UgdGhlIGNvcnJlY3QNCj4g
PiBzZXF1ZW5jZS4NCj4gDQo+IElzIHRoYXQgdHJ1ZSBvbmx5IGZvciAzMi1iaXQgc3lzdGVtcyBv
bmx5PyBJIHRob3VnaHQgUklQLXJlbGF0aXZlIGFkZHJlc3Npbmcgd2FzDQo+IGludHJvZHVjZWQg
aW4gNjQtYml0IG1vZGUuIFBsZWFzZSBjb25maXJtLg0KDQpJIHNhaWQgaTM4NiBub3QgYW1kNjQg
b3IgeDg2LTY0Lg0KDQpTbyB5ZXMsIDY0Yml0IGNvZGUgaGFzIFBDLXJlbGF0aXZlIGFkZHJlc3Np
bmcuDQpCdXQgSSdtIHByZXR0eSBzdXJlIGl0IGhhcyBubyBvdGhlciB3YXkgdG8gZ2V0IHRoZSBQ
QyBpdHNlbGYNCmV4Y2VwdCB1c2luZyBjYWxsIC0gY2VydGFpbmx5IG5vdGhpbmcgaW4gdGhlICd1
c3VhbCcgaW5zdHJ1Y3Rpb25zLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExh
a2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQs
IFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

