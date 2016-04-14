Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Apr 2016 15:29:09 -0700
Message-Id: <1460672954-32567-17-git-send-email-keescook@chromium.org>
In-Reply-To: <1460672954-32567-1-git-send-email-keescook@chromium.org>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 16/21] x86, KASLR: Add virtual address choosing function
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Baoquan He <bhe@redhat.com>

To support randomizing the kernel virtual address separately from the
physical address, this patch adds find_random_virt_offset() to choose
a slot anywhere between LOAD_PHYSICAL_ADDR and KERNEL_IMAGE_SIZE.
Since this address is virtual, not physical, we can place the kernel
anywhere in this region, as long as it is aligned and (in the case of
kernel being larger than the slot size) placed with enough room to load
the entire kernel image.

Signed-off-by: Baoquan He <bhe@redhat.com>
[kees: rewrote changelog, refactor slot calculation for readability]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/aslr.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index b06618000732..b527ff10372a 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -407,6 +407,29 @@ static unsigned long find_random_addr(unsigned long minimum,
 	return slots_fetch_random();
 }
 
+static unsigned long find_random_virt_offset(unsigned long minimum,
+				  unsigned long image_size)
+{
+	unsigned long slots, random;
+
+	/* Make sure minimum is aligned. */
+	minimum = ALIGN(minimum, CONFIG_PHYSICAL_ALIGN);
+	/* Align image_size for easy slot calculations. */
+	image_size = ALIGN(image_size, CONFIG_PHYSICAL_ALIGN);
+
+	/*
+	 * There are how many CONFIG_PHYSICAL_ALIGN-sized slots
+	 * that can hold image_size within the range of minimum to
+	 * KERNEL_IMAGE_SIZE?
+	 */
+	slots = (KERNEL_IMAGE_SIZE - minimum - image_size) /
+		 CONFIG_PHYSICAL_ALIGN + 1;
+
+	random = get_random_long() % slots;
+
+	return random * CONFIG_PHYSICAL_ALIGN + minimum;
+}
+
 unsigned char *choose_kernel_location(unsigned char *input,
 				      unsigned long input_size,
 				      unsigned char *output,
-- 
2.6.3
