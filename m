From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon,  6 Feb 2017 16:24:29 +0000
Message-Id: <1486398275-3966-2-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1486398275-3966-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1486398275-3966-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 1/7] include: pe.h: allow for use in assembly
To: linux-arm-kernel@lists.infradead.org, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com
Cc: labbott@fedoraproject.org, kernel-hardening@lists.openwall.com, leif.lindholm@linaro.org, pjones@redhat.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Mark Rutland <mark.rutland@arm.com>

Some of the definitions in include/linux/pe.h would be useful for the
EFI stub headers, where values are currently open-coded. Unfortunately
they cannot be used as some structures are also defined in pe.h without
!__ASSEMBLY__ guards.

This patch moves the structure definitions into an #ifdef __ASSEMBLY__
block, so that the common value definitions can be used from assembly.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 include/linux/pe.h | 174 ++++++++++----------
 1 file changed, 89 insertions(+), 85 deletions(-)

diff --git a/include/linux/pe.h b/include/linux/pe.h
index e170b95e763b..a8a594117df3 100644
--- a/include/linux/pe.h
+++ b/include/linux/pe.h
@@ -23,34 +23,6 @@
 
 #define MZ_MAGIC	0x5a4d	/* "MZ" */
 
-struct mz_hdr {
-	uint16_t magic;		/* MZ_MAGIC */
-	uint16_t lbsize;	/* size of last used block */
-	uint16_t blocks;	/* pages in file, 0x3 */
-	uint16_t relocs;	/* relocations */
-	uint16_t hdrsize;	/* header size in "paragraphs" */
-	uint16_t min_extra_pps;	/* .bss */
-	uint16_t max_extra_pps;	/* runtime limit for the arena size */
-	uint16_t ss;		/* relative stack segment */
-	uint16_t sp;		/* initial %sp register */
-	uint16_t checksum;	/* word checksum */
-	uint16_t ip;		/* initial %ip register */
-	uint16_t cs;		/* initial %cs relative to load segment */
-	uint16_t reloc_table_offset;	/* offset of the first relocation */
-	uint16_t overlay_num;	/* overlay number.  set to 0. */
-	uint16_t reserved0[4];	/* reserved */
-	uint16_t oem_id;	/* oem identifier */
-	uint16_t oem_info;	/* oem specific */
-	uint16_t reserved1[10];	/* reserved */
-	uint32_t peaddr;	/* address of pe header */
-	char     message[64];	/* message to print */
-};
-
-struct mz_reloc {
-	uint16_t offset;
-	uint16_t segment;
-};
-
 #define PE_MAGIC		0x00004550	/* "PE\0\0" */
 #define PE_OPT_MAGIC_PE32	0x010b
 #define PE_OPT_MAGIC_PE32_ROM	0x0107
