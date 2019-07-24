Return-Path: <SRS0=PCJo=VV=lists.openwall.com=kernel-hardening-return-16572-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F435C7618B
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 12:06:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 833E2229F3
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 12:06:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 833E2229F3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=opteya.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16572-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25659 invoked by uid 550); 24 Jul 2019 12:06:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25621 invoked from network); 24 Jul 2019 12:06:21 -0000
Message-ID: <bc1ad99a420dd842ce3a17c2c38a2f94683dc91c.camel@opteya.com>
From: Yann Droneaud <ydroneaud@opteya.com>
To: David Laight <David.Laight@ACULAB.COM>, 'Rasmus Villemoes'
	 <linux@rasmusvillemoes.dk>, Joe Perches <joe@perches.com>, Linus Torvalds
	 <torvalds@linux-foundation.org>, "linux-kernel@vger.kernel.org"
	 <linux-kernel@vger.kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Stephen Kitt <steve@sk2.org>, Kees
 Cook <keescook@chromium.org>, Nitin Gote <nitin.r.gote@intel.com>, 
 "jannh@google.com" <jannh@google.com>,
 "kernel-hardening@lists.openwall.com"
 <kernel-hardening@lists.openwall.com>, Andrew Morton
 <akpm@linux-foundation.org>
Date: Wed, 24 Jul 2019 14:05:48 +0200
In-Reply-To: <5ffdbf4f87054b47a2daf23a6afabecf@AcuMS.aculab.com>
References: <cover.1563841972.git.joe@perches.com>
	 <7ab8957eaf9b0931a59eff6e2bd8c5169f2f6c41.1563841972.git.joe@perches.com>
	 <eec901c6-ca51-89e4-1887-1ccab0288bee@rasmusvillemoes.dk>
	 <5ffdbf4f87054b47a2daf23a6afabecf@AcuMS.aculab.com>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 37.164.191.68
X-SA-Exim-Mail-From: ydroneaud@opteya.com
Subject: Re: [PATCH 1/2] string: Add stracpy and stracpy_pad mechanisms
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on ou.quest-ce.net)

Hi,

Le mardi 23 juillet 2019 à 15:41 +0000, David Laight a écrit :
> From: Rasmus Villemoes
> > Sent: 23 July 2019 07:56
> ...
> > > +/**
> > > + * stracpy - Copy a C-string into an array of char
> > > + * @to: Where to copy the string, must be an array of char and
> > > not a pointer
> > > + * @from: String to copy, may be a pointer or const char array
> > > + *
> > > + * Helper for strscpy.
> > > + * Copies a maximum of sizeof(@to) bytes of @from with %NUL
> > > termination.
> > > + *
> > > + * Returns:
> > > + * * The number of characters copied (not including the trailing
> > > %NUL)
> > > + * * -E2BIG if @to is a zero size array.
> > 
> > Well, yes, but more importantly and generally: -E2BIG if the copy
> > including %NUL didn't fit. [The zero size array thing could be made
> > into
> > a build bug for these stra* variants if one thinks that might
> > actually
> > occur in real code.]
> 
> Probably better is to return the size of the destination if the copy
> didn't fit
> (zero if the buffer is zero length).
> This allows code to do repeated:
> 	offset += str*cpy(buf + offset, src, sizeof buf - offset);
> and do a final check for overflow after all the copies.
> 
> The same is true for a snprintf()like function
> 

Beware that snprintf(), per C standard, is supposed to return the
length of the formatted string, regarless of the size of the
destination buffer.

So encouraging developper to write something like code below because
snprintf() in kernel behave in a non-standard way, will likely create
some issues in the near future.

  for(;...;)
    offset += snprintf(buf + offset, size - offset, "......", ....);

(Reminder: the code below is not safe and shouldn't be used)

Regards.

-- 
Yann Droneaud
OPTEYA


