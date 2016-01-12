Reply-To: kernel-hardening@lists.openwall.com
From: Daniel Axtens <dja@axtens.net>
In-Reply-To: <1452626745-31708-1-git-send-email-jann@thejh.net>
References: <1452626745-31708-1-git-send-email-jann@thejh.net>
Date: Wed, 13 Jan 2016 10:34:39 +1100
Message-ID: <87mvsa5q40.fsf@gamma.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Subject: [kernel-hardening] Re: [RFC] kernel/panic: place an upper limit on number of oopses
To: Jann Horn <jann@thejh.net>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Baoquan He <bhe@redhat.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
List-ID: <kernel-hardening.lists.openwall.com>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Jann Horn <jann@thejh.net> writes:

> To prevent an attacker from turning a mostly harmless oops into an
> exploitable issue using a refcounter wraparound caused by repeated
> oopsing, limit the number of oopses.
>
> I have not experimentally verified whether the attack I describe
> in the comment works, but I don't see why it wouldn't.
> (f_count increments through fget() use atomic_long_inc_not_zero(),
> but get_file() just does a normal increment and is e.g.
> used by dup_fd().)
>
> This approach is strictly inferior to PAX_REFCOUNT, but as long
> as that's not upstreamed and turned on by default, it might make
> sense to at least use this patch.
>
> Opinions?

I'm torn between making the limit configurable and not adding to the
massive proliferation of config options.

Other comments below.
>
> Signed-off-by: Jann Horn <jann@thejh.net>
> ---
>  kernel/panic.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 4b150bc..27a480d 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -422,9 +422,37 @@ void print_oops_end_marker(void)
>   */
>  void oops_exit(void)
>  {
> +	static atomic_t oops_counter =3D ATOMIC_INIT(0);
> +
>  	do_oops_enter_exit();
>  	print_oops_end_marker();
>  	kmsg_dump(KMSG_DUMP_OOPS);
> +
> +	/*
> +	 * Every time the system oopses, if the oops happens while a
> +	 * reference to an object was held (e.g. in a VFS function),
> +	 * the reference leaks. If the oops doesn't also leak memory,
> +	 * repeated oopsing can cause the reference counter to wrap
> +	 * around - in particular, on 32bit systems, f_count in
> +	 * struct file is only 32 bits long and can realistically
> +	 * wrap around.
> +	 * This means that an oops, even if it's just caused by an
> +	 * unexploitable-looking NULL pointer dereference or so,
> +	 * could maybe be turned into a use-after-free through a
> +	 * counter overincrement, and a use-after-free might be
> +	 * exploitable.
> +	 * To reduce the probability that this happens, place an
> +	 * upper bound on how often the kernel may oops - after this
> +	 * limit is reached, just panic.
> +	 * The constant used as limit should be low enough to
> +	 * mitigate this kind of exploitation attempt, but high
> +	 * enough to avoid unnecessary panics.
> +	 */
> +	if (atomic_inc_return(&oops_counter) >=3D 0x100000 &&
> +			panic_on_oops =3D=3D 0) {
Do you need to check panic_on_oops? If it was 1 you'd already have
paniced, right?
> +		pr_emerg("oopsed too often, setting panic_on_oops=3D1\n");
> +		panic_on_oops =3D 1;
Would it be easier to just panic here, rather than wait for another oops?
> +	}
>  }
>=20=20
>  #ifdef WANT_WARN_ON_SLOWPATH

Regards,
Daniel
> --=20
> 2.1.4

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJWlY2PAAoJEPC3R3P2I92FRRcP/RXA5+Bf7Kk/Z01jjbOP4/7c
hAI87Yz0WnKwhgKB/6RebFAK1P8KWkw8UaDde32bRfaPNsoGk20BDTUjj+qjyv4Z
bKDMHMNqc7TKSnuecmsJBDq++YtMvY1OTzBC7YyW1//QMBX+WK+yk7A48R9RPs8M
Uoa6FvXpUQ53yTy7PkSL1y52ZcvLv9yglTVev7+m6EkFek+IH7HIiC5suKs3RxRw
NGgbk67yMZkQwhUr6E/ilOaB639aMTFHw2nXQMjl8N7N2IS6B76UrsypmCUzSsE8
UtV5DqKJJusiY3FmkDvuW2PXArYTTiYmu2X1TFWi2QMeqdrxwOrU37DGNUYWFTIo
RqerOUaVQ2xtZAAbFI8WSs05qJT1Ua7sAt+SUOqNKfjyXLgDjakxKC2twGJctgW+
x3CDmZ2V76J7rd9i78qpCxo6F3ktKu3hUDkiiyhXhH1e3PX3CsxPlG6hEhiqVYBY
IHrhEZmgAVDnTPBav/doRpAeXDYmre7uKQCWnW667pIyCkFyJRnqXh+ariSps26D
Z8MYHjjMHRQQTjXi5LSkyZOKd0jQLl7DduK1ht1JD1O2mfmEVChex6MnxGuZ2Xly
0pW8yTcLRa1VQ3qqTvaDzy6Qg0h4CMyG5UhiX60N1oyBMD721ElVKQTBuEysjo4+
qD9oXMmZivT1766UPhGB
=OMDg
-----END PGP SIGNATURE-----
--=-=-=--
