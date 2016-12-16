Reply-To: kernel-hardening@lists.openwall.com
From: NeilBrown <neilb@suse.com>
Date: Fri, 16 Dec 2016 12:02:33 +1100
In-Reply-To: <20161214185000.GA3930@kroah.com>
References: <20161214185000.GA3930@kroah.com>
Message-ID: <87k2b0wus6.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Subject: [kernel-hardening] Re: [RFC 0/4] make call_usermodehelper a bit more "safe"
To: Greg KH <gregkh@linuxfoundation.org>, kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

--=-=-=
Content-Type: text/plain

On Thu, Dec 15 2016, Greg KH wrote:

> Hi all,
>
> Here's a proof-of-concept patch series that tries to work to address the
> issue of call_usermodehelper being abused to have the kernel call any
> userspace binary with full root permissions.
>
> The issue is that if you end up getting write access to kernel memory,
> if you change the string '/sbin/hotplug' to point to
> '/home/hacked/my_binary', then the next uevent that the system makes
> will call this binary instead of the "trusted" one.

You seem to be targeting a situation where the kernel memory can be
easily changed, but filesystem content cannot (if it could - the
attacker would simply replace /sbin/hotplug).

If that is a credible threat scenario, it seems to me that the simplest
mitigation is to have call_usermodehelper always call a single
compiled-in path - e.g. /sbin/usermode-helper - and rely on that
program to validate argv[0] and call it if it is deemed safe.

i.e. get the policy out of the kernel.


Just a thought,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhTPSkACgkQOeye3VZi
gbkQEg/9FfxrNYAyDReFNooQqhedgnUD1WNYWHrfZT7kEL1cnTcTeD3+wFQMM+Aq
vPBBOz9+97INs76he9iX5TIo1eLkIm9+OsOerQAj6ifePS5m4T4SjlRU2wyZubUc
bLsyOkzEczGTJ+q4viwiRgZp5YR0KNhYJWBLQ/I4VqMIRlbww8XsKmSEbAtvP+i2
OZvAlVFC/Z3h7z8mKjffhAeEaEJGHeiZsD5mZ5c+f5+W+WmZ4AOT2N/hOx/xi51f
FQO9uGHdnq+GwNYNWRWyv0iaEhUwgDGI/GAMc9J67P3RpkmXD2bHvDvFHs6BDLdD
+RPoZ7mnVJrU70FLZKhqTKolxM7WWYG7r4q8kn0pjWA6QVQ8iWqby7wg1Gdf1BSF
tKWZB6zwwg1O8+d6V1QmCbewiZ5CVdggsKRmkodYGfR5gD1HgTueBTPpjn4wauCN
2QrzfdjMvOt8mE9mEKq+HLkTHealLL4kKg19eOmnimCLvvhF1j1O4ZNqX3lC/FAb
rEK0vIAd4Zlk29rXcBxwKeGz11vd0s7f0VsFFWjjY/rO2aTY0XnxRkDuwm6IrBzh
7qYs9VYgnYXmPpySiOGIp8F4y1NntC8AlbzXgRoy3kb93//c4LCdt5m1CB8XTbr4
G1EQjrfqMp7uunVmdG7+DYAebID3oGwHlHK+61PfNz5H4Aj3YD4=
=Maa2
-----END PGP SIGNATURE-----
--=-=-=--
