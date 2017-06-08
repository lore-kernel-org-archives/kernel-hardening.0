Date: Wed, 7 Jun 2017 20:00:43 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170608000043.5xfnmfhroawd5uep@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com>
 <20170606174804.31124-3-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170606174804.31124-3-Jason@zx2c4.com>
Subject: [kernel-hardening] Re: [PATCH v4 02/13] random: add synchronous API for the urandom pool
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 06, 2017 at 07:47:53PM +0200, Jason A. Donenfeld wrote:
> This enables users of get_random_{bytes,u32,u64,int,long} to wait until
> the pool is ready before using this function, in case they actually want
> to have reliable randomness.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Thanks, applied for the dev branch of random.git.  (I changed the
patch summary slightly; it now reads: "random: add
wait_for_random_bytes() API").

						- Ted
