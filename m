Return-Path: <SRS0=DpDW=VU=lists.openwall.com=kernel-hardening-return-16559-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D27E6C7618B
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 15:40:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 31583223BA
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 15:40:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31583223BA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16559-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24070 invoked by uid 550); 23 Jul 2019 15:40:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24034 invoked from network); 23 Jul 2019 15:40:05 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: fowl35_38e5e5eee520d
X-Filterd-Recvd-Size: 2880
Message-ID: <c9ef2b56eaf36c8e5449b751ab6e5971b6b34311.camel@perches.com>
Subject: Re: [PATCH V2 1/2] string: Add stracpy and stracpy_pad mechanisms
From: Joe Perches <joe@perches.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Linus Torvalds
	 <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Stephen Kitt <steve@sk2.org>, Kees
 Cook <keescook@chromium.org>, Nitin Gote <nitin.r.gote@intel.com>,
 jannh@google.com,  kernel-hardening@lists.openwall.com, Andrew Morton
 <akpm@linux-foundation.org>
Date: Tue, 23 Jul 2019 08:39:49 -0700
In-Reply-To: <ce1320d8-60df-7c54-2348-6aabac63c24d@rasmusvillemoes.dk>
References: <cover.1563889130.git.joe@perches.com>
	 <ed4611a4a96057bf8076856560bfbf9b5e95d390.1563889130.git.joe@perches.com>
	 <ce1320d8-60df-7c54-2348-6aabac63c24d@rasmusvillemoes.dk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2019-07-23 at 16:37 +0200, Rasmus Villemoes wrote:
> On 23/07/2019 15.51, Joe Perches wrote:
> > Several uses of strlcpy and strscpy have had defects because the
> > last argument of each function is misused or typoed.
> > 
> > Add macro mechanisms to avoid this defect.
> > 
> > stracpy (copy a string to a string array) must have a string
> > array as the first argument (dest) and uses sizeof(dest) as the
> > count of bytes to copy.
> > 
> > These mechanisms verify that the dest argument is an array of
> > char or other compatible types like u8 or s8 or equivalent.
> Sorry, but "compatible types" has a very specific meaning in C, so
> please don't use that word.

I think you are being overly pedantic here but
what wording do you actually suggest?

>  And yes, the kernel disables -Wpointer-sign,
> so passing an u8* or s8* when strscpy() expects a char* is silently
> accepted, but does such code exist?

u8 definitely, s8 I'm not sure.

I don't find via grep a use of s8 foo[] = "bar";
or "signed char foo[] = "bar";

I don't think it bad to allow it.

> > V2: Use __same_type testing char[], signed char[], and unsigned char[]
> >     Rename to, from, and size, dest, src and count
> 
> count is just as bad as size in terms of "the expression src might
> contain that identifier". But there's actually no reason to even declare
> a local variable, just use ARRAY_SIZE() directly as the third argument
> to strscpy().

I don't care about that myself.
It's a macro local identifier and shadowing in a macro
is common.  I'm not a big fan of useless underscores.

I think either works.


