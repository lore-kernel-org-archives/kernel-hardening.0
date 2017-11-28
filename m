MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CA+55aFyO6sKuE16z6hgocRA8Azd6E7sO4CO=AogxF1m6vaTh4A@mail.gmail.com>
References: <1511826058-2563-1-git-send-email-me@tobin.cc> <CA+55aFyO6sKuE16z6hgocRA8Azd6E7sO4CO=AogxF1m6vaTh4A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Nov 2017 17:09:10 -0800
Message-ID: <CA+55aFzDh7GpkKniTgQp29-6TObR8NpOKczbAW-85qux=ek0Tw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 0/5] add printk specifier %px, unique identifier
To: "Tobin C. Harding" <me@tobin.cc>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 27, 2017 at 4:03 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So the big remaining ones for me are the /proc/<pid>/stack (stack
> pointers) and the /proc/net/* ones.
>
> I'm a bit disappointed that those haven't been fixed already and
> aren't even in this series..

Oh well, I just did /proc/<pid>/stack by making it just print 0
unconditionally rather than the hex number.

Looking around, not even proc-ps actually uses that file, and it's
conditional on PROC_STACKTRACE anyway. And can't recall ever having
seen a report of something breaking due to CONFIG_STACKTRACE not being
enabled, so I suspect nothing really uses /proc/<pid>/stack at all.

But rather than removing it, making it report 0 seemed the smaller change.

I'd be inclined to do the same for /proc/*/net/* too, but I would
actually expect that there are tools that cross-reference the sockets
by socket address (ie "fuser" and similar tools). So I'd like to have
that hashing for that.

Although maybe I'm wrong, and they simply use the socket number, and
the socket address could just be scrubbed entirely.

                  Linus
