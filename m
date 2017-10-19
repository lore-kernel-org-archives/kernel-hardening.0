MIME-Version: 1.0
In-Reply-To: <CAGXu5jKfeQm6ygxN7yvXs3nhLbi0EK+LbQhuEc0mKgSN-BZHZw@mail.gmail.com>
References: <1508362242-12857-1-git-send-email-me@tobin.cc>
 <CAHmME9oawjpRQEqo_rHgqjC6S8pSrEr2sbr06Gkhm93DXq9kqA@mail.gmail.com>
 <20171019013106.GE604@jagdpanzerIV> <CAHmME9oDWRo2CYMoF+frqypje4DEBFchEoX-j19jkHNybkGUrQ@mail.gmail.com>
 <20171019014429.GG31318@eros> <CAHmME9qV-f1pvW0iC2cYU71PA+YUf0YpR=06T+FCFxywRhvjEw@mail.gmail.com>
 <CAGXu5jKfeQm6ygxN7yvXs3nhLbi0EK+LbQhuEc0mKgSN-BZHZw@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 19 Oct 2017 19:30:27 +0200
Message-ID: <CAHmME9qwoSwFi7fsg1Z+gcEh1fBY+KY2rJ81UTHYn2ZMcjjwFA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5] printk: hash addresses printed with %p
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

> Tangent: why is the random_ready API designed with -EALREADY? Couldn't
> add_random_ready_callback() just perform the call itself and avoid
> needing all the callers to check for -EALREADY?

Absolutely. I can submit a patch for this soon, though to avoid merge
dependencies, and given the usual delays in getting random.c things
merged, maybe I'll wait until after this patch hits Linus' tree.

This could even be renamed and made into an LD section, as
random_initcall, though that needs some more spec'ing out.
