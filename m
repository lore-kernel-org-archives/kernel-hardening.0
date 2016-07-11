Reply-To: kernel-hardening@lists.openwall.com
From: Valdis.Kletnieks@vt.edu
In-Reply-To: <CAHgaXdLPLCiggTrKGcFZzmGiBUmdmNGAt0_nO9BS5aGoP=bVmw@mail.gmail.com>
References: <CAHgaXdKW4=y-PviWudtMAThuB=GEW-73RejSHRMYNVzLyxP+iA@mail.gmail.com> <CAGXu5jLA+ri_RwWSOoZwAtv6a6pXL_EzUx6BZ0Mmc-n0+We9vg@mail.gmail.com>
 <CAHgaXdLPLCiggTrKGcFZzmGiBUmdmNGAt0_nO9BS5aGoP=bVmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1468263917_4649P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 11 Jul 2016 15:05:17 -0400
Message-ID: <21496.1468263917@turing-police.cc.vt.edu>
Subject: Re: [kernel-hardening] Looking for something to WORK ON
To: Shubham Bansal <illusionist.neo@gmail.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

--==_Exmh_1468263917_4649P
Content-Type: text/plain; charset=us-ascii

On Sun, 10 Jul 2016 21:34:29 +0530, Shubham Bansal said:

> Hi Kees,
>
> Sorry for the late reply. I am having some problems with arranging a lot of
> mails from the list.

If you're not sure where to start, try picking up all the patches we've got
so far, applying them to a reasonably recent kernel, and seeing what breaks.

As far as I know, I'm the only crash test dummy at the moment, so having
somebody else testing with a kernel config different than what I have
on my laptop would be valuable.  So far I've identified that ptrace()
and some (but not all) variants of setsockopt() have issues with Kees's
usercopy patches.

Kees:  Am I the only guy who's trying this on a SLAB rather than SLUB box?

--==_Exmh_1468263917_4649P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBV4Pt7QdmEQWDXROgAQIJcg/9H1Gy0hH+zBEVJNyK4Ke9Jssn9xc1eeji
w+tpOei4b6YH/2EaHC4bVL3rB9BsqcBUXZnmhWJd6UXkr1aCX9sYVq2rj+q40g/W
rGqzn2W8F5MBb+J/MdAUOdASlEnikk+wjntNvYf4qSVlXkFSzBVcK8KRboP8VJAo
60M7G6ol2DAnZUA1wXpLwoWVcFcJSxH01NOKXZtKC3Zl9VGAe3IYDjsm6TRWYAj1
RiK2E6oGT5V/rymt9WIaLiI6BaYJu8YhQZjvv3hR13fl1tNgm9kfXtJN/BjSjTVZ
MvRZ5MzGa8CmcpMxvHvM9TJnBCAjZKf5Y9r5ai2PuTWGtl8jqitBfFSzArOREgnz
h5Q6L2fNi4Blm5Z/r+6JYtJLLh3x4MY4cMggAa69l1/GAxfrL9yWbJI9wUUCrrNo
ZJTnjjCzV9kK/3WYcYLpqzCz0kHzP9phLbS++9HfsWwaG814q1ILo3L9nuctXyR+
N+KcOH20DTgE88PHJqBLcP7pl+qRXu2J4BjgJ9hZON1iZkrVVbS4NegaqQG/BurE
3WtFex0iLECEOUQ7BxzEHHTC9EzeqZ7G1GyDr0tejlyrKlqloJtHZ7mFraxZ6BXJ
+NZ/aS1ekoipXN9aonT4Au35mBb/ziqjyH/ZhFFEV6cjU81zqtHKupCnvHcTs6Gl
aKu8r7+UT84=
=ef0S
-----END PGP SIGNATURE-----

--==_Exmh_1468263917_4649P--
