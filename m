Date: Fri, 8 Dec 2017 20:01:27 +0900
From: Jinbum Park <jinb.park7@gmail.com>
Message-ID: <20171208110127.GA12139@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening][PATCH v6 2/3] arm: mm: dump: make the page table
 dumping seq_file optional
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: afzal.mohd.ma@gmail.com, mark.rutland@arm.com, labbott@redhat.com, linux@armlinux.org.uk, gregkh@linuxfoundation.org, keescook@chromium.org, vladimir.murzin@arm.com, arnd@arndb.de, pombredanne@nexb.com
List-ID: <kernel-hardening.lists.openwall.com>

This patch makes the page table dumping seq_file optional.
It makes the page table dumping code usable for other cases.

This patch refers below commit of arm64.
(ae5d1cf358a5
("arm64: dump: Make the page table dumping seq_file optional"))

Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Laura Abbott <labbott@redhat.com>
Reviewed-by: Laura Abbott <labbott@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
---
v6: No changes
    (Just add Reviewed-by from Kees Cook)
---
 arch/arm/mm/dump.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
index 8dfe7c3..43a2bee 100644
--- a/arch/arm/mm/dump.c
+++ b/arch/arm/mm/dump.c
@@ -34,6 +34,18 @@
 	{ -1,			NULL },
 };
 
+#define pt_dump_seq_printf(m, fmt, args...) \
+({                      \
+	if (m)					\
+		seq_printf(m, fmt, ##args);	\
+})
+
+#define pt_dump_seq_puts(m, fmt)    \
+({						\
+	if (m)					\
+		seq_printf(m, fmt);	\
+})
+
 struct pg_state {
 	struct seq_file *seq;
 	const struct addr_marker *marker;
@@ -210,7 +222,7 @@ static void dump_prot(struct pg_state *st, const struct prot_bits *bits, size_t
 			s = bits->clear;
 
 		if (s)
-			seq_printf(st->seq, " %s", s);
+			pt_dump_seq_printf(st->seq, " %s", s);
 	}
 }
 
@@ -224,7 +236,7 @@ static void note_page(struct pg_state *st, unsigned long addr,
 		st->level = level;
 		st->current_prot = prot;
 		st->current_domain = domain;
-		seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
+		pt_dump_seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
 	} else if (prot != st->current_prot || level != st->level ||
 		   domain != st->current_domain ||
 		   addr >= st->marker[1].start_address) {
@@ -232,7 +244,7 @@ static void note_page(struct pg_state *st, unsigned long addr,
 		unsigned long delta;
 
 		if (st->current_prot) {
-			seq_printf(st->seq, "0x%08lx-0x%08lx   ",
+			pt_dump_seq_printf(st->seq, "0x%08lx-0x%08lx   ",
 				   st->start_address, addr);
 
 			delta = (addr - st->start_address) >> 10;
@@ -240,17 +252,19 @@ static void note_page(struct pg_state *st, unsigned long addr,
 				delta >>= 10;
 				unit++;
 			}
-			seq_printf(st->seq, "%9lu%c", delta, *unit);
+			pt_dump_seq_printf(st->seq, "%9lu%c", delta, *unit);
 			if (st->current_domain)
-				seq_printf(st->seq, " %s", st->current_domain);
+				pt_dump_seq_printf(st->seq, " %s",
+							st->current_domain);
 			if (pg_level[st->level].bits)
 				dump_prot(st, pg_level[st->level].bits, pg_level[st->level].num);
-			seq_printf(st->seq, "\n");
+			pt_dump_seq_printf(st->seq, "\n");
 		}
 
 		if (addr >= st->marker[1].start_address) {
 			st->marker++;
-			seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
+			pt_dump_seq_printf(st->seq, "---[ %s ]---\n",
+							st->marker->name);
 		}
 		st->start_address = addr;
 		st->current_prot = prot;
-- 
1.9.1
