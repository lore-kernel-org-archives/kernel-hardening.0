Date: Thu, 9 Feb 2017 16:01:04 +0800
From: kbuild test robot <lkp@intel.com>
Message-ID: <201702091508.y1BtYFQv%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <1486613040-30555-1-git-send-email-hoeun.ryu@gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 1/2] fork: free vmapped stacks in cache when cpus are
 offline
To: Hoeun Ryu <hoeun.ryu@gmail.com>
Cc: kbuild-all@01.org, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Hoeun,

[auto build test WARNING on next-20170208]
[also build test WARNING on v4.10-rc7]
[cannot apply to linus/master linux/master v4.9-rc8 v4.9-rc7 v4.9-rc6]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Hoeun-Ryu/fork-free-vmapped-stacks-in-cache-when-cpus-are-offline/20170209-124143
config: i386-randconfig-x004-201706 (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   kernel/fork.c: In function 'free_vm_stack_cache':
   kernel/fork.c:177:18: error: 'NR_CACHED_STACKS' undeclared (first use in this function)
     for (i = 0; i < NR_CACHED_STACKS; i++) {
                     ^~~~~~~~~~~~~~~~
   kernel/fork.c:177:18: note: each undeclared identifier is reported only once for each function it appears in
   In file included from include/asm-generic/percpu.h:6:0,
                    from arch/x86/include/asm/percpu.h:542,
                    from arch/x86/include/asm/preempt.h:5,
                    from include/linux/preempt.h:59,
                    from include/linux/spinlock.h:50,
                    from include/linux/mmzone.h:7,
                    from include/linux/gfp.h:5,
                    from include/linux/slab.h:14,
                    from kernel/fork.c:14:
   kernel/fork.c:178:46: error: 'cached_stacks' undeclared (first use in this function)
      struct vm_struct *vm_stack = this_cpu_read(cached_stacks[i]);
                                                 ^
   include/linux/percpu-defs.h:305:9: note: in definition of macro '__pcpu_size_call_return'
     typeof(variable) pscr_ret__;     \
            ^~~~~~~~
   kernel/fork.c:178:32: note: in expansion of macro 'this_cpu_read'
      struct vm_struct *vm_stack = this_cpu_read(cached_stacks[i]);
                                   ^~~~~~~~~~~~~
   include/linux/percpu-defs.h:304:1: warning: initialization makes pointer from integer without a cast [-Wint-conversion]
    ({         \
    ^
   include/linux/percpu-defs.h:494:29: note: in expansion of macro '__pcpu_size_call_return'
    #define this_cpu_read(pcp)  __pcpu_size_call_return(this_cpu_read_, pcp)
                                ^~~~~~~~~~~~~~~~~~~~~~~
   kernel/fork.c:178:32: note: in expansion of macro 'this_cpu_read'
      struct vm_struct *vm_stack = this_cpu_read(cached_stacks[i]);
                                   ^~~~~~~~~~~~~
   In file included from arch/x86/include/asm/preempt.h:5:0,
                    from include/linux/preempt.h:59,
                    from include/linux/spinlock.h:50,
                    from include/linux/mmzone.h:7,
                    from include/linux/gfp.h:5,
                    from include/linux/slab.h:14,
                    from kernel/fork.c:14:
>> arch/x86/include/asm/percpu.h:94:13: warning: assignment makes integer from pointer without a cast [-Wint-conversion]
      pto_tmp__ = (val);   \
                ^
   arch/x86/include/asm/percpu.h:416:36: note: in expansion of macro 'percpu_to_op'
    #define this_cpu_write_1(pcp, val) percpu_to_op("mov", (pcp), val)
                                       ^~~~~~~~~~~~
   include/linux/percpu-defs.h:364:11: note: in expansion of macro 'this_cpu_write_1'
      case 1: stem##1(variable, __VA_ARGS__);break;  \
              ^~~~
   include/linux/percpu-defs.h:495:34: note: in expansion of macro '__pcpu_size_call'
    #define this_cpu_write(pcp, val) __pcpu_size_call(this_cpu_write_, pcp, val)
                                     ^~~~~~~~~~~~~~~~
>> kernel/fork.c:183:3: note: in expansion of macro 'this_cpu_write'
      this_cpu_write(cached_stacks[i], NULL);
      ^~~~~~~~~~~~~~
>> arch/x86/include/asm/percpu.h:94:13: warning: assignment makes integer from pointer without a cast [-Wint-conversion]
      pto_tmp__ = (val);   \
                ^
   arch/x86/include/asm/percpu.h:417:36: note: in expansion of macro 'percpu_to_op'
    #define this_cpu_write_2(pcp, val) percpu_to_op("mov", (pcp), val)
                                       ^~~~~~~~~~~~
   include/linux/percpu-defs.h:365:11: note: in expansion of macro 'this_cpu_write_2'
      case 2: stem##2(variable, __VA_ARGS__);break;  \
              ^~~~
   include/linux/percpu-defs.h:495:34: note: in expansion of macro '__pcpu_size_call'
    #define this_cpu_write(pcp, val) __pcpu_size_call(this_cpu_write_, pcp, val)
                                     ^~~~~~~~~~~~~~~~
>> kernel/fork.c:183:3: note: in expansion of macro 'this_cpu_write'
      this_cpu_write(cached_stacks[i], NULL);
      ^~~~~~~~~~~~~~
>> arch/x86/include/asm/percpu.h:94:13: warning: assignment makes integer from pointer without a cast [-Wint-conversion]
      pto_tmp__ = (val);   \
                ^
   arch/x86/include/asm/percpu.h:418:36: note: in expansion of macro 'percpu_to_op'
    #define this_cpu_write_4(pcp, val) percpu_to_op("mov", (pcp), val)
                                       ^~~~~~~~~~~~
   include/linux/percpu-defs.h:366:11: note: in expansion of macro 'this_cpu_write_4'
      case 4: stem##4(variable, __VA_ARGS__);break;  \
              ^~~~
   include/linux/percpu-defs.h:495:34: note: in expansion of macro '__pcpu_size_call'
    #define this_cpu_write(pcp, val) __pcpu_size_call(this_cpu_write_, pcp, val)
                                     ^~~~~~~~~~~~~~~~
>> kernel/fork.c:183:3: note: in expansion of macro 'this_cpu_write'
      this_cpu_write(cached_stacks[i], NULL);
      ^~~~~~~~~~~~~~
   At top level:
   kernel/fork.c:173:12: warning: 'free_vm_stack_cache' defined but not used [-Wunused-function]
    static int free_vm_stack_cache(unsigned int cpu)
               ^~~~~~~~~~~~~~~~~~~

vim +/this_cpu_write +183 kernel/fork.c

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
   177		for (i = 0; i < NR_CACHED_STACKS; i++) {
   178			struct vm_struct *vm_stack = this_cpu_read(cached_stacks[i]);
   179			if (!vm_stack)
   180				continue;
   181	
   182			vfree(vm_stack->addr);
 > 183			this_cpu_write(cached_stacks[i], NULL);
   184		}
   185	
   186		return 0;
   187	}
   188	
   189	static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
   190	{
   191	#ifdef CONFIG_VMAP_STACK

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--OgqxwSJOaUobr8KG
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
V4wAFRhhxYnUaS77AjaSEy74f6J6FPg3rAEA

--OgqxwSJOaUobr8KG--
