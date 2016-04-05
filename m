Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 5 Apr 2016 22:00:29 +0100
From: James Hogan <james.hogan@imgtec.com>
Message-ID: <20160405210029.GG31316@jhogan-linux.le.imgtec.org>
References: <1459415142-3412-1-git-send-email-matt.redfearn@imgtec.com>
 <CAGXu5jKMLcRmMkowF=fUEQdtccTJLR9FEWT4g_zeyZMW4BWQOg@mail.gmail.com>
 <20160404233721.GB26295@linux-mips.org>
 <CAGXu5jJ7P95T0ZyAVZagQ0LZhSg28wxkQxR-tRFkhZsHekrN_Q@mail.gmail.com>
 <20160405090923.GF31316@jhogan-linux.le.imgtec.org>
 <CAGXu5jJ5B+MEg7SVgbmWju+y8XYnbunvfdR0ZD_tfz-u=iB03w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="7lMq7vMTJT4tNk0a"
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ5B+MEg7SVgbmWju+y8XYnbunvfdR0ZD_tfz-u=iB03w@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH v2 00/11] MIPS relocatable kernel &
 KASLR
To: Kees Cook <keescook@chromium.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linux MIPS Mailing List <linux-mips@linux-mips.org>, Matt Redfearn <matt.redfearn@imgtec.com>, Aaro
 Koskinen <aaro.koskinen@nokia.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexander Sverdlin <alexander.sverdlin@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Thomas
 Gleixner <tglx@linutronix.de>, David Daney <ddaney@caviumnetworks.com>, Jaedon Shin <jaedon.shin@gmail.com>, Jonas Gorski <jogo@openwrt.org>, Paul
 Burton <paul.burton@imgtec.com>
List-ID: <kernel-hardening.lists.openwall.com>

--7lMq7vMTJT4tNk0a
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 05, 2016 at 11:10:40AM -0700, Kees Cook wrote:
> On Tue, Apr 5, 2016 at 2:09 AM, James Hogan <james.hogan@imgtec.com> wrot=
e:
> > EVA (enhanced virtual addressing) is a feature present on recent MIPS
> > 32-bit i-class and p-class cores (and p6600 too which is 64-bit),
> > intended to make better use of 32-bit virtual address space. It can
> > actually overlap kernel and virtual address space, requiring special
> > instructions for accessing userland mappings, however each segment can't
> > have distinct TLB mappings for kernel and user mode (if kernel and user
> > view of segment differs, kernel would need to see it unmapped, i.e. a
> > window into physical memory). As such its generally better to keep the
> > lowest segment visible to both kernel and user, so that kernel NULL
> > dereferences can still be caught, which would negate the point of using
> > it for security. It is possible to make it work with watchpoints to
> > catch NULL dereferences in lowest 4KB, so kernel can't access any user
> > address space directly, but thats a bit of a hack really. Also since EVA
> > is aimed at making better use of 32-bit address space, it doesn't
> > address 64-bit.
>=20
> Ah, so it couldn't cover a 64-bit userspace range?

Correct.

<long version>
OTOH the segments that can be configured by EVA on MIPS64 (specifically
P6600 core) are:

0xffffffffe0000000..0xffffffffffffffff 512MB (normally kernel mapped)
0xffffffffc0000000..0xffffffffdfffffff 512MB (normally kernel mapped)
0xffffffffa0000000..0xffffffffbfffffff 512MB (normally kernel uncached)
0xffffffff80000000..0xffffffff9fffffff 512MB (normally kernel)
=2E..
0x8000000000000000..0xbfffffffffffffff 8 64-bit unmapped segments (kern)
=2E.. <- MIPS64 extends user address space here
0x0000000040000000..0x000000007fffffff 1GB (normally user)
0x0000000000000000..0x000000003fffffff 1GB (normally user)

In the middle there, MIPS64 extends userspace from 0x0000000080000000
towards 0x4000000000000000 (depending on number of virtual address bits
implemented), over which there is no segmentation control.
</long version>

Cheers
James

--7lMq7vMTJT4tNk0a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXBCdtAAoJEGwLaZPeOHZ6xEYP/1QCAip793JX3QvQlc34TXLt
sORXtYXDhQdSUc0JcWuarMMdqaXaJXismSp8Hf8uGDlFQDnPubCoeSNi1Cuz5gLR
aN5IjBYdlbUAKcxDzNnmuNmdrXwTiv90QIiqGzvE9TRY+j/06N4tVfAr6kRNew9l
gZMHbozKa/abz3dr2+QeoivDAo21tCIaDgCxDnNiaBkvQ4UfPZ7X9nyRO72FCakx
cyHIaEp+MkVe4r9hyFGUHEOkYTmQ4J2Dou80vjRNc9BpKgkE2sUMruR0+7iBtxXQ
zl5l6HWbNSKI2ZtsQLej8ud7+8KFlDPQmIIArnf0eeFunrY8RRUVS2lsgHLMYqeK
3iwU4sOK3y59yaWC7p7RGspGpW28uu29OOdbEFMH/Ra2Xq5ChF/tahVGKvYCbJpg
o6F5O/kNfA6ELKaQGkKURy9ukOWr3Jl8QkmeTbd1VMjsN54jiqSvZ5pTYXMb1m61
mKCy3IrNpHEZ+H74NWTAkoOyqN6npwCZO3i+I+wzDpcN4ug3ieCM40axm0BGV5WC
nX59qkmtySxAgRw0yKmgABNd4Gqt4a9dHVGxcjWgSTSjw1Q/5NLZDvnXVXQEIDpl
RyBZEFRMGxzR7HAvn6NFas6iETZIDMcvcqCjT7296hWwxpe7gAxMcQqMhgpzyjaF
mdB1GgOr+yuNWfqDmu+B
=d+Hw
-----END PGP SIGNATURE-----

--7lMq7vMTJT4tNk0a--
