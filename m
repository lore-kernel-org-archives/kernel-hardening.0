Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 26 Oct 2017 15:45:45 +0200
Message-Id: <20171026134547.23664-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH v2 0/2] KVM: fixes for the kernel-hardening tree
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Cornelia Huck <cohuck@redhat.com>, James Hogan <james.hogan@imgtec.com>, Paul Mackerras <paulus@samba.org>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

Four KVM ioctls (KVM_GET/SET_CPUID2 on x86, KVM_GET/SET_ONE_REG on
ARM and s390) directly access the kvm_vcpu_arch struct.  Therefore, the
new usercopy hardening work in linux-next, which forbids copies from and
to slab objects unless they are from kmalloc or explicitly whitelisted,
breaks KVM on those architectures.

The kvm_vcpu_arch struct is embedded in the kvm_vcpu struct and the
corresponding slab cache is allocated by architecture-independent code.
It is enough, for simplicity, to whitelist the whole sub-struct and
only touch one place of the KVM code.  Later, any further restrictions
can be applied in the KVM tree.

Paolo Bonzini (2):
  kvm: whitelist struct kvm_vcpu_arch
  kvm: x86: fix KVM_XEN_HVM_CONFIG ioctl

 arch/x86/kvm/x86.c  | 7 ++++---
 virt/kvm/kvm_main.c | 8 ++++++--
 2 files changed, 10 insertions(+), 5 deletions(-)

-- 
2.14.2
