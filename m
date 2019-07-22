Return-Path: <SRS0=IVO3=VT=lists.openwall.com=kernel-hardening-return-16530-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	LOTS_OF_MONEY,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61DC6C7618F
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 17:59:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BF92221955
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 17:59:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF92221955
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16530-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5220 invoked by uid 550); 22 Jul 2019 17:59:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5179 invoked from network); 22 Jul 2019 17:59:15 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: drug03_31cab706afb19
X-Filterd-Recvd-Size: 4309
Message-ID: <15f2be3cde69321f4f3a48d60645b303d66a600b.camel@perches.com>
Subject: Re: [PATCH] checkpatch: Added warnings in favor of strscpy().
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>, Stephen Kitt <steve@sk2.org>
Cc: Nitin Gote <nitin.r.gote@intel.com>, jannh@google.com, 
	kernel-hardening@lists.openwall.com, corbet@lwn.net, 
	linux-kernel@vger.kernel.org, Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Date: Mon, 22 Jul 2019 10:59:00 -0700
In-Reply-To: <201907221047.4895D35B30@keescook>
References: <1561722948-28289-1-git-send-email-nitin.r.gote@intel.com>
	 <20190629181537.7d524f7d@sk2.org> <201907021024.D1C8E7B2D@keescook>
	 <20190706144204.15652de7@heffalump.sk2.org>
	 <201907221047.4895D35B30@keescook>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 2019-07-22 at 10:50 -0700, Kees Cook wrote:
> On Sat, Jul 06, 2019 at 02:42:04PM +0200, Stephen Kitt wrote:
> > On Tue, 2 Jul 2019 10:25:04 -0700, Kees Cook <keescook@chromium.org> wrote:
> > > On Sat, Jun 29, 2019 at 06:15:37PM +0200, Stephen Kitt wrote:
> > > > On Fri, 28 Jun 2019 17:25:48 +0530, Nitin Gote <nitin.r.gote@intel.com>
> > > > wrote:  
> > > > > 1. Deprecate strcpy() in favor of strscpy().  
> > > > 
> > > > This isn’t a comment “against” this patch, but something I’ve been
> > > > wondering recently and which raises a question about how to handle
> > > > strcpy’s deprecation in particular. There is still one scenario where
> > > > strcpy is useful: when GCC replaces it with its builtin, inline version...
> > > > 
> > > > Would it be worth introducing a macro for strcpy-from-constant-string,
> > > > which would check that GCC’s builtin is being used (when building with
> > > > GCC), and fall back to strscpy otherwise?  
> > > 
> > > How would you suggest it operate? A separate API, or something like the
> > > existing overloaded strcpy() macros in string.h?
> > 
> > The latter; in my mind the point is to simplify the thought process for
> > developers, so strscpy should be the “obvious” choice in all cases, even when
> > dealing with constant strings in hot paths. Something like
> > 
> > __FORTIFY_INLINE ssize_t strscpy(char *dest, const char *src, size_t count)
> > {
> > 	size_t dest_size = __builtin_object_size(dest, 0);
> > 	size_t src_size = __builtin_object_size(src, 0);
> > 	if (__builtin_constant_p(count) &&
> > 	    __builtin_constant_p(src_size) &&
> > 	    __builtin_constant_p(dest_size) &&
> > 	    src_size <= count &&
> > 	    src_size <= dest_size &&
> > 	    src[src_size - 1] == '\0') {
> > 		strcpy(dest, src);
> > 		return src_size - 1;
> > 	} else {
> > 		return __strscpy(dest, src, count);
> > 	}
> > }
> > 
> > with the current strscpy renamed to __strscpy. I imagine it’s not necessary
> > to tie this to FORTIFY — __OPTIMIZE__ should be sufficient, shouldn’t it?
> > Although building on top of the fortified strcpy is reassuring, and I might
> > be missing something. I’m also not sure how to deal with the backing strscpy:
> > weak symbol, or something else... At least there aren’t (yet) any
> > arch-specific implementations of strscpy to deal with, but obviously they’d
> > still need to be supportable.
> > 
> > In my tests, this all gets optimised away, and we end up with code such as
> > 
> > 	strscpy(raead.type, "aead", sizeof(raead.type));
> > 
> > being compiled down to
> > 
> > 	movl    $1684104545, 4(%rsp)
> > 
> > on x86-64, and non-constant code being compiled down to a direct __strscpy
> > call.
> 
> Thanks for the details! Yeah, that seems nice. I wonder if there is a
> sensible way to combine these also with the stracpy*() proposal[1], so the
> call in your example above could just be:
> 
> 	stracpy(raead.type, "aead");
> 
> (It seems both proposals together would have the correct result...)
> 
> [1] https://lkml.kernel.org/r/201907221031.8B87A9DE@keescook

Easy enough to do.


