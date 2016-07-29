Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 29 Jul 2016 20:11:23 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20160729181123.GC11621@pc.thejh.net>
References: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
 <1469777680-3687-5-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5QAgd0e35j3NYeGe"
Content-Disposition: inline
In-Reply-To: <1469777680-3687-5-git-send-email-elena.reshetova@intel.com>
Subject: Re: [kernel-hardening] [RFC] [PATCH 4/5] invoke path_chroot() LSM
 hook on mntns_install()
To: kernel-hardening@lists.openwall.com
Cc: linux-security-module@vger.kernel.org, keescook@chromium.org, spender@grsecurity.net, jmorris@namei.org, casey.schaufler@intel.com, michael.leibowitz@intel.com, william.c.roberts@intel.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--5QAgd0e35j3NYeGe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 29, 2016 at 10:34:39AM +0300, Elena Reshetova wrote:
> This adds an additional invocation of the
> security_path_chroot LSM hook inside mntns_install().
> Currently only capabilities are checked at this point,
> while process root actually changes.

Are you aware that unprivileged user namespace creation doesn't work in
a chrooted process? See the invocation of current_chrooted() in
create_user_ns(). This means that for this new LSM hook to make any
sense, a namespace admin has to attempt to sandbox himself with chroot().

If the current namespace is the init namespace, the process has
CAP_SYS_ADMIN in the init namespace, meaning that filesystem sandboxing
is probably useless.

If the current namespace is not the init namespace, the process probably
used namespaces to sandbox itself, in which case it wouldn't be using
chroot in the first place, or it is running in a container with admin
privileges. In the latter case, this mitigation miiight make a
difference, I'm not sure exactly how powerful the APIs for namespace
admins are - but a mitigation that only makes a difference inside
containers would be weird anyway.

So: What is your specific usecase here?

--5QAgd0e35j3NYeGe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXm5xLAAoJED4KNFJOeCOoP0YP/0ysxtg9DQfDOeNCxb4sUuIh
K2LfFSaqpNMfg7dLDlOnPwQz0Xv4roqOlOb6hxOouIMc1V8pC5jEiF5ipAVr62rl
GcWdnuco9HMweoShkiLCcleFx+lc00t/Ds2b0ub1d1ImLN/lh4YYFtel659399lv
37+Qx2l8gNX/wxevDAV6fVuw1S8QR0OtDqeImMuPh7Be0kR6oRs0qpeg+YZi8hYs
eBdu5S3xs3IONysxiGpfJ2pMXQrbsMF47blli0qxquK95jKXGskO6r2gpSmLlktW
f3jTfuTtmV4BPqgiPNstX+0aEgAJHKmPKsWafb8H/OoYZQ+1sw3hQO+H3EbCooAV
9cSVriysRa+KS0GcLDIiTBHpaUHeV+1a/xeT16Rp8zkMW6+uBXCjNVDN++7Mbsk1
gXb/SvorxfcsllUkz8iohRy2uD7GRAYgY+xdwPxCGwOQcqxFDQRCnxKMV17BXN5b
Lpt3/s/aCNpOnlJ9kSwC7AlM268hRG/Ab1dyKaP+MmPT9G8O+oPie1LmIloeTlcm
Gx2ewFGV0yS00jKvHTenvnG7rGR92d28sAac/yGz+jQBImTfm7D2JoZRyZnVpY5F
5B8gVWU5xDjE40WsUSEsiSqfB+2p0ksefReN0ZHO7pFSA7aqXtc03rLQaV8O3JJd
/roWFk8ycNT0eTgY4Wj0
=S3cY
-----END PGP SIGNATURE-----

--5QAgd0e35j3NYeGe--
