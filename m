Return-Path: <kernel-hardening-return-21651-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id DD8C5C76196
	for <kernel-hardening@archiver.kernel.org>; Sun,  2 Apr 2023 17:33:32 +0000 (UTC)
Received: (qmail 1258 invoked by uid 550); 2 Apr 2023 17:33:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1223 invoked from network); 2 Apr 2023 17:33:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hboeck.de; s=key1;
	t=1680456791; bh=dUCJahnCeUZyo0kAQXyrirGF9suJedj9yZQ3OoWr6qs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	b=oEaX1/ooGJGY/4NRpQ1XB+Rl/p00B9oIkNxC4qNWIeOHohzl0pkNIPiRQvNuFOC2s
	 uy39nZg1RVbXI45N5p4W8Xsk0AHOpxk0F2CVwvaABTZI5I5f+XjLpewn9+IJyYQ8Uq
	 b0oUa8q4bAq0QEarpSmD+olgn4BGSvkLbR5iW9jcYnS2mhfrn2PsujPLA9CNU+OULJ
	 yBi/PQ6kVT04Gaq1JwHlnFQSCN6eWIUAeed+T2qwfEx0ZRfiR4FviSjKBtNZ2esj6M
	 pFgOk74oYOi4vTv4WSoit4GKsdxfmKHdiVlFqDeR0uevex3VBpqyEWTmSGVYPCQu9Q
	 xB5UCn9s3VNXg==
Original-Subject: Re: [PATCH] Restrict access to TIOCLINUX
Author: Hanno =?iso-8859-1?q?B=F6ck?= <hanno@hboeck.de>
Date: Sun, 2 Apr 2023 19:33:10 +0200
From: Hanno =?iso-8859-1?q?B=F6ck?= <hanno@hboeck.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] Restrict access to TIOCLINUX
Message-ID: <20230402193310.0e2be5bb.hanno@hboeck.de>
In-Reply-To: <2023040207-pretender-legislate-2e8b@gregkh>
References: <20230402160815.74760f87.hanno@hboeck.de>
	<2023040232-untainted-duration-daf6@gregkh>
	<20230402191652.747b6acc.hanno@hboeck.de>
	<2023040207-pretender-legislate-2e8b@gregkh>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 2 Apr 2023 19:23:44 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> > Do you have other proposals how to fix this issue? One could
> > introduce an option like for TIOCSTI that allows disabling
> > selection features by default. =20
>=20
> What exact issue are you trying to fix here?

The fact that the selection features of TIOCLINUX can be used for
privilege escalation.

I already mentioned this in the original patch description, but I think
the minitty.c example here illustrates this well:
https://www.openwall.com/lists/oss-security/2023/03/14/3

Compile it, do
sudo -u [anynonprivilegeduser] ./minitty

It'll execute shell code with root permission.


--=20
Hanno B=C3=B6ck
https://hboeck.de/
