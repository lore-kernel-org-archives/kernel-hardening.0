Date: Thu, 1 Jun 2017 14:08:12 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20170601140812.583cf0a5@alans-desktop>
In-Reply-To: <CAGXu5j+pqD1082fYDS_dvDB2QNvt9wSz+C7vAhGpMXcJWxoDkw@mail.gmail.com>
References: <20170529213800.29438-1-matt@nmatt.com>
	<20170529213800.29438-3-matt@nmatt.com>
	<20170529232640.16211960@alans-desktop>
	<CAFUG7CdDd0Yfegb1S6_wNQzje4EuLE0jPdvOE=uSQL152meyjQ@mail.gmail.com>
	<3738951f-7a4a-b37f-c695-21a2fcd45f76@schaufler-ca.com>
	<0e078ce7-5b62-f27c-3920-efc2ffdf342b@nmatt.com>
	<b0a29f23-4154-8f2f-98e7-0942612f0cdc@schaufler-ca.com>
	<e1c9e4e8-5427-b4b6-aad2-72c88552a6af@nmatt.com>
	<20170530132427.016053da@alans-desktop>
	<2ab8580e-bf8e-21bd-6bfa-33e5fa82400b@nmatt.com>
	<20170530235106.11aab25c@alans-desktop>
	<3bd4ff7b-6f7d-52b0-03f6-026bac79f11f@nmatt.com>
	<20170531005633.484a2e14@alans-desktop>
	<CAGXu5j+pqD1082fYDS_dvDB2QNvt9wSz+C7vAhGpMXcJWxoDkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make
 TIOCSTI ioctl require CAP_SYS_ADMIN
To: Kees Cook <keescook@chromium.org>
Cc: Matt Brown <matt@nmatt.com>, Casey Schaufler <casey@schaufler-ca.com>, Boris Lukashev <blukashev@sempervictus.com>, Greg KH <gregkh@linuxfoundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

> I still cannot wrap my head around why providing users with a
> protection is a bad thing. Yes, the other tty games are bad, but this
> fixes a specific and especially bad case that is easy to kill. It's
> got a Kconfig and a sysctl. It's not on by default. This protects the
> common case of privileged ttys that aren't attached to consoles, etc,

Which just leads to stuff not getting fixed. Like all the code out there
today which is still vulnerable to selection based attacks because people
didn't do the job right when "fixing" stuff because they are not
thinking about security at a systems level but just tickboxing CVEs.

I'm not against doing something to protect the container folks, but that
something as with Android is a whitelist of ioctls. And if we need to do
this with a kernel hook lets do it properly.

Remember the namespace of the tty on creation
If the magic security flag is set then
	Apply a whitelist to *any* tty ioctl call where the ns doesn't
		match

and we might as well just take the Android whitelist since they've kindly
built it for us all!

In the tty layer it ends up being something around 10 lines of code and
some other file somewhere in security/ that's just a switch or similar
with the whitelisted ioctl codes in it.

That (or a similar SELinux ruleset) would actually fix the problem.
SELinux would be better because it can also apply the rules when doing
things like su/sudo/...

Alan
