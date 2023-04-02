Return-Path: <kernel-hardening-return-21650-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id EC5ABC76196
	for <kernel-hardening@archiver.kernel.org>; Sun,  2 Apr 2023 17:24:08 +0000 (UTC)
Received: (qmail 27834 invoked by uid 550); 2 Apr 2023 17:24:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27799 invoked from network); 2 Apr 2023 17:23:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680456226;
	bh=zEPNOi5nensa7LEc+RtrjeS0bYTw3pgaKy0Jw9fN+jw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SNm1DsbZxR765ERA9Y/hIiAFJZDAilFZPzbv5KS4TVZTnksxEyLUeg9H0Fc1uXpv+
	 ZSIEBBCfUkAMO0OUVEtHJeUUWXqA4Uu4YRsGcE3FFSgREEtpGb/uu4kd1rgdOtuSjd
	 g/Rbv1/HERtjG/PIQWjCZg1KdUNq/tisGkRTyhh0=
Date: Sun, 2 Apr 2023 19:23:44 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Hanno =?iso-8859-1?Q?B=F6ck?= <hanno@hboeck.de>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] Restrict access to TIOCLINUX
Message-ID: <2023040207-pretender-legislate-2e8b@gregkh>
References: <20230402160815.74760f87.hanno@hboeck.de>
 <2023040232-untainted-duration-daf6@gregkh>
 <20230402191652.747b6acc.hanno@hboeck.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230402191652.747b6acc.hanno@hboeck.de>

On Sun, Apr 02, 2023 at 07:16:52PM +0200, Hanno Böck wrote:
> On Sun, 2 Apr 2023 16:55:01 +0200
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > You just now broke any normal user programs that required this (or the
> > other ioctls), and so you are going to have to force them to be run
> > with CAP_SYS_ADMIN permissions? 
> 
> Are you aware of such normal user programs?
> It was my impression that this is a relatively obscure feature and gpm
> is pretty much the only tool using it.

"Pretty much" does not mean "none" :(

> > And you didn't change anything for programs like gpm that already had
> > root permission (and shouldn't that permission be dropped anyway?)
> 
> Well, you could restrict all that to a specific capability. However, it
> is my understanding that the existing capability system is limited in
> the number of capabilities and new ones should only be introduced in
> rare cases. It does not seem a feature probably few people use anyway
> deserves a new capability.

I did not suggest that a new capability be created for this, that would
be an abust of the capability levels for sure.

> Do you have other proposals how to fix this issue? One could introduce
> an option like for TIOCSTI that allows disabling selection features by
> default.

What exact issue are you trying to fix here?

thanks,

greg k-h
