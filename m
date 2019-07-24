Return-Path: <SRS0=QK1Q=VV=lists.openwall.com=kernel-hardening-return-16568-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0452DC7618B
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 06:54:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4CBCD20644
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 06:54:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rasmusvillemoes.dk header.i=@rasmusvillemoes.dk header.b="aLewX3TL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CBCD20644
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rasmusvillemoes.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16568-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22224 invoked by uid 550); 24 Jul 2019 06:54:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22186 invoked from network); 24 Jul 2019 06:54:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/C6SvXQ+6R/YS6/L/kVntLwubBzK8ruAflHed0nbReY=;
        b=aLewX3TLaQpEf+jG9eq9DR3rB2kCKnHWJojwSG6hMYifsXBJLDODudPpRS09tpfVA8
         k0qf8wDdhjVj9/qFMn1TyUVNwLz3iMFztt9kCH4NB59+ZB9e1XPhjA2jlWT4EK4xlH6L
         HcDzjQqhjYJ3JqYlFX+8m23zc0khbv+Ltlgho=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/C6SvXQ+6R/YS6/L/kVntLwubBzK8ruAflHed0nbReY=;
        b=AIMpkzCgp1tUNYfiVpLzuyr2XsBAd8XBgBBIYq2hmiHXpEcwuhrXGEHJxNQc4ykhox
         fMj5RhInn+Wrl1bUstIuAGInu2uZdb3ZpTo9KOSHjrMAICGUaKGKoDCi6uJNbRbu8UII
         vVKOTQ8JRJW0ydl30TTOgXUPO0FJ4An3W5Ni0cSfOYyo7ucwi9PvLbAQVKALuKEC1UWH
         YYMpO3GcPe5i0Etu1PeM42CJIqywonupmD86miqkgPeKOL6xcwkW1L3QDeyI19HbbGjR
         q9k1ab55WtVVXva2cFJH7lo/Ry6jpzeNagolwBlGBPOVjSUwSSmc1rPhbSjMQe97PuuA
         uiGA==
X-Gm-Message-State: APjAAAU34lBy86JxU89HnUnFt4b9j0DZRQA9ZDuePdKBVCgihTthlIn0
	EX2up//aYqEeppN5TLS9S4o=
X-Google-Smtp-Source: APXvYqzr9x7DR4WYz7BXPk/LyHKBpDLjCJDWYISOmQ5xhwv78XBLqqnFGP0JqxfK2W5Gk5p9CxqYMQ==
X-Received: by 2002:a2e:3008:: with SMTP id w8mr42706727ljw.13.1563951234307;
        Tue, 23 Jul 2019 23:53:54 -0700 (PDT)
Subject: Re: [PATCH V2 1/2] string: Add stracpy and stracpy_pad mechanisms
To: Joe Perches <joe@perches.com>, Rasmus Villemoes
 <linux@rasmusvillemoes.dk>, Linus Torvalds <torvalds@linux-foundation.org>,
 linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Stephen Kitt <steve@sk2.org>,
 Kees Cook <keescook@chromium.org>, Nitin Gote <nitin.r.gote@intel.com>,
 jannh@google.com, kernel-hardening@lists.openwall.com,
 Andrew Morton <akpm@linux-foundation.org>
References: <cover.1563889130.git.joe@perches.com>
 <ed4611a4a96057bf8076856560bfbf9b5e95d390.1563889130.git.joe@perches.com>
 <ce1320d8-60df-7c54-2348-6aabac63c24d@rasmusvillemoes.dk>
 <c9ef2b56eaf36c8e5449b751ab6e5971b6b34311.camel@perches.com>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <dab1b433-93c0-09ab-cceb-3db91b6ef353@rasmusvillemoes.dk>
Date: Wed, 24 Jul 2019 08:53:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <c9ef2b56eaf36c8e5449b751ab6e5971b6b34311.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 23/07/2019 17.39, Joe Perches wrote:
> On Tue, 2019-07-23 at 16:37 +0200, Rasmus Villemoes wrote:
>> On 23/07/2019 15.51, Joe Perches wrote:
>>>
>>> These mechanisms verify that the dest argument is an array of
>>> char or other compatible types like u8 or s8 or equivalent.
>> Sorry, but "compatible types" has a very specific meaning in C, so
>> please don't use that word.
> 
> I think you are being overly pedantic here but
> what wording do you actually suggest?

I'd just not support anything other than char[], but if you want,
perhaps say "related types", or some other informal description.

>>  And yes, the kernel disables -Wpointer-sign,
>> so passing an u8* or s8* when strscpy() expects a char* is silently
>> accepted, but does such code exist?
> 
> u8 definitely, s8 I'm not sure.

Example (i.e. of someone passing an u8* as destination to some string
copy/formatting function)? I believe you, I'd just like to see the context.

> I don't find via grep a use of s8 foo[] = "bar";
> or "signed char foo[] = "bar";
> 
> I don't think it bad to allow it.

Your patch.

>> count is just as bad as size in terms of "the expression src might
>> contain that identifier". But there's actually no reason to even declare
>> a local variable, just use ARRAY_SIZE() directly as the third argument
>> to strscpy().
> 
> I don't care about that myself.
> It's a macro local identifier and shadowing in a macro
> is common.  I'm not a big fan of useless underscores.

shadowing is not the problem. The identifier "count" appearing in one of
the "dest" or "src" expressions is. For something that's supposed to
help eliminate bugs, such a hidden footgun seems to be a silly thing to
include. No need for some hideous triple-underscore variable, just make
the whole thing

BUILD_BUG_ON(!__same_type())
strscpy(dst, src, ARRAY_SIZE(dst))

Rasmus
