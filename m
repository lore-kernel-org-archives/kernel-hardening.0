From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: [PATCH 12/17] prmem: linked list: set alignment
Date: Wed, 24 Oct 2018 00:34:59 +0300
Message-Id: <20181023213504.28905-13-igor.stoppa@huawei.com>
In-Reply-To: <20181023213504.28905-1-igor.stoppa@huawei.com>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexey Dobriyan <adobriyan@gmail.com>, Pekka Enberg <penberg@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Lihao Liang <lianglihao@huawei.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

As preparation to using write rare on the nodes of various types of
lists, specify that the fields in the basic data structures must be
aligned to sizeof(void *)

It is meant to ensure that any static allocation will not cross a page
boundary, to allow pointers to be updated in one step.

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Masahiro Yamada <yamada.masahiro@socionext.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Pekka Enberg <penberg@kernel.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Lihao Liang <lianglihao@huawei.com>
CC: linux-kernel@vger.kernel.org
---
 include/linux/types.h | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/linux/types.h b/include/linux/types.h
index 9834e90aa010..53609bbdcf0f 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -183,17 +183,29 @@ typedef struct {
 } atomic64_t;
 #endif
 
+#ifdef CONFIG_PRMEM
 struct list_head {
-	struct list_head *next, *prev;
-};
+	struct list_head *next __aligned(sizeof(void *));
+	struct list_head *prev __aligned(sizeof(void *));
+} __aligned(sizeof(void *));
 
-struct hlist_head {
-	struct hlist_node *first;
+struct hlist_node {
+	struct hlist_node *next __aligned(sizeof(void *));
+	struct hlist_node **pprev __aligned(sizeof(void *));
+} __aligned(sizeof(void *));
+#else
+struct list_head {
+	struct list_head *next, *prev;
 };
 
 struct hlist_node {
 	struct hlist_node *next, **pprev;
 };
+#endif
+
+struct hlist_head {
+	struct hlist_node *first;
+};
 
 struct ustat {
 	__kernel_daddr_t	f_tfree;
-- 
2.17.1
