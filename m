Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <4FBE5E3C.9070600@zytor.com>
References: <20120522173942.GJ11775@ZenIV.linux.org.uk> <1337875681-20717-1-git-send-email-wad@chromium.org>
 <4FBE5E3C.9070600@zytor.com>
From: Roland McGrath <mcgrathr@google.com>
Date: Thu, 24 May 2012 11:07:31 -0700
Message-ID: <CAB=4xhp3WYoD6RnY+Y=XV18RiCLOeT-dsDmHxAVUYpaSUMpZdA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [RFC PATCH 0/3] move the secure_computing call
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org, indan@nul.nu, netdev@parisplace.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de, luto@mit.edu, serge.hallyn@canonical.com, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org, viro@zeniv.linux.org.uk, jmorris@namei.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 24, 2012 at 9:13 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> I think this really screws with using seccomp for self-interception. =A0I
> wouldn't inherently be opposed to the following flow:
>
> =A0 =A0 =A0 =A0seccomp -> ptrace -> seccomp
>
> ... i.e. if ptrace is enabled and we enable something, run it through
> seccomp again, but there are bunch of use cases (mostly involving
> SIGSYS) where doing ptrace before seccomp is just bizarre.

Are you sure?  This is ptrace syscall tracing going first.
If seccomp generates a SIGSYS, then ptrace will still get its opportunity
to intercept the signal and change the register state however it likes.


Thanks,
Roland
