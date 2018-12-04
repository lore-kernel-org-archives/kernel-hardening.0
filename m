From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: [PATCH 4/6] rodata_test: add verification for __wr_after_init
Date: Tue,  4 Dec 2018 14:18:03 +0200
Message-Id: <20181204121805.4621-5-igor.stoppa@huawei.com>
In-Reply-To: <20181204121805.4621-1-igor.stoppa@huawei.com>
References: <20181204121805.4621-1-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>
Cc: igor.stoppa@huawei.com, Nadav Amit <nadav.amit@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, linux-integrity@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

The write protection of the __wr_after_init data can be verified with the
same methodology used for const data.

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>

CC: Andy Lutomirski <luto@amacapital.net>
CC: Nadav Amit <nadav.amit@gmail.com>
CC: Matthew Wilcox <willy@infradead.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Kees Cook <keescook@chromium.org>
CC: Dave Hansen <dave.hansen@linux.intel.com>
CC: linux-integrity@vger.kernel.org
CC: kernel-hardening@lists.openwall.com
CC: linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org
---
 mm/rodata_test.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/mm/rodata_test.c b/mm/rodata_test.c
index 3c1e515ca9b1..a98d088ad9cc 100644
--- a/mm/rodata_test.c
+++ b/mm/rodata_test.c
@@ -16,7 +16,19 @@
 
 #define INIT_TEST_VAL 0xC3
 
+/*
+ * Note: __ro_after_init data is, for every practical effect, equivalent to
+ * const data, since they are even write protected at the same time; there
+ * is no need for separate testing.
+ * __wr_after_init data, otoh, is altered also after the write protection
+ * takes place and it cannot be exploitable for altering more permanent
+ * data.
+ */
+
 static const int rodata_test_data = INIT_TEST_VAL;
+static int wr_after_init_test_data __wr_after_init = INIT_TEST_VAL;
+extern long __start_wr_after_init;
+extern long __end_wr_after_init;
 
 static bool test_data(char *data_type, const int *data,
 		      unsigned long start, unsigned long end)
@@ -60,6 +72,9 @@ void rodata_test(void)
 {
 	if (test_data("rodata", &rodata_test_data,
 		      (unsigned long)&__start_rodata,
-		      (unsigned long)&__end_rodata))
+		      (unsigned long)&__end_rodata) &&
+	    test_data("wr after init data", &wr_after_init_test_data,
+		      (unsigned long)&__start_wr_after_init,
+		      (unsigned long)&__end_wr_after_init))
 		pr_info("all tests were successful\n");
 }
-- 
2.19.1
