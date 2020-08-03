Return-Path: <SRS0=2EkI=BN=lists.openwall.com=kernel-hardening-return-19542-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F0CC433DF
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Aug 2020 18:18:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5336820792
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Aug 2020 18:18:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UCEO7FRl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5336820792
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19542-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9221 invoked by uid 550); 3 Aug 2020 18:18:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8177 invoked from network); 3 Aug 2020 18:18:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1596478676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VMw7i1cpHh8qkyXWE10tJgStQ1flp9PULSkxAaczHSg=;
	b=UCEO7FRl8sEH8QMcLU7xvv3t9fKlWYiJwYC/PE8ek3G4WbVsNVzNhDjTeITkU8hk4m/JJH
	9i1pyu4zUzaG9WQK1mG7r4zqhn8y5M4lStmoKutTWSbetJUGcjrdXsdgJu5aMYf/wJPOUo
	6yUNthUfZq9mBH0B2TbBcPYhfRs3W/A=
X-MC-Unique: fFB4_STrOvKdjZdsookBXA-1
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
To: Kees Cook <keescook@chromium.org>,
 Evgenii Shatokhin <eshatokhin@virtuozzo.com>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>,
 Miroslav Benes <mbenes@suse.cz>, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, arjan@linux.intel.com, x86@kernel.org,
 linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
 rick.p.edgecombe@intel.com, live-patching@vger.kernel.org,
 Josh Poimboeuf <jpoimboe@redhat.com>, Jessica Yu <jeyu@kernel.org>,
 "Frank Ch. Eigler" <fche@redhat.com>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <e9c4d88b-86db-47e9-4299-3fac45a7e3fd@virtuozzo.com>
 <202008031043.FE182E9@keescook>
From: Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <fc6d2289-af97-5cf8-a4bb-77c2b0b8375c@redhat.com>
Date: Mon, 3 Aug 2020 14:17:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <202008031043.FE182E9@keescook>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13

On 8/3/20 1:45 PM, Kees Cook wrote:
> On Mon, Aug 03, 2020 at 02:39:32PM +0300, Evgenii Shatokhin wrote:
>> There are at least 2 places where high-order memory allocations might happen
>> during module loading. Such allocations may fail if memory is fragmented,
>> while physically contiguous memory areas are not really needed there. I
>> suggest to switch to kvmalloc/kvfree there.
> 
> While this does seem to be the right solution for the extant problem, I
> do want to take a moment and ask if the function sections need to be
> exposed at all? What tools use this information, and do they just want
> to see the bounds of the code region? (i.e. the start/end of all the
> .text* sections) Perhaps .text.* could be excluded from the sysfs
> section list?
> 

[[cc += FChE, see [0] for Evgenii's full mail ]]

It looks like debugging tools like systemtap [1], gdb [2] and its 
add-symbol-file cmd, etc. peek at the /sys/module/<MOD>/section/ info.

But yeah, it would be preferable if we didn't export a long sysfs 
representation if nobody actually needs it.


[0] 
https://lore.kernel.org/lkml/e9c4d88b-86db-47e9-4299-3fac45a7e3fd@virtuozzo.com/
[1] https://fossies.org/linux/systemtap/staprun/staprun.c
[2] 
https://www.oreilly.com/library/view/linux-device-drivers/0596005903/ch04.html#linuxdrive3-CHP-4-SECT-6.1

-- Joe

