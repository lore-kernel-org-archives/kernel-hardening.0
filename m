From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] gcc-plugins: arm_ssp_per_task_plugin: sign extend the SP mask
Date: Fri, 18 Jan 2019 11:58:06 +0100
Message-Id: <20190118105807.26425-2-ard.biesheuvel@linaro.org>
In-Reply-To: <20190118105807.26425-1-ard.biesheuvel@linaro.org>
References: <20190118105807.26425-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: keescook@chromium.org
Cc: re.emese@gmail.com, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kugan Vivekanandarajah <kugan.vivekanandarajah@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

The ARM per-task stack protector GCC plugin hits an assert in
the compiler in some case, due to the fact the the SP mask
expression is not sign-extended as it should be. So fix that.

Suggested-by: Kugan Vivekanandarajah <kugan.vivekanandarajah@linaro.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 scripts/gcc-plugins/arm_ssp_per_task_plugin.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/gcc-plugins/arm_ssp_per_task_plugin.c b/scripts/gcc-plugins/arm_ssp_per_task_plugin.c
index de70b8470971..a65fbefb8501 100644
--- a/scripts/gcc-plugins/arm_ssp_per_task_plugin.c
+++ b/scripts/gcc-plugins/arm_ssp_per_task_plugin.c
@@ -13,7 +13,7 @@ static unsigned int arm_pertask_ssp_rtl_execute(void)
 	for (insn = get_insns(); insn; insn = NEXT_INSN(insn)) {
 		const char *sym;
 		rtx body;
-		rtx masked_sp;
+		rtx mask, masked_sp;
 
 		/*
 		 * Find a SET insn involving a SYMBOL_REF to __stack_chk_guard
@@ -33,12 +33,13 @@ static unsigned int arm_pertask_ssp_rtl_execute(void)
 		 * produces the address of the copy of the stack canary value
 		 * stored in struct thread_info
 		 */
+		mask = GEN_INT(sext_hwi(sp_mask, GET_MODE_PRECISION(Pmode)));
 		masked_sp = gen_reg_rtx(Pmode);
 
 		emit_insn_before(gen_rtx_SET(masked_sp,
 					     gen_rtx_AND(Pmode,
 							 stack_pointer_rtx,
-							 GEN_INT(sp_mask))),
+							 mask)),
 				 insn);
 
 		SET_SRC(body) = gen_rtx_PLUS(Pmode, masked_sp,
-- 
2.20.1
