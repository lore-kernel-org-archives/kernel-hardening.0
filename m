Return-Path: <SRS0=5/8C=DA=lists.openwall.com=kernel-hardening-return-19990-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33945C2D0A8
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 19:17:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1AAB72145D
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 19:17:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="R/f7vi7J"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1AAB72145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19990-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22467 invoked by uid 550); 23 Sep 2020 19:17:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22426 invoked from network); 23 Sep 2020 19:17:43 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CE99120B7179
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1600888651;
	bh=3V9yRh0zCmTojKK1USEI2jDBEq7wh/QbrL/41M/+wzU=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=R/f7vi7J2qckScOCWh3kF/qy9S0K/1T6lHGGHPjotwbfa9uILSrVnoq4jZ3kOTEvo
	 nllS7aBXEK+MSRSIiDfi9E0VmYqam8vNJ2ZSS4AtYLBqZgF45tCOyMP35SAjXg2jnk
	 Ji3oSzQihgZhuEoO5YOa1VhHw0IBIwzXgyXJJYkw=
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Florian Weimer <fw@deneb.enyo.de>, kernel-hardening@lists.openwall.com,
 linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 oleg@redhat.com, x86@kernel.org, libffi-discuss@sourceware.org,
 luto@kernel.org, David.Laight@ACULAB.COM, mark.rutland@arm.com,
 mic@digikod.net, pavel@ucw.cz
References: <20200916150826.5990-1-madvenka@linux.microsoft.com>
 <87v9gdz01h.fsf@mid.deneb.enyo.de>
 <96ea02df-4154-5888-1669-f3beeed60b33@linux.microsoft.com>
 <20200923014616.GA1216401@rani.riverdale.lan>
 <20200923091125.GB1240819@rani.riverdale.lan>
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <a742b9cd-4ffb-60e0-63b8-894800009700@linux.microsoft.com>
Date: Wed, 23 Sep 2020 14:17:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200923091125.GB1240819@rani.riverdale.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit



On 9/23/20 4:11 AM, Arvind Sankar wrote:
> For libffi, I think the proposed standard trampoline won't actually
> work, because not all ABIs have two scratch registers available to use
> as code_reg and data_reg. Eg i386 fastcall only has one, and register
> has zero scratch registers. I believe 32-bit ARM only has one scratch
> register as well.

The trampoline is invoked as a function call in the libffi case. Any
caller saved register can be used as code_reg, can it not? And the
scratch register is needed only to jump to the code. After that, it
can be reused for any other purpose.

However, for ARM, you are quite correct. There is only one scratch
register. This means that I have to provide two types of trampolines:

	- If an architecture has enough scratch registers, use the currently
	  defined trampoline.

	- If the architecture has only one scratch register, but has PC-relative
	  data references, then embed the code address at the bottom of the
	  trampoline and access it using PC-relative addressing.

Thanks for pointing this out.

Madhavan
