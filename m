MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <1509945567-11801-1-git-send-email-me@tobin.cc>
References: <1509945567-11801-1-git-send-email-me@tobin.cc>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 6 Nov 2017 09:27:09 -0800
Message-ID: <CA+55aFzPeCuvjscBNj6ANzfRUDsjT6Ntn9Grr915CrSpOfNSnA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3] scripts: add leaking_addresses.pl
To: "Tobin C. Harding" <me@tobin.cc>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Nov 5, 2017 at 9:19 PM, Tobin C. Harding <me@tobin.cc> wrote:
> Currently we are leaking addresses from the kernel to user space. This
> script is an attempt to find some of those leakages. Script parses
> `dmesg` output and /proc and /sys files for hex strings that look like
> kernel addresses.

Lovely. This is great. It shows just how much totally pointless stuff
we leak, and to normal users that really shouldn't need it.

I had planned to wait for 4.15 to look at the printk hashing stuff
etc, but this part I think I could/should merge early just because I
think a lot of kernel developers will go "Why the f*ck would we expose
that kernel address there?"

The module sections stuff etc should likely be obviously root-only,
although maybe I'm missing some tool that ends up using it and is
useful to normal developers.

And I'm thinking we could make kallsyms smarter too, and instead of
depending on kptr_restrict that screws over things with much too big a
hammer, we could make it take 'perf_event_paranoid' into account. I
suspect that's the main user of kallsyms that would still be relevant
to non-root.

I really really hate kptr_restrict due to that whole "all or nothing" thing.

The networking code ends up having a ton of "sk" pointers, and I
suspect those would all be fine just using the hashed address, since
nobody is going to care about the _actual_ kernel address, but
matching a socket reference in one file against another one makes tons
of sense and I would not be surprised if there's a lot of netstat-like
tools that do that. So the whole '%pK' thing is entirely useless for
them, but the "hash %p values" should work fine.

Adding netdev and David Miller explicitly to the cc, since many of the
kernel pointer leaks are from them, and they may not even have been
following this discussion at all.

David - you can see the patch on patchwork:

    https://patchwork.kernel.org/patch/10042605/

and try it out yourself.

I heartily recommend other developers run it too, just to see if it
makes you go "Oh, I didn't even realize.."

This looks much more interesting than the whole "%p vs %pK vs %x" discussion.

                  Linus
