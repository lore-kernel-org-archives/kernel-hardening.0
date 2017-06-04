From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Date: Sun, 04 Jun 2017 08:23:41 +0200
Message-ID: <2428753.coFJxKiQCy@tauon.chronox.de>
In-Reply-To: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
References: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: [kernel-hardening] Re: get_random_bytes returns bad randomness before seeding is complete
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Am Freitag, 2. Juni 2017, 16:59:56 CEST schrieb Jason A. Donenfeld:

Hi Jason,

> Alternatively, I'm open to other solutions people might come up with.

One addition, there is an issue (I would call it a bug) in random.c before 4.8 
where the nonblocking_pool is not reseeded during early boot even though 
entropy may be available. That issue aggravates early boot time entropy issues 
for user and kernel land.

I have not heard about accepting or rejecting it, so I am wondering how 
patches go into random.c at all.

[1] https://patchwork.kernel.org/patch/9620431/

Ciao
Stephan
