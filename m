MIME-Version: 1.0
In-Reply-To: <1496425271.1989.1.camel@gmail.com>
References: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
 <CAHmME9omJTaP1C=yUh3913Cv1gF1pBtpy9cmEMyJG4yw_dnZWQ@mail.gmail.com> <1496425271.1989.1.camel@gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 2 Jun 2017 19:46:43 +0200
Message-ID: <CAHmME9rSNdTYK2GiazG0y_9POnBf__=puWJwrtKVptZxBXNiaA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: get_random_bytes returns bad randomness
 before seeding is complete
To: Daniel Micay <danielmicay@gmail.com>
Cc: Stephan Mueller <smueller@chronox.de>, Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 2, 2017 at 7:41 PM, Daniel Micay <danielmicay@gmail.com> wrote:
> One of the early uses is initializing the stack canary value for SSP in
> very early boot. If that blocks, it's going to be blocking nearly
> anything else from happening.
>
> On x86, that's only the initial canary since the per-task canaries end
> up being used, but elsewhere at least without SMP disabled or changes to
> GCC that's all there is so the entropy matters.

If this is the case, then we simply need a function called
get_random_bytes_but_potentially_crappy_ones_because_we_are_desperate_for_anything(),
which would respond with a weaker guarantee than that
get_random_bytes(), which the documentation says always returns
cryptographically secure numbers.
