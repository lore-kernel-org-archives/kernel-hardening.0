Return-Path: <kernel-hardening-return-21700-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 66D69CD68EE
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Oct 2023 06:18:10 +0000 (UTC)
Received: (qmail 13765 invoked by uid 550); 10 Oct 2023 06:17:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13727 invoked from network); 10 Oct 2023 06:17:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696918665;
	bh=YJVdJBcR0G+dWvkRN0BrKIFst4P2/slXP3g2G4ZEtKc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UjscamohYOsADCQsJqSgnaP36kG1L9kTDJ1SwWHgPFG9NFWOOOfgydg+rnfpqAlf5
	 IQmX/5rEGOQ+Inkn/Wr5EbY9qKHAiamucD+ftlIlWFovfNk+HW7BcrVlOBANcQA4I9
	 NGcrKn+p6H4BVTANq6m/L+vDCBk/Wxtz/icGRDP4=
Date: Tue, 10 Oct 2023 08:17:42 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: =?iso-8859-1?Q?G=FCnther?= Noack <gnoack@google.com>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Hanno =?iso-8859-1?Q?B=F6ck?= <hanno@hboeck.de>,
	kernel-hardening@lists.openwall.com,
	Jiri Slaby <jirislaby@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Paul Moore <paul@paul-moore.com>,
	David Laight <David.Laight@aculab.com>,
	Simon Brand <simon.brand@postadigitale.de>,
	Dave Mielke <Dave@mielke.cc>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	KP Singh <kpsingh@google.com>,
	Nico Schottelius <nico-gpm2008@schottelius.org>
Subject: Re: [PATCH v3 0/1] Restrict access to TIOCLINUX
Message-ID: <2023101045-stride-auction-1b9e@gregkh>
References: <20230828164117.3608812-1-gnoack@google.com>
 <20230828164521.tpvubdufa62g7zwc@begin>
 <ZO3r42zKRrypg/eM@google.com>
 <ZQRc7e0l2SjsCB5m@google.com>
 <202310091319.F1D49BC30B@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202310091319.F1D49BC30B@keescook>

On Mon, Oct 09, 2023 at 01:19:47PM -0700, Kees Cook wrote:
> On Fri, Sep 15, 2023 at 03:32:29PM +0200, Günther Noack wrote:
> > On Tue, Aug 29, 2023 at 03:00:19PM +0200, Günther Noack wrote:
> > > Let me update the list of known usages then: The TIOCL_SETSEL, TIOCL_PASTESEL
> > > and TIOCL_SELLOADLUT mentions found on codesearch.debian.net are:
> > > 
> > > (1) Actual invocations:
> > > 
> > >  * consolation:
> > >      "consolation" is a gpm clone, which also runs as root.
> > >      (I have not had the chance to test this one yet.)
> > 
> > I have tested the consolation program with a kernel that has the patch, and it
> > works as expected -- you can copy and paste on the console.
> > 
> > 
> > >  * BRLTTY:
> > >      Uses TIOCL_SETSEL as a means to highlight portions of the screen.
> > >      The TIOCSTI patch made BRLTTY work by requiring CAP_SYS_ADMIN,
> > >      so we know that BRLTTY has that capability (it runs as root and
> > >      does not drop it).
> > > 
> > > (2) Some irrelevant matches:
> > > 
> > >  * snapd: has a unit test mentioning it, to test their seccomp filters
> > >  * libexplain: mentions it, but does not call it (it's a library for
> > >    human-readably decoding system calls)
> > >  * manpages: documentation
> > > 
> > > 
> > > *Outside* of codesearch.debian.org:
> > > 
> > >  * gpm:
> > >      I've verified that this works with the patch.
> > >      (To my surprise, Debian does not index this project's code.)
> > 
> > (As Samuel pointed out, I was wrong there - Debian does index it, but it does
> > not use the #defines from the headers... who would have thought...)
> > 
> > 
> > > FWIW, I also briefly looked into "jamd" (https://jamd.sourceforge.net/), which
> > > was mentioned as similar in the manpage for "consolation", but that software
> > > does not use any ioctls at all.
> > > 
> > > So overall, it still seems like nothing should break. 👍
> > 
> > Summarizing the above - the only three programs which are known to use the
> > affected TIOCLINUX subcommands are:
> > 
> > * consolation (tested)
> > * gpm (tested)
> > * BRLTTY (known to work with TIOCSTI, where the same CAP_SYS_ADMIN requirement
> >   is imposed for a while now)
> > 
> > I think that this is a safe change for the existing usages and that we have done
> > the due diligence required to turn off these features.
> > 
> > Greg, could you please have another look?
> 
> Can you spin a v4 with all these details collected into the commit log?
> That should be sufficient information for Greg, I would think.

This is already commit 8d1b43f6a6df ("tty: Restrict access to TIOCLINUX'
copy-and-paste subcommands") in my tty-next tree, and in linux-next.
It's been there for 5 days now :)

thanks,

greg k-h
