Date: Fri, 2 Jun 2017 13:18:22 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
Message-ID: <20170602181822.GA5125@mail.hallyn.com>
References: <20170531005633.484a2e14@alans-desktop>
 <CAGXu5j+pqD1082fYDS_dvDB2QNvt9wSz+C7vAhGpMXcJWxoDkw@mail.gmail.com>
 <20170601140812.583cf0a5@alans-desktop>
 <CAGXu5jLefv=T3mCYryqh2pYjYonFsTQZSLsHqLK75CKvSmgb-w@mail.gmail.com>
 <20170601222432.6f593538@lxorguk.ukuu.org.uk>
 <2d0ad49c-886e-1caf-771a-d251957f614c@nmatt.com>
 <20170602153647.GA2688@mail.hallyn.com>
 <a3c1b792-a426-90e1-e37b-9f9a8d4d192a@nmatt.com>
 <20170602165732.GA3614@mail.hallyn.com>
 <3027e4fa-5dc2-a52f-8699-9974cb4d4b6b@nmatt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3027e4fa-5dc2-a52f-8699-9974cb4d4b6b@nmatt.com>
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make
 TIOCSTI ioctl require CAP_SYS_ADMIN
To: Matt Brown <matt@nmatt.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Kees Cook <keescook@chromium.org>, Casey Schaufler <casey@schaufler-ca.com>, Boris Lukashev <blukashev@sempervictus.com>, Greg KH <gregkh@linuxfoundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Quoting Matt Brown (matt@nmatt.com):
> On 6/2/17 12:57 PM, Serge E. Hallyn wrote:
> > I'm not quite sure what you're asking for here.  Let me offer a precise
> > strawman design.  I'm sure there are problems with it, it's just a starting
> > point.
> > 
> > system-wide whitelist (for now 'may_push_chars') is full by default.
> > 
> 
> So is may_push_chars just an alias for TIOCSTI? Or are there some
> potential whitelist members that would map to multiple ioctls?

<shrug>  I'm seeing it as only TIOCSTI right now.

> > By default, nothing changes - you can use those on your own tty, need
> > CAP_SYS_ADMIN against init_user_ns otherwise.
> > 
> > Introduce a new CAP_TTY_PRIVILEGED.
> > 
> 
> I'm fine with this.
> 
> > When may_push_chars is removed from the whitelist, you lose the ability
> > to use TIOCSTI on a tty - even your own - if you do not have CAP_TTY_PRIVILEGED
> > against the tty's user_ns.
> > 
> 
> How do you propose storing/updating the whitelist? sysctl?
> 
> If it is a sysctl, would each whitelist member have a sysctl?
> e.g.: kernel.ioctlwhitelist.may_push_chars = 1
> 
> Overall, I'm fine with this idea.

That sounds reasonable.  Or a securityfs file - I guess not everyone
has securityfs, but if it were to become part of YAMA then that would
work.

-serge
