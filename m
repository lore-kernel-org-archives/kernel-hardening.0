Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Apr 2016 15:29:14 -0700
Message-Id: <1460672954-32567-22-git-send-email-keescook@chromium.org>
In-Reply-To: <1460672954-32567-1-git-send-email-keescook@chromium.org>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 21/21] x86, KASLR: Allow randomization below load address
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Yinghai Lu <yinghai@kernel.org>

Currently the physical randomization's lower boundary is the load
address. For bootloaders that load kernels into very high memory
(e.g. kexec), this means randomization takes place in a very small window
at the top of memory, ignoring the large region of physical memory below
the load address.

Since mem_avoid is already correctly tracking the regions that must be
avoided, this patch changes the minimum address to which ever is less:
512M (to conservatively avoid unknown things in lower memory) or the
load address. Now, for example, if the kernel is loaded at 8G, [512M,
8G) will be added into possible physical memory positions.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
[kees: rewrote changelog, refactor to use min()]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/aslr.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index e83d3bb3808b..864a51863b45 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -459,7 +459,8 @@ void choose_kernel_location(unsigned char *input,
 				unsigned long output_size,
 				unsigned char **virt_offset)
 {
-	unsigned long random;
+	unsigned long random, min_addr;
+
 	*virt_offset = (unsigned char *)LOAD_PHYSICAL_ADDR;
 
 #ifdef CONFIG_HIBERNATION
@@ -480,8 +481,11 @@ void choose_kernel_location(unsigned char *input,
 	mem_avoid_init((unsigned long)input, input_size,
 		       (unsigned long)*output);
 
+	/* Low end should be the smaller of 512M or initial location. */
+	min_addr = min((unsigned long)*output, 512UL << 20);
+
 	/* Walk e820 and find a random address. */
-	random = find_random_phy_addr((unsigned long)*output, output_size);
+	random = find_random_phy_addr(min_addr, output_size);
 	if (!random)
 		debug_putstr("KASLR could not find suitable E820 region...\n");
 	else {
-- 
2.6.3
