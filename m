MIME-Version: 1.0
In-Reply-To: <1593673.B5xods8kYN@tauon.chronox.de>
References: <CAHmME9rjrz2Pn39ay3myApBeBtQAPNt0C+NvmFoV28NeT4_zLg@mail.gmail.com>
 <20170917115217.15805-1-Jason@zx2c4.com> <1593673.B5xods8kYN@tauon.chronox.de>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 20 Sep 2017 12:52:21 +0200
Message-ID: <CAHmME9pvZ-Q8qoUGjQjXX_DYNVv43C7MJRDzKZAAotM5UZircA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v6] security/keys: rewrite all of big_key crypto
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Eric Biggers <ebiggers3@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, security@kernel.org, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Sep 20, 2017 at 7:30 AM, Stephan Mueller <smueller@chronox.de> wrote:
> The use of GCM with the implementtion here is just as challenging. The
> implementation uses a NULL IV. GCM is a very brittle cipher where the
> construction of the IV is of special importance. SP800-38D section 8.2.1 and
> 8.2.2 outlines the generation methods of the IV. A collision of keys/IVs is
> fatal. I understand that keys are generated anew each time which makes that
> issue less critical here. However, as user space may see the ciphertext, GCM
> should simply not be used.

This sounds incorrect to me.  Choosing a fresh, random, one-time-use
256-bit key and rolling with a zero nonce is a totally legitimate way
of using GCM. There's no possible reuse of the key stream this way.
However, on the off chance that you know what you're talking about,
could you outline the cryptographic attack you have in mind, or if
that's too difficult, simply link to the relevant paper on eprint?
