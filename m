Return-Path: <kernel-hardening-return-21714-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id DE858C0032E
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Oct 2023 17:11:07 +0000 (UTC)
Received: (qmail 9321 invoked by uid 550); 25 Oct 2023 17:10:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9284 invoked from network); 25 Oct 2023 17:10:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698253845; x=1698858645; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WbCzlcs1e/xyWA1Lmpsd2IcmsRjzxcTLP4u0CYsVcpQ=;
        b=irAvu/2Hu1SFf9JgmANLO3iiaJWnSNKgRFrOw0zDXsWJomr5nZaO17XqWMXjR0Y22x
         9vifXQoAewsKAMwSwTPQHRuBd3eIhziE0X3Iqa8q4Lo36BwsjSNZ+qwqpHkXFGv0+bmI
         jvwS6SNU146kksQq8jnqI7JrYrtVWERCABjZaTq+cLfhhofs4RSSbFB784u/13+XBu3j
         +0xdUgQKUZe+oXyYYoZ0Gqj7RDGW/ZYuDIasjfNaAxDg7DZJB3G10CO+32cc7hTd88nT
         vcddYtyFy8BzwTIMynhi9tmObNRZwqTb/SpcWkUzq7+9g4tbgFvJYF9uqHoZ+HeyVaas
         bcpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698253845; x=1698858645;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WbCzlcs1e/xyWA1Lmpsd2IcmsRjzxcTLP4u0CYsVcpQ=;
        b=tuTYQ+XB/tH9FznrQ0gcgmgyOdBTdlWjirxn6FOWbN3aZChoxeoP+9QkyZjh7yNoBa
         U9L7jIVAkEY/g34xUBh+EQKbLnJfottt6t1hGZkKO5RzfFAwEp+TflA0+kETqr1U/LgG
         7nj8ZjmzIE3i0X0cocvz+3S4cnnKo5lE+JrNBF1/iO9wAfmwFkiPxw9QUNp0trH+roT8
         o8OG4bmfJnr5YZgkl6UE2DLnuT12UdBYgK4sEsTsYe6ZARo690506Lv+mlyODTQBaeYa
         lwMX17rOfbp3ycGgiLsGOC9GZJ2SKSHn9z9DPBwCgksRI0tLkEXI60YjbVi9kOsfy5kK
         NQ4g==
X-Gm-Message-State: AOJu0Ywf1dTSFMhAq1f6B0VX0iGX8Ey88Z0Q9xYEJs9w1t99TbU9MMCV
	KKA/740hxL1IQdEhoqzzP5r0hH7UFl8/XPHXQ7xQ3Q==
X-Google-Smtp-Source: AGHT+IEuT5m2F+vLsyPqrvngPEJcOV2q2E/KK4G3bQy+ECWMBZP/HzYEGV6AqI1S0zF15bbRjRPWy0jFMJv1H1qaOCI=
X-Received: by 2002:a50:9ec5:0:b0:540:9444:222c with SMTP id
 a63-20020a509ec5000000b005409444222cmr125835edf.6.1698253845177; Wed, 25 Oct
 2023 10:10:45 -0700 (PDT)
MIME-Version: 1.0
References: <Y59qBh9rRDgsIHaj@mailbox.org> <20231024134608.GC320399@mail.hallyn.com>
In-Reply-To: <20231024134608.GC320399@mail.hallyn.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 25 Oct 2023 19:10:07 +0200
Message-ID: <CAG48ez2DF4unFq7wXqHVdUg+o_VYee012v0hUiGTbfnTpsPi0w@mail.gmail.com>
Subject: Re: Isolating abstract sockets
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Stefan Bavendiek <stefan.bavendiek@mailbox.org>, kernel-hardening@lists.openwall.com, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 24, 2023 at 3:46=E2=80=AFPM Serge E. Hallyn <serge@hallyn.com> =
wrote:
> Disabling them altogether would break lots of things depending on them,
> like X :)  (@/tmp/.X11-unix/X0).

FWIW, X can connect over both filesystem-based unix domain sockets and
abstract unix domain sockets. When a normal X client tries to connect
to the server, it'll try a bunch of stuff, including an abstract unix
socket address, a filesystem-based unix socket address, and TCP:

$ DISPLAY=3D:12345 strace -f -e trace=3Dconnect xev >/dev/null
connect(3, {sa_family=3DAF_UNIX, sun_path=3D@"/tmp/.X11-unix/X12345"}, 24)
=3D -1 ECONNREFUSED (Connection refused)
connect(3, {sa_family=3DAF_UNIX, sun_path=3D"/tmp/.X11-unix/X12345"}, 110)
=3D -1 ENOENT (No such file or directory)
[...]
connect(3, {sa_family=3DAF_INET, sin_port=3Dhtons(18345),
sin_addr=3Dinet_addr("127.0.0.1")}, 16) =3D 0
connect(3, {sa_family=3DAF_INET6, sin6_port=3Dhtons(18345),
inet_pton(AF_INET6, "::1", &sin6_addr), sin6_flowinfo=3Dhtonl(0),
sin6_scope_id=3D0}, 28) =3D 0
connect(3, {sa_family=3DAF_INET6, sin6_port=3Dhtons(18345),
inet_pton(AF_INET6, "::1", &sin6_addr), sin6_flowinfo=3Dhtonl(0),
sin6_scope_id=3D0}, 28) =3D -1 ECONNREFUSED (Connection refused)
connect(3, {sa_family=3DAF_INET, sin_port=3Dhtons(18345),
sin_addr=3Dinet_addr("127.0.0.1")}, 16) =3D -1 ECONNREFUSED (Connection
refused)

And the X server normally listens on both an abstract and a
filesystem-based unix socket address (see "netstat --unix -lnp").

So rejecting abstract unix socket connections shouldn't prevent an X
client from connecting to the X server, I think.
