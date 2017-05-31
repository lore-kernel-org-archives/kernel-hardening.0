Date: Wed, 31 May 2017 15:36:15 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20170531153615.37fea64a@alans-desktop>
In-Reply-To: <CANA3KFWE2kUwdzGAGwRn8x4ceFzx5Z-quC2WBwqvks8LkTCh+A@mail.gmail.com>
References: <5c5c9b06-d2ec-c2e5-3ea2-463f315428f6@nmatt.com>
	<CANA3KFUh6Q+Pq6Srh-dQv0gaRy4zUJAJcyGLYoDFH+MfTycp+A@mail.gmail.com>
	<1a1730f3-5378-1ce5-77a9-b9bc8cd5c90b@nmatt.com>
	<CAGXu5jJrEw1WOGniTV4Jhv_mO2zHxmXJqpzUs7BOUJNpCU1MNg@mail.gmail.com>
	<20170517174113.69d1cbaa@alans-desktop>
	<1495045540.1619.1.camel@gmail.com>
	<CAGXu5jL9GUyVYf3d+13UE7UHd+CvUzVwasyCfUmF+ykaY5rpOQ@mail.gmail.com>
	<CANA3KFWF-=6AWZKAc1ijyoL5vRAwPnwngZZEP9=5+AFgnMv1rg@mail.gmail.com>
	<20170519143344.GA15983@mail.hallyn.com>
	<CANA3KFXVzSXuA4Cocm7fUYE9EOvJX7pW0bsj=cgyUYvScUsXGQ@mail.gmail.com>
	<20170530155235.GA11861@mail.hallyn.com>
	<20170530225245.092497be@alans-desktop>
	<CANA3KFWE2kUwdzGAGwRn8x4ceFzx5Z-quC2WBwqvks8LkTCh+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v6 0/2] security: tty: make
 TIOCSTI ioctl require CAP_SYS_ADMIN
To: Peter Dolding <oiaohm@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Daniel Micay <danielmicay@gmail.com>, Matt Brown <matt@nmatt.com>, Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, James Morris <jmorris@namei.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

> Alan is right.   CAP_SYS_ADMIN allows crossing the tty barrier.

I don't need CAP_ anything to mmap your frame buffer, or use selection to
cut and paste text into the terminal.

> Broken applications that you can wrap in a pty/tty pair as the lxc
> application does would be defeated if those applications move up to
> CAP_SYS_ADMIN.  Because you have granted the high right of cross
> pty/tty containment.

Yes

> I don't know of a genuine program using push back in exploiting way
> where the pushed back input is expected to be processed after the
> program has terminated.

So there are two real problems here

1. We don't know what namespace each character belongs to, so there's no
way we can construct a model where pushed symbols only appear in the
namespace they are pushed from. That would be a nice situation but it's
not at all obvious there is a sane way to implement it.

2. Focussing on TIOCSTI is just ignoring the bigger picture. TIOCSTI is
actually a lot less nasty in many situations than a framebuffer mmap and
spying attack where a container run from the console could sit and watch
you. TIOCSTI is in some ways the easiest to fix because setsid() will let
you mitigate it in certain cases whereas I'm fairly sure the selection
based console attack doesn't need controlling terminal rights.

In the case you have a less privileged subshell you need a whole new tty
context, and there's no obvious way for the kernel to magic one into
existance so that for example the container can change it's own baud rate
but not the baud rate of any app outside the container.

ioctl whitelisting will break stuff, but an SELinux/AppArmour/seccomp
whitelisting based solution is probably the only practical one you can
implement usefully, and for a lot of container users would be ok.

And yes there are genuine users of TIOCSTI although these days most
things just use their own pty/tty pair.

Alan
