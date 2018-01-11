From: Kees Cook <keescook@chromium.org>
Date: Wed, 10 Jan 2018 18:02:37 -0800
Message-Id: <1515636190-24061-6-git-send-email-keescook@chromium.org>
In-Reply-To: <1515636190-24061-1-git-send-email-keescook@chromium.org>
References: <1515636190-24061-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 05/38] stddef.h: Introduce sizeof_field()
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, David Windsor <dave@nullcore.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Christoph Hellwig <hch@infradead.org>, Christoph Lameter <cl@linux.com>, "David S. Miller" <davem@davemloft.net>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Dave Kleikamp <dave.kleikamp@oracle.com>, Jan Kara <jack@suse.cz>, Luis de Bethencourt <luisbg@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Rik van Riel <riel@redhat.com>, Matthew Garrett <mjg59@google.com>, linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, netdev@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The size of fields within a structure is needed in a few places in the
kernel already, and will be needed for the usercopy whitelisting when
declaring whitelist regions within structures. This creates a dedicated
macro and redefines offsetofend() to use it.

Existing usage, ignoring the 1200+ lustre assert uses:

$ git grep -E 'sizeof\(\(\((struct )?[a-zA-Z_]+ \*\)0\)->' | \
	grep -v staging/lustre | wc -l
65

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/stddef.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index 2181719fd907..998a4ba28eba 100644
--- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -20,12 +20,20 @@ enum {
 #endif
 
 /**
+ * sizeof_field(TYPE, MEMBER)
+ *
+ * @TYPE: The structure containing the field of interest
+ * @MEMBER: The field to return the size of
+ */
+#define sizeof_field(TYPE, MEMBER) sizeof((((TYPE *)0)->MEMBER))
+
+/**
  * offsetofend(TYPE, MEMBER)
  *
  * @TYPE: The type of the structure
  * @MEMBER: The member within the structure to get the end offset of
  */
 #define offsetofend(TYPE, MEMBER) \
-	(offsetof(TYPE, MEMBER)	+ sizeof(((TYPE *)0)->MEMBER))
+	(offsetof(TYPE, MEMBER)	+ sizeof_field(TYPE, MEMBER))
 
 #endif
-- 
2.7.4
