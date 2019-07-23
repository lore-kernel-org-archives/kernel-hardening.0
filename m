Return-Path: <SRS0=I8wb=VU=lists.openwall.com=kernel-hardening-return-16557-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF39CC7618B
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 14:37:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0B07B21738
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 14:37:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rasmusvillemoes.dk header.i=@rasmusvillemoes.dk header.b="RRbq2pjM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B07B21738
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rasmusvillemoes.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16557-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 8185 invoked by uid 550); 23 Jul 2019 14:37:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8150 invoked from network); 23 Jul 2019 14:37:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YBcNl1Cx1gVNSGn+Kq9310BI1gMrWUUWqNCvZ/2rb/s=;
        b=RRbq2pjMpXvz9KgvzBNVhBIj6k2ETFnueG4QX8xDJ5WLNruHjwz1L6JINxAG0AoLtJ
         c5QjfhUPBMbc9oGLYyjKO+/cooINg5BDHACf/+q6fNCge217NgFndpxjTo7RrTxBPoZw
         anV3B+QvbgTWq3vsY28TiRMC7b7EwF4WtpagU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YBcNl1Cx1gVNSGn+Kq9310BI1gMrWUUWqNCvZ/2rb/s=;
        b=SHPqwuctOt54O5BESyLyaZHRjZi72RXpvCP0cHGSLDyxvH1hQ9UIrJq8IFx3tAg5aK
         sdwOETiOJUw+mxNnLgRomOwubAZDLPyBZ3lidPS8ErrPIt93C8+mk0E9sQs/FvvxrsWK
         nmsHDiWli8jKnGm8XJtXAxhVSV7hiYL3rRNKFYTfXBMOmQm+Xd+lwrsH6FfgjrNlAB0z
         JWj5llsCME4xQKsRRG+n70KlTgP1c0YlPk76I649FtDQKLmScNrUNHDrvfbbNvJDIiVE
         uqUR00+SVTqdWrEOGBiWYk2DP1B///xQ8tyAlRPbxUbU5lK2LTx4Ovd+84GcVN/UpXQX
         u4QA==
X-Gm-Message-State: APjAAAU2jNjAZCup+mFqIbmGfNJcQDB0cQMP8uJTKoBELTXGPc3j7PGv
	BJm9kGnaSiz4uc9Vy1Ta8mOXpV8UqldWPA==
X-Google-Smtp-Source: APXvYqzh3QhbGRFuTVqjNmfeVm8I4Q8Oe5n8SjeNL4DVCXX34MRoWq5JCbYU1iJqo5oVGl3DEjonGQ==
X-Received: by 2002:ac2:43cf:: with SMTP id u15mr23454716lfl.188.1563892623570;
        Tue, 23 Jul 2019 07:37:03 -0700 (PDT)
Subject: Re: [PATCH V2 1/2] string: Add stracpy and stracpy_pad mechanisms
To: Joe Perches <joe@perches.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Stephen Kitt <steve@sk2.org>,
 Kees Cook <keescook@chromium.org>, Nitin Gote <nitin.r.gote@intel.com>,
 jannh@google.com, kernel-hardening@lists.openwall.com,
 Andrew Morton <akpm@linux-foundation.org>
References: <cover.1563889130.git.joe@perches.com>
 <ed4611a4a96057bf8076856560bfbf9b5e95d390.1563889130.git.joe@perches.com>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <ce1320d8-60df-7c54-2348-6aabac63c24d@rasmusvillemoes.dk>
Date: Tue, 23 Jul 2019 16:37:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <ed4611a4a96057bf8076856560bfbf9b5e95d390.1563889130.git.joe@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 23/07/2019 15.51, Joe Perches wrote:
> Several uses of strlcpy and strscpy have had defects because the
> last argument of each function is misused or typoed.
> 
> Add macro mechanisms to avoid this defect.
> 
> stracpy (copy a string to a string array) must have a string
> array as the first argument (dest) and uses sizeof(dest) as the
> count of bytes to copy.
> 
> These mechanisms verify that the dest argument is an array of
> char or other compatible types like u8 or s8 or equivalent.

Sorry, but "compatible types" has a very specific meaning in C, so
please don't use that word. And yes, the kernel disables -Wpointer-sign,
so passing an u8* or s8* when strscpy() expects a char* is silently
accepted, but does such code exist?

> 
> V2: Use __same_type testing char[], signed char[], and unsigned char[]
>     Rename to, from, and size, dest, src and count

count is just as bad as size in terms of "the expression src might
contain that identifier". But there's actually no reason to even declare
a local variable, just use ARRAY_SIZE() directly as the third argument
to strscpy().

Rasmus
