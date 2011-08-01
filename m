Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 1 Aug 2011 22:34:01 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110801183401.GA27647@albatros>
References: <20110801180151.GA26686@albatros>
 <20110801112021.25ec9041.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110801112021.25ec9041.akpm@linux-foundation.org>
Subject: Re: [kernel-hardening] Re: initcall dependency problem (ns vs.
 threads)
To: kernel-hardening@lists.openwall.com
Cc: Ingo Molnar <mingo@elte.hu>, "Paul E. McKenney" <paul.mckenney@linaro.org>, Manuel Lauss <manuel.lauss@googlemail.com>, linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>, torvalds@linux-foundation.org, Marc Zyngier <maz@misterjones.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 01, 2011 at 11:20 -0700, Andrew Morton wrote:
> There's not really enough detail here for me to suggest a fix without
> actually doing some work.  Which ipc initialization function is being
> called to late?

The call sequence is:

static int __init ipc_init(void)
{
    ...
	shm_init();
    ...
}
__initcall(ipc_init);

void __init shm_init (void)
{
	shm_init_ns(&init_ipc_ns);
    ...

void shm_init_ns(struct ipc_namespace *ns)
{
    ...
	ipc_init_ids(&shm_ids(ns));

void ipc_init_ids(struct ipc_ids *ids)
{
	init_rwsem(&ids->rw_mutex);
    ...


The code triggering the oops (called from do_exit()):

void exit_shm(struct task_struct *task)
{
    ...
	down_write(&shm_ids(ns).rw_mutex);

>  Which thread is using which data structures before
> which initialization function has been run?

Actually, it doesn't matter.  If ANY thread exits before init_rwsem()
then exit_shm() would use uninitialized shm_ids(ns).rw_mutex.


> Are we talking about init_ipc_ns.ids[] here?  If so, did you try
> initializing the three rwsems at compile-time?

No, good idea.  I'll do it.

IMO moving specific initializer is bad by design.  There should be a
guarantee what resources are accessible on what boot stage.  I suppose
it should be: all thread related information (including ns data) is
accessible for the moment of threads' code execution.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
