Date: Tue, 7 Nov 2017 08:03:27 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171106210327.GS18478@eros>
References: <1509945567-11801-1-git-send-email-me@tobin.cc>
 <CA+55aFzPeCuvjscBNj6ANzfRUDsjT6Ntn9Grr915CrSpOfNSnA@mail.gmail.com>
 <12d52fe9-d205-7186-31ac-0eb6e7a467e6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12d52fe9-d205-7186-31ac-0eb6e7a467e6@gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH v3] scripts: add
 leaking_addresses.pl
To: Pavel Vasilyev <dixlor@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <golden_miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 06, 2017 at 09:25:33PM +0300, Pavel Vasilyev wrote:
>  ./leaking_addresses.pl --dont_walk_abs /proc --dont_walk_abs /sys
> Unknown option: dont_walk_abs
> Unknown option: dont_walk_abs

Oh thanks. Documentation is out of sync with the code, what are the odds.

v4 to come.

thanks,
Tobin.
