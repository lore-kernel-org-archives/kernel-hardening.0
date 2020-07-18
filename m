Return-Path: <SRS0=O31Y=A5=lists.openwall.com=kernel-hardening-return-19391-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C42EC433DF
	for <kernel-hardening@archiver.kernel.org>; Sat, 18 Jul 2020 12:22:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C859C20724
	for <kernel-hardening@archiver.kernel.org>; Sat, 18 Jul 2020 12:22:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="kxnCP+qn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C859C20724
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19391-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11850 invoked by uid 550); 18 Jul 2020 12:22:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11818 invoked from network); 18 Jul 2020 12:22:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1595074917;
	bh=UOeeO+ukQGMllkOG7WfjFALkFL9GMHEpInijwvm1CqM=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kxnCP+qnSn8hZ1GS7N5d/afaUNhntNilYD6zRuI731ixFMhT/6SOEKbc9LuwqYdHz
	 oL6cXOKGuaJspXMBmulk1CwoRN2rHaTwkQ/jv82B2Lm46Q/vy82nte2NYB1r7cvhMn
	 FHGmvRT0QkYOd77q3EIkYee/MlxciLt5CGbyGW2Q=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Sat, 18 Jul 2020 14:21:45 +0200
From: Oscar Carter <oscar.carter@gmx.com>
To: Kees Cook <keescook@chromium.org>, Allen <allen.lkml@gmail.com>
Cc: Oscar Carter <oscar.carter@gmx.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: Clarification about the series to modernize the tasklet api
Message-ID: <20200718122145.GA3153@ubuntu>
References: <20200711174239.GA3199@ubuntu>
 <CAOMdWSLFSci1DCMsQLBoX-ADP0cHbhudfvRKokdM+pEQEfpnAQ@mail.gmail.com>
 <202007130914.E9157B3@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202007130914.E9157B3@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:DbZqgwDFGwawfYUFeNbWQOsNzRwWGSDzK4XfrP0kWHxr8g3L3JH
 MFg/i6rBL9WH2MFYvl5K/jPUnz/xW/DBHgfXZwQlMHfsMmdIce5VyOODIzTcgH+VdxUNd2U
 SmwnVxK04QF+FxivAFsl8aAkvz2K3XBjRvndIm0KwmQFY7FH0lA2yXSHt0q5Zk/Hfikume6
 phErtfe/By2zW9RtXalAw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:OCaIfDmdzco=:FCNzbFJEcGptbHBtIH94os
 cX5SIByAN71ODUG5Fzy21pIyQqEbCWD22miFae3vbHo5xnvv0SegMc5u136HTmVG3LYxPCrDn
 IjYectqLvKBNPkXolfPQzG9W0tWtP+JPqRWFpSB6ywR9Bwl+k9Qj07qyPpc0OIqdf9+2+zBjd
 nib7rZgCmRGw65NZrvedKFl9PoVdDfNnF0YQj6vvy5FaPnOrOw9y3+K9noaEkSrdaNVw2PXFI
 q4A6699nH9boJpacWOwAQgyYVQem6SNOeZ5v/U13oEXnAoP2SeJ9YWN96OjhTbJA8YwC7B7nY
 sHqDDCokGMHCkLpiU6vR/+86c6QescFiRPYEHo2e1p1nbPSqGUHZumwE46jyhwoWvo9fCg3ZH
 dKjJ9yO7ziDLBcbgRRMe0ux4oWSsYxuub2HWc7EXgzWjuG8iWLd9L9JBcafwntL88lJVmtFAr
 Dynr/ivCsCFlkohQOh4mLzeecVmG27g3Z6NReqbW3h2Sg5o95vzx7mf9Oec0CcvZFkKfUKUye
 Ub2YYuY+uP76BCzrCJz5gXgeUGCh/Do06aMzAb5MeKQCqFX78QEQSIfu4POc4eELACV3krx0C
 Zx1SmxicWesAKFVV/kILll43Wl7SizSK0CuRZd1sah2rXi3Iy6b2HQEuRXmQKFgkwpzOFAX8g
 mxuxbPn8TERaCgWtS0hRQ9EOwYaWN2CC/ich3XKPaK81OT0L7jZmoo8B17pG+mZxUBYQgvLrx
 8yr9L9FIa2Gjd/UHecWVyWGnENbKoOg4NvR/S0ZzRRXwNb+2qGoCo+NV7CycCAqAPH7NRGXJH
 pe3Wiq2WJO6/Ly6/qYqju0clnRjNtXUoXDFRTK7Efyl4j8hr1RoOnF/jWvt60+x80/Sgm40v8
 lxpY426ncksDLVV8Cg9pFTUn2KCEvQUl4UHjxyNg/H/+bSP59KrVkU/N9XAznUB5sJFre/asD
 H3OxIc2xN474PM/eaRzB+bBKwZTaKNemjPxeCjHVEt9RXLLo2/BWaJEux9EEwHr5Dn8aihRTO
 XeY123yXsJQkgGaBl5iV7kXjS+6CYtpt1WlIlMJcbTmfJh84qxWJCGEsi5MiUNc6zrrxS3cu8
 jnGOFthMAhjfNfCl3Wh9ZsxICyzMUNTmjo5uZDUoStZvZOnrPAxDSObDUgSN76JUUe6+Ez2M9
 UenBjFE36aY+oPJp8g84i4DJTqxp/nCHlNGCXbnUbNY0JwOhEotEkJF+UHVCKbiYTbklTUVjQ
 v4FwA8MHfAAgdFtnBzdaFAgJelWJwTiy40kVDIw==
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 13, 2020 at 09:16:12AM -0700, Kees Cook wrote:
> On Mon, Jul 13, 2020 at 02:55:22PM +0530, Allen wrote:
> > Oscar,
> > >
> > > I'm working to modernize the tasklet api but I don't understand the =
reply
> > > to the patch 12/16 [1] of the patch series of Romain Perier [2].
> >
> >  Am working on the same too. I did try reaching out to Romain but not =
luck.
> > Let's hope we are not duplicating efforts.

Don't worry. The work done by me for the moment has been to read all the R=
omain
patches.

> > > If this patch is combined with the first one, and the function proto=
types
> > > are not changed accordingly and these functions don't use the from_t=
asklet()
> > > helper, all the users that use the DECLARE_TASKLET macro don't pass =
the
> > > correct argument to the .data field.
> > >
> > >  #define DECLARE_TASKLET(name, func, data) \
> > > -struct tasklet_struct name =3D { NULL, 0, ATOMIC_INIT(0), func, dat=
a }
> > > +struct tasklet_struct name =3D { NULL, 0, ATOMIC_INIT(0), (TASKLET_=
FUNC_TYPE)func, (TASKLET_DATA_TYPE)&name }
> > >
> >
> >  Ideally this above bit should have been part of the first patch.
>
> Right, the idea was to have a single patch that contained all the
> infrastructure changes to support the conversion patches.

Ok, thanks for the explanation.

> --
> Kees Cook

Thanks,
Oscar Carter
