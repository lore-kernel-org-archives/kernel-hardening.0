Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 31 Jul 2016 23:23:18 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20160731212318.GA31482@pc.thejh.net>
References: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
 <1469777680-3687-2-git-send-email-elena.reshetova@intel.com>
 <20160729181213.GD11621@pc.thejh.net>
 <2236FBA76BA1254E88B949DDB74E612B41B7029C@IRSMSX102.ger.corp.intel.com>
 <20160731120255.GB14676@pc.thejh.net>
 <2236FBA76BA1254E88B949DDB74E612B41B70337@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41B70337@IRSMSX102.ger.corp.intel.com>
Subject: Re: [kernel-hardening] [RFC] [PATCH 1/5] path_fchdir and
 path_fhandle LSM hooks
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "keescook@chromium.org" <keescook@chromium.org>, "spender@grsecurity.net" <spender@grsecurity.net>, "jmorris@namei.org" <jmorris@namei.org>, "Schaufler, Casey" <casey.schaufler@intel.com>, "Leibowitz, Michael" <michael.leibowitz@intel.com>, "Roberts, William C" <william.c.roberts@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 31, 2016 at 06:28:08PM +0000, Reshetova, Elena wrote:
> On Sun, Jul 31, 2016 at 10:55:04AM +0000, Reshetova, Elena wrote:
[...]
> >Alternatively, you could forbid double-chroots and use the LSM hooks for
> file descriptor passing via unix domain sockets and binder to check incom=
ing
> file descriptors.
>=20
> This would not prevent guessing the file descriptor unfortunately.

That doesn't make sense to me. Can you elaborate on that, please?

How would you "guess" a file descriptor? Are you talking about file
descriptors opened before chroot() that have been leaked accidentally?
In that case, you could just do on chroot() what SELinux does on a domain
transition and replace all dangerous open file descriptors with /dev/null.

Or are you concerned about shared file descriptor tables (which really
shouldn't happen accidentally, at least when you keep in mind that for
this to be an issue, the fs_struct would have to not be shared)?

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXnmxGAAoJED4KNFJOeCOoPFAP/0zRC/Nl0VyALflqBXyYPkg9
GGma7FASncduXB3kDjJ9wlkqnY7217jesvBue1uKFskVc1YN5FDR7sUytqWGRLZx
ABL/pS39Wts+U/cpq5V2a111ia3nhnDAdpuAXppB9/MFKkddO5Uk8LGJamtXTSGu
f2f9EGuLMEgwTMSO9kDfDwepKF5Jf8A2RAALWaVVIsmk5ka6PRzBdfzjZXBgxB5E
UbxiqWrwONSK6Ek0h24tKY9OLfYJ5yS6eGN4sPjusNx07Md3vhzx2EOCMJ6WhRDn
u5ukI4BMhCUplLMTqhPPggUaEhOI5ZRAI8Af/PXXJy6PeDqm6YGwpc3shFXV9JPR
RCRrfBxdIRWRkWG1xp37CukCMaMe1qKi+8/yGYDgnWvEucRMyrtc+1COv0releNz
y7GDed0qtt8yYmY+HExPRKPlrMUkCb2SPvy6m4EjxJ8jxApw3X5Xa/P3BRrsGN99
O5aZW3ISHbqW0qvqL6t+iDSy+o/gD9BsXtQNF8d1e+swqW9J+UZDmdcuP3on2m2u
2YQODPykyb7IIcdR6T/tSb84UWFcy+3jLMAtCSbKw0KTnmJyToSoRsooRpke9vpO
8wA/ivYpKIdoh8m3fWw1isDSm/NxbyW71KYwBb39zmq3GYvS4oQH67B7yMygELHR
2zjcslMiC9ARfDdSVwQZ
=0x/p
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
