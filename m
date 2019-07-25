Return-Path: <SRS0=rZuO=VW=lists.openwall.com=kernel-hardening-return-16588-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 560CAC76190
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jul 2019 20:03:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A2246229F9
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jul 2019 20:03:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gRrhkgmX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2246229F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16588-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15418 invoked by uid 550); 25 Jul 2019 20:03:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15382 invoked from network); 25 Jul 2019 20:03:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uHw7zEXiXiWuFCeMIM1DoPEM5lUo8QWt7fmyIitbzd4=;
        b=gRrhkgmXX57rpW/eOfU07DHgYIRJaSRHWUMLcqkuazmJ9eSgJ3ejVn/JebuAtKVADk
         Es6uzHuBitkmgkTqzHq1W3PJ0BRywQ0CY27gZ/QC9xT0zl4goLkz+41D93WnbaD1uMqw
         G/fn+b5k6gja9lg/U079hwILSubBD+sUO58DQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uHw7zEXiXiWuFCeMIM1DoPEM5lUo8QWt7fmyIitbzd4=;
        b=o6M42xDLa2TjZ3jZd47i9ZrWaQqDi5iDtcCJbDy6vk5rp2BdhdbtIqFSKL+IMLlWuQ
         HtDWHreRJvQEL2C1GeDQXosza8JuwE/2jE5cSqTSADYxlIWye8EeofV1X15+vtERwp/T
         6nasGsRpAUa2ItqTwl9793MQWO+VYU2MhsfUYNZL9DZ3V3xau31l1PG4qVVuCXJHpFQu
         V0KFH2YaxvcBas7bhXiglDXPL3QRnwkQJpUyVihDtgBIELNBUUR1e7OJZdDG+j7Rf9rg
         IUiYwY8vVdBca/J5G6QpOPWTML5ZtJFU2wBqwy3IDB0Fm/p1XEPINke6M2KkNohjdAjN
         ifNg==
X-Gm-Message-State: APjAAAUpmyk1UWECrf3ZBfsJ6OwZCtKkByLTxCkPcp042ueBd3cQgB4P
	7Q1nAWdK7ydZjRE5mPya+7IBVw==
X-Google-Smtp-Source: APXvYqyiwJnHa4FCVMLcBfvKJWud2kqtfpMi3xvkqMN2IoBqOPCPGL/0CNp1/3L5rVvFG+E3R3tlcw==
X-Received: by 2002:a63:a302:: with SMTP id s2mr18456663pge.125.1564085012343;
        Thu, 25 Jul 2019 13:03:32 -0700 (PDT)
Date: Thu, 25 Jul 2019 13:03:30 -0700
From: Kees Cook <keescook@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Yann Droneaud <ydroneaud@opteya.com>,
	David Laight <David.Laight@aculab.com>,
	Joe Perches <joe@perches.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Stephen Kitt <steve@sk2.org>,
	Nitin Gote <nitin.r.gote@intel.com>,
	"jannh@google.com" <jannh@google.com>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] string: Add stracpy and stracpy_pad mechanisms
Message-ID: <201907251301.E1E32DCCCE@keescook>
References: <cover.1563841972.git.joe@perches.com>
 <7ab8957eaf9b0931a59eff6e2bd8c5169f2f6c41.1563841972.git.joe@perches.com>
 <eec901c6-ca51-89e4-1887-1ccab0288bee@rasmusvillemoes.dk>
 <5ffdbf4f87054b47a2daf23a6afabecf@AcuMS.aculab.com>
 <bc1ad99a420dd842ce3a17c2c38a2f94683dc91c.camel@opteya.com>
 <396d1eed-8edf-aa77-110b-c50ead3a5fd5@rasmusvillemoes.dk>
 <CAHk-=whPA-Vv-OHbUe4M5=ygTknQNOasnLAp-E3zSAaq=pue+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whPA-Vv-OHbUe4M5=ygTknQNOasnLAp-E3zSAaq=pue+g@mail.gmail.com>

On Wed, Jul 24, 2019 at 10:08:57AM -0700, Linus Torvalds wrote:
> On Wed, Jul 24, 2019 at 6:09 AM Rasmus Villemoes
> <linux@rasmusvillemoes.dk> wrote:
> >
> > The kernel's snprintf() does not behave in a non-standard way, at least
> > not with respect to its return value.
> 
> Note that the kernels snprintf() *does* very much protect against the
> overflow case - not by changing the return value, but simply by having
> 
>         /* Reject out-of-range values early.  Large positive sizes are
>            used for unknown buffer sizes. */
>         if (WARN_ON_ONCE(size > INT_MAX))
>                 return 0;
> 
> at the very top.
> 
> So you can't actually overflow in the kernel by using the repeated
> 
>         offset += vsnprintf( .. size - offset ..);
> 
> model.
> 
> Yes, it's the wrong thing to do, but it is still _safe_.

Actually, perhaps we should add this test to strscpy() too?

diff --git a/lib/string.c b/lib/string.c
index 461fb620f85f..0e0d7628ddc4 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -182,7 +182,7 @@ ssize_t strscpy(char *dest, const char *src, size_t count)
 	size_t max = count;
 	long res = 0;
 
-	if (count == 0)
+	if (count == 0 || count > INT_MAX)
 		return -E2BIG;
 
 #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS

-- 
Kees Cook
