From: Mark Rutland <mark.rutland@arm.com>
Date: Thu, 26 Oct 2017 10:09:42 +0100
Message-Id: <20171026090942.7041-3-mark.rutland@arm.com>
In-Reply-To: <20171026090942.7041-1-mark.rutland@arm.com>
References: <20171026090942.7041-1-mark.rutland@arm.com>
Subject: [kernel-hardening] [RFC PATCH 2/2] arm64: allow paranoid __{get,put}user
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Will Deacon <will.deacon@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Now that the compiler can identify redundant access_ok() checks, we can
make __get-user() and __put_user() BUG()-out if there wasn't a preceding
access_ok() check. So long as that's in the same compilation unit, the
compiler should be able to get rid of the redundant second check and BUG
entry.

This will allow us to catch __{get,put}_user() calls which did not have
a preceding access_ok() check, but may adversely affect a small number
of callsites where GCC fails to spot that it can fold two access_ok()
checks together.

As these checks may impact performance and code size, they are only
enabled when CONFIG_ARM64_PARANOID_UACCESS is selected.

In testing with v4.14-rc5 with the Linaro 17.05 GCC 6.3.1 toolchain,
this makes the kernel Image ~4KiB bigger, and the vmlinux ~93k bigger. I
have no performance numbers so far.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/Kconfig               | 9 +++++++++
 arch/arm64/include/asm/uaccess.h | 8 ++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 0df64a6a56d4..34df81acda8e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1028,6 +1028,15 @@ config RANDOMIZE_MODULE_REGION_FULL
 	  a limited range that contains the [_stext, _etext] interval of the
 	  core kernel, so branch relocations are always in range.
 
+config ARM64_PARANOID_UACCESS
+	bool "Use paranoid uaccess primitives"
+	help
+	  Forces access_ok() checks in __get_user(), __put_user(), and other
+	  low-level uaccess primitives which usually do not have checks. This
+	  can limit the effect of missing access_ok() checks in higher-level
+	  primitives, with a runtime performance overhead in some cases and a
+	  small code size overhead.
+
 endmenu
 
 menu "Boot options"
diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 36f84ec92b9d..dbe8dfd46ceb 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -195,6 +195,12 @@ static inline void uaccess_enable_not_uao(void)
 	__uaccess_enable(ARM64_ALT_PAN_NOT_UAO);
 }
 
+#define verify_uaccess(dir, ptr)					\
+({									\
+	if (IS_ENABLED(CONFIG_ARM64_PARANOID_UACCESS))			\
+		BUG_ON(!access_ok(dir, (ptr), sizeof(*(ptr))));		\
+})
+
 /*
  * The "__xxx" versions of the user access functions do not verify the address
  * space - it must have been done previously with a separate "access_ok()"
@@ -222,6 +228,7 @@ static inline void uaccess_enable_not_uao(void)
 do {									\
 	unsigned long __gu_val;						\
 	__chk_user_ptr(ptr);						\
+	verify_uaccess(VERIFY_READ, ptr);				\
 	uaccess_enable_not_uao();					\
 	switch (sizeof(*(ptr))) {					\
 	case 1:								\
@@ -287,6 +294,7 @@ do {									\
 do {									\
 	__typeof__(*(ptr)) __pu_val = (x);				\
 	__chk_user_ptr(ptr);						\
+	verify_uaccess(VERIFY_WRITE, ptr);				\
 	uaccess_enable_not_uao();					\
 	switch (sizeof(*(ptr))) {					\
 	case 1:								\
-- 
2.11.0
