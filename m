Date: Wed, 1 Aug 2018 00:29:05 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] perf/core: Fix possible Spectre-v1 for
 perf_swevent_enabled
Message-ID: <201808010038.2G0e4vR6%fengguang.wu@intel.com>
References: <20180731142557.GA12460@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <20180731142557.GA12460@pjb1027-Latitude-E5410>
To: Jinbum Park <jinb.park7@gmail.com>
Cc: kbuild-all@01.org, peterz@infradead.org, mingo@redhat.com, acme@kernel.org, alexander.shishkin@linux.intel.com, jolsa@redhat.com, namhyung@kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jinbum,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on tip/perf/core]
[also build test ERROR on v4.18-rc7 next-20180727]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Jinbum-Park/perf-core-Fix-possible-Spectre-v1-for-perf_swevent_enabled/20180731-235311
config: i386-randconfig-x077-201830 (attached as .config)
compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All error/warnings (new ones prefixed by >>):

   Cyclomatic Complexity 11 kernel//events/core.c:perf_event_read_local
   Cyclomatic Complexity 4 kernel//events/core.c:perf_event_task_enable
   Cyclomatic Complexity 4 kernel//events/core.c:perf_event_task_disable
   Cyclomatic Complexity 1 kernel//events/core.c:arch_perf_update_userpage
   Cyclomatic Complexity 6 kernel//events/core.c:perf_event_update_userpage
   Cyclomatic Complexity 3 kernel//events/core.c:__perf_event_sync_stat
   Cyclomatic Complexity 8 kernel//events/core.c:perf_event_sync_stat
   Cyclomatic Complexity 15 kernel//events/core.c:perf_event_context_sched_out
   Cyclomatic Complexity 5 kernel//events/core.c:__perf_event_task_sched_out
   Cyclomatic Complexity 1 kernel//events/core.c:_perf_event_reset
   Cyclomatic Complexity 2 kernel//events/core.c:task_clock_event_add
   Cyclomatic Complexity 2 kernel//events/core.c:cpu_clock_event_add
   Cyclomatic Complexity 6 kernel//events/core.c:ring_buffer_get
   Cyclomatic Complexity 3 kernel//events/core.c:ring_buffer_put
   Cyclomatic Complexity 8 kernel//events/core.c:ring_buffer_attach
   Cyclomatic Complexity 8 kernel//events/core.c:_free_event
   Cyclomatic Complexity 3 kernel//events/core.c:free_event
   Cyclomatic Complexity 9 kernel//events/core.c:perf_event_create_kernel_counter
   Cyclomatic Complexity 10 kernel//events/core.c:inherit_event
   Cyclomatic Complexity 7 kernel//events/core.c:inherit_group
   Cyclomatic Complexity 5 kernel//events/core.c:inherit_task_group
   Cyclomatic Complexity 18 kernel//events/core.c:perf_event_init_context
   Cyclomatic Complexity 2 kernel//events/core.c:put_event
   Cyclomatic Complexity 14 kernel//events/core.c:perf_event_release_kernel
   Cyclomatic Complexity 1 kernel//events/core.c:perf_release
   Cyclomatic Complexity 3 kernel//events/core.c:perf_free_event
   Cyclomatic Complexity 44 kernel//events/core.c:perf_mmap
   Cyclomatic Complexity 14 kernel//events/core.c:perf_event_set_output
   Cyclomatic Complexity 84 kernel//events/core.c:__do_sys_perf_event_open
   Cyclomatic Complexity 1 kernel//events/core.c:__se_sys_perf_event_open
   Cyclomatic Complexity 23 kernel//events/core.c:_perf_ioctl
   Cyclomatic Complexity 1 kernel//events/core.c:perf_ioctl
   Cyclomatic Complexity 13 kernel//events/core.c:perf_mmap_close
   Cyclomatic Complexity 2 kernel//events/core.c:perf_event_wakeup
   Cyclomatic Complexity 2 kernel//events/core.c:perf_event_header__init_id
   Cyclomatic Complexity 2 kernel//events/core.c:perf_event__output_id_sample
   Cyclomatic Complexity 3 kernel//events/core.c:perf_log_throttle
   Cyclomatic Complexity 12 kernel//events/core.c:perf_adjust_freq_unthr_context
   Cyclomatic Complexity 11 kernel//events/core.c:perf_event_task_tick
   Cyclomatic Complexity 6 kernel//events/core.c:__perf_event_account_interrupt
   Cyclomatic Complexity 6 kernel//events/core.c:__perf_event_overflow
   Cyclomatic Complexity 8 kernel//events/core.c:perf_swevent_hrtimer
   Cyclomatic Complexity 5 kernel//events/core.c:__perf_event_period
   Cyclomatic Complexity 5 kernel//events/core.c:perf_log_itrace_start
   Cyclomatic Complexity 12 kernel//events/core.c:event_sched_in
   Cyclomatic Complexity 14 kernel//events/core.c:group_sched_in
   Cyclomatic Complexity 6 kernel//events/core.c:pinned_sched_in
   Cyclomatic Complexity 5 kernel//events/core.c:flexible_sched_in
   Cyclomatic Complexity 5 kernel//events/core.c:perf_event_switch_output
   Cyclomatic Complexity 3 kernel//events/core.c:perf_event_task_output
   Cyclomatic Complexity 3 kernel//events/core.c:perf_event_comm_output
   Cyclomatic Complexity 3 kernel//events/core.c:perf_event_namespaces_output
   Cyclomatic Complexity 5 kernel//events/core.c:perf_event_mmap_output
   Cyclomatic Complexity 2 kernel//events/core.c:perf_event_read_event
   Cyclomatic Complexity 2 kernel//events/core.c:sync_child_event
   Cyclomatic Complexity 5 kernel//events/core.c:perf_event_exit_event
   Cyclomatic Complexity 8 kernel//events/core.c:perf_event_exit_task_context
   Cyclomatic Complexity 31 kernel//events/core.c:perf_output_sample
   Cyclomatic Complexity 5 kernel//events/core.c:perf_callchain
   Cyclomatic Complexity 19 kernel//events/core.c:perf_prepare_sample
   Cyclomatic Complexity 1 kernel//events/core.c:perf_event_output
   Cyclomatic Complexity 3 kernel//events/core.c:perf_event_exec
   Cyclomatic Complexity 3 kernel//events/core.c:perf_event_comm
   Cyclomatic Complexity 2 kernel//events/core.c:perf_event_namespaces
   Cyclomatic Complexity 1 kernel//events/core.c:perf_event_fork
   Cyclomatic Complexity 2 kernel//events/core.c:perf_event_mmap
   Cyclomatic Complexity 2 kernel//events/core.c:perf_event_aux_event
   Cyclomatic Complexity 2 kernel//events/core.c:perf_log_lost_samples
   Cyclomatic Complexity 1 kernel//events/core.c:perf_event_itrace_started
   Cyclomatic Complexity 1 kernel//events/core.c:perf_event_account_interrupt
   Cyclomatic Complexity 1 kernel//events/core.c:perf_event_overflow
   Cyclomatic Complexity 3 kernel//events/core.c:perf_swevent_set_period
   Cyclomatic Complexity 5 kernel//events/core.c:perf_swevent_overflow
   Cyclomatic Complexity 9 kernel//events/core.c:perf_swevent_event
   Cyclomatic Complexity 8 kernel//events/core.c:do_perf_sw_event
   Cyclomatic Complexity 4 kernel//events/core.c:perf_swevent_add
   Cyclomatic Complexity 1 kernel//events/core.c:perf_swevent_put_recursion_context
   Cyclomatic Complexity 5 kernel//events/core.c:perf_pending_event
   Cyclomatic Complexity 3 kernel//events/core.c:___perf_sw_event
   Cyclomatic Complexity 2 kernel//events/core.c:__perf_sw_event
   Cyclomatic Complexity 3 kernel//events/core.c:perf_bp_event
   Cyclomatic Complexity 7 kernel//events/core.c:perf_event_exit_task
   Cyclomatic Complexity 7 kernel//events/core.c:perf_event_free_task
   Cyclomatic Complexity 3 kernel//events/core.c:perf_event_delayed_put
   Cyclomatic Complexity 3 kernel//events/core.c:perf_event_get
   Cyclomatic Complexity 2 kernel//events/core.c:perf_get_event
   Cyclomatic Complexity 2 kernel//events/core.c:perf_event_attrs
   Cyclomatic Complexity 3 kernel//events/core.c:perf_event_init_task
   Cyclomatic Complexity 5 kernel//events/core.c:perf_swevent_init_cpu
   Cyclomatic Complexity 4 kernel//events/core.c:perf_event_init_cpu
   Cyclomatic Complexity 1 kernel//events/core.c:perf_event_exit_cpu
   Cyclomatic Complexity 2 kernel//events/core.c:perf_reboot
   Cyclomatic Complexity 3 kernel//events/core.c:perf_event_init
   In file included from include/linux/kernel.h:10:0,
                    from include/linux/list.h:9,
                    from include/linux/wait.h:7,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:6,
                    from kernel//events/core.c:12:
   kernel//events/core.c: In function 'perf_swevent_init':
