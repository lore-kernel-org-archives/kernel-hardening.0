Date: Thu, 27 Apr 2017 13:34:21 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20170427133421.22255fd1@lxorguk.ukuu.org.uk>
In-Reply-To: <07bec2b1-c945-fc6e-0238-28acb21b5cfb@nmatt.com>
References: <20170425041512.13189-1-matt@nmatt.com>
	<20170425144746.0d8721a3@lxorguk.ukuu.org.uk>
	<CAG48ez0uYkAg65iBZ8cKLxzFyEK=Axt=NP7jnmQkFp4rN=0GzA@mail.gmail.com>
	<20170425203015.1ae62057@lxorguk.ukuu.org.uk>
	<CAG48ez2u8Op1ej9Z3z+PNaeEqh2f3LKnUqQku+g6asGc3K6q9g@mail.gmail.com>
	<20170425222135.2859b1a8@lxorguk.ukuu.org.uk>
	<CAG48ez31W30Qqmf5ZZ1_eVQC0uobBrva3_zgRdzejztFLzKoPg@mail.gmail.com>
	<20170426134732.7579ebdd@lxorguk.ukuu.org.uk>
	<07bec2b1-c945-fc6e-0238-28acb21b5cfb@nmatt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v5 0/2] security: tty: make TIOCSTI ioctl require
 CAP_SYS_ADMIN
To: Matt Brown <matt@nmatt.com>
Cc: Jann Horn <jannh@google.com>, serge@hallyn.com, jmorris@namei.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jslaby@suse.com, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

> > Which is the sudo case and why sudo uses a separate pty/tty pair as it's
> > not just TIOCSTI that's an issue but there are a load of ioctls that do
> > things like cause signals to the process or are just annoying -
> > vhangup(), changing the speed etc
> >
> > (And for console changing the keymap - which is a nasty one)
> >  
> 
> Are any of these annoyances potential security issues? I would be happy
> to add patches or modify this one to include extra hardening measures.

Or you could just use pty/tty pairs properly the way sudo and other
applications do perfectly well.

Lots of them are potential security issues - if I sent your console to
1x1 char, change the font and keymap you'd proably be peeved 8-)

It's not about hardening against all these (which would break lots of
legitimate use cases), it's about having the affected applications do the
right thing.

It makes sense that TIOCSTI honours namespaces. However it and everything
else are correctly handled by creating the lower security level process
with its own pty/tty pair.

Alan
