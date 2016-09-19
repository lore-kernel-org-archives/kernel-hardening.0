Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 19 Sep 2016 15:55:29 +0100
From: James Hogan <james.hogan@imgtec.com>
Message-ID: <20160919145529.GK18931@jhogan-linux.le.imgtec.org>
References: <20160916203819.GA29767@roeck-us.net>
 <20160916212720.GA18931@jhogan-linux.le.imgtec.org>
 <20160916213718.GA32384@roeck-us.net>
 <20160916233249.GB18931@jhogan-linux.le.imgtec.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Qo8f1a4rgWw9S/zY"
Content-Disposition: inline
In-Reply-To: <20160916233249.GB18931@jhogan-linux.le.imgtec.org>
Subject: [kernel-hardening] Re: qemu:metag image runtime failure in -next due to 'kthread: allow
 to cancel kthread work'
To: Guenter Roeck <linux@roeck-us.net>
Cc: Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, linux-metag@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

--Qo8f1a4rgWw9S/zY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Sat, Sep 17, 2016 at 12:32:49AM +0100, James Hogan wrote:
> Here this version of QEMU puts the args at where it thinks the end of
> the loaded image is, which is based on the number of bytes copied from
> the ELF, i.e. the total MemSiz's, not taking into account the alignment
> gap in between, so it puts them at 0x40377348.

QEMU meta-v1.3.1 branch updated at:
https://github.com/img-meta/qemu.git

Hopefully that'll fix it for you Guenter.

Cheers
James

--Qo8f1a4rgWw9S/zY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJX3/xhAAoJEGwLaZPeOHZ6ScEP/RpXwc1eYFqnPfZLWq0h91Ha
SGTOWZCQsjPAaVx/svBykio3gcQP0oRXKoQUua026TMAo1PG3fqhtIvFFyWBmVZO
XxMoj3Okh65/gY/73RcY1bCpcY+wZThIRJVBjORn6TuBSzo1DvcrVou/bqvz28ky
cDePWyyyBIiuk4DZEl/F3KBujpW4cPh7jK5qFaz29QnyomYuhu5UsHX6txv2aPHT
NETNRMXIU5yhfPDY0Wee333H8jQmhHrWkq2kWzpV/TJ/xWHrDP7n9GAj0t4vrdll
lsZeQiUk/bPXqyCJwpWrqiD3oV7WclXSjb1ZOJFEoqsPEmNbD/OE546COYq2p0Hi
243RlRX3zisAwBnin1CczxNNvdF9ovuoTP2j5Sve7nWvMe8f2sUhTO+CV0bH8XEB
3iVfaMINI0lNEpwm1QEXpvT2WZqniJxUPUayIVMA5pS+m9WFVDg71wNJAtD/UUtH
iNHe4+SYRy9lCk0kAwK5P7Ny23WclVqG8YWmugKAVGwtdO1+1gbtbXiBrbwaR2WF
hDh20M1SE7ojEy5sgHLvmsyJL19wtCQsHAkIoGkqFw88/FSubM0uXj7tig+xPylX
ppwoncseKZ+5HmESPf1+upaNl6mzjzqNJhXShrsM98OM0pXODPwaEQaMC7gNqCjM
86/24YC1zl9A7oP3v0zR
=3GcV
-----END PGP SIGNATURE-----

--Qo8f1a4rgWw9S/zY--
