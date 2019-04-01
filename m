From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] Convert struct pid count to refcount_t
Date: Mon, 1 Apr 2019 15:28:35 +0000
Message-ID: <76f3b894980d4a79a2c0ae815425d6a0@AcuMS.aculab.com>
References: <20190329173209.GA23683@redhat.com>
 <Pine.LNX.4.44L0.1903291519060.1497-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1903291519060.1497-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: 'Alan Stern' <stern@rowland.harvard.edu>, Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>, Jann Horn <jannh@google.com>, Joel Fernandes <joel@joelfernandes.org>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Michal
 Hocko <mhocko@suse.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Alan Stern
> Sent: 29 March 2019 19:45
...
> There is a big difference between WRITE_ONCE() and plain assignment.
> Given "WRITE_ONCE(X, 2)", the compiler will emit a simple store
> instruction.  But given "X =3D 2", the compiler is allowed to emit
> instructions equivalent to:
>=20
> =09if (X !=3D 2)
> =09=09X =3D 2;

Worse for you, it can also emit:
=09X =3D 0;
=09X =3D 2;

Many years ago I fell foul of a compiler (not C) that implemented
a write to a 2 bit wide bitfield as:
=09X &=3D ~3
=09X |=3D value
even when 'value' was a compile time constant of 3.
Took a while to find out why the linked list got f*cked.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)
