Return-Path: <kernel-hardening-return-21685-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id DFF8FC71153
	for <kernel-hardening@archiver.kernel.org>; Mon, 28 Aug 2023 14:48:53 +0000 (UTC)
Received: (qmail 16216 invoked by uid 550); 28 Aug 2023 14:48:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16178 invoked from network); 28 Aug 2023 14:48:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693234110;
	bh=Ua8ZSdN6A7c+b3DB28+xF4FqK2nKZZJH481q+x1cd78=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EBWX+4dT0BSJj9oqQUbN+mb+HMnogkvQHvjG9HaW16sXwcMjVYBpVXA732v1Di7au
	 mwrRAglO2qgZc0Ta3V5chM0wS4LQLWaD5XqNkovRNKtY8kMx156qTQXhkTvsiT7XHG
	 4RtT3wrS+gUvnP1yMB2k2JrkFR9uMcOsTZ07yH34=
Date: Mon, 28 Aug 2023 16:48:28 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?G=FCnther?= Noack <gnoack@google.com>
Cc: Hanno =?iso-8859-1?Q?B=F6ck?= <hanno@hboeck.de>,
	kernel-hardening@lists.openwall.com,
	Kees Cook <keescook@chromium.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Paul Moore <paul@paul-moore.com>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	David Laight <David.Laight@aculab.com>,
	Simon Brand <simon.brand@postadigitale.de>,
	Dave Mielke <Dave@mielke.cc>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	KP Singh <kpsingh@google.com>,
	Nico Schottelius <nico-gpm2008@schottelius.org>
Subject: Re: [PATCH v2 1/1] tty: Restrict access to TIOCLINUX' copy-and-paste
 subcommands
Message-ID: <2023082836-masses-gyration-0e7e@gregkh>
References: <20230828122109.3529221-1-gnoack@google.com>
 <20230828122109.3529221-2-gnoack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230828122109.3529221-2-gnoack@google.com>

On Mon, Aug 28, 2023 at 02:21:09PM +0200, Günther Noack wrote:
> From: Hanno Böck <hanno@hboeck.de>
> 
> TIOCLINUX can be used for privilege escalation on virtual terminals when
> code is executed via tools like su/sudo and sandboxing tools.
> 
> By abusing the selection features, a lower-privileged application can
> write content to the console, select and copy/paste that content and
> thereby executing code on the privileged account. See also the poc
> here:
> 
>   https://www.openwall.com/lists/oss-security/2023/03/14/3
> 
> Selection is usually used by tools like gpm that provide mouse features
> on the virtual console. gpm already runs as root (due to earlier
> changes that restrict access to a user on the current TTY), therefore
> it will still work with this change.
> 
> With this change, the following TIOCLINUX subcommands require
> CAP_SYS_ADMIN:
> 
>  * TIOCL_SETSEL - setting the selected region on the terminal
>  * TIOCL_PASTESEL - pasting the contents of the selected region into
>    the input buffer
>  * TIOCL_SELLOADLUT - changing word-by-word selection behaviour
> 
> The security problem mitigated is similar to the security risks caused
> by TIOCSTI, which, since kernel 6.2, can be disabled with
> CONFIG_LEGACY_TIOCSTI=n.
> 
> Signed-off-by: Hanno Böck <hanno@hboeck.de>
> Tested-by: Günther Noack <gnoack@google.com>

When you pass on a patch like this, you too need to sign off on it as
per the instructions in the DCO.  I'm pretty sure the Google open source
training also says that, but maybe not.  If not, it should :)

thanks,

greg k-h
