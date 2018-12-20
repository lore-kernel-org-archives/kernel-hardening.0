From: Tycho Andersen <tycho@tycho.ws>
Subject: [RFC v1 2/4] move name-based analysis before linearization
Date: Thu, 20 Dec 2018 12:59:29 -0700
Message-Id: <20181220195931.20331-3-tycho@tycho.ws>
In-Reply-To: <20181220195931.20331-1-tycho@tycho.ws>
References: <20181220195931.20331-1-tycho@tycho.ws>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Tycho Andersen <tycho@tycho.ws>
List-ID: <kernel-hardening.lists.openwall.com>

Based on [1], let's move the function name matching analysis to before
linearization so that we don't destroy type info. This has the added
benefit that we can call the same analysis on inlined functions, since they
haven't been totally inlined yet and still have their name information.

Unfortunately, this means that walking the AST is much more complicated,
because we need to handle all the various expression/statement cases. I've
done what I believe is a mostly complete implementation of this, but there
are a few TODOs here and there as well.

I ported the current size checks to this new point as well.

[1]: https://www.spinics.net/lists/linux-sparse/msg09867.html

Signed-off-by: Tycho Andersen <tycho@tycho.ws>
---
 sparse.c | 193 ++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 156 insertions(+), 37 deletions(-)

diff --git a/sparse.c b/sparse.c
index 151eaf4..217a5bf 100644
--- a/sparse.c
+++ b/sparse.c
@@ -149,68 +149,188 @@ static void check_range_instruction(struct instruction *insn)
 	warning(insn->pos, "value out of range");
 }
 
-static void check_byte_count(struct instruction *insn, pseudo_t count)
+static void check_byte_count(struct position pos, struct expression *size)
 {
-	if (!count)
+	long long val;
+
+	if (!size)
 		return;
-	if (count->type == PSEUDO_VAL) {
-		unsigned long long val = count->value;
-		if (Wmemcpy_max_count && val > fmemcpy_max_count)
-			warning(insn->pos, "%s with byte count of %llu",
-				show_ident(insn->func->sym->ident), val);
+
+	val = get_expression_value_silent(size);
+	if (val == 0)
 		return;
-	}
+
+	if (Wmemcpy_max_count && val > fmemcpy_max_count)
+		warning(pos, "copy with byte count of %llu", val);
 	/* OK, we could try to do the range analysis here */
 }
 
-static pseudo_t argument(struct instruction *call, unsigned int argno)
+static void check_memset(struct position pos, struct expression_list *args)
 {
-	pseudo_t args[8];
-	struct ptr_list *arg_list = (struct ptr_list *) call->arguments;
-
-	argno--;
-	if (linearize_ptr_list(arg_list, (void *)args, 8) > argno)
-		return args[argno];
-	return NULL;
+	struct expression *size = ptr_list_nth_entry((struct ptr_list *)args, 2);
+	check_byte_count(pos, size);
 }
 
-static void check_memset(struct instruction *insn)
-{
-	check_byte_count(insn, argument(insn, 3));
 }
 
+
 #define check_memcpy check_memset
 #define check_ctu check_memset
 #define check_cfu check_memset
 
 struct checkfn {
 	struct ident *id;
-	void (*check)(struct instruction *insn);
+	void (*check)(struct position pos, struct expression_list *args);
+};
+
+static const struct checkfn check_fn[] = {
+	{ &memset_ident, check_memset },
+	{ &memcpy_ident, check_memcpy },
+	{ &copy_to_user_ident, check_ctu },
+	{ &copy_from_user_ident, check_cfu },
 };
 
