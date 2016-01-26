Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 26 Jan 2016 18:10:42 +0100
Message-Id: <1453828249-14467-16-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v4 15/22] scripts/sortextable: add support for ET_DYN binaries
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, labbott@fedoraproject.org, matt@codeblueprint.co.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Add support to scripts/sortextable for handling relocatable (PIE)
executables, whose ELF type is ET_DYN, not ET_EXEC. Other than adding
support for the new type, no changes are needed.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 scripts/sortextable.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/sortextable.c b/scripts/sortextable.c
index af247c70fb66..19d83647846c 100644
--- a/scripts/sortextable.c
+++ b/scripts/sortextable.c
@@ -266,9 +266,9 @@ do_file(char const *const fname)
 		break;
 	}  /* end switch */
 	if (memcmp(ELFMAG, ehdr->e_ident, SELFMAG) != 0
-	||  r2(&ehdr->e_type) != ET_EXEC
+	||  (r2(&ehdr->e_type) != ET_EXEC && r2(&ehdr->e_type) != ET_DYN)
 	||  ehdr->e_ident[EI_VERSION] != EV_CURRENT) {
-		fprintf(stderr, "unrecognized ET_EXEC file %s\n", fname);
+		fprintf(stderr, "unrecognized ET_EXEC/ET_DYN file %s\n", fname);
 		fail_file();
 	}
 
@@ -304,7 +304,7 @@ do_file(char const *const fname)
 		if (r2(&ehdr->e_ehsize) != sizeof(Elf32_Ehdr)
 		||  r2(&ehdr->e_shentsize) != sizeof(Elf32_Shdr)) {
 			fprintf(stderr,
-				"unrecognized ET_EXEC file: %s\n", fname);
+				"unrecognized ET_EXEC/ET_DYN file: %s\n", fname);
 			fail_file();
 		}
 		do32(ehdr, fname, custom_sort);
@@ -314,7 +314,7 @@ do_file(char const *const fname)
 		if (r2(&ghdr->e_ehsize) != sizeof(Elf64_Ehdr)
 		||  r2(&ghdr->e_shentsize) != sizeof(Elf64_Shdr)) {
 			fprintf(stderr,
-				"unrecognized ET_EXEC file: %s\n", fname);
+				"unrecognized ET_EXEC/ET_DYN file: %s\n", fname);
 			fail_file();
 		}
 		do64(ghdr, fname, custom_sort);
-- 
2.5.0
