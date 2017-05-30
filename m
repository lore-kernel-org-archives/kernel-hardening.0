Message-ID: <1496175757.9871.6.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Tue, 30 May 2017 16:22:37 -0400
In-Reply-To: <100b7d8c-7468-3122-4f59-3b0dcdf5dfc3@nmatt.com>
References: <20170529213800.29438-1-matt@nmatt.com>
	 <20170529213800.29438-3-matt@nmatt.com>
	 <20170529232640.16211960@alans-desktop>
	 <CAFUG7CdDd0Yfegb1S6_wNQzje4EuLE0jPdvOE=uSQL152meyjQ@mail.gmail.com>
	 <3738951f-7a4a-b37f-c695-21a2fcd45f76@schaufler-ca.com>
	 <0e078ce7-5b62-f27c-3920-efc2ffdf342b@nmatt.com>
	 <b0a29f23-4154-8f2f-98e7-0942612f0cdc@schaufler-ca.com>
	 <e1c9e4e8-5427-b4b6-aad2-72c88552a6af@nmatt.com>
	 <20170530132427.016053da@alans-desktop>
	 <2ab8580e-bf8e-21bd-6bfa-33e5fa82400b@nmatt.com>
	 <1496169122.2164.21.camel@tycho.nsa.gov>
	 <CAFJ0LnHKKccbr-LqHHaFX5UNB20DzqfWDhvR-NTpgPedtkg0RA@mail.gmail.com>
	 <100b7d8c-7468-3122-4f59-3b0dcdf5dfc3@nmatt.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make
 TIOCSTI ioctl require CAP_SYS_ADMIN
To: Matt Brown <matt@nmatt.com>, Nick Kralevich <nnk@google.com>, Stephen Smalley <sds@tycho.nsa.gov>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Casey Schaufler <casey@schaufler-ca.com>, Boris Lukashev <blukashev@sempervictus.com>, Greg KH <gregkh@linuxfoundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

> Thanks, I didn't know that android was doing this. I still think this
> feature
> is worthwhile for people to be able to harden their systems against
> this attack
> vector without having to implement a MAC.

Since there's a capable LSM hook for ioctl already, it means it could go
in Yama with ptrace_scope but core kernel code would still need to be
changed to track the owning tty. I think Yama vs. core kernel shouldn't
matter much anymore due to stackable LSMs.

Not the case for perf_event_paranoid=3 where a) there's already a sysctl
exposed which would be unfortunate to duplicate, b) there isn't an LSM
hook yet (AFAIK).

The toggles for ptrace and perf events are more useful though since
they're very commonly used debugging features vs. this obscure, rarely
used ioctl that in practice no one will notice is missing. It's still
friendlier to have a toggle than a seccomp policy requiring a reboot to
get rid of it, or worse compiling it out of the kernel.
