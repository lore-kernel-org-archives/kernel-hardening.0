Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Apr 2016 15:28:53 -0700
Message-Id: <1460672954-32567-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 00/21] x86, boot: KASLR cleanup and 64-bit improvements
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

This is v5 of the x86 KASLR improvement series from Yinghai, Baoquan,
and myself. The current branch lives here:
http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=kaslr/highmem

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
    most, the price to build all region of identity mapping is too high.
    We need build the identity mapping on demand, not covering all
    physical address space.

  - Decouple the physical address and virtual address randomization of kernel
    text and let them work separately.

***Parts:
   - The 1st part is clean-up and improvements to help the rest of the series.
     (Patches 01-10)
   - The 2nd part is Yinghai's building of identity mappings on demand.
     This is used to solve the first problem mentioned above.
     (Patches 11-12)
   - The 3rd part is Baoquan's decoupling the physical address and virtual
     address randomization of kernel text and letting them work separately,
     based on Yinghai's ident mapping patches.
     (Patches 13-21)

I've boot tested this a bunch on 32-bit and 64-bit, and things appear
to be working as expected. I've cleaned up the changelogs, improved
some comments, refactored a few things, etc. Changes are noted in the
individual changelogs.

Thanks!

-Kees

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
