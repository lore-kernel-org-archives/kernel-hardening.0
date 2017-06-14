MIME-Version: 1.0
In-Reply-To: <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc>
References: <20170607232607.26870-1-Jason@zx2c4.com> <20170607232607.26870-2-Jason@zx2c4.com>
 <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 15 Jun 2017 00:33:12 +0200
Message-ID: <CAHmME9oRG4Oe4zNN4D8Nc9+A51uXPC0y3m3+ws_QK2aq=K=zwA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5 01/13] random: invalidate batched entropy after crng init
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers3@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, David Miller <davem@davemloft.net>, tglx@breakpoint.cc
List-ID: <kernel-hardening.lists.openwall.com>

There's a potential race that I fixed in my v5 of that patch set, but
Ted only took v4, and for whatever reason has been to busy to submit
the additional patch I already posted showing the diff between v4&v5.
Hopefully he actually gets around to it and sends this for the next
rc. Here it is:

https://patchwork.kernel.org/patch/9774563/
