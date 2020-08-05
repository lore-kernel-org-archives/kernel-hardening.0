Return-Path: <SRS0=NkEb=BP=lists.openwall.com=kernel-hardening-return-19562-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 970EFC433DF
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 Aug 2020 20:50:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D850922B42
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 Aug 2020 20:50:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="AMi6K8LK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D850922B42
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19562-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26294 invoked by uid 550); 5 Aug 2020 20:50:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26270 invoked from network); 5 Aug 2020 20:50:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IX9XrPUzOcyKkpmBN/wRczSmpUnTjA2wU4ML+y9lkZ8=;
        b=AMi6K8LKX1VQCBDo+8/FHHEO12L0113YiFMtxUoRuvYnMXNOau5IOsAMJBeoHyUPvz
         syaxTLjdh0s5hixSX2+615yeJbMX/icq96mS0El/s59+/3aYS6wjSZ9cpm/gCZWiUtLP
         wCNGlh9BDMAoEeOqKiBE7ODo4wL8f+Cmx1wIQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IX9XrPUzOcyKkpmBN/wRczSmpUnTjA2wU4ML+y9lkZ8=;
        b=b9Kn0QV18aT9SJY0aEkYT/jifPuMNlQ1KGZGz6vAM8pb6vX1XIzCcpAw3ALBKh7VIT
         7Yqnj7+Mt+UIC1Bom4yjffXo+KJ7AXUl9TspnWGIN6fhhDyP3UY3poWg/Fj4JxjfavRj
         cnkqi664s3nLbWWBzPIGbgjzF7eu/fIFFfmutfd6udHQG9javskxkWKYKasz0JMEqEW5
         +pKWOwxjIzkcArGbrB6agTjJY3DE12+qEx6kKa2P75uGVI+5iKI2fcGGsdz8HXxNjUqY
         +lmNqEzfPLpzbvi3I550hVvFa+eVqeJc8qsdoJ78emRFbcgsMRud39yCnztBjh3q8lFO
         uQyg==
X-Gm-Message-State: AOAM531WqxqhtPfJA8RVxYALYOKEVC5ltpZdjgmuLqTi4OmHpwaA/BlS
	MFtZUheBk+r1IKsjkcSwpB4lcg==
X-Google-Smtp-Source: ABdhPJxyidMPujgN2fn9cGhCwYoULrrcvpnTqk0YBB0eSUmdPS1OzUXvCVsfSSkTOPx8c3h7OefOiA==
X-Received: by 2002:a17:90a:f012:: with SMTP id bt18mr4586168pjb.63.1596660625999;
        Wed, 05 Aug 2020 13:50:25 -0700 (PDT)
Date: Wed, 5 Aug 2020 13:50:24 -0700
From: Kees Cook <keescook@chromium.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [RFC] saturate check_*_overflow() output?
Message-ID: <202008051349.553E49E12@keescook>
References: <202008031118.36756FAD04@keescook>
 <f177a821-74a3-e868-81d3-55accfb5b161@rasmusvillemoes.dk>
 <202008041137.02D231B@keescook>
 <6d190601-68f1-c086-97ac-2ee1c08f5a34@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d190601-68f1-c086-97ac-2ee1c08f5a34@rasmusvillemoes.dk>

On Wed, Aug 05, 2020 at 01:38:58PM +0200, Rasmus Villemoes wrote:
> Anyway, we don't need to apply it to the last expression inside ({}), we
> can just pass the whole ({}) to must_check_overflow() as in
> 
> -#define check_sub_overflow(a, b, d) ({         \
> +#define check_sub_overflow(a, b, d) must_check_overflow(({             \

Oh! Yes, of course. I was blinded by looking inside the macro and not
wanting to spoil the type magic. Yes, that's perfect. I will spin a
patch...

-- 
Kees Cook
