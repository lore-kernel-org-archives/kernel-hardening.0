From: Tycho Andersen <tycho@tycho.ws>
Subject: [RFC v1 3/4] add a check for copy_to_user() address spaces
Date: Thu, 20 Dec 2018 12:59:30 -0700
Message-Id: <20181220195931.20331-4-tycho@tycho.ws>
In-Reply-To: <20181220195931.20331-1-tycho@tycho.ws>
References: <20181220195931.20331-1-tycho@tycho.ws>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Tycho Andersen <tycho@tycho.ws>
List-ID: <kernel-hardening.lists.openwall.com>

Leaking kernel pointers to userspace is a bad idea, so let's try to do some
analysis for it.

The basic idea is that every pointer copied to userspace "should be" (but
isn't necessarily) annotated with __user, and if it is not, then it's a
potential infoleak. The motivation for this is stuff like [1], which is
exactly a case of this. Based on a subsequent manual analysis of the uapi
headers, I found [2].

Unfortunately in both of these cases, there is void * (for compat) trickery
that masks them from actually turning up in this case. But hey, I wrote it
and tried it out, so perhaps the code is useful for someone :)

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/block/floppy.c?id=65eea8edc315589d6c993cf12dbb5d0e9ef1fe4e
[2]: https://lkml.org/lkml/2018/11/3/142

Signed-off-by: Tycho Andersen <tycho@tycho.ws>
---
 sparse.c                  | 93 ++++++++++++++++++++++++++++++++++++++-
 validation/copy_to_user.c | 31 +++++++++++++
 2 files changed, 123 insertions(+), 1 deletion(-)

diff --git a/sparse.c b/sparse.c
index 217a5bf..8bcbe16 100644
--- a/sparse.c
+++ b/sparse.c
@@ -171,13 +171,104 @@ static void check_memset(struct position pos, struct expression_list *args)
 	check_byte_count(pos, size);
 }
 
+static struct symbol *resolve_arg_type(struct position pos, struct expression *arg)
+{
+	struct expression *uncast;
+
+	uncast = arg;
+	switch (arg->type) {
+	case EXPR_CAST:
+	case EXPR_FORCE_CAST:
+	case EXPR_IMPLIED_CAST:
+		/*
+		 * Undo any casting done by sparse to the function's
+		 * argument type.
+		 */
+		uncast = arg->cast_expression;
+		break;
+	case EXPR_SYMBOL:
+		break;
+	case EXPR_PREOP:
+		/*
+		 * handle derefs; these are really just the type of the
+		 * resulting expression.
+		 */
+		break;
+	case EXPR_BINOP:
+		/* TODO: resolve this pointer math if possible? */
+		return NULL;
+	default:
+		warning(pos, "huh? arg not a cast or symbol? %d", arg->type);
+		return NULL;
+	}
+
+	return uncast->ctype->ctype.base_type;
+}
+
+static void check_ptr_in_other_as(struct position pos, struct symbol *sym, int this_as)
+{
+	struct ident *ident = sym->ident;
+
+	if (sym->type == SYM_NODE)
+		sym = sym->ctype.base_type;
+
+	switch (sym->type) {
+	case SYM_ARRAY:
+	case SYM_PTR: {
+		if (sym->ctype.as != this_as)
+			warning(pos, "member %s is a kernel pointer copied to userspace", show_ident(ident));
+		check_ptr_in_other_as(pos, sym->ctype.base_type, this_as);
+		break;
+	}
+	case SYM_STRUCT:
+	case SYM_UNION: {
+		struct symbol *member;
+
+		FOR_EACH_PTR(sym->symbol_list, member) {
+			check_ptr_in_other_as(pos, member, this_as);
+		} END_FOR_EACH_PTR(member);
+		break;
+	}
+	default:
+		/*
+		 * scalar types are ok
+		 * TODO: what about SYM_LABEL/PREPROCESSOR?
+		 */
+		break;
+	}
+}
+
+static void check_no_kernel_pointers(struct position pos, struct expression_list *args)
+{
+	struct expression *src = ptr_list_nth_entry((struct ptr_list *)args, 1);
+	struct symbol *base = NULL;
+
+	if (!Waddress_space)
+		return;
+
+	/* get the type of src */
+	base = resolve_arg_type(pos, src);
+
+	/*
+	 * And deref it to *src; src will *always* be a kernel pointer, and
+	 * we're really after members of structures here, not the pointers
+	 * themselves. So we do this deref at the top level.
+	 */
+	base = base->ctype.base_type;
+
+	check_ptr_in_other_as(pos, base, 1);
 }
 
 
 #define check_memcpy check_memset
-#define check_ctu check_memset
 #define check_cfu check_memset
 
+void check_ctu(struct position pos, struct expression_list *args)
+{
+	check_memset(pos, args);
+	check_no_kernel_pointers(pos, args);
+}
+
 struct checkfn {
 	struct ident *id;
 	void (*check)(struct position pos, struct expression_list *args);
diff --git a/validation/copy_to_user.c b/validation/copy_to_user.c
new file mode 100644
index 0000000..d9cded6
--- /dev/null
+++ b/validation/copy_to_user.c
@@ -0,0 +1,31 @@
+#define __user __attribute__((address_space(1)))
+
+struct bar {
+	char *bar_kptr;
+};
+
+struct foo {
+	char *foo_kptr;
+	char __user *uptr;
+	struct bar bar;
+};
+
+static void copy_to_user(void __user *to, const void *from, unsigned long n)
+{
+}
+
+static void bar(void)
+{
+	struct foo f;
+	void __user *p = (void __user *)0;
+
+	copy_to_user(p, &f, sizeof(f));
+}
+/*
+ * check-name: copy_to_user arguments
+ *
+ * check-error-start
+copy_to_user.c:22:9: warning: member foo_kptr is a kernel pointer copied to userspace
+copy_to_user.c:22:9: warning: member bar_kptr is a kernel pointer copied to userspace
+ * check-error-end
+ */
-- 
2.19.1
