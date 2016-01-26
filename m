Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1453775278.3737.5.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Mon, 25 Jan 2016 21:27:58 -0500
In-Reply-To: <CAGXu5jLwwCw9wZA8QYNVrZ2+kHJn7G3sXQZchvqFMYj3bN=DpQ@mail.gmail.com>
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
	 <8737tp0zhr.fsf@x220.int.ebiederm.org>
	 <CALCETrWYRvqhyCwx5RX6L3TEYCfW0j6ThFUc+ASL7BpxgO5dEQ@mail.gmail.com>
	 <CAGXu5j+mx+6BOKb42yfyKnL7VTCUBNC0Nk9aCOd0D5tSD6DbCg@mail.gmail.com>
	 <CALCETrXNZhJdjbxYH8x3wr3EyQVJzp2fhNyXwzgmuiKzoKO24A@mail.gmail.com>
	 <CAGXu5jJ6fQ5E17jKoC3kFZ0RgbcNLuzW6zdunaXV+jiQPSo+Lg@mail.gmail.com>
	 <87bn89sbc2.fsf@x220.int.ebiederm.org>
	 <CAGXu5jLwwCw9wZA8QYNVrZ2+kHJn7G3sXQZchvqFMYj3bN=DpQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-dnvxDKaGZZtyovhfs/Zh"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH 0/2] sysctl: allow CLONE_NEWUSER
 to be disabled
To: kernel-hardening@lists.openwall.com, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, Robert =?UTF-8?Q?=C5=9Awi=C4=99cki?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-dnvxDKaGZZtyovhfs/Zh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> This feature is already implemented by two distros, and likely wanted
> by others. We cannot ignore that.

Date point: Arch Linux won't be enabling CONFIG_USERNS until there's a
way to disable unprivileged user namespaces. The kernel maintainers are
unwilling to carry long-term out-of-tree patches.

https://github.com/sandstorm-io/sandstorm/blob/d270755b1b55e5be6c96df2cce7c=
914f35f0d2a2/install.sh#L464-L474
--=-dnvxDKaGZZtyovhfs/Zh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWptmuAAoJEPnnEuWa9fIqoS0P/ij9ahLYkTB2cXTeezz3skvi
1PasB8yOMs2wbacF8KrG9JEVd1qnp0OUsfjgY91xpnQcmFMR2MlTXG+As748zheP
+TCPkd1rZpB7MX3UqC5u5ta8pvrH40Z5frQDpiCgh84c945V6rl7gL2FssV03mN1
wl1S8lC/RwmVAJ3+FUkbaCKT0mZM1bVyh50+t6ApUcfaW/EZUJng6Lun+/lv3Q3h
PlaC0u9+M4/m+Da8YmB2L9pUhWiqU9XF/kpAAkAFq/cjacQKnWydYcHrbxjIr6iE
QLn5rFbloz7WeE6BXpOvQenGzSS0W/qPdryEcURWSptsq/ufZ1pgonuQ2lvz9Bcg
hLGwPQWkCd5gg0e/e7t2IOC/68+yg6LMDvSdZNHSDk5SGiD1ZQDY4E+MAL7AlefA
ocXl0tImhRqVXLATiyr51R0PeyJyQ8dNp8QkhOqOCeKB/DnCO8bxV3LLKcrlYyrA
j1r8NFbOVtAf5K6fUve3KU2EtfUBWWECTaVx6n7jOcRTlTJTSbWPgHOJmd5JLtKO
ZWT4kIoXnxDwkjaC/hN31GcFjSHq6xmsEVLTnZA5XxVR4BnyIoCkyQSfmP1L+6Jq
YO4+vWXAyvMlePlOlPmmLVzedF5zisC7EElZMAdiC/sVoVTSZ6TzC1+VgljYnpEc
c4NRkNgydF+nx+vQouBE
=Oze5
-----END PGP SIGNATURE-----

--=-dnvxDKaGZZtyovhfs/Zh--
