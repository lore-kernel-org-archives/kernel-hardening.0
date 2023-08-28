Return-Path: <kernel-hardening-return-21691-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 7C326C71153
	for <kernel-hardening@archiver.kernel.org>; Mon, 28 Aug 2023 18:48:47 +0000 (UTC)
Received: (qmail 7230 invoked by uid 550); 28 Aug 2023 18:48:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7194 invoked from network); 28 Aug 2023 18:48:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693248505;
	bh=B3pxrg7AL7Lla6jbYhR3X2grZ8ox4XPq6mWm0wvjuqI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gZ3IQvZPHy4kzXmlQuIybZYFhW+F0kFz4nw3xWhDyxYksp6I5ZSFOGcm4hWwzhB8v
	 wZIM/OoPKsfl4uOlYyGxz6hTQjWb4QLMpaVq3SkSNqanT78QaUU0fnrNf2Cz1HifBJ
	 SLiSI/pJVDRfc3mm3PbbiUCwKoX2Q0u1JkX+R+9U=
Date: Mon, 28 Aug 2023 20:48:22 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: =?iso-8859-1?Q?G=FCnther?= Noack <gnoack@google.com>,
	Hanno =?iso-8859-1?Q?B=F6ck?= <hanno@hboeck.de>,
	kernel-hardening@lists.openwall.com,
	Kees Cook <keescook@chromium.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Paul Moore <paul@paul-moore.com>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	David Laight <David.Laight@aculab.com>,
	Simon Brand <simon.brand@postadigitale.de>,
	Dave Mielke <Dave@mielke.cc>, KP Singh <kpsingh@google.com>,
	Nico Schottelius <nico-gpm2008@schottelius.org>
Subject: Re: [PATCH v3 1/1] tty: Restrict access to TIOCLINUX' copy-and-paste
 subcommands
Message-ID: <2023082829-runner-engaging-20e2@gregkh>
References: <20230828164117.3608812-1-gnoack@google.com>
 <20230828164117.3608812-2-gnoack@google.com>
 <20230828.eGare4bei2ji@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230828.eGare4bei2ji@digikod.net>

On Mon, Aug 28, 2023 at 08:43:39PM +0200, Mickaël Salaün wrote:
> On Mon, Aug 28, 2023 at 06:41:17PM +0200, Günther Noack wrote:
> > From: Hanno Böck <hanno@hboeck.de>
> > 
> > TIOCLINUX can be used for privilege escalation on virtual terminals when
> > code is executed via tools like su/sudo and sandboxing tools.
> > 
> > By abusing the selection features, a lower-privileged application can
> > write content to the console, select and copy/paste that content and
> > thereby executing code on the privileged account. See also the poc
> > here:
> > 
> >   https://www.openwall.com/lists/oss-security/2023/03/14/3
> > 
> > Selection is usually used by tools like gpm that provide mouse features
> > on the virtual console. gpm already runs as root (due to earlier
> > changes that restrict access to a user on the current TTY), therefore
> > it will still work with this change.
> > 
> > With this change, the following TIOCLINUX subcommands require
> > CAP_SYS_ADMIN:
> > 
> >  * TIOCL_SETSEL - setting the selected region on the terminal
> >  * TIOCL_PASTESEL - pasting the contents of the selected region into
> >    the input buffer
> >  * TIOCL_SELLOADLUT - changing word-by-word selection behaviour
> > 
> > The security problem mitigated is similar to the security risks caused
> > by TIOCSTI, which, since kernel 6.2, can be disabled with
> > CONFIG_LEGACY_TIOCSTI=n.
> > 
> > Signed-off-by: Hanno Böck <hanno@hboeck.de>
> > Signed-off-by: Günther Noack <gnoack@google.com>
> 
> The SoB rules are tricky, you cannot have a Signed-off-by if you are not
> in the From/Author or Committer or Co-Developed-by fields:
> https://docs.kernel.org/process/submitting-patches.html#when-to-use-acked-by-cc-and-co-developed-by

Not true at all, maintainers add their signed-off-by to everything they
apply, and you HAVE to add it to a patch that flows through you to
someone else, as per the DCO.

> It should be:
> 
> Co-Developed-by: Günther Noack <gnoack@google.com>

Not if this person was not a developer on it, no.

> Signed-off-by: Günther Noack <gnoack@google.com>
> Signed-off-by: Hanno Böck <hanno@hboeck.de>
> 
> > Tested-by: Günther Noack <gnoack@google.com>
> 
> This Tested-by should not be required anymore because of your SoB,
> which should implicitly stipulate that you tested this patch.
> 
> I'm not sure if it's worth sending another version with only this fix
> though, if there is no more issue I guess the maintainer picking it
> could fix it.

As submitted, it is correct.

thanks,

greg k-h
