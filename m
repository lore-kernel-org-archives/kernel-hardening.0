Date: Tue, 20 Jun 2017 09:07:21 +0200
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20170620070721.GA30728@amd>
References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
 <1497286620-15027-5-git-send-email-s.mesoraca16@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <1497286620-15027-5-git-send-email-s.mesoraca16@gmail.com>
Subject: [kernel-hardening] Re: [PATCH 04/11] S.A.R.A. USB Filtering
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>
List-ID: <kernel-hardening.lists.openwall.com>


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2017-06-12 18:56:53, Salvatore Mesoraca wrote:
> Introduction of S.A.R.A. USB Filtering.
> It uses the "usb_device_auth" LSM hook to provide a mechanism to decide
> which USB devices should be authorized to connect to the system and
> which shouldn't.
> The main goal is to narrow the attack surface for custom USB devices
> designed to exploit vulnerabilities found in some USB device drivers.
> Via configuration it's possible to allow or to deny authorization, based
> on one or more of: Vendor ID, Product ID, bus name and port number. There
> is also support for "trailing wildcards".

Hmm. Given that USB device provides vendor id/product id, this does
not really stop anyone, right?

AFAICT you can still get USB stick with vid/pid of logitech keyboard,
and kernel will recognize it as a usb stick.

So you should not really filter on vid/pid, but on device
types (sha sum of USB descriptor?).

> Depending on the configuration, it can work both as a white list or as a
> black list.

Blacklisting vid/pid is completely useless. Whitelisting vid/pid is
nearly so. Attacker able to plug USB devices sees devices already
attached, so he can guess right vid/pids quite easily.

								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllIyakACgkQMOfwapXb+vL77ACggGqDtQ0u6emWwkM4vRVmqRNx
pcIAoLvy8RyhQ4r4TN3QYLLb8v2UTito
=lPqt
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
