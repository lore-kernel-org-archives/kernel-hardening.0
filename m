From: Tycho Andersen <tycho@tycho.ws>
Subject: [RFC v1 4/4] check copy_to_user() sizes
Date: Thu, 20 Dec 2018 12:59:31 -0700
Message-Id: <20181220195931.20331-5-tycho@tycho.ws>
In-Reply-To: <20181220195931.20331-1-tycho@tycho.ws>
References: <20181220195931.20331-1-tycho@tycho.ws>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Tycho Andersen <tycho@tycho.ws>
List-ID: <kernel-hardening.lists.openwall.com>

The intent here is to be a smarter version of the size checking that's just
a hard coded constant. The insight is that we know the type of the thing
that's getting passed to copy_to_user(), so if we can evaluate the size, it
should be <= sizeof(*the thing being copied).

I've run this over x86 with allyes config, and it didn't find anything, so
perhaps it isn't particularly useful. Indeed, most copy_to_user()s look
like:

        copy_to_user(p, &foo, sizeof(foo))

so perhaps this isn't a surprise.

The one potentially interesting case is the hard coded array length case:
it's possible someone might change one place but not the other. See e.g.
the first copy_to_user() in drivers/ata/libata-scsi.c, which looks like:

        copy_to_user(dst, dev->id, ATA_ID_WORDS * sizeof(u16))

id here is a u16 id[ATA_ID_WORDS], so it would be possible to change this
in one place or not the other. Unfortunately, sparse seems to unify the
type of dev->id to a u16* instead of u16[], so we can't see through this.

Anyway, there are currently no violations of this in the kernel either,
although it does emit some false positives like,

fs/xfs/xfs_ioctl.c:1813:25: warning: copy_to_user() where size (13) is larger than src (1)

due to the above. I wrote the code, so perhaps someday it will be useful to
someone, so I'm posting it :)

Signed-off-by: Tycho Andersen <tycho@tycho.ws>
---
 sparse.c                               | 45 ++++++++++++++++++++++
 validation/copy_to_user_sizes.c        | 53 ++++++++++++++++++++++++++
 validation/copy_to_user_sizes_inline.c | 29 ++++++++++++++
 3 files changed, 127 insertions(+)

diff --git a/sparse.c b/sparse.c
index 8bcbe16..eb7d5d7 100644
--- a/sparse.c
+++ b/sparse.c
@@ -31,6 +31,7 @@
 #include <ctype.h>
 #include <unistd.h>
 #include <fcntl.h>
+#include <limits.h>
 
 #include "lib.h"
 #include "allocate.h"
@@ -259,6 +260,49 @@ static void check_no_kernel_pointers(struct position pos, struct expression_list
 	check_ptr_in_other_as(pos, base, 1);
 }
 
+static void check_copy_size(struct position pos, struct expression_list *args)
+{
+	struct expression *src = ptr_list_nth_entry((struct ptr_list *)args, 1);
+	struct expression *size = ptr_list_nth_entry((struct ptr_list *)args, 2);
+	long long src_actual = LLONG_MAX;
+	long long size_actual;
+	struct symbol *base, *deref;
+
+	/* get the type of src */
+	base = resolve_arg_type(pos, src);
+
+	/* and deref it to *src */
+	deref = base->ctype.base_type;
+
+	/*
+	 * Note, this is never hit right now because sparse seems to unify
+	 * arrays that are arguments to type *.
+	 */
+	if (is_array_type(base)) {
+		long long array_size = get_expression_value_silent(base->array_size);
+		printf("%s is array type\n", show_ident(base->ident));
+
+		/* failed to evaluate */
+		if (array_size == 0)
+			return;
+		src_actual = array_size * bits_to_bytes(deref->bit_size);
+	} else {
+		src_actual = bits_to_bytes(deref->bit_size);
+	}
+
+	/* Evaluate size, if we can */
+	size_actual = get_expression_value_silent(size);
+	/*
+	 * size_actual == 0 means that get_expression_value failed; of
+	 * course we'll miss something if there is a 0 length copy, but
+	 * then nothing will leak anyway so...
+	 */
+	if (size_actual == 0)
+		return;
+
+	if (size_actual > src_actual)
+		warning(pos, "copy_to_user() where size (%lld) is larger than src (%lld)", size_actual, src_actual);
+}
 
 #define check_memcpy check_memset
 #define check_cfu check_memset
