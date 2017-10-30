Date: Mon, 30 Oct 2017 16:28:49 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20171030232849.GA8409@gmail.com>
References: <20171026134547.23664-1-pbonzini@redhat.com>
 <20171026134547.23664-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171026134547.23664-2-pbonzini@redhat.com>
Subject: Re: [kernel-hardening] [PATCH 1/2] kvm: whitelist struct
 kvm_vcpu_arch
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Cornelia Huck <cohuck@redhat.com>, James Hogan <james.hogan@imgtec.com>, Paul Mackerras <paulus@samba.org>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Christian Borntraeger <borntraeger@redhat.com>, Christoffer Dall <cdall@linaro.org>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 26, 2017 at 03:45:46PM +0200, Paolo Bonzini wrote:
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
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4d81f6ded88e..b4809ccfdfa1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4005,8 +4005,12 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  	/* A kmem cache lets us meet the alignment requirements of fx_save. */
>  	if (!vcpu_align)
>  		vcpu_align = __alignof__(struct kvm_vcpu);
> -	kvm_vcpu_cache = kmem_cache_create("kvm_vcpu", vcpu_size, vcpu_align,
> -					   0, NULL);
> +	kvm_vcpu_cache =
> +		kmem_cache_create_usercopy("kvm_vcpu",
> +					   sizeof(struct kvm_vcpu), vcpu_align,
> +					   0, offsetof(struct kvm_vcpu, arch),
> +					   sizeof_field(struct kvm_vcpu, arch),
> +					   NULL);

Doesn't it need to be 'vcpu_size' instead of 'sizeof(struct kvm_vcpu)'?

Eric
