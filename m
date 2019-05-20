MIME-Version: 1.0
References: <20190520164214.GA14656@himanshu-Vostro-3559>
In-Reply-To: <20190520164214.GA14656@himanshu-Vostro-3559>
From: Jann Horn <jannh@google.com>
Date: Mon, 20 May 2019 21:01:26 +0200
Message-ID: <CAG48ez2+NoQ4mtm=PCyz005O4Efmszxo3Z7wgaF_5xx1nYO8dQ@mail.gmail.com>
Subject: Re: Sparse context checking Vs Clang Thread Safety analysis
Content-Type: text/plain; charset="UTF-8"
To: Himanshu Jha <himanshujha199640@gmail.com>
Cc: linux-sparse@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>, Philipp Reisner <philipp.reisner@linbit.com>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, clang-built-linux <clang-built-linux@googlegroups.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

+kernel-hardening

On Mon, May 20, 2019 at 6:42 PM Himanshu Jha
<himanshujha199640@gmail.com> wrote:
> I'm an undergrad student working on Google Summer of Code'19 Project[1]
> to apply clang thread safety analysis feature on linux kernel to find bugs
> related to concurrency/race condtions with Lukas & clangbuiltlinux
> community.
>
> Since sparse has similar context checking feature, I started
> investigating by looking the source and some other resources such as
> LWN[2] about the internals.
>
> `-Wcontext` is my prime focus for now and currently we have:
>
> himanshu@himanshu-Vostro-3559:~/linux-next$ make C=2 CF="-Wcontext" 2>&1 >/dev/null | grep -w 'context' | wc -l
> 772
>
> o Why do we have so many open warnings for context imbalance ? Or
>   Why did we stop at some point annotating the codebase ?

Many developers don't use sparse, and sparse doesn't support some
locking patterns that the kernel uses.

> o Does sparse stores some sort of context counter since we didn't get
> any warnings for `bad_difflocks` which locks 'lock1' and unlocks 'lock2'
> ?

Yes. Sparse currently ignores the context and only has a simple
counter shared by all locks.

> o What exactly the usage of `__acquire/__release` ?
> I have used it to shut up the warning for lockfn & unlockfn above.

You use those to inform sparse where you're taking a lock or releasing
a lock; and some parts of the kernel also use it to inform sparse of
places where a lock is effectively taken, even though there is no
actual locking call (e.g. when two pointers point to the same object,
and therefore you only need to actually call the locking function once
instead of twice).

[...]
> So, clang thread safety analysis[3] follows a different mechanism
> to overcome what we have observed above.
>
> I did small analysis on a C program[4] and a device driver[5].
>
> Clang analysis has many annotations available to suitable annotate the
> codebase which can be found in the documentation[3].
>
> Quite surprisingly, Philipp proposed[6] `__protected_by` feature which is
> very similar to `guarded_by`[7] feature implemented in Clang.
>
> Similarly, Johannes proposed[8] the same with a different implementation.
>
> Questions from both you:
>
> o Why was it not deployed in sparse ?
>
> o Does the lock protecting the data should be a global variable ?
>
> ie.,
>
> struct foo {
>         struct mutex lock;
>         int balance __protected_by(lock);
> }
>
> Can this be done ? Or lock should be global ?
>
> Because clang analysis wants it to be global!
>
> There are other attribute restrictions as well for clang analysis:
> https://github.com/llvm-mirror/clang/blob/master/test/Sema/attr-capabilities.c
>
>
> *Most Important*
> Could you please point me some critical data examples that you know in
> the kernel source which should be protected. This would help us a lot!

The complicated thing in the kernel is that almost any structure
member can be accessed without locking under some circumstances - for
example, when a structure is initialized, or when the structure is
being freed and all other references to the object have gone away. On
top of that, many fields can be accessed under multiple locking
mechanisms - e.g. many fields can be read under either a
spinlock/mutex or in an RCU read-critical section. And there are
functions that conditionally acquire a lock and signal the state of
the lock through their return value - for example,
mutex_lock_killable() and mutex_lock_interruptible().

I think that static analysis of locking is a great thing, but the
kernel doesn't exactly make it easy. In particular, I think it is
going to require annotations that you can use to tell the compiler
which state of its lifecycle an object is in (since that can influence
locking rules), and annotations that tell the compiler what the
semantics of functions like mutex_lock_killable() are.
