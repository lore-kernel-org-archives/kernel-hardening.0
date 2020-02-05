Return-Path: <SRS0=S37i=3Z=lists.openwall.com=kernel-hardening-return-17678-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA4FC35247
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 Feb 2020 22:41:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DBF0E214AF
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 Feb 2020 22:41:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DBF0E214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17678-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10101 invoked by uid 550); 5 Feb 2020 22:39:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10003 invoked from network); 5 Feb 2020 22:39:56 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,407,1574150400"; 
   d="scan'208";a="225092459"
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	arjan@linux.intel.com,
	keescook@chromium.org
Cc: rick.p.edgecombe@intel.com,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: [RFC PATCH 08/11] x86: Add support for finer grained KASLR
Date: Wed,  5 Feb 2020 14:39:47 -0800
Message-Id: <20200205223950.1212394-9-kristen@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200205223950.1212394-1-kristen@linux.intel.com>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At boot time, find all the function sections that have separate .text
sections, shuffle them, and then copy them to new locations. Adjust
any relocations accordingly.

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
---
 arch/x86/boot/compressed/Makefile        |   1 +
 arch/x86/boot/compressed/fgkaslr.c       | 751 +++++++++++++++++++++++
 arch/x86/boot/compressed/misc.c          | 106 +++-
 arch/x86/boot/compressed/misc.h          |  26 +
 arch/x86/boot/compressed/vmlinux.symbols |  15 +
 arch/x86/include/asm/boot.h              |  15 +-
 arch/x86/include/asm/kaslr.h             |   1 +
 arch/x86/lib/kaslr.c                     |  15 +
 scripts/kallsyms.c                       |  14 +-
 scripts/link-vmlinux.sh                  |   4 +
 10 files changed, 939 insertions(+), 9 deletions(-)
 create mode 100644 arch/x86/boot/compressed/fgkaslr.c
 create mode 100644 arch/x86/boot/compressed/vmlinux.symbols

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index b7e5ea757ef4..60d4c4e59c05 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -122,6 +122,7 @@ OBJCOPYFLAGS_vmlinux.bin :=  -R .comment -S
 
 ifdef CONFIG_FG_KASLR
 	RELOCS_ARGS += --fg-kaslr
+	OBJCOPYFLAGS += --keep-symbols=$(obj)/vmlinux.symbols
 endif
 
 $(obj)/vmlinux.bin: vmlinux FORCE
