Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Mon,  9 May 2016 13:22:12 -0700
Message-Id: <1462825332-10505-10-git-send-email-keescook@chromium.org>
In-Reply-To: <1462825332-10505-1-git-send-email-keescook@chromium.org>
References: <1462825332-10505-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v7 9/9] x86/KASLR: Allow randomization below load address
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Yinghai Lu <yinghai@kernel.org>

Currently the physical randomization's lower boundary is the original
kernel load address. For bootloaders that load kernels into very high
memory (e.g. kexec), this means randomization takes place in a very small
window at the top of memory, ignoring the large region of physical memory
below the load address.

Since mem_avoid is already correctly tracking the regions that must be
avoided, this patch changes the minimum address to whatever is less:
512M (to conservatively avoid unknown things in lower memory) or the
load address. Now, for example, if the kernel is loaded at 8G, [512M,
8G) will be added into possible physical memory positions.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
[kees: rewrote changelog, refactor to use min()]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/kaslr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index def1da9e7863..d972a026d44c 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -492,7 +492,7 @@ void choose_random_location(unsigned long input,
 			    unsigned long output_size,
 			    unsigned long *virt_addr)
 {
-	unsigned long random_addr;
+	unsigned long random_addr, min_addr;
 
 	/* By default, keep output position unchanged. */
 	*virt_addr = *output;
@@ -514,8 +514,11 @@ void choose_random_location(unsigned long input,
 	/* Record the various known unsafe memory ranges. */
 	mem_avoid_init(input, input_size, *output);
 
+	/* Low end should be the smaller of 512M or initial location. */
+	min_addr = min(*output, 512UL << 20);
+
 	/* Walk e820 and find a random address. */
-	random_addr = find_random_phys_addr(*output, output_size);
+	random_addr = find_random_phys_addr(min_addr, output_size);
 	if (!random_addr) {
 		warn("KASLR disabled: could not find suitable E820 region!");
 	} else {
-- 
2.6.3
