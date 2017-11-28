From: ebiederm@xmission.com (Eric W. Biederman)
References: <1511826058-2563-1-git-send-email-me@tobin.cc>
	<CA+55aFyO6sKuE16z6hgocRA8Azd6E7sO4CO=AogxF1m6vaTh4A@mail.gmail.com>
	<CA+55aFzDh7GpkKniTgQp29-6TObR8NpOKczbAW-85qux=ek0Tw@mail.gmail.com>
Date: Tue, 28 Nov 2017 00:26:58 -0600
In-Reply-To: <CA+55aFzDh7GpkKniTgQp29-6TObR8NpOKczbAW-85qux=ek0Tw@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 27 Nov 2017 17:09:10 -0800")
Message-ID: <874lpelxzh.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH 0/5] add printk specifier %px, unique identifier
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, Nov 27, 2017 at 4:03 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> So the big remaining ones for me are the /proc/<pid>/stack (stack
>> pointers) and the /proc/net/* ones.
>>
>> I'm a bit disappointed that those haven't been fixed already and
>> aren't even in this series..
>
> Oh well, I just did /proc/<pid>/stack by making it just print 0
> unconditionally rather than the hex number.

Patch?

I know I have used /proc/<pid>/stack manually many times when looking
at a system where something is hung/weird and I needed to see what is
going on.  The backtrace inside the kernel can be invaluable.

At the same time I don't know if we actually need the hex address.
But please don't break that interface it is very useful.


Eric
