Date: Wed, 5 Jul 2017 13:34:39 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170705173439.rra2enjfp3vv7rvb@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com>
 <20170606174804.31124-7-Jason@zx2c4.com>
 <20170608024357.fhyyentj2qm7ti2q@thunk.org>
 <CAHmME9pViOqqDPyjXKLfCWSTnQrcE4OLJMdK1yaTiUvrOV+ecQ@mail.gmail.com>
 <fbca1b2b-c9ae-80ce-45ef-17c3d3b93e57@suse.com>
 <CAHmME9rU_H6Jq7ArjDq1yByrYf1P7nyC4Y8tqkzG585U39MFLg@mail.gmail.com>
 <02d60ed4-4207-dd7d-8826-0f9f7f4e966d@suse.com>
 <CAH8yC8nHX2r9cfQ0gNeJAUrgSfAS8V16dVHv35BRnLn-YprZCg@mail.gmail.com>
 <595C9079020000A100026F37@gwsmtp1.uni-regensburg.de>
 <8CC15605-CFF3-4D6E-ADBE-5EFC9F8E7CE7@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8CC15605-CFF3-4D6E-ADBE-5EFC9F8E7CE7@comcast.net>
Subject: Re: Antw: Re: [kernel-hardening] Re: [PATCH v4 06/13] iscsi: ensure
 RNG is seeded before use
To: Paul Koning <paulkoning@comcast.net>
Cc: open-iscsi@googlegroups.com, Lee Duncan <lduncan@suse.com>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>, "Nicholas A.Bellinger" <nab@linux-iscsi.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Chris Leech <cleech@redhat.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, linux-kernel@vger.kernel.org, "Jason A.Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 05, 2017 at 09:16:09AM -0400, Paul Koning wrote:
> 
> In the implementations I know, /dev/random and /dev/urandom are the
> same driver, the only difference is that when you read from
> /dev/random there's a check for the current entropy level.

It's in the same driver but /dev/random and /dev/urandom are different
beasts.  Pre-4.9 we use the same SHA-1 based generator, but we use
different state pools, and we periodically "catastrophically reseed"
(ala Yarrow) from the random pool to the urandom pool.  Getrandom(2)
uses the urandom pool.

In 4.9 and later kernels, /dev/urandom and getrandom(2) use a ChaCha20
based generator which provides for more speed.  We still use the SHA-1
pool for the random pool because it allows for a much larger "state
pool" to store entropy.

> If you have a properly constructed RNG, as soon as it's been fed
> enough entropy it is secure (at least for the next 2^64 bits or so).
> The notion of "using up entropy" is not meaningful for a good
> generator.  See Bruce Schneier's "Yarrow" paper for the details.

A lot of this depends on whether or not you trust your crypto
primitives or not.  The /dev/random driver was the very first OS-based
random generator, and back then, export restrictions were still a
thing (which is why we only used MD5 and SHA-1 as crypto primitives),
and our cryptoanalytic understanding of what makes for a good crypto
hash or encryption algorithm was quite limited.  So trying to
accumulate a large amount of entropy pool of entropy is a good thing,
because even if there was a minor weakness in the crypto hash (and for
a while we were using MD5), relying on the adversary not being able to
guess all of the environmental noise harvested by the kernel would
cover for a lot of sins.

Remember, in the kernel we have access to a large amount of
environmental noise, so it makes a lot of sense to take advantage of
that as much as possible.  So by having a huge state pool for the
/dev/random entropy pool, we can harvest and store as much of that
environmental noise as possible.  This buys us a large amount of
safety margin, which is good thing because somewhere there might be
some Linux 2.0 or Linux 2.2 based router sitting in someone's home
where /dev/random is using MD5.  Those ancient kernels are probably
riddled with zero-day security holes, but the safety margin of using a
large entropy pool is such that even though there are many known
attacks against MD5, I'm actually pretty confident that the large
state pool mitigates the weakness of MD5 as used by /dev/random and
/dev/urandom.  At the very least, it will be much easier for the NSA
to use some other zero-day to attack the said router with the ancient
kernel, well before they try to reverse engineer its /dev/urandom
output.  :-)

						- Ted
