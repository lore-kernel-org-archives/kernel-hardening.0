MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAHmME9q01Yb_hhDpfOz0v8Tg-AQE9Ov3hdN5S-FoMsTsh=kvWw@mail.gmail.com>
References: <1507676974-1298-1-git-send-email-me@tobin.cc> <CA+55aFx56_4ERvNfdvQUk4yFF5UXWPkwg5g=QwS820nxAK0Bcg@mail.gmail.com>
 <CAHmME9q01Yb_hhDpfOz0v8Tg-AQE9Ov3hdN5S-FoMsTsh=kvWw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Oct 2017 14:29:09 -0700
Message-ID: <CA+55aFzc9vaZxd0u-QmqTzwObQizCGAn79s2u0m4v1cE_ntPMA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 0/3] add %pX specifier
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, KVM list <kvm@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 11, 2017 at 1:11 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Indeed the correct functions to use would be siphash_1u32 or
> siphash_1u64, depending. Depending on the popularity of that, we might
> even consider making a siphash_1ulong helper, I suppose.

Yeah, siphash is probably the sanest thing to use.

How bad would it be to use HalfSipHash on 32-bit architectures?

On a 32-bit machine, the full siphash is pretty expensive - big
constants, and lots of 64-bit shifts. And 32-bit machines also tend to
mean "slow machines" these days.

I suspect there's little point in worrying a ton about the 64-bit key,
considering that I think the *input* is generally more guessable than
the output or the key.

           Linus
