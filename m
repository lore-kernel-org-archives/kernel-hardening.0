Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 5 Jun 2011 22:30:27 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110605183027.GA5859@albatros>
References: <20110605182830.GB5789@albatros>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <20110605182830.GB5789@albatros>
Subject: [kernel-hardening] Re: [RFC v1] debugfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 05, 2011 at 22:28 +0400, Vasiliy Kulikov wrote:
> While implementing it, I realized that it is probably more usefull to
> implement it as 2 sysctls and CONFIG_DEBUGFS_* options - a lot of
> debugfs files are created at the boot time, so it makes sense to change
> these setting at the compile time and not to bother with chmod'ing
> already created files.

The same for configfs.  However, I'm hesitating to mention sysfs as it
will be divided into well defined per-namespace parts in the future and
global sysfs umask would be confusing.

--=20
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJN68tDAAoJEBoUx9gkVaZcKfoQAJkCCujIPnBQZDoosrcfNm+l
YuOw/yY1Nvdph+Q29UWuQaPVLC6KEFAPtYBbavC7gwOzWpaNUQG/YB4amPAZOPy5
1tDyDu9bLl8KeXhSBY5SHhHAe+/Zkd+GSDObv3Lecx6fBviJGRpkeD3cvC+altKp
aBn2RpejE75mrE1jiR0wnJGgTTpjomuFwLdi5MXqGf8t/alBCIhgczNHnHAo5/Ji
7kOcK7yZzUgakK+FWrcJvLzH8ix9cLEWWfjTY9pJsoxLguTw/QSPDcKeUz9wSlHG
zJobgagrDItoifTe2s9HA+Ym8TqtCApDxv6beBMDyAnqcrmAnU9qjUSmDubnmVbc
dCh7R7rNaHNHBql2Ygj8v9uJbaLsY9oSgEFCwa3aWRVpfdQzZk8OUGiW824UEHxr
6QQ4PNGKaFxEWgkRRTr0X0fVgXvG8N+SXPbkBg+8l+t2+o8eMW5D7gI6hpvaYLoE
0fDs7bBvFnutAxxbxSn6wI8ImLYxiMUnrx848uX7hN0BG6WuIYi3xH0hTxCsmO6e
qnTy/UYm89o3ljY9W+bIJSs9/wGXw8S+doLukQXqNxF0aEu5+3A5k8vsTJ7ud2vV
V4NjhecLdCwKND8l/+GiepifXgD2r4mtG9LNdhfdDFDwC7MmdhHz14DtGS2E0GTk
rJjmmjfuHsk1Ut6zNyn1
=wr12
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
