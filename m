From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 24 Mar 2017 13:24:07 +0000
Message-Id: <20170324132410.16628-2-ard.biesheuvel@linaro.org>
In-Reply-To: <20170324132410.16628-1-ard.biesheuvel@linaro.org>
References: <20170324132410.16628-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 1/4] efi/libstub: fix harmless command line parsing bug
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, matt@codeblueprint.co.uk, leif.lindholm@linaro.org, rfranz@cavium.com, mingo@kernel.org, bp@alien8.de, mark.rutland@arm.com, kernel-hardening@lists.openwall.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

When we parse the 'efi=' command line parameter in the stub, we
fail to take spaces into account. Currently, the only way this
could result in unexpected behavior is when the string 'nochunk'
appears as a separate command line argument after 'efi=xxx,yyy,zzz ',
so this is harmless in practice. But let's fix it nonetheless.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 919822b7773d..3290fae0b38f 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -436,14 +436,14 @@ efi_status_t efi_parse_options(char *cmdline)
 	 * Remember, because efi= is also used by the kernel we need to
 	 * skip over arguments we don't understand.
 	 */
-	while (*str) {
+	while (*str && *str != ' ') {
 		if (!strncmp(str, "nochunk", 7)) {
 			str += strlen("nochunk");
 			__chunk_size = -1UL;
 		}
 
 		/* Group words together, delimited by "," */
-		while (*str && *str != ',')
+		while (*str && *str != ' ' && *str != ',')
 			str++;
 
 		if (*str == ',')
-- 
2.9.3
