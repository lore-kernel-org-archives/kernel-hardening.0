Return-Path: <kernel-hardening-return-21673-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 60BFDEE49A3
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Aug 2023 12:07:54 +0000 (UTC)
Received: (qmail 22305 invoked by uid 550); 22 Aug 2023 12:07:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22270 invoked from network); 22 Aug 2023 12:07:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692706047;
	bh=5pAw0BctsAwNeVsLoEIFwZCqgszIEDk0UUQJhT2rNVQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IjGuK1fVrke0NEdGFupU0g3PkJ9ToYkFtlpUYh0l+C6g/gzNjPen6O3CN2wxDZjDb
	 rtgSqPJPl6qzHoaMDpE/iBHxtcnDB2IT1DI+FXGW7If1bMZwfWg6jxAIaxM7yiISCP
	 3UUZGWn2B6AmyYXoRyYyh+hl3+EE5HJg2svQE25c=
Date: Tue, 22 Aug 2023 14:07:24 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?G=FCnther?= Noack <gnoack@google.com>
Cc: Hanno =?iso-8859-1?Q?B=F6ck?= <hanno@hboeck.de>,
	kernel-hardening@lists.openwall.com,
	Kees Cook <keescook@chromium.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Paul Moore <paul@paul-moore.com>,
	Samuel Thibault <samuel@ens-lyon.org>,
	David Laight <David.Laight@aculab.com>,
	Simon Brand <simon.brand@postadigitale.de>,
	Dave Mielke <Dave@mielke.cc>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Subject: Re: [PATCH] Restrict access to TIOCLINUX
Message-ID: <2023082203-slackness-sworn-2c80@gregkh>
References: <20230402160815.74760f87.hanno@hboeck.de>
 <2023040232-untainted-duration-daf6@gregkh>
 <20230402191652.747b6acc.hanno@hboeck.de>
 <2023040207-pretender-legislate-2e8b@gregkh>
 <ZN+X6o3cDWcLoviq@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZN+X6o3cDWcLoviq@google.com>

On Fri, Aug 18, 2023 at 06:10:18PM +0200, Günther Noack wrote:
> Hello!
> 
> +CC the people involved in TIOCSTI
> 
> This patch seems sensible to me --
> and I would like to kindly ask you to reconsider it.
> 
> On Sun, Apr 02, 2023 at 07:23:44PM +0200, Greg KH wrote:
> > On Sun, Apr 02, 2023 at 07:16:52PM +0200, Hanno Böck wrote:
> > > On Sun, 2 Apr 2023 16:55:01 +0200
> > > Greg KH <gregkh@linuxfoundation.org> wrote:
> > > 
> > > > You just now broke any normal user programs that required this (or the
> > > > other ioctls), and so you are going to have to force them to be run
> > > > with CAP_SYS_ADMIN permissions? 
> > > 
> > > Are you aware of such normal user programs?
> > > It was my impression that this is a relatively obscure feature and gpm
> > > is pretty much the only tool using it.
> > 
> > "Pretty much" does not mean "none" :(
> 
> This patch only affects TIOCLINUX subcodes which are responsible for text
> cut-and-paste, TIOCL_SETSEL, TIOCL_PASTESEL and TIOCL_SELLOADLUT.
> 
> The only program that I am aware of which uses cut&paste on the console is gpm.
> My web searches for these subcode names have only surfaced Linux header files
> and discussions about their security problems.

Is gpm running with the needed permissions already?

> > > > And you didn't change anything for programs like gpm that already had
> > > > root permission (and shouldn't that permission be dropped anyway?)
> > > 
> > > Well, you could restrict all that to a specific capability. However, it
> > > is my understanding that the existing capability system is limited in
> > > the number of capabilities and new ones should only be introduced in
> > > rare cases. It does not seem a feature probably few people use anyway
> > > deserves a new capability.
> > 
> > I did not suggest that a new capability be created for this, that would
> > be an abust of the capability levels for sure.
> > 
> > > Do you have other proposals how to fix this issue? One could introduce
> > > an option like for TIOCSTI that allows disabling selection features by
> > > default.
> > 
> > What exact issue are you trying to fix here?
> 
> It's the same problem as with TIOCSTI, which got (optionally) disabled for
> non-CAP_SYS_ADMIN in commit 83efeeeb3d04 ("tty: Allow TIOCSTI to be disabled")
> and commit 690c8b804ad2 ("TIOCSTI: always enable for CAP_SYS_ADMIN").
> 
> The number of exploits which have used TIOCSTI in the past is long[1] and has
> affected multiple sandboxing and sudo-like tools.  If the user is using the
> console, TIOCLINUX's cut&paste functionality can replace TIOCSTI in these
> exploits.
> 
> We have this problem with the Landlock LSM as well, with both TIOCSTI and these
> TIOCLINUX subcodes.
> 
> Here is an example scenario:
> 
> * User runs a vulnerable version of the "ping" command from the console.

Don't do that :)

> * The "ping" command is a hardened version which puts itself into a Landlock
>   sandbox, but it still has the TTY FD through stdout.
> 
> * Ping gets buffer-overflow-exploited by an attacker through ping responses.

You allowed a root-permissioned program to accept unsolicted network
code, why is it the kernel's issue here?

> * The attacker can't directly access the file system, but the attacker can
>   escape the sandbox by controlling the surrounding (non-sandboxed) shell on its
>   terminal through TIOCLINUX.
> 
> The ping example is not completely made up -- FreeBSD had such a vulnerability
> in its ping utility in 2022[2].  The impact of the vulnerability was mitigated
> by FreeBSD's Capsicum sandboxing.
> 
> The correct solution for the problem on Linux is to my knowledge to create a
> pty/tty pair, but that is somewhat impractical for small utilities like ping, in
> order to restrict themselves (they would need to create a sidecar process to
> shovel the data back and forth).  Workarounds include setsid() and seccomp-bpf,
> but they also have their limits and are not a clean solution.  We've previously
> discussed it in [3].
> 
> I do believe that requiring CAP_SYS_ADMIN for TIOCLINUX's TIOCL_PASTESEL subcode
> would be a better approach than so many sudo-style and sandboxing tools having
> to learn this lesson the hard way.  Can we please reconsider this patch?

Have you verified that nothing will break with this?

If so, it needs to be submitted in a form that could be accepted (this
one was not, so I couldn't take it even if I wanted to), and please add
a tested-by from you and we will be glad to reconsider it.

thanks,

greg k-h
