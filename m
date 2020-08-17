Return-Path: <SRS0=+e48=B3=lists.openwall.com=kernel-hardening-return-19649-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEAB4C433DF
	for <kernel-hardening@archiver.kernel.org>; Mon, 17 Aug 2020 19:37:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2347520716
	for <kernel-hardening@archiver.kernel.org>; Mon, 17 Aug 2020 19:37:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="E+bxGWQ4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2347520716
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19649-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19592 invoked by uid 550); 17 Aug 2020 19:37:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19568 invoked from network); 17 Aug 2020 19:37:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uSda/maq1kyFlmgdc9lPucbhxB4Rs/n3Ulbz/u//5ko=;
        b=E+bxGWQ4aloHMCGvC/C88Lm/LjqBzqUeliCrcozBEZMRKbyg+1uq3MbJHRL+u+fAgy
         rcfLJVPQZ9kKIBkXB0xoAGLmBb+lgoPAZlnS4ffebwSge6AqZOPLud4MtAVsUxyNCwLs
         808/MgaEYfc7LQRe31GlclDrcC3duq6vYQwQ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uSda/maq1kyFlmgdc9lPucbhxB4Rs/n3Ulbz/u//5ko=;
        b=l0HABXvhjj1rpa8Jy6FLhfe5uqjIC6CLu6du6nAzE+UwNGkSjrC7CxHRecgydl4Pbf
         vr9TRKEAw8zG9mHvkIJAu+/3x59eru458imob813NQKLtUSeqy3c1moFnX0u6UQfCj2W
         +jJWdv4g3R7YUuLl8TxoI1Rw3XWzj7xtfbrcMD0RJcH6hQXsG93wLdRg34Cv0YCI4+H1
         BP+upSCoQ4XVlBmoWZYX5adeJyAYYIB0krZ8A9/AVuqJtl6oMnhPwijJnqMGA7Ms/pLo
         dPHfcM7b5gb1pncCLK40/UEb29Z2NJn8GN7avHOMrarc27WBU/zAALEZIbGzQhdr44hq
         WrJQ==
X-Gm-Message-State: AOAM5322FOzeS0KByOO5CRihXNThQPl/MLYqQ/8cSGUNF7m7Ba9+1x4V
	ubn/Lxpt4X4VAXUbodcfocZK/A==
X-Google-Smtp-Source: ABdhPJzvvoBV3hMQrSf1AK6MLwM3KhYjHVP7hewssO8T6Pva04uXO9tD4vj9ZMjY0m+FhHm8dDndNg==
X-Received: by 2002:a65:63ca:: with SMTP id n10mr11219632pgv.252.1597693014022;
        Mon, 17 Aug 2020 12:36:54 -0700 (PDT)
Date: Mon, 17 Aug 2020 12:36:51 -0700
From: Kees Cook <keescook@chromium.org>
To: dsterba@suse.cz, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v2] overflow: Add __must_check attribute to check_*()
 helpers
Message-ID: <202008171235.816B3AD@keescook>
References: <202008151007.EF679DF@keescook>
 <20200817090854.GA2026@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817090854.GA2026@twin.jikos.cz>

On Mon, Aug 17, 2020 at 11:08:54AM +0200, David Sterba wrote:
> On Sat, Aug 15, 2020 at 10:09:24AM -0700, Kees Cook wrote:
> > +static inline bool __must_check __must_check_overflow(bool overflow)
> > +{
> > +	return unlikely(overflow);
> 
> How does the 'unlikely' hint propagate through return? It is in a static
> inline so compiler has complete information in order to use it, but I'm
> curious if it actually does.

It may not -- it depends on how the compiler decides to deal with it. :)

> In case the hint gets dropped, the fix would probably be
> 
> #define check_add_overflow(a, b, d) unlikely(__must_check_overflow(({	\
>  	typeof(a) __a = (a);			\
>  	typeof(b) __b = (b);			\
>  	typeof(d) __d = (d);			\
>  	(void) (&__a == &__b);			\
>  	(void) (&__a == __d);			\
>  	__builtin_add_overflow(__a, __b, __d);	\
> })))

Unfortunately not, as the unlikely() ends up eating the __must_check
attribute. :(

-- 
Kees Cook
