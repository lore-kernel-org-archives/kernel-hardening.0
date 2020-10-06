Return-Path: <SRS0=JgKd=DN=lists.openwall.com=kernel-hardening-return-20105-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD583C4363A
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Oct 2020 02:12:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BE7CE2085B
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Oct 2020 02:12:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Qxk3h4dI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE7CE2085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20105-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7604 invoked by uid 550); 6 Oct 2020 02:12:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7565 invoked from network); 6 Oct 2020 02:12:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VZRD+TMaL8IPQ0MGbmyliD18F5b146FgOWwgTc6dgq4=;
        b=Qxk3h4dI0WGdYw3MgojRy3uS/mvhPwWzlYo/2snbGBUZgqXvojT2aIw2SZNRj7ahCC
         Dsc457ZOM4KJAIYzcXJphrjNvv7Ix2ADoPqRBGeYI39hntpFj/WvtjN1Uu9O29p0Yxce
         1Toi3J6qBr54e1SZCFb4ekFCzxtw+4I88tsNM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VZRD+TMaL8IPQ0MGbmyliD18F5b146FgOWwgTc6dgq4=;
        b=lvUmvTwxUOM2j+zIc9P0+rHS21lecr2Zf+HET3SyQ3uIHg4a99fbidZ85sVYc8ZbGz
         bCZoPVmKLe2lD3VPeb0VnrOATNCwp2dWWcdtwCLtOL2FWAlKPiz6KNXVxpoNvQ8ZcH/i
         mHUJDzB/Yg/wCzFUiknrj7NFSA69WqBDPwT3+sKk+rj8BOkfM+XSh7ZCupb8zS7Xb+ya
         pB7AWelG5H6JsqFV2oDDe9f2+BzaL0HSEU3gZLY2oF7rNCGhZoLJtTaLQpcZM9BfJG4I
         DZCXb9hkqZ7ZEBJZ1IWKEjVEN9kdxelWXtElD/Ve5BP0z1WvrF2QTCAxaKHHOPTuC5gR
         hYuA==
X-Gm-Message-State: AOAM531Iai9KcpmRDvJBzlo4X/9aiCFb8JZ+H93GajxW5f4zYU0DM5Jj
	dSIU7gpqDQFCZKoRZyAeptiLrA==
X-Google-Smtp-Source: ABdhPJyVFFS9wGSPx2kS3ePT3bDnzMoFQeQuxGgqj3ijS0b1+VmeQQ38aHDXOr3umuIHUuzRADHQMA==
X-Received: by 2002:aa7:97a8:0:b029:13e:d13d:a105 with SMTP id d8-20020aa797a80000b029013ed13da105mr2299234pfq.33.1601950351477;
        Mon, 05 Oct 2020 19:12:31 -0700 (PDT)
Date: Mon, 5 Oct 2020 19:12:29 -0700
From: Kees Cook <keescook@chromium.org>
To: Thibaut Sautereau <thibaut.sautereau@clip-os.org>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Willy Tarreau <w@1wt.eu>, Emese Revfy <re.emese@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] random32: Restore __latent_entropy attribute on
 net_rand_state
Message-ID: <202010051910.BC7E9F4@keescook>
References: <20201002151610.24258-1-thibaut.sautereau@clip-os.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002151610.24258-1-thibaut.sautereau@clip-os.org>

On Fri, Oct 02, 2020 at 05:16:11PM +0200, Thibaut Sautereau wrote:
> From: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> 
> Commit f227e3ec3b5c ("random32: update the net random state on interrupt
> and activity") broke compilation and was temporarily fixed by Linus in
> 83bdc7275e62 ("random32: remove net_rand_state from the latent entropy
> gcc plugin") by entirely moving net_rand_state out of the things handled
> by the latent_entropy GCC plugin.
> 
> From what I understand when reading the plugin code, using the
> __latent_entropy attribute on a declaration was the wrong part and
> simply keeping the __latent_entropy attribute on the variable definition
> was the correct fix.
> 
> Fixes: 83bdc7275e62 ("random32: remove net_rand_state from the latent entropy gcc plugin")
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Willy Tarreau <w@1wt.eu>
> Cc: Emese Revfy <re.emese@gmail.com>
> Signed-off-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>

Yes, that looks correct. Thank you!

Acked-by: Kees Cook <keescook@chromium.org>

I'm not sure the best tree for this. Ted, Andrew, Linus? I'll take it
via my gcc plugin tree if no one else takes it. :)

-- 
Kees Cook
