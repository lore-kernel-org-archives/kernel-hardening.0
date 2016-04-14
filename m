Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Apr 2016 15:29:06 -0700
Message-Id: <1460672954-32567-14-git-send-email-keescook@chromium.org>
In-Reply-To: <1460672954-32567-1-git-send-email-keescook@chromium.org>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 13/21] x86, boot: Report overlap failures in memcpy
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Yinghai Lu <yinghai@kernel.org>

parse_elf is using a local memcpy to move sections to their final running
position. However, this memcpy only supports non-overlapping arguments
(or dest < src).

To avoid future hard-to-debug surprises, this adds checking in memcpy to
detect the unhandled condition (which should not be happening currently).

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Baoquan He <bhe@redhat.com>
[kees: rewrote changelog]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/misc.c   |  9 ++-------
 arch/x86/boot/compressed/misc.h   |  2 ++
 arch/x86/boot/compressed/string.c | 29 +++++++++++++++++++++++++++--
 3 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 562d647289ac..c47ac162d3bd 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -114,9 +114,6 @@
 #undef memset
 #define memzero(s, n)	memset((s), 0, (n))
 
-
-static void error(char *m);
-
 /*
  * This is set up by the setup-routine at boot-time
  */
@@ -243,7 +240,7 @@ void __puthex(unsigned long value)
 	}
 }
 
-static void error(char *x)
+void error(char *x)
 {
 	error_putstr("\n\n");
 	error_putstr(x);
@@ -378,9 +375,7 @@ static void parse_elf(void *output)
 #else
 			dest = (void *)(phdr->p_paddr);
 #endif
-			memcpy(dest,
-			       output + phdr->p_offset,
-			       phdr->p_filesz);
+			memcpy(dest, output + phdr->p_offset, phdr->p_filesz);
 			break;
 		default: /* Ignore other PT_* */ break;
 		}
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 11736a6a6670..39d0e9a53736 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -38,6 +38,8 @@ void __puthex(unsigned long value);
 #define error_putstr(__x)  __putstr(__x)
 #define error_puthex(__x)  __puthex(__x)
 
+void error(char *x);
+
 #ifdef CONFIG_X86_VERBOSE_BOOTUP
 
 #define debug_putstr(__x)  __putstr(__x)
diff --git a/arch/x86/boot/compressed/string.c b/arch/x86/boot/compressed/string.c
index 00e788be1db9..3a935d0c82a8 100644
--- a/arch/x86/boot/compressed/string.c
+++ b/arch/x86/boot/compressed/string.c
@@ -1,7 +1,7 @@
 #include "../string.c"
 
 #ifdef CONFIG_X86_32
-void *memcpy(void *dest, const void *src, size_t n)
+void *__memcpy(void *dest, const void *src, size_t n)
 {
 	int d0, d1, d2;
 	asm volatile(
@@ -15,7 +15,7 @@ void *memcpy(void *dest, const void *src, size_t n)
 	return dest;
 }
 #else
-void *memcpy(void *dest, const void *src, size_t n)
+void *__memcpy(void *dest, const void *src, size_t n)
 {
 	long d0, d1, d2;
 	asm volatile(
@@ -30,6 +30,31 @@ void *memcpy(void *dest, const void *src, size_t n)
 }
 #endif
 
+extern void error(char *x);
+void *memcpy(void *dest, const void *src, size_t n)
+{
+	unsigned long start_dest, end_dest;
+	unsigned long start_src, end_src;
+	unsigned long max_start, min_end;
+
+	if (dest < src)
+		return __memcpy(dest, src, n);
+
+	start_dest = (unsigned long)dest;
+	end_dest = (unsigned long)dest + n;
+	start_src = (unsigned long)src;
+	end_src = (unsigned long)src + n;
+	max_start = (start_dest > start_src) ?  start_dest : start_src;
+	min_end = (end_dest < end_src) ? end_dest : end_src;
+
+	if (max_start >= min_end)
+		return __memcpy(dest, src, n);
+
+	error("memcpy does not support overlapping with dest > src!\n");
+
+	return dest;
+}
+
 void *memset(void *s, int c, size_t n)
 {
 	int i;
-- 
2.6.3
