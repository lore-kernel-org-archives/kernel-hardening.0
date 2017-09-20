From: Stephan Mueller <smueller@chronox.de>
Date: Wed, 20 Sep 2017 15:45:07 +0200
Message-ID: <2545404.XUVGGHhd0i@tauon.chronox.de>
In-Reply-To: <CAHmME9pvZ-Q8qoUGjQjXX_DYNVv43C7MJRDzKZAAotM5UZircA@mail.gmail.com>
References: <CAHmME9rjrz2Pn39ay3myApBeBtQAPNt0C+NvmFoV28NeT4_zLg@mail.gmail.com> <1593673.B5xods8kYN@tauon.chronox.de> <CAHmME9pvZ-Q8qoUGjQjXX_DYNVv43C7MJRDzKZAAotM5UZircA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: [kernel-hardening] Re: [PATCH v6] security/keys: rewrite all of big_key crypto
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Eric Biggers <ebiggers3@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, security@kernel.org, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Am Mittwoch, 20. September 2017, 12:52:21 CEST schrieb Jason A. Donenfeld:

Hi Jason,

> 
> This sounds incorrect to me.  Choosing a fresh, random, one-time-use
> 256-bit key and rolling with a zero nonce is a totally legitimate way
> of using GCM. There's no possible reuse of the key stream this way.
> However, on the off chance that you know what you're talking about,
> could you outline the cryptographic attack you have in mind, or if
> that's too difficult, simply link to the relevant paper on eprint?

http://csrc.nist.gov/groups/ST/toolkit/BCM/documents/Joux_comments.pdf

Ciao
Stephan
