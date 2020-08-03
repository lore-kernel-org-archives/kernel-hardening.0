Return-Path: <SRS0=7JBJ=BN=lists.openwall.com=kernel-hardening-return-19535-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84AC6C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Aug 2020 15:59:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D15102072A
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Aug 2020 15:59:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="CmZKNOH/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D15102072A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19535-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21663 invoked by uid 550); 3 Aug 2020 15:59:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21640 invoked from network); 3 Aug 2020 15:59:17 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0B58220B4908
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1596470345;
	bh=61JblHzq4qhtQkPzj2G3tGZ75oReI0NIx105fosLKrI=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=CmZKNOH/KALtRXbeh0M5SY5+FforFJaVBEotq9VkjW4009Y9gJ4Y8SiPFK60B63Ek
	 PKT5VksgRHxxB2UeKRaW8GTHJZ0qNSXo3Bv3a1oHMYNew4GGXbm8WZ2IzEPQtDPc28
	 jbSZxdwUc01p8o/CYVhWcBeeqUmlISxGx9Y/uaWA=
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
To: David Laight <David.Laight@ACULAB.COM>, Andy Lutomirski <luto@kernel.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux API <linux-api@vger.kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 linux-integrity <linux-integrity@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 LSM List <linux-security-module@vger.kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, X86 ML <x86@kernel.org>
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
 <3b916198-3a98-bd19-9a1c-f2d8d44febe8@linux.microsoft.com>
 <a5fb2778a86f45b58ef5dd35228d950b@AcuMS.aculab.com>
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <8f938da2-a10d-ca15-56f0-70315c678771@linux.microsoft.com>
Date: Mon, 3 Aug 2020 10:59:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a5fb2778a86f45b58ef5dd35228d950b@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US



On 8/3/20 3:23 AM, David Laight wrote:
> From: Madhavan T. Venkataraman
>> Sent: 02 August 2020 19:55
>> To: Andy Lutomirski <luto@kernel.org>
>> Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>; Linux API <linux-api@vger.kernel.org>;
>> linux-arm-kernel <linux-arm-kernel@lists.infradead.org>; Linux FS Devel <linux-
>> fsdevel@vger.kernel.org>; linux-integrity <linux-integrity@vger.kernel.org>; LKML <linux-
>> kernel@vger.kernel.org>; LSM List <linux-security-module@vger.kernel.org>; Oleg Nesterov
>> <oleg@redhat.com>; X86 ML <x86@kernel.org>
>> Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
>>
>> More responses inline..
>>
>> On 7/28/20 12:31 PM, Andy Lutomirski wrote:
>>>> On Jul 28, 2020, at 6:11 AM, madvenka@linux.microsoft.com wrote:
>>>>
>>>> ﻿From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>>>
>>> 2. Use existing kernel functionality.  Raise a signal, modify the
>>> state, and return from the signal.  This is very flexible and may not
>>> be all that much slower than trampfd.
>> Let me understand this. You are saying that the trampoline code
>> would raise a signal and, in the signal handler, set up the context
>> so that when the signal handler returns, we end up in the target
>> function with the context correctly set up. And, this trampoline code
>> can be generated statically at build time so that there are no
>> security issues using it.
>>
>> Have I understood your suggestion correctly?
> I was thinking that you'd just let the 'not executable' page fault
> signal happen (SIGSEGV?) when the code jumps to on-stack trampoline
> is executed.
>
> The user signal handler can then decode the faulting instruction
> and, if it matches the expected on-stack trampoline, modify the
> saved registers before returning from the signal.
>
> No kernel changes and all you need to add to the program is
> an architecture-dependant signal handler.

Understood.

Madhavan
