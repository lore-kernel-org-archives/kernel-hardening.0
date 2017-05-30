Date: Tue, 30 May 2017 13:24:27 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20170530132427.016053da@alans-desktop>
In-Reply-To: <e1c9e4e8-5427-b4b6-aad2-72c88552a6af@nmatt.com>
References: <20170529213800.29438-1-matt@nmatt.com>
	<20170529213800.29438-3-matt@nmatt.com>
	<20170529232640.16211960@alans-desktop>
	<CAFUG7CdDd0Yfegb1S6_wNQzje4EuLE0jPdvOE=uSQL152meyjQ@mail.gmail.com>
	<3738951f-7a4a-b37f-c695-21a2fcd45f76@schaufler-ca.com>
	<0e078ce7-5b62-f27c-3920-efc2ffdf342b@nmatt.com>
	<b0a29f23-4154-8f2f-98e7-0942612f0cdc@schaufler-ca.com>
	<e1c9e4e8-5427-b4b6-aad2-72c88552a6af@nmatt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make
 TIOCSTI ioctl require CAP_SYS_ADMIN
To: Matt Brown <matt@nmatt.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, Boris Lukashev <blukashev@sempervictus.com>, Greg KH <gregkh@linuxfoundation.org>, "Serge
 E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Look there are two problems here

1. TIOCSTI has users

2. You don't actually fix anything

The underlying problem is that if you give your tty handle to another
process which you don't trust you are screwed. It's fundamental to the
design of the Unix tty model and it's made worse in Linux by the fact
that we use the tty descriptor to access all sorts of other console state
(which makes a ton of sense).

Many years ago a few people got this wrong. All those apps got fixes back
then. They allocate a tty/pty pair and create a new session over that.
The potentially hostile other app only gets to screw itself.

If it was only about TIOCSTI then your patch would still not make sense
because you could use on of the existing LSMs to actually write yourself
some rules about who can and can't use TIOCSTI. For that matter you can
even use the seccomp feature today to do this without touching your
kernel because the ioctl number is a value so you can just block ioctl
with argument 2 of TIOCSTI.

So please explain why we need an obscure kernel config option that normal
users will not understand which protects against nothing and can be
done already ?

Alan
