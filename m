Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 29 Jul 2016 20:02:11 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20160729180211.GB11621@pc.thejh.net>
References: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
 <1469777680-3687-4-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
Content-Disposition: inline
In-Reply-To: <1469777680-3687-4-git-send-email-elena.reshetova@intel.com>
Subject: Re: [kernel-hardening] [RFC] [PATCH 3/5] sb_unsharefs LSM hook
To: kernel-hardening@lists.openwall.com
Cc: linux-security-module@vger.kernel.org, keescook@chromium.org, spender@grsecurity.net, jmorris@namei.org, casey.schaufler@intel.com, michael.leibowitz@intel.com, william.c.roberts@intel.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 29, 2016 at 10:34:38AM +0300, Elena Reshetova wrote:
> This adds a new security_sb_unsharefs() LSM hook.
> It can be used by LSMs concerned about unsharefs()
> system call.

There is no unsharefs() system call. Your patch touches a kernel function
unshare_fs_struct() that is called by the NFS server kernel thread and
some lustre stuff, which also looks like kernel threads.

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXm5ojAAoJED4KNFJOeCOo3h0QAJJkKWHhgRo4Mps+CQa73E36
qZLSQRiPCEk+7X1muF/eB4KIeX0WZ34AMuCyUapMxb8pMeRIoz3orslEVvEl2o0u
EMDScf2vxwnRrqLEkTeb4QrVRb0nQ0U4tFw6Jjdz/i9MvPplPBkX3/dRfJQdnMgF
5at2Eeg5EpxcbmJykuvAKNaWTk95dnw7dM4n5KL2gWbgAj3lpClBokM0MgYzwN64
NOJ2Q7CZVoqfuRj57/kvdsdzmCKCMo5eh3QvF2bPgtSKJe8bBGcxg5c29LSnsHfP
w8WTt5HYBmSaP9d2w7TIVigWF4zndSFN4i/ga9LeS1WEL/B0aEx+Y7iChwm+0j3j
LhQIc83iuH7ttnvK/4TmRfFziRpLwV7cQ0qJXzLQ9MUI2M4q3kKvdp1ZGqGfgwHr
9+bIiQukB+kIpAWdwAxvcs4pcebgt10RBCJyHiFb+hjYu45HsQWRPbHEkrHYS1fm
o7iURcBU0RUoU5XHKllH9z1e8Uin5Dp7bDUaL0Rgu32SxKzv6DSQJZe0rRNCh0mU
gDOhr8uVM996tzy7KIl21ZJYCWMuZxXx6j99nwu+rE7pVaEGORkNfM/B+6mafAF0
o2ooGt2qeeKnWtWwX2qcJQTLiNY0m3WGlI7EWKX6h+kmeM5zgaNxMAZIqyWTqcBg
Wn4rRYcKykKA5MSwiOaO
=0m4f
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
