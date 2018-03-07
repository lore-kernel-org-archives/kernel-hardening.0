Date: Wed, 7 Mar 2018 13:25:55 -0800
From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] test_bitmap: Do not accidentally use stack VLA
Message-ID: <20180307212555.GA17927@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yury Norov <ynorov@caviumnetworks.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This avoids an accidental stack VLA (since the compiler thinks the value
of "len" can change, even when marked "const"). This just replaces it
with a #define so it will DTRT.

Seen with -Wvla. Fixed as part of the directive to remove all VLAs from
the kernel: https://lkml.org/lkml/2018/3/7/621

Cc: Yury Norov <ynorov@caviumnetworks.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/test_bitmap.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index b3f235baa05d..756f20ad03db 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -292,15 +292,17 @@ static void __init test_bitmap_parselist(void)
 	}
 }
 
+#define EXP_BYTES	(sizeof(exp) * 8)
+
 static void __init test_bitmap_arr32(void)
 {
-	unsigned int nbits, next_bit, len = sizeof(exp) * 8;
+	unsigned int nbits, next_bit;
 	u32 arr[sizeof(exp) / 4];
-	DECLARE_BITMAP(bmap2, len);
+	DECLARE_BITMAP(bmap2, EXP_BYTES);
 
 	memset(arr, 0xa5, sizeof(arr));
 
-	for (nbits = 0; nbits < len; ++nbits) {
+	for (nbits = 0; nbits < EXP_BYTES; ++nbits) {
 		bitmap_to_arr32(arr, exp, nbits);
 		bitmap_from_arr32(bmap2, arr, nbits);
 		expect_eq_bitmap(bmap2, exp, nbits);
@@ -312,7 +314,7 @@ static void __init test_bitmap_arr32(void)
 				" tail is not safely cleared: %d\n",
 				nbits, next_bit);
 
-		if (nbits < len - 32)
+		if (nbits < EXP_BYTES - 32)
 			expect_eq_uint(arr[DIV_ROUND_UP(nbits, 32)],
 								0xa5a5a5a5);
 	}
-- 
2.7.4


-- 
Kees Cook
Pixel Security
