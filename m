Date: Thu, 26 Oct 2017 16:13:42 +0200
From: Cornelia Huck <cohuck@redhat.com>
Message-ID: <20171026161242.017bcb9b.cohuck@redhat.com>
In-Reply-To: <20171026134547.23664-2-pbonzini@redhat.com>
References: <20171026134547.23664-1-pbonzini@redhat.com>
	<20171026134547.23664-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH 1/2] kvm: whitelist struct kvm_vcpu_arch
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, Paul Mackerras <paulus@samba.org>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Christoffer Dall <cdall@linaro.org>, Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 26 Oct 2017 15:45:46 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On x86, ARM and s390, struct kvm_vcpu_arch has a usercopy region
> taht is read and written by the KVM_GET/SET_CPUID2 ioctls (x86)
> or KVM_GET/SET_ONE_REG (ARM/s390).  Without whitelisting the area,
> KVM is completely broken on those architectures with usercopy hardening
> enabled.
>=20
> For now, allow writing to the entire struct on all architectures.
> The KVM tree will not refine this to an architecture-specific
> subset of struct kvm_vcpu_arch.
>=20
> Cc: kernel-hardening@lists.openwall.com
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Christian Borntraeger <borntraeger@redhat.com>
> Cc: Christoffer Dall <cdall@linaro.org>
> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4d81f6ded88e..b4809ccfdfa1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4005,8 +4005,12 @@ int kvm_init(void *opaque, unsigned vcpu_size, uns=
igned vcpu_align,
>  	/* A kmem cache lets us meet the alignment requirements of fx_save. */
>  	if (!vcpu_align)
>  		vcpu_align =3D __alignof__(struct kvm_vcpu);
> -	kvm_vcpu_cache =3D kmem_cache_create("kvm_vcpu", vcpu_size, vcpu_align,
> -					   0, NULL);
> +	kvm_vcpu_cache =3D
> +		kmem_cache_create_usercopy("kvm_vcpu",
> +					   sizeof(struct kvm_vcpu), vcpu_align,
> +					   0, offsetof(struct kvm_vcpu, arch),
> +					   sizeof_field(struct kvm_vcpu, arch),
> +					   NULL);
>  	if (!kvm_vcpu_cache) {
>  		r =3D -ENOMEM;
>  		goto out_free_3;

Acked-by: Cornelia Huck <cohuck@redhat.com>
