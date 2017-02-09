Date: Thu, 9 Feb 2017 18:26:18 +0800
From: kbuild test robot <lkp@intel.com>
Message-ID: <201702091841.J7puTe76%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486613040-30555-1-git-send-email-hoeun.ryu@gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 1/2] fork: free vmapped stacks in cache when cpus are
 offline
To: Hoeun Ryu <hoeun.ryu@gmail.com>
Cc: kbuild-all@01.org, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Hoeun,

[auto build test WARNING on next-20170208]
[also build test WARNING on v4.10-rc7]
[cannot apply to linus/master linux/master v4.9-rc8 v4.9-rc7 v4.9-rc6]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Hoeun-Ryu/fork-free-vmapped-stacks-in-cache-when-cpus-are-offline/20170209-124143
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:264:8: sparse: attribute 'no_sanitize_address': unknown attribute
   kernel/fork.c:177:25: sparse: undefined identifier 'NR_CACHED_STACKS'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
>> kernel/fork.c:178:46: sparse: incompatible types for operation (+)
   kernel/fork.c:178:46:    left side has type bad type
   kernel/fork.c:178:46:    right side has type int [signed] [assigned] i
>> kernel/fork.c:178:46: sparse: cannot dereference this type
>> kernel/fork.c:178:46: sparse: incompatible types for operation (+)
   kernel/fork.c:178:46:    left side has type bad type
   kernel/fork.c:178:46:    right side has type int
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
>> kernel/fork.c:178:46: sparse: incompatible types for 'case' statement
>> kernel/fork.c:178:46: sparse: incompatible types for 'case' statement
>> kernel/fork.c:178:46: sparse: incompatible types for 'case' statement
>> kernel/fork.c:178:46: sparse: incompatible types for 'case' statement
>> kernel/fork.c:178:46: sparse: incompatible types for operation (+)
   kernel/fork.c:178:46:    left side has type bad type
   kernel/fork.c:178:46:    right side has type int [signed] [assigned] i
>> kernel/fork.c:178:46: sparse: cannot dereference this type
>> kernel/fork.c:178:46: sparse: incompatible types for operation (+)
   kernel/fork.c:178:46:    left side has type bad type
   kernel/fork.c:178:46:    right side has type int [signed] [assigned] i
>> kernel/fork.c:178:46: sparse: cannot dereference this type
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
>> kernel/fork.c:178:46: sparse: incompatible types for 'case' statement
>> kernel/fork.c:178:46: sparse: incompatible types for 'case' statement
>> kernel/fork.c:178:46: sparse: incompatible types for 'case' statement
>> kernel/fork.c:178:46: sparse: incompatible types for 'case' statement
>> kernel/fork.c:178:46: sparse: incompatible types for operation (+)
   kernel/fork.c:178:46:    left side has type bad type
   kernel/fork.c:178:46:    right side has type int [signed] [assigned] i
>> kernel/fork.c:178:46: sparse: cannot dereference this type
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
>> kernel/fork.c:178:46: sparse: incompatible types for 'case' statement
>> kernel/fork.c:178:46: sparse: incompatible types for 'case' statement
>> kernel/fork.c:178:46: sparse: incompatible types for 'case' statement
>> kernel/fork.c:178:46: sparse: incompatible types for 'case' statement
>> kernel/fork.c:178:46: sparse: incompatible types for operation (+)
   kernel/fork.c:178:46:    left side has type bad type
   kernel/fork.c:178:46:    right side has type int [signed] [assigned] i
>> kernel/fork.c:178:46: sparse: cannot dereference this type
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:178:46: sparse: undefined identifier 'cached_stacks'
>> kernel/fork.c:178:46: sparse: incompatible types for 'case' statement
>> kernel/fork.c:178:46: sparse: incompatible types for 'case' statement
>> kernel/fork.c:178:46: sparse: incompatible types for 'case' statement
>> kernel/fork.c:178:46: sparse: incompatible types for 'case' statement
>> kernel/fork.c:178:46: sparse: incompatible types for operation (+)
   kernel/fork.c:178:46:    left side has type bad type
   kernel/fork.c:178:46:    right side has type int [signed] [assigned] i
