MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <1511890919.19952.42.camel@perches.com>
References: <1511826058-2563-1-git-send-email-me@tobin.cc> <CA+55aFyO6sKuE16z6hgocRA8Azd6E7sO4CO=AogxF1m6vaTh4A@mail.gmail.com>
 <CA+55aFzDh7GpkKniTgQp29-6TObR8NpOKczbAW-85qux=ek0Tw@mail.gmail.com>
 <874lpelxzh.fsf@xmission.com> <CA+55aFx+bMOT-DDp3EYuio0aJDGzWa3PzQxVbM3Rz+GdZKaaFQ@mail.gmail.com>
 <1511890919.19952.42.camel@perches.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Nov 2017 10:04:42 -0800
Message-ID: <CA+55aFyK2-1JAotJuoxRo3me5OPXCzrrs3isOprhZnq-omNTjg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 0/5] add printk specifier %px, unique identifier
To: Joe Perches <joe@perches.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 28, 2017 at 9:41 AM, Joe Perches <joe@perches.com> wrote:
>
> Perhaps if there are really tools that parse this
> the [<leading-0-width>] should be kept the same too.

If we really get failures, we can do that.

But since the width is already different on 32-bit and 64-bit, I
seriously doubt there are any tools that would care about the width.
They'd already be horribly broken.

So let's not waste space with pointless zeroes unless somebody finds a
case where it matters.

            Linus
