From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 28 Nov 2017 10:12:09 +0000
Message-ID: <d9e00abc387546319b13b94affecc9e0@AcuMS.aculab.com>
References: <1511826058-2563-1-git-send-email-me@tobin.cc>
        <CA+55aFyO6sKuE16z6hgocRA8Azd6E7sO4CO=AogxF1m6vaTh4A@mail.gmail.com>
        <CA+55aFzDh7GpkKniTgQp29-6TObR8NpOKczbAW-85qux=ek0Tw@mail.gmail.com>
 <874lpelxzh.fsf@xmission.com>
In-Reply-To: <874lpelxzh.fsf@xmission.com>
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH 0/5] add printk specifier %px, unique identifier
To: "'Eric W. Biederman'" <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo
 Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan
 Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?iso-8859-2?Q?Radim_Krcm=E1r?= <rkrcmar@redhat.com>, Linux Kernel Mailing
 List <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Eric W. Biederman
> Sent: 28 November 2017 06:27
> Linus Torvalds <torvalds@linux-foundation.org> writes:
>=20
> > On Mon, Nov 27, 2017 at 4:03 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> >>
> >> So the big remaining ones for me are the /proc/<pid>/stack (stack
> >> pointers) and the /proc/net/* ones.
> >>
> >> I'm a bit disappointed that those haven't been fixed already and
> >> aren't even in this series..
> >
> > Oh well, I just did /proc/<pid>/stack by making it just print 0
> > unconditionally rather than the hex number.
>=20
> Patch?
>=20
> I know I have used /proc/<pid>/stack manually many times when looking
> at a system where something is hung/weird and I needed to see what is
> going on.  The backtrace inside the kernel can be invaluable.

Ditto - after I spotted it.
Also the similar tracebacks from echo t >/proc/sysrq-trigger
although they are less useful unless you've a big kernel message buffer.
Although they can be requested from a keyboard if everything except the
keyboard interrupt is borked.

> At the same time I don't know if we actually need the hex address.
> But please don't break that interface it is very useful.

Definitely need to know which addresses are zero (or near zero).
I will have tied the addresses there to ones available elsewhere.
(In private trace that won't be affected by whatever kernel printf
does with %p.)

If you want to hide addresses, then maybe use a write-only sysctl.

	David
