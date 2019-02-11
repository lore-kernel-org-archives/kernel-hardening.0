From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: [RFC PATCH v4 10/12] __wr_after_init: rodata_test: test __wr_after_init
Date: Tue, 12 Feb 2019 01:27:47 +0200
Message-Id: <5b674df65263831006ea27edce2c08fd70ddd6b1.1549927666.git.igor.stoppa@huawei.com>
In-Reply-To: <cover.1549927666.git.igor.stoppa@huawei.com>
References: <cover.1549927666.git.igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Igor Stoppa <igor.stoppa@huawei.com>, Andy Lutomirski <luto@amacapital.net>, Nadav Amit <nadav.amit@gmail.com>, Matthew Wilcox <willy@infradead.org>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@linux.intel.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Thiago Jung Bauermann <bauerman@linux.ibm.com>, Ahmed Soliman <ahmedsoliman@mena.vt.edu>, linux-integrity@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
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
CC: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: Thiago Jung Bauermann <bauerman@linux.ibm.com>
CC: Ahmed Soliman <ahmedsoliman@mena.vt.edu>
CC: linux-integrity@vger.kernel.org
CC: kernel-hardening@lists.openwall.com
CC: linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org
---
 mm/rodata_test.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/mm/rodata_test.c b/mm/rodata_test.c
index e1349520b436..a669cf9f5a61 100644
--- a/mm/rodata_test.c
+++ b/mm/rodata_test.c
@@ -16,8 +16,23 @@
 
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
 
+#ifdef CONFIG_PRMEM
+static int wr_after_init_test_data __wr_after_init = INIT_TEST_VAL;
+extern long __start_wr_after_init;
+extern long __end_wr_after_init;
+#endif
+
 static bool test_data(char *data_type, const int *data,
 		      unsigned long start, unsigned long end)
 {
@@ -59,7 +74,13 @@ static bool test_data(char *data_type, const int *data,
 
 void rodata_test(void)
 {
-	test_data("rodata", &rodata_test_data,
-		  (unsigned long)&__start_rodata,
-		  (unsigned long)&__end_rodata);
+	if (!test_data("rodata", &rodata_test_data,
+		       (unsigned long)&__start_rodata,
+		       (unsigned long)&__end_rodata))
+		return;
+#ifdef CONFIG_PRMEM
+	    test_data("wr after init data", &wr_after_init_test_data,
+		      (unsigned long)&__start_wr_after_init,
+		      (unsigned long)&__end_wr_after_init);
+#endif
 }
-- 
2.19.1
