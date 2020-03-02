Return-Path: <SRS0=yBj9=4T=lists.openwall.com=kernel-hardening-return-18037-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD3D7C3F2CD
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Mar 2020 15:29:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 08B6B2084E
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Mar 2020 15:29:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho-ws.20150623.gappssmtp.com header.i=@tycho-ws.20150623.gappssmtp.com header.b="Ka8fcbUo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08B6B2084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=tycho.ws
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18037-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5708 invoked by uid 550); 2 Mar 2020 15:29:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5676 invoked from network); 2 Mar 2020 15:29:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tycho-ws.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZELvoTh0xXCJ16TM4LMcgSPymnk+qgV/Io9vwrxStOI=;
        b=Ka8fcbUomoExO8dMtRavZ6xdQDFoqTL+dMYjjXJnplJQqNty6kInHp/SA8oQqkNfoc
         mGep+DT/B7MFOUmHtYk3Eyuppv9vkrOcmRjAuJUUYww44Ms+jsBHeJpww+mCDbHSZAAo
         RBzbstkJYS1XpxL0UmA1+0+jaBFLusmx5PUpRtILwXTlfTbNUuTesemYQ7OGCVxovv3j
         DF0Aed3Nhf2ftEM8pWNsvWYJC8mmM6oEG2lFzB7anqXDcc8Z8x/65c9/4D2oV9vGlHyq
         ry9YkJu6JP4Kr19aM9RJmNgMs/42jsFIay1p87AEAgxzNxMwLhQXcz+W8wNEcv4h32Rx
         rgwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZELvoTh0xXCJ16TM4LMcgSPymnk+qgV/Io9vwrxStOI=;
        b=VKWOpZ64SpkiNjqzPFIwMtZLd6nHiuLIxttxq/1D56tFV+Tzf4PuWpK6JDqEdj+VLe
         MDDKpYrrgh6akfCEm2MbJmMXCVQgU0CliyJ00RnLAG9NHu4mGY21Jfm/VlRF17QokLmM
         JTbDAYTxM43aaI5O3VrA9mYBx0z0ue1LthJMqHvZvjm+zy95DCtKV+y85SrOUoSvUW7Z
         R9NRt8tPFyobQpj9RXB7EKI5rDCGjjowUmJYtmrtHqye/ffyCVJEgCKyk9g9dduJE1iI
         ea3GhF+a0IBLLamDjYdHn+Qw71edTsrG4mY4nkXWPK4MLxgLMzpUccja0KRi99t+gljN
         Ysag==
X-Gm-Message-State: APjAAAWqdtaA5BULmRfcEFg2vlRWcMvI0/XH45PLokd4dD29hkhKPwtT
	noC+jih4lBBnrZ+6M1siXxcX7g==
X-Google-Smtp-Source: APXvYqyxlU/eQXwoIsbmUvLYYQ4AbS80Gp7//bZAGJ2KIFGK4BxXwB+sNYYCGL1sq8Z5F8aZXJNFig==
X-Received: by 2002:a17:902:b40c:: with SMTP id x12mr18636387plr.70.1583162953095;
        Mon, 02 Mar 2020 07:29:13 -0800 (PST)
Date: Mon, 2 Mar 2020 08:29:09 -0700
From: Tycho Andersen <tycho@tycho.ws>
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: "Tobin C . Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com,
	Kees Cook <keescook@chromium.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86/mm/init_32: Stop printing the virtual memory
 layout
Message-ID: <20200302152909.GA7777@cisco>
References: <202002291534.ED372CC@keescook>
 <20200301002209.1304982-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200301002209.1304982-1-nivedita@alum.mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Sat, Feb 29, 2020 at 07:22:09PM -0500, Arvind Sankar wrote:
> For security, don't display the kernel's virtual memory layout.
> 
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>

Acked-by: Tycho Andersen <tycho@tycho.ws>
