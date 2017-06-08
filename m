Date: Wed, 7 Jun 2017 22:43:57 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170608024357.fhyyentj2qm7ti2q@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com>
 <20170606174804.31124-7-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170606174804.31124-7-Jason@zx2c4.com>
Subject: [kernel-hardening] Re: [PATCH v4 06/13] iscsi: ensure RNG is seeded before use
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 06, 2017 at 07:47:57PM +0200, Jason A. Donenfeld wrote:
> It's not safe to use weak random data here, especially for the challenge
> response randomness. Since we're always in process context, it's safe to
> simply wait until we have enough randomness to carry out the
> authentication correctly.
> 
> While we're at it, we clean up a small memleak during an error
> condition.

What was the testing that was done for commit?  It looks safe, but I'm
unfamiliar enough with how the iSCSI authentication works that I'd
prefer getting an ack'ed by from the iSCSI maintainers or
alternativel, information about how to kick off some kind of automated
test suite ala xfstests for file systems.

Thanks,

					- Ted
