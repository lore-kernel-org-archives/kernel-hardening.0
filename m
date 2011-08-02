Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 2 Aug 2011 13:55:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20110802135512.b49c9de1.akpm@linux-foundation.org>
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

erm, wait.  There's no reason I can think of why a kernel thread needs
to call shm_exit() at all?

Is that a regular kernel thread exiting, or is it a
call_usermodehelper() worker thread?  It *looks* like
____call_usermodehelper()'s kernel_execve() failed, so
____call_usermodehelper() directly called do_exit().

Something's still screwed up here - we shouldn't be trying to run
usermode helper applications before shm_init() has been run - usermode
helpers can use ipc!

Can someone who can reproduce this please work out if and why we're
calling call_usermodehelper() under do_pre_smp_initcalls()?  Something
like this...

--- a/init/main.c~a
+++ a/init/main.c
@@ -722,12 +722,16 @@ static void __init do_basic_setup(void)
 	do_initcalls();
 }
 
+int in_do_pre_smp_initcalls;
+
 static void __init do_pre_smp_initcalls(void)
 {
 	initcall_t *fn;
 
+	in_do_pre_smp_initcalls = 1;
 	for (fn = __initcall_start; fn < __early_initcall_end; fn++)
 		do_one_initcall(*fn);
+	in_do_pre_smp_initcalls = 0;
 }
 
 static void run_init_process(const char *init_filename)
--- a/kernel/kmod.c~a
+++ a/kernel/kmod.c
@@ -412,12 +412,17 @@ EXPORT_SYMBOL(call_usermodehelper_setfns
  * asynchronously if wait is not set, and runs as a child of keventd.
  * (ie. it runs with full root capabilities).
  */
+
+extern int in_do_pre_smp_initcalls;
+
 int call_usermodehelper_exec(struct subprocess_info *sub_info,
 			     enum umh_wait wait)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval = 0;
 
+	if (in_do_pre_smp_initcalls)
+		dump_stack();
 	helper_lock();
 	if (sub_info->path[0] == '\0')
 		goto out;
_
