Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20161209183659.25727-1-Jason@zx2c4.com>
References: <20161209183659.25727-1-Jason@zx2c4.com>
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sat, 10 Dec 2016 15:17:17 +0100
Message-ID: <CAOMGZ=HMTZhBOh0jTBT4cyMuK5s-D51FFUtWUWyMV7VX0U2L0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] siphash: add cryptographically secure hashtable function
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>, Linus Torvalds <torvalds@linux-foundation.org>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, "Daniel J . Bernstein" <djb@cr.yp.to>, linux@sciencehorizons.net
List-ID: <kernel-hardening.lists.openwall.com>

On 9 December 2016 at 19:36, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> SipHash is a 64-bit keyed hash function that is actually a
> cryptographically secure PRF, like HMAC. Except SipHash is super fast,
> and is meant to be used as a hashtable keyed lookup function.
>
> SipHash isn't just some new trendy hash function. It's been around for a
> while, and there really isn't anything that comes remotely close to
> being useful in the way SipHash is. With that said, why do we need this?
>
> There are a variety of attacks known as "hashtable poisoning" in which an
> attacker forms some data such that the hash of that data will be the
> same, and then preceeds to fill up all entries of a hashbucket. This is
> a realistic and well-known denial-of-service vector.
>
> Linux developers already seem to be aware that this is an issue, and
> various places that use hash tables in, say, a network context, use a
> non-cryptographically secure function (usually jhash) and then try to
> twiddle with the key on a time basis (or in many cases just do nothing
> and hope that nobody notices). While this is an admirable attempt at
> solving the problem, it doesn't actually fix it. SipHash fixes it.

Could you give some more concrete details/examples? Here's the IPv4
hash table from include/net/inet_sock.h / net/ipv4/inet_hashtables.c:

static inline unsigned int __inet_ehashfn(const __be32 laddr,
                                         const __u16 lport,
                                         const __be32 faddr,
                                         const __be16 fport,
                                         u32 initval)
{
       return jhash_3words((__force __u32) laddr,
                           (__force __u32) faddr,
                           ((__u32) lport) << 16 | (__force __u32)fport,
                           initval);
}

static u32 inet_ehashfn(const struct net *net, const __be32 laddr,
                       const __u16 lport, const __be32 faddr,
                       const __be16 fport)
{
       static u32 inet_ehash_secret __read_mostly;

       net_get_random_once(&inet_ehash_secret, sizeof(inet_ehash_secret));

       return __inet_ehashfn(laddr, lport, faddr, fport,
                             inet_ehash_secret + net_hash_mix(net));
}

There's a 32-bit secret random salt (inet_ehash_secret) which means
that in practice, inet_ehashfn() will select 1 out of 2^32 different
hash functions at random each time you boot the kernel; without
knowing which one it selected, how can a local or remote attacker can
force IPv4 connections/whatever to go into a single hash bucket?

It is not possible to obtain the secret salt directly (except by
reading from kernel memory, in which case you've lost already), nor is
it possible to obtain the result of inet_ehashfn() other than (maybe)
by a timing attack where you somehow need to detect that two
connections went into the same hash bucket and work backwards from
that to figure out how to land more connections into into the same
bucket -- but if they can do that, you've also already lost.

The same pattern is used for IPv6 hashtables and the dentry cache.

I suppose that using a hash function proven to be cryptographically
secure gives a hard guarantee (under some assumptions) that the
salt/key will give enough diversity between the (in the example above)
2^32 different hash functions that you cannot improve your chances of
guessing that two values will map to the same bucket regardless of the
salt/key. However, I am a bit doubtful that using a cryptographically
secure hash function will make much of a difference as long as the
attacker doesn't actually have any way to get the output/result of the
hash function (and given that the hash function isn't completely
trivial, of course).

I am happy to be proven wrong, but you make it sound very easy to
exploit the current situation, so I would just like to ask whether you
have a concrete way to do that?


Vegard

> There are a modicum of places in the kernel that are vulnerable to
> hashtable poisoning attacks, either via userspace vectors or network
> vectors, and there's not a reliable mechanism inside the kernel at the
> moment to fix it. The first step toward fixing these issues is actually
> getting a secure primitive into the kernel for developers to use. Then
> we can, bit by bit, port things over to it as deemed appropriate.
>
> Dozens of languages are already using this internally for their hash
> tables. Some of the BSDs already use this in their kernels. SipHash is
> a widely known high-speed solution to a widely known problem, and it's
> time we catch-up.
