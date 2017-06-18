From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Date: Sun, 18 Jun 2017 10:04:58 +0200
Message-ID: <2639082.PtrrGWOPPL@positron.chronox.de>
In-Reply-To: <02d60ed4-4207-dd7d-8826-0f9f7f4e966d@suse.com>
References: <20170606174804.31124-1-Jason@zx2c4.com> <CAHmME9rU_H6Jq7ArjDq1yByrYf1P7nyC4Y8tqkzG585U39MFLg@mail.gmail.com> <02d60ed4-4207-dd7d-8826-0f9f7f4e966d@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: Re: [kernel-hardening] Re: [PATCH v4 06/13] iscsi: ensure RNG is seeded before use
To: Lee Duncan <lduncan@suse.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Chris Leech <cleech@redhat.com>, open-iscsi@googlegroups.com
List-ID: <kernel-hardening.lists.openwall.com>

Am Samstag, 17. Juni 2017, 05:45:57 CEST schrieb Lee Duncan:

Hi Lee,

> In your testing, how long might a process have to wait? Are we talking
> seconds? Longer? What about timeouts?
>

In current kernels (starting with 4.8) this timeout should clear within a few 
seconds after boot.

In older kernels (pre 4.8), my KVM takes up to 90 seconds to reach that 
seeding point. I have heard that on IBM System Z this trigger point requires 
minutes to be reached.

Ciao
Stephan
