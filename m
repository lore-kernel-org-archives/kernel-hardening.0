Return-Path: <SRS0=gvPu=AT=lists.openwall.com=kernel-hardening-return-19254-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A155C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jul 2020 09:39:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F36FE206C3
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jul 2020 09:39:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F36FE206C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19254-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25793 invoked by uid 550); 8 Jul 2020 09:39:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22398 invoked from network); 7 Jul 2020 23:16:28 -0000
IronPort-SDR: 7kyrnjNT40COcWwxeV/HL4VSPOVr61/nEdzYr/LDpBdF5B0aSm76Nta9vIRIWKzTeWYRHUkPEg
 thkktp3SSN8g==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="145210812"
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="145210812"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: ijLCuaWKCRsIjWYnojOSUVQo9G3uGaETGna7yLAjc7XSk3ypwOFZs8gxavYIjgHddZRp6JegKf
 ipz+yeg+2V3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="315678575"
From: "Luck, Tony" <tony.luck@intel.com>
To: Kristen Carlson Accardi <kristen@linux.intel.com>, Kees Cook
	<keescook@chromium.org>, Jann Horn <jannh@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@linux.intel.com>, the
 arch/x86 maintainers <x86@kernel.org>, kernel list
	<linux-kernel@vger.kernel.org>, Kernel Hardening
	<kernel-hardening@lists.openwall.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>
Subject: RE: [PATCH v3 09/10] kallsyms: Hide layout
Thread-Topic: [PATCH v3 09/10] kallsyms: Hide layout
Thread-Index: AQHWSYM11GEyu/9l+ketSGcChG8StajoBLUAgABS94CAFO8JgP//jrPw
Date: Tue, 7 Jul 2020 23:16:14 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F7F68AC3B@ORSMSX115.amr.corp.intel.com>
References: <20200623172327.5701-1-kristen@linux.intel.com>
	 <20200623172327.5701-10-kristen@linux.intel.com>
	 <CAG48ez3YHoPOTZvabsNUcr=GP-rX+OXhNT54KcZT9eSQ28Fb8Q@mail.gmail.com>
	 <202006240815.45AAD55@keescook>
 <f34eb868e609a1a8a7f19b77fe5d00bf3555bb00.camel@linux.intel.com>
In-Reply-To: <f34eb868e609a1a8a7f19b77fe5d00bf3555bb00.camel@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0

PiBTaWduZWQtb2ZmLWJ5OiBLcmlzdGVuIENhcmxzb24gQWNjYXJkaSA8a3Jpc3RlbkBsaW51eC5p
bnRlbC5jb20+DQo+IFJldmlld2VkLWJ5OiBUb255IEx1Y2sgPHRvbnkubHVja0BpbnRlbC5jb20+
DQo+IFRlc3RlZC1ieTogVG9ueSBMdWNrIDx0b255Lmx1Y2tAaW50ZWwuY29tPg0KDQpJJ2xsIGhh
cHBpbHkgcmV2aWV3IGFuZCB0ZXN0IGFnYWluIC4uLiBidXQgc2luY2UgeW91J3ZlIG1hZGUgc3Vi
c3RhbnRpdmUNCmNoYW5nZXMsIHlvdSBzaG91bGQgZHJvcCB0aGVzZSB0YWdzIHVudGlsIEkgZG8u
DQoNCkZXSVcgSSB0aGluayByYW5kb20gb3JkZXIgaXMgYSBnb29kIGlkZWEuICBEbyB5b3Ugc2h1
ZmZsZSBvbmNlPw0KT3IgZXZlcnkgdGltZSBzb21lYm9keSBvcGVucyAvcHJvYy9rYWxsc3ltcz8N
Cg0KLVRvbnkNCg==
