From: Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>
Subject: Read Only Enforcement patches V4 [VMM based kernel hardening]
Date: Sun, 21 Oct 2018 00:21:22 +0200
Message-Id: <20181020222127.6368-1-ahmedsoliman0x666@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, ahmedsoliman0x666@gmail.com, Ovich00@gmail.com, kernel-hardening@lists.openwall.com, nigel.edwards@hpe.com, Boris Lukashev <blukashev@sempervictus.com>, Hossam Hassan <7ossam9063@gmail.com>, Ahmed Lotfy <A7med.lotfey@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

This is the 4th version and the most complete one. ROE is a hypercall
that enables host operating system to restrict guest's access to its own memory.
This will provide a hardening mechanism that can be used to stop rootkits from
manipulating kernel static data structures and code. Once a memory region is
protected the guest kernel can't even request undoing the protection.

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

Our model assumes that an attacker got full root access to a running guest and
his goal is to manipulate kernel code/data (hook syscalls, overwrite IDT ..etc).

There is future work in progress to also put some sort of protection on the page
table register CR3 and other critical registers that can be intercepted by KVM.
This way it won't be possible for an attacker to manipulate any part of the
guests page table.

Summary:

Documentation/virtual/kvm/hypercalls.txt | 40 -----
arch/x86/include/asm/kvm_host.h | 11 +-
arch/x86/kvm/Kconfig | 7 -
arch/x86/kvm/mmu.c | 129 ++++----------
arch/x86/kvm/x86.c | 281 +------------------------------
include/linux/kvm_host.h | 29 ----
include/uapi/linux/kvm_para.h | 5 -
virt/kvm/kvm_main.c | 119 ++-----------
8 files changed, 50 insertions(+), 571 deletions(-)
