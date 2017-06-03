From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sat,  3 Jun 2017 04:32:01 +0200
Message-Id: <20170603023204.30933-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9oLHP85ENr5aZgKsTSrxiUWoQ_pfv7C6XYxmcoxPfq3Ew@mail.gmail.com>
References: <CAHmME9oLHP85ENr5aZgKsTSrxiUWoQ_pfv7C6XYxmcoxPfq3Ew@mail.gmail.com>
Subject: [kernel-hardening] [PATCH RFC 0/3] get_random_bytes seed blocking
To: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

Per the other thread on this mailing list, here's an initial
stab at what we discussed -- adding a blocking API for the RNG,
and adding a default-on dmesg Kconfig value for when things go
wrong.

Let me know what you think of this general implementation strategy,
and if you like it, I'll move forward with polish and with integrating
it into a fix for a few currently buggy get_random_bytes use cases.

Jason A. Donenfeld (3):
  random: add synchronous API for the urandom pool
  random: add get_random_{bytes,u32,u64,int,long}_wait family
  random: warn when kernel uses unseeded randomness

 drivers/char/random.c  | 49 +++++++++++++++++++++++++++++++++++++++++++++----
 include/linux/random.h | 31 +++++++++++++++++++++++++++++++
 lib/Kconfig.debug      | 15 +++++++++++++++
 3 files changed, 91 insertions(+), 4 deletions(-)

-- 
2.13.0
