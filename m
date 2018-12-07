From: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
Subject: [PATCH V7 0/10] KVM: X86: Introducing ROE Protection Kernel Hardening
Date: Fri,  7 Dec 2018 14:47:53 +0200
Message-Id: <20181207124803.10828-1-ahmedsoliman@mena.vt.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, ahmedsoliman0x666@gmail.com, ovich00@gmail.com, kernel-hardening@lists.openwall.com, nigel.edwards@hpe.com, Boris Lukashev <blukashev@sempervictus.com>, Igor Stoppa <igor.stoppa@gmail.com>
Cc: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
List-ID: <kernel-hardening.lists.openwall.com>

-- Summary --

ROE is a hypercall that enables host operating system to restrict guest's access
to its own memory. This will provide a hardening mechanism that can be used to
stop rootkits from manipulating kernel static data structures and code. Once a
memory region is protected the guest kernel can't even request undoing the
protection.

Memory protected by ROE should be non-swapable because even if the ROE protected
page got swapped out, It won't be possible to write anything in its place.

ROE hypercall should be capable of either protecting a whole memory frame or
parts of it. With these two, it should be possible for guest kernel to protect
its memory and all the page table entries for that memory inside the page table.
I am still not sure whether this should be part of ROE job or the guest's job.


The reason why it would be better to implement this from inside kvm: instead of
(host) user space is the need to access SPTEs to modify the permissions, while
mprotect() from user space can work in theory. It will become a big performance
hit to vmexit and switch to user space mode on each fault, on the other hand,
having the permission handled by EPT should make some remarkable performance
gain.

Our threat model assumes that an attacker got full root access to a running
guest and his goal is to manipulate kernel code/data (hook syscalls, overwrite
IDT ..etc).

There is future work in progress to also put some sort of protection on the page
table register CR3 and other critical registers that can be intercepted by KVM.
This way it won't be possible for an attacker to manipulate any part of the
guests page table.


-- Test Case --

I was requested to add a test to tools/testing/selftests/kvm/. But the original
testing suite didn't work for my machine, I experienced shutdown due to triple
fault because of EPT fault with the current tests. I tried bisecting but the
triple fault was there from the very first commit.

So instead I would provide here a demo kernel module to test the current
implementation:

```
	#include <linux/init.h>
	#include <linux/module.h>
	#include <linux/kernel.h>
	#include <linux/slab.h>
	#include <linux/kvm_para.h>
	#include <linux/mm.h>
	MODULE_LICENSE("GPL");
	MODULE_AUTHOR("OddCoder");
	MODULE_DESCRIPTION("ROE Hello world Module");
	MODULE_VERSION("0.0.1");

	#define KVM_HC_ROE 11
	#define ROE_VERSION 0
	#define ROE_MPROTECT 1
	#define ROE_MPROTECT_CHUNK 2

	static long roe_version(void){
		return kvm_hypercall1 (KVM_HC_ROE, ROE_VERSION);
	}

	static long roe_mprotect(void *addr, long pg_count) {
		return kvm_hypercall3 (KVM_HC_ROE, ROE_MPROTECT, (u64)addr, pg_count);
	}

	static long roe_mprotect_chunk(void *addr, long size) {
		return kvm_hypercall3 (KVM_HC_ROE, ROE_MPROTECT_CHUNK, (u64)addr, size);
	}

 	static int __init hello(void ) {
		int x;
		struct page *pg1, *pg2;
		void *memory;
		pg1 = alloc_page(GFP_KERNEL);
		pg2 = alloc_page(GFP_KERNEL);
		memory = page_to_virt(pg1);
		pr_info ("ROE_VERSION: %ld\n", roe_version());
		pr_info ("Allocated memory: 0x%llx\n", (u64)memory);
		pr_info("Physical Address: 0x%llx\n", virt_to_phys(memory));
		strcpy((char *)memory, "ROE PROTECTED");
		pr_info("memory_content: %s\n", (char *)memory);
		x = roe_mprotect((void *)memory, 1);
		strcpy((char *)memory, "The strcpy should silently fail and"
					"memory content won't be modified");
		pr_info("memory_content: %s\n", (char *)memory);
		memory = page_to_virt(pg2);
		pr_info ("Allocated memory: 0x%llx\n", (u64)memory);
		pr_info("Physical Address: 0x%llx\n", virt_to_phys(memory));
		strcpy((char *)memory, "ROE PROTECTED PARTIALLY");
		roe_mprotect_chunk((void *)memory, strlen((char *)memory));
		pr_info("memory_content: %s\n", (char *)memory);
		strcpy((char *)memory, "XXXXXXXXXXXXXXXXXXXXXXX"
					" <- Text here not modified still Can concat");
		pr_info("memory_content: %s\n", (char *)memory);
		return 0;
	}
	static void __exit bye(void) {
		pr_info("Allocated Memory May never be freed at all!\n");
		pr_info("Actually this is more of an ABI demonstration\n");
		pr_info("than actual use case\n");
		}
	module_init(hello);
	module_exit(bye);

```

