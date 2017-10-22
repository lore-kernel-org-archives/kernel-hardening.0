MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20171021184545.2497-1-christoffer.dall@linaro.org>
References: <20171020232525.7387-1-pbonzini@redhat.com> <20171021184545.2497-1-christoffer.dall@linaro.org>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 21 Oct 2017 20:06:10 -0700
Message-ID: <CAGXu5jKJ2jPz2540ZLCwmcdVZxrgnhVPHs0uumiJm2o0ZgpVag@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH] KVM: arm/arm64: Allow usercopy to vcpu->arch.ctxt and
 arm64 debug
To: Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, KVM <kvm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Oct 21, 2017 at 11:45 AM, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> We do direct useraccess copying to the kvm_cpu_context structure
> embedded in the kvm_vcpu_arch structure, and to the vcpu debug register
> state.  Everything else (timer, PMU, vgic) goes through a temporary
> indirection.

Are these copies done with a dynamic size? The normal way these get
whitelisted is via builtin_const sizes on the copy. Looking at
KVM_REG_SIZE(), though, it seems that would be a dynamic calculation.

> Fixing all accesses to kvm_cpu_context is massively invasive, and we'd
> like to avoid that, so we tell kvm_init_usercopy to whitelist accesses
> to out context structure.
>
> The debug system register accesses on arm64 are modified to work through
> an indirection instead.
>
> Cc: kernel-hardening@lists.openwall.com
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> This fixes KVM/ARM on today's linux next with CONFIG_HARDENED_USERCOPY.
>
> The patch is based on linux-next plus Paolo's x86 patch which introduces
> kvm_init_usercopy.  Not sure how this needs to get merged, but it would
> potentially make sense for Paolo to put together a set of the patches
> needed for this.

I was planning to carry Paolo's patches, and I can take this one too.
If this poses a problem, then I could just do a two-phase commit of
the whitelisting code, leaving the very last commit (which enables the
defense for anything not yet whitelisted), until the KVM trees land.

What's preferred?

Thanks for looking at this!

-Kees

>
> Thanks,
> -Christoffer
>
>  arch/arm64/kvm/sys_regs.c | 36 ++++++++++++++++++++----------------
>  virt/kvm/arm/arm.c        |  5 ++++-
>  2 files changed, 24 insertions(+), 17 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 2e070d3baf9f..cdf47a9108fe 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -293,19 +293,20 @@ static bool trap_bvr(struct kvm_vcpu *vcpu,
>  static int set_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>                 const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> -       __u64 *r =3D &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
> +       __u64 r;
>
> -       if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) !=3D 0)
> +       if (copy_from_user(&r, uaddr, KVM_REG_SIZE(reg->id)) !=3D 0)
>                 return -EFAULT;
> +       vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg] =3D r;
>         return 0;
>  }
>
>  static int get_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>         const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> -       __u64 *r =3D &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
> +       __u64 r =3D vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
>
> -       if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)
> +       if (copy_to_user(uaddr, &r, KVM_REG_SIZE(reg->id)) !=3D 0)
>                 return -EFAULT;
>         return 0;
>  }
> @@ -335,10 +336,11 @@ static bool trap_bcr(struct kvm_vcpu *vcpu,
>  static int set_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>                 const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> -       __u64 *r =3D &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
> +       __u64 r;
>
> -       if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) !=3D 0)
> +       if (copy_from_user(&r, uaddr, KVM_REG_SIZE(reg->id)) !=3D 0)
>                 return -EFAULT;
> +       vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg] =3D r;
>
>         return 0;
>  }
> @@ -346,9 +348,9 @@ static int set_bcr(struct kvm_vcpu *vcpu, const struc=
t sys_reg_desc *rd,
>  static int get_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>         const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> -       __u64 *r =3D &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
> +       __u64 r =3D vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
>
> -       if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)
> +       if (copy_to_user(uaddr, &r, KVM_REG_SIZE(reg->id)) !=3D 0)
>                 return -EFAULT;
>         return 0;
>  }
> @@ -379,19 +381,20 @@ static bool trap_wvr(struct kvm_vcpu *vcpu,
>  static int set_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>                 const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> -       __u64 *r =3D &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
> +       __u64 r;
>
> -       if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) !=3D 0)
> +       if (copy_from_user(&r, uaddr, KVM_REG_SIZE(reg->id)) !=3D 0)
>                 return -EFAULT;
> +       vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg] =3D r;
>         return 0;
>  }
>
>  static int get_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>         const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> -       __u64 *r =3D &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
> +       __u64 r =3D vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
>
> -       if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)
> +       if (copy_to_user(uaddr, &r, KVM_REG_SIZE(reg->id)) !=3D 0)
>                 return -EFAULT;
>         return 0;
>  }
> @@ -421,19 +424,20 @@ static bool trap_wcr(struct kvm_vcpu *vcpu,
>  static int set_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>                 const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> -       __u64 *r =3D &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
> +       __u64 r;
>
> -       if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) !=3D 0)
> +       if (copy_from_user(&r, uaddr, KVM_REG_SIZE(reg->id)) !=3D 0)
>                 return -EFAULT;
> +       vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg] =3D r;
>         return 0;
>  }
>
>  static int get_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>         const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> -       __u64 *r =3D &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
> +       __u64 r =3D vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
>
> -       if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)
> +       if (copy_to_user(uaddr, &r, KVM_REG_SIZE(reg->id)) !=3D 0)
>                 return -EFAULT;
>         return 0;
>  }
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index b9f68e4add71..639e388678ff 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1502,7 +1502,10 @@ void kvm_arch_exit(void)
>
>  static int arm_init(void)
>  {
> -       int rc =3D kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE=
);
> +       int rc =3D kvm_init_usercopy(NULL, sizeof(struct kvm_vcpu), 0,
> +                                  offsetof(struct kvm_vcpu_arch, ctxt),
> +                                  sizeof_field(struct kvm_vcpu_arch, ctx=
t),
> +                                  THIS_MODULE);
>         return rc;
>  }
>
> --
> 2.14.2
>



--=20
Kees Cook
Pixel Security
