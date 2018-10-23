From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: [PATCH 11/17] prmem: llist: use designated initializer
Date: Wed, 24 Oct 2018 00:34:58 +0300
Message-Id: <20181023213504.28905-12-igor.stoppa@huawei.com>
In-Reply-To: <20181023213504.28905-1-igor.stoppa@huawei.com>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Kate Stewart <kstewart@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Edward Cree <ecree@solarflare.com>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Using a list_head in an unnamed union poses a problem with the current
implementation of the initializer, since it doesn't specify the names of
the fields it is initializing.

This patch makes it use designated initializers.

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
CC: Kate Stewart <kstewart@linuxfoundation.org>
CC: "David S. Miller" <davem@davemloft.net>
CC: Edward Cree <ecree@solarflare.com>
CC: Philippe Ombredanne <pombredanne@nexb.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
---
 include/linux/list.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index de04cc5ed536..184a7b60436f 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -18,7 +18,10 @@
  * using the generic single-entry routines.
  */
 
-#define LIST_HEAD_INIT(name) { &(name), &(name) }
+#define LIST_HEAD_INIT(name) {	\
+	.next = &(name),	\
+	.prev = &(name),	\
+}
 
 #define LIST_HEAD(name) \
 	struct list_head name = LIST_HEAD_INIT(name)
-- 
2.17.1
