Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 3 Aug 2011 12:33:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20110803123352.88670c9c.akpm@linux-foundation.org>
In-Reply-To: <CA+55aFx_FMg2Y0jMrzYUpAqgxWFjxnFzzrqvysoqrYyz+Ue6BQ@mail.gmail.com>
References: <20110801180151.GA26686@albatros>
	<20110801112021.25ec9041.akpm@linux-foundation.org>
	<20110801190341.GA6898@albatros>
	<CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com>
	<20110802124530.GA2543@albatros>
	<CA+55aFx_FMg2Y0jMrzYUpAqgxWFjxnFzzrqvysoqrYyz+Ue6BQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Manuel Lauss <manuel.lauss@googlemail.com>, linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>, Marc Zyngier <maz@misterjones.org>, Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paul.mckenney@linaro.org>, Kay Sievers <kay.sievers@vrfy.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2 Aug 2011 21:43:23 -1000
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Aug 2, 2011 at 2:45 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> >
> > From: Vasiliy Kulikov <segoon@openwall.com>
> > Subject: [PATCH] shm: fix a race between shm_exit() and shm_init()
> 
> This patch is disgusting.
> 

I think it's buggy too.

> 
> > +       /*
> > +        * For init_ipc_ns shm_ids().rw_mutex is statically initialized
> > +        * as kernel threads should be able to use it in do_exit() before
> > +        * shm_init(), which is called on do_initcall()
> > +        */
> > +       if (ns == &init_ipc_ns)
> > +                ipc_init_ids(&shm_ids(ns));
> > +       else
> > +               ipc_init_ids(&shm_ids(ns));

afacit init_ipc_ns.ids[0].rw_mutex and init_ipc_ns.ids[1].rw_mutex
never get initialised with this patch?


Still.  It seems that the real bug is that driver_init() is trying to
invoke userspace helpers before the kernel is ready to run userspace.

We could hack around it with something like

--- a/init/main.c~a
+++ a/init/main.c
@@ -108,6 +108,9 @@ bool early_boot_irqs_disabled __read_mos
 enum system_states system_state __read_mostly;
 EXPORT_SYMBOL(system_state);
 
+/* This gets set when the kernel is ready to execute usermode code */
+bool usermode_available = false;
+
 /*
  * Boot command-line arguments
  */
@@ -804,6 +807,8 @@ static int __init kernel_init(void * unu
 
 	do_basic_setup();
 
+	usermode_available = true;
+
 	/* Open the /dev/console on the rootfs, this should never fail */
 	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
 		printk(KERN_WARNING "Warning: unable to open an initial console.\n");
diff -puN include/linux/init.h~a include/linux/init.h
--- a/include/linux/init.h~a
+++ a/include/linux/init.h
@@ -149,6 +149,7 @@ extern int do_one_initcall(initcall_t fn
 extern char __initdata boot_command_line[];
 extern char *saved_command_line;
 extern unsigned int reset_devices;
+extern bool usermode_available;
 
 /* used by init/main.c */
 void setup_arch(char **);
diff -puN kernel/kmod.c~a kernel/kmod.c
--- a/kernel/kmod.c~a
+++ a/kernel/kmod.c
@@ -418,6 +418,9 @@ int call_usermodehelper_exec(struct subp
 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval = 0;
 
+	if (usermode_available == false)
+		return -EINVAL;
+
 	helper_lock();
 	if (sub_info->path[0] == '\0')
 		goto out;
_


(which I think deserves a big fat WARN_ON() when it triggers)

But it would be better to fix driver_init() for real.

Save us, Kay!
