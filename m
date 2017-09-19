Date: Tue, 19 Sep 2017 09:39:59 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170919133959.5fgtioyonlsdyjf5@thunk.org>
References: <20170916130034.17706-1-Jason@zx2c4.com>
 <2681038.03lnYPhpsa@tauon.chronox.de>
 <CAHmME9p6uq0ELtgxB94bc4bUppa7UogWSEgj_9o8p2xXQfrz5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9p6uq0ELtgxB94bc4bUppa7UogWSEgj_9o8p2xXQfrz5A@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v4] security/keys: rewrite all of big_key crypto
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Stephan Mueller <smueller@chronox.de>, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Eric Biggers <ebiggers3@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ilhan Gurel <ilhan.gurel@gmail.com>, security@kernel.org, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 18, 2017 at 01:24:18PM +0200, Jason A. Donenfeld wrote:
> Good luck with getting approval... While Ted and I have our
> differences like any two kernel developers, I really tend agree with
> him in his attitude about this FIPS silliness. It's unlikely you're
> going to be able to shovel this stuff into random.c, and I think doing
> so will undermine your entire LRNG effort.

Let me add one more reason why FIPS compliance for the kernel is just
***stupid***.  The way FIPS compliance works, you have to pay hundreds
of thousands of dollars to a FIPS certification lab to certify a
specific binary, complete with the exact build environment (compiler,
binutils, etc.) used to build that kernel binary.

The moment you need to make a change --- say, to fix a critical
zero-day security bug --- this breaks the FIPS certification, and you
then have to go back to the FIPS certification lab, and pay another
hundreds of thousands of dollars for another certification.  This will
take weeks/months, and while you are waiting for the results to come
back from the FIPS certification lab, the hackers will be busy
extracting another 143 million credit histories, or another 4.1
million SF-86 Security Clearance Forms from the systems involved.  :-)

You might say that FIPS certification != FIPS compliance.  Sure, but
the only silly people who care about FIPS compliance also need FIPS
certification, for the US Goverment signoff.

Realistically, people who need FIPS certification will need to use
FIPS certified crypto in hardware.  In which case the FIPS certified
RNG, as well as the FIPS certified crypto, will all be in a single
certified lump of hardware, which doesn't have to change when we need
to fix various kernel bugs.

Cheers,

						- Ted
