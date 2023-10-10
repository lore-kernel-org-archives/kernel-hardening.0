Return-Path: <kernel-hardening-return-21701-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 8A367CD98CA
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Oct 2023 22:24:15 +0000 (UTC)
Received: (qmail 32206 invoked by uid 550); 10 Oct 2023 22:23:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32083 invoked from network); 10 Oct 2023 22:23:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1696976626; x=1697581426; darn=lists.openwall.com;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hSHO1Qy0CIrORr8MnlKrlc8xrPp5WpRsphpyJZoUNQw=;
        b=JobjXozYOmkFrjeQlmqoJ7WS9QYOg6lVTttLEiH8Weu5vsLKs6udI6aOnp+ql7J02M
         R7YUmdXgObd/YG5cSs18eMqcV3HFty0gKXrgL1N1o3NNOcls7BCk804e4UXTQdW7Rjjy
         blDSyGcWNIGQjxPAQpRYRxrgF++quL8BfjIsM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696976626; x=1697581426;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hSHO1Qy0CIrORr8MnlKrlc8xrPp5WpRsphpyJZoUNQw=;
        b=wnw4O751OrA5g0bHHMPy5iC1okvphcefownm9No50kkkKyskAvVSir2EYNnXsb8Td2
         c9UA/4s/YhDOdGBaX9IbsIqORyXQnu9K1+MWNu6VCxaAFfn+zFvsEru9580aPyPo8fT0
         DP5YV2Q9RMBvdBTWkBxgeMOS86dZfH3WPc1qepxB6mrJmjUe1xh1WpGULHG8FSqpzyFn
         gVxfJ836zFhUm0LRm2geGTnk4qQ0pod5ukdG0n2Dza6Y31zciGkfR0tC3oEjXRMOe5hm
         GPU66kMuevp9UsXptVzg8EV7FJSsyyHrhLjq7Lqs9AsPivcjYGG6Jj0AFAWQFMREi/Os
         msAA==
X-Gm-Message-State: AOJu0YzVz5es02H3SLa5h/exDmBln2LFTlO9jC6rS7JjrjCjZhe5iFvo
	GQvGtkrlJivYFMwftKySosBicQ==
X-Google-Smtp-Source: AGHT+IEIKU7mgxftU7HzMNDi+h+vg0siLQLFuMvnyRqlEEQJwi7lOCbOOwpp6q0mgHKRh1wn7KYAgA==
X-Received: by 2002:a17:902:8f97:b0:1c7:4973:7b34 with SMTP id z23-20020a1709028f9700b001c749737b34mr15543169plo.50.1696976625960;
        Tue, 10 Oct 2023 15:23:45 -0700 (PDT)
Date: Tue, 10 Oct 2023 15:23:42 -0700
From: Kees Cook <keescook@chromium.org>
To: Greg KH <gregkh@linuxfoundation.org>
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
Message-ID: <202310101522.A4446CF1D@keescook>
References: <20230828164117.3608812-1-gnoack@google.com>
 <20230828164521.tpvubdufa62g7zwc@begin>
 <ZO3r42zKRrypg/eM@google.com>
 <ZQRc7e0l2SjsCB5m@google.com>
 <202310091319.F1D49BC30B@keescook>
 <2023101045-stride-auction-1b9e@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2023101045-stride-auction-1b9e@gregkh>

On Tue, Oct 10, 2023 at 08:17:42AM +0200, Greg KH wrote:
> On Mon, Oct 09, 2023 at 01:19:47PM -0700, Kees Cook wrote:
> > On Fri, Sep 15, 2023 at 03:32:29PM +0200, Günther Noack wrote:
> > > On Tue, Aug 29, 2023 at 03:00:19PM +0200, Günther Noack wrote:
> > > > Let me update the list of known usages then: The TIOCL_SETSEL, TIOCL_PASTESEL
> > > > and TIOCL_SELLOADLUT mentions found on codesearch.debian.net are:
> > > > 
> > > > (1) Actual invocations:
> > > > 
> > > >  * consolation:
> > > >      "consolation" is a gpm clone, which also runs as root.
> > > >      (I have not had the chance to test this one yet.)
> > > 
> > > I have tested the consolation program with a kernel that has the patch, and it
> > > works as expected -- you can copy and paste on the console.
> > > 
> > > 
> > > >  * BRLTTY:
> > > >      Uses TIOCL_SETSEL as a means to highlight portions of the screen.
> > > >      The TIOCSTI patch made BRLTTY work by requiring CAP_SYS_ADMIN,
> > > >      so we know that BRLTTY has that capability (it runs as root and
> > > >      does not drop it).
> > > > 
> > > > (2) Some irrelevant matches:
> > > > 
> > > >  * snapd: has a unit test mentioning it, to test their seccomp filters
> > > >  * libexplain: mentions it, but does not call it (it's a library for
> > > >    human-readably decoding system calls)
> > > >  * manpages: documentation
> > > > 
> > > > 
> > > > *Outside* of codesearch.debian.org:
> > > > 
> > > >  * gpm:
> > > >      I've verified that this works with the patch.
> > > >      (To my surprise, Debian does not index this project's code.)
> > > 
> > > (As Samuel pointed out, I was wrong there - Debian does index it, but it does
> > > not use the #defines from the headers... who would have thought...)
> > > 
> > > 
> > > > FWIW, I also briefly looked into "jamd" (https://jamd.sourceforge.net/), which
> > > > was mentioned as similar in the manpage for "consolation", but that software
> > > > does not use any ioctls at all.
> > > > 
> > > > So overall, it still seems like nothing should break. 👍
> > > 
> > > Summarizing the above - the only three programs which are known to use the
> > > affected TIOCLINUX subcommands are:
> > > 
> > > * consolation (tested)
> > > * gpm (tested)
> > > * BRLTTY (known to work with TIOCSTI, where the same CAP_SYS_ADMIN requirement
> > >   is imposed for a while now)
> > > 
> > > I think that this is a safe change for the existing usages and that we have done
> > > the due diligence required to turn off these features.
> > > 
> > > Greg, could you please have another look?
> > 
> > Can you spin a v4 with all these details collected into the commit log?
> > That should be sufficient information for Greg, I would think.
> 
> This is already commit 8d1b43f6a6df ("tty: Restrict access to TIOCLINUX'
> copy-and-paste subcommands") in my tty-next tree, and in linux-next.
> It's been there for 5 days now :)

Oh perfect! Thanks.

On a related topic, I wonder if you can change your scripting to reply
to the original patch thread when something lands? This is helpful when
going back over old threads, etc. (This is what the various other bots
and b4 tooling does...)

-Kees

-- 
Kees Cook
