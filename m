Date: Fri, 27 Oct 2017 16:25:03 +1100
From: Paul Mackerras <paulus@ozlabs.org>
Message-ID: <20171027052503.GB27483@fergus.ozlabs.ibm.com>
References: <20171026134547.23664-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171026134547.23664-1-pbonzini@redhat.com>
Subject: [kernel-hardening] Re: [PATCH v2 0/2] KVM: fixes for the kernel-hardening tree
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Cornelia Huck <cohuck@redhat.com>, James Hogan <james.hogan@imgtec.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 26, 2017 at 03:45:45PM +0200, Paolo Bonzini wrote:
> Four KVM ioctls (KVM_GET/SET_CPUID2 on x86, KVM_GET/SET_ONE_REG on
> ARM and s390) directly access the kvm_vcpu_arch struct.  Therefore, the
> new usercopy hardening work in linux-next, which forbids copies from and
> to slab objects unless they are from kmalloc or explicitly whitelisted,
> breaks KVM on those architectures.
> 
> The kvm_vcpu_arch struct is embedded in the kvm_vcpu struct and the
> corresponding slab cache is allocated by architecture-independent code.
> It is enough, for simplicity, to whitelist the whole sub-struct and
> only touch one place of the KVM code.  Later, any further restrictions
> can be applied in the KVM tree.

I checked arch/powerpc/kvm, and all the copy_to/from_user calls are
accessing the stack or memory allocated with kzalloc or kvzalloc, so
if I understand correctly, we should be OK there.

Paul.
