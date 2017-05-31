Date: Wed, 31 May 2017 10:32:43 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
Message-ID: <20170531153243.GA31189@mail.hallyn.com>
References: <20170517174113.69d1cbaa@alans-desktop>
 <1495045540.1619.1.camel@gmail.com>
 <CAGXu5jL9GUyVYf3d+13UE7UHd+CvUzVwasyCfUmF+ykaY5rpOQ@mail.gmail.com>
 <CANA3KFWF-=6AWZKAc1ijyoL5vRAwPnwngZZEP9=5+AFgnMv1rg@mail.gmail.com>
 <20170519143344.GA15983@mail.hallyn.com>
 <CANA3KFXVzSXuA4Cocm7fUYE9EOvJX7pW0bsj=cgyUYvScUsXGQ@mail.gmail.com>
 <20170530155235.GA11861@mail.hallyn.com>
 <20170530225245.092497be@alans-desktop>
 <CANA3KFWE2kUwdzGAGwRn8x4ceFzx5Z-quC2WBwqvks8LkTCh+A@mail.gmail.com>
 <20170531153615.37fea64a@alans-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170531153615.37fea64a@alans-desktop>
Subject: Re: [kernel-hardening] Re: [PATCH v6 0/2] security: tty: make
 TIOCSTI ioctl require CAP_SYS_ADMIN
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Peter Dolding <oiaohm@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Daniel Micay <danielmicay@gmail.com>, Matt Brown <matt@nmatt.com>, Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, James Morris <jmorris@namei.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Quoting Alan Cox (gnomes@lxorguk.ukuu.org.uk):
> > Alan is right.   CAP_SYS_ADMIN allows crossing the tty barrier.
> 
> I don't need CAP_ anything to mmap your frame buffer, or use selection to
> cut and paste text into the terminal.
> 
> > Broken applications that you can wrap in a pty/tty pair as the lxc
> > application does would be defeated if those applications move up to
> > CAP_SYS_ADMIN.  Because you have granted the high right of cross
> > pty/tty containment.
> 
> Yes

Right.

> > I don't know of a genuine program using push back in exploiting way
> > where the pushed back input is expected to be processed after the
> > program has terminated.
> 
> So there are two real problems here
> 
> 1. We don't know what namespace each character belongs to, so there's no
> way we can construct a model where pushed symbols only appear in the
> namespace they are pushed from. That would be a nice situation but it's
> not at all obvious there is a sane way to implement it.
> 
> 2. Focussing on TIOCSTI is just ignoring the bigger picture. TIOCSTI is
> actually a lot less nasty in many situations than a framebuffer mmap and
> spying attack where a container run from the console could sit and watch
> you. TIOCSTI is in some ways the easiest to fix because setsid() will let
> you mitigate it in certain cases whereas I'm fairly sure the selection
> based console attack doesn't need controlling terminal rights.
> 
> In the case you have a less privileged subshell you need a whole new tty
> context, and there's no obvious way for the kernel to magic one into
> existance so that for example the container can change it's own baud rate
> but not the baud rate of any app outside the container.
> 
> ioctl whitelisting will break stuff, but an SELinux/AppArmour/seccomp
> whitelisting based solution is probably the only practical one you can
> implement usefully, and for a lot of container users would be ok.

Seccomp policy could refuse TIOCSTI to any fd, but that's not ideal.  It could
be customized per-application-start to only refuse TIOCSTI to the passed-in tty
fd, but you'd have to prevent dup then right?  Selinux can label the fd so it's
in fact ideal here.  But - is there something clever a seccomp policy could do
to work only on specified fds and any that were dup'ed?

Mind you, I of course agree that creating a new pty and passing only that in
is the sane fix.  Maybe in the end this thread will serve best as a loud
reminder / teaching moment about this issue for those about to write such an
application.
