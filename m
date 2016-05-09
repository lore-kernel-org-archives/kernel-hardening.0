Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Mon,  9 May 2016 13:22:03 -0700
Message-Id: <1462825332-10505-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v7 0/9] x86/KASLR: Randomize virtual address separately
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Okay, here's the remaining patches for this series. Hopefully these
are clean and obvious. Technically this is v7 of the series, though
much of it has already been added to -tip already. This is all based on
the work of Yinghai, Baoquan, and myself.

***Background:
Bugs have been reported around kdump, kexec, and some netboot situations
that didn't work when KASLR was enabled. While discussing the bugs, it
was found that the current KASLR implementation had various limitations,
but most importantly that it can only randomize in a 1GB region of
physical memory.

The current KASLR implementaion only randomizes the base physical
address of the kernel. If the delta from build-time load address and
KASLR run-time load address (i.e. the physical address of where the
kernel actually decompressed) is not equal to 0, relocation handling is
performed using the delta. Though in principle kernel can be randomized
to any physical address, the physical kernel text mapping address space
is limited to 1G and the virtual address is just offset by the same
amount. On x86_64 the result is the following range:
[0xffffffff80000000, 0xffffffffc0000000)

hpa and Vivek suggested we should change this by decoupling the physical
address and virtual address randomization of kernel text and let them work
separately. Then kernel text physical address can be randomized in region
[16M, 64T), and kernel text virtual address can be randomized in region
[0xffffffff80000000, 0xffffffffc0000000).

***Problems that needed solving:
  - When booting from the startup_32 case, only a 0~4G identity mapping is
    built. If kernel will be randomly put anywhere from 16M to 64T at
    most, the price to build all the identity mappings is too high. We
    need to build the identity mapping on demand, not covering all of the
    physical address space. (The infrastructure for solving this has
    already landed in -tip now.)

  - Decouple the physical address and virtual address randomization of kernel
    text and let them work separately.

  - Kernels loaded high will not randomize into a lower memory region.

***Parts:
   - The 1st part includes a bug fix and clean ups.
     (Patches 1-2)
   - The 2nd part is Baoquan's new randomization slot management code for
     handling the much larger possible memory space.
     (Patches 3-4)
   - The 4th part is Baoquan's decoupling the physical address and virtual
     address randomization of kernel text and letting them work separately,
     based on Yinghai's ident mapping patches, fixing problem #2 above.
     (Patches 5-7)
   - The 5th part lifts the upper and lower limits on physical addresses,
     fixing problem #3 above.
     (Patches 8-9)

I've boot tested this a bunch on 32-bit and 64-bit, and things appear to
be working as expected. I've cleaned up the changelogs, improved some
comments, refactored a few things, split out things and merged others,
etc. Changes are noted in the individual changelogs.

Thanks!

-Kees

v6->v7:
- general refactoring to adapt to changing casts, etc in earlier patches.
- found and fixed a typo in my refactorings that was obscuring a bug in
  my changes to the page table ident mapping code (physical address was
  never being added to identity maps).
- found some more file header comments to add, fixed mem_avoid comment typo.

v5->v6:
- sent other clean-ups as separate patches
- squashed code removal into the patches that made them removable
- refactoring slot calculation to avoid the confusing "if" statement
- protected slot_area_index in store_slot_info to be paranoid
- adjusted Kconfig language to be more complete but with hopefully less jargon
- fixed up as much of the unsigned long casts as possible
- fixed some coding styel on brace usage
- made find_random_phys_addr look like find_random_virt_addr
- clarified various variable names

v4->v5:
- rewrote all the changelogs, and several comments.
- refactored e820 parser to use a while loop instead of goto.
- rearranged removal of CONFIG_RANDOMIZE_BASE_MAX_OFFSET to earlier.
- additionally dropped KERNEL_IMAGE_SIZE_DEFAULT
- refactored minimum address calculation
- refactored slot offset calculation for readability
- fixed 32-bit boot failures
- fixed CONFIG_RANDOMIZE_BASE=n boot failure
- improved debug reporting

[Baoquan's histroy]
v3->v4:
- Made changes according to Kees's comments.
  Add one patch 20/20 as Kees suggested to use KERNEL_IMAGE_SIZE as offset
  max of virtual random, meanwhile clean up useless CONFIG_RANDOM_OFFSET_MAX

    x86, kaslr: Use KERNEL_IMAGE_SIZE as the offset max for kernel virtual randomization

v2->v3:
- It only takes care of the kaslr related patches.
  For reviewers it's better to discuss only one issue in one thread.
    * I take off one patch as follows from Yinghai's because I think it's unnecessay.
       - Patch 05/19 x86, kaslr: rename output_size to output_run_size
         output_size is enough to represen the value:
            output_len > run_size ? output_len : run_size

    * I add Patch 04/19, it's a comment update patch. For other patches, I just
      adjust patch log and do several places of change comparing with 2nd round.
      Please check the change log under patch log of each patch for details.

    * Adjust sequence of several patches to make review easier. It doesn't
      affect codes.

v1->v2:
- In 2nd round Yinghai made a big patchset including this kaslr fix and another
  setup_data related fix. The link is here:
   http://lists-archives.com/linux-kernel/28346903-x86-updated-patches-for-kaslr-and-setup_data-etc-for-v4-3.html
  You can get the code from Yinghai's git branch:
  git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-v4.3-next

v1:
- The first round can be found here:
    https://lwn.net/Articles/637115/
