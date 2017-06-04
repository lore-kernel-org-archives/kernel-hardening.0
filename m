From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Date: Sun, 04 Jun 2017 07:48:26 +0200
Message-ID: <2400574.rYAxqaUNNq@positron.chronox.de>
In-Reply-To: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
References: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: [kernel-hardening] Re: get_random_bytes returns bad randomness before seeding is complete
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Am Freitag, 2. Juni 2017, 16:59:56 CEST schrieb Jason A. Donenfeld:

Hi Jason,

> 
> Alternatively, I'm open to other solutions people might come up with.

How about stirring in some data from the Jitter RNG that we have in the kernel 
already and that is used for the DRBG in case get_random_bytes has 
insufficient entropy? Yes, two kernel developers said that this RNG is 
useless, where in fact a lot of hardware and even crypto folks say that this 
approach has merits.

In any case, it cannot destroy the (not present) entropy at boot time anyway. 
Thus, take some 32, 48 or 64 bytes from it right at the start of the kernel, 
and we should be better (from the view point of quite some folks) or not worse 
off (view point of two developers here).

As this RNG does not depend on any in-kernel facility, it is always available 
at any time.

PS: I could revive a patch adding this to random.c that I sent long ago if 
desired.

Ciao
Stephan
