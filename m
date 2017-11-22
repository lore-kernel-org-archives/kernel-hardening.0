From: zerons <zeronsaxm@gmail.com>
Message-ID: <be5b9100-4f60-1a10-6b32-b425cb2db05e@gmail.com>
Date: Wed, 22 Nov 2017 22:33:31 +0800
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------E9219F000EA79A6AFCAFC68F"
Subject: [kernel-hardening] a part of SLAB_FREELIST_HARDENED feature doesn't
 work well
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is a multi-part message in MIME format.
--------------E9219F000EA79A6AFCAFC68F
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

(commit-webpage)[https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ce6fa91b93630396ca220c33dd38ffc62686d499]

Test it on kernel 4.14.0.

When something goes like
kfree(a);
kfree(a);
then `insmod` crashed 'Segment Fault'

kfree(a);kfree(b);kfree(a);
Got nothing.

I add another kernel thread, just free some objects
very close to the target object_a;
kfree(a);
		another thread does some kfree(...)
kfree(a);
nothing happened, this patch didn't crash the `insmod` operation.

--------------E9219F000EA79A6AFCAFC68F
Content-Type: text/x-csrc;
 name="test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="test.c"

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/types.h>
#include <linux/fs.h>
#include <linux/slab.h>
#include <linux/debugfs.h>
#include <linux/kallsyms.h>
#include <linux/sched.h>
#include <linux/kthread.h>
#include <linux/err.h>
#include <linux/delay.h>
#include <asm/insn.h>

#define COUNT 0x20
char *p[COUNT];
struct task_struct *tsk;

int another_thread(void *arg)
{
	int i = 0;
	for (i = 0; i < COUNT-2; i+=2) {
		pr_info("kfree i: %d, %p\n", i, p[i]);
		kfree(p[i]);
	}
	msleep(10);
	kfree(p[COUNT-2]);
	return 0;
}

static int __init test_init(void)
{
	int i = 0;
	for (i = 0; i < COUNT-1; i++)
		p[i] = kmalloc(4096, GFP_KERNEL);
	p[COUNT-1] = p[COUNT-3];

	tsk = kthread_run(another_thread, NULL, "another_thread");
	if (IS_ERR(tsk))
		pr_info("kthread_run err\n");

	for (i = 1; i < COUNT-1; i+=2) {
		pr_info("kfree i: %d, %p\n", i, p[i]);
		kfree(p[i]);
	}

	msleep(100);
	kfree(p[COUNT-1]);

	return 0;
}

static void __exit test_exit(void)
{
	if (!IS_ERR(tsk))
		kthread_stop(tsk);
	return;
}

module_init(test_init);
module_exit(test_exit);
MODULE_LICENSE("GPL");

--------------E9219F000EA79A6AFCAFC68F--
