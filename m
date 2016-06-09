Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 8 Jun 2016 20:02:30 -0700
From: Kees Cook <keescook@chromium.org>
Message-ID: <20160609030230.GA23922@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1465420302-23754-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [RFC][PATCH v2 5/4] arm: fixes for usercopy
To: kernel-hardening@lists.openwall.com
Cc: Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

These will be in the next version; they are the fixes I needed to boot my
ARM VM.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 7bcdb56ce6fb..c4887b272527 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -515,12 +515,12 @@ __copy_to_user(void __user *to, const void *from, unsigned long n)
 #ifndef CONFIG_UACCESS_WITH_MEMCPY
 	unsigned int __ua_flags = uaccess_save_and_enable();
 
-	check_object_size(to, n, false);
+	check_object_size(from, n, true);
 	n = arm_copy_to_user(to, from, n);
 	uaccess_restore(__ua_flags);
 	return n;
 #else
-	check_object_size(to, n, false);
+	check_object_size(from, n, true);
 	return arm_copy_to_user(to, from, n);
 #endif
 }
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 7b8f2141427b..98b497c83aef 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -252,6 +252,7 @@ badframe:
 static int
 setup_sigframe(struct sigframe __user *sf, struct pt_regs *regs, sigset_t *set)
 {
+	sigset_t setcopy = *set;
 	struct aux_sigframe __user *aux;
 	int err = 0;
 
@@ -278,7 +279,7 @@ setup_sigframe(struct sigframe __user *sf, struct pt_regs *regs, sigset_t *set)
 	__put_user_error(current->thread.address, &sf->uc.uc_mcontext.fault_address, err);
 	__put_user_error(set->sig[0], &sf->uc.uc_mcontext.oldmask, err);
 
-	err |= __copy_to_user(&sf->uc.uc_sigmask, set, sizeof(*set));
+	err |= __copy_to_user(&sf->uc.uc_sigmask, &setcopy, sizeof(*set));
 
 	aux = (struct aux_sigframe __user *) sf->uc.uc_regspace;
 #ifdef CONFIG_CRUNCH
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index e2c6da096cef..99420fc1f066 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -125,6 +125,8 @@ SECTIONS
 #ifdef CONFIG_DEBUG_ALIGN_RODATA
 	. = ALIGN(1<<SECTION_SHIFT);
 #endif
+	_etext = .;			/* End of text section */
+
 	RO_DATA(PAGE_SIZE)
 
 	. = ALIGN(4);
@@ -155,8 +157,6 @@ SECTIONS
 
 	NOTES
 
-	_etext = .;			/* End of text and rodata section */
-
 #ifdef CONFIG_DEBUG_RODATA
 	. = ALIGN(1<<SECTION_SHIFT);
 #else

-- 
Kees Cook
Chrome OS & Brillo Security
