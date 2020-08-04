Return-Path: <SRS0=Un9V=BO=lists.openwall.com=kernel-hardening-return-19555-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 391E8C433E0
	for <kernel-hardening@archiver.kernel.org>; Tue,  4 Aug 2020 14:48:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 94074206DA
	for <kernel-hardening@archiver.kernel.org>; Tue,  4 Aug 2020 14:48:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Zd9gPm9P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94074206DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19555-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1389 invoked by uid 550); 4 Aug 2020 14:48:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1364 invoked from network); 4 Aug 2020 14:48:24 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C779220B4908
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1596552492;
	bh=WWoZU5hW4wXDmLDqxKWgVjJhEBnDZrlL0eZeSoA1M0E=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=Zd9gPm9PZos91WvJOt0oayxz099VIuOsWoBZIXUJDFjP7lCj1dlQONa0QNp25lwdY
	 dsm1r5OpjOcAXzNUDHh+nWWnMfnxq0oL6LMUtoVLftLBOD3ttlLrNDioYA+AS/vahh
	 DP92H/rykDhIN5jKmVDwqf9m4OvMWrU04m/O4Ps0=
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
To: David Laight <David.Laight@ACULAB.COM>,
 'Mark Rutland' <mark.rutland@arm.com>
Cc: Andy Lutomirski <luto@kernel.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux API <linux-api@vger.kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 linux-integrity <linux-integrity@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 LSM List <linux-security-module@vger.kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, X86 ML <x86@kernel.org>
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
 <6540b4b7-3f70-adbf-c922-43886599713a@linux.microsoft.com>
 <CALCETrWnNR5v3ZCLfBVQGYK8M0jAvQMaAc9uuO05kfZuh-4d6w@mail.gmail.com>
 <46a1adef-65f0-bd5e-0b17-54856fb7e7ee@linux.microsoft.com>
 <20200731183146.GD67415@C02TD0UTHF1T.local>
 <86625441-80f3-2909-2f56-e18e2b60957d@linux.microsoft.com>
 <20200804135558.GA7440@C02TD0UTHF1T.local>
 <c898918d18f34fd5b004cd1549b6a99e@AcuMS.aculab.com>
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <5f3c9616-52f5-f539-a39f-3fd3ada4f0aa@linux.microsoft.com>
Date: Tue, 4 Aug 2020 09:48:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c898918d18f34fd5b004cd1549b6a99e@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US



On 8/4/20 9:33 AM, David Laight wrote:
>>> If you look at the libffi reference patch I have included, the architecture
>>> specific changes to use trampfd just involve a single C function call to
>>> a common code function.
> No idea what libffi is, but it must surely be simpler to
> rewrite it to avoid nested function definitions.

Sorry if I wasn't clear.

libffi is a separate use case and GCC nested functions is a separate one.
libffi is not used to solve the nested function stuff.

For nested functions, GCC generates trampoline code and arranges to
place it on the stack and execute it.

I agree with your other points about nested function implementation.

Madhavan
> Or find a book from the 1960s on how to do recursive
> calls and nested functions in FORTRAN-IV.
>
> 	David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

