Date: Wed, 7 Jun 2017 20:25:23 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170608002523.m3h3jin4poav5xy2@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com>
 <20170606174804.31124-9-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170606174804.31124-9-Jason@zx2c4.com>
Subject: Re: [kernel-hardening] [PATCH v4 08/13] cifs: use get_random_u32 for
 32-bit lock random
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>, Steve French <sfrench@samba.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 06, 2017 at 07:47:59PM +0200, Jason A. Donenfeld wrote:
> Using get_random_u32 here is faster, more fitting of the use case, and
> just as cryptographically secure. It also has the benefit of providing
> better randomness at early boot, which is sometimes when this is used.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Steve French <sfrench@samba.org>

There's a bigger problem here, which is that cifs_lock_secret is a
32-bit value which is being used to obscure flock->fl_owner before it
is sent across the wire.  But flock->fl_owner is a pointer to the
struct file *, so 64-bit architecture, the high 64-bits of a kernel
pointer is being exposed to anyone using tcpdump.  (Oops, I'm showing
my age; I guess all the cool kids are using Wireshark these days.)

Worse, the obscuring is being done using XOR.  How an active attacker
might be able to trivially reverse engineer the 32-bit "secret" is
left as an exercise to the reader.  The bottom line is if the goal is
to hide the memory location of a struct file from an attacker,
cifs_lock_secret is about as useful as a TSA agent doing security
theatre at an airport.  Which is to say, it makes the civilians feel
good.  :-)

BTW, Jason, this is why it's *good* to audit all of the uses of
get_random_bytes().  It only took me about 30 seconds in the first
patch in your series that changes a caller of get_random_bytes(), and
look what I was able to find by just taking a quick look.  Not waiting
for the CRNG to be fully initialized is the *least* of its problems.

Anyway, I'll include this commit in the dev branch of the random tree,
since it's not going to make things worse.

						- Ted
