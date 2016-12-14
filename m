Reply-To: kernel-hardening@lists.openwall.com
From: David Laight <David.Laight@ACULAB.COM>
Date: Wed, 14 Dec 2016 09:51:16 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6DB023F4DA@AcuExch.aculab.com>
References: <20161214001656.19388-1-Jason@zx2c4.com>
 <20161214001656.19388-3-Jason@zx2c4.com>
In-Reply-To: <20161214001656.19388-3-Jason@zx2c4.com>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH 3/3] secure_seq: use fast&secure siphash instead of
 slow&insecure md5
To: "'Jason A. Donenfeld'" <Jason@zx2c4.com>, Netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Linus Torvalds <torvalds@linux-foundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, George Spelvin <linux@horizon.com>, Scott Bauer <sbauer@eng.utah.edu>, Andi
 Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Greg KH <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Jason A. Donenfeld
> Sent: 14 December 2016 00:17
> This gives a clear speed and security improvement. Rather than manually
> filling MD5 buffers, we simply create a layout by a simple anonymous
> struct, for which gcc generates rather efficient code.
...
> +	const struct {
> +		struct in6_addr saddr;
> +		struct in6_addr daddr;
> +		__be16 sport;
> +		__be16 dport;
> +	} __packed combined =3D {
> +		.saddr =3D *(struct in6_addr *)saddr,
> +		.daddr =3D *(struct in6_addr *)daddr,
> +		.sport =3D sport,
> +		.dport =3D dport
> +	};

You need to look at the effect of marking this (and the other)
structures 'packed' on architectures like sparc64.

	David
