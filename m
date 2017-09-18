From: Stephan Mueller <smueller@chronox.de>
Date: Mon, 18 Sep 2017 11:12:23 +0200
Message-ID: <1802190.3ov6B1aDpW@tauon.chronox.de>
In-Reply-To: <20170918090455.GA18325@kroah.com>
References: <20170916130034.17706-1-Jason@zx2c4.com> <2681038.03lnYPhpsa@tauon.chronox.de> <20170918090455.GA18325@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: Re: [kernel-hardening] Re: [PATCH v4] security/keys: rewrite all of big_key crypto
To: kernel-hardening@lists.openwall.com
Cc: Greg KH <gregkh@linuxfoundation.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, ebiggers3@gmail.com, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ilhan Gurel <ilhan.gurel@gmail.com>, security@kernel.org, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Am Montag, 18. September 2017, 11:04:55 CEST schrieb Greg KH:

Hi Greg,

> On Mon, Sep 18, 2017 at 10:49:56AM +0200, Stephan Mueller wrote:
> > Am Samstag, 16. September 2017, 15:00:34 CEST schrieb Jason A. Donenfeld:
> > 
> > Hi Jason,
> > 
> > > This started out as just replacing the use of crypto/rng with
> > > get_random_bytes_wait,
> > 
> > This change is a challenge. The use of the kernel crypto API's DRNG has
> > been made to allow FIPS 140-2 compliance. Otherwise, the entire key
> > generation logic will not be using the right(TM) DRNG. Thus, I would not
> > suggest to replace that for a stable tree.
> 
> Why not?

An SP800-90A-compliant DRNG must be used in those circumstances.

> What is the issue here, there is only one "DRNG" in the kernel
> now (and probably for a long time...)

There are more DRNGs implemented in the kernel crypto API (see crypto/drbg.c 
or crypto/ansi-cprng.c).
> 
> > Note, I am currently working on a pluggable DRNG apporach for /dev/random
> > and /dev/urandom to be able to get rid of the use of the kernel crypto
> > API's DRNG API. It is ready and I will air that solution shortly. Yet, it
> > needs work to be integrated upstream (and approval from Ted Tso).
> 
> We don't postpone work for potential future patches that might or might
> not ever happen or get merged.  That's how NetBSD died...

Then I would recommend to leave it as is or hear complaints from other users.

Ciao
Stephan
