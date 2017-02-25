Message-ID: <1488011791.1141.1.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Sat, 25 Feb 2017 03:36:31 -0500
In-Reply-To: <20170225003232.GA123380@beast>
References: <20170225003232.GA123380@beast>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-N5L6yYW8Ym77WTG1Mzcg"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] [RFC] mm: enable sanitizing via CONFIG
To: Kees Cook <keescook@chromium.org>, Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--=-N5L6yYW8Ym77WTG1Mzcg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-02-24 at 16:32 -0800, Kees Cook wrote:
> This enables page and slab poisoning by default under
> CONFIG_MEMORY_SANITIZE.
> Based on work by Kaiwan N Billimoria.
>=20
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> This is more what I had in mind. This is based on the latest patch,
> but
> handles slab and slub. I tested slub with lkdtm's READ_AFTER_FREE and
> READ_BUDDY_AFTER_FREE which both trip the poisoning tests.
>=20
> While doing this, I noticed one major issue with slub/slab poisoning:
> it performs poisoning both on alloc and free, which is a rather large
> performance hit, so the next step is likely to find a way to split the
> poisoning into alloc and free halves so that CONFIG_MEMORY_SANITIZE
> poisoning will only happen on the free.

It also still fills with a value that will make pointers point to
userspace, right? Rather than a better value or zeroing (and relying on
mmap_min_addr, although that's pretty small and easy to index past).

It also verifies the poisoning is still there, which can be wanted but
is more expensive. It increases allocations by the size of a pointer
which PaX doesn't do anymore, and there's the whole losing the fast path
which seems to mean losing CPU caching too since it's just hitting the
global stuff. The debug infrastructure could also be a risk, that would
not be present in normal builds up to this point.

I would like to be able to use upstream features but I think case it
seems that anyone not willing to unnecessarily lose performance and
security properties will need to keep carrying ~15 line of code out of
tree or using the PaX features.

Is there a path to doing it properly from here? I really don't see the
point in it being upstreaming if it's such a hack. It's frustrating...

Not to mention that real allocator hardening like not having inline free
lists and being able to reliably detect double-free would be nice. Maybe
there should just be a security-oriented slab allocator, freeing it from
needing to avoid stepping on other people's toes. It just needs to pick
a performance target and then the design can shift away from the current
one within that target over time. *shrug*
--=-N5L6yYW8Ym77WTG1Mzcg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQJKBAABCAA0FiEEZe7+AiEI4rcIy/z3+ecS5Zr18ioFAlixQg8WHGRhbmllbG1p
Y2F5QGdtYWlsLmNvbQAKCRD55xLlmvXyKvptD/9p+fWsbuF+DG5QaBtNDPwPJ0YO
HTSdAdHhrtF6+N95Psk0KauWXUzxg/Vl0ZilOWsFvh1icjzPZ9qdsOOejCoJtU6P
CyoJMswfJeu6L20F+u7/zcqvvgzXBqAidUDozfcdcwabMfADUFbNyVcqHW9izrnZ
62sHqKrqXWpcleGIpUYaeAQS7U1yBaRM8sYUrewOkJOGbs5jEjKuTbRymIGzHcwP
mcWW/BYkqeRtAuPXcOuvcFcAdANVlu4vLjMuEDEq/SFLJfKXyfe8kf+n4VVUHSI6
6vucNFlP654qo6DnG+R7yMLWSU7eVK3PUhdLZ9Tn04FcMbehwQxy6bSNYwgOEj+h
gAWuYzM+gp1io81s5efnmlwD/h8zd6gX8UkNDIGA5Do06hpR79iPDG2sj4pM+SYO
uvGVgZuFEH5VF5L2UQlKBcT0J8gqSUhNHfo64XBXN8fP0fylX70jZF0ApnQbZEio
14eJmrSxN/zg6uvUqUe1CR0/GWKpNZpHNsuK1/glxDGKK0rNBjghJwb1iVBWxSfc
JX6hYkESTmWZq7f0UEj5O0VLN9cEyo/uZPc0aeERPgeddnz+87cJzC+8budJIvL+
E7jwZ5P+s6yyXUcfUz1e08zzUohvSR3fHv1XUwFZpstczZxCkXoKae+hlvF0Hxm0
HFRizGi1QM0L8e57zQ==
=pyAh
-----END PGP SIGNATURE-----

--=-N5L6yYW8Ym77WTG1Mzcg--
