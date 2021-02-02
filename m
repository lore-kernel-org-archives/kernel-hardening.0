Return-Path: <SRS0=D7AB=HE=lists.openwall.com=kernel-hardening-return-20716-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BB1C433DB
	for <kernel-hardening@archiver.kernel.org>; Tue,  2 Feb 2021 09:24:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4C03960234
	for <kernel-hardening@archiver.kernel.org>; Tue,  2 Feb 2021 09:24:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C03960234
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20716-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13497 invoked by uid 550); 2 Feb 2021 09:24:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13465 invoked from network); 2 Feb 2021 09:24:06 -0000
X-MC-Unique: ZgGVazRuO0urN_jQBu4yZw-1
From: David Laight <David.Laight@ACULAB.COM>
To: 'Andy Lutomirski' <luto@kernel.org>, "Jason A. Donenfeld"
	<Jason@zx2c4.com>
CC: Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML
	<linux-kernel@vger.kernel.org>, Jann Horn <jann@thejh.net>, Christian Brauner
	<christian.brauner@canonical.com>
Subject: RE: forkat(int pidfd), execveat(int pidfd), other awful things?
Thread-Topic: forkat(int pidfd), execveat(int pidfd), other awful things?
Thread-Index: AQHW+MjRGTZ+ypDOi0yJVnTMuiyGI6pElfgg
Date: Tue, 2 Feb 2021 09:23:54 +0000
Message-ID: <cf07f0732eb94dbfa67c9d56ceba738e@AcuMS.aculab.com>
References: <CAHmME9oHBtR4fBBUY8E_Oi7av-=OjOGkSNhQuMJMHhafCjazBw@mail.gmail.com>
 <CALCETrVGLx5yeHo7ExAmJZmPjVjcJiV7p1JOa4iUaW5DRoEvLQ@mail.gmail.com>
In-Reply-To: <CALCETrVGLx5yeHo7ExAmJZmPjVjcJiV7p1JOa4iUaW5DRoEvLQ@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64

RnJvbTogQW5keSBMdXRvbWlyc2tpDQo+IFNlbnQ6IDAxIEZlYnJ1YXJ5IDIwMjEgMTg6MzANCi4u
Lg0KPiAyLiBBIHNhbmUgcHJvY2VzcyBjcmVhdGlvbiBBUEkuICBJdCB3b3VsZCBiZSBkZWxpZ2h0
ZnVsIHRvIGJlIGFibGUgdG8NCj4gY3JlYXRlIGEgZnVsbHktc3BlY2lmaWVkIHByb2Nlc3Mgd2l0
aG91dCBmb3JraW5nLiAgVGhpcyBtaWdodCBlbmQgdXANCj4gYmVpbmcgYSBmYWlybHkgY29tcGxp
Y2F0ZWQgcHJvamVjdCwgdGhvdWdoIC0tIHRoZXJlIGFyZSBhIGxvdCBvZg0KPiBpbmhlcml0ZWQg
cHJvY2VzcyBwcm9wZXJ0aWVzIHRvIGJlIGVudW1lcmF0ZWQuDQoNClNpbmNlIHlvdSBhcmUgZ29p
bmcgdG8gKGV2ZW50dWFsbHkpIGxvYWQgaW4gYSBwcm9ncmFtIGltYWdlDQpoYXZlIHRvIGRvIHNl
dmVyYWwgc3lzdGVtIGNhbGxzIHRvIGNyZWF0ZSB0aGUgcHJvY2VzcyBpc24ndA0KbGlrZWx5IHRv
IGJlIGEgcHJvYmxlbS4NClNvIHVzaW5nIHNlcGFyYXRlIGNhbGxzIGZvciBlYWNoIHByb3BlcnR5
IGlzbid0IHJlYWxseSBhbiBpc3N1ZQ0KYW5kIHNvbHZlcyB0aGUgaG9ycmlkIHByb2JsZW0gb2Yg
dGhlIEFQSSBzdHJ1Y3R1cmUuDQoNClNvIHlvdSBjb3VsZCBjcmVhdGUgYW4gZW1icnlvbmljIHBy
b2Nlc3MgdGhhdCBpbmhlcml0cyBhIGxvdA0Kb2Ygc3R1ZmYgZnJvbSB0aGUgY3VycmVudCBwcm9j
ZXNzLCB0aGUgZG8gYWN0aW9ucyB0aGF0DQpzb3J0IG91dCB0aGUgZmRzLCBhcmd2LCBuYW1lc3Bh
Y2UgZXRjLg0KRmluYWxseSBydW5uaW5nIHRoZSBuZXcgcHJvZ3JhbS4NCg0KSXQgd291bGQgcHJv
YmFibHkgbWFrZSBpbXBsZW1lbnQgcG9zaXhfc3Bhd24oKSBlYXNpZXIuDQoNCglEYXZpZA0KDQot
DQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwg
TWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2Fs
ZXMpDQo=

