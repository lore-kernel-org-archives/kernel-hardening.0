Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 29 Jul 2011 13:27:12 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110729092712.GA7727@albatros>
References: <20110723162251.GA11485@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110723162251.GA11485@openwall.com>
Subject: Re: [kernel-hardening] base address for shared libs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Sat, Jul 23, 2011 at 20:22 +0400, Solar Designer wrote:
> At least on rhel5/openvz kernels, 32-bit processes get their shared libs
> loaded at different kinds of addresses on i686 vs. x86_64 kernels.

Looking into RHEL6 kernel:

    void arch_pick_mmap_layout(struct mm_struct *mm)
    {
        ...
            if (!(current->personality & READ_IMPLIES_EXEC)
                && mmap_is_ia32())
                mm->get_unmapped_exec_area = arch_get_unmapped_exec_area;
        ...
    }

    #define SHLIB_BASE	0x00110000

    unsigned long
    arch_get_unmapped_exec_area(struct file *filp, unsigned long addr0,
            unsigned long len0, unsigned long pgoff, unsigned long flags)
    {
        ...
        if (!addr)
            addr = !should_randomize() ? SHLIB_BASE :
                randomize_range(SHLIB_BASE, 0x01000000, len);
        ...
    }

Looks like it is considered as a way to easily mmap libraries in CS
limited area by exec-shield, and not as a C-string barrier.


The comment says the common bottom-up doesn't support randomization:

    /*
     * Bottom-up (legacy) layout on X86_32 did not support randomization, X86_64
     * does, but not when emulating X86_32
     */

So, IMO the bottom-up layout allocator should be patched.


Thanks,

-- 
Vasiliy
