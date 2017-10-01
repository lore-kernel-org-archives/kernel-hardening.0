From: "Tobin C. Harding" <me@tobin.cc>
Date: Sun,  1 Oct 2017 11:06:49 +1100
Message-Id: <1506816410-10230-6-git-send-email-me@tobin.cc>
In-Reply-To: <1506816410-10230-1-git-send-email-me@tobin.cc>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [RFC V2 5/6] lib: vsprintf: add "%paP", "%papP", and "%padP" specifiers
To: Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

Add %papP and %padP for address types that need to always be shown
regardless of kptr restrictions. Add %paP is a synonym for %papP, this
is inline with current implementation (%pa is a synonym for %pap).

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 Documentation/printk-formats.txt | 19 +++++++++++++++----
 Documentation/sysctl/kernel.txt  |  4 ++--
 lib/vsprintf.c                   |  9 +++++++--
 3 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 16c9abc..d247bc8 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -119,26 +119,37 @@ For printing struct resources. The ``R`` and ``r`` specifiers result in a
 printed resource with (``R``) or without (``r``) a decoded flags member.
 Passed by reference.
 
+Physical addresses types
+========================
+
+::
+
+	%pa[P]	0x01234567 or 0x0123456789abcdef
+
+Synonymous with ``%pap[P]`` (for printing ``phys_addr_t``). See below.
+
 Physical addresses types ``phys_addr_t``
 ========================================
 
 ::
 
-	%pa[p]	0x01234567 or 0x0123456789abcdef
+	%pap[P]	0x01234567 or 0x0123456789abcdef
 
 For printing a ``phys_addr_t`` type (and its derivatives, such as
 ``resource_size_t``) which can vary based on build options, regardless of
-the width of the CPU data path. Passed by reference.
+the width of the CPU data path. Passed by reference. Use the trailing 'P'
+if it needs to be always shown.
 
 DMA addresses types ``dma_addr_t``
 ==================================
 
 ::
 
-	%pad	0x01234567 or 0x0123456789abcdef
+	%pad[P]         0x01234567 or 0x0123456789abcdef
 
 For printing a ``dma_addr_t`` type which can vary based on build options,
-regardless of the width of the CPU data path. Passed by reference.
+regardless of the width of the CPU data path. Passed by reference. Use the
+trailing 'P' if it needs to be always shown.
 
 Raw buffer as an escaped string
 ===============================
diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index b6d45bc..f1d52eb 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -400,8 +400,8 @@ however kernel pointers printed using %pP will continue to be printed.
 
 When kptr_restrict is set to (4), kernel pointers printed with
 %p, %pK, %pa, and %p[rR] will be replaced with 0's regardless of
-privileges. Kernel pointers printed using %pP will continue to be
-printed.
+privileges. Kernel pointers printed using %pP, %paP, %papP, %padP will
+continue to be printed.
 
 ==============================================================
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index e009325..1a35a7f 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1395,21 +1395,26 @@ static noinline_for_stack
 char *address_val(char *buf, char *end, const void *addr, const char *fmt)
 {
 	unsigned long long num;
+	int cleanse = kptr_restrict_cleanse_addresses();
+	int decleanse_idx = 1;
 	int size;
 
 	switch (fmt[1]) {
 	case 'd':
 		num = *(const dma_addr_t *)addr;
 		size = sizeof(dma_addr_t);
+		decleanse_idx = 2;
 		break;
 	case 'p':
+		decleanse_idx = 2;
+		/* fall through */
 	default:
 		num = *(const phys_addr_t *)addr;
 		size = sizeof(phys_addr_t);
 		break;
 	}
-
-	if (kptr_restrict_cleanse_addresses())
+	/* 'P' on the tail means don't restrict the pointer. */
+	if (cleanse && (fmt[decleanse_idx] != 'P'))
 		num = 0UL;
 
 	return special_hex_number(buf, end, num, size);
-- 
2.7.4
