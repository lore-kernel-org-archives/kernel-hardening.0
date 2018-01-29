From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 29 Jan 2018 15:23:39 +0000
Message-ID: <c7d092ebc21e4aedbefa9bce58dcfed4@AcuMS.aculab.com>
References: <CALCETrV1JHK1ovjjD1vbs08K1an6tq6nbRoAj9uyrY2GUYJJBA@mail.gmail.com>
 <CA+55aFzTXVRPo7OBPMo2OB26GisY8-dg6NaC8ackVJgS9M0+4w@mail.gmail.com>
 <CALCETrU42C1S3nvSuLuamXtp2-s1xBG3q5cSNVOfGThncHxBZA@mail.gmail.com>
 <b8ea504729db4073abf82ebd5d8a53c6@AcuMS.aculab.com>
 <1516976647.5438.6.camel@linux.intel.com>
 <CALCETrXaARjGa+fCmxDDYNQCgv0ZSm+DaUFoXFmRxU9J245HxQ@mail.gmail.com>
 <CA+55aFzr_tvdjsq1B+N1zrprNe-qfwo0At+r8uKiS=BGN_92vQ@mail.gmail.com>
 <20180126180722.GA13338@ZenIV.linux.org.uk>
 <CA+55aFydRUyNWz5M2nWWMsLk5dW5JjRRNcFjP62yecAJ_bSDpQ@mail.gmail.com>
 <CALCETrU9t1TO_Y7tmHnq0Qqrpmm3bBJzaAbPBV0vmtEvo28JCw@mail.gmail.com>
 <20180129131942.GC25549@arm.com>
In-Reply-To: <20180129131942.GC25549@arm.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH] x86/retpoline/entry: Disable the entire SYSCALL64 fast
 path with retpolines on
To: 'Will Deacon' <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alan Cox <alan@linux.intel.com>, the arch/x86
 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Samuel Neves <samuel.c.p.neves@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

From: Will Deacon
> Sent: 29 January 2018 13:20
...
> Another issue with this style of macro definition exists on architectures
> where the calling convention needs you to carry state around depending on
> how you packed the previous parameters. For example, on 32-bit ARM, 64-bi=
t
> values are passed in adjacent pairs of registers but the low numbered
> register needs to be even. This is what stopped me from trying to use
> existing helpers such as syscall_get_arguments to unpack the pt_regs
> and it generally means that anything that says "get me argument n" is goi=
ng
> to require constructing arguments 0..n-1 first.
>=20
> To do this properly I think we'll either need to pass back the size and
> current register offset to the arch code, or just allow the thing to be
> overridden per syscall (the case above isn't especially frequent).

If you generate a structure from the argument list that might work
'by magic'.
Certainly you can add explicit pads to any structure.

	David

=09
