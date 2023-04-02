Return-Path: <kernel-hardening-return-21648-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id AA941C7619A
	for <kernel-hardening@archiver.kernel.org>; Sun,  2 Apr 2023 14:55:26 +0000 (UTC)
Received: (qmail 13931 invoked by uid 550); 2 Apr 2023 14:55:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13890 invoked from network); 2 Apr 2023 14:55:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680447303;
	bh=OBxKfDAO6qMCdPao7psCNuyPZaWGdL8OHH3kmD1wxbo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vyDFK2BDsMsDcmhM1UXwQXnJnKrF4SJtZIcwGGlh0ciMVQUFM+PzAr/vt8G4+xdHU
	 wEFSZRdD9ffE8KEYLpQJTzvIpAMoYsX52gxGnSHbREHxuW/9UvaIfjMesK4hrzbUUi
	 L1rkzKBi0LVm/6lYTgl5+BmRTQkzWG7U3Vhy8Aa8=
Date: Sun, 2 Apr 2023 16:55:01 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Hanno =?iso-8859-1?Q?B=F6ck?= <hanno@hboeck.de>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] Restrict access to TIOCLINUX
Message-ID: <2023040232-untainted-duration-daf6@gregkh>
References: <20230402160815.74760f87.hanno@hboeck.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230402160815.74760f87.hanno@hboeck.de>

On Sun, Apr 02, 2023 at 04:08:15PM +0200, Hanno Böck wrote:
> Hi,
> 
> I'm sending this here before I'll try to send it to lkml and the
> respective maintainers to get some feedback first.
> 
> The TIOCLINUX functionality in the kernel can be abused for privilege
> escalation, similar to TIOCSTI. I considered a few options how to fix
> this, and this is what I came up with.
> 
> 
> Restrict access to TIOCLINUX
> 
> TIOCLINUX can be used for privilege escalation on virtual terminals when
> code is executed via tools like su/sudo.
> By abusing the selection features a lower-privileged application can
> write content to the console, select and copy/paste that content and
> thereby executing code on the privileged account. See also the poc here:
>   https://www.openwall.com/lists/oss-security/2023/03/14/3
> 
> Selection is usually used by tools like gpm that provide mouse features
> on the virtual console. gpm already runs as root (due to earlier
> changes that restrict access to a user on the current tty), therefore
> it will still work with this change.
> 
> The security problem mitigated is similar to the security risks caused
> by TIOCSTI, which, since kernel 6.2, can be disabled with
> CONFIG_LEGACY_TIOCSTI=n.
> 
> Signed-off-by: Hanno Böck <hanno@hboeck.de>
> ---
>  drivers/tty/vt/vt.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index 3c2ea9c098f7..3671173109b8 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -3146,10 +3146,14 @@ int tioclinux(struct tty_struct *tty, unsigned
> long arg) switch (type)
>  	{
>  		case TIOCL_SETSEL:
> +			if (!capable(CAP_SYS_ADMIN))
> +				return -EPERM;

You just now broke any normal user programs that required this (or the
other ioctls), and so you are going to have to force them to be run with
CAP_SYS_ADMIN permissions?  That feels like you are going backwards in
security, not forwards.

And you didn't change anything for programs like gpm that already had
root permission (and shouldn't that permission be dropped anyway?)

thanks,

greg k-h
