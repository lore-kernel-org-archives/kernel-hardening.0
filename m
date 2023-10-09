Return-Path: <kernel-hardening-return-21699-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 6F15FCD612F
	for <kernel-hardening@archiver.kernel.org>; Mon,  9 Oct 2023 20:20:14 +0000 (UTC)
Received: (qmail 17824 invoked by uid 550); 9 Oct 2023 20:20:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17786 invoked from network); 9 Oct 2023 20:20:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1696882789; x=1697487589; darn=lists.openwall.com;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UlbznTrZgEYtlyenMc3wKchZLHB8yLZ7Xwct2TBwn28=;
        b=TFHRhQ0DTdMfpS20A/EhR5MhJfzxDyfxSXK4TeG6YvVqhTRfRlTL/h7vsOBfLt7v+C
         toWA+Sa0Q3USp6007BpevsYKl4SYwbJgfJ8Fv+J9HSefk0zVLWwe/CaVAzOALyzEbb2u
         eDPy4UksRs8HJzzzgw/ZZJE0+D8ovBvJyliHk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696882789; x=1697487589;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UlbznTrZgEYtlyenMc3wKchZLHB8yLZ7Xwct2TBwn28=;
        b=wFarQrp1TRjp8/dSFjhQi56LEEELemfFI1gSNCNBqObUk26Qw+LTlHjNuk4VOsazAM
         zAM9lBKXRcpwsGODecd/s6DvqL5tQIRE30RJ5m/n6KOJkGyhQYWx8nmB5Cnb0NxocxBN
         ceiQjqoTzcUfOqAFdF7aPyDOBDCZNoYxPARk6232b7jPeD7wpo35bpHW6IIf7T5jFX99
         zTEfVt4zdHJXNJRc0TptaRwaAI8Wt5LIi9Ic+b6Y7fRv0SwAF6UNQALeEKy3zxiLUp7O
         lt2mff3qazNa+MijRi0qqxqFfn8VPn9vXdFA8utNeIBZBloJLMnCQBWR9QFCwJWS4EP7
         qQvg==
X-Gm-Message-State: AOJu0YzZnCX0s0IjU/gyIHId2sG6blo8yCSa9vd6xigoOJ5Q4LsZlYTQ
	269lMno1w/c5Ad2z2/cVf7sfgg==
X-Google-Smtp-Source: AGHT+IGcQ1R0BhKdaqZgYy8M9CGxt4iHXCBxiyYcQapnWCws/AdK+oZFJneKsZ75tSUMMFdEU/snrw==
X-Received: by 2002:a05:6a00:2356:b0:68e:2822:fb36 with SMTP id j22-20020a056a00235600b0068e2822fb36mr15652270pfj.8.1696882789134;
        Mon, 09 Oct 2023 13:19:49 -0700 (PDT)
Date: Mon, 9 Oct 2023 13:19:47 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?G=FCnther?= Noack <gnoack@google.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Greg KH <gregkh@linuxfoundation.org>,
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
Message-ID: <202310091319.F1D49BC30B@keescook>
References: <20230828164117.3608812-1-gnoack@google.com>
 <20230828164521.tpvubdufa62g7zwc@begin>
 <ZO3r42zKRrypg/eM@google.com>
 <ZQRc7e0l2SjsCB5m@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZQRc7e0l2SjsCB5m@google.com>

On Fri, Sep 15, 2023 at 03:32:29PM +0200, Günther Noack wrote:
> On Tue, Aug 29, 2023 at 03:00:19PM +0200, Günther Noack wrote:
> > Let me update the list of known usages then: The TIOCL_SETSEL, TIOCL_PASTESEL
> > and TIOCL_SELLOADLUT mentions found on codesearch.debian.net are:
> > 
> > (1) Actual invocations:
> > 
> >  * consolation:
> >      "consolation" is a gpm clone, which also runs as root.
> >      (I have not had the chance to test this one yet.)
> 
> I have tested the consolation program with a kernel that has the patch, and it
> works as expected -- you can copy and paste on the console.
> 
> 
> >  * BRLTTY:
> >      Uses TIOCL_SETSEL as a means to highlight portions of the screen.
> >      The TIOCSTI patch made BRLTTY work by requiring CAP_SYS_ADMIN,
> >      so we know that BRLTTY has that capability (it runs as root and
> >      does not drop it).
> > 
> > (2) Some irrelevant matches:
> > 
> >  * snapd: has a unit test mentioning it, to test their seccomp filters
> >  * libexplain: mentions it, but does not call it (it's a library for
> >    human-readably decoding system calls)
> >  * manpages: documentation
> > 
> > 
> > *Outside* of codesearch.debian.org:
> > 
> >  * gpm:
> >      I've verified that this works with the patch.
> >      (To my surprise, Debian does not index this project's code.)
> 
> (As Samuel pointed out, I was wrong there - Debian does index it, but it does
> not use the #defines from the headers... who would have thought...)
> 
> 
> > FWIW, I also briefly looked into "jamd" (https://jamd.sourceforge.net/), which
> > was mentioned as similar in the manpage for "consolation", but that software
> > does not use any ioctls at all.
> > 
> > So overall, it still seems like nothing should break. 👍
> 
> Summarizing the above - the only three programs which are known to use the
> affected TIOCLINUX subcommands are:
> 
> * consolation (tested)
> * gpm (tested)
> * BRLTTY (known to work with TIOCSTI, where the same CAP_SYS_ADMIN requirement
>   is imposed for a while now)
> 
> I think that this is a safe change for the existing usages and that we have done
> the due diligence required to turn off these features.
> 
> Greg, could you please have another look?

Can you spin a v4 with all these details collected into the commit log?
That should be sufficient information for Greg, I would think.

Thanks for checking each of these!

-Kees

-- 
Kees Cook
