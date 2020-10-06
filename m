Return-Path: <SRS0=PFtE=DN=lists.openwall.com=kernel-hardening-return-20109-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC80C41604
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Oct 2020 05:57:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1758E2078A
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Oct 2020 05:57:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="lIzQwVFz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1758E2078A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20109-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19723 invoked by uid 550); 6 Oct 2020 05:57:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19688 invoked from network); 6 Oct 2020 05:57:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gx4WOvLZE+8XVE2Cbj1TNlsvQN+bEc7hhbjF/tgIFks=;
        b=lIzQwVFztGvCS46aamlT+Zp90+6vgiZYuYVYPYCJ266iK/uoWXyEyrXdL+ASF2Rpqj
         ZMXs/jATshsL6nNxJIJtjbFrXbBtj+7EKt0zWl0QpYwJSVFxB/yglLqM6l06tKlgg73j
         pP+effqg9e6dsJyuFUrqtstsMcZCr/eCqWXu0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gx4WOvLZE+8XVE2Cbj1TNlsvQN+bEc7hhbjF/tgIFks=;
        b=Ok0syvvBhKFtdt3DtapHN0gPNH70NtO4LlQBxZq49nWWS98D6qDzck3gfB9l2iDR7d
         7hbj90EUbg4JFu75rs+BG6HfKJ2DUWAy5PUGkQld9cR0LQs9gu4ASBCjtMMGoUO9E7To
         48Joy+Veqcf4860d+J5n7VYxCIbh5RcQDpoKJzpQJmV9GOUIUIRmbdP5ZPgwP1zFCyoi
         Q9WBnhjBZmAQTNz6G3ju6OWb3o61IFdXoNhJj7eM/Ybn3DIAj/FNMWfC63WaCe8yPiDP
         nfrSgf1CvseyA3lDc+n5q7nZackpXVx8Ex3TOVwzZPeudyIvQA5hQYJ4UZ8No13lxWg2
         xoVA==
X-Gm-Message-State: AOAM53263UGHEAUfrv1y5krKv5uW+k5MCkbZTLc5Dyl/TATNEEvGPVN5
	TM/HkXlcTd2uTA7xQuolIt8JyQ==
X-Google-Smtp-Source: ABdhPJyyhqIDHGy7mDnDHpQB09ZhAu+H7/Ucq2xIm6TB1CInHA8Hx4CXWDmYBVa2VyTjeL4m+tfnaA==
X-Received: by 2002:a17:90a:8007:: with SMTP id b7mr274521pjn.84.1601963849512;
        Mon, 05 Oct 2020 22:57:29 -0700 (PDT)
Date: Mon, 5 Oct 2020 22:57:27 -0700
From: Kees Cook <keescook@chromium.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Emese Revfy <re.emese@gmail.com>, Theodore Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] random32: Restore __latent_entropy attribute on
 net_rand_state
Message-ID: <202010052257.CB8E47E@keescook>
References: <20201002151610.24258-1-thibaut.sautereau@clip-os.org>
 <202010051910.BC7E9F4@keescook>
 <20201006022808.GA5531@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006022808.GA5531@1wt.eu>

On Tue, Oct 06, 2020 at 04:28:09AM +0200, Willy Tarreau wrote:
> Hi Kees,
> 
> On Mon, Oct 05, 2020 at 07:12:29PM -0700, Kees Cook wrote:
> > On Fri, Oct 02, 2020 at 05:16:11PM +0200, Thibaut Sautereau wrote:
> > > From: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> > > 
> > > Commit f227e3ec3b5c ("random32: update the net random state on interrupt
> > > and activity") broke compilation and was temporarily fixed by Linus in
> > > 83bdc7275e62 ("random32: remove net_rand_state from the latent entropy
> > > gcc plugin") by entirely moving net_rand_state out of the things handled
> > > by the latent_entropy GCC plugin.
> > > 
> > > From what I understand when reading the plugin code, using the
> > > __latent_entropy attribute on a declaration was the wrong part and
> > > simply keeping the __latent_entropy attribute on the variable definition
> > > was the correct fix.
> > > 
> > > Fixes: 83bdc7275e62 ("random32: remove net_rand_state from the latent entropy gcc plugin")
> > > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > > Cc: Willy Tarreau <w@1wt.eu>
> > > Cc: Emese Revfy <re.emese@gmail.com>
> > > Signed-off-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> > 
> > Yes, that looks correct. Thank you!
> > 
> > Acked-by: Kees Cook <keescook@chromium.org>
> > 
> > I'm not sure the best tree for this. Ted, Andrew, Linus? I'll take it
> > via my gcc plugin tree if no one else takes it. :)
> 
> It was already merged as commit 09a6b0bc3be79 and queued for -stable.

Ah, perfect! Thanks.

-- 
Kees Cook