@@ -267,6 +311,7 @@ void check_ctu(struct position pos, struct expression_list *args)
 {
 	check_memset(pos, args);
 	check_no_kernel_pointers(pos, args);
+	check_copy_size(pos, args);
 }
 
 struct checkfn {
diff --git a/validation/copy_to_user_sizes.c b/validation/copy_to_user_sizes.c
new file mode 100644
index 0000000..f1f7b8e
--- /dev/null
+++ b/validation/copy_to_user_sizes.c
@@ -0,0 +1,53 @@
+static void copy_to_user(void *to, const void *from, unsigned long n)
+{
+}
+
+struct foo {
+	int bar;
+};
+
+static void main(void)
+{
+	void *p;
+	struct foo f;
+	int uninitialized;
+
+	copy_to_user(p, &f, sizeof(f));
+	copy_to_user(p, &f, sizeof(f)-1);
+	copy_to_user(p, &f, sizeof(f)+1);
+	copy_to_user(p, &f, 1);
+	copy_to_user(p, &f, 100);
+	copy_to_user(p, &f, uninitialized);
+}
+
+#if 0
+static void broken(void)
+{
+	void *p;
+	char arr[100];
+	struct foo foo_arr[2];
+
+	/*
+	 * These all fail right now, because sparse seems to unify the type of
+	 * arr/foo_arr to char * /struct foo *, instead of char[]/struct foo[].
+	 *
+	 * That's unfortunate, because it means that these generate false
+	 * positives in the kernel when using a static array length, and that
+	 * seems like a case where this type of check would be especially
+	 * useful.
+	 */
+	copy_to_user(p, arr, 100);
+	copy_to_user(p, arr, 101);
+	copy_to_user(p, foo_arr, sizeof(foo_arr));
+	copy_to_user(p, foo_arr, sizeof(foo_arr)-1);
+	copy_to_user(p, foo_arr, sizeof(foo_arr[0])*2);
+}
+#endif
+/*
+ * check-name: copy_to_user sizes
+ *
+ * check-error-start
+copy_to_user_sizes.c:17:9: warning: copy_to_user() where size (5) is larger than src (4)
+copy_to_user_sizes.c:19:9: warning: copy_to_user() where size (100) is larger than src (4)
+ * check-error-end
+ */
diff --git a/validation/copy_to_user_sizes_inline.c b/validation/copy_to_user_sizes_inline.c
new file mode 100644
index 0000000..bd3c3bd
--- /dev/null
+++ b/validation/copy_to_user_sizes_inline.c
@@ -0,0 +1,29 @@
+static inline void copy_to_user(void *to, const void *from, unsigned long n)
+{
+}
+
+struct foo {
+	int bar;
+};
+
+static void main(void)
+{
+	void *p;
+	struct foo f;
+	int uninitialized;
+
+	copy_to_user(p, &f, sizeof(f));
+	copy_to_user(p, &f, sizeof(f)-1);
+	copy_to_user(p, &f, sizeof(f)+1);
+	copy_to_user(p, &f, 1);
+	copy_to_user(p, &f, 100);
+	copy_to_user(p, &f, uninitialized);
+}
+/*
+ * check-name: copy_to_user sizes
+ *
+ * check-error-start
+copy_to_user_sizes_inline.c:17:21: warning: copy_to_user() where size (5) is larger than src (4)
+copy_to_user_sizes_inline.c:19:21: warning: copy_to_user() where size (100) is larger than src (4)
+ * check-error-end
+ */
-- 
2.19.1
