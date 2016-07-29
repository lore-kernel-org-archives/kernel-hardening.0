Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 29 Jul 2016 22:53:54 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20160729205354.GA13090@pc.thejh.net>
References: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
 <1469777680-3687-6-git-send-email-elena.reshetova@intel.com>
 <20160729185317.GF11621@pc.thejh.net>
 <f2fcb76e-f843-cd78-0552-6709b34827e3@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <f2fcb76e-f843-cd78-0552-6709b34827e3@schaufler-ca.com>
Subject: Re: [kernel-hardening] [RFC] [PATCH 5/5] Hardchroot LSM
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, keescook@chromium.org, spender@grsecurity.net, jmorris@namei.org, casey.schaufler@intel.com, michael.leibowitz@intel.com, william.c.roberts@intel.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 29, 2016 at 12:20:56PM -0700, Casey Schaufler wrote:
> On 7/29/2016 11:53 AM, Jann Horn wrote:
> > On Fri, Jul 29, 2016 at 10:34:40AM +0300, Elena Reshetova wrote:
> >> This adds a new Hardchroot LSM that is intended to make
> >> classical chroot more secure. It is based on
> >> GRKERNSEC_CHROOT feature with necessary changes needed to
> >> make it fit inside LSM. Currently not all GRKERNSEC_CHROOT
> >> features are supported, but support is planned to be added
> >> on granular basis.
> >>
> >> The credits for feature itself should go to the original
> >> authors of GRKERNSEC_CHROOT. Since there is no way to share
> >> security metadata between LSMs yet, the Hardchroot info task
> >> management is done based on Yama LSM. When support is added,
> >> the required info can be stored as part of task struct and it
> >> can drastically simplify the internal management.
> > I really don't like this series.
> >
> > First off: On Linux, as far as I know, chroots were never meant
> > to be a security feature,
>=20
> This is a common misconception. When chroot was introduced circa 1979
> (the exact date is subject to interpretation and your skill with sccs)
> security, especially in the form of protecting the system from
> accidental corruption, was an important concern.

I'm explicitly talking about the situation *on Linux*. I don't
know much about old UNIX variants, and I don't think that they
are very relevant here - IMO, what matters here are what chroot()
was designed for *on Linux* and how it was treated during the
development of the kernel, because that is what influences how
easy it is going to be to add that stuff to Linux today.

And when you look at Linux 0.10, you'll see that already back
then, sys_chroot() just updated current->root; sending signals
to other processes, setting the system time and so on just did
UID checks.


> > and chroot "jails" break in a number
> > of different ways.
>=20
> All of which were introduced after the fact, and most of which
> have been introduced in spite of the objections of the security
> community. Even sockets, which are the biggest single breakage
> (followed closely by the process namespace and SVIPC) came along
> well after chroot and really should have taken the "root" into
> account.

Namespaces on Linux actually take chroots into account - you can't
create a new namespace if you're unprivileged and inside a chroot,
see commit 3151527ee0. I'm not sure whether that was added before
or after unprivileged user namespaces were enabled.


> > A lot of effort went into making bind mounts
> > actually secure with reasonable performance, and I doubt that
> > something like this can provide anything close to that, at least
> > not without gigantic runtime overhead. Instead of making people
> > believe that it's now okay to use chroot for security, I would
> > very much prefer to keep the "never use this for security
> > purposes" warning in the chroot() manpage and encourage people
> > to use namespaces with bind mounts instead.
>=20
> There is merit to the argument that namespaces are better than
> chroot jails. Nonetheless, we're all aware of just how much
> legacy code we're going to have to deal with for the next
> forever, and some of that can benefit from this work.

Eh. For that, you could also make a shim that turns chroot into
namespace creation automatically - either as a libc feature or
as a personality flag in the kernel. The biggest issue with this
would probably be dealing with multithreaded processes that call
chroot() while being multithreaded - in that case, a personality
flag would have the advantage of allowing the kernel to have a
variant of unshare() that synchronizes new user and mount
namespaces across all threads.

That approach would probably be less of a maintenance and
performance burden and have less security issues popping up over
time compared to attempting to have two orthogonal filesystem
sandboxing implementations.

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXm8JiAAoJED4KNFJOeCOoUnAP/0Cyjn0PcgT2tR4PEloKA2od
ujvSKxmEK5S0H4pBffC1rteT+dqrdaZeOOViwSE+HCNia4wGAexcgc7hNKlXSTvF
xRd7Iad5qZUjM0utEhgGWLLPKO37P3bLhUFFurt1NArvjqt5i8TiJ+8yCGyovA+u
7ETDqZSuprUrivshvfSgu4AvqJ3n+mQPyDy6XYFrLkceMlMV0c5+6HMV9XgcJpGC
X19sdNCMw8EOKjQ0u9KjUfJGoItR93aXYp5uQ9yrLZi4KY5oy6Rrlzopw1iPvT4/
Zz9BdnTioixW3E/qd7pTdlpuw57ZH+6+nw0veck5iYvxBX5qG2qrdpsWYpCt+f+d
HktlQeT/nBC8ScMASZgom0Xzs7uc2rL5P6GaVOD5gOTjrUw2Iua+3NCCmwxNqCR+
qQwgmCL6zjw0oxEU7s9IaYs5ZxmDadLGjYV3zpt3/C9mfAH4MnQIXbxTM+xgpGFK
VI31j6x11YP7p02hWYcpyNojjUBS3wc/bRHdAlYK5xCXnPNdlk+zg07zSou6gvop
EY0ZbJuXGp8cyZmWWLo7b/873TJkzGjqAmvMDffTnckkwhVkjuyfzihXXbERD1ZA
2n66IKD79+c0b3UoqXDdIWKTVjN7zEwgvMs0YuOzZTNrpyVINrGztylElfsEA99h
Gl3niBT/Fl0UKsqbm1lj
=PEs0
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
