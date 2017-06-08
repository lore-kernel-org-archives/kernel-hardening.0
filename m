Date: Wed, 7 Jun 2017 20:05:25 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170608000525.yezrat26fvrdpdrv@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com>
 <20170606174804.31124-4-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170606174804.31124-4-Jason@zx2c4.com>
Subject: Re: [kernel-hardening] [PATCH v4 03/13] random: add
 get_random_{bytes,u32,u64,int,long,once}_wait family
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 06, 2017 at 07:47:54PM +0200, Jason A. Donenfeld wrote:
> These functions are simple convenience wrappers that call
> wait_for_random_bytes before calling the respective get_random_*
> function.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Thanks, applied to the dev branch.

					- Ted
