Return-Path: <SRS0=DLdv=VV=lists.openwall.com=kernel-hardening-return-16573-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 198D3C41514
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 13:09:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 69CDB21738
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 13:09:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rasmusvillemoes.dk header.i=@rasmusvillemoes.dk header.b="P1hm04nm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69CDB21738
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rasmusvillemoes.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16573-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7482 invoked by uid 550); 24 Jul 2019 13:09:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7425 invoked from network); 24 Jul 2019 13:09:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f4suZrpfhVME9PStBS3l8/qYNB52LjXte4Jp7QV1fJc=;
        b=P1hm04nmq8167DSE3iTDmBtlSkwmwS0C9IQYXgXAr3bOqgsitm4JZyJpEwjECFSJ3r
         hVs+wZSxh9IimkkFqfvll8rE1TX6cXYyb3yJrOQ4slWIUZeOdB5qdSQVrQjt4D7xVDlu
         rrCg74BJef1BmvhakY4s2UB0xlON8LZ++gDkQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f4suZrpfhVME9PStBS3l8/qYNB52LjXte4Jp7QV1fJc=;
        b=gB3fxFJximfEgm4onUq5aoqUXHjM59WK+b87sje1l/RgAyzzkPFq0I3TKNo6Ml8yg9
         Pmr3v9AiSGLnHm7/bGxxXux4+1sVPZJVmItCKnYtqEHI6BSY2Yu00ky2DTVFQQZBYzOX
         G9UG1y5fVWg3WrF81mLdnxpa09QAyosQCtPaH+axZiSI3WYbdWZGl/tspb5gWKH4LDGn
         cJxkq2XeAtb4je5/EfZHh0LqAh9/4Y9ba4gxt7DaU4fDDhGRCitNNDPKBt6IYGJg0oF7
         XKvrJf6/hFk75wEvJzJjhluX4Q7Fl2bLulICX5gE77qHDu4YAJeAAm0EmXgnFj+/R1Uc
         uchQ==
X-Gm-Message-State: APjAAAUlZaKBi3Icu5ex2/r/7JU5prSqa+4/whAQRjKfY+TpJRd+hIuR
	M+2ZqkumIkXDuaEzGtOBlKc=
X-Google-Smtp-Source: APXvYqyvAFqxSWtH3PlfUwSteuCMN+fUFBjvA8cZCWk+4aDvXTvZddDHhQVliHvtjV77g0yqQZzgBg==
X-Received: by 2002:a2e:93c5:: with SMTP id p5mr41945289ljh.79.1563973752416;
        Wed, 24 Jul 2019 06:09:12 -0700 (PDT)
Subject: Re: [PATCH 1/2] string: Add stracpy and stracpy_pad mechanisms
To: Yann Droneaud <ydroneaud@opteya.com>,
 David Laight <David.Laight@ACULAB.COM>, Joe Perches <joe@perches.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Stephen Kitt <steve@sk2.org>,
 Kees Cook <keescook@chromium.org>, Nitin Gote <nitin.r.gote@intel.com>,
 "jannh@google.com" <jannh@google.com>,
 "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <cover.1563841972.git.joe@perches.com>
 <7ab8957eaf9b0931a59eff6e2bd8c5169f2f6c41.1563841972.git.joe@perches.com>
 <eec901c6-ca51-89e4-1887-1ccab0288bee@rasmusvillemoes.dk>
 <5ffdbf4f87054b47a2daf23a6afabecf@AcuMS.aculab.com>
 <bc1ad99a420dd842ce3a17c2c38a2f94683dc91c.camel@opteya.com>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <396d1eed-8edf-aa77-110b-c50ead3a5fd5@rasmusvillemoes.dk>
Date: Wed, 24 Jul 2019 15:09:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <bc1ad99a420dd842ce3a17c2c38a2f94683dc91c.camel@opteya.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 24/07/2019 14.05, Yann Droneaud wrote:
> Hi,
> 

> Beware that snprintf(), per C standard, is supposed to return the
> length of the formatted string, regarless of the size of the
> destination buffer.
> 
> So encouraging developper to write something like code below because
> snprintf() in kernel behave in a non-standard way,

The kernel's snprintf() does not behave in a non-standard way, at least
not with respect to its return value. It doesn't support %n or floating
point, of course, and there are some quirks regarding precision (see
lib/test_printf.c for details).

There's the non-standard scnprintf() for getting the length of the
formatted string, which can safely be used in an append loop. Or one can
use the seq_buf API.

Rasmus
