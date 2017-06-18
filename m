MIME-Version: 1.0
In-Reply-To: <2812305.zGuAXT15AM@positron.chronox.de>
References: <20170606174804.31124-1-Jason@zx2c4.com> <1606799.lNpamfCTbW@tauon.chronox.de>
 <20170618154625.5qu3eduqjtgk5bal@thunk.org> <2812305.zGuAXT15AM@positron.chronox.de>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sun, 18 Jun 2017 21:12:55 +0200
Message-ID: <CAHmME9pqUR+mSeG8SNgCKvxnayPUhVn0K+Mw4EsKuTcMOhNASw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Re: [PATCH v4 13/13] random: warn when kernel
 uses unseeded randomness
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Cc: Theodore Ts'o <tytso@mit.edu>, kernel-hardening@lists.openwall.com, Michael Ellerman <mpe@ellerman.id.au>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 18, 2017 at 7:55 PM, Stephan M=C3=BCller <smueller@chronox.de> =
wrote:
> But you bring up an interesting point: if it is true you say that it is h=
ard
> for people to use differnent types of APIs regarding entropy and random
> numbers right (which I would concur with), and considering that you imply=
 that
> get_random_bytes, get_random_u32 and get_random_u64 have the same securit=
y
> strength, why do we have these three APIs to begin with? The get_random_b=
ytes
> API would then be more than enough.

Because there are efficiences we can benefit from for getting integer
sized outputs.

Use get_random_{u32,u64} when you want a secure random number.
Use get_random_bytes when you want a longer secure random bytestring.
