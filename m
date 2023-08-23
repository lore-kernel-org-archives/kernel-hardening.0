Return-Path: <kernel-hardening-return-21678-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 294FBEE49A3
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Aug 2023 14:37:22 +0000 (UTC)
Received: (qmail 22092 invoked by uid 550); 23 Aug 2023 14:37:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22060 invoked from network); 23 Aug 2023 14:37:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692801416;
	bh=JEmEfA7sww7HXk95z95xWU1hoxzeEHjmipokTka8feY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b6t819dqqLcWSkIbiUXH3GSmgEYH4DcDVlVl9Ybd5dYOUcqHfR6qAOWtvAQZvbVrJ
	 Pr2umBo1VTOM3pqFbTMzkEaVJVrQJEWLXqWRdhHLHOcbv8+g2uewdVxiWsbRjRhQeJ
	 BE00xrWaUAfvcGoss8wRyMgf6NHLDjz0SarX3NvM=
Date: Wed, 23 Aug 2023 16:36:54 +0200
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
	KP Singh <kpsingh@google.com>
Subject: Re: [PATCH] Restrict access to TIOCLINUX
Message-ID: <2023082320-jogging-kissing-a700@gregkh>
References: <20230402160815.74760f87.hanno@hboeck.de>
 <2023040232-untainted-duration-daf6@gregkh>
 <20230402191652.747b6acc.hanno@hboeck.de>
 <2023040207-pretender-legislate-2e8b@gregkh>
 <ZN+X6o3cDWcLoviq@google.com>
 <2023082203-slackness-sworn-2c80@gregkh>
 <ZOT8zL8tXqy41XmM@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZOT8zL8tXqy41XmM@google.com>

On Tue, Aug 22, 2023 at 08:22:04PM +0200, Günther Noack wrote:
> By the non-submittable "form", I assume you mean the formatting and maybe
> phrasing of the e-mail, so that it can be cleanly applied to git?  Or was there
> anything in the code which I missed?

I only looked at the format, that was incorrect.  You can test the patch
to verify if the code is correct before submitting it :)

thanks,

greg k-h
