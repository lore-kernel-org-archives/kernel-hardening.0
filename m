From: Stephan Mueller <smueller@chronox.de>
Date: Mon, 18 Sep 2017 10:49:56 +0200
Message-ID: <2681038.03lnYPhpsa@tauon.chronox.de>
In-Reply-To: <20170916130034.17706-1-Jason@zx2c4.com>
References: <20170916130034.17706-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: [kernel-hardening] Re: [PATCH v4] security/keys: rewrite all of big_key crypto
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, dhowells@redhat.com, ebiggers3@gmail.com, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ilhan Gurel <ilhan.gurel@gmail.com>, security@kernel.org, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Am Samstag, 16. September 2017, 15:00:34 CEST schrieb Jason A. Donenfeld:

Hi Jason,

> This started out as just replacing the use of crypto/rng with
> get_random_bytes_wait, 

This change is a challenge. The use of the kernel crypto API's DRNG has been 
made to allow FIPS 140-2 compliance. Otherwise, the entire key generation 
logic will not be using the right(TM) DRNG. Thus, I would not suggest to 
replace that for a stable tree.

Note, I am currently working on a pluggable DRNG apporach for /dev/random and 
/dev/urandom to be able to get rid of the use of the kernel crypto API's DRNG 
API. It is ready and I will air that solution shortly. Yet, it needs work to 
be integrated upstream (and approval from Ted Tso).

Ciao
Stephan
