Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CALCETrUuG0-tGNQ5iAEO2_gaK1eUq7AoALoBeQKcOP8cvxr=eA@mail.gmail.com>
References: <cover.1466466093.git.luto@kernel.org> <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
 <CALCETrUuG0-tGNQ5iAEO2_gaK1eUq7AoALoBeQKcOP8cvxr=eA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Jun 2016 23:02:21 -0700
Message-ID: <CA+55aFx480bxx7VAmFqdsVGHjoSav4eCvVpcx5ZSpBQuq+=1Mw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 22, 2016 at 6:22 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> I implemented a percpu cache, and it's useless.
>
> When a task goes away, one reference is held until the next RCU grace
> period so that task_struct can be used under RCU (look for
> delayed_put_task_struct).

Yeah, that RCU batching will screw the cache idea.

But isn't it only the "task_struct" that needs that? That's a separate
allocation from the stack, which contains the "thread_info".

I think that what we *could* do is re-use the tread-info within the
RCU grace period, as long as we delay freeing the task_struct.

Yes, yes, we currently tie the task_struct and thread_info lifetimes
together very tightly, but that's a historical thing rather than a
requirement. We do the

        account_kernel_stack(tsk->stack, -1);
        arch_release_thread_info(tsk->stack);
        free_thread_info(tsk->stack);

in free_task(), but I could imagine doing it earlier, and
independently of the RCU-delayed free.

In fact, I think we just do that at exit() time synchronously. The
reference counting of the task_struct() is because a lot of other
threads can have references to the exiting thread (and we have the
tasklist and thread lists that are RCU-traversed), but none of those
other references should ever look at the stack. Or even the
thread-info.

Hmm. I bet it would show some problems, but not be technically
impossible. Especially if we make the thread-info rules be like the
SLAB_DESTROY_BY_RCU semantics - the allocation may be re-used during
the RCU grace period, but it is going to still exists and be of the
same type.

This sounds very much like something for Oleg Nesterov.

Oleg, what do you think? Would it be reasonable to free the stack and
thread_info synchronously at exit time, clear the pointer (to catch
any odd use), and only RCU-delay the task_struct itself?

That is, after all, what we already do with the VM, semaphores, files,
fs info etc. There's no real reason I see to keep the stack around.

(Obviously, we can't release it in do_exit() itself like we do some of
the other state - it would need to be released after we've scheduled
away to another process' stack, but we already have that TASK_DEAD
handling in finish_task_switch for this exact reason).

                 Linus