I tried this on Gentoo host with Ubuntu guest and Qemu from git after applying
the following changes to Qemu

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 4880a05399..57d0973aca 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2035,6 +2035,9 @@ int kvm_cpu_exec(CPUState *cpu)
                              run->mmio.is_write);
             ret = 0;
             break;
+	case KVM_EXIT_ROE:
+	    ret = 0;
+	    break;
         case KVM_EXIT_IRQ_WINDOW_OPEN:
             DPRINTF("irq_window_open\n");
             ret = EXCP_INTERRUPT;
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index f11a7eb49c..67aded8f00 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -235,7 +235,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_S390_STSI        25
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
-
+#define KVM_EXIT_ROE              28
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
 #define KVM_INTERNAL_ERROR_EMULATION	1



-- Change log V6 -> V7 --

- Completely remove CONFIG_KVM_ROE, ROE is always enabled, since it is opt in
  anyway.
- Bug fixes regarding how each element in the protection bitmap maps to the
  equivalent SPTE.
- General Code cleaning.


-- Known Issues --

- THP is not supported yet. In general it is not supported when the guest frame
  size is not the same as the equivalent EPT frame size.

The previous version (V6) of the patch set can be found at [1]

-- links --

[1] https://lkml.org/lkml/2018/11/4/417

-- List of patches --

[PATCH V7 01/10] KVM: State whether memory should be freed in
[PATCH V7 02/10] KVM: X86: Add arbitrary data pointer in kvm memslot
[PATCH V7 03/10] KVM: X86: Add helper function to convert SPTE to GFN
[PATCH V7 04/10] KVM: Document Memory ROE
[PATCH V7 05/10] KVM: Create architecture independent ROE skeleton
[PATCH V7 06/10] KVM: X86: Enable ROE for x86
[PATCH V7 07/10] KVM: Add support for byte granular memory ROE
[PATCH V7 08/10] KVM: X86: Port ROE_MPROTECT_CHUNK to x86
[PATCH V7 09/10] KVM: Add new exit reason For ROE violations
[PATCH V7 10/10] KVM: Log ROE violations in system log


-- Difstat --

 Documentation/virtual/kvm/hypercalls.txt |  40 ++++
 arch/x86/include/asm/kvm_host.h          |   2 +-
 arch/x86/kvm/Makefile                    |   4 +-
 arch/x86/kvm/mmu.c                       | 121 +++++------
 arch/x86/kvm/mmu.h                       |  31 ++-
 arch/x86/kvm/roe.c                       | 104 ++++++++++
 arch/x86/kvm/roe_arch.h                  |  28 +++
 arch/x86/kvm/x86.c                       |  21 +-
 include/kvm/roe.h                        |  28 +++
 include/linux/kvm_host.h                 |  25 +++
 include/uapi/linux/kvm.h                 |   2 +-
 include/uapi/linux/kvm_para.h            |   5 +
 virt/kvm/kvm_main.c                      |  56 +++--
 virt/kvm/roe.c                           | 342 +++++++++++++++++++++++++++++++
 virt/kvm/roe_generic.h                   |  18 ++
 15 files changed, 732 insertions(+), 95 deletions(-)

Signed-off-by: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
