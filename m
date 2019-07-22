Return-Path: <SRS0=Lez8=VT=lists.openwall.com=kernel-hardening-return-16528-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,LOTS_OF_MONEY,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9B77C76190
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 17:50:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4DDD421901
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 17:50:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CXl0D6bg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DDD421901
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16528-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23965 invoked by uid 550); 22 Jul 2019 17:50:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23929 invoked from network); 22 Jul 2019 17:50:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=EydYv65e83oetehWJiFXQMJntcT2fvfp15FyorV7npo=;
        b=CXl0D6bgk/eTPheCyRT3F6xn5TUDB8UaUgfM2JJclOnmCyaMCzTt4LO4C+O8KJFCll
         5VwB6NtqbQSCacBzC4JUL0KiVTcReEmBB75zhGCSz4MKLU6pZKrufpw6o6MMCQFDO6vX
         AijVsKh+7rkTYIyD+uN4sXN+goXir8D0+zVMQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EydYv65e83oetehWJiFXQMJntcT2fvfp15FyorV7npo=;
        b=fN02sHE3+ewsr/H2sNDNAq04vBuJfKGHGLObNZUrhSrYHbFU+RRdajPp7Xe4p/VSHh
         S25lU40G9saKFjuk0X6lZeKxmCnmPrpvnjTXFIgAg8QjpNc955NvdEsRyIBR/gDMnCc1
         d1OsAXAgU/VLJx71N4CqaYwjSudxgFsqmCoEb2FvClzF5tkHoh9bnUVf8lY+SVmAMVjN
         /1omfFNfypRibyDXrGnDGGU6RYMf1s0iqjjOvXzEIc1k2dQ5oiN88oBcrbrGhcQQJK0t
         Omi3I6FyGX5dxN4h7CnqRu3roNka04yJxI9dCHpMimqjyZXGTbyaoBNccLz7AVNWYXJX
         73Ng==
X-Gm-Message-State: APjAAAXnenKn8GaNh1et4r7XZLVc72yBsLk7DsHjx4VrKUmLbeNeNPjC
	cLMrnDpmUq9UANXa152sA/IiqG2+xAk=
X-Google-Smtp-Source: APXvYqw4LSNCWCxQ/yLJp59WHPmP2/0qp/JIrEN32DV882tVN30ScL0zOniDXe6YQc0xt3HY2pfVKw==
X-Received: by 2002:a17:902:9a95:: with SMTP id w21mr19131904plp.126.1563817815105;
        Mon, 22 Jul 2019 10:50:15 -0700 (PDT)
Date: Mon, 22 Jul 2019 10:50:13 -0700
From: Kees Cook <keescook@chromium.org>
To: Stephen Kitt <steve@sk2.org>
Cc: Nitin Gote <nitin.r.gote@intel.com>, jannh@google.com,
	kernel-hardening@lists.openwall.com, Joe Perches <joe@perches.com>,
	corbet@lwn.net, linux-kernel@vger.kernel.org,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH] checkpatch: Added warnings in favor of strscpy().
Message-ID: <201907221047.4895D35B30@keescook>
References: <1561722948-28289-1-git-send-email-nitin.r.gote@intel.com>
 <20190629181537.7d524f7d@sk2.org>
 <201907021024.D1C8E7B2D@keescook>
 <20190706144204.15652de7@heffalump.sk2.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190706144204.15652de7@heffalump.sk2.org>

On Sat, Jul 06, 2019 at 02:42:04PM +0200, Stephen Kitt wrote:
> On Tue, 2 Jul 2019 10:25:04 -0700, Kees Cook <keescook@chromium.org> wrote:
> > On Sat, Jun 29, 2019 at 06:15:37PM +0200, Stephen Kitt wrote:
> > > On Fri, 28 Jun 2019 17:25:48 +0530, Nitin Gote <nitin.r.gote@intel.com>
> > > wrote:  
> > > > 1. Deprecate strcpy() in favor of strscpy().  
> > > 
> > > This isn’t a comment “against” this patch, but something I’ve been
> > > wondering recently and which raises a question about how to handle
> > > strcpy’s deprecation in particular. There is still one scenario where
> > > strcpy is useful: when GCC replaces it with its builtin, inline version...
> > > 
> > > Would it be worth introducing a macro for strcpy-from-constant-string,
> > > which would check that GCC’s builtin is being used (when building with
> > > GCC), and fall back to strscpy otherwise?  
> > 
> > How would you suggest it operate? A separate API, or something like the
> > existing overloaded strcpy() macros in string.h?
> 
> The latter; in my mind the point is to simplify the thought process for
> developers, so strscpy should be the “obvious” choice in all cases, even when
> dealing with constant strings in hot paths. Something like
> 
> __FORTIFY_INLINE ssize_t strscpy(char *dest, const char *src, size_t count)
> {
> 	size_t dest_size = __builtin_object_size(dest, 0);
> 	size_t src_size = __builtin_object_size(src, 0);
> 	if (__builtin_constant_p(count) &&
> 	    __builtin_constant_p(src_size) &&
> 	    __builtin_constant_p(dest_size) &&
> 	    src_size <= count &&
> 	    src_size <= dest_size &&
> 	    src[src_size - 1] == '\0') {
> 		strcpy(dest, src);
> 		return src_size - 1;
> 	} else {
> 		return __strscpy(dest, src, count);
> 	}
> }
> 
> with the current strscpy renamed to __strscpy. I imagine it’s not necessary
> to tie this to FORTIFY — __OPTIMIZE__ should be sufficient, shouldn’t it?
> Although building on top of the fortified strcpy is reassuring, and I might
> be missing something. I’m also not sure how to deal with the backing strscpy:
> weak symbol, or something else... At least there aren’t (yet) any
> arch-specific implementations of strscpy to deal with, but obviously they’d
> still need to be supportable.
> 
> In my tests, this all gets optimised away, and we end up with code such as
> 
> 	strscpy(raead.type, "aead", sizeof(raead.type));
> 
> being compiled down to
> 
> 	movl    $1684104545, 4(%rsp)
> 
> on x86-64, and non-constant code being compiled down to a direct __strscpy
> call.

Thanks for the details! Yeah, that seems nice. I wonder if there is a
sensible way to combine these also with the stracpy*() proposal[1], so the
call in your example above could just be:

	stracpy(raead.type, "aead");

(It seems both proposals together would have the correct result...)

[1] https://lkml.kernel.org/r/201907221031.8B87A9DE@keescook

-- 
Kees Cook
