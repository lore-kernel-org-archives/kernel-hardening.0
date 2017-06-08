MIME-Version: 1.0
In-Reply-To: <20170608002523.m3h3jin4poav5xy2@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com> <20170606174804.31124-9-Jason@zx2c4.com>
 <20170608002523.m3h3jin4poav5xy2@thunk.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 8 Jun 2017 02:34:40 +0200
Message-ID: <CAHmME9o+qn+yo1KRekNXNm1r1swSgQasKpqws2EGh6iv1LOagg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH v4 08/13] cifs: use get_random_u32 for
 32-bit lock random
To: Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>, Steve French <sfrench@samba.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 8, 2017 at 2:25 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> There's a bigger problem here, which is that cifs_lock_secret is a
> 32-bit value which is being used to obscure flock->fl_owner before it
> is sent across the wire.  But flock->fl_owner is a pointer to the
> struct file *, so 64-bit architecture, the high 64-bits of a kernel
> pointer is being exposed to anyone using tcpdump.  (Oops, I'm showing
> my age; I guess all the cool kids are using Wireshark these days.)
>
> Worse, the obscuring is being done using XOR.  How an active attacker
> might be able to trivially reverse engineer the 32-bit "secret" is
> left as an exercise to the reader.  The bottom line is if the goal is
> to hide the memory location of a struct file from an attacker,
> cifs_lock_secret is about as useful as a TSA agent doing security
> theatre at an airport.  Which is to say, it makes the civilians feel
> good.  :-)

High five for taking the deep dive and actually reading how this all
works. Nice bug!

> Not waiting
> for the CRNG to be fully initialized is the *least* of its problems.

The kernel is vast and filled with tons of bugs of many sorts. On this
reasoning, maybe I should spend my time auditing web apps instead,
which are usually the "front door" of bugs? I like the puzzles of
random.c. I also had a real world need for wait_for_random_bytes() in
a module I'm writing.

But anyway, your general point is a really good one. Tons of callers
of the random functions are doing it wrong in one way or another.
Spending time looking at those is probably a good idea...

> Anyway, I'll include this commit in the dev branch of the random tree,
> since it's not going to make things worse.

Great, thanks.
