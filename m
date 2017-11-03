From: Laura Abbott <labbott@redhat.com>
Date: Fri,  3 Nov 2017 16:04:25 -0700
Message-Id: <20171103230426.19114-1-labbott@redhat.com>
In-reply-to: <20171026090942.7041-1-mark.rutland@arm.com>
Subject: [kernel-hardening] [RFC PATCH 1/2] x86: Avoid multiple evaluations in __{get,put}_user_size
To: kernel-hardening@lists.openwall.com
Cc: Laura Abbott <labbott@redhat.com>, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Currently __{get,put}_user_size() expand their ptr argument in several
places, and some callers pass in expressions with side effects.

For example, fs/binfmt_elf.c, passes sp++ as the ptr argument to a chain
of __put_user() calls.

So far this isn't a problem, as each of these uses is mutually
exclusive. However, in subsequent patches we will need to make use of
the ptr argument several times, and ensure that we evaluate the ptr
expression exactly once to avoid corrupting the pointer.

In preparation for such uses, this patch reorganises
__{get,put}_user_size to evaluate the ptr argument into a temporary
__{gu,pu}_ptr variable, ensuring that side-effects occur exaclty once.

There should be no functional change as a result of this patch.

Based on work done for arm64 by Mark Rutland.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
This is setup patch for checking __{get,put}_user on x86 based on
Mark Rutland's work for arm64
lkml.kernel.org/r/<20171026090942.7041-1-mark.rutland@arm.com>
---
 arch/x86/include/asm/uaccess.h | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 574dff4d2913..d23fb5844404 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -275,21 +275,25 @@ extern void __put_user_8(void);
 
 #define __put_user_size(x, ptr, size, retval, errret)			\
 do {									\
+	typeof(ptr) __pu_ptr = (ptr);					\
 	retval = 0;							\
-	__chk_user_ptr(ptr);						\
+	__chk_user_ptr(__pu_ptr);					\
 	switch (size) {							\
 	case 1:								\
-		__put_user_asm(x, ptr, retval, "b", "b", "iq", errret);	\
+		__put_user_asm(x, __pu_ptr, retval, "b", "b", "iq",	\
+				errret);				\
 		break;							\
 	case 2:								\
-		__put_user_asm(x, ptr, retval, "w", "w", "ir", errret);	\
+		__put_user_asm(x, __pu_ptr, retval, "w", "w", "ir",	\
+				errret);				\
 		break;							\
 	case 4:								\
-		__put_user_asm(x, ptr, retval, "l", "k", "ir", errret);	\
+		__put_user_asm(x, __pu_ptr, retval, "l", "k", "ir",	\
+				errret);				\
 		break;							\
 	case 8:								\
-		__put_user_asm_u64((__typeof__(*ptr))(x), ptr, retval,	\
-				   errret);				\
+		__put_user_asm_u64((__typeof__(*ptr))(x), __pu_ptr,	\
+				retval,	\ errret);			\
 		break;							\
 	default:							\
 		__put_user_bad();					\
@@ -352,20 +356,24 @@ do {									\
 
 #define __get_user_size(x, ptr, size, retval, errret)			\
 do {									\
+	typeof(ptr) __gu_ptr = (ptr);					\
 	retval = 0;							\
-	__chk_user_ptr(ptr);						\
+	__chk_user_ptr(__gu_ptr);					\
 	switch (size) {							\
 	case 1:								\
-		__get_user_asm(x, ptr, retval, "b", "b", "=q", errret);	\
+		__get_user_asm(x, __gu_ptr, retval, "b", "b", "=q",	\
+				errret);				\
 		break;							\
 	case 2:								\
-		__get_user_asm(x, ptr, retval, "w", "w", "=r", errret);	\
+		__get_user_asm(x, __gu_ptr, retval, "w", "w", "=r",	\
+				errret);				\
 		break;							\
 	case 4:								\
-		__get_user_asm(x, ptr, retval, "l", "k", "=r", errret);	\
+		__get_user_asm(x, __gu_ptr, retval, "l", "k", "=r",	\
+				errret);				\
 		break;							\
 	case 8:								\
-		__get_user_asm_u64(x, ptr, retval, errret);		\
+		__get_user_asm_u64(x, __gu_ptr, retval, errret);	\
 		break;							\
 	default:							\
 		(x) = __get_user_bad();					\
-- 
2.13.5
