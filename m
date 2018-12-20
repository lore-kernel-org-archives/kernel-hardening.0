Subject: Re: 10e9ae9fab ("gcc-plugins: Add STACKLEAK plugin for tracking .."):
 WARNING: can't dereference registers at (null) for ip
 entry_SYSCALL_64_after_hwframe
References: <5c18828f.VHbQvL3kBXAW0ohl%lkp@intel.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <532c3a5b-3358-6f70-b0e8-c2b4afbbbab3@linux.com>
Date: Thu, 20 Dec 2018 23:18:01 +0300
MIME-Version: 1.0
In-Reply-To: <5c18828f.VHbQvL3kBXAW0ohl%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: kernel test robot <lkp@intel.com>, Kees Cook <keescook@chromium.org>
Cc: LKP <lkp@01.org>, kernel-hardening@lists.openwall.com, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hello everyone,

I've carefully worked with this report, let me share the results.

On 18.12.2018 8:15, kernel test robot wrote:
> Greetings,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> 
> commit 10e9ae9fabaf96c8e5227c1cd4827d58b3aa406d
>     gcc-plugins: Add STACKLEAK plugin for tracking the kernel stack

This bot has been running trinity at the following points:

> afaef01c00  x86/entry: Add STACKLEAK erasing the kernel stack at the end of syscalls
> 10e9ae9fab  gcc-plugins: Add STACKLEAK plugin for tracking the kernel stack

    just after stackleak was merged into 4.20-rc1

> 1a9430db28  ima: cleanup the match_token policy code

    near 4.20-rc7 (Dec 17)

> 6648e120dd  Add linux-next specific files for 20181217

    rc + next (Dec 17)

> +---------------------------------------------------------------+------------+------------+------------+---------------+
> |                                                               | afaef01c00 | 10e9ae9fab | 1a9430db28 | next-20181217 |
> +---------------------------------------------------------------+------------+------------+------------+---------------+
> | boot_successes                                                | 386        | 141        | 134        | 135           |
> | boot_failures                                                 | 68         | 9          | 16         | 8             |

The following oopses happened on 4.20-rc1 and disappeared on 4.20-rc7:

> | RIP:trace                                                     | 37         |            |            |               |
> | WARNING:stack_recursion                                       | 36         |            |            |               |
> | WARNING:at(____ptrval____)for_ip_syscall_return_via_sysret/0x | 37         |            |            |               |
> | Kernel_panic-not_syncing:Machine_halted                       | 37         |            |            |               |
> | PANIC:double_fault                                            | 27         |            |            |               |

They are caused by stackleak issues with ftrace and kprobes, that are fixed
in these commits:
    e9c7d656610e
    ef1a84093489

I've double-checked that now stackleak works properly with function tracing,
function_graph tracing and kprobes.

> | Mem-Info                                                      | 2          | 0          | 1          |               |
> | invoked_oom-killer:gfp_mask=0x                                | 1          | 0          | 1          |               |
> | RIP:__put_user_4                                              | 1          |            |            |               |

These 3 lines are not meaningful to me.

> | BUG:KASAN:stack-out-of-bounds_in_u                            | 25         | 8          | 12         | 7             |

This is interesting. How does KASAN work with stackleak? I tested it using
test_kasan.ko -- it works properly both for KASAN outline and inline
instrumentation.

However I noticed that stackleak lkdtm test sometimes reports that kernel
stack is not properly erased in case of KASAN outline instrumentation.
I think it happens because KASAN increases kernel stack usage, so
CONFIG_STACKLEAK_TRACK_MIN_SIZE should be adjusted. I will investigate
that later.

> | RIP:__x86_indirect_thunk_rdx                                  | 26         | 9          | 12         | 7             |
> | INFO:rcu_preempt_detected_stalls_on_CPUs/tasks                | 3          | 0          | 3          |               |
> | RIP:arch_local_irq_enable                                     | 1          |            |            |               |
> | RIP:mntput_no_expire                                          | 1          |            |            |               |
> | RIP:arch_local_irq_restore                                    | 1          |            |            |               |
> | RIP:compound_head                                             | 1          |            |            |               |
> | RIP:rcu_read_lock                                             | 1          |            |            |               |
> | RIP:check_kill_permission                                     | 1          |            |            |               |
> | RIP:radix_tree_load_root                                      | 1          |            |            |               |
> | WARNING:at(null)for_ip_entry_SYSCALL_64_after_hwframe/0x      | 0          | 7          | 11         | 7             |
> | WARNING:at(null)for_ip_async_page_fault/0x                    | 0          | 1          | 1          |               |
> | WARNING:at_kernel/locking/lockdep.c:#lock_downgrade           | 0          | 0          | 2          |               |
> | RIP:lock_downgrade                                            | 0          | 0          | 2          |               |
> | RIP:xa_is_node                                                | 0          | 0          | 1          |               |
> | BUG:kernel_reboot-without-warning_in_test_stage               | 0          | 0          | 0          | 1             |
> +---------------------------------------------------------------+------------+------------+------------+---------------+

Unfortunately, I can't extract anything useful from these lines.
And trinity doesn't provide reproducers...

Anyway, I've created exactly the same trinity setup and have been running
it for 2 days (900 tests) on 4.20-rc7 -- no kernel crashes were hit.

Best regards,
Alexander
