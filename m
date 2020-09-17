Return-Path: <SRS0=YdCl=C2=lists.openwall.com=kernel-hardening-return-19913-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF4E0C43464
	for <kernel-hardening@archiver.kernel.org>; Thu, 17 Sep 2020 22:05:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BF6C2206B6
	for <kernel-hardening@archiver.kernel.org>; Thu, 17 Sep 2020 22:05:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gZfnTVPq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF6C2206B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19913-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11665 invoked by uid 550); 17 Sep 2020 22:05:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11645 invoked from network); 17 Sep 2020 22:05:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RVejrFx8lqGVUKgRhIUmNAugSkLKO3AWaoC/1SxxcL0=;
        b=gZfnTVPqJkwyJQbCSxJtksOl0Wp3oPCryqhhzYqmD6nXS59iDI+KLW4Fe8f0f8zL3n
         /elUdPuoSqhgtEl2zfjQjTb/kbloI1vZr9vae5Jthw3imZMzfP9Eia8WaXmx3/Q3AM39
         b9Swp7NuoP77Vi0xXufmukO6fA00nsfebrOJI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RVejrFx8lqGVUKgRhIUmNAugSkLKO3AWaoC/1SxxcL0=;
        b=YtmRpsLb+ssorCkQp69XPgl0lir0ipIAAQ5aP8mnpLb1I1bHiXuLYTJr2OtPblo9NQ
         ImE4WJOSTrG5tFaLdva5fmDH4RXTxi0l1/gcNX1jI8lvdUSPGXoa3WAzxx19TXF6MCMf
         gQpMHHMtcoG1+CNx0w61zJvDHm6B4f8S+6nFISEiXAPCZXahqy/09f2UUGsgcus+8bf8
         mDxGck+oMD89CuC6xNZVjT0lZ3xP/y1PGUjfRLGrxflJZih/Xm8wSBqvXEHBBZ38y7PU
         5LZDNPOKe4S7Yjrd+z/oxkEKVcaojWSTw9sJAx7CXWa6PS1WrI9fMu9ybQcZS7skV0/k
         WPiw==
X-Gm-Message-State: AOAM531zZzvArTr6/g1ld0MvQCfnHqd6yJTiR/EpACwB0K6zIKC5ipk6
	E/lKlwPv6IuCQO4Ga6W729kjMg==
X-Google-Smtp-Source: ABdhPJxpTQhskINmsg7Ej2h7teJJR0+5sPJiS7FT04TblAYOWkDs4Jwx5Cao9/nMc6ypwIWmOhsmsw==
X-Received: by 2002:a63:1e0c:: with SMTP id e12mr6153286pge.346.1600380320847;
        Thu, 17 Sep 2020 15:05:20 -0700 (PDT)
Date: Thu, 17 Sep 2020 15:05:18 -0700
From: Kees Cook <keescook@chromium.org>
To: John Wood <john.wood@gmx.com>
Cc: Jann Horn <jannh@google.com>, kernel-hardening@lists.openwall.com,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Iurii Zaikin <yzaikin@google.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH 1/6] security/fbfam: Add a Kconfig to enable the
 fbfam feature
Message-ID: <202009171504.841FA53@keescook>
References: <20200910202107.3799376-1-keescook@chromium.org>
 <20200910202107.3799376-2-keescook@chromium.org>
 <202009101615.8566BA3967@keescook>
 <20200917175146.GB3637@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917175146.GB3637@ubuntu>

On Thu, Sep 17, 2020 at 08:40:06PM +0200, John Wood wrote:
> Hi,
> 
> On Thu, Sep 10, 2020 at 04:18:08PM -0700, Kees Cook wrote:
> > On Thu, Sep 10, 2020 at 01:21:02PM -0700, Kees Cook wrote:
> > > From: John Wood <john.wood@gmx.com>
> > >
> > > Add a menu entry under "Security options" to enable the "Fork brute
> > > force attack mitigation" feature.
> > >
> > > Signed-off-by: John Wood <john.wood@gmx.com>
> > > ---
> > >  security/Kconfig       |  1 +
> > >  security/fbfam/Kconfig | 10 ++++++++++
> > >  2 files changed, 11 insertions(+)
> > >  create mode 100644 security/fbfam/Kconfig
> > >
> > > diff --git a/security/Kconfig b/security/Kconfig
> > > index 7561f6f99f1d..00a90e25b8d5 100644
> > > --- a/security/Kconfig
> > > +++ b/security/Kconfig
> > > @@ -290,6 +290,7 @@ config LSM
> > >  	  If unsure, leave this as the default.
> > >
> > >  source "security/Kconfig.hardening"
> > > +source "security/fbfam/Kconfig"
> >
> > Given the layout you've chosen and the interface you've got, I think
> > this should just be treated like a regular LSM.
> 
> Yes, throughout the review it seems the most appropiate is treat
> this feature as a regular LSM. Thanks.
> 
> > >
> > >  endmenu
> > >
> > > diff --git a/security/fbfam/Kconfig b/security/fbfam/Kconfig
> > > new file mode 100644
> > > index 000000000000..bbe7f6aad369
> > > --- /dev/null
> > > +++ b/security/fbfam/Kconfig
> > > @@ -0,0 +1,10 @@
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +config FBFAM
> >
> > To jump on the bikeshed: how about just calling this
> > FORK_BRUTE_FORCE_DETECTION or FORK_BRUTE, and the directory could be
> > "brute", etc. "fbfam" doesn't tell anyone anything.
> 
> Understood. But how about use the fbfam abbreviation in the code? Like as
> function name prefix, struct name prefix, ... It would be better to use a
> more descriptive name in this scenario? It is not clear to me.

I don't feel too strongly, but I think having the CONFIG roughly match
the directory name, roughly match the function prefixes should be best.
Maybe call the directory and function prefix "brute"?

-- 
Kees Cook
