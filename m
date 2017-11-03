From: Laura Abbott <labbott@redhat.com>
Date: Fri,  3 Nov 2017 16:04:26 -0700
Message-Id: <20171103230426.19114-2-labbott@redhat.com>
In-Reply-To: <20171103230426.19114-1-labbott@redhat.com>
References: <20171103230426.19114-1-labbott@redhat.com>
Subject: [kernel-hardening] [RFC PATCH 2/2] x86: Allow paranoid __{get,put}_user
To: kernel-hardening@lists.openwall.com
Cc: Laura Abbott <labbott@redhat.com>, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

__{get,put}_user calls are designed to be fast and have no checks,
relying on the caller to have made the appropriate calls previously.
It's very easy to forget a check though, leaving the kernel vulnerable
to exploits. Add an option to do the checks and kill the kernel if it
catches something bad.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
This is the actual implemtation for __{get,put}_user on x86 based on
Mark Rutland's work for arm66
lkml.kernel.org/r/<20171026090942.7041-1-mark.rutland@arm.com>

x86 turns out to be easier since the safe and unsafe paths are mostly
disjoint so we don't have to worry about gcc optimizing out access_ok.
I tweaked the Kconfig to someting a bit more generic.

The size increase was ~8K in text with a config I tested.
---
 arch/x86/Kconfig               |  3 +++
 arch/x86/include/asm/uaccess.h | 11 ++++++++++-
 security/Kconfig               | 11 +++++++++++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2fdb23313dd5..10c6e150a91e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -261,6 +261,9 @@ config RWSEM_XCHGADD_ALGORITHM
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
+config ARCH_HAS_PARANOID_UACCESS
+	def_bool y
+
 config ARCH_HAS_CPU_RELAX
 	def_bool y
 
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index d23fb5844404..767febe1c720 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -132,6 +132,13 @@ extern int __get_user_bad(void);
 #define __inttype(x) \
 __typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
 
+
+#define verify_uaccess(dir, ptr)                                        \
+({                                                                      \
+        if (IS_ENABLED(CONFIG_PARANOID_UACCESS))                  \
+                BUG_ON(!access_ok(dir, (ptr), sizeof(*(ptr))));         \
+})
+
 /**
  * get_user: - Get a simple variable from user space.
  * @x:   Variable to store result.
@@ -278,6 +285,7 @@ do {									\
 	typeof(ptr) __pu_ptr = (ptr);					\
 	retval = 0;							\
 	__chk_user_ptr(__pu_ptr);					\
+	verify_uaccess(VERIFY_WRITE, __pu_ptr);				\
 	switch (size) {							\
 	case 1:								\
 		__put_user_asm(x, __pu_ptr, retval, "b", "b", "iq",	\
@@ -293,7 +301,7 @@ do {									\
 		break;							\
 	case 8:								\
 		__put_user_asm_u64((__typeof__(*ptr))(x), __pu_ptr,	\
-				retval,	\ errret);			\
+				retval,	errret);			\
 		break;							\
 	default:							\
 		__put_user_bad();					\
@@ -359,6 +367,7 @@ do {									\
 	typeof(ptr) __gu_ptr = (ptr);					\
 	retval = 0;							\
 	__chk_user_ptr(__gu_ptr);					\
+	verify_uaccess(VERIFY_READ, __gu_ptr);				\
 	switch (size) {							\
 	case 1:								\
 		__get_user_asm(x, __gu_ptr, retval, "b", "b", "=q",	\
diff --git a/security/Kconfig b/security/Kconfig
index e8e449444e65..0a9ec1a4e86b 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -205,6 +205,17 @@ config STATIC_USERMODEHELPER_PATH
 	  If you wish for all usermode helper programs to be disabled,
 	  specify an empty string here (i.e. "").
 
+config PARANOID_UACCESS
+	bool "Use paranoid uaccess primitives"
+	depends on ARCH_HAS_PARANOID_UACCESS
+	help
+	  Forces access_ok() checks in __get_user(), __put_user(), and other
+	  low-level uaccess primitives which usually do not have checks. This
+	  can limit the effect of missing access_ok() checks in higher-level
+	  primitives, with a runtime performance overhead in some cases and a
+	  small code size overhead.
+
+
 source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
-- 
2.13.5
