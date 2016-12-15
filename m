Reply-To: kernel-hardening@lists.openwall.com
From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 15 Dec 2016 10:14:33 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6DB02401A1@AcuExch.aculab.com>
References: <20161214035927.30004-1-Jason@zx2c4.com>
 <20161214184605.24006-1-Jason@zx2c4.com>
 <20161214184605.24006-3-Jason@zx2c4.com>
In-Reply-To: <20161214184605.24006-3-Jason@zx2c4.com>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH v3 3/3] random: use siphash24 instead of md5 for
 get_random_int/long
To: "'Jason A. Donenfeld'" <Jason@zx2c4.com>, Netdev <netdev@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, Ted Tso <tytso@mit.edu>
List-ID: <kernel-hardening.lists.openwall.com>

From: Behalf Of Jason A. Donenfeld
> Sent: 14 December 2016 18:46
...
> +	ret =3D *chaining =3D siphash24((u8 *)&combined, offsetof(typeof(combin=
ed), end),

If you make the first argument 'const void *' you won't need the cast
on every call.

I'd also suggest making the key u64[2].

	David
