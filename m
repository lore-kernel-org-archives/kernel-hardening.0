From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAMuHMdWd3ttH7Zdpo=bodkOBw2xiyeX_R9MhPf=Bcf0-QLhOiQ@mail.gmail.com>
References: <CAMuHMdWd3ttH7Zdpo=bodkOBw2xiyeX_R9MhPf=Bcf0-QLhOiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7443.1506978724.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Oct 2017 22:12:04 +0100
Message-ID: <7444.1506978724@warthog.procyon.org.uk>
Subject: [kernel-hardening] Re: Modular BIG_KEYS (was: Re: [PATCH v4] security/keys: rewrite all of big_key crypto)
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: dhowells@redhat.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, ebiggers3@gmail.com, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ilhan Gurel <ilhan.gurel@gmail.com>, security@kernel.org, stable <stable@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> Now this has hit mainline, the "BIG_KEYS" Kconfig symbol appeared on my
> radar. Is there any reason this cannot be tristate?

It was tristate, but it got converted to bool:

	commit 2eaf6b5dcafda2b8c22930eff7f48a364fce1741
	KEYS: Make BIG_KEYS boolean

and then:

	commit a1f2bdf338f15dbad10ee6362891ebf79244858b
	security/keys: make big_key.c explicitly non-modular

> So to save kernel size, I wan't to save N, but for a distro kernel that =
might
> have Kerberos users, you currently need to say Y, while M would be nicer=
.

If you want to do that, you'll need to implement demand-loading of key typ=
e
modules.

Note that you'd end up using a minimum of a whole page as a module rather =
than
~2K if built in (I know, that's a compromise you have to decide on).

David
