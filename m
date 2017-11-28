MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <1511826058-2563-1-git-send-email-me@tobin.cc>
References: <1511826058-2563-1-git-send-email-me@tobin.cc>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Nov 2017 16:03:56 -0800
Message-ID: <CA+55aFyO6sKuE16z6hgocRA8Azd6E7sO4CO=AogxF1m6vaTh4A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 0/5] add printk specifier %px, unique identifier
To: "Tobin C. Harding" <me@tobin.cc>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 27, 2017 at 3:40 PM, Tobin C. Harding <me@tobin.cc> wrote:
> Finally, with this patch set in place, we have the added benefit that
> newbies (me) can quietly go around the kernel 'sweeping up' after
> leaking addresses. This as apposed to using a hammer and hashing all
> %p. And if this is deemed too little and too slow we can always search
> and replace '%p' with '%px'.

So the big remaining ones for me are the /proc/<pid>/stack (stack
pointers) and the /proc/net/* ones.

I'm a bit disappointed that those haven't been fixed already and
aren't even in this series..

Since I was the proponent of the whole "leaking_addresses" script
model, I guess I can't complain when %p isn't then just made to hash
everything, but it does feel like this has been dragging out a bit..

            Linus