@@ -98,17 +70,6 @@ struct mz_reloc {
 #define IMAGE_FILE_UP_SYSTEM_ONLY            0x4000
 #define IMAGE_FILE_BYTES_REVERSED_HI         0x8000
 
-struct pe_hdr {
-	uint32_t magic;		/* PE magic */
-	uint16_t machine;	/* machine type */
-	uint16_t sections;	/* number of sections */
-	uint32_t timestamp;	/* time_t */
-	uint32_t symbol_table;	/* symbol table offset */
-	uint32_t symbols;	/* number of symbols */
-	uint16_t opt_hdr_size;	/* size of optional header */
-	uint16_t flags;		/* flags */
-};
-
 #define IMAGE_FILE_OPT_ROM_MAGIC	0x107
 #define IMAGE_FILE_OPT_PE32_MAGIC	0x10b
 #define IMAGE_FILE_OPT_PE32_PLUS_MAGIC	0x20b
@@ -134,6 +95,93 @@ struct pe_hdr {
 #define IMAGE_DLLCHARACTERISTICS_WDM_DRIVER             0x2000
 #define IMAGE_DLLCHARACTERISTICS_TERMINAL_SERVER_AWARE  0x8000
 
+/* they actually defined 0x00000000 as well, but I think we'll skip that one. */
+#define IMAGE_SCN_RESERVED_0	0x00000001
+#define IMAGE_SCN_RESERVED_1	0x00000002
+#define IMAGE_SCN_RESERVED_2	0x00000004
+#define IMAGE_SCN_TYPE_NO_PAD	0x00000008 /* don't pad - obsolete */
+#define IMAGE_SCN_RESERVED_3	0x00000010
+#define IMAGE_SCN_CNT_CODE	0x00000020 /* .text */
+#define IMAGE_SCN_CNT_INITIALIZED_DATA 0x00000040 /* .data */
+#define IMAGE_SCN_CNT_UNINITIALIZED_DATA 0x00000080 /* .bss */
+#define IMAGE_SCN_LNK_OTHER	0x00000100 /* reserved */
+#define IMAGE_SCN_LNK_INFO	0x00000200 /* .drectve comments */
+#define IMAGE_SCN_RESERVED_4	0x00000400
+#define IMAGE_SCN_LNK_REMOVE	0x00000800 /* .o only - scn to be rm'd*/
+#define IMAGE_SCN_LNK_COMDAT	0x00001000 /* .o only - COMDAT data */
+#define IMAGE_SCN_RESERVED_5	0x00002000 /* spec omits this */
+#define IMAGE_SCN_RESERVED_6	0x00004000 /* spec omits this */
+#define IMAGE_SCN_GPREL		0x00008000 /* global pointer referenced data */
+/* spec lists 0x20000 twice, I suspect they meant 0x10000 for one of them */
+#define IMAGE_SCN_MEM_PURGEABLE	0x00010000 /* reserved for "future" use */
+#define IMAGE_SCN_16BIT		0x00020000 /* reserved for "future" use */
+#define IMAGE_SCN_LOCKED	0x00040000 /* reserved for "future" use */
+#define IMAGE_SCN_PRELOAD	0x00080000 /* reserved for "future" use */
+/* and here they just stuck a 1-byte integer in the middle of a bitfield */
+#define IMAGE_SCN_ALIGN_1BYTES	0x00100000 /* it does what it says on the box */
+#define IMAGE_SCN_ALIGN_2BYTES	0x00200000
+#define IMAGE_SCN_ALIGN_4BYTES	0x00300000
+#define IMAGE_SCN_ALIGN_8BYTES	0x00400000
+#define IMAGE_SCN_ALIGN_16BYTES	0x00500000
+#define IMAGE_SCN_ALIGN_32BYTES	0x00600000
+#define IMAGE_SCN_ALIGN_64BYTES	0x00700000
+#define IMAGE_SCN_ALIGN_128BYTES 0x00800000
+#define IMAGE_SCN_ALIGN_256BYTES 0x00900000
+#define IMAGE_SCN_ALIGN_512BYTES 0x00a00000
+#define IMAGE_SCN_ALIGN_1024BYTES 0x00b00000
+#define IMAGE_SCN_ALIGN_2048BYTES 0x00c00000
+#define IMAGE_SCN_ALIGN_4096BYTES 0x00d00000
+#define IMAGE_SCN_ALIGN_8192BYTES 0x00e00000
+#define IMAGE_SCN_LNK_NRELOC_OVFL 0x01000000 /* extended relocations */
+#define IMAGE_SCN_MEM_DISCARDABLE 0x02000000 /* scn can be discarded */
+#define IMAGE_SCN_MEM_NOT_CACHED 0x04000000 /* cannot be cached */
+#define IMAGE_SCN_MEM_NOT_PAGED	0x08000000 /* not pageable */
+#define IMAGE_SCN_MEM_SHARED	0x10000000 /* can be shared */
+#define IMAGE_SCN_MEM_EXECUTE	0x20000000 /* can be executed as code */
+#define IMAGE_SCN_MEM_READ	0x40000000 /* readable */
+#define IMAGE_SCN_MEM_WRITE	0x80000000 /* writeable */
+
+#ifndef __ASSEMBLY__
+
+struct mz_hdr {
+	uint16_t magic;		/* MZ_MAGIC */
+	uint16_t lbsize;	/* size of last used block */
+	uint16_t blocks;	/* pages in file, 0x3 */
+	uint16_t relocs;	/* relocations */
+	uint16_t hdrsize;	/* header size in "paragraphs" */
+	uint16_t min_extra_pps;	/* .bss */
+	uint16_t max_extra_pps;	/* runtime limit for the arena size */
+	uint16_t ss;		/* relative stack segment */
+	uint16_t sp;		/* initial %sp register */
+	uint16_t checksum;	/* word checksum */
+	uint16_t ip;		/* initial %ip register */
+	uint16_t cs;		/* initial %cs relative to load segment */
+	uint16_t reloc_table_offset;	/* offset of the first relocation */
+	uint16_t overlay_num;	/* overlay number.  set to 0. */
+	uint16_t reserved0[4];	/* reserved */
+	uint16_t oem_id;	/* oem identifier */
+	uint16_t oem_info;	/* oem specific */
+	uint16_t reserved1[10];	/* reserved */
+	uint32_t peaddr;	/* address of pe header */
+	char     message[64];	/* message to print */
+};
+
+struct mz_reloc {
+	uint16_t offset;
+	uint16_t segment;
+};
+
+struct pe_hdr {
+	uint32_t magic;		/* PE magic */
+	uint16_t machine;	/* machine type */
+	uint16_t sections;	/* number of sections */
+	uint32_t timestamp;	/* time_t */
+	uint32_t symbol_table;	/* symbol table offset */
+	uint32_t symbols;	/* number of symbols */
+	uint16_t opt_hdr_size;	/* size of optional header */
+	uint16_t flags;		/* flags */
+};
+
 /* the fact that pe32 isn't padded where pe32+ is 64-bit means union won't
  * work right.  vomit. */
 struct pe32_opt_hdr {
@@ -243,52 +291,6 @@ struct section_header {
 	uint32_t flags;
 };
 
-/* they actually defined 0x00000000 as well, but I think we'll skip that one. */
-#define IMAGE_SCN_RESERVED_0	0x00000001
-#define IMAGE_SCN_RESERVED_1	0x00000002
-#define IMAGE_SCN_RESERVED_2	0x00000004
-#define IMAGE_SCN_TYPE_NO_PAD	0x00000008 /* don't pad - obsolete */
-#define IMAGE_SCN_RESERVED_3	0x00000010
-#define IMAGE_SCN_CNT_CODE	0x00000020 /* .text */
-#define IMAGE_SCN_CNT_INITIALIZED_DATA 0x00000040 /* .data */
-#define IMAGE_SCN_CNT_UNINITIALIZED_DATA 0x00000080 /* .bss */
-#define IMAGE_SCN_LNK_OTHER	0x00000100 /* reserved */
-#define IMAGE_SCN_LNK_INFO	0x00000200 /* .drectve comments */
-#define IMAGE_SCN_RESERVED_4	0x00000400
-#define IMAGE_SCN_LNK_REMOVE	0x00000800 /* .o only - scn to be rm'd*/
-#define IMAGE_SCN_LNK_COMDAT	0x00001000 /* .o only - COMDAT data */
-#define IMAGE_SCN_RESERVED_5	0x00002000 /* spec omits this */
-#define IMAGE_SCN_RESERVED_6	0x00004000 /* spec omits this */
-#define IMAGE_SCN_GPREL		0x00008000 /* global pointer referenced data */
-/* spec lists 0x20000 twice, I suspect they meant 0x10000 for one of them */
-#define IMAGE_SCN_MEM_PURGEABLE	0x00010000 /* reserved for "future" use */
-#define IMAGE_SCN_16BIT		0x00020000 /* reserved for "future" use */
-#define IMAGE_SCN_LOCKED	0x00040000 /* reserved for "future" use */
-#define IMAGE_SCN_PRELOAD	0x00080000 /* reserved for "future" use */
-/* and here they just stuck a 1-byte integer in the middle of a bitfield */
-#define IMAGE_SCN_ALIGN_1BYTES	0x00100000 /* it does what it says on the box */
-#define IMAGE_SCN_ALIGN_2BYTES	0x00200000
-#define IMAGE_SCN_ALIGN_4BYTES	0x00300000
-#define IMAGE_SCN_ALIGN_8BYTES	0x00400000
-#define IMAGE_SCN_ALIGN_16BYTES	0x00500000
-#define IMAGE_SCN_ALIGN_32BYTES	0x00600000
-#define IMAGE_SCN_ALIGN_64BYTES	0x00700000
-#define IMAGE_SCN_ALIGN_128BYTES 0x00800000
-#define IMAGE_SCN_ALIGN_256BYTES 0x00900000
-#define IMAGE_SCN_ALIGN_512BYTES 0x00a00000
-#define IMAGE_SCN_ALIGN_1024BYTES 0x00b00000
-#define IMAGE_SCN_ALIGN_2048BYTES 0x00c00000
-#define IMAGE_SCN_ALIGN_4096BYTES 0x00d00000
-#define IMAGE_SCN_ALIGN_8192BYTES 0x00e00000
-#define IMAGE_SCN_LNK_NRELOC_OVFL 0x01000000 /* extended relocations */
-#define IMAGE_SCN_MEM_DISCARDABLE 0x02000000 /* scn can be discarded */
-#define IMAGE_SCN_MEM_NOT_CACHED 0x04000000 /* cannot be cached */
-#define IMAGE_SCN_MEM_NOT_PAGED	0x08000000 /* not pageable */
-#define IMAGE_SCN_MEM_SHARED	0x10000000 /* can be shared */
-#define IMAGE_SCN_MEM_EXECUTE	0x20000000 /* can be executed as code */
-#define IMAGE_SCN_MEM_READ	0x40000000 /* readable */
-#define IMAGE_SCN_MEM_WRITE	0x80000000 /* writeable */
-
 enum x64_coff_reloc_type {
 	IMAGE_REL_AMD64_ABSOLUTE = 0,
 	IMAGE_REL_AMD64_ADDR64,
@@ -445,4 +447,6 @@ struct win_certificate {
 	uint16_t cert_type;
 };
 
+#endif /* !__ASSEMBLY__ */
+
 #endif /* __LINUX_PE_H */
-- 
2.7.4
