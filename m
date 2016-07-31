Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 31 Jul 2016 13:29:27 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20160731112927.GA14676@pc.thejh.net>
References: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
 <1469777680-3687-5-git-send-email-elena.reshetova@intel.com>
 <20160729181123.GC11621@pc.thejh.net>
 <2236FBA76BA1254E88B949DDB74E612B41B70283@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41B70283@IRSMSX102.ger.corp.intel.com>
Subject: Re: [kernel-hardening] [RFC] [PATCH 4/5] invoke path_chroot() LSM
 hook on mntns_install()
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "keescook@chromium.org" <keescook@chromium.org>, "spender@grsecurity.net" <spender@grsecurity.net>, "jmorris@namei.org" <jmorris@namei.org>, "Schaufler, Casey" <casey.schaufler@intel.com>, "Leibowitz, Michael" <michael.leibowitz@intel.com>, "Roberts, William C" <william.c.roberts@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 31, 2016 at 10:39:04AM +0000, Reshetova, Elena wrote:
> On Fri, Jul 29, 2016 at 10:34:39AM +0300, Elena Reshetova wrote:
> > This adds an additional invocation of the security_path_chroot LSM=20
> > hook inside mntns_install().
> > Currently only capabilities are checked at this point, while process=20
> > root actually changes.
>=20
> >Are you aware that unprivileged user namespace creation doesn't work in a
> chrooted process? See the invocation of current_chrooted() in
> create_user_ns(). This means that for this new LSM hook to make any sense=
, a
> namespace admin has to attempt >to sandbox himself with chroot().
>=20
> I am not sure I understand you fully here. It is possible to create new
> mount namespace without creating new user namespace, and when this happen=
s,
> if I understand the code right, there is no check like current_chrooted()=
 or
> smth like this.=20
> So, how does it relate to user namespace?=20

You can only create a new mount namespace if you're privileged relative to
your current namespace. See the second and third invocation of ns_capable()=
 in
mntns_install(). To get those privileges, you have to either be privileged
already or unshare the user namespace to get new namespaced privileges.
An unprivileged, chrooted process doesn't have existing privileges and can't
unshare the user namespace to get new ones, so it can't unshare other
namespaces (like the mount namespace) anymore.


> >If the current namespace is the init namespace, the process has
> CAP_SYS_ADMIN in the init namespace, meaning that filesystem sandboxing is
> probably useless.
> >If the current namespace is not the init namespace, the process probably
> used namespaces to sandbox itself, in which case it wouldn't be using chr=
oot
> in the first place,=20
> Why? It is possible that we might be running in the namespace some daemon
> which just uses chroot by default (legacy or whatever). I think you even
> proposed that in another email.=20

True.

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXneEXAAoJED4KNFJOeCOosrgQALsuOqeL4ukYbSOTF20P2Tb8
Ekf+VJ8Wk11HG24qvLLxXQxA3XclSiGEUWIxGX7a06MUBsEHyfosJkRXUKVQRQRV
DPTg0w+zyVZtTCXNMs00BQICZc6jKqAy8OhrNA6YhCf0+vBgRN1WkkISZ9sHcg8y
Ogrew/XqtV/c+KKL9kuFwxHH1ccIDHBfK2sXwAMxa0Bj2aMu5iMbPcfTn0GaxMgR
JArPvG94+ls5I1fGpu8fs1XhOW6PWWWq71sLiIallvlLEryoOHNEaBAWuirRT9PR
Jd54scfXk2M6S5ho545gXNubW5ZHqSPInbtF77fkaJJiFa2QSygFGkLrEiIEkUBy
D79wdJ6eoQJZxiwGY67tzSGcbkYiOYoZH6VNyW9+4KgzBojCEh0Zz46ZftxpIHKq
1aOS5zG8LVk+BoFmpGye4gMPqQhXKq4Ya3fySh+QF7mTV2u74R7FsInV5RsQS+J2
kRi/Zdfl8ld8hDa8DIetY4OnUBhLFcXa2n8UJyDhhW/CfmpVFkOnGYwAbYUXJr0h
sQA0BAwYqcCUlfxHT/6135ffstNlcaRvRVFl7rMTgMxMVlVdR0aqjwphkPr20PiK
7Jeefa4EfwF+/IKBwB6oyyAImB/lXjnBWil9nh5F7Yvmc0q9j/E97sM75VguqJ6y
UhA0c+tN4W5egffP9v7G
=w2QP
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
