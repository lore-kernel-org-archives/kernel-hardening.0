Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Apr 2016 15:28:55 -0700
Message-Id: <1460672954-32567-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1460672954-32567-1-git-send-email-keescook@chromium.org>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 02/21] x86, KASLR: Handle kernel relocation above 2G
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Baoquan He <bhe@redhat.com>

When processing the relocation table, the offset used to calculate the
relocation is an int. This is sufficient for calculating the physical
address of the relocs entry on 32-bit systems and on 64-bit systems when
the relocation is under 2G. To handle relocations above 2G (seen in
situations like kexec, netboot, etc), this offset needs to be calculated
using a long to avoid wrapping and miscalculating the relocation.

Signed-off-by: Baoquan He <bhe@redhat.com>
[kees: rewrote changelog]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index f35ad9eb1bf1..c4477d5f3fff 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -295,7 +295,7 @@ static void handle_relocations(void *output, unsigned long output_len)
 	 * So we work backwards from the end of the decompressed image.
 	 */
 	for (reloc = output + output_len - sizeof(*reloc); *reloc; reloc--) {
-		int extended = *reloc;
+		long extended = *reloc;
 		extended += map;
 
 		ptr = (unsigned long)extended;
-- 
2.6.3
