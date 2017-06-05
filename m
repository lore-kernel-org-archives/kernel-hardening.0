MIME-Version: 1.0
In-Reply-To: <20170605034757.4803-1-Jason@zx2c4.com>
References: <20170605034757.4803-1-Jason@zx2c4.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 6 Jun 2017 01:47:25 +0200
Message-ID: <CAHmME9oXmZD2X8hSicVgAZRbaoBNUwRK-16Ekz2JAkNcZE+_dg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH RFC v2 0/8] get_random_bytes_wait family of APIs
To: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

As this RFC series matures, all the changes are in this branch here, to look at:

https://git.zx2c4.com/linux-dev/log/?h=jd/rng-blocker

Ted -- there's one, in particular, that should probably be picked up
regardless of the rest, and that's "random: invalidate batched entropy
after crng init". Hopefully though, we can develop that in relation
with the rest and make this a proper series.

Anyway, awaiting your feedback on these RFC series, if you'd like to
help me help the Linux RNG.

Jason
