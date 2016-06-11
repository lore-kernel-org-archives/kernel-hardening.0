Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1465607314.16365.181.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Fri, 10 Jun 2016 21:08:34 -0400
In-Reply-To: <CAGXu5j+d1nWs=HjMudPx9P=rbE5dSs3on3Gex=UeBcBNB7pEgA@mail.gmail.com>
References: <1465420302-23754-1-git-send-email-keescook@chromium.org>
	 <1465420302-23754-3-git-send-email-keescook@chromium.org>
	 <CAGXu5j+d1nWs=HjMudPx9P=rbE5dSs3on3Gex=UeBcBNB7pEgA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-LWxRB4ttxKr+0cLsNpXJ"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH v2 2/4] usercopy: avoid direct
 copying to userspace
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-LWxRB4ttxKr+0cLsNpXJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-06-10 at 14:09 -0700, Kees Cook wrote:
> On Wed, Jun 8, 2016 at 2:11 PM, Kees Cook <keescook@chromium.org>
> wrote:
> >=20
> > Some non-whitelisted heap memory has small areas that need to be
> > copied
> > to userspace. For these cases, explicitly copy the needed contents
> > out
> > to stack first before sending to userspace. This lets their
> > respective
> > caches remain un-whitelisted (i.e. no SLAB_USERCOPY), since the
> > bulk of
> > their contents should not be exposed to userspace.
> I've spent some time thinking about these kinds of
> non-whitelisted-slab-workaround changes, and I would like to see if
> we
> can design a better solution. So, to that end, here's what I see:
>=20
> - HARDENED_USERCOPY verifies object addresses and sizes
> - whitelisted caches (via HARDENED_USERCOPY_WHITELIST's
> SLAB_USERCOPY)
> are intentionally rare
> - Some code uses small parts of non-whitelisted cache memory for
> userspace work (I think the auxv ("mm_struct") and signal frames
> ("task_struct") are good examples of this: neither cache should be
> entirely exposed to userspace, yet tiny pieces are sent to
> userspace.)
> - non-whitelist-workarounds are open-coded
> - non-whitelist-workarounds require a double-copy
> - non-whitelist-workarounds have explicit size maximums (e.g.
> AT_VECTOR_SIZE, sizeof(sigset_t))
> - non-whitelist-workarounds _bypass_ HARDENED_USERCOPY object address
> checking
>=20
> So, while the workarounds do have a max-size sanity-check, they
> actually lack the object address checking that would normally happen
> with the usercopy checks. I think to solve the open-coding and
> double-copy problems without compromising on the whitelisting or the
> explicit size checking, we could also gain back the address checking
> if we created something like:
>=20
> copy_to_user_n(user, kernel, dynamic-size, const-max-size);
>=20
> If "const-max-size" isn't detected as a builtin_constant it could
> fail
> to build. When run, it would a) verify dynamic-size wasn't larger
> that
> const-max-size, and b) perform the regular usercopy checks (without
> the SLAB_USERCOPY check).
>=20
> So, for the auxv example, instead of the new stack variable, the
> memcpy, etc, it could just be a one-line change replacing the
> existing
> copy_to_user() call:
>=20
> copy_to_user_n(sp, elf_info, ei_index * sizeof(elf_addr_t),
> AT_VECTOR_SIZE);
>=20
> (Bike-shedding: copy_to_user_bounded(), ..._limited(),
> ..._whitelist_hole(), ?)
>=20
> What do people think?

I like your idea a lot.

For some kinds of objects, we could go one further.

Eg. for objects we know to be in the slab, we could use
copy_to_user_slab, and fail the copy if the pointer is
not a slab object.

--=20
All Rights Reversed.


--=-LWxRB4ttxKr+0cLsNpXJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXW2STAAoJEM553pKExN6DDoYH/R2TN7uzF92YdMmPYxs2Gczm
q8xb7+EsYvIXT1uah8eBZ4GNYGxSU8gQyDNqg2rwy8pVIak9kL1d3A1i8fGzMJOV
APqc5Z3xN4YHH8cgUMcXKnjEopOAHPsrxfAouU3xcf/rTEfS6E3WtnAa6obQIn1S
ArhZvcNWVPQeeFkwQOsz93ZWR/UI3rA+6LnVyG2tW+uVve4V9PLBNni6jxhnOPe6
4eelIVOkrJv8ckP6gNsQETfQFxKL2GOTwt8LE6CdLJWt9WCRdkKQbp7sE18co7Rr
w7XMWce1Lnu2ETJfu+jD+bxZoXj20kqlWh/xm2iZDpxu6+5oHKs1yjnn7Lzh1xI=
=b0ir
-----END PGP SIGNATURE-----

--=-LWxRB4ttxKr+0cLsNpXJ--
