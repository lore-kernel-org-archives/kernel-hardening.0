Date: Tue, 25 Apr 2017 20:30:15 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20170425203015.1ae62057@lxorguk.ukuu.org.uk>
In-Reply-To: <CAG48ez0uYkAg65iBZ8cKLxzFyEK=Axt=NP7jnmQkFp4rN=0GzA@mail.gmail.com>
References: <20170425041512.13189-1-matt@nmatt.com>
	<20170425144746.0d8721a3@lxorguk.ukuu.org.uk>
	<CAG48ez0uYkAg65iBZ8cKLxzFyEK=Axt=NP7jnmQkFp4rN=0GzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v5 0/2] security: tty: make TIOCSTI ioctl require
 CAP_SYS_ADMIN
To: Jann Horn <jannh@google.com>
Cc: Matt Brown <matt@nmatt.com>, serge@hallyn.com, jmorris@namei.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jslaby@suse.com, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 25 Apr 2017 15:56:32 +0200
Jann Horn <jannh@google.com> wrote:

> On Tue, Apr 25, 2017 at 3:47 PM, Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
> >> There could be a few user programs that would be effected by this
> >> change.
> >> See: <https://codesearch.debian.net/search?q=ioctl%5C%28.*TIOCSTI>
> >> notable programs are: agetty, csh, xemacs and tcsh
> >>
> >> However, I still believe that this change is worth it given that the
> >> Kconfig defaults to n. This will be a feature that is turned on for the
> >> same reason that people activate it when using grsecurity. Users of this
> >> opt-in feature will realize that they are choosing security over some OS
> >> features  
> >
> > Only in this case they are not.
> >
> > If I am at the point I have the ability to send you TIOCSTI you already
> > lost because I can just open /dev/tty to get access to my controlling tty
> > and use write().  
> 
> In terms of PTYs, this patch does not try to prevent writes to a slave
> device (which afaik is what /dev/tty will give you). It tries to prevent the
> equivalent of writes to the master device. As far as I know, there is no
> way to go from a slave to the corresponding master without having
> access to the master in some other way already.

Ok so the point I was trying to make about write and read is I can
already trash your channel when you su. Probably less irritatingly.

In the pty case yes I can go from the tty to pty trivially and then open
it, however the owner of the pty side would normally have exclusivity so
while it's a potential hole it isn't a trivial one.

If I want to do the equvalent of the TIOCSTI attack then I fork a process
and exit the parent. The child can now use ptrace to reprogram your shell
to do whatever interesting things it likes (eg running child processes
called "su" via a second pty/tty pair). Not exactly rocket science.

The tty layer does not try to manage this because it can't and two
processes with the same uid are not protected from one another in the
traditional Unix model. As with anything else when you try and glue
namespaces on top of a model not designed for it you get a pile of holes.

There is no safe way to fix it if you can't trust the environment you are
communicating through. Secure practice is either to make another
connection or if local to switch console and use SAK then login.

In the namespaces case it certainly makes sense to forbid a process in
one namespace from typing characters into another namespace but to me
that implies that tty sessions/job control are namespaced, and that makes
transitioning namespace or even just typing stuff into a docker container
shell rather more tricky to get right if you have to be in the right tty
session _and_ namespace to use the tty.

Alan
