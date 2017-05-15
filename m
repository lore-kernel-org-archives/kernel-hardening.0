Date: Mon, 15 May 2017 21:57:52 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20170515215752.4e9f3826@alans-desktop>
In-Reply-To: <e73698a7-7b6a-a916-3270-82dcfe0a558b@nmatt.com>
References: <20170505232018.28846-1-matt@nmatt.com>
	<20170510212920.7f6bc5e6@alans-desktop>
	<e73698a7-7b6a-a916-3270-82dcfe0a558b@nmatt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v6 0/2] security: tty: make TIOCSTI ioctl require
 CAP_SYS_ADMIN
To: Matt Brown <matt@nmatt.com>
Cc: serge@hallyn.com, gregkh@linuxfoundation.org, jslaby@suse.com, akpm@linux-foundation.org, jannh@google.com, keescook@chromium.org, jmorris@namei.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

O> I'm not implying that my patch is supposed to provide safety for
> "hundreds of other" issues. I'm looking to provide a way to lock down a
> single TTY ioctl that has caused real security issues to arise. For

In other words you are not actually fixing anything.

> this reason, it's completely incorrect to say that this feature is
> snake oil. My patch does exactly what it claims to do. No more no less.
> 
> > In addition your change to allow it to be used by root in the guest
> > completely invalidates any protection you have because I can push
> >
> > "rm -rf /\n"
> >
> > as root in my namespace and exit
> >
> > The tty buffers are not flushed across the context change so the shell
> > you return to gets the input and oh dear....  
> 
> This is precisely what my patch prevents! With my protection enabled, a
> container will only be able to use the TIOCSTI ioctl on a tty if that
> container has CAP_SYS_ADMIN in the user namespace in which the tty was
> created.

Which is not necessarily the namespace of the process that next issues a
read().

This is snake oil. There is a correct and proper process for this use
case. That proper process is to create a new pty/tty pair. There are two
cases

- processes that do it right in which case the attacker is screwed and we
  don't need to mess up TIOCSTI handling for no reason.

- processes that do it wrong. If they do it wrong then they'll also use
  all the other holes and attacks available via the same path which are
  completely unfixable without making your system basically unusable.


So can we please apply the minimum of common sense reasoning to this and
drop the patch.

Alan
