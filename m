Return-Path: <kernel-hardening-return-21690-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 8546AC83F11
	for <kernel-hardening@archiver.kernel.org>; Mon, 28 Aug 2023 18:44:03 +0000 (UTC)
Received: (qmail 32536 invoked by uid 550); 28 Aug 2023 18:43:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32497 invoked from network); 28 Aug 2023 18:43:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1693248220;
	bh=Wd4/DbXQKI4gSSyoU4HWY/YpVlxuNp5C1P6pl4XRtRg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zQiy/hkFplQ2Su5hon38m4T5ARYbPIMllmxtazpRq/pCebpbMTC0oTfRTTp9de11H
	 7Mfj6a1lN3q5dUQ+2nStSxpobQnuMhLEpqUmeyvFVwoki3dH9fm8s+rTnjI6yOVOiF
	 EpRgu32N6+/Lod3QyPSXJxGiQU1P+7UceVEsMfes=
Date: Mon, 28 Aug 2023 20:43:39 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: =?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, 
	Hanno =?utf-8?B?QsO2Y2s=?= <hanno@hboeck.de>, kernel-hardening@lists.openwall.com, 
	Kees Cook <keescook@chromium.org>, Jiri Slaby <jirislaby@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Paul Moore <paul@paul-moore.com>, 
	Samuel Thibault <samuel.thibault@ens-lyon.org>, David Laight <David.Laight@aculab.com>, 
	Simon Brand <simon.brand@postadigitale.de>, Dave Mielke <Dave@mielke.cc>, KP Singh <kpsingh@google.com>, 
	Nico Schottelius <nico-gpm2008@schottelius.org>
Subject: Re: [PATCH v3 1/1] tty: Restrict access to TIOCLINUX' copy-and-paste
 subcommands
Message-ID: <20230828.eGare4bei2ji@digikod.net>
References: <20230828164117.3608812-1-gnoack@google.com>
 <20230828164117.3608812-2-gnoack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230828164117.3608812-2-gnoack@google.com>
X-Infomaniak-Routing: alpha

On Mon, Aug 28, 2023 at 06:41:17PM +0200, Günther Noack wrote:
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
> Signed-off-by: Günther Noack <gnoack@google.com>

The SoB rules are tricky, you cannot have a Signed-off-by if you are not
in the From/Author or Committer or Co-Developed-by fields:
https://docs.kernel.org/process/submitting-patches.html#when-to-use-acked-by-cc-and-co-developed-by

It should be:

Co-Developed-by: Günther Noack <gnoack@google.com>
Signed-off-by: Günther Noack <gnoack@google.com>
Signed-off-by: Hanno Böck <hanno@hboeck.de>

> Tested-by: Günther Noack <gnoack@google.com>

This Tested-by should not be required anymore because of your SoB,
which should implicitly stipulate that you tested this patch.

I'm not sure if it's worth sending another version with only this fix
though, if there is no more issue I guess the maintainer picking it
could fix it.


> ---
>  drivers/tty/vt/vt.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index 1e8e57b45688..1eb30ed1118d 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -3156,9 +3156,13 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
>  
>  	switch (type) {
>  	case TIOCL_SETSEL:
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EPERM;
>  		return set_selection_user((struct tiocl_selection
>  					 __user *)(p+1), tty);
>  	case TIOCL_PASTESEL:
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EPERM;
>  		return paste_selection(tty);
>  	case TIOCL_UNBLANKSCREEN:
>  		console_lock();
> @@ -3166,6 +3170,8 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
>  		console_unlock();
>  		break;
>  	case TIOCL_SELLOADLUT:
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EPERM;
>  		console_lock();
>  		ret = sel_loadlut(p);
>  		console_unlock();
> -- 
> 2.42.0.rc2.253.gd59a3bf2b4-goog
> 
