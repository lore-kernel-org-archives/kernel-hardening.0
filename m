Reply-To: kernel-hardening@lists.openwall.com
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Thu, 24 Mar 2016 03:54:00 +0100
Message-Id: <1458788042-26173-7-git-send-email-mic@digikod.net>
In-Reply-To: <1458788042-26173-1-git-send-email-mic@digikod.net>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
 <1458788042-26173-1-git-send-email-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [RFC v1 15/17] selftest/seccomp: Add argeval_toctou_argument test
To: linux-security-module@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk@man7.org>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Will Drewry <wad@chromium.org>, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Test if a time-of-check-time-of-use (TOCTOU) race condition attack is
effective to change a syscall argument after the seccomp filter
evaluation but before the effective syscall.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paul Moore <pmoore@redhat.com>
Cc: Will Drewry <wad@chromium.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 157 ++++++++++++++++++++++++++
 1 file changed, 157 insertions(+)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index f3a6ef4fce62..64b4d758b007 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -2363,6 +2363,163 @@ TEST(argeval_open_whitelist)
 	EXPECT_EQ(E2BIG, errno);
 	close(fd);
 }
+
+FIXTURE_DATA(TRACE_poke_arg_path) {
+	struct sock_fprog prog;
+	pid_t tracer;
+	struct tracer_args_poke_t tracer_args;
+	char *path_orig;
+	char *path_hijack;
+};
+
+FIXTURE_SETUP(TRACE_poke_arg_path)
+{
+	unsigned long orig_delta, orig_size, hijack_delta, hijack_size;
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_open, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_TRACE | 0x1001),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+
+	memset(&self->prog, 0, sizeof(self->prog));
+	self->prog.filter = malloc(sizeof(filter));
+	ASSERT_NE(NULL, self->prog.filter);
+	memcpy(self->prog.filter, filter, sizeof(filter));
+	self->prog.len = (unsigned short)ARRAY_SIZE(filter);
+
+	/* @path_orig must be writable */
+	orig_delta = sizeof(PATH_DEV_ZERO) % sizeof(long);
+	orig_size = sizeof(PATH_DEV_ZERO) - orig_delta +
+		(orig_delta ? sizeof(long) : 0);
+	self->path_orig = malloc(orig_size);
+	ASSERT_NE(NULL, self->path_orig);
+	memset(self->path_orig, 0, orig_size);
+	memcpy(self->path_orig, PATH_DEV_ZERO, sizeof(PATH_DEV_ZERO));
+	self->tracer_args.poke_addr = (unsigned long *)self->path_orig;
+
+	hijack_delta = sizeof(PATH_DEV_NULL) % sizeof(long);
+	hijack_size = sizeof(PATH_DEV_NULL) - hijack_delta +
+		(hijack_delta ? sizeof(long) : 0);
+	/* @path_hijack must be able to override @path_orig */
+	ASSERT_GE(orig_size, hijack_size);
+	self->path_hijack = malloc(hijack_size);
+	ASSERT_NE(NULL, self->path_hijack);
+	memset(self->path_hijack, 0, hijack_size);
+	memcpy(self->path_hijack, PATH_DEV_NULL, sizeof(PATH_DEV_NULL));
+	self->tracer_args.poke_data = (unsigned long *)self->path_hijack;
+	self->tracer_args.poke_len = hijack_size;
+
+	/* Launch tracer */
+	self->tracer = setup_trace_fixture(_metadata, tracer_poke,
+					   &self->tracer_args);
+}
+
+FIXTURE_TEARDOWN(TRACE_poke_arg_path)
+{
+	teardown_trace_fixture(_metadata, self->tracer);
+	if (self->prog.filter)
+		free(self->prog.filter);
+	if (self->path_orig)
+		free(self->path_orig);
+}
+
+/* Any tracer process can bypass a seccomp filter, so we can't protect against
+ * this threat and should deny any ptrace call from a seccomped process to be
+ * able to properly sandbox it.
+ *
+ * However, a seccomped process can fork and ask its child to change a shared
+ * memory used to hold the syscall arguments. This can be used to trigger
+ * TOCTOU race conditions between the filter evaluation and the effective
+ * syscall operations. For test purpose, it is simpler to ask a dedicated
+ * tracer process to do the same action after the filter evaluation to acheive
+ * the same result. The kernel must detect and block this race condition.
+ */
+TEST_F(TRACE_poke_arg_path, argeval_toctou_argument)
+{
+	int fd;
+	char buf;
+	ssize_t len;
+
+	/* Validate the first test file */
+	fd = open(self->path_orig, O_RDONLY);
+	EXPECT_NE(-1, fd) {
+		TH_LOG("Failed to open %s", self->path_orig);
+	}
+	len = read(fd, &buf, sizeof(buf));
+	EXPECT_EQ(1, len) {
+		TH_LOG("Failed to read from %s", self->path_orig);
+	}
+	EXPECT_EQ(0, buf) {
+		TH_LOG("Got unexpected value from %s", self->path_orig);
+	}
+	close(fd);
+
+	/* Validate the second test file */
+	fd = open(self->path_hijack, O_RDONLY);
+	EXPECT_NE(-1, fd) {
+		TH_LOG("Failed to open %s", self->path_hijack);
+	}
+	len = read(fd, &buf, sizeof(buf));
+	EXPECT_EQ(0, len) {
+		TH_LOG("Able to read from %s", self->path_orig);
+	}
+	close(fd);
+
+	apply_sandbox0(_metadata, PATH_DEV_ZERO);
+
+	/* Allowed file: /dev/zero */
+	fd = open(self->path_orig, O_RDONLY);
+	EXPECT_NE(-1, fd) {
+		TH_LOG("Failed to open %s", self->path_orig);
+	}
+	len = read(fd, &buf, sizeof(buf));
+	EXPECT_EQ(1, len) {
+		TH_LOG("Failed to read from %s", self->path_orig);
+	}
+	EXPECT_EQ(0, buf) {
+		TH_LOG("Got unexpected value from %s", self->path_orig);
+	}
+	close(fd);
+
+	/* Denied file: /dev/null */
+	fd = open(self->path_hijack, O_RDONLY);
+	EXPECT_EQ(-1, fd) {
+		TH_LOG("Could open %s", self->path_hijack);
+	}
+	close(fd);
+
+	/* Setup the hijack for every open: replace /dev/zero with /dev/null */
+	EXPECT_EQ(0, seccomp(SECCOMP_SET_MODE_FILTER,
+				SECCOMP_FILTER_FLAG_TSYNC, &self->prog)) {
+		TH_LOG("Failed to install filter!");
+	}
+
+	/* Should read /dev/zero even if it is hijacked with /dev/null after
+	 * the filter
+	 */
+	fd = open(self->path_orig, O_RDONLY);
+	EXPECT_NE(-1, fd) {
+		TH_LOG("Failed to open %s", self->path_orig);
+	}
+	len = read(fd, &buf, sizeof(buf));
+	EXPECT_EQ(1, len) {
+		TH_LOG("Failed to read from %s", self->path_orig);
+	}
+	EXPECT_EQ(0, buf) {
+		TH_LOG("Got unexpected value from %s", self->path_orig);
+	}
+	close(fd);
+
+	/* Now path_orig is definitely hijacked, so it must be denied */
+	fd = open(self->path_orig, O_RDONLY);
+	EXPECT_EQ(-1, fd) {
+		TH_LOG("Could open %s", self->path_orig);
+	}
+	EXPECT_EQ(E2BIG, errno);
+	close(fd);
+}
 #endif /* SECCOMP_DATA_ARGEVAL_PRESENT */
 
 /*
-- 
2.8.0.rc3
