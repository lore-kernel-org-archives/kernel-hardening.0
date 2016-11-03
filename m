Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 3 Nov 2016 21:42:39 +0100
From: Jann Horn <jann@thejh.net>
Message-ID: <20161103204239.GN8196@pc.thejh.net>
References: <1478187038-19954-2-git-send-email-wluikil@gmail.com>
 <20161103182441.GA29904@laptop.thejh.net>
 <CAGXu5jJ9d+hiHdS_Ge6H+Jxz3py-RNAEx626M9L2doSZ608LDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tjOMJDssiV0CZSJH"
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ9d+hiHdS_Ge6H+Jxz3py-RNAEx626M9L2doSZ608LDQ@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [2/2] procfs/tasks: add a simple per-task
 procfs hidepid= field
To: Kees Cook <keescook@chromium.org>
Cc: Lafcadio Wluiki <wluikil@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--tjOMJDssiV0CZSJH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 03, 2016 at 02:34:16PM -0600, Kees Cook wrote:
> On Thu, Nov 3, 2016 at 12:24 PM, Jann Horn <jann@thejh.net> wrote:
> > On Thu, Nov 03, 2016 at 09:30:38AM -0600, Lafcadio Wluiki wrote:
> >> This adds a new per-task hidepid=3D flag that is honored by procfs when
> >> presenting /proc to the user, in addition to the existing hidepid=3D m=
ount
> >> option. So far, hidepid=3D was exclusively a per-pidns setting. Locking
> >> down a set of processes so that they cannot see other user's processes
> >> without affecting the rest of the system thus currently requires
> >> creation of a private PID namespace, with all the complexity it brings,
> >> including maintaining a stub init process as PID 1 and losing the
> >> ability to see processes of the same user on the rest of the system.
> > [...]
> >> diff --git a/kernel/sys.c b/kernel/sys.c
> >> index 89d5be4..c0a1d3e 100644
> >> --- a/kernel/sys.c
> >> +++ b/kernel/sys.c
> >> @@ -2270,6 +2270,16 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned lo=
ng, arg2, unsigned long, arg3,
> >>       case PR_GET_FP_MODE:
> >>               error =3D GET_FP_MODE(me);
> >>               break;
> >> +     case PR_SET_HIDEPID:
> >> +             if (arg2 < HIDEPID_OFF || arg2 > HIDEPID_INVISIBLE)
> >> +                     return -EINVAL;
> >> +             if (arg2 < me->hide_pid)
> >> +                     return -EPERM;
> >> +             me->hide_pid =3D arg2;
> >> +             break;
> >
> > Should we test for ns_capable(CAP_SYS_ADMIN)||no_new_privs here?
> > I think it wouldn't hurt, and I'd like to avoid adding new ways in which
> > the execution of setuid programs can be influenced. OTOH, people already
> > use hidepid now, and it's not an issue... I'm not sure. Opinions?
>=20
> Hrrm, I'm really on the fence. I don't feel like having things in
> /proc go invisible for a setuid would be bad, but I wouldn't be
> surprised to eat my words. :) On the other hand, I can't think of a
> place where this requirement would create a problem.
>=20
> e.g. init launching a web server as root could set nnp and this, and
> it would still be able to switch down to www-data, etc. If someone has
> www-data in their /etc/sudoers file, I already fear for their sanity.
> ;)

(and init launching a web server as root could also set hidepid without
setting nnp if it really wants to)

--tjOMJDssiV0CZSJH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYG6E/AAoJED4KNFJOeCOoJpgP/jPkc1Ol53lyN6wqq30bKaZw
/tn7QysAK+Fr5NpHrk41jPZ0XTXlHbKFzvnRfOX65qp1EEZLM+mcrj318tBt7hdr
R+OjlYMMx2SQnfp6Nz6BSh9fbEt5n391zEvxDqft4MDmWFfQUwPADbKZ4e9IU3Aj
TwFHe1Gelj1bggOWKJmO6lYED0ws1BDURNeu0Sw3FF8dzO/wG12VoMNkMoeIqfRw
p6MjyFttwwGUDUISLLijuR8uErwAc0cFWSHBZZkHzy30r5UQmmn9OrJV3QCQ6Q9w
JwrJMM1okfNNyxHAqg+BDu6SUFYQDddolAdi6Ha4sfIU7F8+fwZy/gQLoDCellF2
hyBvsoSQwlE913h3/y/SuYklw7koyl3bSg4ABNAWl4uMgY3mW2OWJ6TDLJErx5PL
HaKm7ysjXb0lEk73O6dfO8xEzzTxbjdBDPFdgunNN4y4mYOqTtIjgIy6OGzeZ5p1
I1/nV/bHaGwmF9ahJSjGWIr7/Ejy1DB1/n0eelTETU+ltVtXqijPhou0E2wIsppT
4UP5qWA99brTo0nOYQIVZgI7k7ph2DhYR/d9P9/pZ2QtsRrWsfM8smQTSZUKyivv
12apwb9hITlbuXvpvPRRo47q3uoJI6FyG+uTcdfilokjesXMew6kMTRy4IyuOwaG
LElHlDC7SsW4UMVhggwn
=ooIc
-----END PGP SIGNATURE-----

--tjOMJDssiV0CZSJH--
