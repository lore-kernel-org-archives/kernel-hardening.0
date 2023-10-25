Return-Path: <kernel-hardening-return-21716-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 5DEE9C07545
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Oct 2023 17:42:04 +0000 (UTC)
Received: (qmail 5418 invoked by uid 550); 25 Oct 2023 17:41:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5354 invoked from network); 25 Oct 2023 17:41:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698255702; x=1698860502; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NAZ9nGAhH3o0erIde1hPIJrXvGELXGLaUsVfM+RSmeg=;
        b=P0nPYX2Ho0rY0mluSN1+AC8RG7nYTJC2bOmDmPib5uZCePThKcQM5TK9l+YjYzPlBQ
         v2bvx9HJVfQCISARgJN6AS9zjQBPa6zj3yR2brlbp9EGMqq8QSetTM5f8xP6c91q2Yiw
         G4UZNZz0e2OQ9XfBHid/pIlPk9JCnFtv+jQameD0fiD0rk69Z+hDYQOcTmvQHCWHQVvT
         6S+LpX0iDigqwfu+JnwZ2+ZglpvOexdPPFCFLZtRMSWC2isf6mLzd9RLcSVIGvowKRz7
         PLHG/X4Bwix94FoTpYfhV6w4GmMejvCc4HODyMLCbGUmRcuWW3Rf1eJrvDIIahb34f/F
         8L8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698255702; x=1698860502;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NAZ9nGAhH3o0erIde1hPIJrXvGELXGLaUsVfM+RSmeg=;
        b=Nel9PIk5FIL4EL86CZq0DNJL/4/RqAfUEJyPTkVPmpHfQaJeDQKM30JVTZeTqr++Rs
         bLu1D/A2ca2ekhqgnPoHow8un6v0dsNmjJDP0dz6h/pR2HHIoRuiZIaXqKSP/VwW3fgV
         wLTYBjsTKYx5rJ1D0b6AWRUmeFnTN7R545iZODQgkwcZolE1r/9p1uW15Wmc+cXwpra4
         z+CUodzk0aaxLdDC/sobPI84sIOyr7JwqJdYN0E12vBX+nkOeS4EqyfLQe1NCuRgu4Jf
         IjMmddXmuODRZM1jyuqjWaSf7o6wCQ8q9u/19n3M0mET5LlqdxP2l8uP75mQt/xCeErR
         fSgw==
X-Gm-Message-State: AOJu0Yx7AKDiHiZdCuuLtAiWMxrfSb+7nioqIcBd7y984WkuAlEP2gpo
	QAXYb8KNd+1Sv4AEYuyOeOZeUomHLrXKby3qRu4A7w==
X-Google-Smtp-Source: AGHT+IGETRjieiv11ugdTejLjjbzIjSP8buXEjIFCRQqEAqn2HYOKjHiEJwZgva9XIL3KL1gydFf/zhtey/xR2xX3Xk=
X-Received: by 2002:a50:d706:0:b0:53e:7ad7:6d47 with SMTP id
 t6-20020a50d706000000b0053e7ad76d47mr122973edi.5.1698255701707; Wed, 25 Oct
 2023 10:41:41 -0700 (PDT)
MIME-Version: 1.0
References: <Y59qBh9rRDgsIHaj@mailbox.org> <20231024134608.GC320399@mail.hallyn.com>
 <CAG48ez2DF4unFq7wXqHVdUg+o_VYee012v0hUiGTbfnTpsPi0w@mail.gmail.com> <20231025172235.GA345747@mail.hallyn.com>
In-Reply-To: <20231025172235.GA345747@mail.hallyn.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 25 Oct 2023 19:41:03 +0200
Message-ID: <CAG48ez06yt4NO3QnUOLBBmrjesR2eF6GUWnffuckWEemxtUYcg@mail.gmail.com>
Subject: Re: Isolating abstract sockets
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Stefan Bavendiek <stefan.bavendiek@mailbox.org>, kernel-hardening@lists.openwall.com, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 25, 2023 at 7:22=E2=80=AFPM Serge E. Hallyn <serge@hallyn.com> =
wrote:
>
> On Wed, Oct 25, 2023 at 07:10:07PM +0200, Jann Horn wrote:
> > On Tue, Oct 24, 2023 at 3:46=E2=80=AFPM Serge E. Hallyn <serge@hallyn.c=
om> wrote:
> > > Disabling them altogether would break lots of things depending on the=
m,
> > > like X :)  (@/tmp/.X11-unix/X0).
> >
> > FWIW, X can connect over both filesystem-based unix domain sockets and
> > abstract unix domain sockets. When a normal X client tries to connect
> > to the server, it'll try a bunch of stuff, including an abstract unix
> > socket address, a filesystem-based unix socket address, and TCP:
> >
> > $ DISPLAY=3D:12345 strace -f -e trace=3Dconnect xev >/dev/null
> > connect(3, {sa_family=3DAF_UNIX, sun_path=3D@"/tmp/.X11-unix/X12345"}, =
24)
> > =3D -1 ECONNREFUSED (Connection refused)
> > connect(3, {sa_family=3DAF_UNIX, sun_path=3D"/tmp/.X11-unix/X12345"}, 1=
10)
> > =3D -1 ENOENT (No such file or directory)
> > [...]
> > connect(3, {sa_family=3DAF_INET, sin_port=3Dhtons(18345),
> > sin_addr=3Dinet_addr("127.0.0.1")}, 16) =3D 0
> > connect(3, {sa_family=3DAF_INET6, sin6_port=3Dhtons(18345),
> > inet_pton(AF_INET6, "::1", &sin6_addr), sin6_flowinfo=3Dhtonl(0),
> > sin6_scope_id=3D0}, 28) =3D 0
> > connect(3, {sa_family=3DAF_INET6, sin6_port=3Dhtons(18345),
> > inet_pton(AF_INET6, "::1", &sin6_addr), sin6_flowinfo=3Dhtonl(0),
> > sin6_scope_id=3D0}, 28) =3D -1 ECONNREFUSED (Connection refused)
> > connect(3, {sa_family=3DAF_INET, sin_port=3Dhtons(18345),
> > sin_addr=3Dinet_addr("127.0.0.1")}, 16) =3D -1 ECONNREFUSED (Connection
> > refused)
> >
> > And the X server normally listens on both an abstract and a
> > filesystem-based unix socket address (see "netstat --unix -lnp").
> >
> > So rejecting abstract unix socket connections shouldn't prevent an X
> > client from connecting to the X server, I think.
>
> Well it was just an example :)  Dbus is another.  But maybe all
> the users of abstract unix sockets will fall back gracefully to
> something else.  That'd be nice.

For what it's worth, when I try to connect to the session or system
bus on my system (like "strace -f -e trace=3Dconnect dbus-send
--session/--system /foo foo"), the connections seem to go directly to
a filesystem socket...

> For X, abstract really doesn't even make sense to me.  Has it always
> supported that?

No idea.
