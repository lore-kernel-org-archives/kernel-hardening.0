Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 4 Oct 2016 14:41:56 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20161004124156.GE2040@pc.thejh.net>
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
 <1475476886-26232-13-git-send-email-elena.reshetova@intel.com>
 <57F2B105.9050400@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jKBxcB1XkHIR0Eqt"
Content-Disposition: inline
In-Reply-To: <57F2B105.9050400@intel.com>
Subject: Re: [kernel-hardening] [RFC PATCH 12/13] x86: x86 implementation for
 HARDENED_ATOMIC
To: Dave Hansen <dave.hansen@intel.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


--jKBxcB1XkHIR0Eqt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 03, 2016 at 12:27:01PM -0700, Dave Hansen wrote:
> On 10/02/2016 11:41 PM, Elena Reshetova wrote:
> >  static __always_inline void atomic_add(int i, atomic_t *v)
> >  {
> > -	asm volatile(LOCK_PREFIX "addl %1,%0"
> > +	asm volatile(LOCK_PREFIX "addl %1,%0\n"
> > +
> > +#ifdef CONFIG_HARDENED_ATOMIC
> > +		     "jno 0f\n"
> > +		     LOCK_PREFIX "subl %1,%0\n"
> > +		     "int $4\n0:\n"
> > +		     _ASM_EXTABLE(0b, 0b)
> > +#endif
> > +
> > +		     : "+m" (v->counter)
> > +		     : "ir" (i));
> > +}
>=20
> Rather than doing all this assembly and exception stuff, could we just do:
>=20
> static __always_inline void atomic_add(int i, atomic_t *v)
> {
> 	if (atomic_add_unless(v, a, INT_MAX))
> 		BUG_ON_OVERFLOW_FOO()...
> }
>=20
> That way, there's also no transient state where somebody can have
> observed the overflow before it is fixed up.  Granted, this
> cmpxchg-based operation _is_ more expensive than the fast-path locked add=
l.

I think we need some numbers, so I copypasted a bunch of kernel code togeth=
er
so that I can benchmark this stuff in userspace without having a full kernel
implementation of refcounting protection. My code is at the bottom of
the mail - please test this on other CPUs, these are just numbers from my
machine.

The following numbers are from tests on a
"Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz" CPU.

First, I'm testing the single-threaded (uncontended) case:

$ gcc -o atomic_user_test atomic_user_test.c -std=3Dgnu99 -Wall -pthread -g=
gdb
$ time ./atomic_user_test 1 1 1000000000 # single-threaded, no protection
real	0m9.281s
user	0m9.251s
sys	0m0.004s
$ time ./atomic_user_test 1 2 1000000000 # single-threaded, racy protection
real	0m9.385s
user	0m9.365s
sys	0m0.003s
$ time ./atomic_user_test 1 3 1000000000 # single-threaded, cmpxchg protect=
ion
real	0m12.399s
user	0m12.375s
sys	0m0.000s

The cmpxchg protection is something like 30% slower than the racy one. The
cmpxchg protection needs something like 12.4ns per operation, or around 45
cycles per operation. (Well, probably actually a bit less, considering that
the loop also costs some time.) My guess is that this wouldn't be noticeabl=
e.

Now, I'm testing the multi-threaded (contended) case, with two threads that
only try to increment the same counter over and over again - so this is a
pretty extreme worst-case microbenchmark:

$ time ./atomic_user_test 2 1 1000000000 # multi-threaded, no protection
real	0m9.550s
user	0m18.988s
sys	0m0.000s
$ time ./atomic_user_test 2 2 1000000000 # multi-threaded, racy protection
real	0m9.249s
user	0m18.430s
sys	0m0.004s
$ time ./atomic_user_test 2 3 1000000000 # multi-threaded, cmpxchg protecti=
on
real	1m47.331s
user	3m34.390s
sys	0m0.024s

Here, the cmpxchg-protected counter is around 11 times as slow as the
unprotected counter, with around 107ns per average increment. That's around
380 cycles per increment.

I guess we probably don't care all that much about the few extra cycles in
the uncontended case.
So I think the big question now is how important the performance of the
high-contention case is.


My test code, cobbled together from the kernel sources and the
suggested mitigations:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#define _GNU_SOURCE
#include <pthread.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <err.h>
#include <unistd.h>
#include <sys/wait.h>
#include <limits.h>

#define LOCK_PREFIX "lock; "

static __always_inline void atomic_inc_raw(int *v)
{
  asm volatile(LOCK_PREFIX "incl %0"
         : "+m" (v));
}

static __always_inline void atomic_inc_racy(int *v)
{
  asm volatile(LOCK_PREFIX "incl %0\n"
    "jno 0f\n"
    LOCK_PREFIX "decl %0\n"
    "call abort\n0:\n"
    : "+m" (v));
}

#define READ_ONCE_32(v) (*(volatile int *)(v))

static __always_inline int cmpxchg(int *v, int old, int new)
{
        volatile unsigned int *ptr =3D (volatile unsigned int *)(v);
        int ret;
        asm volatile(LOCK_PREFIX "cmpxchgl %2,%1"
                     : "=3Da" (ret), "+m" (*ptr)
                     : "r" (new), "0" (old)
                     : "memory");
        return ret;
}

static __always_inline int __atomic_add_unless_(int *v, int a, int u)
{
  int c, old;
  c =3D READ_ONCE_32(v);
  for (;;) {
    if (__builtin_expect(c =3D=3D (u), 0))
      break;
    old =3D cmpxchg((v), c, c + (a));
    if (__builtin_expect(old =3D=3D c, 1))
      break;
    c =3D old;
  }
  return c;
}

static __always_inline void atomic_inc_cmpxchg(int *v)
{
  if (__atomic_add_unless_(v, 1, INT_MAX) =3D=3D INT_MAX)
    abort();
}

int mode, type, count;
#define TYPE_RAW 1
#define TYPE_RACY 2
#define TYPE_CMPXCHG 3

int test_atomic;
void *childfn(void *arg) {
  switch (type) {
  case TYPE_RAW:
    for (int i=3D0; i<count; i++)
      atomic_inc_raw(&test_atomic);
    break;
  case TYPE_RACY:
    for (int i=3D0; i<count; i++)
      atomic_inc_racy(&test_atomic);
    break;
  case TYPE_CMPXCHG:
    for (int i=3D0; i<count; i++)
      atomic_inc_cmpxchg(&test_atomic);
    break;
  }
  return NULL;
}

int main(int argc, char **argv) {
  pthread_t thread;

  if (argc !=3D 4)
    errx(1, "bad invocation; want mode, type and count");
  mode =3D atoi(argv[1]); // 1 =3D=3D single process, 2 =3D=3D two processes
  if (mode !=3D 1 && mode !=3D 2)
    errx(1, "bad mode");
  type =3D atoi(argv[2]);
  if (type < 1 || type > 3)
    errx(1, "bad type");
  count =3D atoi(argv[3]);
  if (count <=3D 0)
    errx(1, "bad count");

  if (mode =3D=3D 2) {
    if (pthread_create(&thread, NULL, childfn, NULL))
      err(1, "pthread_create");
  }
  childfn(NULL);

  if (mode =3D=3D 2) {
    if (pthread_join(thread, NULL))
      err(1, "join");
  }

  return 0;
}
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--jKBxcB1XkHIR0Eqt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX86OUAAoJED4KNFJOeCOoHeYQAIU4j8UBCJHAImHoIFP3c3gT
MAXgwj42M3CFBg+pkKhHIQk4PAj/gaYqtCyOBiXG7Ki2wc2ycVr9rkcWkP8iGYvG
WrLtmZZ4RmWLU+Y2dWA6zbJeqhDmgwhbb9C9VZdbu55lRj1bGbS1yp7/IppxbHuI
ZE/7KRxZcbAP441/I35+CuZa2A5aDi93hmKdxQPSBt1+WeryFmNx+jmplokP8TzS
gEJ60ypChhwpdrjhk3mDdD0lzgFT52V/xhCAhYqH6nTUglpPjNrGw/s5qzz9LGD5
9S+QOs+aycu31iti5BdnK8JClR8Qq7YwuLd0BJBsNLQrvDPAgvzjDH0f5VEshmiB
OJEfhd/c/JEO1blOUMKhZRJ+h109efAonGAxTSIps2zb279PSllV4AHlldSPJt0U
DQ01sf99Qh/nr1Yl0LNBPTyTV2wlSzFVeuoJyRzPQksNoQnSf4dOFDev8oQgpT4B
RZVOxz+WjBoqoYTDyMkj49L85j65PQkAEvZ9WLOzB+RvNnhnVJH4uQiwISZH/q4s
CoNOiuPG4u7AVgweR+WVunXe75oxh/n7i8OUGVq/Ct31Dja3Fiq1g2AvieAv1CY4
PGKYsRyRU2VQhwHXXFdFcHixoT5IAgAixE4Jz3t5g5BssaLwq75BnzxgTUxrnU4B
ErmuUMjBbuz1v9Wobgt0
=hNzv
-----END PGP SIGNATURE-----

--jKBxcB1XkHIR0Eqt--
