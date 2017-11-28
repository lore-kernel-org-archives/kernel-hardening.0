MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CA+55aFyK2-1JAotJuoxRo3me5OPXCzrrs3isOprhZnq-omNTjg@mail.gmail.com>
References: <1511826058-2563-1-git-send-email-me@tobin.cc> <CA+55aFyO6sKuE16z6hgocRA8Azd6E7sO4CO=AogxF1m6vaTh4A@mail.gmail.com>
 <CA+55aFzDh7GpkKniTgQp29-6TObR8NpOKczbAW-85qux=ek0Tw@mail.gmail.com>
 <874lpelxzh.fsf@xmission.com> <CA+55aFx+bMOT-DDp3EYuio0aJDGzWa3PzQxVbM3Rz+GdZKaaFQ@mail.gmail.com>
 <1511890919.19952.42.camel@perches.com> <CA+55aFyK2-1JAotJuoxRo3me5OPXCzrrs3isOprhZnq-omNTjg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Nov 2017 10:11:07 -0800
Message-ID: <CA+55aFz-7FAcZtkoxs97nAfyxfaOdtp1JUjmaF_ksx5uKqefJA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 0/5] add printk specifier %px, unique identifier
To: Joe Perches <joe@perches.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 28, 2017 at 10:04 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> If we really get failures, we can do that.

Anyway, it's pushed out now so people can test whatever workflows they have.

As mentioned, I doubt anybody cares. That file is already conditional
on CONFIG_STACKTRACE, and while that may be something that all distros
do enable, I know that I have run without it and never even realized.

So it's not just that the numbers are different widths on different
architectures (including the "running 32-bit user space x86 on a
64-bit kernel" case), the whole file isn't even always there, and I
can't say that I've ever heard of problems with /proc/<pid>/stack.

So this file almost certainly doesn't matter to begin with, and with
KASLR (which everybody should have anyway) the numerical values are
useless to anybody except for some attacker that wants to get the
kaslr offset.

We've had kasrl for a long time, this is just a (small) part of
actually making it halfway relevant.

               Linus
