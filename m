Return-Path: <SRS0=mVYc=4W=lists.openwall.com=kernel-hardening-return-18082-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 140EFC3F2D1
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 17:35:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 672AF2072D
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 17:35:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="LWAX/mnH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 672AF2072D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18082-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1980 invoked by uid 550); 5 Mar 2020 17:35:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1945 invoked from network); 5 Mar 2020 17:35:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xEAJ1NUXPHu81BkE5lRF70aT//8/AuwgSjMAA/AA9VY=;
        b=LWAX/mnHWCEyMQS79Ze1HibVuhsx2iRhWybu/OIfRIhEMmxafA+jO26+0CcM8GqZKp
         bj465loQBo/50XZIGBZ/ylnMWfJX66dz1JBN7/OtzDfydSHSgNy9SDYwXcCo8Xg96Vmr
         Yt9ah3j9GlG/34Y7n1Z4iDB3Jgr4sgDvvLFHM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xEAJ1NUXPHu81BkE5lRF70aT//8/AuwgSjMAA/AA9VY=;
        b=SC5iebEMnKv6sQ4OAk9Ls8wwzkHHSBDxqPpyr1GiWWzcm9K0TpbAJ6vXqFBSqu4KqC
         360YtkEcnKgitaaQUYr2ltboYMfh3ifHXz9IkVV1iqbngwGP6/aWEwSH1KrfKCUTDjPp
         F1gmJRCfHJhN4FWinWN80E+v7GfGwkK/FxYdGE5y7oLB+97EEee5hoiN/GxtKMB+h3vL
         8EdDhA9+pW+4BPvNZ4H8KizclNJJdlSVs8NsgyJWzCddFnNdn4yTNhxm+NR3vJYE8EaG
         4SjDiDKjy6fNwPibYDQ+zAazpuT+PebMhBGAypBzBkLMIqyyVnQUb0sOgvRKwiT32iRQ
         y5Hw==
X-Gm-Message-State: ANhLgQ1kFSyXr3BwLYwg1SDQOM4cnd+LpJumijskpoNR0x7UXKXd0otI
	hM3DaB1/boIvUv9jJ03y7J7oxz6FeLc=
X-Google-Smtp-Source: ADFU+vuqTfC7B4BJz1/7pVQ/CWvKBqNiVRzuaTrFyEVgzlwk4wZWRxHJIk8rQLzAzPTg3iuU6kJDPA==
X-Received: by 2002:a63:7f14:: with SMTP id a20mr3441343pgd.428.1583429689456;
        Thu, 05 Mar 2020 09:34:49 -0800 (PST)
Date: Thu, 5 Mar 2020 09:34:47 -0800
From: Kees Cook <keescook@chromium.org>
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Joe Perches <joe@perches.com>, "Tobin C . Harding" <me@tobin.cc>,
	Tycho Andersen <tycho@tycho.ws>,
	kernel-hardening@lists.openwall.com,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh: Stop printing the virtual memory layout
Message-ID: <202003050933.14BDEDBF1@keescook>
References: <202003021038.8F0369D907@keescook>
 <20200305151010.835954-1-nivedita@alum.mit.edu>
 <f672417e-1323-4ef2-58a1-1158c482d569@physik.fu-berlin.de>
 <31d1567c4c195f3bc5c6b610386cf0f559f9094f.camel@perches.com>
 <3c628a5a-35c7-3d92-b94b-23704500f7c4@physik.fu-berlin.de>
 <20200305154657.GA848330@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305154657.GA848330@rani.riverdale.lan>

On Thu, Mar 05, 2020 at 10:46:58AM -0500, Arvind Sankar wrote:
> On Thu, Mar 05, 2020 at 04:41:05PM +0100, John Paul Adrian Glaubitz wrote:
> > On 3/5/20 4:38 PM, Joe Perches wrote:
> > >> Aww, why wasn't this made configurable? I found these memory map printouts
> > >> very useful for development.
> > > 
> > > It could be changed from pr_info to pr_devel.
> > > 
> > > A #define DEBUG would have to be added to emit it.
> > 
> > Well, from the discussion it seems the decision to cut it out has already been
> > made, so I guess it's too late :(.
> > 
> > Adrian
> > 
> > -- 
> >  .''`.  John Paul Adrian Glaubitz
> > : :' :  Debian Developer - glaubitz@debian.org
> > `. `'   Freie Universitaet Berlin - glaubitz@physik.fu-berlin.de
> >   `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
> 
> Not really too late. I can do s/pr_info/pr_devel and resubmit.
> 
> parisc for eg actually hides this in #if 0 rather than deleting the
> code.
> 
> Kees, you fine with that?

I don't mind pr_devel(). ("#if 0" tends to lead to code-rot since it's
not subjected to syntax checking in case the names of things change.)
That said, it's really up to the arch maintainers.

-- 
Kees Cook
