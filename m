Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 13 Jan 2016 00:51:17 +0100
From: Jann Horn <jann@thejh.net>
Message-ID: <20160112235117.GA2537@pc.thejh.net>
References: <1452626745-31708-1-git-send-email-jann@thejh.net>
 <87mvsa5q40.fsf@gamma.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <87mvsa5q40.fsf@gamma.ozlabs.ibm.com>
Subject: [kernel-hardening] Re: [RFC] kernel/panic: place an upper limit on number of oopses
To: Daniel Axtens <dja@axtens.net>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Baoquan He <bhe@redhat.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
List-ID: <kernel-hardening.lists.openwall.com>


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 13, 2016 at 10:34:39AM +1100, Daniel Axtens wrote:
> Jann Horn <jann@thejh.net> writes:
> > +	 * limit is reached, just panic.
> > +	 * The constant used as limit should be low enough to
> > +	 * mitigate this kind of exploitation attempt, but high
> > +	 * enough to avoid unnecessary panics.
> > +	 */
> > +	if (atomic_inc_return(&oops_counter) >= 0x100000 &&
> > +			panic_on_oops == 0) {
> Do you need to check panic_on_oops? If it was 1 you'd already have
> paniced, right?
[...]
> > +		pr_emerg("oopsed too often, setting panic_on_oops=1\n");
> > +		panic_on_oops = 1;
> Would it be easier to just panic here, rather than wait for another oops?

Ah, yes. So the code would be just this, apart from the definition of
oops_counter:

        if (atomic_inc_return(&oops_counter) >= 0x100000)
                panic("oopsed too often\n");

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWlZF1AAoJED4KNFJOeCOoZl8P/iargQH0fLzDBjyNzIoQh8Hz
o8x+KiSwCmcG69ozDUbKidAYJ3c/JLe2E8VVyEjiTkFsUoVETK6TyCAGzKYPAb7j
cqPBvrWVgLZ5OQZCbQqpbiMjdEiGRxG82qXBSwhs+vBZnOGS4U8xzM86E3aUdGRQ
f/RoZemtb4K9nc+J60ryvYOi97EMgWIqx/2B8hGgCK/4j4E6AdaBpaXS+DrT5nvz
vrs9kDvcbvTf+v5XcvcR1b9Dt76/cAsFofyWOAK0At4clOhZk1lcZ7ha/Yp62ae8
gUVNj+gViuff3OJnNXrqU39jJA2N5iI7UPSiMU5XExC7uIKj4dWE8cNUjeYRNqiv
kxbLhE1mIpSLbGtNAB85iqTgUlTP7krAAfkfAgdreyLGmoClFfV50Q84E6FrErzi
WGL2j8l0lfaRW5CEhK74yrZK4DEvInKGRoSeQ3FP4VLM8pelJcO0eXvxx3ei/WQ7
Y8Dr/LO7wPre9GU4oZCi8dtJm+8g/B1Ov4rAQ57jxUHT7DM8NMcO3k88gluiAsjI
0emnDL3AdfmGiA9JxebmKyJjxwYLd5uFPYAO5dGCHRn3DXAgTUYk8YvvB/GDo+Fn
DOL9VB79ii3lasriJtTO1OxlvLcGKS6L8nwWflP6WD/J/05S5v6yeAntNdeDGC3O
J6cJxK7kwqz6Wg2UKR3Y
=uWMv
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
