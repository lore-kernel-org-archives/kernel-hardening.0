From: Bhupesh Sharma <bhsharma@redhat.com>
Date: Thu,  2 Feb 2017 11:12:46 +0530
Message-Id: <1486014168-1279-1-git-send-email-bhsharma@redhat.com>
Subject: [kernel-hardening] [PATCH 0/2] RFC: Adjust powerpc ASLR elf randomness
To: linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com
Cc: dcashman@google.com, mpe@ellerman.id.au, bhupesh.linux@gmail.com, keescook@chromium.org, Bhupesh Sharma <bhsharma@redhat.com>, Alexander Graf <agraf@suse.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Anatolij Gustschin <agust@denx.de>, Alistair Popple <alistair@popple.id.au>, Matt Porter <mporter@kernel.crashing.org>, Vitaly Bordug <vitb@kernel.crashing.org>, Scott Wood <oss@buserror.net>, Kumar Gala <galak@kernel.crashing.org>, Daniel Cashman <dcashman@android.com>
List-ID: <kernel-hardening.lists.openwall.com>

This RFC patchset tries to make the powerpc ASLR elf randomness
implementation similar to other ARCHs (like x86).

The 1st patch introduces the support of ARCH_MMAP_RND_BITS in powerpc
mmap implementation to allow a sane balance between increased randomness
in the mmap address of ASLR elfs and increased address space
fragmentation.

The 2nd patch increases the ELF_ET_DYN_BASE value from the current
hardcoded value of 0x2000_0000 to something more practical,
i.e. TASK_SIZE - PAGE_SHIFT (which makes sense especially for
64-bit platforms which would like to utilize more randomization
in the load address of a PIE elf).

I have tested this patchset on 64-bit Fedora and RHEL7 machines/VMs.
Here are the test results and details of the test environment:

1. Create a test PIE program which shows its own memory map:

$ cat show_mmap_pie.c
#include <stdlib.h>
#include <stdio.h>

int main(void){
    char command[1024];
    sprintf(command,"cat /proc/%d/maps",getpid());
    system(command);
    return 0;
}

2. Compile it as a PIE:

$ gcc -o show_mmap_pie -fpie -pie show_mmap_pie.c

3. Before this patchset (on a Fedora-25 PPC64 POWER7 machine):

# ./show_mmap_pie
33dd0000-33de0000 r-xp 00000000 fd:00 1724816                            /root/git/linux/show_mmap_pie
33de0000-33df0000 r--p 00000000 fd:00 1724816                            /root/git/linux/show_mmap_pie
33df0000-33e00000 rw-p 00010000 fd:00 1724816                            /root/git/linux/show_mmap_pie
3fff9d750000-3fff9d940000 r-xp 00000000 fd:00 2753176                    /usr/lib64/power7/libc-2.23.so
3fff9d940000-3fff9d950000 ---p 001f0000 fd:00 2753176                    /usr/lib64/power7/libc-2.23.so
3fff9d950000-3fff9d960000 r--p 001f0000 fd:00 2753176                    /usr/lib64/power7/libc-2.23.so
3fff9d960000-3fff9d970000 rw-p 00200000 fd:00 2753176                    /usr/lib64/power7/libc-2.23.so
3fff9d980000-3fff9d9a0000 r-xp 00000000 00:00 0                          [vdso]
3fff9d9a0000-3fff9d9e0000 r-xp 00000000 fd:00 2625136                    /usr/lib64/ld-2.23.so
3fff9d9e0000-3fff9d9f0000 r--p 00030000 fd:00 2625136                    /usr/lib64/ld-2.23.so
3fff9d9f0000-3fff9da00000 rw-p 00040000 fd:00 2625136                    /usr/lib64/ld-2.23.so
3ffff5280000-3ffff52b0000 rw-p 00000000 00:00 0                          [stack]

As one can notice, the load address even for a 64-bit binary
(show_mmap_pie), is within the 32-bit range.

4. After this patchset (on a Fedora-25 PPC64 POWER7 machine):

# ./show_mmap_pie
3fffad250000-3fffad440000 r-xp 00000000 fd:00 2753176                    /usr/lib64/power7/libc-2.23.so
3fffad440000-3fffad450000 ---p 001f0000 fd:00 2753176                    /usr/lib64/power7/libc-2.23.so
3fffad450000-3fffad460000 r--p 001f0000 fd:00 2753176                    /usr/lib64/power7/libc-2.23.so
3fffad460000-3fffad470000 rw-p 00200000 fd:00 2753176                    /usr/lib64/power7/libc-2.23.so
3fffad480000-3fffad4a0000 r-xp 00000000 00:00 0                          [vdso]
3fffad4a0000-3fffad4e0000 r-xp 00000000 fd:00 2625136                    /usr/lib64/ld-2.23.so
3fffad4e0000-3fffad4f0000 r--p 00030000 fd:00 2625136                    /usr/lib64/ld-2.23.so
3fffad4f0000-3fffad500000 rw-p 00040000 fd:00 2625136                    /usr/lib64/ld-2.23.so
3fffad500000-3fffad510000 r-xp 00000000 fd:00 1724816                    /root/git/linux/show_mmap_pie
3fffad510000-3fffad520000 r--p 00000000 fd:00 1724816                    /root/git/linux/show_mmap_pie
3fffad520000-3fffad530000 rw-p 00010000 fd:00 1724816                    /root/git/linux/show_mmap_pie
3fffe3110000-3fffe3140000 rw-p 00000000 00:00 0                          [stack]

The load address of the elf is now pushed to be in a 64-bit range.

As I have access to limited number of powerpc machines, request folks
having powerpc platforms to try this patchset and share their
test results/issues as well.

Cc: Alexander Graf <agraf@suse.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Anatolij Gustschin <agust@denx.de>
Cc: Alistair Popple <alistair@popple.id.au>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: Scott Wood <oss@buserror.net>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Daniel Cashman <dcashman@android.com>
Cc: Kees Cook <keescook@chromium.org>

Bhupesh Sharma (2):
  powerpc: mm: support ARCH_MMAP_RND_BITS
  powerpc: Redefine ELF_ET_DYN_BASE

 arch/powerpc/Kconfig           | 34 ++++++++++++++++++++++++++++++++++
 arch/powerpc/include/asm/elf.h |  2 +-
 arch/powerpc/mm/mmap.c         |  7 ++++---
 3 files changed, 39 insertions(+), 4 deletions(-)

-- 
2.7.4
