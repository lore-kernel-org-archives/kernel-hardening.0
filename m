Date: Wed, 7 Jun 2017 23:01:54 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170608030154.mwniddfm6hke773t@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com>
 <20170606174804.31124-12-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170606174804.31124-12-Jason@zx2c4.com>
Subject: [kernel-hardening] Re: [PATCH v4 11/13] net/route: use get_random_int for random counter
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 06, 2017 at 07:48:02PM +0200, Jason A. Donenfeld wrote:
> Using get_random_int here is faster, more fitting of the use case, and
> just as cryptographically secure. It also has the benefit of providing
> better randomness at early boot, which is when many of these structures
> are assigned.
> 
> Also, semantically, it's not really proper to have been assigning an
> atomic_t in this way before, even if in practice it works fine.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: David Miller <davem@davemloft.net>

Applied to the dev branch of the random.git branch, thanks.

	       	   	     	 	    - Ted
