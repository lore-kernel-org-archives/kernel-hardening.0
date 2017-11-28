Message-ID: <1511890919.19952.42.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Tue, 28 Nov 2017 09:41:59 -0800
In-Reply-To: <CA+55aFx+bMOT-DDp3EYuio0aJDGzWa3PzQxVbM3Rz+GdZKaaFQ@mail.gmail.com>
References: <1511826058-2563-1-git-send-email-me@tobin.cc>
	 <CA+55aFyO6sKuE16z6hgocRA8Azd6E7sO4CO=AogxF1m6vaTh4A@mail.gmail.com>
	 <CA+55aFzDh7GpkKniTgQp29-6TObR8NpOKczbAW-85qux=ek0Tw@mail.gmail.com>
	 <874lpelxzh.fsf@xmission.com>
	 <CA+55aFx+bMOT-DDp3EYuio0aJDGzWa3PzQxVbM3Rz+GdZKaaFQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 0/5] add printk specifier %px, unique identifier
To: Linus Torvalds <torvalds@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2017-11-28 at 09:33 -0800, Linus Torvalds wrote:
> On Mon, Nov 27, 2017 at 10:26 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
> > > 
> > > Oh well, I just did /proc/<pid>/stack by making it just print 0
> > > unconditionally rather than the hex number.
> > 
> > Patch?
> 
> Oh, apparently I never pushed out yesterday.
> 
> The patch literally just affects the (useless) hex number. So:
> 
>     cat /proc/self/stack
> 
> now prints out
> 
>     [<0>] proc_pid_stack+0xaa/0x100
>     [<0>] proc_single_show+0x48/0x80
>     [<0>] seq_read+0xd2/0x410

> I considered getting rid of the whole "[<>]" thing, but that's where
> "maybe there are tools that parse this" came in.
> 
> I doubt there are any, though. If proc-ps doesn't look at this, I
> don't know what could. But the format change might as well be a
> separate thing if somebody cares deeply.

Perhaps if there are really tools that parse this
the [<leading-0-width>] should be kept the same too.

> 
