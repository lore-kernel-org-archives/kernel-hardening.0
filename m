Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 4 Oct 2016 21:48:48 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20161004194848.GI2040@pc.thejh.net>
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
 <1475476886-26232-13-git-send-email-elena.reshetova@intel.com>
 <57F2B105.9050400@intel.com>
 <20161004124156.GE2040@pc.thejh.net>
 <CAGXu5j+6dBJ17UK-=DH7Vz-8qJSPnQ=CCyq4mjAiUJHEd9HfnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TA4f0niHM6tHt3xR"
Content-Disposition: inline
In-Reply-To: <CAGXu5j+6dBJ17UK-=DH7Vz-8qJSPnQ=CCyq4mjAiUJHEd9HfnA@mail.gmail.com>
Subject: Re: [kernel-hardening] [RFC PATCH 12/13] x86: x86 implementation for
 HARDENED_ATOMIC
To: Kees Cook <keescook@chromium.org>
Cc: Dave Hansen <dave.hansen@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


--TA4f0niHM6tHt3xR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 04, 2016 at 11:51:09AM -0700, Kees Cook wrote:
> On Tue, Oct 4, 2016 at 5:41 AM, Jann Horn <jann@thejh.net> wrote:
> > On Mon, Oct 03, 2016 at 12:27:01PM -0700, Dave Hansen wrote:
> >> On 10/02/2016 11:41 PM, Elena Reshetova wrote:
> >> >  static __always_inline void atomic_add(int i, atomic_t *v)
> >> >  {
> >> > -   asm volatile(LOCK_PREFIX "addl %1,%0"
> >> > +   asm volatile(LOCK_PREFIX "addl %1,%0\n"
> >> > +
> >> > +#ifdef CONFIG_HARDENED_ATOMIC
> >> > +                "jno 0f\n"
> >> > +                LOCK_PREFIX "subl %1,%0\n"
> >> > +                "int $4\n0:\n"
> >> > +                _ASM_EXTABLE(0b, 0b)
> >> > +#endif
> >> > +
> >> > +                : "+m" (v->counter)
> >> > +                : "ir" (i));
> >> > +}
> >>
> >> Rather than doing all this assembly and exception stuff, could we just=
 do:
> >>
> >> static __always_inline void atomic_add(int i, atomic_t *v)
> >> {
> >>       if (atomic_add_unless(v, a, INT_MAX))
> >>               BUG_ON_OVERFLOW_FOO()...
> >> }
> >>
> >> That way, there's also no transient state where somebody can have
> >> observed the overflow before it is fixed up.  Granted, this
> >> cmpxchg-based operation _is_ more expensive than the fast-path locked =
addl.
> >
> > I think we need some numbers, so I copypasted a bunch of kernel code to=
gether
> > so that I can benchmark this stuff in userspace without having a full k=
ernel
> > implementation of refcounting protection. My code is at the bottom of
> > the mail - please test this on other CPUs, these are just numbers from =
my
> > machine.
> >
> > The following numbers are from tests on a
> > "Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz" CPU.
> >
> > First, I'm testing the single-threaded (uncontended) case:
> >
> > $ gcc -o atomic_user_test atomic_user_test.c -std=3Dgnu99 -Wall -pthrea=
d -ggdb
> > $ time ./atomic_user_test 1 1 1000000000 # single-threaded, no protecti=
on
> > real    0m9.281s
> > user    0m9.251s
> > sys     0m0.004s
> > $ time ./atomic_user_test 1 2 1000000000 # single-threaded, racy protec=
tion
> > real    0m9.385s
> > user    0m9.365s
> > sys     0m0.003s
> > $ time ./atomic_user_test 1 3 1000000000 # single-threaded, cmpxchg pro=
tection
> > real    0m12.399s
> > user    0m12.375s
> > sys     0m0.000s
> >
> > The cmpxchg protection is something like 30% slower than the racy one. =
The
> > cmpxchg protection needs something like 12.4ns per operation, or around=
 45
> > cycles per operation. (Well, probably actually a bit less, considering =
that
> > the loop also costs some time.) My guess is that this wouldn't be notic=
eable.
> >
> > Now, I'm testing the multi-threaded (contended) case, with two threads =
that
> > only try to increment the same counter over and over again - so this is=
 a
> > pretty extreme worst-case microbenchmark:
> >
> > $ time ./atomic_user_test 2 1 1000000000 # multi-threaded, no protection
> > real    0m9.550s
> > user    0m18.988s
> > sys     0m0.000s
> > $ time ./atomic_user_test 2 2 1000000000 # multi-threaded, racy protect=
ion
> > real    0m9.249s
> > user    0m18.430s
> > sys     0m0.004s
> > $ time ./atomic_user_test 2 3 1000000000 # multi-threaded, cmpxchg prot=
ection
> > real    1m47.331s
> > user    3m34.390s
> > sys     0m0.024s
> >
> > Here, the cmpxchg-protected counter is around 11 times as slow as the
> > unprotected counter, with around 107ns per average increment. That's ar=
ound
> > 380 cycles per increment.
> >
> > I guess we probably don't care all that much about the few extra cycles=
 in
> > the uncontended case.
> > So I think the big question now is how important the performance of the
> > high-contention case is.
>=20
> What I find quite exciting about this benchmark is that they're the
> absolute worst-case: the process is doing nothing but atomic
> operations (which won't be the case for general kernel workloads) and
> the fact that the racy protection is basically lost in the noise is
> great.

Yeah, I agree.


> Now, cmpxchg looks bad here, but is, again, in the worst-case
> environment. I'll be curious to see kernel workloads with it, though.

Me too.

Btw: I just noticed that __fget() uses atomic_long_inc_not_zero(), which
is already implemented with cmpxchg on x86. So every time a multithreaded
process has multiple threads that interact with the same fd a lot, this
is already going to create racing cmpxchg loops today, and nobody seems
to have complained sufficiently loud so far. (And "perf top" says that
indeed, doing pread() in a loop in two threads spends way less time in
fget() if the threads use different fds. I'm not going to give you exact
numbers from my system because I have all kinds of debug crap turned on,
but I'll put my test code at the bottom of this mail if someone wants to
play with it.)

> As for the "racy" part, I'm not too concerned about it. (I would like
> it not to race, but given a choice, I would rather this protection was
> enabled by default.) As-is, with two threads fighting for a race, it
> can be hard to win the race, and even if there's a success, one will
> still Oops, so it's still better than what we have today: no
> notification of failure and an exploitable condition. (And, frankly,
> the act of racing and _failing_ is both threads Oopsing, so performing
> a racy would be extremely noisy on systems where they're not already
> set to panic on the first Oops...)
>=20
> Just to make sure I'm not imagining the wrong thing, the race looks like =
this:
>=20
> CPU0  CPU1
> inc->0
>             inc->1
> dec->0
> Oops
>             carry on

Yup, exactly.

In my test with an artificial worst-realistic-case bug that I did in
https://bugs.chromium.org/p/project-zero/issues/detail?id=3D856, it was
possible to get around the racy protection within seconds. Of course,
the normal cost of overflowing a reference counter comes on top of
that, and if you look at the logs while the attack is running, it is
indeed going to be very obvious - but I think that realistically, on
most systems, nobody is actually watching dmesg and looking for
oopses. Either you have panic_on_oops=3D1 or the attack is successful
and the attacker wipes the logs.


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#define _GNU_SOURCE
#include <pthread.h>
#include <err.h>
#include <sys/eventfd.h>
#include <unistd.h>

static int evfd =3D -1;

void *childfn(void *arg) {
  // uncomment the following three lines to let the threads use separate FDs
#if 0
  int evfd =3D eventfd(0, 0);
  if (evfd =3D=3D -1)
    err(1, "eventfd");
#endif
  char c =3D 'X';
  while (1) {
    pread(evfd, &c, 1, 0); // will fail every time
  }
  return NULL;
}

int main(void) {
  evfd =3D eventfd(0, 0);
  if (evfd =3D=3D -1)
    err(1, "eventfd");
  pthread_t thread;
  if (pthread_create(&thread, NULL, childfn, NULL))
    err(1, "pthread_create");
  childfn(NULL);
}
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--TA4f0niHM6tHt3xR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX9AegAAoJED4KNFJOeCOolc8QAKzA4+CF/L3tYG+5WXzMUGjR
E/gMlKhOv3RvfUT6aigVKkHr0dBZ37inKhZfyj+95ib0htB0DBUg+r0heyGjoG7Y
Rbpyx4+TeYrfnwKLepmV5E9Enw/fc2xW7b1wavS2XQyHpvOrux8PQWBEP2WVneRB
RRIbDMD9K9AC5OnjlVOsIu5fbSsKe07OK8Ny4I6ao2PkVmYZQdhR6gaQZayMdNy5
cDLRJPwns5nO2KO4WEZQNBu1PDlM6A7PTIFc3h3FsrV0bnPUIPYqHamXZPox9RAG
WhWH0Sgq5fcwG+MJwRNrYhuHIY0gWHcEs+KbYiZl8ScVPHUCPuhET+DgoSRUTfYC
VEEZ965tWLOO0MISah6BZXgKG3ULGzp4AxW4OPh7kxNI4dsBOfd+Hyn2/CsyiD5m
oEuG61wNB4yhTEffSfZH9TFCIqtjoSstL8BBEr4VsYXtLNVaedwmozd0z/u6eVgj
gwtK1wU0IfuWr5mQrcQNXbIk1dUAQnvM6x/Uk8e7TifmT15cBQyQAF9t/4YuqzHg
1+mWDWD731tb/4V7IH5NUc8Gt9OCu5GnV7VW9muDPHgkv4nW7VPA9/HCpu3aZOoj
BqB9ENlT+nJqEqgnOxSnkwdGXIV/cGaOzKpMjPajSgJbtaRzciUI7cihPpOVnNX2
JPbbTKIy/6qP1j9HyeaE
=F7rI
-----END PGP SIGNATURE-----

--TA4f0niHM6tHt3xR--
