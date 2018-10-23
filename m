From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: [PATCH 13/17] prmem: linked list: disable layout randomization
Date: Wed, 24 Oct 2018 00:35:00 +0300
Message-Id: <20181023213504.28905-14-igor.stoppa@huawei.com>
In-Reply-To: <20181023213504.28905-1-igor.stoppa@huawei.com>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexey Dobriyan <adobriyan@gmail.com>, Pekka Enberg <penberg@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Lihao Liang <lianglihao@huawei.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Some of the data structures used in list management are composed by two
pointers. Since the kernel is now configured by default to randomize the
layout of data structures soleley composed by pointers, this might
prevent correct type punning between these structures and their write
rare counterpart.

It shouldn't be anyway a big loss, in terms of security: with only two
fields, there is a 50% chance of guessing correctly the layout.
The randomization is disabled only when write rare is enabled.

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
CC: Kees Cook <keescook@chromium.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Masahiro Yamada <yamada.masahiro@socionext.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Pekka Enberg <penberg@kernel.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Lihao Liang <lianglihao@huawei.com>
CC: linux-kernel@vger.kernel.org
---
 include/linux/types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/types.h b/include/linux/types.h
index 53609bbdcf0f..a9f6f6515fdc 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -187,12 +187,12 @@ typedef struct {
 struct list_head {
 	struct list_head *next __aligned(sizeof(void *));
 	struct list_head *prev __aligned(sizeof(void *));
-} __aligned(sizeof(void *));
+} __no_randomize_layout __aligned(sizeof(void *));
 
 struct hlist_node {
 	struct hlist_node *next __aligned(sizeof(void *));
 	struct hlist_node **pprev __aligned(sizeof(void *));
-} __aligned(sizeof(void *));
+} __no_randomize_layout __aligned(sizeof(void *));
 #else
 struct list_head {
 	struct list_head *next, *prev;
-- 
2.17.1