diff --git a/arch/x86/boot/compressed/fgkaslr.c b/arch/x86/boot/compressed/fgkaslr.c
new file mode 100644
index 000000000000..fa4e15488a6e
--- /dev/null
+++ b/arch/x86/boot/compressed/fgkaslr.c
@@ -0,0 +1,751 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * fgkaslr.c
+ *
+ * This contains the routines needed to reorder the kernel text section
+ * at boot time.
+ */
+#define __DISABLE_EXPORTS
+#define _LINUX_KPROBES_H
+#define NOKPROBE_SYMBOL(fname)
+
+#include "misc.h"
+#include "error.h"
+#include "pgtable.h"
+#include "../string.h"
+#include "../voffset.h"
+#include <linux/sort.h>
+#include <linux/bsearch.h>
+#include "../../include/asm/extable.h"
+
+/* Macros used by the included decompressor code below. */
+#define STATIC		static
+
+/*
+ * Use normal definitions of mem*() from string.c. There are already
+ * included header files which expect a definition of memset() and by
+ * the time we define memset macro, it is too late.
+ */
+#undef memcpy
+#undef memset
+#define memzero(s, n)	memset((s), 0, (n))
+#define memmove		memmove
+
+/* Functions used by the included decompressor code below. */
+#include <linux/decompress/mm.h>
+void *memmove(void *dest, const void *src, size_t n);
+
+static unsigned long percpu_start;
+static unsigned long percpu_end;
+
+static long kallsyms_names;
+static long kallsyms_offsets;
+static long kallsyms_num_syms;
+static long kallsyms_relative_base;
+static long kallsyms_markers;
+static long __start___ex_table_addr;
+static long __stop___ex_table_addr;
+static long _stext;
+static long _etext;
+static long _sinittext;
+static long _einittext;
+static long fgkaslr_seed;
+
+/* addresses in mapped address space */
+static int *base;
+static u8 *names;
+static unsigned long relative_base;
+static unsigned int *markers_addr;
+static unsigned long long seed[4];
+
+struct kallsyms_name {
+	u8 len;
+	u8 indecis[256];
+};
+struct kallsyms_name *names_table;
+
+/*
+ * This is an array of pointers to sections headers for randomized sections
+ */
+Elf64_Shdr **sections;
+
+/*
+ * This is an array of all section headers, randomized or otherwise.
+ */
+Elf64_Shdr *sechdrs;
+
+/*
+ * The number of elements in the randomized section header array (sections)
+ */
+int sections_size;
+
+static void parse_prandom_seed(void)
+{
+	char optstr[128], *options;
+	unsigned long long a, b, c, d;
+
+	a = b = c = d = 0;
+
+	/*
+	 * passing the fgkaslr_seed option should only be used for
+	 * debugging since the cmdline is exposed to the user
+	 * via /proc/cmdline.
+	 */
+	if (cmdline_find_option("fgkaslr_seed", optstr, sizeof(optstr)) > 0) {
+		int retval;
+
+		options = optstr;
+
+		a = simple_strtoull(options, &options, 16);
+
+		if (options && options[0] == ',')
+			b = simple_strtoull(options+1, &options, 16);
+		if (options && options[0] == ',')
+			c = simple_strtoull(options+1, &options, 16);
+		if (options && options[0] == ',')
+			d = simple_strtoull(options+1, &options, 16);
+	}
+
+	if (a == 0)
+		a = kaslr_get_random_seed(NULL);
+	if (b == 0)
+		b = kaslr_get_random_seed(NULL);
+	if (c == 0)
+		c = kaslr_get_random_seed(NULL);
+	if (d == 0)
+		d = kaslr_get_random_seed(NULL);
+
+	prng_init_seed(a, b, c, d);
+	seed[0] = a;
+	seed[1] = b;
+	seed[2] = c;
+	seed[3] = d;
+}
+
+static bool is_text(long addr)
+{
+	if ((addr >= _stext && addr < _etext) ||
+	   (addr >= _sinittext && addr < _einittext))
+		return true;
+	return false;
+}
+
+bool is_percpu_addr(long pc, long offset)
+{
+	unsigned long ptr;
+	long address;
+
+	address = pc + offset + 4;
+
+	ptr = (unsigned long) address;
+
+	if (ptr >= percpu_start && ptr < percpu_end)
+		return true;
+
+	return false;
+}
+
+static int cmp_section_addr(const void *a, const void *b)
+{
+	unsigned long ptr = (unsigned long)a;
+	Elf64_Shdr *s = *(Elf64_Shdr **)b;
+	unsigned long end = s->sh_addr + s->sh_size;
+
+	if (ptr >= s->sh_addr && ptr < end)
+		return 0;
+
+	if (ptr < s->sh_addr)
+		return -1;
+
+	return 1;
+}
+
+/*
+ * Discover if the address is in a randomized section and if so, adjust
+ * by the saved offset.
+ */
+Elf64_Shdr *adjust_address(long *address)
+{
+	Elf64_Shdr **s;
+	Elf64_Shdr *shdr;
+
+	if (sections == NULL) {
+		debug_putstr("\nsections is null\n");
+		return NULL;
+	}
+
+	s = bsearch((const void *)*address, sections, sections_size, sizeof(*s),
+			cmp_section_addr);
+	if (s != NULL) {
+		shdr = *s;
+		*address += shdr->sh_offset;
+		return shdr;
+	}
+
+	return NULL;
+}
+
+void adjust_relative_offset(long pc, long *value, Elf64_Shdr *section)
+{
+	Elf64_Shdr *s;
+	long address;
+
+	/*
+	 * sometimes we are updating a relative offset that would
+	 * normally be relative to the next instruction (such as a call).
+	 * In this case to calculate the target, you need to add 32bits to
+	 * the pc to get the next instruction value. However, sometimes
+	 * targets are just data that was stored in a table such as ksymtab
+	 * or cpu alternatives. In this case our target is not relative to
+	 * the next instruction.
+	 */
+
+	/*
+	 * Calculate the address that this offset would call.
+	 */
+	if (!is_text(pc))
+		address = pc + *value;
+	else
+		address = pc + *value + 4;
+
+	/*
+	 * if the address is in section that was randomized,
+	 * we need to adjust the offset.
+	 */
+	s = adjust_address(&address);
+	if (s != NULL)
+		*value += s->sh_offset;
+
+	/*
+	 * If the PC that this offset was calculated for was in a section
+	 * that has been randomized, the value needs to be adjusted by the
+	 * same amount as the randomized section was adjusted from it's original
+	 * location.
+	 */
+	if (section != NULL)
+		*value -= section->sh_offset;
+
+}
+
+static void kallsyms_swp(void *a, void *b, int size)
+{
+	int idx1, idx2;
+	int temp;
+	struct kallsyms_name name_a;
+
+	/* determine our index into the array */
+	idx1 = (int *)a - base;
+	idx2 = (int *)b - base;
+	temp = base[idx1];
+	base[idx1] = base[idx2];
+	base[idx2] = temp;
+
+	/* also swap the names table */
+	memcpy(&name_a, &names_table[idx1], sizeof(name_a));
+	memcpy(&names_table[idx1], &names_table[idx2],
+		sizeof(struct kallsyms_name));
+	memcpy(&names_table[idx2], &name_a, sizeof(struct kallsyms_name));
+}
+
+static int kallsyms_cmp(const void *a, const void *b)
+{
+	int addr_a, addr_b;
+	unsigned long uaddr_a, uaddr_b;
+
+	addr_a = *(int *)a;
+	addr_b = *(int *)b;
+
+	if (addr_a >= 0)
+		uaddr_a = addr_a;
+	if (addr_b >= 0)
+		uaddr_b = addr_b;
+
+	if (addr_a < 0)
+		uaddr_a = relative_base - 1 - addr_a;
+	if (addr_b < 0)
+		uaddr_b = relative_base - 1 - addr_b;
+
+	if (uaddr_b > uaddr_a)
+		return -1;
+
+	return 0;
+}
+
+static void deal_with_names(int num_syms)
+{
+	int num_bytes;
+	int i, j;
+	int offset;
+
+
+	/* we should have num_syms kallsyms_name entries */
+	num_bytes = num_syms * sizeof(*names_table);
+	names_table = malloc(num_syms * sizeof(*names_table));
+	if (names_table == NULL) {
+		debug_putstr("\nbytes requested: ");
+		debug_puthex(num_bytes);
+		error("\nunable to allocate space for names table\n");
+	}
+
+	/* read all the names entries */
+	offset = 0;
+	for (i = 0; i < num_syms; i++) {
+		names_table[i].len = names[offset];
+		offset++;
+		for (j = 0; j < names_table[i].len; j++) {
+			names_table[i].indecis[j] = names[offset];
+			offset++;
+		}
+	}
+}
+
+static void write_sorted_names(int num_syms)
+{
+	int i, j;
+	int offset = 0;
+	unsigned int *markers;
+
+	/*
+	 * we are going to need to regenerate the markers table, which is a
+	 * table of offsets into the compressed stream every 256 symbols.
+	 * this code copied almost directly from scripts/kallsyms.c
+	 */
+	markers = malloc(sizeof(unsigned int) * ((num_syms + 255) / 256));
+	if (!markers) {
+		debug_putstr("\nfailed to allocate heap space of ");
+		debug_puthex(((num_syms + 255) / 256));
+		debug_putstr(" bytes\n");
+		error("Unable to allocate space for markers table");
+	}
+
+	for (i = 0; i < num_syms; i++) {
+		if ((i & 0xFF) == 0)
+			markers[i >> 8] = offset;
+
+		names[offset] = (u8) names_table[i].len;
+		offset++;
+		for (j = 0; j < names_table[i].len; j++) {
+			names[offset] = (u8) names_table[i].indecis[j];
+			offset++;
+		}
+	}
+
+	/* write new markers table over old one */
+	for (i = 0; i < ((num_syms + 255) >> 8); i++)
+		markers_addr[i] = markers[i];
+
+	free(markers);
+	free(names_table);
+}
+
+static void sort_kallsyms(unsigned long map)
+{
+	int num_syms;
+	int i;
+
+	debug_putstr("\nRe-sorting kallsyms ...");
+
+	num_syms = *(int *)(kallsyms_num_syms + map);
+	base = (int *)(kallsyms_offsets + map);
+	relative_base = *(unsigned long *)(kallsyms_relative_base + map);
+	markers_addr = (unsigned int *)(kallsyms_markers + map);
+	names = (u8 *)(kallsyms_names + map);
+
+	/*
+	 * the kallsyms table was generated prior to any randomization.
+	 * it is a bunch of offsets from "relative base". In order for
+	 * us to check if a symbol has an address that was in a randomized
+	 * section, we need to reconstruct the address to it's original
+	 * value prior to handle_relocations.
+	 */
+	for (i = 0; i < num_syms; i++) {
+		unsigned long addr;
+		int new_base;
+
+		/*
+		 * according to kernel/kallsyms.c, positive offsets are absolute
+		 * values and negative offsets are relative to the base.
+		 *
+		 * TBD: I think we can just continue if positive value
+		 *      since that would be in the percpu section.
+		 */
+		if (base[i] >= 0)
+			addr = base[i];
+		else
+			addr = relative_base - 1 - base[i];
+
+		if (adjust_address(&addr)) {
+			/* here we need to recalcuate the offset */
+			new_base = relative_base - 1 - addr;
+			base[i] = new_base;
+		}
+	}
+
+	/*
+	 * here we need to read in all the kallsyms_names info
+	 * so that we can regenerate it.
+	 */
+	deal_with_names(num_syms);
+
+	sort(base, num_syms, sizeof(int), kallsyms_cmp, kallsyms_swp);
+
+	/* write the newly sorted names table over the old one */
+	write_sorted_names(num_syms);
+}
+
+#define ARCH_HAS_SEARCH_EXTABLE
+#include "../../../../lib/extable.c"
+
+static inline unsigned long
+ex_fixup_handler(const struct exception_table_entry *x)
+{
+	return ((unsigned long)&x->handler + x->handler);
+}
+
+static inline unsigned long
+ex_fixup_addr(const struct exception_table_entry *x)
+{
+	return ((unsigned long)&x->fixup + x->fixup);
+}
+
+static void update_ex_table(unsigned long map)
+{
+	struct exception_table_entry *start_ex_table = (struct exception_table_entry *) (__start___ex_table_addr + map);
+	struct exception_table_entry *stop_ex_table = (struct exception_table_entry *) (__stop___ex_table_addr + map);
+	int num_entries = ( __stop___ex_table_addr - __start___ex_table_addr ) / sizeof(struct exception_table_entry);
+	int i;
+
+	debug_putstr("\nUpdating exception table...\n");
+	for (i = 0; i < num_entries; i++) {
+		unsigned long insn = ex_to_insn(&start_ex_table[i]);
+		unsigned long fixup = ex_fixup_addr(&start_ex_table[i]);
+		unsigned long handler = ex_fixup_handler(&start_ex_table[i]);
+		unsigned long addr;
+		Elf64_Shdr *s;
+
+		/* check each address to see if it needs adjusting */
+		addr = insn - map;
+		s = adjust_address(&addr);
+		if (s != NULL)
+			start_ex_table[i].insn += s->sh_offset;
+
+		addr = fixup - map;
+		s = adjust_address(&addr);
+		if (s != NULL)
+			start_ex_table[i].fixup += s->sh_offset;
+
+		addr = handler - map;
+		s = adjust_address(&addr);
+		if (s != NULL)
+			start_ex_table[i].handler += s->sh_offset;
+	}
+}
+
+static void sort_ex_table(unsigned long map)
+{
+	struct exception_table_entry *start_ex_table = (struct exception_table_entry *) (__start___ex_table_addr + map);
+	struct exception_table_entry *stop_ex_table = (struct exception_table_entry *) (__stop___ex_table_addr + map);
+
+	debug_putstr("\nRe-sorting exception table...\n");
+
+	sort_extable(start_ex_table, stop_ex_table);
+}
+
+static void write_seed(unsigned long map)
+{
+	unsigned long long *ptr;
+	int i;
+
+	ptr = (unsigned long long *)(fgkaslr_seed + map);
+	for (i = 0; i < 4; i++)
+		ptr[i] = seed[i];
+}
+
+void post_relocations_cleanup(unsigned long map)
+{
+	update_ex_table(map);
+	sort_ex_table(map);
+	write_seed(map);
+	free(sections);
+	free(sechdrs);
+}
+
+void pre_relocations_cleanup(unsigned long map)
+{
+	sort_kallsyms(map);
+}
+
+static void shuffle_sections(int *list, int size)
+{
+	int i;
+	unsigned long j;
+	int temp;
+
+	parse_prandom_seed();
+
+	for (i = size - 1; i > 0; i--) {
+		j = kaslr_get_prandom_long() % (i + 1);
+
+		temp = list[i];
+		list[i] = list[j];
+		list[j] = temp;
+	}
+}
+
+static void move_text(int num_sections, char *secstrings, Elf64_Shdr *text,
+			void *source, void *dest, Elf64_Phdr *phdr)
+{
+	unsigned long adjusted_addr;
+	int copy_bytes;
+	void *stash;
+	Elf64_Shdr **sorted_sections;
+	int *index_list;
+
+	memmove(dest, source + text->sh_offset, text->sh_size);
+	copy_bytes = text->sh_size;
+	dest += text->sh_size;
+	adjusted_addr = text->sh_addr + text->sh_size;
+
+	/*
+	 * we leave the sections sorted in their original order
+	 * by s->sh_addr, but shuffle the indexes in a random
+	 * order for copying.
+	 */
+	index_list = malloc(sizeof(int) * num_sections);
+	if (!index_list)
+		error("Failed to allocate space for index list");
+
+	for (int i = 0; i < num_sections; i++)
+		index_list[i] = i;
+
+	shuffle_sections(index_list, num_sections);
+
+	/*
+	 * to avoid overwriting earlier sections before they can get
+	 * copied to dest, stash everything into a buffer first.
+	 * this will cause our source address to be off by
+	 * phdr->p_offset though, so we'll adjust s->sh_offset below.
+	 *
+	 * TBD: ideally we'd simply decompress higher up so that our
+	 * copy wasn't in danger of overwriting anything important.
+	 */
+	stash = malloc(phdr->p_filesz);
+	if (!stash)
+		error("Failed to allocate space for text stash");
+
+	memcpy(stash, source + phdr->p_offset, phdr->p_filesz);
+
+	/* now we'd walk through the sections. */
+	for (int j = 0; j < num_sections; j++) {
+		unsigned long aligned_addr;
+		Elf64_Shdr *s;
+		const char *sname;
+		void *src;
+
+		s = sections[index_list[j]];
+
+		sname = secstrings + s->sh_name;
+
+		/* align addr for this section */
+		aligned_addr = ALIGN(adjusted_addr, s->sh_addralign);
+		dest = (void *) ALIGN((unsigned long)dest, s->sh_addralign);
+
+		/*
+		 * copy out of stash, so adjust offset
+		 */
+		src = stash + s->sh_offset - phdr->p_offset;
+
+		/* tbd - fill pad bytes with int3 */
+		memmove(dest, src, s->sh_size);
+
+		dest += s->sh_size;
+		copy_bytes += s->sh_size + aligned_addr - adjusted_addr;
+		adjusted_addr = aligned_addr + s->sh_size;
+
+		/* we can blow away sh_offset for our own uses */
+		s->sh_offset = aligned_addr - s->sh_addr;
+	}
+
+	free(index_list);
+
+	/*
+	 * move remainder of text segment. Ok to just use original source
+	 * here since this area is untouched.
+	 */
+	memmove(dest, source + text->sh_offset + copy_bytes, phdr->p_filesz - copy_bytes);
+	free(stash);
+}
+
+#define GET_SYM(name)					\
+	if (strcmp(#name, strtab + sym->st_name) == 0) {\
+		name = sym->st_value;			\
+		continue;				\
+	}
+
+static void parse_symtab(Elf64_Sym *symtab, char *strtab, long num_syms)
+{
+	Elf64_Sym *sym;
+
+	if (symtab == NULL || strtab == NULL)
+		return;
+
+	debug_putstr("\nLooking for symbols... ");
+
+	/*
+	 * walk through the symbol table looking for the symbols
+	 * that we care about.
+	 */
+	for (sym = symtab; --num_syms >= 0; sym++) {
+		if (!sym->st_name)
+			continue;
+
+		GET_SYM(kallsyms_num_syms);
+		GET_SYM(kallsyms_offsets);
+		GET_SYM(kallsyms_relative_base);
+		GET_SYM(kallsyms_names);
+		GET_SYM(kallsyms_markers);
+		GET_SYM(_stext);
+		GET_SYM(_etext);
+		GET_SYM(_sinittext);
+		GET_SYM(_einittext);
+		GET_SYM(fgkaslr_seed);
+
+		/* these have to be renamed */
+		if (strcmp("__start___ex_table", strtab + sym->st_name) == 0) {
+			 __start___ex_table_addr = sym->st_value;
+			continue;
+		}
+
+		if (strcmp("__stop___ex_table", strtab + sym->st_name) == 0) {
+			 __stop___ex_table_addr = sym->st_value;
+			continue;
+		}
+	}
+}
+
+void parse_sections_headers(void *output, Elf64_Ehdr *ehdr, Elf64_Phdr *phdrs)
+{
+	Elf64_Phdr *phdr;
+	Elf64_Shdr *s;
+	Elf64_Shdr *text = NULL;
+	Elf64_Shdr *percpu = NULL;
+	char *secstrings;
+	const char *sname;
+	int num_sections = 0;
+	Elf64_Sym *symtab = NULL;
+	char *strtab = NULL;
+	long num_syms = 0;
+	void *dest;
+	int i;
+
+	debug_putstr("\nParsing ELF section headers... ");
+
+	/*
+	 * TBD: support more than 64K section headers.
+	 */
+
+	/* we are going to need to allocate space for the section headers */
+	sechdrs = malloc(sizeof(*sechdrs) * ehdr->e_shnum);
+	if (!sechdrs)
+		error("Failed to allocate space for shdrs");
+
+	sections = malloc(sizeof(*sections) * ehdr->e_shnum);
+	if (!sections)
+		error("Failed to allocate space for section pointers");
+
+	memcpy(sechdrs, output + ehdr->e_shoff,
+		sizeof(*sechdrs) * ehdr->e_shnum);
+
+	/* we need to allocate space for the section string table */
+	s = &sechdrs[ehdr->e_shstrndx];
+
+	secstrings = malloc(s->sh_size);
+	if (!secstrings)
+		error("Failed to allocate space for shstr");
+
+	memcpy(secstrings, output + s->sh_offset, s->sh_size);
+
+	/*
+	 * now we need to walk through the section headers and collect the
+	 * sizes of the .text sections to be randomized.
+	 */
+	for (i = 0; i < ehdr->e_shnum; i++) {
+		s = &sechdrs[i];
+		sname = secstrings + s->sh_name;
+
+		if (s->sh_type == SHT_SYMTAB) {
+			/* only one symtab per image */
+			symtab = malloc(s->sh_size);
+			if (!symtab)
+				error("Failed to allocate space for symtab");
+
+			memcpy(symtab, output + s->sh_offset, s->sh_size);
+			num_syms = s->sh_size/sizeof(*symtab);
+			continue;
+		}
+
+		if (s->sh_type == SHT_STRTAB && (i != ehdr->e_shstrndx)) {
+			strtab = malloc(s->sh_size);
+			if (!strtab)
+				error("Failed to allocate space for strtab");
+
+			memcpy(strtab, output + s->sh_offset, s->sh_size);
+		}
+
+		if (!strcmp(sname, ".text")) {
+			text = s;
+			continue;
+		}
+
+		if (!strcmp(sname, ".data..percpu")) {
+			/* get start addr for later */
+			percpu = s;
+		}
+
+		if (!(s->sh_flags & SHF_ALLOC) ||
+		    !(s->sh_flags & SHF_EXECINSTR) ||
+		    !(strstarts(sname, ".text")))
+			continue;
+
+		sections[num_sections] = s;
+
+		num_sections++;
+	}
+	sections[num_sections] = NULL;
+	sections_size = num_sections;
+
+	parse_symtab(symtab, strtab, num_syms);
+
+	for (i = 0; i < ehdr->e_phnum; i++) {
+		phdr = &phdrs[i];
+
+		switch (phdr->p_type) {
+		case PT_LOAD:
+			if ((phdr->p_align % 0x200000) != 0)
+				error("Alignment of LOAD segment isn't multiple of 2MB");
+			dest = output;
+			dest += (phdr->p_paddr - LOAD_PHYSICAL_ADDR);
+			if (text && (phdr->p_offset == text->sh_offset)) {
+				move_text(num_sections, secstrings, text, output, dest, phdr);
+			} else {
+				if (percpu && (phdr->p_offset == percpu->sh_offset)) {
+					percpu_start = percpu->sh_addr;
+					percpu_end = percpu_start + phdr->p_filesz;
+				}
+				memmove(dest, output + phdr->p_offset,
+					phdr->p_filesz);
+			}
+			break;
+		default: /* Ignore other PT_* */
+			break;
+		}
+	}
+
+	/* we need to keep the section info to redo relocs */
+	free(secstrings);
+
+	free(phdrs);
+}
+
+#include "../../../../lib/sort.c"
+#include "../../../../lib/bsearch.c"
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 9652d5c2afda..977da0911ce7 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -203,10 +203,20 @@ static void handle_relocations(void *output, unsigned long output_len,
 	if (IS_ENABLED(CONFIG_X86_64))
 		delta = virt_addr - LOAD_PHYSICAL_ADDR;
 
-	if (!delta) {
-		debug_putstr("No relocation needed... ");
-		return;
+	/*
+	 * it is possible to have delta be zero and
+	 * still have enabled fg kaslr. We need to perform relocations
+	 * for fgkaslr regardless of whether the base address has moved.
+	 */
+	if (!IS_ENABLED(CONFIG_FG_KASLR)) {
+		if (!delta) {
+			debug_putstr("No relocation needed... ");
+			return;
+		}
 	}
+
+	pre_relocations_cleanup(map);
+
 	debug_putstr("Performing relocations... ");
 
 	/*
@@ -230,35 +240,106 @@ static void handle_relocations(void *output, unsigned long output_len,
 	 */
 	for (reloc = output + output_len - sizeof(*reloc); *reloc; reloc--) {
 		long extended = *reloc;
+		long value;
+
+		/*
+		 * if using fgkaslr, we might have moved the address
+		 * of the relocation. Check it to see if it needs adjusting
+		 * from the original address.
+		 */
+		(void) adjust_address(&extended);
+
 		extended += map;
 
 		ptr = (unsigned long)extended;
 		if (ptr < min_addr || ptr > max_addr)
 			error("32-bit relocation outside of kernel!\n");
 
-		*(uint32_t *)ptr += delta;
+		value = *(int32_t *)ptr;
+
+		/*
+		 * If using fgkaslr, the value of the relocation
+		 * might need to be changed because it referred
+		 * to an address that has moved.
+		 */
+		adjust_address(&value);
+
+		value += delta;
+
+		*(uint32_t *)ptr = value;
 	}
 #ifdef CONFIG_X86_64
 	while (*--reloc) {
 		long extended = *reloc;
+		long value;
+		long oldvalue;
+		Elf64_Shdr *s;
+
+		/*
+		 * if using fgkaslr, we might have moved the address
+		 * of the relocation. Check it to see if it needs adjusting
+		 * from the original address.
+		 */
+		s = adjust_address(&extended);
+
 		extended += map;
 
 		ptr = (unsigned long)extended;
 		if (ptr < min_addr || ptr > max_addr)
 			error("inverse 32-bit relocation outside of kernel!\n");
 
-		*(int32_t *)ptr -= delta;
+		value = *(int32_t *)ptr;
+		oldvalue = value;
+
+		/*
+		 * If using fgkaslr, these relocs will contain
+		 * relative offsets which might need to be
+		 * changed because it referred
+		 * to an address that has moved.
+		 */
+		adjust_relative_offset(*reloc, &value, s);
+
+		/*
+		 * only percpu symbols need to have their values adjusted for
+		 * base address kaslr since relative offsets within the .text
+		 * and .text.* sections are ok wrt each other.
+		 */
+		if (is_percpu_addr(*reloc, oldvalue))
+			value -= delta;
+
+		*(int32_t *)ptr = value;
 	}
 	for (reloc--; *reloc; reloc--) {
 		long extended = *reloc;
+		long value;
+
+		/*
+		 * if using fgkaslr, we might have moved the address
+		 * of the relocation. Check it to see if it needs adjusting
+		 * from the original address.
+		 */
+		(void) adjust_address(&extended);
+
 		extended += map;
 
 		ptr = (unsigned long)extended;
 		if (ptr < min_addr || ptr > max_addr)
 			error("64-bit relocation outside of kernel!\n");
 
-		*(uint64_t *)ptr += delta;
+		value = *(int64_t *)ptr;
+
+		/*
+		 * If using fgkaslr, the value of the relocation
+		 * might need to be changed because it referred
+		 * to an address that has moved.
+		 */
+		(void) adjust_address(&value);
+
+		value += delta;
+
+		*(uint64_t *)ptr = value;
 	}
+	post_relocations_cleanup(map);
 #endif
 }
 #else
@@ -296,6 +377,11 @@ static void parse_elf(void *output)
 
 	memcpy(phdrs, output + ehdr.e_phoff, sizeof(*phdrs) * ehdr.e_phnum);
 
+	if (IS_ENABLED(CONFIG_FG_KASLR)) {
+		parse_sections_headers(output, &ehdr, phdrs);
+		return;
+	}
+
 	for (i = 0; i < ehdr.e_phnum; i++) {
 		phdr = &phdrs[i];
 
@@ -448,3 +534,11 @@ void fortify_panic(const char *name)
 {
 	error("detected buffer overflow");
 }
+
+/*
+ * TBD: why does including the .c file in this way work, but building
+ * a separate fgkaslr.o file cause memory reads to fail (garbage)?
+ */
+#ifdef CONFIG_FG_KASLR
+#include "fgkaslr.c"
+#endif
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index c8181392f70d..60ceb277596d 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -74,6 +74,32 @@ struct mem_vector {
 	unsigned long long size;
 };
 
+#ifdef CONFIG_X86_64
+#define Elf_Ehdr Elf64_Ehdr
+#define Elf_Phdr Elf64_Phdr
+#define Elf_Shdr Elf64_Shdr
+#else
+#define Elf_Ehdr Elf32_Ehdr
+#define Elf_Phdr Elf32_Phdr
+#define Elf_Shdr Elf32_Shdr
+#endif
+
+#if CONFIG_FG_KASLR
+void parse_sections_headers(void *output, Elf_Ehdr *ehdr, Elf_Phdr *phdrs);
+void pre_relocations_cleanup(unsigned long map);
+void post_relocations_cleanup(unsigned long map);
+Elf_Shdr *adjust_address(long *address);
+void adjust_relative_offset(long pc, long *value, Elf_Shdr *section);
+bool is_percpu_addr(long pc, long offset);
+#else
+static inline void parse_sections_headers(void *output, Elf_Ehdr *ehdr, Elf_Phdr *phdrs) { }
+static inline void pre_relocations_cleanup(unsigned long map) { }
+static inline void post_relocations_cleanup(unsigned long map) { }
+static inline Elf_Shdr *adjust_address(long *address) { return NULL; }
+static inline void adjust_relative_offset(long pc, long *value, Elf_Shdr *section) { }
+static inline bool is_percpu_addr(long pc, long offset) { return true; }
+#endif /* CONFIG_FG_KASLR */
+
 #if CONFIG_RANDOMIZE_BASE
 /* kaslr.c */
 void choose_random_location(unsigned long input,
diff --git a/arch/x86/boot/compressed/vmlinux.symbols b/arch/x86/boot/compressed/vmlinux.symbols
new file mode 100644
index 000000000000..13ef31a0aaf2
--- /dev/null
+++ b/arch/x86/boot/compressed/vmlinux.symbols
@@ -0,0 +1,15 @@
+kallsyms_offsets
+kallsyms_addresses
+kallsyms_num_syms
+kallsyms_relative_base
+kallsyms_names
+kallsyms_token_table
+kallsyms_token_index
+kallsyms_markers
+__start___ex_table
+__stop___ex_table
+_sinittext
+_einittext
+_stext
+_etext
+fgkaslr_seed
diff --git a/arch/x86/include/asm/boot.h b/arch/x86/include/asm/boot.h
index 680c320363db..6918d33eb5ef 100644
--- a/arch/x86/include/asm/boot.h
+++ b/arch/x86/include/asm/boot.h
@@ -26,8 +26,19 @@
 
 #ifdef CONFIG_KERNEL_BZIP2
 # define BOOT_HEAP_SIZE		0x400000
-#else /* !CONFIG_KERNEL_BZIP2 */
-# define BOOT_HEAP_SIZE		 0x10000
+#elif CONFIG_FG_KASLR
+/*
+ * We need extra boot heap when using fgkaslr because we make a copy
+ * of the original decompressed kernel to avoid issues with writing
+ * over ourselves when shuffling the sections. We also need extra
+ * space for resorting kallsyms after shuffling. This value could
+ * be decreased if free() would release memory properly, or if we
+ * could avoid the kernel copy. It would need to be increased if we
+ * find additional tables that need to be resorted.
+ */
+# define BOOT_HEAP_SIZE		0x4000000
+#else /* !CONFIG_KERNEL_BZIP2 && !CONFIG_FG_KASLR */
+# define BOOT_HEAP_SIZE		0x10000
 #endif
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/include/asm/kaslr.h b/arch/x86/include/asm/kaslr.h
index 47d5b25e5b11..f35a9831aaec 100644
--- a/arch/x86/include/asm/kaslr.h
+++ b/arch/x86/include/asm/kaslr.h
@@ -4,6 +4,7 @@
 
 unsigned long kaslr_get_random_seed(const char *purpose);
 unsigned long kaslr_get_prandom_long(void);
+void prng_init_seed(unsigned long a, unsigned long b, unsigned long c, unsigned long d);
 
 #ifdef CONFIG_RANDOMIZE_MEMORY
 void kernel_randomize_memory(void);
diff --git a/arch/x86/lib/kaslr.c b/arch/x86/lib/kaslr.c
index 41b5610855a3..950299d64e1e 100644
--- a/arch/x86/lib/kaslr.c
+++ b/arch/x86/lib/kaslr.c
@@ -144,3 +144,18 @@ unsigned long kaslr_get_prandom_long(void)
 
 	return prng_u64(&state);
 }
+
+void prng_init_seed(unsigned long a, unsigned long b, unsigned long c, unsigned long d)
+{
+	int i;
+
+	state.a = a;
+	state.b = b;
+	state.c = c;
+	state.d = d;
+
+	for (i = 0; i < 30; ++i)
+		(void)prng_u64(&state);
+
+	initialized = true;
+}
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 94153732ec00..2f42c14df0f3 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -60,6 +60,7 @@ static unsigned int table_size, table_cnt;
 static int all_symbols;
 static int absolute_percpu;
 static int base_relative;
+static int fg_kaslr;
 
 static int token_profit[0x10000];
 
@@ -71,7 +72,7 @@ static unsigned char best_table_len[256];
 static void usage(void)
 {
 	fprintf(stderr, "Usage: kallsyms [--all-symbols] "
-			"[--base-relative] < in.map > out.S\n");
+			"[--base-relative] [--fg-kaslr] < in.map > out.S\n");
 	exit(1);
 }
 
@@ -98,6 +99,7 @@ static bool is_ignored_symbol(const char *name, char type)
 		"kallsyms_markers",
 		"kallsyms_token_table",
 		"kallsyms_token_index",
+		"fgkaslr_seed",
 		/* Exclude linker generated symbols which vary between passes */
 		"_SDA_BASE_",		/* ppc */
 		"_SDA2_BASE_",		/* ppc */
@@ -466,6 +468,14 @@ static void write_src(void)
 	output_label("kallsyms_token_index");
 	for (i = 0; i < 256; i++)
 		printf("\t.short\t%d\n", best_idx[i]);
+
+	if (fg_kaslr) {
+		output_label("fgkaslr_seed");
+		printf("\t.quad\t%d\n", 0);
+		printf("\t.quad\t%d\n", 0);
+		printf("\t.quad\t%d\n", 0);
+		printf("\t.quad\t%d\n", 0);
+	}
 	printf("\n");
 }
 
@@ -743,6 +753,8 @@ int main(int argc, char **argv)
 				absolute_percpu = 1;
 			else if (strcmp(argv[i], "--base-relative") == 0)
 				base_relative = 1;
+			else if (strcmp(argv[i], "--fg-kaslr") == 0)
+				fg_kaslr = 1;
 			else
 				usage();
 		}
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 436379940356..33882bbf95cc 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -152,6 +152,10 @@ kallsyms()
 		kallsymopt="${kallsymopt} --base-relative"
 	fi
 
+	if [ -n "${CONFIG_FG_KASLR}" ]; then
+		kallsymopt="${kallsymopt} --fg-kaslr"
+	fi
+
 	local aflags="${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL}               \
 		      ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"
 
-- 
2.24.1

