From: Ruslan Nikolaev <nruslan_devel@yahoo.com>
Subject: [PATCH v1 01/06]: Extending objtool for PIC modules
Message-ID: <a562f9f5-79c1-8a10-8c1e-91fec7ee6614@yahoo.com>
Date: Tue, 15 Jan 2019 13:56:40 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: kernel-hardening@lists.openwall.com
Cc: thgarnie@google.com, x86@kernel.org, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Extending objtool for PIC modules

The patch is by Hassan Nadeem and Ruslan Nikolaev. This extends
the prior PIE kernel patch (by Thomas Garnier) to also support
position-independent modules that can be placed anywhere in the
48/64-bit address space (for better KASLR).

Signed-off-by: Ruslan Nikolaev <nruslan_devel@yahoo.com>
---
  check.c |   39 ++++++++++++++++++++++++++++-----------
  1 file changed, 28 insertions(+), 11 deletions(-)

diff -uprN a/tools/objtool/check.c b/tools/objtool/check.c
--- a/tools/objtool/check.c	2019-01-15 11:20:46.047176216 -0500
+++ b/tools/objtool/check.c	2019-01-15 11:20:57.727294197 -0500
@@ -179,7 +179,7 @@ static int __dead_end_function(struct ob
  		return 0;

  	insn = find_insn(file, func->sec, func->offset);
-	if (!insn->func)
+	if (!insn || !insn->func)
  		return 0;

  	func_for_each_insn_all(file, func, insn) {
@@ -233,6 +233,8 @@ static int __dead_end_function(struct ob

  static int dead_end_function(struct objtool_file *file, struct symbol 
*func)
  {
+	if (!func)
+		return 0;
  	return __dead_end_function(file, func, 0);
  }

@@ -581,7 +583,7 @@ static int add_call_destinations(struct
  	struct rela *rela;

  	for_each_insn(file, insn) {
-		if (insn->type != INSN_CALL)
+		if (insn->type != INSN_CALL && insn->type != INSN_CALL_DYNAMIC)
  			continue;

  		rela = find_rela_by_dest_range(insn->sec, insn->offset,
@@ -590,8 +592,8 @@ static int add_call_destinations(struct
  			dest_off = insn->offset + insn->len + insn->immediate;
  			insn->call_dest = find_symbol_by_offset(insn->sec,
  								dest_off);
-
-			if (!insn->call_dest && !insn->ignore) {
+			if (!insn->call_dest && !insn->ignore &&
+			    insn->type != INSN_CALL_DYNAMIC) {
  				WARN_FUNC("unsupported intra-function call",
  					  insn->sec, insn->offset);
  				if (retpoline)
@@ -602,8 +604,9 @@ static int add_call_destinations(struct
  		} else if (rela->sym->type == STT_SECTION) {
  			insn->call_dest = find_symbol_by_offset(rela->sym->sec,
  								rela->addend+4);
-			if (!insn->call_dest ||
-			    insn->call_dest->type != STT_FUNC) {
+			if ((!insn->call_dest ||
+			     insn->call_dest->type != STT_FUNC) &&
+			    insn->type != INSN_CALL_DYNAMIC) {
  				WARN_FUNC("can't find call dest symbol at %s+0x%x",
  					  insn->sec, insn->offset,
  					  rela->sym->sec->name,
@@ -836,6 +839,11 @@ static int add_switch_table(struct objto
  	struct symbol *pfunc = insn->func->pfunc;
  	unsigned int prev_offset = 0;

+	/* If PC32 relocations are used (as in PIC), the following logic
+	 * can be broken in many ways.
+	 */
+	if (file->ignore_unreachables)
+		return 0;
  	list_for_each_entry_from(rela, &file->rodata->rela->rela_list, list) {
  		if (rela == next_table)
  			break;
@@ -1244,7 +1252,7 @@ static int decode_sections(struct objtoo

  static bool is_fentry_call(struct instruction *insn)
  {
-	if (insn->type == INSN_CALL &&
+	if (insn->call_dest &&
  	    insn->call_dest->type == STT_NOTYPE &&
  	    !strcmp(insn->call_dest->name, "__fentry__"))
  		return true;
@@ -1889,6 +1897,7 @@ static int validate_branch(struct objtoo
  			return 0;

  		case INSN_CALL:
+		case INSN_CALL_DYNAMIC:
  			if (is_fentry_call(insn))
  				break;

@@ -1898,8 +1907,6 @@ static int validate_branch(struct objtoo
  			if (ret == -1)
  				return 1;

-			/* fallthrough */
-		case INSN_CALL_DYNAMIC:
  			if (!no_fp && func && !has_valid_stack_frame(&state)) {
  				WARN_FUNC("call without frame pointer save/setup",
  					  sec, insn->offset);
@@ -1929,12 +1936,15 @@ static int validate_branch(struct objtoo
  			break;

  		case INSN_JUMP_DYNAMIC:
+			/* XXX: Does not work properly with PIC code. */
+#if 0
  			if (func && list_empty(&insn->alts) &&
  			    has_modified_stack_frame(&state)) {
  				WARN_FUNC("sibling call from callable instruction with modified 
stack frame",
  					  sec, insn->offset);
  				return 1;
  			}
+#endif

  			return 0;

@@ -2015,6 +2025,11 @@ static int validate_retpoline(struct obj
  		if (!strcmp(insn->sec->name, ".init.text") && !module)
  			continue;

+		/* ignore ftrace calls in PIC code */
+		if (!insn->call_dest ||
+		    !strcmp(insn->call_dest->name, "__fentry__"))
+			continue;
+
  		WARN_FUNC("indirect %s found in RETPOLINE build",
  			  insn->sec, insn->offset,
  			  insn->type == INSN_JUMP_DYNAMIC ? "jump" : "call");
@@ -2027,13 +2042,15 @@ static int validate_retpoline(struct obj

  static bool is_kasan_insn(struct instruction *insn)
  {
-	return (insn->type == INSN_CALL &&
+	return ((insn->type == INSN_CALL || insn->type == INSN_CALL_DYNAMIC) &&
+		insn->call_dest &&
  		!strcmp(insn->call_dest->name, "__asan_handle_no_return"));
  }

  static bool is_ubsan_insn(struct instruction *insn)
  {
-	return (insn->type == INSN_CALL &&
+	return ((insn->type == INSN_CALL || insn->type == INSN_CALL_DYNAMIC) &&
+		insn->call_dest &&
  		!strcmp(insn->call_dest->name,
  			"__ubsan_handle_builtin_unreachable"));
  }
