Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sun, 28 Jan 2018 20:21:28 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20180128192128.x5pb3bzjn3znxdyn@gmail.com>
References: <cover.1517164461.git.luto@kernel.org>
 <4dd5a4d0f6b694f17eaf64c80c36a2560993b9ea.1517164461.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dd5a4d0f6b694f17eaf64c80c36a2560993b9ea.1517164461.git.luto@kernel.org>
Subject: [kernel-hardening] Re: [PATCH 3/3] syscalls: Add a bit of documentation to
 __SYSCALL_DEFINE
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>


* Andy Lutomirski <luto@kernel.org> wrote:

> __SYSCALL_DEFINE is rather magical.  Add a bit of documentation.
> 
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  include/linux/syscalls.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index a78186d826d7..d3f244a447c5 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -207,6 +207,16 @@ static inline int is_syscall_trace_event(struct trace_event_call *tp_event)
>  	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
>  
>  #define __PROTECT(...) asmlinkage_protect(__VA_ARGS__)
> +
> +/*
> + * For a syscall like long foo(void *a, long long b), this defines:
> + *
> + * static inline long SYSC_foo(void *a, long long b): the actual code
> + *
> + * asmlinkage long SyS_foo(long a, long long b): wrapper that calls SYSC_foo
> + *
> + * asmlinkage long sys_foo(void *a, long long b): alias of SyS_foo
> + */

Nit, would it be more readable to write this as pseudo-code, i.e. something like:

/*
 * For a syscall like long foo(void *a, long long b), this defines:
 *
 *  static inline long SYSC_foo(void *a, long long b) { /* the actual code following */ }
 *
 *  asmlinkage long SyS_foo(long a, long long b) { /* wrapper that calls SYSC_foo() */ }
 *  asmlinkage long sys_foo(void *a, long long b); /* as GCC alias of SyS_foo() */
 */

Also, I wanted to suggest to also document that in practice the three methods map 
to the very same function in the end, with the SYSC_ variant being eliminated due 
to inlining - but when double checking an x86-64 defconfig that does not appear to 
be so for all system calls:

 triton:~/tip> grep accept4 System.map 
 ffffffff8170d710 t SYSC_accept4
 ffffffff8170f940 T SyS_accept4
 ffffffff8170f940 T sys_accept4

While for others there's just 2:

 triton:~/tip> grep sched_getattr System.map 
 ffffffff8107b9a0 T SyS_sched_getattr
 ffffffff8107b9a0 T sys_sched_getattr

The only difference appears to be that accept4() is called internally within the 
kernel, by socketcall:

 SYSCALL_DEFINE3(accept, int, fd, struct sockaddr __user *, upeer_sockaddr,
                 int __user *, upeer_addrlen)
 {
         return sys_accept4(fd, upeer_sockaddr, upeer_addrlen, 0);
 }

But why does that result in SYSC_accept4() being a different symbol?

The difference between the two appears to be rather dumb as well:

 ffffffff8170f940 <SyS_accept4>:
 ffffffff8170f940:       e9 cb dd ff ff          jmpq   ffffffff8170d710 <SYSC_accept4>

Using GCC 7.2.0.

What am I missing?

Thanks,

	Ingo
