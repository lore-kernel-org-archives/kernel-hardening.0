MIME-Version: 1.0
In-Reply-To: <2400574.rYAxqaUNNq@positron.chronox.de>
References: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
 <2400574.rYAxqaUNNq@positron.chronox.de>
From: Jeffrey Walton <noloader@gmail.com>
Date: Sun, 4 Jun 2017 01:54:12 -0400
Message-ID: <CAH8yC8moNo7DN06dAt+hUhARuNBkUNAhuS4sxUYCcjWew76hsg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: get_random_bytes returns bad randomness before seeding is complete
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 4, 2017 at 1:48 AM, Stephan M=C3=BCller <smueller@chronox.de> w=
rote:
> Am Freitag, 2. Juni 2017, 16:59:56 CEST schrieb Jason A. Donenfeld:
>
>> Alternatively, I'm open to other solutions people might come up with.
>
> How about stirring in some data from the Jitter RNG that we have in the k=
ernel
> already and that is used for the DRBG in case get_random_bytes has
> insufficient entropy? Yes, two kernel developers said that this RNG is
> useless, where in fact a lot of hardware and even crypto folks say that t=
his
> approach has merits.

Almost anything has to be better than (1) silent failures, and (2)
draining the little entropy available when the generators are starting
and trying to become operational.

The [negative] use case for (2) is systemd. See, for example,
https://github.com/systemd/systemd/issues/4167.

Jeff
