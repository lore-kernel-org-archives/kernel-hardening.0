Date: Wed, 31 May 2017 00:56:33 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20170531005633.484a2e14@alans-desktop>
In-Reply-To: <3bd4ff7b-6f7d-52b0-03f6-026bac79f11f@nmatt.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make
 TIOCSTI ioctl require CAP_SYS_ADMIN
To: Matt Brown <matt@nmatt.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, Boris Lukashev <blukashev@sempervictus.com>, Greg KH <gregkh@linuxfoundation.org>, "Serge
 E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

> This is my point. Apps will continue to shoot themselves in the foot. Of course
> the correct response to one of these vulns is to not pass ttys across a
> security boundary. We have an opportunity here to reduce the impact of this bug
> class at the kernel level. 

Not really.

If you pass me your console for example I can mmap your framebuffer and
spy on you all day. Or I could reprogram your fonts, your keyboard, your
video mode, or use set and paste selection to write stuff. If you are
using X and you can't get tty handles right you'll no doubt pass me a
copy of your X file descriptor in which case I own your display, your
keyboard and your mouse and I don't need to use TIOCSTI there either.

There are so many different attacks based upon that screwup that the
kernel cannot defend against them. You aren't exactly reducing the impact.

Alan
