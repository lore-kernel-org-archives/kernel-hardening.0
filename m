From: Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>
Subject: Memory Read Only Enforcement: VMM assisted kernel rootkit mitigation for KVM V4
Date: Sat, 21 Jul 2018 01:31:27 +0200
Message-Id: <20180720233130.14129-1-ahmedsoliman0x666@gmail.com>
To: kvm@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org, x86@kernel.org, xen-devel@lists.xensource.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, nathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, hpa@zytor.com, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Hildenbrand <david@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, David Vrabel <david.vrabel@nutanix.com>, nigel.edwards@hpe.com, Rik van Riel <riel@surriel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Here is change log from V3 To V4:
- Fixing spelling/grammar mistakes suggested by Randy Dunlap
- Changing the hypercall interface to be able to process multiple pages
  per one hypercall also suggested by Randy Dunlap. It turns out that
  this will save lots of vmexist/memory slot flushes when protecting many
  pages.

[PATCH RFC V4 1/3] KVM: X86: Memory ROE documentation
[PATCH RFC V4 2/3] KVM: X86: Adding arbitrary data pointer in kvm memslot iterator functions
[PATCH RFC V4 3/3] KVM: X86: Adding skeleton for Memory ROE

Summary:

 Documentation/virtual/kvm/hypercalls.txt |  14 ++++
 arch/x86/include/asm/kvm_host.h          |  11 ++-
 arch/x86/kvm/Kconfig                     |   7 ++
 arch/x86/kvm/mmu.c                       | 127 ++++++++++++++++++++++---------
 arch/x86/kvm/x86.c                       | 104 ++++++++++++++++++++++++-
 include/linux/kvm_host.h                 |   3 +
 include/uapi/linux/kvm_para.h            |   1 +
 virt/kvm/kvm_main.c                      |  29 ++++++-
 8 files changed, 254 insertions(+), 42 deletions(-)
