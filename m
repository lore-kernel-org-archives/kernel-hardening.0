MIME-Version: 1.0
Date: Mon, 25 Jun 2018 15:38:53 -0700
In-Reply-To: <20180625224014.134829-1-thgarnie@google.com>
Message-Id: <20180625224014.134829-6-thgarnie@google.com>
References: <20180625224014.134829-1-thgarnie@google.com>
Subject: [PATCH v5 05/27] x86: relocate_kernel - Adapt assembly for PIE support
From: Thomas Garnier <thgarnie@google.com>
Content-Type: text/plain; charset="UTF-8"
To: kernel-hardening@lists.openwall.com
Cc: Thomas Garnier <thgarnie@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Change the assembly code to use only relative references of symbols for the
kernel to be PIE compatible.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/kernel/relocate_kernel_64.S | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
index 11eda21eb697..a7227dfe1a2b 100644
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -208,9 +208,11 @@ identity_mapped:
 	movq	%rax, %cr3
 	lea	PAGE_SIZE(%r8), %rsp
 	call	swap_pages
-	movq	$virtual_mapped, %rax
-	pushq	%rax
-	ret
+	jmp	*virtual_mapped_addr(%rip)
+
+	/* Absolute value for PIE support */
+virtual_mapped_addr:
+	.quad virtual_mapped
 
 virtual_mapped:
 	movq	RSP(%r8), %rsp
-- 
2.18.0.rc2.346.g013aa6912e-goog
