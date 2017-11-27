From: "Tobin C. Harding" <me@tobin.cc>
Date: Tue, 28 Nov 2017 10:40:58 +1100
Message-Id: <1511826058-2563-6-git-send-email-me@tobin.cc>
In-Reply-To: <1511826058-2563-1-git-send-email-me@tobin.cc>
References: <1511826058-2563-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 5/5] vfio_pci: use %px to print token identifier
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Currently token address is printed using %p. This exposes the address of
the token in dmesg and potentially leaks sensitive information to
userspace. In this instance the address is being used as a unique
identifier for the token, we can use the newly defined printk specifier
%px for exactly this purpose.

Use the new %px specifier to print a unique identifier for the token.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 1c46045b0e7f..73d3ae8b5784 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -346,7 +346,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 	ret = irq_bypass_register_producer(&vdev->ctx[vector].producer);
 	if (unlikely(ret))
 		dev_info(&pdev->dev,
-		"irq bypass producer (token %p) registration fails: %d\n",
+		"irq bypass producer (token %px) registration fails: %d\n",
 		vdev->ctx[vector].producer.token, ret);
 
 	vdev->ctx[vector].trigger = trigger;
-- 
2.7.4
