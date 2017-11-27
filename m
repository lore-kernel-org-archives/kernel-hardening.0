From: "Tobin C. Harding" <me@tobin.cc>
Date: Tue, 28 Nov 2017 10:40:57 +1100
Message-Id: <1511826058-2563-5-git-send-email-me@tobin.cc>
In-Reply-To: <1511826058-2563-1-git-send-email-me@tobin.cc>
References: <1511826058-2563-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 4/5] KVM: use %px to print token identifier
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
 virt/kvm/eventfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index f2ac53ab8243..9c700fdf571c 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -416,7 +416,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 		irqfd->consumer.start = kvm_arch_irq_bypass_start;
 		ret = irq_bypass_register_consumer(&irqfd->consumer);
 		if (ret)
-			pr_info("irq bypass consumer (token %p) registration fails: %d\n",
+			pr_info("irq bypass consumer (token %px) registration fails: %d\n",
 				irqfd->consumer.token, ret);
 	}
 #endif
-- 
2.7.4
