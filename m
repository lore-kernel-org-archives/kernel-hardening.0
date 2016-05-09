Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Mon,  9 May 2016 13:22:09 -0700
Message-Id: <1462825332-10505-7-git-send-email-keescook@chromium.org>
In-Reply-To: <1462825332-10505-1-git-send-email-keescook@chromium.org>
References: <1462825332-10505-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v7 6/9] x86/KASLR: Clarify purpose of each get_random_long()
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

KASLR will be calling get_random_long() twice, but the debug output
won't distinguishing between them. This patch adds a report on when it
is fetching the physical vs virtual address. With this, once the virtual
offset is separate, the report changes from:

KASLR using RDTSC...
KASLR using RDTSC...

into:

Physical KASLR using RDTSC...
Virtual KASLR using RDTSC...

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/kaslr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index 82d00282df3f..c4b1e4b05cb6 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -72,7 +72,7 @@ static unsigned long get_random_boot(void)
 	return hash;
 }
 
-static unsigned long get_random_long(void)
+static unsigned long get_random_long(const char *purpose)
 {
 #ifdef CONFIG_X86_64
 	const unsigned long mix_const = 0x5d6008cbf3848dd3UL;
@@ -82,7 +82,8 @@ static unsigned long get_random_long(void)
 	unsigned long raw, random = get_random_boot();
 	bool use_i8254 = true;
 
-	debug_putstr("KASLR using");
+	debug_putstr(purpose);
+	debug_putstr(" KASLR using");
 
 	if (has_cpuflag(X86_FEATURE_RDRAND)) {
 		debug_putstr(" RDRAND");
@@ -365,7 +366,7 @@ static unsigned long slots_fetch_random(void)
 	if (slot_max == 0)
 		return 0;
 
-	return slots[get_random_long() % slot_max];
+	return slots[get_random_long("Physical") % slot_max];
 }
 
 static void process_e820_entry(struct e820entry *entry,
@@ -453,7 +454,7 @@ static unsigned long find_random_virt_addr(unsigned long minimum,
 	slots = (KERNEL_IMAGE_SIZE - minimum - image_size) /
 		 CONFIG_PHYSICAL_ALIGN + 1;
 
-	random_addr = get_random_long() % slots;
+	random_addr = get_random_long("Virtual") % slots;
 
 	return random_addr * CONFIG_PHYSICAL_ALIGN + minimum;
 }
-- 
2.6.3
