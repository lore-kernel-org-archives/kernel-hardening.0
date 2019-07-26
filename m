Return-Path: <SRS0=RPqz=VX=lists.openwall.com=kernel-hardening-return-16590-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C4C6C76190
	for <kernel-hardening@archiver.kernel.org>; Fri, 26 Jul 2019 02:47:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 73AE02238C
	for <kernel-hardening@archiver.kernel.org>; Fri, 26 Jul 2019 02:47:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 73AE02238C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16590-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22298 invoked by uid 550); 26 Jul 2019 02:47:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22193 invoked from network); 26 Jul 2019 02:47:09 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: crow03_1f320ee7be00f
X-Filterd-Recvd-Size: 3123
Message-ID: <ffcdd323f2f325fc9e9f2e17e1795ddaddeccd33.camel@perches.com>
Subject: Re: [PATCH 1/2] string: Add stracpy and stracpy_pad mechanisms
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Yann Droneaud
 <ydroneaud@opteya.com>, David Laight <David.Laight@aculab.com>, 
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jonathan
 Corbet <corbet@lwn.net>, Stephen Kitt <steve@sk2.org>, Nitin Gote
 <nitin.r.gote@intel.com>, "jannh@google.com" <jannh@google.com>,
 "kernel-hardening@lists.openwall.com"
 <kernel-hardening@lists.openwall.com>, Andrew Morton
 <akpm@linux-foundation.org>
Date: Thu, 25 Jul 2019 19:46:53 -0700
In-Reply-To: <201907251301.E1E32DCCCE@keescook>
References: <cover.1563841972.git.joe@perches.com>
	 <7ab8957eaf9b0931a59eff6e2bd8c5169f2f6c41.1563841972.git.joe@perches.com>
	 <eec901c6-ca51-89e4-1887-1ccab0288bee@rasmusvillemoes.dk>
	 <5ffdbf4f87054b47a2daf23a6afabecf@AcuMS.aculab.com>
	 <bc1ad99a420dd842ce3a17c2c38a2f94683dc91c.camel@opteya.com>
	 <396d1eed-8edf-aa77-110b-c50ead3a5fd5@rasmusvillemoes.dk>
	 <CAHk-=whPA-Vv-OHbUe4M5=ygTknQNOasnLAp-E3zSAaq=pue+g@mail.gmail.com>
	 <201907251301.E1E32DCCCE@keescook>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2019-07-25 at 13:03 -0700, Kees Cook wrote:
> On Wed, Jul 24, 2019 at 10:08:57AM -0700, Linus Torvalds wrote:
> > On Wed, Jul 24, 2019 at 6:09 AM Rasmus Villemoes
> > <linux@rasmusvillemoes.dk> wrote:
> > > The kernel's snprintf() does not behave in a non-standard way, at least
> > > not with respect to its return value.
> > 
> > Note that the kernels snprintf() *does* very much protect against the
> > overflow case - not by changing the return value, but simply by having
> > 
> >         /* Reject out-of-range values early.  Large positive sizes are
> >            used for unknown buffer sizes. */
> >         if (WARN_ON_ONCE(size > INT_MAX))
> >                 return 0;
> > 
> > at the very top.
> > 
> > So you can't actually overflow in the kernel by using the repeated
> > 
> >         offset += vsnprintf( .. size - offset ..);
> > 
> > model.
> > 
> > Yes, it's the wrong thing to do, but it is still _safe_.
> 
> Actually, perhaps we should add this test to strscpy() too?

Doesn't seem to have a reason not to be added
but maybe it's better to add another WARN_ON_ONCE.

> diff --git a/lib/string.c b/lib/string.c
[]
> @@ -182,7 +182,7 @@ ssize_t strscpy(char *dest, const char *src, size_t count)
>  	size_t max = count;
>  	long res = 0;
>  
> -	if (count == 0)
> +	if (count == 0 || count > INT_MAX)
>  		return -E2BIG;
>  
>  #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> 