>> kernel/fork.c:178:46: sparse: cannot dereference this type
>> kernel/fork.c:178:46: sparse: incompatible types for 'case' statement
>> kernel/fork.c:178:46: sparse: incompatible types for 'case' statement
>> kernel/fork.c:178:46: sparse: incompatible types for 'case' statement
>> kernel/fork.c:178:46: sparse: incompatible types for 'case' statement
   kernel/fork.c:183:17: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:183:17: sparse: incompatible types for operation (+)
   kernel/fork.c:183:17:    left side has type bad type
   kernel/fork.c:183:17:    right side has type int [signed] [assigned] i
   kernel/fork.c:183:17: sparse: cannot dereference this type
   kernel/fork.c:183:17: sparse: incompatible types for operation (+)
   kernel/fork.c:183:17:    left side has type bad type
   kernel/fork.c:183:17:    right side has type int
   kernel/fork.c:183:17: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:183:17: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:183:17: sparse: incompatible types for operation (+)
   kernel/fork.c:183:17:    left side has type bad type
   kernel/fork.c:183:17:    right side has type int [signed] [assigned] i
   kernel/fork.c:183:17: sparse: cannot dereference this type
   kernel/fork.c:183:17: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:183:17: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:183:17: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:183:17: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:183:17: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:183:17: sparse: incompatible types for 'case' statement
   kernel/fork.c:183:17: sparse: incompatible types for 'case' statement
   kernel/fork.c:183:17: sparse: incompatible types for 'case' statement
   kernel/fork.c:183:17: sparse: incompatible types for 'case' statement
   kernel/fork.c:183:17: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:183:17: sparse: incompatible types for operation (+)
   kernel/fork.c:183:17:    left side has type bad type
   kernel/fork.c:183:17:    right side has type int [signed] [assigned] i
   kernel/fork.c:183:17: sparse: cannot dereference this type
   kernel/fork.c:183:17: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:183:17: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:183:17: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:183:17: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:183:17: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:183:17: sparse: incompatible types for 'case' statement
   kernel/fork.c:183:17: sparse: incompatible types for 'case' statement
   kernel/fork.c:183:17: sparse: incompatible types for 'case' statement
   kernel/fork.c:183:17: sparse: incompatible types for 'case' statement
   kernel/fork.c:183:17: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:183:17: sparse: incompatible types for operation (+)
   kernel/fork.c:183:17:    left side has type bad type
   kernel/fork.c:183:17:    right side has type int [signed] [assigned] i
   kernel/fork.c:183:17: sparse: cannot dereference this type
   kernel/fork.c:183:17: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:183:17: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:183:17: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:183:17: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:183:17: sparse: undefined identifier 'cached_stacks'
   kernel/fork.c:183:17: sparse: incompatible types for 'case' statement
   kernel/fork.c:183:17: sparse: incompatible types for 'case' statement
>> kernel/fork.c:183:17: sparse: too many errors
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
   arch/x86/include/asm/percpu.h:94:13: warning: assignment makes integer from pointer without a cast [-Wint-conversion]
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
   kernel/fork.c:183:3: note: in expansion of macro 'this_cpu_write'
      this_cpu_write(cached_stacks[i], NULL);
      ^~~~~~~~~~~~~~
   arch/x86/include/asm/percpu.h:101:15: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
          : "qi" ((pto_T__)(val)));  \
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
   kernel/fork.c:183:3: note: in expansion of macro 'this_cpu_write'
      this_cpu_write(cached_stacks[i], NULL);
      ^~~~~~~~~~~~~~
   arch/x86/include/asm/percpu.h:106:15: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
          : "ri" ((pto_T__)(val)));  \
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
   kernel/fork.c:183:3: note: in expansion of macro 'this_cpu_write'
      this_cpu_write(cached_stacks[i], NULL);
      ^~~~~~~~~~~~~~
   arch/x86/include/asm/percpu.h:111:15: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
          : "ri" ((pto_T__)(val)));  \
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
   kernel/fork.c:183:3: note: in expansion of macro 'this_cpu_write'
      this_cpu_write(cached_stacks[i], NULL);
      ^~~~~~~~~~~~~~
   arch/x86/include/asm/percpu.h:116:15: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

vim +178 kernel/fork.c

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
   182			vfree(vm_stack->addr);
 > 183			this_cpu_write(cached_stacks[i], NULL);
   184		}
   185	
   186		return 0;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
