Date: Thu, 9 Feb 2017 15:28:01 +0800
From: kbuild test robot <lkp@intel.com>
Message-ID: <201702091559.1b1GyiFU%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <1486613040-30555-1-git-send-email-hoeun.ryu@gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 1/2] fork: free vmapped stacks in cache when cpus are
 offline
To: Hoeun Ryu <hoeun.ryu@gmail.com>
Cc: kbuild-all@01.org, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Hoeun,

[auto build test ERROR on next-20170208]
[also build test ERROR on v4.10-rc7]
[cannot apply to linus/master linux/master v4.9-rc8 v4.9-rc7 v4.9-rc6]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Hoeun-Ryu/fork-free-vmapped-stacks-in-cache-when-cpus-are-offline/20170209-124143
config: parisc-c3000_defconfig (attached as .config)
compiler: hppa-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=parisc 

All error/warnings (new ones prefixed by >>):

   kernel/fork.c: In function 'free_vm_stack_cache':
>> kernel/fork.c:177:18: error: 'NR_CACHED_STACKS' undeclared (first use in this function)
     for (i = 0; i < NR_CACHED_STACKS; i++) {
                     ^~~~~~~~~~~~~~~~
   kernel/fork.c:177:18: note: each undeclared identifier is reported only once for each function it appears in
   In file included from include/asm-generic/percpu.h:6:0,
                    from ./arch/parisc/include/generated/asm/percpu.h:1,
                    from arch/parisc/include/asm/processor.h:19,
                    from arch/parisc/include/asm/thread_info.h:7,
                    from include/linux/thread_info.h:25,
                    from include/asm-generic/preempt.h:4,
                    from ./arch/parisc/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:59,
                    from include/linux/spinlock.h:50,
                    from include/linux/mmzone.h:7,
                    from include/linux/gfp.h:5,
                    from include/linux/slab.h:14,
                    from kernel/fork.c:14:
>> kernel/fork.c:178:46: error: 'cached_stacks' undeclared (first use in this function)
      struct vm_struct *vm_stack = this_cpu_read(cached_stacks[i]);
                                                 ^
   include/linux/percpu-defs.h:305:9: note: in definition of macro '__pcpu_size_call_return'
     typeof(variable) pscr_ret__;     \
            ^~~~~~~~
>> kernel/fork.c:178:32: note: in expansion of macro 'this_cpu_read'
      struct vm_struct *vm_stack = this_cpu_read(cached_stacks[i]);
                                   ^~~~~~~~~~~~~
>> include/linux/percpu-defs.h:304:1: warning: initialization makes pointer from integer without a cast [-Wint-conversion]
    ({         \
    ^
   include/linux/percpu-defs.h:494:29: note: in expansion of macro '__pcpu_size_call_return'
    #define this_cpu_read(pcp)  __pcpu_size_call_return(this_cpu_read_, pcp)
                                ^~~~~~~~~~~~~~~~~~~~~~~
>> kernel/fork.c:178:32: note: in expansion of macro 'this_cpu_read'
      struct vm_struct *vm_stack = this_cpu_read(cached_stacks[i]);
                                   ^~~~~~~~~~~~~
   At top level:
   kernel/fork.c:173:12: warning: 'free_vm_stack_cache' defined but not used [-Wunused-function]
    static int free_vm_stack_cache(unsigned int cpu)
               ^~~~~~~~~~~~~~~~~~~

vim +/NR_CACHED_STACKS +177 kernel/fork.c

     8	 *  'fork.c' contains the help-routines for the 'fork' system call
     9	 * (see also entry.S and others).
    10	 * Fork is rather simple, once you get the hang of it, but the memory
    11	 * management can be a bitch. See 'mm/memory.c': 'copy_page_range()'
    12	 */
    13	
  > 14	#include <linux/slab.h>
    15	#include <linux/init.h>
    16	#include <linux/unistd.h>
    17	#include <linux/module.h>
    18	#include <linux/vmalloc.h>
    19	#include <linux/completion.h>
    20	#include <linux/personality.h>
    21	#include <linux/mempolicy.h>
    22	#include <linux/sem.h>
    23	#include <linux/file.h>
    24	#include <linux/fdtable.h>
    25	#include <linux/iocontext.h>
    26	#include <linux/key.h>
    27	#include <linux/binfmts.h>
    28	#include <linux/mman.h>
    29	#include <linux/mmu_notifier.h>
    30	#include <linux/fs.h>
    31	#include <linux/mm.h>
    32	#include <linux/vmacache.h>
    33	#include <linux/nsproxy.h>
    34	#include <linux/capability.h>
    35	#include <linux/cpu.h>
    36	#include <linux/cgroup.h>
    37	#include <linux/security.h>
    38	#include <linux/hugetlb.h>
    39	#include <linux/seccomp.h>
    40	#include <linux/swap.h>
    41	#include <linux/syscalls.h>
    42	#include <linux/jiffies.h>
    43	#include <linux/futex.h>
    44	#include <linux/compat.h>
    45	#include <linux/kthread.h>
    46	#include <linux/task_io_accounting_ops.h>
    47	#include <linux/rcupdate.h>
    48	#include <linux/ptrace.h>
    49	#include <linux/mount.h>
    50	#include <linux/audit.h>
    51	#include <linux/memcontrol.h>
    52	#include <linux/ftrace.h>
    53	#include <linux/proc_fs.h>
    54	#include <linux/profile.h>
    55	#include <linux/rmap.h>
    56	#include <linux/ksm.h>
    57	#include <linux/acct.h>
    58	#include <linux/userfaultfd_k.h>
    59	#include <linux/tsacct_kern.h>
    60	#include <linux/cn_proc.h>
    61	#include <linux/freezer.h>
    62	#include <linux/delayacct.h>
    63	#include <linux/taskstats_kern.h>
    64	#include <linux/random.h>
    65	#include <linux/tty.h>
    66	#include <linux/blkdev.h>
    67	#include <linux/fs_struct.h>
    68	#include <linux/magic.h>
    69	#include <linux/perf_event.h>
    70	#include <linux/posix-timers.h>
    71	#include <linux/user-return-notifier.h>
    72	#include <linux/oom.h>
    73	#include <linux/khugepaged.h>
    74	#include <linux/signalfd.h>
    75	#include <linux/uprobes.h>
    76	#include <linux/aio.h>
    77	#include <linux/compiler.h>
    78	#include <linux/sysctl.h>
    79	#include <linux/kcov.h>
    80	
    81	#include <asm/pgtable.h>
    82	#include <asm/pgalloc.h>
    83	#include <linux/uaccess.h>
    84	#include <asm/mmu_context.h>
    85	#include <asm/cacheflush.h>
    86	#include <asm/tlbflush.h>
    87	
    88	#include <trace/events/sched.h>
    89	
    90	#define CREATE_TRACE_POINTS
    91	#include <trace/events/task.h>
    92	
    93	/*
    94	 * Minimum number of threads to boot the kernel
    95	 */
    96	#define MIN_THREADS 20
    97	
    98	/*
    99	 * Maximum number of threads
   100	 */
   101	#define MAX_THREADS FUTEX_TID_MASK
   102	
   103	/*
   104	 * Protected counters by write_lock_irq(&tasklist_lock)
   105	 */
   106	unsigned long total_forks;	/* Handle normal Linux uptimes. */
   107	int nr_threads;			/* The idle threads do not count.. */
   108	
   109	int max_threads;		/* tunable limit on nr_threads */
   110	
   111	DEFINE_PER_CPU(unsigned long, process_counts) = 0;
   112	
   113	__cacheline_aligned DEFINE_RWLOCK(tasklist_lock);  /* outer */
   114	
   115	#ifdef CONFIG_PROVE_RCU
   116	int lockdep_tasklist_lock_is_held(void)
   117	{
   118		return lockdep_is_held(&tasklist_lock);
   119	}
   120	EXPORT_SYMBOL_GPL(lockdep_tasklist_lock_is_held);
   121	#endif /* #ifdef CONFIG_PROVE_RCU */
   122	
   123	int nr_processes(void)
   124	{
   125		int cpu;
   126		int total = 0;
   127	
   128		for_each_possible_cpu(cpu)
   129			total += per_cpu(process_counts, cpu);
   130	
   131		return total;
   132	}
   133	
   134	void __weak arch_release_task_struct(struct task_struct *tsk)
   135	{
   136	}
   137	
   138	#ifndef CONFIG_ARCH_TASK_STRUCT_ALLOCATOR
   139	static struct kmem_cache *task_struct_cachep;
   140	
   141	static inline struct task_struct *alloc_task_struct_node(int node)
   142	{
   143		return kmem_cache_alloc_node(task_struct_cachep, GFP_KERNEL, node);
   144	}
   145	
   146	static inline void free_task_struct(struct task_struct *tsk)
   147	{
   148		kmem_cache_free(task_struct_cachep, tsk);
   149	}
   150	#endif
   151	
   152	void __weak arch_release_thread_stack(unsigned long *stack)
   153	{
   154	}
   155	
   156	#ifndef CONFIG_ARCH_THREAD_STACK_ALLOCATOR
   157	
   158	/*
   159	 * Allocate pages if THREAD_SIZE is >= PAGE_SIZE, otherwise use a
   160	 * kmemcache based allocator.
   161	 */
   162	# if THREAD_SIZE >= PAGE_SIZE || defined(CONFIG_VMAP_STACK)
   163	
   164	#ifdef CONFIG_VMAP_STACK
   165	/*
   166	 * vmalloc() is a bit slow, and calling vfree() enough times will force a TLB
   167	 * flush.  Try to minimize the number of calls by caching stacks.
   168	 */
   169	#define NR_CACHED_STACKS 2
   170	static DEFINE_PER_CPU(struct vm_struct *, cached_stacks[NR_CACHED_STACKS]);
   171	#endif
   172	
   173	static int free_vm_stack_cache(unsigned int cpu)
   174	{
   175		int i;
   176	
 > 177		for (i = 0; i < NR_CACHED_STACKS; i++) {
 > 178			struct vm_struct *vm_stack = this_cpu_read(cached_stacks[i]);
   179			if (!vm_stack)
   180				continue;
   181	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--k1lZvvs/B4yU6o8G
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--k1lZvvs/B4yU6o8G--
