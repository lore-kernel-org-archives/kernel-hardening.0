From: Marc Zyngier <marc.zyngier@arm.com>
In-Reply-To: <20171026134547.23664-2-pbonzini@redhat.com> (Paolo Bonzini's
	message of "Thu, 26 Oct 2017 15:45:46 +0200")
References: <20171026134547.23664-1-pbonzini@redhat.com>
	<20171026134547.23664-2-pbonzini@redhat.com>
Date: Thu, 26 Oct 2017 15:34:38 +0100
Message-ID: <86h8umasg1.fsf@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH 1/2] kvm: whitelist struct kvm_vcpu_arch
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Cornelia Huck <cohuck@redhat.com>, James Hogan <james.hogan@imgtec.com>, Paul Mackerras <paulus@samba.org>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Christian Borntraeger <borntraeger@redhat.com>, Christoffer Dall <cdall@linaro.org>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 26 2017 at  3:45:46 pm BST, Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
> On x86, ARM and s390, struct kvm_vcpu_arch has a usercopy region
> taht is read and written by the KVM_GET/SET_CPUID2 ioctls (x86)
> or KVM_GET/SET_ONE_REG (ARM/s390).  Without whitelisting the area,
> KVM is completely broken on those architectures with usercopy hardening
> enabled.
>
> For now, allow writing to the entire struct on all architectures.
> The KVM tree will not refine this to an architecture-specific
> subset of struct kvm_vcpu_arch.
>
> Cc: kernel-hardening@lists.openwall.com
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Christian Borntraeger <borntraeger@redhat.com>
> Cc: Christoffer Dall <cdall@linaro.org>
> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
--=20
Jazz is not dead. It just smells funny.
