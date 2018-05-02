From: Laura Abbott <labbott@redhat.com>
Subject: [PATCH 1/2] stackleak: Update for arm64
Date: Wed,  2 May 2018 13:33:25 -0700
Message-Id: <20180502203326.9491-2-labbott@redhat.com>
In-Reply-To: <20180502203326.9491-1-labbott@redhat.com>
References: <20180502203326.9491-1-labbott@redhat.com>
To: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

arm64 has another layer of indirection in the RTL.
Account for this in the plugin.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
Fixed from previous version to be a vector expression.
---
 scripts/gcc-plugins/stackleak_plugin.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/gcc-plugins/stackleak_plugin.c b/scripts/gcc-plugins/stackleak_plugin.c
index 6ac2a055ec61..0a55ecaf44df 100644
--- a/scripts/gcc-plugins/stackleak_plugin.c
+++ b/scripts/gcc-plugins/stackleak_plugin.c
@@ -253,6 +253,10 @@ static unsigned int stackleak_cleanup_execute(void)
 		 * that insn.
 		 */
 		body = PATTERN(insn);
+		/* arm64 is different */
+		if (GET_CODE(body) == PARALLEL)
+			body = XVECEXP(body, 0, 0);
+
 		if (GET_CODE(body) != CALL)
 			continue;
 
-- 
2.14.3
