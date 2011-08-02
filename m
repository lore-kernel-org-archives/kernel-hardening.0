Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 2 Aug 2011 13:33:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20110802133356.79e80b91.akpm@linux-foundation.org>
In-Reply-To: <20110802124530.GA2543@albatros>
References: <20110801180151.GA26686@albatros>
	<20110801112021.25ec9041.akpm@linux-foundation.org>
	<20110801190341.GA6898@albatros>
	<CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com>
	<20110802124530.GA2543@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Manuel Lauss <manuel.lauss@googlemail.com>, linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>, Marc Zyngier <maz@misterjones.org>, Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paul.mckenney@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2 Aug 2011 16:45:30 +0400
Vasiliy Kulikov <segoon@openwall.com> wrote:

> On thread exit shm_exit() is called, it uses shm_ids(ns).rw_mutex.

You meant shm_exit_ns().

> It is initialized in shm_init(), but it is not called yet at the moment
> of kernel threads exit.  Some kernel threads are created in
> do_pre_smp_initcalls(), and shm_init() is called in do_initcalls().
> 
> Static initialization of shm_ids(init_ipc_ns).rw_mutex fixes the race.
> 
> It fixes a kernel oops:
> 
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
> ...
> [<c0320090>] (__down_write_nested+0x88/0xe0) from [<c015da08>] (exit_shm+0x28/0x48)
> [<c015da08>] (exit_shm+0x28/0x48) from [<c002e550>] (do_exit+0x59c/0x750)
> [<c002e550>] (do_exit+0x59c/0x750) from [<c003eaac>] (____call_usermodehelper+0x13c/0x154)
> [<c003eaac>] (____call_usermodehelper+0x13c/0x154) from [<c000f630>] (kernel_thread_exit+0x0/0x8)
> Code: 1afffffa e597c00c e58d0000 e587d00c (e58cd000)
> 
> ...
>
> --- a/ipc/msgutil.c
> +++ b/ipc/msgutil.c
> @@ -20,6 +20,9 @@
>  
>  DEFINE_SPINLOCK(mq_lock);
>  
> +#define INIT_IPC_SHM_IDS(name) \
> +	{ .rw_mutex = __RWSEM_INITIALIZER(name.rw_mutex), }
> +
>  /*
>   * The next 2 defines are here bc this is the only file
>   * compiled when either CONFIG_SYSVIPC and CONFIG_POSIX_MQUEUE
> @@ -27,6 +30,9 @@ DEFINE_SPINLOCK(mq_lock);
>   */
>  struct ipc_namespace init_ipc_ns = {
>  	.count		= ATOMIC_INIT(1),
> +	.ids	= {
> +		[IPC_SHM_IDS] = INIT_IPC_SHM_IDS(init_ipc_ns.ids[IPC_SHM_IDS]),
> +	},

That's what I meant by "nasty".  We initialise one field because we
happen to use that one at the wrong time, and leave everything else
uninitialised. eww.

But in this case it's not as bad as it might be -
shm_exit_ns()->free_ipcs() is a no-op because ids[2].inuse is zero, so
we kinda _did_ initialise that.  otoh we left ids[0].rw_mutex and
ids[1].rw_mutex uninitialised, so it's still nasty ;)

We could perhaps have fixed the bug by testing ids->inuse before taking
the mutex, which would also have been a speedup for that function. 
That would need some thought.
