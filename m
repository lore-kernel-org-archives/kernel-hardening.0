From: riel@redhat.com
Date: Wed, 24 May 2017 11:57:50 -0400
Message-Id: <20170524155751.424-5-riel@redhat.com>
In-Reply-To: <20170524155751.424-1-riel@redhat.com>
References: <20170524155751.424-1-riel@redhat.com>
Subject: [kernel-hardening] [PATCH 4/5] arm64: ascii armor the arm64 boot init stack canary
To: linux-kernel@vger.kernel.org
Cc: danielmicay@gmail.com, tytso@mit.edu, keescook@chromium.org, hpa@zytor.com, luto@amacapital.net, mingo@kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, linux-sh@vger.kernel.org, ysato@users.sourceforge.jp, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Rik van Riel <riel@redhat.com>

Use the ascii-armor canary to prevent unterminated C string overflows
from being able to successfully overwrite the canary, even if they
somehow obtain the canary value.

Inspired by execshield ascii-armor and Daniel Micay's linux-hardened tree.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 arch/arm64/include/asm/stackprotector.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/stackprotector.h b/arch/arm64/include/asm/stackprotector.h
index fe5e287dc56b..b86a0865ddf1 100644
--- a/arch/arm64/include/asm/stackprotector.h
+++ b/arch/arm64/include/asm/stackprotector.h
@@ -30,6 +30,7 @@ static __always_inline void boot_init_stack_canary(void)
 	/* Try to get a semi random initial value. */
 	get_random_bytes(&canary, sizeof(canary));
 	canary ^= LINUX_VERSION_CODE;
+	canary &= CANARY_MASK;
 
 	current->stack_canary = canary;
 	__stack_chk_guard = current->stack_canary;
-- 
2.9.3
