Return-Path: <SRS0=rMGE=YD=lists.openwall.com=kernel-hardening-return-17008-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B33C4360C
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Oct 2019 22:31:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C283D214E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Oct 2019 22:31:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jqhoan3M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C283D214E0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17008-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28520 invoked by uid 550); 10 Oct 2019 22:31:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28487 invoked from network); 10 Oct 2019 22:31:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ev/d6Je830uwoBCWDVb3eTZLuxKiQ4MMnBctxfQpBVU=;
        b=jqhoan3MF6olnmMqFY1BuET+CyWitf6WOb/0mKhl8tb839/xzq9H1+kYKZ/tbuvVsj
         IkvJooT5/x0qAhnjrlMUkkLLQwVFzSHm/ET+SJmujvx6iz1eHECppWdtCJRT40cenzU3
         hYx1Aucyqhh0ui4xJ7t47ySOJ2AqHieYpHh0I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ev/d6Je830uwoBCWDVb3eTZLuxKiQ4MMnBctxfQpBVU=;
        b=T8r70P+Bu0cwpHzFl/AjtgGzWnBABGMctxmY7b23DA+ewySfKCHbnxcyjr/fMS1tYv
         HcgWdiNKkD00fK3F/P6D1ce0GeEphvjQECt6572FMlzunmLeqIidwP2q8EtPElYfqsWI
         7z6BehuMwVQYweSiMRVtvbqeWK8350uXhH3hs6JJHWUzA4xznX8LrfRNSFmRFdHXzI8j
         ieZKEIjdKDi+wn2VckNFbeJbdMyHxLo+3W7nr64xIwogXcXIlSVJIfNl/cpeMfufziT7
         zBz7Uki3jc0IvH6hYcXmZAUkRWqYPmXdAR1l0IyGKfuiSa49+/Q5qDES76yovDwXpsWX
         T8cw==
X-Gm-Message-State: APjAAAWZT6HyatjL6TgKiJIe2FOzs8xe6N3etqu9mVn/Z+/IfGEeM3VI
	O91dMLIgNDO1ouB3jIQNasmMDmhy9vg=
X-Google-Smtp-Source: APXvYqw5UjhkHTNzDLtB4unZIZ2vNhZ7kUh2TPglUK86LPS0negWDIT0iy0T5ilwU04fXzV2/BrFbA==
X-Received: by 2002:a62:1c82:: with SMTP id c124mr13414244pfc.163.1570746654632;
        Thu, 10 Oct 2019 15:30:54 -0700 (PDT)
Date: Thu, 10 Oct 2019 15:30:52 -0700
From: Kees Cook <keescook@chromium.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: [PRE-REVIEW PATCH 11/16] treewide: Globally replace
 tasklet_init() by tasklet_setup()
Message-ID: <201910101529.D6550C790D@keescook>
References: <20190929163028.9665-1-romain.perier@gmail.com>
 <20190929163028.9665-12-romain.perier@gmail.com>
 <201909301545.913F7805AB@keescook>
 <20191001171828.GB2748@debby.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191001171828.GB2748@debby.home>

On Tue, Oct 01, 2019 at 07:18:28PM +0200, Romain Perier wrote:
> On Mon, Sep 30, 2019 at 03:46:29PM -0700, Kees Cook wrote:
> > On Sun, Sep 29, 2019 at 06:30:23PM +0200, Romain Perier wrote:
> > > This converts all remaining cases of the old tasklet_init() API into
> > > tasklet_setup(), where the callback argument is the structure already
> > > holding the struct tasklet_struct. These should have no behavioral changes,
> > > since they just change which pointer is passed into the callback with
> > > the same available pointers after conversion. Moreover, all callbacks
> > > that were not passing a pointer of structure holding the struct
> > > tasklet_struct has already been converted.
> > 
> > Was this done mechanically with Coccinelle or manually? (If done with
> > Coccinelle, please include the script in the commit log.) To land a
> > treewide change like this usually you'll need to separate the mechanical
> > from the manual as Linus likes to run those changes himself sometimes.
> 
> Hi,
> 
> This was done with both technics mechanically with a "buggy" Coccinelle
> script, after what I have fixed building errors and mismatches (even if it's
> clearly super powerful, it was my first complex cocci script). 80% of trivial
> replacements were done with a Cocci script, the rest was done manually.
> That's complicated to remember which one was mechanically or manually to
> be honnest :=D
> 
> What I can propose is the following:
> 
> - A commit for trivial tasklet_init() -> tasklet_setup() replacements:
>   it would contain basic replacements of the calls "tasklet_init() ->
>   tasklet_setup()" and addition of "from_tasklet()" without any other
>   changes.

Right -- the manual ones might need to be split up by subsystem or
driver.

> - A second commit for more complicated replacements:
>   It would contain replacements of functions that are in different
>   modules, or modules that use function pointer for tasklet handlers
>   etc... Basically everything that is not covered by the first commit

Same for this if it can't be automated.

> What do you think ?
> Moreover, the cocci script I have used is... ugly... so I don't want to
> see Linus's eyes bleed :=D

Heh. Well, the timer_struct Cocci script was ugly too. The idea is that
maintainers will likely want per-driver patches, so the more you can
automate with a script to put in a single commit for Linus would be
better for your own sanity. :)

> PS: I can try to recover the cocci script in my git repo by using "git
> reflog". And put the cocci script in the first commit (for trivial
> replacements), in the worst case...

Probably it is only needed in the commit log.

-- 
Kees Cook
