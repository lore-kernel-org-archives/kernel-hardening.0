Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Mon, 16 Jan 2017 16:16:15 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C3DB77@IRSMSX102.ger.corp.intel.com>
References: <1482994571-18687-9-git-send-email-elena.reshetova@intel.com>
 <20170105022535.GA20972@linaro.org>
 <2236FBA76BA1254E88B949DDB74E612B41C380E4@IRSMSX102.ger.corp.intel.com>
 <CAGXu5jKYN8WS-mkAfBNOyJ2+Zpy=0ErxS8Ow6K0hAWgkyb9Bpw@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41C3A6D8@IRSMSX102.ger.corp.intel.com>
 <CAGXu5jKDYE7AHrXchNDLmvNMbvGytZDks6W1=i6+fyFX9ZGoNA@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41C3BD08@IRSMSX102.ger.corp.intel.com>
 <CAGXu5jJe0F_z5unvTg7y1myka+AP7Qn5mShEw9DS2M+c=NqpBA@mail.gmail.com>
 <CAGXu5jLC-drraZ3D5bj3_rO4LEFiUhutHHw7U8AfDyAEHg+xtg@mail.gmail.com>
 <20170112051114.GG20972@linaro.org>
 <20170112085714.GC3081@twins.programming.kicks-ass.net>
In-Reply-To: <20170112085714.GC3081@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: RE: [kernel-hardening] [RFC PATCH 08/19] kernel, mm: convert from
 atomic_t to refcount_t
To: Peter Zijlstra <peterz@infradead.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "dwindsor@gmail.com" <dwindsor@gmail.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "ishkamiel@gmail.com" <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

> On Thu, Jan 12, 2017 at 02:11:15PM +0900, AKASHI Takahiro wrote:
> > On Wed, Jan 11, 2017 at 02:55:21PM -0800, Kees Cook wrote:
> > > On Wed, Jan 11, 2017 at 1:42 PM, Kees Cook <keescook@chromium.org>
> wrote:
> > > > I can see if it'll cherry-pick cleanly, I assume it will. :)
> > >
> > > It cherry-picked cleanly. However, I made several changes:
> > >
> > > - I adjusted Peter's author email (it had extra []s around).
> > > - I fixed all of the commit subjects (Peter's were missing).
> > > - I added back "kref: Add KREF_INIT()" since it seems to have been
> > > lost and mixed into other patches that would break bisection
> > >
> > > It's here now, please work from this version:
> > >
> > >
> http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=3Dkspp/=
hardened-
> atomic
> >
> > I gave it a spin on arm64.
> > It can compile with a change to smp.c that I mentioned before,
> > but the boot failed. I've not dug into it.
> >
> > =3D=3D=3D8<=3D=3D=3D
> > [    3.578618] refcount_t: increment on 0; use-after-free.
> > [    3.579165] ------------[ cut here ]------------
> > [    3.579254] WARNING: CPU: 0 PID: 1 at /home/akashi/arm/armv8/linaro/=
linux-
> aarch64/include/linux/refcount.h:109 unx_create+0x8c/0xc0
>=20
> That's dodgy code, someone needs to look at that.
>=20
> It has an inc in a function called 'create' which seems to suggest its
> objection creation and we should be using refcount_set() instead.
>=20
> Then again, it looks like you can call this 'create' method multiple
> times, each time returning the same static object, so refcount_set()
> would not be correct.
>=20
> Using a refcount on a static object is weird of course, so this is bound
> to give trouble.

I have reverted this one back to atomic and added it to the tracking doc.
The problem for this one is that it is not always used as static and in oth=
er cases
it is even initialized correctly to 1, but this static case seems to be spe=
cial one giving troubles...

Last week I also fixed all the warnings/errors that test infra gave. The qu=
estion that comes is what next? How do we really test this further apart fr=
om just booting this up?=20
