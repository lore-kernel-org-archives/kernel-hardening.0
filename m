Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAHmME9rbKi3O1SS89LRMEUeMdKyrdutXAfjb9QmW3KNoCuE-wg@mail.gmail.com>
References: <CAHmME9rbKi3O1SS89LRMEUeMdKyrdutXAfjb9QmW3KNoCuE-wg@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 16 Dec 2016 23:12:51 +0100
Message-ID: <CAHmME9qpyCDDAfCx-G=B1h=Os5LS11YrEAXuqHteRrvKgUp-jA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v6 3/5] random: use SipHash in place of MD5
To: Andy Lutomirski <luto@amacapital.net>, Ted Tso <tytso@mit.edu>
Cc: Netdev <netdev@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, David Laight <David.Laight@aculab.com>, Hannes Frederic Sowa <hannes@stressinduktion.org>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers3@gmail.com>, Tom Herbert <tom@herbertland.com>, George Spelvin <linux@sciencehorizons.net>, Vegard Nossum <vegard.nossum@gmail.com>, Andi Kleen <ak@linux.intel.com>, "David S. Miller" <davem@davemloft.net>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Andy, Ted,

I've made the requested changes. Keys now rotate and are per-CPU
based. The chaining value is now additive instead of replacing.

DavidL suggested I lower the velocity of `git-send-email` triggers, so
if you'd like to take a look at this before I post v7, you can follow
along at my git tree here:

    https://git.zx2c4.com/linux-dev/log/?h=siphash

Choose the commit entitled "random: use SipHash in place of MD5"

Thanks,
Jason
