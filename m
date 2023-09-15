Return-Path: <kernel-hardening-return-21697-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 3BA90EED61A
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Sep 2023 18:55:10 +0000 (UTC)
Received: (qmail 12008 invoked by uid 550); 15 Sep 2023 18:54:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10103 invoked from network); 15 Sep 2023 13:32:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694784753; x=1695389553; darn=lists.openwall.com;
        h=content-transfer-encoding:to:from:subject:references:mime-version
         :message-id:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TyLgUJPDwHdku4HBVALGJIIBCNNL0be1Ph4oiNqsW7s=;
        b=aDYhpnnYloFUp8hUFXF4sT5COiot61xwEreDKJmuLQ4hpOvuw03WZxcI98lrRvgtr5
         QZ4/zcDbWb4JCAwwZ5PWIT/b/9ReXIiif6Oc31lP1cJOpJmRf9qde1NP+D0nH1cfVTcI
         1ECKr8oRK26F4QS0TPB6T2PiKDhOEDD791aiMBQ4g3UPbjJG4c/X2jLiIclE/ziTDdlt
         1zEIB/NS21ApQiGF8qUpK56gyuJWlHTPL9PLHHjqJZYUF/nSE4rD1pgTnh7mmK0KBQ0b
         f35V6YZj0BC/XL2hQ7M2iM0ZTNytJBrgsBx6/goFGAuyvXTvRon4uh9W9xms4bYZfNXi
         QNZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694784753; x=1695389553;
        h=content-transfer-encoding:to:from:subject:references:mime-version
         :message-id:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TyLgUJPDwHdku4HBVALGJIIBCNNL0be1Ph4oiNqsW7s=;
        b=rNm6a0R5szQXOULmXznlYFc0p8Ags0WE5/ZvTdSoxuzR/dpPmdIOyWR00io3RyEPcl
         mg3pvPbVhT3tfBSZ5wfFmRULKJSlih3WTbwdqvYbeHGSuCUfJx8hKSqh1IfksK2JqijO
         Ip64ayrxd0WEpwOY4+x3gisVhmK04kxE4L2byMdJbjAGfUgTTl3sVb4ezpSYypGC8AL+
         29WNSx7YRDvk0H7tVavmTbCk+39hMETgVmi6NExhA4AJsw3HN60ezrrgFZ60vj/C+UvL
         sgatfitEsQ6a0pC1V/ekXEdxcsDOHkMRCKNFOyvamWGWfGM4gK2fLvvsXsU47/NrCbs/
         Q+FA==
X-Gm-Message-State: AOJu0YyD7cgN7kGWoLtsw8jCam9mjQlfaOzL1bb1j4je8pWzHMGZtNPv
	gNONeGh35ScbVC6pGmlcyswpmzdRjek=
X-Google-Smtp-Source: AGHT+IEYBHB1ti925C99gz6yyNLB4SnDs3T3pvE0j5s0dYSmgz440ozIj+nHrqaxN7/VTv/ipQAqD+SsphM=
X-Received: from sport.zrh.corp.google.com ([2a00:79e0:9d:4:7c7d:7821:5d3f:92b7])
 (user=gnoack job=sendgmr) by 2002:a17:906:396:b0:9a1:c377:419 with SMTP id
 b22-20020a170906039600b009a1c3770419mr44549eja.3.1694784752819; Fri, 15 Sep
 2023 06:32:32 -0700 (PDT)
Date: Fri, 15 Sep 2023 15:32:29 +0200
In-Reply-To: <ZO3r42zKRrypg/eM@google.com>
Message-Id: <ZQRc7e0l2SjsCB5m@google.com>
Mime-Version: 1.0
References: <20230828164117.3608812-1-gnoack@google.com> <20230828164521.tpvubdufa62g7zwc@begin>
 <ZO3r42zKRrypg/eM@google.com>
Subject: Re: [PATCH v3 0/1] Restrict access to TIOCLINUX
From: "=?iso-8859-1?Q?G=FCnther?= Noack" <gnoack@google.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>, Greg KH <gregkh@linuxfoundation.org>, 
	"Hanno =?iso-8859-1?Q?B=F6ck?=" <hanno@hboeck.de>, kernel-hardening@lists.openwall.com, 
	Kees Cook <keescook@chromium.org>, Jiri Slaby <jirislaby@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Paul Moore <paul@paul-moore.com>, 
	David Laight <David.Laight@aculab.com>, Simon Brand <simon.brand@postadigitale.de>, 
	Dave Mielke <Dave@mielke.cc>, "=?iso-8859-1?Q?Micka=EBl_Sala=FCn?=" <mic@digikod.net>, KP Singh <kpsingh@google.com>, 
	Nico Schottelius <nico-gpm2008@schottelius.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 29, 2023 at 03:00:19PM +0200, G=C3=BCnther Noack wrote:
> Let me update the list of known usages then: The TIOCL_SETSEL, TIOCL_PAST=
ESEL
> and TIOCL_SELLOADLUT mentions found on codesearch.debian.net are:
>=20
> (1) Actual invocations:
>=20
>  * consolation:
>      "consolation" is a gpm clone, which also runs as root.
>      (I have not had the chance to test this one yet.)

I have tested the consolation program with a kernel that has the patch, and=
 it
works as expected -- you can copy and paste on the console.


>  * BRLTTY:
>      Uses TIOCL_SETSEL as a means to highlight portions of the screen.
>      The TIOCSTI patch made BRLTTY work by requiring CAP_SYS_ADMIN,
>      so we know that BRLTTY has that capability (it runs as root and
>      does not drop it).
>=20
> (2) Some irrelevant matches:
>=20
>  * snapd: has a unit test mentioning it, to test their seccomp filters
>  * libexplain: mentions it, but does not call it (it's a library for
>    human-readably decoding system calls)
>  * manpages: documentation
>=20
>=20
> *Outside* of codesearch.debian.org:
>=20
>  * gpm:
>      I've verified that this works with the patch.
>      (To my surprise, Debian does not index this project's code.)

(As Samuel pointed out, I was wrong there - Debian does index it, but it do=
es
not use the #defines from the headers... who would have thought...)


> FWIW, I also briefly looked into "jamd" (https://jamd.sourceforge.net/), =
which
> was mentioned as similar in the manpage for "consolation", but that softw=
are
> does not use any ioctls at all.
>=20
> So overall, it still seems like nothing should break. =F0=9F=91=8D

Summarizing the above - the only three programs which are known to use the
affected TIOCLINUX subcommands are:

* consolation (tested)
* gpm (tested)
* BRLTTY (known to work with TIOCSTI, where the same CAP_SYS_ADMIN requirem=
ent
  is imposed for a while now)

I think that this is a safe change for the existing usages and that we have=
 done
the due diligence required to turn off these features.

Greg, could you please have another look?

Thanks,
=E2=80=94G=C3=BCnther

--=20
Sent using Mutt =F0=9F=90=95 Woof Woof
