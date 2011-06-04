Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 4 Jun 2011 09:47:58 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110604054758.GA4063@albatros>
References: <20110603191153.GB514@openwall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <20110603191153.GB514@openwall.com>
Subject: [kernel-hardening] Re: procfs mount options
To: kernel-hardening@lists.openwall.com
Cc: Eugene Teo <eugeneteo@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Solar,

On Fri, Jun 03, 2011 at 23:11 +0400, Solar Designer wrote:
> I welcome suggestions on how to achieve the desired functionality for
> procfs in a non-confusing and generic way.  It should support the
> following reasonable configuration:
>=20
> /proc/PID directories restricted to group proc (except for owners and
> root, indeed).  However, /proc/cpuinfo and the like unrestricted.
> Here's what this looks like on Linux 2.4.x-ow:
>=20
> dr-xr-x---  3 root    proc         0 Jun  3 22:59 1
> ...
> dr-xr-x---  3 syslogd proc         0 Jun  3 22:59 205
> dr-xr-x---  3 klogd   proc         0 Jun  3 22:59 211
> ...
> -r--r--r--  1 root    proc         0 Jun  3 23:00 cpuinfo
> ...
> -r--------  1 root    proc 536743936 Jun  3 23:00 kcore
> -r--------  1 root    proc         0 May  5 20:36 kmsg
> ...
> dr-xr-x---  5 root    proc         0 Jun  3 23:00 net
> ...
> -r--r--r--  1 root    proc         0 Jun  3 23:00 uptime
> -r--r--r--  1 root    proc         0 Jun  3 23:00 version
>=20
> Perhaps gid=3Dproc,umask=3D007 should result in the above for /proc/PID, =
but
> how do we justify it not affecting /proc/cpuinfo, uptime, version (and
> many others)?  How do we justify it nevertheless affecting /proc/net (or
> should another option do that)?

I think it should be done with separate mount options for /proc/self/net
(/proc/net is a symlink to /proc/self/net since net namespaces
introduction) and for /proc/PID.  All other files should be e.g.
chmod'ed go=3D and then some white list should be chmod'ed to the relaxed
perms.

> Indeed, we could set some of these perms with chmod post-mount, but as
> discussed this has drawbacks.

Where its drawbacks were discussed?  I cannot find anything on
owl-dev.  Do you mean some possible diffirences between procfs files
among different kernel versions?  If so, white list instead of black
list should partly solve it.

>  So ideally our preferred configuration
> (which will be the default on Owl) should be achievable with mount
> options alone.

At least for sysfs it is unreachable if we go in the current direction -
umask doesn't change perms of already created files, and additional
"chmod -R" is needed anyway.

Thanks,

--=20
Vasiliy

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJN6ccHAAoJEBoUx9gkVaZcP5sQAKqZ1Ebb3886peomnAuB35NT
c9xYHlcD0KfJ79V46HCb6XzkBUC31DX4zKk5/9jCsyr5q09dAnKgtfGR8CeFlWxk
Mzk/J1pHAmmhXZfb+LG76IsoWEPPbbgIF0GCWp+DOOBJ8E/cBsQ2/Ux0PZMCJ4Qu
TfTOrrkLaVadJGun5s193H7IYkYKwKatYALzDsCa0hvoEJ3wdjzNhSWABg9vTBBJ
/SudxKzEqNvw4yGBz2ErZ66m3TTW/ZF6PfVvZjqOAnrpX8lbRKC+z8v9nWqtjv4Q
NJW76540OnSJrOWiz8+E7Fyyobij1Gwy6jSFMTa3IdbMJcVi7WVpWomOIkVWLuQ8
/yc2Rf3IeekjFbAPhkZ4zGdoJyCnK/jtPHIStV0q7f5IBYAEPjZbwbwDNgxMiemX
84zVoSlwrNxrSne6oGys+XLSiZzsDFf/DMGtDEj/c39ZU+X1/jmAVuGWLudYIvaq
Gom9DRCZ9Oe1xX7Q/xnZPwfM6F4kpzQFTuOdkJ7VhPIoTmeje/biP5jUA+7Xl4rm
v4yhVM5k2lZdMuk8lhcrYlo1mgnxO1zx/6qSBInpb3vmIYORkv46BCpvw8wtjtWN
QKAnfvUjV1F3Q42ekwyKnnASu9TdjOOr0Ag5EN/Yqruzn5K2K7USOP7FwBSQ+nw8
rDQNLiTyr15t5COBIuka
=LLzZ
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
