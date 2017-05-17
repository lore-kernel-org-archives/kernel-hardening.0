Message-ID: <1495045540.1619.1.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Wed, 17 May 2017 14:25:40 -0400
In-Reply-To: <20170517174113.69d1cbaa@alans-desktop>
References: <20170505232018.28846-1-matt@nmatt.com>
	 <20170510212920.7f6bc5e6@alans-desktop>
	 <e73698a7-7b6a-a916-3270-82dcfe0a558b@nmatt.com>
	 <20170515215752.4e9f3826@alans-desktop>
	 <CANA3KFU6Aor=NjdC49XpX=h29vSpeiDNn78en7sbZFosAcntGw@mail.gmail.com>
	 <5c5c9b06-d2ec-c2e5-3ea2-463f315428f6@nmatt.com>
	 <CANA3KFUh6Q+Pq6Srh-dQv0gaRy4zUJAJcyGLYoDFH+MfTycp+A@mail.gmail.com>
	 <1a1730f3-5378-1ce5-77a9-b9bc8cd5c90b@nmatt.com>
	 <CAGXu5jJrEw1WOGniTV4Jhv_mO2zHxmXJqpzUs7BOUJNpCU1MNg@mail.gmail.com>
	 <20170517174113.69d1cbaa@alans-desktop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v6 0/2] security: tty: make
 TIOCSTI ioctl require CAP_SYS_ADMIN
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Kees Cook <keescook@chromium.org>
Cc: Matt Brown <matt@nmatt.com>, Peter Dolding <oiaohm@gmail.com>, "Serge E.
 Hallyn" <serge@hallyn.com>, Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, James Morris <jmorris@namei.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2017-05-17 at 17:41 +0100, Alan Cox wrote:
> > If we're adjusting applications, they should be made to avoid
> > TIOSCTI
> > completely. This looks to me a lot like the symlink restrictions:
> > yes,
> > userspace should be fixed to the do the right thing, but why not
> > provide support to userspace to avoid the problem entirely?
> 
> We do it's called pty/tty. There isn't any other way to do this
> correctly
> because TIOCSTI is just one hundreds of things the attacker can do to
> make your life miserable in the case you create a child process of
> lower
> security privilege and give it your tty file handle or worse (like
> some
> container crapware) your X11 socket fd.
> 
> Does it really matter any more or less if I reprogram your enter key,
> use
> TIOCSTI, set the baud rate, change all your fonts ?
> 
> The mainstream tools like sudo get this right (*). Blocking TIOCSTI
> fixes
> nothing and breaks apps. If it magically fixed the problem it might
> make
> sense but it doesn't. You actually have to get an adult to write the
> relevant code.

It gets it right because it was reported as a vulnerability and fixed,
which is the cycle many of these tools have gone through. It looks like
sudo and coreutils / shadow su were fixed in 2005, but there are more of
these tools.

CVE-2005-4890 (coreutils su, shadow su, sudo), CVE-2016-7545 (SELinux
sandbox utility), CVE-2016-2781 (chroot --userspec), CVE-2016-2779
(util-linux runuser), CVE-2016-2568 (pkexec)

I am not sure if the pkexec vulnerability is even fixed:

https://bugzilla.redhat.com/show_bug.cgi?id=1300746

CVE-2017-5226 is for bubblewrap/flatpak this year, and I'm sure there
were a lot more as I didn't bother to dig very deep.

I completely agree that it should be solved by doing things properly in
each application. However, it isn't solved properly everywhere and each
new application is making the same mistake. Providing this feature does
not break anything that people use in practice and it doesn't need to
solve every issue to be quite useful, it only needs to prevent local
privilege escalation in the form of code execution in many cases. Is
there another way to get code execution via that bubblewrap/flatpak bug
with this feature implemented? As far as I can tell, there isn't. It's a
problem even with this feature but a significantly less serious one.
