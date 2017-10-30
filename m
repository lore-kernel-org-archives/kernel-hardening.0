MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20171030232849.GA8409@gmail.com>
References: <20171026134547.23664-1-pbonzini@redhat.com> <20171026134547.23664-2-pbonzini@redhat.com>
 <20171030232849.GA8409@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 30 Oct 2017 16:51:52 -0700
Message-ID: <CAGXu5jKwhXgazxj-QoAzqRpijKOxB+-xhDPuuqPfd_cX0e30Xg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] [PATCH 1/2] kvm: whitelist struct kvm_vcpu_arch
To: Eric Biggers <ebiggers3@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Cornelia Huck <cohuck@redhat.com>, James Hogan <james.hogan@imgtec.com>, Paul Mackerras <paulus@samba.org>, kernel-hardening@lists.openwall.com, Christian Borntraeger <borntraeger@redhat.com>, Christoffer Dall <cdall@linaro.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 30, 2017 at 4:28 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> On Thu, Oct 26, 2017 at 03:45:46PM +0200, Paolo Bonzini wrote:
>> On x86, ARM and s390, struct kvm_vcpu_arch has a usercopy region
>> taht is read and written by the KVM_GET/SET_CPUID2 ioctls (x86)
>> or KVM_GET/SET_ONE_REG (ARM/s390).  Without whitelisting the area,
>> KVM is completely broken on those architectures with usercopy hardening
>> enabled.
>>
>> For now, allow writing to the entire struct on all architectures.
>> The KVM tree will not refine this to an architecture-specific
>> subset of struct kvm_vcpu_arch.
>>
>> Cc: kernel-hardening@lists.openwall.com
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Christian Borntraeger <borntraeger@redhat.com>
>> Cc: Christoffer Dall <cdall@linaro.org>
>> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  virt/kvm/kvm_main.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 4d81f6ded88e..b4809ccfdfa1 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -4005,8 +4005,12 @@ int kvm_init(void *opaque, unsigned vcpu_size, un=
signed vcpu_align,
>>       /* A kmem cache lets us meet the alignment requirements of fx_save=
. */
>>       if (!vcpu_align)
>>               vcpu_align =3D __alignof__(struct kvm_vcpu);
>> -     kvm_vcpu_cache =3D kmem_cache_create("kvm_vcpu", vcpu_size, vcpu_a=
lign,
>> -                                        0, NULL);
>> +     kvm_vcpu_cache =3D
>> +             kmem_cache_create_usercopy("kvm_vcpu",
>> +                                        sizeof(struct kvm_vcpu), vcpu_a=
lign,
>> +                                        0, offsetof(struct kvm_vcpu, ar=
ch),
>> +                                        sizeof_field(struct kvm_vcpu, a=
rch),
>> +                                        NULL);
>
> Doesn't it need to be 'vcpu_size' instead of 'sizeof(struct kvm_vcpu)'?

Oh, yikes, yes.

$ git grep '\bkvm_init('
arch/mips/kvm/mips.c:   ret =3D kvm_init(NULL, sizeof(struct kvm_vcpu),
0, THIS_MODULE);
arch/powerpc/kvm/book3s.c:      r =3D kvm_init(NULL, sizeof(struct
kvm_vcpu), 0, THIS_MODULE);
arch/powerpc/kvm/e500.c:        r =3D kvm_init(NULL, sizeof(struct
kvmppc_vcpu_e500), 0, THIS_MODULE);
arch/powerpc/kvm/e500mc.c:      r =3D kvm_init(NULL, sizeof(struct
kvmppc_vcpu_e500), 0, THIS_MODULE);
arch/s390/kvm/kvm-s390.c:       return kvm_init(NULL, sizeof(struct
kvm_vcpu), 0, THIS_MODULE);
arch/x86/kvm/svm.c:     return kvm_init(&svm_x86_ops, sizeof(struct vcpu_sv=
m),
arch/x86/kvm/vmx.c:     int r =3D kvm_init(&vmx_x86_ops, sizeof(struct vcpu=
_vmx),
include/linux/kvm_host.h:int kvm_init(void *opaque, unsigned
vcpu_size, unsigned vcpu_align,
virt/kvm/arm/arm.c:     int rc =3D kvm_init(NULL, sizeof(struct
kvm_vcpu), 0, THIS_MODULE);

I'll fix this up.

-Kees

--=20
Kees Cook
Pixel Security
