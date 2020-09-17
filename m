Return-Path: <SRS0=zlmG=C2=lists.openwall.com=kernel-hardening-return-19910-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC56C43461
	for <kernel-hardening@archiver.kernel.org>; Thu, 17 Sep 2020 16:02:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E721422240
	for <kernel-hardening@archiver.kernel.org>; Thu, 17 Sep 2020 16:01:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E721422240
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=deneb.enyo.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19910-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11416 invoked by uid 550); 17 Sep 2020 16:01:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11396 invoked from network); 17 Sep 2020 16:01:52 -0000
From: Florian Weimer <fw@deneb.enyo.de>
To: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc: kernel-hardening@lists.openwall.com,  linux-api@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,  linux-fsdevel@vger.kernel.org,  linux-integrity@vger.kernel.org,  linux-kernel@vger.kernel.org,  linux-security-module@vger.kernel.org,  oleg@redhat.com,  x86@kernel.org,  libffi-discuss@sourceware.org
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
References: <20200916150826.5990-1-madvenka@linux.microsoft.com>
	<87v9gdz01h.fsf@mid.deneb.enyo.de>
	<96ea02df-4154-5888-1669-f3beeed60b33@linux.microsoft.com>
	<d96b87ed-9869-c732-9938-a1c717a065f3@linux.microsoft.com>
Date: Thu, 17 Sep 2020 18:01:38 +0200
In-Reply-To: <d96b87ed-9869-c732-9938-a1c717a065f3@linux.microsoft.com>
	(Madhavan T. Venkataraman's message of "Thu, 17 Sep 2020 10:57:20
	-0500")
Message-ID: <87y2l8xuhp.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain

* Madhavan T. Venkataraman:

> On 9/17/20 10:36 AM, Madhavan T. Venkataraman wrote:
>>>> libffi
>>>> ======
>>>>
>>>> I have implemented my solution for libffi and provided the changes for
>>>> X86 and ARM, 32-bit and 64-bit. Here is the reference patch:
>>>>
>>>> http://linux.microsoft.com/~madvenka/libffi/libffi.v2.txt
>>> The URL does not appear to work, I get a 403 error.
>> I apologize for that. That site is supposed to be accessible publicly.
>> I will contact the administrator and get this resolved.
>> 
>> Sorry for the annoyance.

> Could you try the link again and confirm that you can access it?
> Again, sorry for the trouble.

Yes, it works now.  Thanks for having it fixed.
