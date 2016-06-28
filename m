Reply-To: kernel-hardening@lists.openwall.com
From: Valdis.Kletnieks@vt.edu
In-Reply-To: <1467150555.24287.77.camel@perches.com>
References: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
 <1467150555.24287.77.camel@perches.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1467151621_1978P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Jun 2016 18:07:01 -0400
Message-ID: <47053.1467151621@turing-police.cc.vt.edu>
Subject: Re: [kernel-hardening] Re: [PATCH v1 0/2] Introduce the initify gcc plugin
To: kernel-hardening@lists.openwall.com
Cc: Emese Revfy <re.emese@gmail.com>, Matt Davis <mattdavis9@gmail.com>, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de
List-ID: <kernel-hardening.lists.openwall.com>

--==_Exmh_1467151621_1978P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Jun 2016 14:49:15 -0700, Joe Perches said:

> Another potentially useful plugin, especially for embedded systems,
> would be to compress any string literal marked with
>
> 	=A0__attribute__((format(printf, string-index,)))
>
> and decompress the compressed format on the stack in lib/vsprintf.c
> vsnprintf just before use.

Are there enough such strings in the kernel to make it worth the effort?
I'm assuming that the string literals in printk(=22some string here=22) a=
re
automatically so marked?

Is there a minimum length under which the compression overhead actually
makes it larger?  For instance, =22a=22 can't be compressed, because you =
need
to indicate there's 1 =22a=22 and 1 =5C0, while =22aaaaaa=22 can, because=
 you can
express it as '6*=22a=22 1 =5C0 in only 4 bytes not 7.  But exactly where=
 the
cutoff is, I have no idea (and is probably *very* text-dependent, as
=22aaaaaa=22 and =22abcdef=22 will compress differently....)


--==_Exmh_1467151621_1978P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBV3L1BQdmEQWDXROgAQLNlBAAsTsvJQJ1xiyxLML8nF9ev3TM+SAU/HmD
L8mKS4SCjtCKUXJt5onbWPhRy7MoPSz5kBJnLeGQCBkZgx5JCrMJEskiVmeun7n1
8pd56F2JlKo+lycdqxzM/7j/X11ryZKpbYcPCRADAch0N88bD/SLBs+rv6LDXXa9
viL8aLlLdV77aah351IiM5D5p//G5tBp9ytYauwnsJeWYneb5QgCHPwYc88+kKZn
XgUTjKjjVBssWw9fdDQvLvhbngkKIl9Ns92zjSJXSiMVHEpLNKmrBQ8WfCwoeI4m
KeStyuOJ75shnf7U7fAfHBpKgLqaG+LPsY5G+2BHC15lnZ4sI+mtg3xJmUoAfpSh
i7px7TX3okk9NFOuVY6m5Fz/D96dg3d7FYmuQgQm+a9ljKnQbKqH4wihQiaK8eGK
+vhKS4DIisHuUSfUwoCKX4Nlm4QBFI3lfjW5YIll21MQdI/lQFkDA7BSjKZORlRZ
N76ZBW8i3usaGK3lPZS8o8uJ/a2KF+v9G+Oz4vL5KLwH1OknYKx3zj3KSIlyPSjo
x2kVPhko4jtH8xqauhxTUi72juCPOvWQkdvoycvJnjhdKin2/TnbAcppKc/dot02
xqf1l+qGyGYjnB+nJSAUfHwn2y9UvyEETm3bqf8pTtaBd5YBmEK8GjXgLUCRmwjn
xGdCvy/5taw=
=SKUT
-----END PGP SIGNATURE-----

--==_Exmh_1467151621_1978P--
