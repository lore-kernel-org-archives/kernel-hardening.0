Date: Wed, 8 Nov 2017 15:18:15 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171108041815.GE18478@eros>
References: <1509945567-11801-1-git-send-email-me@tobin.cc>
 <CA+55aFzPeCuvjscBNj6ANzfRUDsjT6Ntn9Grr915CrSpOfNSnA@mail.gmail.com>
 <CAGXu5j+o6cf0PrnxD+W+09F7UY6JL+h7Bn5_4T2C0Z_fTZAx-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+o6cf0PrnxD+W+09F7UY6JL+h7Bn5_4T2C0Z_fTZAx-w@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3] scripts: add leaking_addresses.pl
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Joe Perches <joe@perches.com>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 07, 2017 at 01:22:13PM -0800, Kees Cook wrote:
> On Mon, Nov 6, 2017 at 9:27 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
[snip]
> And for my kernels, I needed to exclude usbmon or the script would
> hang (perhaps add a read timeout to the script to detect stalling
> files?)

Bother. I submitted the patch set without adding this suggestion. Even
after apologizing for missing it.

Better context switching required.

thanks,
Tobin.
