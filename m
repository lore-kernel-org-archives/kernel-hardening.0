Return-Path: <SRS0=B8yc=C2=lists.openwall.com=kernel-hardening-return-19909-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208CFC43461
	for <kernel-hardening@archiver.kernel.org>; Thu, 17 Sep 2020 15:57:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1E17622211
	for <kernel-hardening@archiver.kernel.org>; Thu, 17 Sep 2020 15:57:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Bap21mAv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E17622211
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19909-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7554 invoked by uid 550); 17 Sep 2020 15:57:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7532 invoked from network); 17 Sep 2020 15:57:33 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0C12120B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1600358241;
	bh=gUfIqFqpkrN0miyEH74CDfja3bpQECkvCujVL/Nljqg=;
	h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
	b=Bap21mAvyeJKL22S4sguYInURgSgiXufpOk5kqSzqijlzRcX3iHUIe82IA0u8e5iF
	 HUp6Jh7UtZquNUVfdaJKc5R07sTADe2RHBpUNCP9wEbiLC2OnHb/EKxDlG4YI6Xwcj
	 FLLh69Sze7efG1K6kw3QGbPypJvP6/2ulwQipahs=
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, oleg@redhat.com, x86@kernel.org,
 libffi-discuss@sourceware.org
References: <20200916150826.5990-1-madvenka@linux.microsoft.com>
 <87v9gdz01h.fsf@mid.deneb.enyo.de>
 <96ea02df-4154-5888-1669-f3beeed60b33@linux.microsoft.com>
Message-ID: <d96b87ed-9869-c732-9938-a1c717a065f3@linux.microsoft.com>
Date: Thu, 17 Sep 2020 10:57:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <96ea02df-4154-5888-1669-f3beeed60b33@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit



On 9/17/20 10:36 AM, Madhavan T. Venkataraman wrote:
>>> libffi
>>> ======
>>>
>>> I have implemented my solution for libffi and provided the changes for
>>> X86 and ARM, 32-bit and 64-bit. Here is the reference patch:
>>>
>>> http://linux.microsoft.com/~madvenka/libffi/libffi.v2.txt
>> The URL does not appear to work, I get a 403 error.
> I apologize for that. That site is supposed to be accessible publicly.
> I will contact the administrator and get this resolved.
> 
> Sorry for the annoyance.
> 

Could you try the link again and confirm that you can access it?
Again, sorry for the trouble.

Madhavan
