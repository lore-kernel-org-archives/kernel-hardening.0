Reply-To: kernel-hardening@lists.openwall.com
From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 12 May 2016 12:28:16 -0700
Message-Id: <1463081300-11127-1-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v5 0/4] x86, boot: KASLR memory randomization
To: "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Thomas Garnier <thgarnie@google.com>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Kees Cook <keescook@chromium.org>, Stephen Smalley <sds@tycho.nsa.gov>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, gthelen@google.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is PATCH v5 for KASLR memory implementation for x86_64.

Recent changes:
    Add performance information on commit.
    Add details on PUD alignment.
    Add information on testing against the KASLR bypass exploit.
    Rebase on next-20160511 and merge recent KASLR changes.
    Integrate feedback from Kees.

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
   https://goo.gl/ANpWdV (see second part of the presentation). The
   exploits used against Linux worked successfuly against 4.6+ but fail
   with KASLR memory enabled (https://goo.gl/iTtXMJ). Similar research
   was done at Google leading to this patch proposal. Variants exists to
   overwrite /proc or /sys objects ACLs leading to elevation of privileges.
   These variants were tested against 4.6+.

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

Performance data:

Kernbench shows almost no difference (-+ less than 1%):

Before:

Average Optimal load -j 12 Run (std deviation):
Elapsed Time 102.63 (1.2695)
User Time 1034.89 (1.18115)
System Time 87.056 (0.456416)
Percent CPU 1092.9 (13.892)
Context Switches 199805 (3455.33)
Sleeps 97907.8 (900.636)

After:

Average Optimal load -j 12 Run (std deviation):
Elapsed Time 102.489 (1.10636)
User Time 1034.86 (1.36053)
System Time 87.764 (0.49345)
Percent CPU 1095 (12.7715)
Context Switches 199036 (4298.1)
Sleeps 97681.6 (1031.11)

Hackbench shows 0% difference on average (hackbench 90
repeated 10 times):

attemp,before,after
1,0.076,0.069
2,0.072,0.069
3,0.066,0.066
4,0.066,0.068
5,0.066,0.067
6,0.066,0.069
7,0.067,0.066
8,0.063,0.067
9,0.067,0.065
10,0.068,0.071
average,0.0677,0.0677

Thanks!
