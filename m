From: Pavel Vasilyev <dixlor@gmail.com>
References: <1509945567-11801-1-git-send-email-me@tobin.cc>
 <CA+55aFzPeCuvjscBNj6ANzfRUDsjT6Ntn9Grr915CrSpOfNSnA@mail.gmail.com>
Message-ID: <12d52fe9-d205-7186-31ac-0eb6e7a467e6@gmail.com>
Date: Mon, 6 Nov 2017 21:25:33 +0300
MIME-Version: 1.0
In-Reply-To: <CA+55aFzPeCuvjscBNj6ANzfRUDsjT6Ntn9Grr915CrSpOfNSnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] Re: [PATCH v3] scripts: add
 leaking_addresses.pl
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <golden_miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Tobin C. Harding" <me@tobin.cc>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

 ./leaking_addresses.pl --dont_walk_abs /proc --dont_walk_abs /sys
Unknown option: dont_walk_abs
Unknown option: dont_walk_abs

06.11.2017 20:27, Linus Torvalds пишет:
> David - you can see the patch on patchwork:
>
>     https://patchwork.kernel.org/patch/10042605/
>
> and try it out yourself.
>
