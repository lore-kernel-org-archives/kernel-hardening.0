Reply-To: kernel-hardening@lists.openwall.com
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Thu, 24 Mar 2016 03:53:59 +0100
Message-Id: <1458788042-26173-6-git-send-email-mic@digikod.net>
In-Reply-To: <1458788042-26173-1-git-send-email-mic@digikod.net>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
 <1458788042-26173-1-git-send-email-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [RFC v1 14/17] selftest/seccomp: Make tracer_poke() more generic
To: linux-security-module@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk@man7.org>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Will Drewry <wad@chromium.org>, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Use a different flag test (0x2001) than the RET_TRACE value (0x1001) to
not be ambiguous.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paul Moore <pmoore@redhat.com>
Cc: Will Drewry <wad@chromium.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 7c48d4cf476a..f3a6ef4fce62 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -1113,14 +1113,16 @@ void teardown_trace_fixture(struct __test_metadata *_metadata,
 
 /* "poke" tracer arguments and function. */
 struct tracer_args_poke_t {
-	unsigned long poke_addr;
+	unsigned long *poke_addr;
+	unsigned long *poke_data;
+	unsigned long poke_len;
 };
 
 void tracer_poke(struct __test_metadata *_metadata, pid_t tracee, int status,
 		 void *args)
 {
 	int ret;
-	unsigned long msg;
+	unsigned long msg, i;
 	struct tracer_args_poke_t *info = (struct tracer_args_poke_t *)args;
 
 	ret = ptrace(PTRACE_GETEVENTMSG, tracee, NULL, &msg);
@@ -1134,8 +1136,14 @@ void tracer_poke(struct __test_metadata *_metadata, pid_t tracee, int status,
 	 * Registers are not touched to try to keep this relatively arch
 	 * agnostic.
 	 */
-	ret = ptrace(PTRACE_POKEDATA, tracee, info->poke_addr, 0x1001);
-	EXPECT_EQ(0, ret);
+	for (i = 0; i < info->poke_len; i++) {
+		unsigned long addr = (unsigned long)info->poke_addr +
+			i * sizeof(long);
+
+		ret = ptrace(PTRACE_POKEDATA, tracee,
+				addr, *(info->poke_data + i));
+		EXPECT_EQ(0, ret);
+	}
 }
 
 FIXTURE_DATA(TRACE_poke_sys_read) {
@@ -1143,6 +1151,7 @@ FIXTURE_DATA(TRACE_poke_sys_read) {
 	pid_t tracer;
 	long poked;
 	struct tracer_args_poke_t tracer_args;
+	unsigned long flag;
 };
 
 FIXTURE_SETUP(TRACE_poke_sys_read)
@@ -1163,7 +1172,10 @@ FIXTURE_SETUP(TRACE_poke_sys_read)
 	self->prog.len = (unsigned short)ARRAY_SIZE(filter);
 
 	/* Set up tracer args. */
-	self->tracer_args.poke_addr = (unsigned long)&self->poked;
+	self->tracer_args.poke_addr = &self->poked;
+	self->flag = 0x2001;
+	self->tracer_args.poke_data = &self->flag;
+	self->tracer_args.poke_len = 1;
 
 	/* Launch tracer. */
 	self->tracer = setup_trace_fixture(_metadata, tracer_poke,
@@ -1190,7 +1202,7 @@ TEST_F(TRACE_poke_sys_read, read_has_side_effects)
 	EXPECT_EQ(0, self->poked);
 	ret = read(-1, NULL, 0);
 	EXPECT_EQ(-1, ret);
-	EXPECT_EQ(0x1001, self->poked);
+	EXPECT_EQ(0x2001, self->poked);
 }
 
 TEST_F(TRACE_poke_sys_read, getpid_runs_normally)
-- 
2.8.0.rc3
