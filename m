From: Laura Abbott <labbott@redhat.com>
Subject: [PATCH 1/2] stackleak: Update for arm64
Date: Tue, 20 Feb 2018 17:13:02 -0800
Message-Id: <20180221011303.20392-2-labbott@redhat.com>
In-Reply-To: <20180221011303.20392-1-labbott@redhat.com>
References: <20180221011303.20392-1-labbott@redhat.com>
To: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


arm64 has another layer of indirection in the RTL.
Account for this in the plugin.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 scripts/gcc-plugins/stackleak_plugin.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/scripts/gcc-plugins/stackleak_plugin.c b/scripts/gcc-plugins/stackleak_plugin.c
index 6fc991c98d8b..7dfaa027423f 100644
--- a/scripts/gcc-plugins/stackleak_plugin.c
+++ b/scripts/gcc-plugins/stackleak_plugin.c
@@ -244,6 +244,11 @@ static unsigned int stackleak_final_execute(void)
 		 * that insn.
 		 */
 		body = PATTERN(insn);
+		/* arm64 is different */
+		if (GET_CODE(body) == PARALLEL) {
+			body = XEXP(body, 0);
+			body = XEXP(body, 0);
+		}
 		if (GET_CODE(body) != CALL)
 			continue;
 
-- 
2.14.3