-static void check_call_instruction(struct instruction *insn)
+static void check_one_statement(struct statement *);
+
+static void check_one_expression(struct position pos, struct expression *expr)
 {
-	pseudo_t fn = insn->func;
-	struct ident *ident;
-	static const struct checkfn check_fn[] = {
-		{ &memset_ident, check_memset },
-		{ &memcpy_ident, check_memcpy },
-		{ &copy_to_user_ident, check_ctu },
-		{ &copy_from_user_ident, check_cfu },
-	};
+	struct expression *call, *fn;
+	struct symbol *direct;
 	int i;
 
-	if (fn->type != PSEUDO_SYM)
+	if (!expr)
+		return;
+
+	if (expr->type == EXPR_STATEMENT) {
+		check_one_statement(expr->statement);
+		return;
+	}
+
+	if (expr->type != EXPR_CALL)
 		return;
-	ident = fn->sym->ident;
-	if (!ident)
+
+	call = expr;
+	fn = call->fn;
+
+	direct = NULL;
+	if (fn->type == EXPR_PREOP) {
+		if (fn->unop->type == EXPR_SYMBOL) {
+			struct symbol *sym = fn->unop->symbol;
+			if (sym->ctype.base_type->type == SYM_FN)
+				direct = sym;
+		}
+	}
+
+	if (!direct)
 		return;
+
 	for (i = 0; i < ARRAY_SIZE(check_fn); i++) {
-		if (check_fn[i].id != ident)
+		if (check_fn[i].id != direct->ident)
 			continue;
-		check_fn[i].check(insn);
+		check_fn[i].check(pos, call->args);
+		return;
+	}
+}
+
+static void check_one_statement(struct statement *stmt)
+{
+	struct ident *ident;
+	int i;
+
+	if (!stmt)
+		return;
+
+	switch (stmt->type) {
+	case STMT_DECLARATION: {
+		struct symbol *sym;
+		FOR_EACH_PTR(stmt->declaration, sym) {
+			check_one_expression(stmt->pos, sym->initializer);
+		} END_FOR_EACH_PTR(sym);
 		break;
 	}
+	case STMT_EXPRESSION:
+		check_one_expression(stmt->pos, stmt->expression);
+		break;
+	case STMT_COMPOUND: {
+		struct statement *s;
+
+		if (stmt->inline_fn) {
+			ident = stmt->inline_fn->ident;
+
+			for (i = 0; i < ARRAY_SIZE(check_fn); i++) {
+				struct symbol *sym;
+				struct expression_list *args = NULL;
+
+				if (check_fn[i].id != ident)
+					continue;
+
+				FOR_EACH_PTR(stmt->args->declaration, sym) {
+					add_expression(&args, sym->initializer);
+				} END_FOR_EACH_PTR(sym);
+
+				check_fn[i].check(stmt->pos, args);
+				free_ptr_list((struct ptr_list **) &args);
+				break;
+			}
+			break;
+		}
+
+		FOR_EACH_PTR(stmt->stmts, s) {
+			check_one_statement(s);
+		} END_FOR_EACH_PTR(s);
+		break;
+	}
+	case STMT_IF:
+		check_one_expression(stmt->pos, stmt->if_conditional);
+		check_one_statement(stmt->if_true);
+		check_one_statement(stmt->if_false);
+		break;
+	case STMT_CASE:
+		check_one_expression(stmt->pos, stmt->case_expression);
+		check_one_expression(stmt->pos, stmt->case_to);
+		check_one_statement(stmt->case_statement);
+		break;
+	case STMT_SWITCH:
+		check_one_expression(stmt->pos, stmt->switch_expression);
+		check_one_statement(stmt->switch_statement);
+		break;
+	case STMT_ITERATOR:
+		check_one_statement(stmt->iterator_pre_statement);
+		check_one_expression(stmt->pos, stmt->iterator_pre_condition);
+		check_one_statement(stmt->iterator_statement);
+		check_one_statement(stmt->iterator_post_statement);
+		check_one_expression(stmt->pos, stmt->iterator_post_condition);
+		break;
+	case STMT_LABEL:
+		check_one_statement(stmt->label_statement);
+		break;
+	case STMT_RANGE:
+		check_one_expression(stmt->pos, stmt->range_expression);
+		check_one_expression(stmt->pos, stmt->range_low);
+		check_one_expression(stmt->pos, stmt->range_high);
+		break;
+	/*
+	 * TODO: STMT_CONTEXT, GOTO, ASM; these could/should all be walked, but
+	 * don't seem super relevant for copy_{to,from}_user().
+	 */
+	default:
+		return;
+	}
+}
+
+static void check_symbol(struct symbol *sym)
+{
+	if (sym->type == SYM_NODE)
+		sym = sym->ctype.base_type;
+
+	switch (sym->type) {
+	case SYM_FN:
+		if (sym->stmt)
+			check_one_statement(sym->stmt);
+		break;
+	default:
+		return;
+	}
 }
 
 static void check_one_instruction(struct instruction *insn)
@@ -224,9 +344,6 @@ static void check_one_instruction(struct instruction *insn)
 	case OP_RANGE:
 		check_range_instruction(insn);
 		break;
-	case OP_CALL:
-		check_call_instruction(insn);
-		break;
 	default:
 		break;
 	}
@@ -314,6 +431,8 @@ static void check_symbols(struct symbol_list *list)
 		struct entrypoint *ep;
 
 		expand_symbol(sym);
+		check_symbol(sym);
+
 		ep = linearize_symbol(sym);
 		if (ep && ep->entry) {
 			if (dbg_entry)
-- 
2.19.1