>> include/linux/compiler.h:339:38: error: call to '__compiletime_assert_8204' declared with attribute error: BUILD_BUG_ON failed: sizeof(_s) > sizeof(long)
     _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
                                         ^
   include/linux/compiler.h:319:4: note: in definition of macro '__compiletime_assert'
       prefix ## suffix();    \
       ^~~~~~
   include/linux/compiler.h:339:2: note: in expansion of macro '_compiletime_assert'
     _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
     ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:45:37: note: in expansion of macro 'compiletime_assert'
    #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                        ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:69:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
     BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
     ^~~~~~~~~~~~~~~~
>> include/linux/nospec.h:55:2: note: in expansion of macro 'BUILD_BUG_ON'
     BUILD_BUG_ON(sizeof(_i) > sizeof(long));   \
     ^~~~~~~~~~~~
>> kernel//events/core.c:8204:14: note: in expansion of macro 'array_index_nospec'
      event_id = array_index_nospec(event_id, PERF_COUNT_SW_MAX);
                 ^~~~~~~~~~~~~~~~~~
--
   Cyclomatic Complexity 11 kernel/events/core.c:perf_event_read_local
   Cyclomatic Complexity 4 kernel/events/core.c:perf_event_task_enable
   Cyclomatic Complexity 4 kernel/events/core.c:perf_event_task_disable
   Cyclomatic Complexity 1 kernel/events/core.c:arch_perf_update_userpage
   Cyclomatic Complexity 6 kernel/events/core.c:perf_event_update_userpage
   Cyclomatic Complexity 3 kernel/events/core.c:__perf_event_sync_stat
   Cyclomatic Complexity 8 kernel/events/core.c:perf_event_sync_stat
   Cyclomatic Complexity 15 kernel/events/core.c:perf_event_context_sched_out
   Cyclomatic Complexity 5 kernel/events/core.c:__perf_event_task_sched_out
   Cyclomatic Complexity 1 kernel/events/core.c:_perf_event_reset
   Cyclomatic Complexity 2 kernel/events/core.c:task_clock_event_add
   Cyclomatic Complexity 2 kernel/events/core.c:cpu_clock_event_add
   Cyclomatic Complexity 6 kernel/events/core.c:ring_buffer_get
   Cyclomatic Complexity 3 kernel/events/core.c:ring_buffer_put
   Cyclomatic Complexity 8 kernel/events/core.c:ring_buffer_attach
   Cyclomatic Complexity 8 kernel/events/core.c:_free_event
   Cyclomatic Complexity 3 kernel/events/core.c:free_event
   Cyclomatic Complexity 9 kernel/events/core.c:perf_event_create_kernel_counter
   Cyclomatic Complexity 10 kernel/events/core.c:inherit_event
   Cyclomatic Complexity 7 kernel/events/core.c:inherit_group
   Cyclomatic Complexity 5 kernel/events/core.c:inherit_task_group
   Cyclomatic Complexity 18 kernel/events/core.c:perf_event_init_context
   Cyclomatic Complexity 2 kernel/events/core.c:put_event
   Cyclomatic Complexity 14 kernel/events/core.c:perf_event_release_kernel
   Cyclomatic Complexity 1 kernel/events/core.c:perf_release
   Cyclomatic Complexity 3 kernel/events/core.c:perf_free_event
   Cyclomatic Complexity 44 kernel/events/core.c:perf_mmap
   Cyclomatic Complexity 14 kernel/events/core.c:perf_event_set_output
   Cyclomatic Complexity 84 kernel/events/core.c:__do_sys_perf_event_open
   Cyclomatic Complexity 1 kernel/events/core.c:__se_sys_perf_event_open
   Cyclomatic Complexity 23 kernel/events/core.c:_perf_ioctl
   Cyclomatic Complexity 1 kernel/events/core.c:perf_ioctl
   Cyclomatic Complexity 13 kernel/events/core.c:perf_mmap_close
   Cyclomatic Complexity 2 kernel/events/core.c:perf_event_wakeup
   Cyclomatic Complexity 2 kernel/events/core.c:perf_event_header__init_id
   Cyclomatic Complexity 2 kernel/events/core.c:perf_event__output_id_sample
   Cyclomatic Complexity 3 kernel/events/core.c:perf_log_throttle
   Cyclomatic Complexity 12 kernel/events/core.c:perf_adjust_freq_unthr_context
   Cyclomatic Complexity 11 kernel/events/core.c:perf_event_task_tick
   Cyclomatic Complexity 6 kernel/events/core.c:__perf_event_account_interrupt
   Cyclomatic Complexity 6 kernel/events/core.c:__perf_event_overflow
   Cyclomatic Complexity 8 kernel/events/core.c:perf_swevent_hrtimer
   Cyclomatic Complexity 5 kernel/events/core.c:__perf_event_period
   Cyclomatic Complexity 5 kernel/events/core.c:perf_log_itrace_start
   Cyclomatic Complexity 12 kernel/events/core.c:event_sched_in
   Cyclomatic Complexity 14 kernel/events/core.c:group_sched_in
   Cyclomatic Complexity 6 kernel/events/core.c:pinned_sched_in
   Cyclomatic Complexity 5 kernel/events/core.c:flexible_sched_in
   Cyclomatic Complexity 5 kernel/events/core.c:perf_event_switch_output
   Cyclomatic Complexity 3 kernel/events/core.c:perf_event_task_output
   Cyclomatic Complexity 3 kernel/events/core.c:perf_event_comm_output
   Cyclomatic Complexity 3 kernel/events/core.c:perf_event_namespaces_output
   Cyclomatic Complexity 5 kernel/events/core.c:perf_event_mmap_output
   Cyclomatic Complexity 2 kernel/events/core.c:perf_event_read_event
   Cyclomatic Complexity 2 kernel/events/core.c:sync_child_event
   Cyclomatic Complexity 5 kernel/events/core.c:perf_event_exit_event
   Cyclomatic Complexity 8 kernel/events/core.c:perf_event_exit_task_context
   Cyclomatic Complexity 31 kernel/events/core.c:perf_output_sample
   Cyclomatic Complexity 5 kernel/events/core.c:perf_callchain
   Cyclomatic Complexity 19 kernel/events/core.c:perf_prepare_sample
   Cyclomatic Complexity 1 kernel/events/core.c:perf_event_output
   Cyclomatic Complexity 3 kernel/events/core.c:perf_event_exec
   Cyclomatic Complexity 3 kernel/events/core.c:perf_event_comm
   Cyclomatic Complexity 2 kernel/events/core.c:perf_event_namespaces
   Cyclomatic Complexity 1 kernel/events/core.c:perf_event_fork
   Cyclomatic Complexity 2 kernel/events/core.c:perf_event_mmap
   Cyclomatic Complexity 2 kernel/events/core.c:perf_event_aux_event
   Cyclomatic Complexity 2 kernel/events/core.c:perf_log_lost_samples
   Cyclomatic Complexity 1 kernel/events/core.c:perf_event_itrace_started
   Cyclomatic Complexity 1 kernel/events/core.c:perf_event_account_interrupt
   Cyclomatic Complexity 1 kernel/events/core.c:perf_event_overflow
   Cyclomatic Complexity 3 kernel/events/core.c:perf_swevent_set_period
   Cyclomatic Complexity 5 kernel/events/core.c:perf_swevent_overflow
   Cyclomatic Complexity 9 kernel/events/core.c:perf_swevent_event
   Cyclomatic Complexity 8 kernel/events/core.c:do_perf_sw_event
   Cyclomatic Complexity 4 kernel/events/core.c:perf_swevent_add
   Cyclomatic Complexity 1 kernel/events/core.c:perf_swevent_put_recursion_context
   Cyclomatic Complexity 5 kernel/events/core.c:perf_pending_event
   Cyclomatic Complexity 3 kernel/events/core.c:___perf_sw_event
   Cyclomatic Complexity 2 kernel/events/core.c:__perf_sw_event
   Cyclomatic Complexity 3 kernel/events/core.c:perf_bp_event
   Cyclomatic Complexity 7 kernel/events/core.c:perf_event_exit_task
   Cyclomatic Complexity 7 kernel/events/core.c:perf_event_free_task
   Cyclomatic Complexity 3 kernel/events/core.c:perf_event_delayed_put
   Cyclomatic Complexity 3 kernel/events/core.c:perf_event_get
   Cyclomatic Complexity 2 kernel/events/core.c:perf_get_event
   Cyclomatic Complexity 2 kernel/events/core.c:perf_event_attrs
   Cyclomatic Complexity 3 kernel/events/core.c:perf_event_init_task
   Cyclomatic Complexity 5 kernel/events/core.c:perf_swevent_init_cpu
   Cyclomatic Complexity 4 kernel/events/core.c:perf_event_init_cpu
   Cyclomatic Complexity 1 kernel/events/core.c:perf_event_exit_cpu
   Cyclomatic Complexity 2 kernel/events/core.c:perf_reboot
   Cyclomatic Complexity 3 kernel/events/core.c:perf_event_init
   In file included from include/linux/kernel.h:10:0,
                    from include/linux/list.h:9,
                    from include/linux/wait.h:7,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:6,
                    from kernel/events/core.c:12:
   kernel/events/core.c: In function 'perf_swevent_init':
