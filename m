Date: Mon, 20 Feb 2017 10:02:13 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170220100213.GA9003@leverpostej>
References: <1487498618-16528-1-git-send-email-hoeun.ryu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487498618-16528-1-git-send-email-hoeun.ryu@gmail.com>
Subject: Re: [kernel-hardening] [PATCH 0/7] introduce __ro_mostly_after_init
 section marker
To: Hoeun Ryu <hoeun.ryu@gmail.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Feb 19, 2017 at 07:03:38PM +0900, Hoeun Ryu wrote:
>  After `__ro_after_init` marker is included in kernel, many kernel data
> objects can be read-only-after-init. But there are many other places that
> would be good to read-only-after-init but `__ro_after_init` can not be simply
> applicable to them because they should be writable at some points, which are
> during module_init/exit or dynamic de/registration for a specific subsystem.

Could you elaborate on this?

For modules, I assume that the __ro_after_init data structures are part
of the module, and not part of the "real" kernel image. Is that the case?

Which specific subsystems whish to modify data structures that are
__ro_after_init?

This sounds like the proposed mostly-ro/rarely-rw stuff would be a
better fit for that case.

Thanks,
Mark.

>  `__ro_mostly_after_init` is basically the same to `__ro_after_init`. The
> section is mapped as read-only after kernel init. The different thing is
> this section is temporarily mapped as read-write during module_init/exit and
> de/registration of a subsystem using set_ro_mostly_after_init_rw/ro pair.
> 
> - Tested only on arm64.
> 
> Description:
>   0001 patch is `__ro_mostly_after_init` itself.
>   0002 patch is to add set_ro_mostly_after_init_rw/ro pair using
>     set_memory_rw/ro.
>   0003 patch is to make the section read-write in module_init/exit.
>   0004 patch is an example for dynamic init/deinit of a subsystem.
>   0005 patch is an example for __ro_mostly_after_init section modified during
>     module_init/exit.
>   0006/0007 patches are fixes for arm64 kernel mapping.
> 
> Hoeun Ryu (7):
>   arch: add __ro_mostly_after_init section marker
>   init: add set_ro_mostly_after_init_rw/ro function
>   module: modify memory attrs for __ro_mostly_after_init during
>     module_init/exit
>   selinux: mark __ro_mostly_after_init for selinux_hooks/selinux_nf_ops
>   cpu: mark ro_mostly_after_init for cpuhp_ap/bp_states
>   arm64: add __map_kernel_segment to accept additional vm flags
>   arm64: map seperately rodata sections for __ro_mostly_after_init
>     section
> 
>  arch/arm64/mm/mmu.c               | 44 ++++++++++++++++++++++++++++++++-------
>  include/asm-generic/sections.h    |  1 +
>  include/asm-generic/vmlinux.lds.h | 10 +++++++++
>  include/linux/cache.h             | 11 ++++++++++
>  include/linux/init.h              |  6 ++++++
>  init/main.c                       | 24 +++++++++++++++++++++
>  kernel/cpu.c                      |  4 ++--
>  kernel/module.c                   | 10 +++++++--
>  security/selinux/hooks.c          |  8 +++++--
>  9 files changed, 105 insertions(+), 13 deletions(-)
> 
> -- 
> 2.7.4
> 
