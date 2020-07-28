Return-Path: <SRS0=Ox13=BH=lists.openwall.com=kernel-hardening-return-19478-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A6CC433E1
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jul 2020 17:09:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5D5B120829
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jul 2020 17:09:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ZuOaQbdU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D5B120829
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19478-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28532 invoked by uid 550); 28 Jul 2020 17:09:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28509 invoked from network); 28 Jul 2020 17:09:01 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3CB1720B4908
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1595956129;
	bh=/7IJcSJkmnGhyvhTN0w/k6D0iSgWl3GbtIXdsg8Fv5A=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=ZuOaQbdU5uYtFJaEiOblvnFbeGROFNYKRjF3F43kJ1vUkhEErX0fbDaPkJowjRf06
	 4DasCLQblFzecv0eF8w7mUhf1hXAgudt5JEdU8ofWsRvm0zC9iTlBhH+fSyTWj70K7
	 RgZPV6XJ7g6uzFeyOC7P2FKqWtU5gXy/jZ/r8ZHI=
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
To: James Morris <jmorris@namei.org>, Casey Schaufler <casey@schaufler-ca.com>
Cc: kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, oleg@redhat.com, x86@kernel.org
References: <aefc85852ea518982e74b233e11e16d2e707bc32>
 <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <3fd22f92-7f45-1b0f-e4fe-857f3bceedd0@schaufler-ca.com>
 <alpine.LRH.2.21.2007290300400.31310@namei.org>
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <a909e0b0-0d82-d869-fe49-cc974680ac23@linux.microsoft.com>
Date: Tue, 28 Jul 2020 12:08:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.2007290300400.31310@namei.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US



On 7/28/20 12:05 PM, James Morris wrote:
> On Tue, 28 Jul 2020, Casey Schaufler wrote:
>
>> You could make a separate LSM to do these checks instead of limiting
>> it to SELinux. Your use case, your call, of course.
> It's not limited to SELinux. This is hooked via the LSM API and 
> implementable by any LSM (similar to execmem, execstack etc.)

Yes. I have an implementation that I am testing right now that
defines the hook for exectramp and implements it for
SELinux. That is why I mentioned SELinux.

Madhavan
