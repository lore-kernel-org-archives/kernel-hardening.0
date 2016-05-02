Reply-To: kernel-hardening@lists.openwall.com
From: Thomas Garnier <thgarnie@google.com>
Date: Mon,  2 May 2016 14:41:12 -0700
Message-Id: <1462225276-106993-1-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v2 0/4] x86, boot: KASLR memory implementation
To: "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Thomas Garnier <thgarnie@google.com>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Kees Cook <keescook@chromium.org>, Stephen Smalley <sds@tycho.nsa.gov>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, gthelen@google.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is PATCH v2 for KASLR memory implementation for x86_64. Edit commit
based on recents testing against the KASLR bypass exploits & rebase on
next-20160502.

***Background:
The current implementation of KASLR randomizes only the base address of
the kernel and its modules. Research was published showing that static
memory can be overwitten to elevate privileges bypassing KASLR.

In more details:

    The physical memory mapping holds most allocations from boot and heap
    allocators. Knowning the base address and physical memory size, an
    attacker can deduce the PDE virtual address for the vDSO memory page.
    This attack was demonstrated at CanSecWest 2016, in the "Getting
    Physical Extreme Abuse of Intel Based Paged Systems"
    https://goo.gl/ANpWdV (see second part of the presentation). Similar
    research was done at Google leading to this patch proposal. Variants
    exists to overwrite /proc or /sys objects ACLs leading to elevation of
    privileges. These variants were tested against 4.6+.

This set of patches randomizes base address and padding of three
major memory sections (physical memory mapping, vmalloc & vmemmap).
It mitigates exploits relying on predictable kernel addresses. This
feature can be enabled with the CONFIG_RANDOMIZE_MEMORY option.

Padding for the memory hotplug support is managed by
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING. The default value is 10
terabytes.

The patches were tested on qemu & physical machines. Xen compatibility was
also verified. Multiple reboots were used to verify entropy for each
memory section.

***Problems that needed solving:
 - The three target memory sections are never at the same place between
   boots.
 - The physical memory mapping can use a virtual address not aligned on
   the PGD page table.
 - Have good entropy early at boot before get_random_bytes is available.
 - Add optional padding for memory hotplug compatibility.

***Parts:
 - The first part prepares for the KASLR memory randomization by
   refactoring entropy functions used by the current implementation and
   support PUD level virtual addresses for physical mapping.
   (Patches 01-02)
 - The second part implements the KASLR memory randomization for all
   sections mentioned.
   (Patch 03)
 - The third part adds support for memory hotplug by adding an option to
   define the padding used between the physical memory mapping section
   and the others.
   (Patch 04)

Thanks!
