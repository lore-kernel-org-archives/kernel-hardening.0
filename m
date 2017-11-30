MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20171026134547.23664-3-pbonzini@redhat.com>
References: <20171026134547.23664-1-pbonzini@redhat.com> <20171026134547.23664-3-pbonzini@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 30 Nov 2017 12:40:10 -0800
Message-ID: <CAGXu5jKzA8UfV9Bfiz=1ZvHLjM+DYDiifR7e=EG956qNrS20JQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH 2/2] kvm: x86: fix KVM_XEN_HVM_CONFIG ioctl
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Cornelia Huck <cohuck@redhat.com>, James Hogan <james.hogan@imgtec.com>, Paul Mackerras <paulus@samba.org>, kernel-hardening@lists.openwall.com, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 26, 2017 at 6:45 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> This ioctl is obsolete (it was used by Xenner as far as I know) but
> still let's not break it gratuitously...  Its handler is copying
> directly into struct kvm.  Go through a bounce buffer instead, with
> the added benefit that we can actually do something useful with the
> flags argument---the previous code was exiting with -EINVAL but still
> doing the copy.
>
> This technically is a userspace ABI breakage, but since no one should be
> using the ioctl, it's a good occasion to see if someone actually
> complains.
>
> Cc: kernel-hardening@lists.openwall.com
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 272320eb328c..f32fbfb833b3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4187,13 +4187,14 @@ long kvm_arch_vm_ioctl(struct file *filp,
>                 mutex_unlock(&kvm->lock);
>                 break;
>         case KVM_XEN_HVM_CONFIG: {
> +               struct kvm_xen_hvm_config xhc;
>                 r =3D -EFAULT;
> -               if (copy_from_user(&kvm->arch.xen_hvm_config, argp,
> -                                  sizeof(struct kvm_xen_hvm_config)))
> +               if (copy_from_user(&xhc, argp, sizeof(xhc)))
>                         goto out;
>                 r =3D -EINVAL;
> -               if (kvm->arch.xen_hvm_config.flags)
> +               if (xhc.flags)
>                         goto out;
> +               memcpy(&kvm->arch.xen_hvm_config, &xhc, sizeof(xhc));
>                 r =3D 0;
>                 break;
>         }
> --
> 2.14.2
>

Hi Paolo,

Since this didn't make it via my usercopy tree, do you want to take it
via KVM? It is a stand-alone fix, AIUI.

Thanks,

-Kees

--=20
Kees Cook
Pixel Security
