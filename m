From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH v2] binfmt_elf: Update READ_IMPLIES_EXEC logic for modern
 CPUs
Date: Fri, 26 Apr 2019 15:02:43 +0000
Message-ID: <20190426150237.GD2303@mellanox.com>
References: <20190424203408.GA11386@beast> <20190425054242.GA7816@gmail.com>
 <CAGXu5jKWQtmt+tN9rwdCWP=7pL6GYU4DmDW4R7ViQV8r1m1J=g@mail.gmail.com>
 <20190425200725.GC58719@gmail.com>
In-Reply-To: <20190425200725.GC58719@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B789B7DDBE5CBF4D84311195D93448DB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Hector Marco-Gisbert <hecmargi@upv.es>, Marc Gonzalez <marc.w.gonzalez@free.fr>, Will Deacon <will.deacon@arm.com>, X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 25, 2019 at 10:07:25PM +0200, Ingo Molnar wrote:

> > But yes, your above diff for "has NX" is roughly correct. I'll walk
> > through each piece I'm thinking about. Here is the current state:
> >=20
> >                CPU: | lacks NX*  | has NX, ia32     | has NX, x86_64 |
> >   ELF:              |            |                  |                |
> >   missing GNU_STACK | exec-all   | exec-all         | exec-all       |
> >   GNU_STACK =3D=3D RWX  | exec-all   | exec-all         | exec-all     =
  |
> >   GNU_STACK =3D=3D RW   | exec-none  | exec-none        | exec-none    =
  |
> >=20
> > *this column has no architecture effect: NX markings are ignored by
> > hardware, but may have behavioral effects when "wants X" collides with
> > "cannot be X" constraints in memory permission flags, as in [1].
>=20
> So [1] appears to be device driver mapping a BAR that isn't intended to=20
> be excutable:
>=20
>    https://lore.kernel.org/netdev/20190418055759.GA3155@mellanox.com/
>=20
> and the question is, do we reject this at the device driver mmap() level=
=20
> already, right?

No, we wanted to reject it at the driver mmap() level, but if an
executable is marked with GNU_STACK=3DRWX then the core mm code always
calls the driver with VM_EXEC (even though the mmap isn't a stack) and
the driver becomes incompatible with userspace using GNU_STACK=3DRWX (ie
some Fortran programs, apparently)

> I suspect the best behavior is to reject as early as possible, so I agree=
=20
> with your change here - even though !NX systems tend to become less and=20
> less relevant these days.

I suggested the idea of adding a flag in either the struct file or the
file_operations flag that says mmap is never to be executable for this
file with the idea that most/all cdev users would set it.

Does that seem reasonable?

Jason
