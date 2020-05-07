Return-Path: <SRS0=oMS9=6V=lists.openwall.com=kernel-hardening-return-18733-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD794C38A2A
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 May 2020 09:00:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0EECF2075E
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 May 2020 09:00:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0EECF2075E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18733-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19717 invoked by uid 550); 7 May 2020 09:00:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19694 invoked from network); 7 May 2020 09:00:31 -0000
X-MC-Unique: 1RrrHCkENDuNPa4zd3w0jA-1
From: David Laight <David.Laight@ACULAB.COM>
To: =?utf-8?B?J01pY2thw6tsIFNhbGHDvG4n?= <mic@digikod.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>, "Al
 Viro" <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>,
	"Christian Heimes" <christian@python.org>, Daniel Borkmann
	<daniel@iogearbox.net>, "Deven Bowers" <deven.desai@linux.microsoft.com>,
	Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn
	<jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook
	<keescook@chromium.org>, "Lakshmi Ramasubramanian"
	<nramas@linux.microsoft.com>, Matthew Garrett <mjg59@google.com>, Matthew
 Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>,
	=?utf-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar
	<zohar@linux.ibm.com>, =?utf-8?B?UGhpbGlwcGUgVHLDqWJ1Y2hldA==?=
	<philippe.trebuchet@ssi.gouv.fr>, Scott Shell <scottsh@microsoft.com>, Sean
 Christopherson <sean.j.christopherson@intel.com>, Shuah Khan
	<shuah@kernel.org>, Steve Dower <steve.dower@python.org>, Steve Grubb
	<sgrubb@redhat.com>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>
Subject: RE: [PATCH v5 0/6] Add support for O_MAYEXEC
Thread-Topic: [PATCH v5 0/6] Add support for O_MAYEXEC
Thread-Index: AQHWIvJxeV/0BLZ+8kuLT1dTVkm+SqicRhNg///4h4CAABSTQA==
Date: Thu, 7 May 2020 09:00:16 +0000
Message-ID: <ad28ab5fe7854b41a575656e95b4da17@AcuMS.aculab.com>
References: <20200505153156.925111-1-mic@digikod.net>
 <20b24b9ca0a64afb9389722845738ec8@AcuMS.aculab.com>
 <907109c8-9b19-528a-726f-92c3f61c1563@digikod.net>
In-Reply-To: <907109c8-9b19-528a-726f-92c3f61c1563@digikod.net>
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

RnJvbTogTWlja2HDq2wgU2FsYcO8bg0KPiBTZW50OiAwNyBNYXkgMjAyMCAwOTozNw0KLi4uDQo+
ID4gTm9uZSBvZiB0aGF0IGRlc2NyaXB0aW9uIGFjdHVhbGx5IHNheXMgd2hhdCB0aGUgcGF0Y2gg
YWN0dWFsbHkgZG9lcy4NCj4gDQo+ICJBZGQgc3VwcG9ydCBmb3IgT19NQVlFWEVDIiAidG8gZW5h
YmxlIHRvIGNvbnRyb2wgc2NyaXB0IGV4ZWN1dGlvbiIuDQo+IFdoYXQgaXMgbm90IGNsZWFyIGhl
cmU/IFRoaXMgc2VlbXMgd2VsbCB1bmRlcnN0b29kIGJ5IG90aGVyIGNvbW1lbnRlcnMuDQo+IFRo
ZSBkb2N1bWVudGF0aW9uIHBhdGNoIGFuZCB0aGUgdGFsa3MgY2FuIGFsc28gaGVscC4NCg0KSSdt
IGd1ZXNzaW5nIHRoYXQgcGFzc2luZyBPX01BWUVYRUMgdG8gb3BlbigpIHJlcXVlc3RzIHRoZSBr
ZXJuZWwNCmNoZWNrIGZvciBleGVjdXRlICd4JyBwZXJtaXNzaW9ucyAoYXMgd2VsbCBhcyByZWFk
KS4NCg0KVGhlbiBrZXJuZWwgcG9saWN5IGRldGVybWluZXMgd2hldGhlciAncmVhZCcgYWNjZXNz
IGlzIGFjdHVhbGx5IGVub3VnaCwNCm9yIHdoZXRoZXIgJ3gnIGFjY2VzcyAocG9zc2libHkgbWFz
a2VkIGJ5IG1vdW50IHBlcm1pc3Npb25zKSBpcyBuZWVkZWQuDQoNCklmIHRoYXQgaXMgdHJ1ZSwg
dHdvIGxpbmVzIHNheSB3aGF0IGlzIGRvZXMuDQoNCkhhdmUgeW91IGV2ZXIgc2V0IGEgc2hlbGwg
c2NyaXB0IHBlcm1pc3Npb25zIHRvIC0teC0tcy0teCA/DQpFbmRzIHVwIGJlaW5nIGV4ZWN1dGFi
bGUgYnkgZXZlcnlvbmUgZXhjZXB0IHRoZSBvd25lciENCkhhdmluZyB0aGUga2VybmVsIHBhc3Mg
YWxsICcjIScgZmlsZXMgdG8gdGhlaXIgaW50ZXJwcmV0ZXJzDQp0aHJvdWdoIGFuIG9wZW4gZmQg
bWlnaHQgaGVscCBzZWN1cml0eS4NCkluIHRoYXQgY2FzZSB0aGUgdXNlciBkb2Vzbid0IG5lZWQg
cmVhZCBhY2Nlc3MgdG8gdGhlIGZpbGUNCmluIG9yZGVyIHRvIGdldCBhbiBpbnRlcnByZXRlciB0
byBwcm9jZXNzIGl0Lg0KKFlvdSdkIG5lZWQgdG8gc3RvcCBzdHJhY2Ugc2hvd2luZyB0aGUgY29u
dGVudHMgdG8gYWN0dWFsbHkNCmhpZGUgdGhlbS4pDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVk
IEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5l
cywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

