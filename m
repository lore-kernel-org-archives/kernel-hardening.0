Subject: Patch "kvm: x86: fix KVM_XEN_HVM_CONFIG ioctl" has been added to the 4.4-stable tree
From: <gregkh@linuxfoundation.org>
Date: Wed, 02 May 2018 12:04:01 -0700
Message-ID: <15252878411690@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: alexander.levin@microsoft.com, gregkh@linuxfoundation.org, keescook@chromium.org, kernel-hardening@lists.openwall.com, pbonzini@redhat.com, rkrcmar@redhat.com
Cc: stable-commits@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


This is a note to let you know that I've just added the patch titled

    kvm: x86: fix KVM_XEN_HVM_CONFIG ioctl

to the 4.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     kvm-x86-fix-kvm_xen_hvm_config-ioctl.patch
and it can be found in the queue-4.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From foo@baz Wed May  2 11:39:22 PDT 2018
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 26 Oct 2017 15:45:47 +0200
Subject: kvm: x86: fix KVM_XEN_HVM_CONFIG ioctl

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


Patches currently in stable-queue which might be from pbonzini@redhat.com are

queue-4.4/kvm-x86-fix-kvm_xen_hvm_config-ioctl.patch
