MIME-Version: 1.0
In-Reply-To: <CA+55aFzc9vaZxd0u-QmqTzwObQizCGAn79s2u0m4v1cE_ntPMA@mail.gmail.com>
References: <1507676974-1298-1-git-send-email-me@tobin.cc> <CA+55aFx56_4ERvNfdvQUk4yFF5UXWPkwg5g=QwS820nxAK0Bcg@mail.gmail.com>
 <CAHmME9q01Yb_hhDpfOz0v8Tg-AQE9Ov3hdN5S-FoMsTsh=kvWw@mail.gmail.com> <CA+55aFzc9vaZxd0u-QmqTzwObQizCGAn79s2u0m4v1cE_ntPMA@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 12 Oct 2017 00:11:43 +0200
Message-ID: <CAHmME9qWH9CFniuyMBENtRHZQcKjGSdMMYYOuVAHLH3gJiLtqg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 0/3] add %pX specifier
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, KVM list <kvm@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, Jann Horn <jann@thejh.net>, pbsd-hn@protonmail.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 11, 2017 at 11:29 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Yeah, siphash is probably the sanest thing to use.
>
> How bad would it be to use HalfSipHash on 32-bit architectures?
>
> On a 32-bit machine, the full siphash is pretty expensive - big
> constants, and lots of 64-bit shifts. And 32-bit machines also tend to
> mean "slow machines" these days.
>
> I suspect there's little point in worrying a ton about the 64-bit key,
> considering that I think the *input* is generally more guessable than
> the output or the key.

[1.0000] Warning: kernel object at address A has a problem
[2.0000] Warning: kernel object at address B has a problem

A and B are known to be in the interval [M, N] ("they're both 128 byte
GFP_KERNEL allocations") and |A-B| is in the smaller interval [m, n]
("they're successive net_devices"). With a 64-bit key (as in
hsiphash), A and B can probably be bruteforced. If you can bruteforce
the key, then %pX==%p, so no good. While this still requires likely
>2^64 computation, this can be offloaded from a victim box and
parallelized.

So we probably want to stick with the 128-bit key of full SipHash for
both platforms. Fortunately, it's still pretty fast.



On another topic: the approach we're discussing here is using a PRF
(pseudo-random function), also known as a keyed hash function. It's
not reversible; it isn't encryption. Mapping 64-bit inputs to 64-bit
outputs means there _might_ be collisions. Not a very huge chance,
considering kernel pointers are nowhere near the full 64-bit domain,
but there's a non-zero chance. Of course, this kind of silly tiny
possibility doesn't actually matter at all for us, since it means
there'd just be an extremely rare confusing dmesg message. So who
cares.

But there is something slightly different that you might be interested
in: a PRP (psuedo-random permutation), also known as a block cipher.
In this case, there'd be a 64-bit to 64-bit reversible map, based on a
secret key, with no collisions. In other words, pointer encryption,
rather than hashing. Aarch64 has some special instructions for this,
with the QARMA tweakable block cipher being built-in. Might be fun to
nerd out about, but I don't know that we actually need this or would
want the complexity, and probably a PRF like SipHash is sufficient.
But thought I'd make you aware of the possibility, in case you're
interested.
