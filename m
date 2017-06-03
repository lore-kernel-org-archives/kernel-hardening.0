Date: Sat, 3 Jun 2017 23:00:48 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20170603230048.52b7f111@lxorguk.ukuu.org.uk>
In-Reply-To: <48a28010-9f35-63e4-b815-71bb6139d50b@nmatt.com>
References: <20170530132427.016053da@alans-desktop>
	<2ab8580e-bf8e-21bd-6bfa-33e5fa82400b@nmatt.com>
	<20170530235106.11aab25c@alans-desktop>
	<3bd4ff7b-6f7d-52b0-03f6-026bac79f11f@nmatt.com>
	<20170531005633.484a2e14@alans-desktop>
	<CAGXu5j+pqD1082fYDS_dvDB2QNvt9wSz+C7vAhGpMXcJWxoDkw@mail.gmail.com>
	<20170601140812.583cf0a5@alans-desktop>
	<CAGXu5jLefv=T3mCYryqh2pYjYonFsTQZSLsHqLK75CKvSmgb-w@mail.gmail.com>
	<20170601222432.6f593538@lxorguk.ukuu.org.uk>
	<2d0ad49c-886e-1caf-771a-d251957f614c@nmatt.com>
	<20170602153647.GA2688@mail.hallyn.com>
	<a3c1b792-a426-90e1-e37b-9f9a8d4d192a@nmatt.com>
	<20170602210544.73680be8@lxorguk.ukuu.org.uk>
	<48a28010-9f35-63e4-b815-71bb6139d50b@nmatt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make
 TIOCSTI ioctl require CAP_SYS_ADMIN
To: Matt Brown <matt@nmatt.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Casey Schaufler <casey@schaufler-ca.com>, Boris Lukashev <blukashev@sempervictus.com>, Greg KH <gregkh@linuxfoundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

> TIOCSLCKTRMIOS

That one I'm more dubious about

> TIOCSLTC
> TIOCSSOFTCAR

tty_io.c also has a few and n_tty has a couple we'd want.

> 
> would it be overkill to have a sysctl kernel.ttyioctlwhitelist.X where X
> is one of the ioctls above?

Why would anyone want to change the entries on that list

Alan
