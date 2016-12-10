Reply-To: kernel-hardening@lists.openwall.com
Date: 10 Dec 2016 10:35:17 -0500
Message-ID: <20161210153517.30834.qmail@ns.sciencehorizons.net>
From: "George Spelvin" <linux@sciencehorizons.net>
In-Reply-To: <CAOMGZ=HMTZhBOh0jTBT4cyMuK5s-D51FFUtWUWyMV7VX0U2L0w@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] siphash: add cryptographically secure hashtable function
To: Jason@zx2c4.com, vegard.nossum@gmail.com
Cc: djb@cr.yp.to, jeanphilippe.aumasson@gmail.com, kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux@sciencehorizons.net, rusty@rustcorp.com.au, torvalds@linux-foundation.org
List-ID: <kernel-hardening.lists.openwall.com>

> There's a 32-bit secret random salt (inet_ehash_secret) which means
> that in practice, inet_ehashfn() will select 1 out of 2^32 different
> hash functions at random each time you boot the kernel; without
> knowing which one it selected, how can a local or remote attacker can
> force IPv4 connections/whatever to go into a single hash bucket?

By figuring out the salt.  The thing is, the timing of hash table lookups
*is externally visible*.  If I create connections to the target, then
see which ones make responses on previous connections slightly slower,
I gain information about the salt.

I dont't know *where* in the hash table the collissions occur, but I
know *which* inputs collide, and that's enough for me to learn something.

(I need more connections than the size of the hash table, but even
with just one IP source I can use 64K ports on my end times however
many the target has open on its end.)

With enough information (google "unicity distance") I can recover the
entire salt.  It's not like I care about the cryptographic strength of
the hash; simply trying all 4 billion possible seeds is pretty fast on
a 4 GHz processor.

Once that happens, I can choose a target connection whose timing I can't
observe directly and pack its hash chain without being obvious about it.

> I am happy to be proven wrong, but you make it sound very easy to
> exploit the current situation, so I would just like to ask whether you
> have a concrete way to do that?

I don't think anyone's implemented an attack on this particular hash
table yet, and the reason it hasn't been urgent is that it's just a mild
DoS attack it makes the computer noticeably slower withough disabling
it completely.

But the general style of attack is well known and has been repeatedly
demonstrated.  Its practicality is not in question.  The only question is
whether it's *more* practical that simpler techniques that don't depend
on any such algorithmic subtlety like brute-force flooding.

But if the history of Internet security has taught us one thing, it's
that naively hoping something won't be a problem is doomed.


The main issue is performance.  IPv6 addresses are big, and although
SipHash is fast by the standard of cryptographic hashes, it's far slower
than jhash or any other non-cryptographic hash.
