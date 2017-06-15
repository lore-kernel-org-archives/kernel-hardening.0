From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Date: Thu, 15 Jun 2017 13:59:43 +0200
Message-ID: <1606799.lNpamfCTbW@tauon.chronox.de>
In-Reply-To: <871sqlpl63.fsf@concordia.ellerman.id.au>
References: <20170606174804.31124-1-Jason@zx2c4.com> <20170608081919.zbtwdjl32vbvd7jt@thunk.org> <871sqlpl63.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: Re: [kernel-hardening] Re: [PATCH v4 13/13] random: warn when kernel uses unseeded randomness
To: kernel-hardening@lists.openwall.com
Cc: Michael Ellerman <mpe@ellerman.id.au>, Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Am Donnerstag, 15. Juni 2017, 13:03:48 CEST schrieb Michael Ellerman:

Hi Michael,

> 
> Even with this patch, it's still pretty spammy (today's linux-next):
> 

I would think that the issue regarding the logging is relevant for 
cryptographic use cases or use cases requiring strong random numbers only. 
Only those use cases should be fixed eventually to wait for a fully seeded 
DRNG.

The logged messages you present here indicate use cases where no strong 
security is required. It looks like that the logs show ASLR related use of 
random numbers. Those do not require a fully seeded ChaCha20 DRNG.

IMHO, users using the get_random_u64 or get_random_u32 are use cases that do 
not require a fully seeded DRNG thus do not need a cryptographically strong 
random number. Hence, I would think that the logging should be removed from 
get_random_u32/u64.

Yet, logging should remain for get_random_bytes which should be denominated as 
the interface for use cases where cryptographically strong random numbers are 
required.

Ciao
Stephan
