MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAHmME9qWH9CFniuyMBENtRHZQcKjGSdMMYYOuVAHLH3gJiLtqg@mail.gmail.com>
References: <1507676974-1298-1-git-send-email-me@tobin.cc> <CA+55aFx56_4ERvNfdvQUk4yFF5UXWPkwg5g=QwS820nxAK0Bcg@mail.gmail.com>
 <CAHmME9q01Yb_hhDpfOz0v8Tg-AQE9Ov3hdN5S-FoMsTsh=kvWw@mail.gmail.com>
 <CA+55aFzc9vaZxd0u-QmqTzwObQizCGAn79s2u0m4v1cE_ntPMA@mail.gmail.com> <CAHmME9qWH9CFniuyMBENtRHZQcKjGSdMMYYOuVAHLH3gJiLtqg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Oct 2017 11:37:22 -0700
Message-ID: <CA+55aFwSJ4mJOSBqQ9TQyNc99+x=ZanFHnQjMaQCtF6_KKZPag@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 0/3] add %pX specifier
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, KVM list <kvm@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, Jann Horn <jann@thejh.net>, pbsd-hn@protonmail.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 11, 2017 at 3:11 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On another topic: the approach we're discussing here is using a PRF
> (pseudo-random function), also known as a keyed hash function. It's
> not reversible; it isn't encryption. Mapping 64-bit inputs to 64-bit
> outputs means there _might_ be collisions.

I really wouldn't worry about it.

In fact, I'd prefer mapping the pointer to a 32-bit value, even on
64-bit architectures. When people use these things for debugging and
for identifying which device node or socket or whatever they are
tracking, we're generally talking a (small) handful of different
devices or whatever.

Tobin did the statistics, most of the %p users are in drivers, and
they tend to be things like identifying *which* ACPI descriptor we're
talking about, or which command/request we're tracing, or which device
we're probing etc.  So _when_ we're talking about identities (as
opposed to when people actually want the true physical device address
or whatever), we're generally talking just a few entries. Maybe tens.

Can we get collisions when unlucky? Sure. But most of the time it's
literally about trying to track the commands to one particular device,
or track one particular command through the debug output. A 32-bit
hash is fine, because if we have so many different things going on at
the same time that you'd have a noticeable risk of collisions, you'd
not depend on debug traces etc anyway, you'd start doing fancier
tracing (ie start filtering using ebpf etc).

> But there is something slightly different that you might be interested
> in: a PRP (psuedo-random permutation), also known as a block cipher.
> In this case, there'd be a 64-bit to 64-bit reversible map, based on a
> secret key, with no collisions. In other words, pointer encryption,
> rather than hashing. Aarch64 has some special instructions for this,
> with the QARMA tweakable block cipher being built-in. Might be fun to
> nerd out about, but I don't know that we actually need this or would
> want the complexity, and probably a PRF like SipHash is sufficient.
> But thought I'd make you aware of the possibility, in case you're
> interested.

My guess would be that something like that might be nice if it would
mean that we'd get hw acceleration for the hashing, and that the
reversibility would be entirely secondary.

But I assume that even when you do have some hardware support for
something like that, the kernel would likely not really be able to use
it, for the simple reason that people would expect it to be used for
other things (and then setup/teardown costs would likely make it more
expensive than just doing the software SipHash() or equivalent). The
kernel use would likely simply be too rare and occasional to warrant
dedicated hardware use.

                     Linus
