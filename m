Date: Sun, 18 Jun 2017 11:46:25 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170618154625.5qu3eduqjtgk5bal@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com>
 <20170608081919.zbtwdjl32vbvd7jt@thunk.org>
 <871sqlpl63.fsf@concordia.ellerman.id.au>
 <1606799.lNpamfCTbW@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1606799.lNpamfCTbW@tauon.chronox.de>
Subject: Re: [kernel-hardening] Re: [PATCH v4 13/13] random: warn when kernel
 uses unseeded randomness
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc: kernel-hardening@lists.openwall.com, Michael Ellerman <mpe@ellerman.id.au>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 15, 2017 at 01:59:43PM +0200, Stephan Müller wrote:
> I would think that the issue regarding the logging is relevant for 
> cryptographic use cases or use cases requiring strong random numbers only. 
> Only those use cases should be fixed eventually to wait for a fully seeded 
> DRNG.
> 
> The logged messages you present here indicate use cases where no strong 
> security is required. It looks like that the logs show ASLR related use of 
> random numbers. Those do not require a fully seeded ChaCha20 DRNG.

I suspect there is a range of opinions aobut whether or not ASLR
requires strongly secure random numbers or not.  It seems pretty clear
that if we proposed using prandom_u32 for ASLR, people would object
very strongly indeed, since that would make it trivially easy for
attackers to circumvent ASLR protections.

> IMHO, users using the get_random_u64 or get_random_u32 are use cases that do 
> not require a fully seeded DRNG thus do not need a cryptographically strong 
> random number. Hence, I would think that the logging should be removed from 
> get_random_u32/u64.

You are effectively proposing that there ought to be a middle range of
security between prandom_32, get_random_u32/get_random_u64 and
get_random_bytes().  I think that's going to lead to all sorts of
complexity and bugs from people not understanding when they should use
get_random_u32 vs get_random_bytes versus prandom_u32.  And then we'll
end up needing to audit all of the callsites for get_random_u32() so
they don't violate this new usage rule that you are proposing.

     	   	   	    	       - Ted