>> include/linux/compiler.h:339:38: error: call to '__compiletime_assert_8204' declared with attribute error: BUILD_BUG_ON failed: sizeof(_s) > sizeof(long)
     _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
                                         ^
   include/linux/compiler.h:319:4: note: in definition of macro '__compiletime_assert'
       prefix ## suffix();    \
       ^~~~~~
   include/linux/compiler.h:339:2: note: in expansion of macro '_compiletime_assert'
     _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
     ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:45:37: note: in expansion of macro 'compiletime_assert'
    #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                        ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:69:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
     BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
     ^~~~~~~~~~~~~~~~
>> include/linux/nospec.h:55:2: note: in expansion of macro 'BUILD_BUG_ON'
     BUILD_BUG_ON(sizeof(_i) > sizeof(long));   \
     ^~~~~~~~~~~~
   kernel/events/core.c:8204:14: note: in expansion of macro 'array_index_nospec'
      event_id = array_index_nospec(event_id, PERF_COUNT_SW_MAX);
                 ^~~~~~~~~~~~~~~~~~

vim +/BUILD_BUG_ON +55 include/linux/nospec.h

8fa80c503 Will Deacon      2018-02-05  34  
8fa80c503 Will Deacon      2018-02-05  35  /*
f38042033 Dan Williams     2018-01-29  36   * array_index_nospec - sanitize an array index after a bounds check
f38042033 Dan Williams     2018-01-29  37   *
f38042033 Dan Williams     2018-01-29  38   * For a code sequence like:
f38042033 Dan Williams     2018-01-29  39   *
f38042033 Dan Williams     2018-01-29  40   *     if (index < size) {
f38042033 Dan Williams     2018-01-29  41   *         index = array_index_nospec(index, size);
f38042033 Dan Williams     2018-01-29  42   *         val = array[index];
f38042033 Dan Williams     2018-01-29  43   *     }
f38042033 Dan Williams     2018-01-29  44   *
f38042033 Dan Williams     2018-01-29  45   * ...if the CPU speculates past the bounds check then
f38042033 Dan Williams     2018-01-29  46   * array_index_nospec() will clamp the index within the range of [0,
f38042033 Dan Williams     2018-01-29  47   * size).
f38042033 Dan Williams     2018-01-29  48   */
f38042033 Dan Williams     2018-01-29  49  #define array_index_nospec(index, size)					\
f38042033 Dan Williams     2018-01-29  50  ({									\
f38042033 Dan Williams     2018-01-29  51  	typeof(index) _i = (index);					\
f38042033 Dan Williams     2018-01-29  52  	typeof(size) _s = (size);					\
1d91c1d2c Dan Williams     2018-02-16  53  	unsigned long _mask = array_index_mask_nospec(_i, _s);		\
f38042033 Dan Williams     2018-01-29  54  									\
f38042033 Dan Williams     2018-01-29 @55  	BUILD_BUG_ON(sizeof(_i) > sizeof(long));			\
f38042033 Dan Williams     2018-01-29  56  	BUILD_BUG_ON(sizeof(_s) > sizeof(long));			\
f38042033 Dan Williams     2018-01-29  57  									\
b98c6a160 Rasmus Villemoes 2018-02-16  58  	(typeof(_i)) (_i & _mask);					\
f38042033 Dan Williams     2018-01-29  59  })
b617cfc85 Thomas Gleixner  2018-04-29  60  

:::::: The code at line 55 was first introduced by commit
:::::: f3804203306e098dae9ca51540fcd5eb700d7f40 array_index_nospec: Sanitize speculative array de-references

:::::: TO: Dan Williams <dan.j.williams@intel.com>
:::::: CC: Thomas Gleixner <tglx@linutronix.de>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--sdtB3X0nJg68CQEu
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
hieOaAEA

--sdtB3X0nJg68CQEu--
