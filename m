Return-Path: <kernel-hardening-return-21652-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 81D28C76196
	for <kernel-hardening@archiver.kernel.org>; Sun,  2 Apr 2023 17:44:52 +0000 (UTC)
Received: (qmail 7939 invoked by uid 550); 2 Apr 2023 17:44:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7901 invoked from network); 2 Apr 2023 17:44:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680457470;
	bh=JX9cnHadOm52C+K8rq4b8lvFqWy3LF+IqAp4H3SZns4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m94dJBrwQrkvwAccWjSq4Yxs8PVoqTjqzG9Qj1oUWosPNIDvB/KC5xVcSx4j+Bqwx
	 1JH8qjm4OjYTACg7BAMSuPvuIl73FRxaTa/Qxk47gaRvbES8ONSW4OMrrlQeDzdBqK
	 VbBVEeTAfnSg8MHYhQb++zymNwDOq1qqoUkuaa4o=
Date: Sun, 2 Apr 2023 19:44:27 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Hanno =?iso-8859-1?Q?B=F6ck?= <hanno@hboeck.de>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] Restrict access to TIOCLINUX
Message-ID: <2023040237-empty-etching-c988@gregkh>
References: <20230402160815.74760f87.hanno@hboeck.de>
 <2023040232-untainted-duration-daf6@gregkh>
 <20230402191652.747b6acc.hanno@hboeck.de>
 <2023040207-pretender-legislate-2e8b@gregkh>
 <20230402193310.0e2be5bb.hanno@hboeck.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230402193310.0e2be5bb.hanno@hboeck.de>

On Sun, Apr 02, 2023 at 07:33:10PM +0200, Hanno Böck wrote:
> On Sun, 2 Apr 2023 19:23:44 +0200
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > > Do you have other proposals how to fix this issue? One could
> > > introduce an option like for TIOCSTI that allows disabling
> > > selection features by default.  
> > 
> > What exact issue are you trying to fix here?
> 
> The fact that the selection features of TIOCLINUX can be used for
> privilege escalation.

Only if you had root permissions already, and then go to try to run
something using su or sudo as someone with less permission, right?

And as you already had permissions before, it's not really an
excalation, or am I missing something?

> I already mentioned this in the original patch description, but I think
> the minitty.c example here illustrates this well:
> https://www.openwall.com/lists/oss-security/2023/03/14/3
> 
> Compile it, do
> sudo -u [anynonprivilegeduser] ./minitty
> 
> It'll execute shell code with root permission.

That doesn't work if you run it from a user without root permissions to
start with, right?

thanks,

greg k-h
