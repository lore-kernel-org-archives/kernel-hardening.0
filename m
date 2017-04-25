Date: Tue, 25 Apr 2017 22:21:35 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20170425222135.2859b1a8@lxorguk.ukuu.org.uk>
In-Reply-To: <CAG48ez2u8Op1ej9Z3z+PNaeEqh2f3LKnUqQku+g6asGc3K6q9g@mail.gmail.com>
References: <20170425041512.13189-1-matt@nmatt.com>
	<20170425144746.0d8721a3@lxorguk.ukuu.org.uk>
	<CAG48ez0uYkAg65iBZ8cKLxzFyEK=Axt=NP7jnmQkFp4rN=0GzA@mail.gmail.com>
	<20170425203015.1ae62057@lxorguk.ukuu.org.uk>
	<CAG48ez2u8Op1ej9Z3z+PNaeEqh2f3LKnUqQku+g6asGc3K6q9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v5 0/2] security: tty: make TIOCSTI ioctl require
 CAP_SYS_ADMIN
To: Jann Horn <jannh@google.com>
Cc: Matt Brown <matt@nmatt.com>, serge@hallyn.com, jmorris@namei.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jslaby@suse.com, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

> Really? By "pty", are you referring to the master? If so, as far as I know,
> to go from the slave to the master, you need one of:
> 
>  - ptrace access to a process that already has an FD to the master, via
>    ptrace() or so (/proc/$pid/fd/$fd won't work)
>  - for a BSD PTY (which AFAIK isn't used much anymore), access to
>    /dev/ptyXX

fstat() and then open *assuming* I have permissions.

> 
> Am I overlooking something?
> 
> > If I want to do the equvalent of the TIOCSTI attack then I fork a process
> > and exit the parent. The child can now use ptrace to reprogram your shell
> > to do whatever interesting things it likes (eg running child processes
> > called "su" via a second pty/tty pair). Not exactly rocket science.  
> 
> Why would the child be able to ptrace the shell? AFAICS, in the most
> relevant scenarios, the child can't ptrace the shell because the
> shell has a different UID (in the case of e.g. su or sudo). In other

If I am the attacker wanting to type something into your su when you go
and su from my account, or where the user account is trojanned I do the
following

fork
exit parent
child ptraces the shell (same uid as it's not setuid)

You type "su" return
The modified shell opens a new pty/tty pair and runs su over it
My ptrace hooks watch the pty/tty traffic until you go to the loo
My ptrace hooks switch the console 
My ptrace hooks type lots of stuff and hack your machine while eating the
output

and you come back, do stuff and then exit

And if you are in X it's even easier and I don't even need to care about
sessions or anything. X has no mechanism to sanely fix the problem, but
Wayland does.

Fortunately in any sane container case we don't give X11 handles to the
container contents. In insane cases (flatpak for example) you lose.

> scenarios, Yama, if enabled, should still stop you from doing that.
> And even with containers that have the same UID as the calling user,
> which I think is not exactly a good approach from a security perspective,
> the PID namespace should stop you from ptracing things outside the
> container.

For the case where the goal is to stop something leaking out of a
container then I agree entirely - namespaces can be used to play
whackamole with that particular one or you could use a pty/tty pair which
is how "sudo" solves the same problem space.

Disabling TIOCSTI via some magic Kconfig is silly, but making it
namespace hard is not.

If you really care about container security you could just a lightweight
vm instead but that's a different discussion ;-)

Alan
