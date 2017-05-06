Date: Fri, 5 May 2017 21:07:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170506040747.GF32707@kroah.com>
References: <20170506040641.GA32707@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170506040641.GA32707@kroah.com>
Subject: [kernel-hardening] [RFC 5/6] lib: vsprintf: Add "%paP", "%padP" options
To: kernel-hardening@lists.openwall.com, Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Chris Fries <cfries@google.com>

Add %paP and %padP for physical address that need to always be shown
regardless of kptr restrictions.

Cc: William Roberts <william.c.roberts@intel.com>
Cc: Dave Weinstein <olorin@google.com>
Signed-off-by: Chris Fries <cfries@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/printk-formats.txt | 10 ++++++----
 lib/vsprintf.c                   | 12 +++++++++---
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 8994c65aa3b0..7ee51269096f 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -82,18 +82,20 @@ Struct Resources:
 
 Physical addresses types phys_addr_t:
 
-	%pa[p]	0x01234567 or 0x0123456789abcdef
+	%pa[p][P] 0x01234567 or 0x0123456789abcdef
 
 	For printing a phys_addr_t type (and its derivatives, such as
 	resource_size_t) which can vary based on build options, regardless of
-	the width of the CPU data path. Passed by reference.
+	the width of the CPU data path. Passed by reference.  Use the trailing
+	'P' if it needs to be always shown.
 
 DMA addresses types dma_addr_t:
 
-	%pad	0x01234567 or 0x0123456789abcdef
+	%pad[P]	0x01234567 or 0x0123456789abcdef
 
 	For printing a dma_addr_t type which can vary based on build options,
-	regardless of the width of the CPU data path. Passed by reference.
+	regardless of the width of the CPU data path. Passed by reference. Use
+	the trailing 'P' if it needs to be always shown.
 
 Raw buffer as an escaped string:
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 404d477d4bd2..37f9d615e622 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1394,23 +1394,29 @@ static noinline_for_stack
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
+		/* fall thru */
 	default:
 		num = *(const phys_addr_t *)addr;
 		size = sizeof(phys_addr_t);
 		break;
 	}
 
-	return special_hex_number(buf, end,
-		      kptr_restrict_cleanse_addresses() ? 0UL : num,
-		      size);
+	/* 'P' on the tail means don't restrict the pointer. */
+	cleanse = cleanse && (fmt[decleanse_idx] != 'P');
+
+	return special_hex_number(buf, end, cleanse ? 0UL : num, size);
 }
 
 static noinline_for_stack
-- 
2.12.2
