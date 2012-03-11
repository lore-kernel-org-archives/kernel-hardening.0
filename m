Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 11 Mar 2012 13:40:39 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20120311094039.GB26640@openwall.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org> <1331421919-15499-2-git-send-email-tixxdz@opendz.org> <CA+55aFzTXuvpqjDUtjN48cc3RWADryddVXxc2RQhj6sCK=V9ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzTXuvpqjDUtjN48cc3RWADryddVXxc2RQhj6sCK=V9ag@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 1/9] exec: add a global execve counter
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Djalal Harouni <tixxdz@opendz.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 10, 2012 at 04:12:20PM -0800, Linus Torvalds wrote:
> On Sat, Mar 10, 2012 at 3:25 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> >
> > Given that consideration this patch introduces two counters:
> > A global atomic execve counter that will be incremented on every
> > do_execve_common() call, and an atomic exec_id member for the task_struct.
> 
> This seems horribly expensive on most 32-bit architectures, including
> very much x86-32. That atomic64_inc_return() is not cheap.  It's
> possible that it's basically an impossible operation to do atomically
> on certain platforms, causing it to use some random spinlock instead.

I think these are _relatively_ cheap considering that it's execve().
If we can do e.g. 10 million of atomic64_inc_return()'s per second (and
I think we can do a lot more, although I did not benchmark this), but
only 10000 of execve()'s per second, then the performance impact is 0.1%.
I admit that 0.1% is significant, but I used worst-case guesstimates
here; the actual number might be more like 0.01% (50 million vs. 5 thousand)
or even 0.002% (200 million vs. 4 thousand).  (200 million is 15 CPU
cycles at 3 GHz, which may be a reasonable optimistic estimate.
4 thousand is a realistic execve() speed for dynamically-linked programs.)

> I wonder if we couldn't make something much cheaper, since we don't
> actually care about it being globally incrementing, we just care about
> it being globally unique. IOW, it could easily be a 56-bit per-cpu
> counter along with the CPU number in the high bits or something like
> that. Avoiding the whole atomicity issue, and thus avoiding the main
> reason those things are really expensive.
> 
> IOW, something like
> 
>    cpu = get_cpu();
>    .. increment percpu 64-bit counter ..
>    id = counter * MAX_CPUS + cpu;
>    put_cpu(cpu);
> 
> or equivalent would seem to be a potentially much cheaper approach.

This makes sense to me.  We just need to ensure that the per-CPU counter
is still large enough that it won't wrap.  56 bits is enough
(considering that the attack has to run on a single CPU of the target
system, unlike e.g. an attack on a cipher with a 56-bit key could be),
but there's little room for reducing this further (such as to support
many more than 256 CPUs in a system).  So if we use this approach, maybe
we should simply keep a 64-bit per-CPU counter and a 32-bit CPU number,
for a 96-bit id.  This may even be faster on execve() (no need to
combine the two values into one).

I don't know which one of these approaches has lower overhead on current
systems.  My _guess_ is that atomic64_inc_return() may well be faster in
many cases.

Alexander
