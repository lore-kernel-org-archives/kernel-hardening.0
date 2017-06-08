Date: Wed, 7 Jun 2017 22:45:12 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170608024512.vjmut7buvimilpfx@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com>
 <20170606174804.31124-8-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170606174804.31124-8-Jason@zx2c4.com>
Subject: Re: [kernel-hardening] [PATCH v4 07/13] ceph: ensure RNG is seeded
 before using
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>, Ilya Dryomov <idryomov@gmail.com>, "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 06, 2017 at 07:47:58PM +0200, Jason A. Donenfeld wrote:
> Ceph uses the RNG for various nonce generations, and it shouldn't accept
> using bad randomness. So, we wait for the RNG to be properly seeded. We
> do this by calling wait_for_random_bytes() in a function that is
> certainly called in process context, early on, so that all subsequent
> calls to get_random_bytes are necessarily acceptable.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Ilya Dryomov <idryomov@gmail.com>
> Cc: "Yan, Zheng" <zyan@redhat.com>
> Cc: Sage Weil <sage@redhat.com>

Thanks, applied to the dev branch.

					- Ted
