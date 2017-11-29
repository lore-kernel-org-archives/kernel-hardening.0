Date: Wed, 29 Nov 2017 15:20:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20171129152040.ed5b28c198093de8968aac9b@linux-foundation.org>
In-Reply-To: <1511921105-3647-1-git-send-email-me@tobin.cc>
References: <1511921105-3647-1-git-send-email-me@tobin.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH V11 0/5] hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 29 Nov 2017 13:05:00 +1100 "Tobin C. Harding" <me@tobin.cc> wrote:

> Currently there exist approximately 14 000 places in the Kernel where
> addresses are being printed using an unadorned %p. This potentially
> leaks sensitive information regarding the Kernel layout in memory. Many
> of these calls are stale, instead of fixing every call lets hash the
> address by default before printing. This will of course break some
> users, forcing code printing needed addresses to be updated. We can add
> a printk specifier for this purpose (%px) to give developers a clear
> upgrade path for breakages caused by applying this patch set.
> 
> The added advantage of hashing %p is that security is now opt-out, if
> you _really_ want the address you have to work a little harder and use
> %px.
> 
> The idea for creating the printk specifier %px to print the actual
> address was suggested by Kees Cook (see below for email threads by
> subject).

Maybe I'm being thick, but...  if we're rendering these addresses
unusable by hashing them, why not just print something like
"<obscured>" in their place?  That loses the uniqueness thing but I
wonder how valuable that is in practice?
