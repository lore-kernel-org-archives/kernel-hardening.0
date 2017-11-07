MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20171107205820.GX18478@eros>
References: <1510050731-32446-1-git-send-email-me@tobin.cc>
 <063D6719AE5E284EB5DD2968C1650D6DD00B3BD1@AcuExch.aculab.com> <20171107205820.GX18478@eros>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 Nov 2017 13:11:00 -0800
Message-ID: <CA+55aFxWdKyqp5z2p40DVqS3wDfPFiX8W-HdGr2+tnoO02MmCw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v4] scripts: add leaking_addresses.pl
To: "Tobin C. Harding" <me@tobin.cc>
Cc: David Laight <David.Laight@aculab.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 7, 2017 at 12:58 PM, Tobin C. Harding <me@tobin.cc> wrote:
>
> Interesting idea. Isn't the same outcome already achieved with
> dmesg_restrict. I appreciate that this does beg the question 'why are we
> scanning dmesg then?'

dmesg_restrict is even more asinine than kptr_restrict.

It's a completely idiotic flag, only useful for distributions that
then also refuse to show system journals to regular users.

And such distributions are garbage, since that also effectively means
that users can't sanely make bug reports etc.

In other words, the whole 'dmesg_restrict' is the _classic_ case of
so-called "security" people who make bad decisions, and play security
theater.

This is exactly the kind of crap that the grsecurity people came up
with, and I'm sorry it was ever back-ported into the mainline kernel,
because it's f*cking retarded.

I often wish that security people used their brains more than they
actually seem to do.

Because a lot of them don't actually seem to ever look at the big
picture, and they do these kinds of security theater garbage patches
that don't actually help anything what-so-ever, but make people say
"that's good security".

And yes, the same would _very_ much be true of anything that just
hides the pointers from users when they read dmesg. It wouldn't be
sufficient to change the kernel, you also would have to change every
single program that implements system logging, and once you did that,
you'd have screwed up system debuggability.

So really, people - start thinking critically about security. That
VERY MUCH also means starting to thinking critically about things that
people _claim_ are a security feature.

               Linus
