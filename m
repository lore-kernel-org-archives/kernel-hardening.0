MIME-Version: 1.0
In-Reply-To: <2ab8580e-bf8e-21bd-6bfa-33e5fa82400b@nmatt.com>
References: <20170529213800.29438-1-matt@nmatt.com> <20170529213800.29438-3-matt@nmatt.com>
 <20170529232640.16211960@alans-desktop> <CAFUG7CdDd0Yfegb1S6_wNQzje4EuLE0jPdvOE=uSQL152meyjQ@mail.gmail.com>
 <3738951f-7a4a-b37f-c695-21a2fcd45f76@schaufler-ca.com> <0e078ce7-5b62-f27c-3920-efc2ffdf342b@nmatt.com>
 <b0a29f23-4154-8f2f-98e7-0942612f0cdc@schaufler-ca.com> <e1c9e4e8-5427-b4b6-aad2-72c88552a6af@nmatt.com>
 <20170530132427.016053da@alans-desktop> <2ab8580e-bf8e-21bd-6bfa-33e5fa82400b@nmatt.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Tue, 30 May 2017 12:44:56 -0400
Message-ID: <CA+DvKQ+9xddJc6+29NXzb81gmt4mYRmUTsi=-42aVy3=xgt3bw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: Matt Brown <matt@nmatt.com>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Casey Schaufler <casey@schaufler-ca.com>, Boris Lukashev <blukashev@sempervictus.com>, Greg KH <gregkh@linuxfoundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

> Seccomp requires the program in question to "opt-in" so to speak and set
> certain restrictions on itself. However as you state above, any TIOCSTI
> protection doesn't matter if the program correctly allocates a tty/pty pair.
> This protections seeks to protect users from programs that don't do things
> correctly. Rather than killing bugs, this feature attempts to kill an entire
> bug class that shows little sign of slowing down in the world of containers and
> sandboxes.

It's possible to do it in PID1 as root without NO_NEW_PRIVS set, but
there isn't an existing implementation of that. It's not included in
init systems like systemd. There's no way to toggle that off at
runtime one that's done like this sysctl though. If a system
administrator wants to enable it, they'll need to modify a
configuration file and reboot if it was even supported by the init
system. It's the same argument that was used against
perf_event_paranoid=3. Meanwhile, perf_event_paranoid=3 is a mandatory
requirement for every Android device and toggling it at runtime is
*necessary* since that's exposed as a system property writable by the
Android Debug Bridge shell user (i.e. physical access via USB + ADB
enabled within the OS + ADB key of the ADB client accepted). There's
less use case for TIOCSTI so toggling it on at runtime isn't as
important, but a toggle like this is a LOT friendlier than a seccomp
blacklist even if that was supported by common init systems, and it's
not.
