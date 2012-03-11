Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 11 Mar 2012 12:24:31 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20120311082431.GA26640@openwall.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org> <1331421919-15499-2-git-send-email-tixxdz@opendz.org> <CA+55aFzTXuvpqjDUtjN48cc3RWADryddVXxc2RQhj6sCK=V9ag@mail.gmail.com> <CA+55aFy-ktC3NG5Wc+vhWB+18aqj9a0VLUSKQg+KR=FsVqfoJQ@mail.gmail.com> <CA+55aFz6Ben=b_jKXTneUm7-ULP_Z8J5uua+=CA+kXjVpSSVjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz6Ben=b_jKXTneUm7-ULP_Z8J5uua+=CA+kXjVpSSVjg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 1/9] exec: add a global execve counter
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Djalal Harouni <tixxdz@opendz.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 10, 2012 at 04:58:01PM -0800, Linus Torvalds wrote:
> On Sat, Mar 10, 2012 at 4:36 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I wonder if the number part of exec_id would even have to be 64-bit. I
> > think I can do about 10000 execves per second if I make the program a
> > small static one - and that's on a fast CPU. And it's a per-thread
> > counter, so you can't scale it with lots of CPU's. So it would take
> > something like four days to wrap. Hmm..
> 
> Actually, using a pure counter is horrible, because even if it takes
> four days to wrap, it *will* wrap, and the attacker can just count his
> own execve's.

Four days (for a 32-bit counter) is just not enough, so the counter
needs to be e.g. 64-bit as proposed.  A 64-bit counter won't wrap during
lifetime of a system.

> If, instead, you were to use a counter that counts *independently* of
> execve's, you're much better off.
> 
> And if you use one that is free - because the CPU implements it
> natively - you're even better off.
> 
> IOW, why is the exec-id just the time stamp counter

The CPUs' timestamp counters were not designed for security.  I would
not be too surprised if some implementation of a CPU architecture (maybe
emulated, maybe under a hypervisor) has such timestamp counter
granularity that we may see the same value across a second execve().

Also, we'd need extra code for archs/CPUs that lack timestamp counters.

> (on any random cpu - we really don't care)?

I'd rather not rely on the timestamp counters across CPUs being in sync,
and if they are not in sync then we may see the same value again (on one
CPU vs. another).  So at least we'd need to record the CPU number as well.

> That should be safe even in just 32 bits
> exactly because it's not under the control of the user.

32 bits is just not enough even if not under control of an attacker.
If there's some low chance of hitting the same counter value on execve()
vs. procfs file access and there's no lockout on multiple counter
mismatches, an attacker may simply try that in a loop, and with 32-bit
values might have a good chance of succeeding in a reasonable amount of
time (such as a few days).

Alexander
