MIME-Version: 1.0
In-Reply-To: <20170608004134.hveeuvojoc2edgjm@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com> <20170606174804.31124-6-Jason@zx2c4.com>
 <20170608004134.hveeuvojoc2edgjm@thunk.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 8 Jun 2017 02:47:36 +0200
Message-ID: <CAHmME9rO7+WtWWLxGpzusqzZ352BB9vw0C12SB1rF6xxbuM7ig@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH v4 05/13] crypto/rng: ensure that the
 RNG is ready before using
To: Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 8, 2017 at 2:41 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> The use in keys/big_key is _being_ removed, so this commit is
> dependent on that commit landing, correct?  (Order matters, because
> otherwise we don't want to potentially screw up doing a kernel bisect
> and causing their kernel to deadlock during the boot while they are
> trying to track down an unreleated problem.)

Yes. It's actually landing with get_random_bytes, to avoid a
dependency problem when merging. After these both lands, I'll submit a
third changing that over to get_random_bytes_wait in the right place.
