Date: Tue, 30 May 2017 22:52:45 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20170530225245.092497be@alans-desktop>
In-Reply-To: <20170530155235.GA11861@mail.hallyn.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v6 0/2] security: tty: make
 TIOCSTI ioctl require CAP_SYS_ADMIN
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Peter Dolding <oiaohm@gmail.com>, Kees Cook <keescook@chromium.org>, Daniel Micay <danielmicay@gmail.com>, Matt Brown <matt@nmatt.com>, Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, James Morris <jmorris@namei.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

> > So tty stuff should under a tty capabilities.  
> 
> (last reply on this)
> 
> Currently capabilities.7 says
> 
>               * employ  the  TIOCSTI ioctl(2) to insert characters into the input queue of a
>                 terminal other than the caller's controlling terminal;
> 
> for CAP_SYS_ADMIN.
> 
> So you can create a new CAP_SYS_TIOCSSTI if you like, and offer a patch where
> *both* CAP_SYS_ADMIN and CAP_SYS_ADMIN suffice.  Again, see CAP_SYSLOG for a
> prior example.

Even then it wouldn't be useful because the attacker can use every other
interface in the tty layer, many of which you can't magic away behind a
capability bit. And the applications would need changing to use the
feature - at which point any theoretical broken apps can instead be fixed
to use a pty/tty pair and actually fix the real problem.

Alan
