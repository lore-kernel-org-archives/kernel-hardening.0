Message-ID: <1496169122.2164.21.camel@tycho.nsa.gov>
From: Stephen Smalley <sds@tycho.nsa.gov>
Date: Tue, 30 May 2017 14:32:02 -0400
In-Reply-To: <2ab8580e-bf8e-21bd-6bfa-33e5fa82400b@nmatt.com>
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
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make
 TIOCSTI ioctl require CAP_SYS_ADMIN
To: Matt Brown <matt@nmatt.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Casey Schaufler <casey@schaufler-ca.com>, Boris Lukashev <blukashev@sempervictus.com>, Greg KH <gregkh@linuxfoundation.org>, "Serge
 E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2017-05-30 at 12:28 -0400, Matt Brown wrote:
> On 5/30/17 8:24 AM, Alan Cox wrote:
> > Look there are two problems here
> > 
> > 1. TIOCSTI has users
> 
> I don't see how this is a problem.
> 
> > 
> > 2. You don't actually fix anything
> > 
> > The underlying problem is that if you give your tty handle to
> > another
> > process which you don't trust you are screwed. It's fundamental to
> > the
> > design of the Unix tty model and it's made worse in Linux by the
> > fact
> > that we use the tty descriptor to access all sorts of other console
> > state
> > (which makes a ton of sense).
> > 
> > Many years ago a few people got this wrong. All those apps got
> > fixes back
> > then. They allocate a tty/pty pair and create a new session over
> > that.
> > The potentially hostile other app only gets to screw itself.
> > 
> 
> Many years ago? We already got one in 2017, as well as a bunch last
> year.
> See: https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=tiocsti
> 
> > If it was only about TIOCSTI then your patch would still not make
> > sense
> > because you could use on of the existing LSMs to actually write
> > yourself
> > some rules about who can and can't use TIOCSTI. For that matter you
> > can
> > even use the seccomp feature today to do this without touching your
> > kernel because the ioctl number is a value so you can just block
> > ioctl
> > with argument 2 of TIOCSTI.
> > 
> 
> Seccomp requires the program in question to "opt-in" so to speak and
> set
> certain restrictions on itself. However as you state above, any
> TIOCSTI
> protection doesn't matter if the program correctly allocates a
> tty/pty pair.
> This protections seeks to protect users from programs that don't do
> things
> correctly. Rather than killing bugs, this feature attempts to kill an
> entire
> bug class that shows little sign of slowing down in the world of
> containers and
> sandboxes.

Just FYI, you can also restrict TIOCSTI (or any other ioctl command)
via SELinux ioctl whitelisting, and Android is using that feature to
restrict TIOCSTI usage in Android O (at least based on the developer
previews to date, also in AOSP master).

> 
> > So please explain why we need an obscure kernel config option that
> > normal
> > users will not understand which protects against nothing and can be
> > done already ?
> > 
> > Alan
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
