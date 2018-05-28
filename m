From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 022/268] kvm: x86: fix KVM_XEN_HVM_CONFIG ioctl
Date: Mon, 28 May 2018 11:59:56 +0200
Message-Id: <20180528100204.614345592@linuxfoundation.org>
In-Reply-To: <20180528100202.045206534@linuxfoundation.org>
References: <20180528100202.045206534@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Sasha Levin <alexander.levin@microsoft.com>
List-ID: <kernel-hardening.lists.openwall.com>

4.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 51776043afa415435c7e4636204fbe4f7edc4501 ]

This ioctl is obsolete (it was used by Xenner as far as I know) but
still let's not break it gratuitously...  Its handler is copying
directly into struct kvm.  Go through a bounce buffer instead, with
the added benefit that we can actually do something useful with the
flags argument---the previous code was exiting with -EINVAL but still
doing the copy.

This technically is a userspace ABI breakage, but since no one should be
using the ioctl, it's a good occasion to see if someone actually
complains.

Cc: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3973,13 +3973,14 @@ long kvm_arch_vm_ioctl(struct file *filp
 		mutex_unlock(&kvm->lock);
 		break;
 	case KVM_XEN_HVM_CONFIG: {
+		struct kvm_xen_hvm_config xhc;
 		r = -EFAULT;
-		if (copy_from_user(&kvm->arch.xen_hvm_config, argp,
-				   sizeof(struct kvm_xen_hvm_config)))
+		if (copy_from_user(&xhc, argp, sizeof(xhc)))
 			goto out;
 		r = -EINVAL;
-		if (kvm->arch.xen_hvm_config.flags)
+		if (xhc.flags)
 			goto out;
+		memcpy(&kvm->arch.xen_hvm_config, &xhc, sizeof(xhc));
 		r = 0;
 		break;
 	}
