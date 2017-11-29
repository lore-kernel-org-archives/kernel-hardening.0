MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5j+xUt+coLCKg9qeCrTzc7HEM7KP=1Z-xTiDXWSRYibJQg@mail.gmail.com>
References: <1511921105-3647-1-git-send-email-me@tobin.cc> <1511921105-3647-5-git-send-email-me@tobin.cc>
 <CA+55aFxgGb13hqoNQ8bzFn4ENZM25PBSdi5pkFUBa5Hk+j-s3Q@mail.gmail.com>
 <324abe19f1ee4177911d2fc48899ac8a@AcuMS.aculab.com> <CAGXu5j+xUt+coLCKg9qeCrTzc7HEM7KP=1Z-xTiDXWSRYibJQg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Nov 2017 14:47:01 -0800
Message-ID: <CA+55aFxmHiXJzaPyBgCMhrka88TMMedUdpK0huste3o90wL0Tw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH V11 4/5] vsprintf: add printk specifier %px
To: Kees Cook <keescook@chromium.org>
Cc: David Laight <David.Laight@aculab.com>, "Tobin C. Harding" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?Q?Radim_Krcm=C3=A1r?= <rkrcmar@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 29, 2017 at 2:28 PM, Kees Cook <keescook@chromium.org> wrote:
>
> In the future, maybe we could have a knob: unhashed, hashed (default),
> or zeroed.

I haven't actually seen a case for that yet.

Let's see if there are actually any debug issues at all, and how big
they are before worrying about it.

                   Linus
