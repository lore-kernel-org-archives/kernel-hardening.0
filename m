Reply-To: kernel-hardening@lists.openwall.com
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Thu, 24 Mar 2016 03:53:58 +0100
Message-Id: <1458788042-26173-5-git-send-email-mic@digikod.net>
In-Reply-To: <1458788042-26173-1-git-send-email-mic@digikod.net>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
 <1458788042-26173-1-git-send-email-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [RFC v1 13/17] selftest/seccomp: Rename TRACE_poke to TRACE_poke_sys_read
To: linux-security-module@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk@man7.org>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Will Drewry <wad@chromium.org>, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Cosmetic rename for future name derivatives.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paul Moore <pmoore@redhat.com>
Cc: Will Drewry <wad@chromium.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 49c5d39c30a4..7c48d4cf476a 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -1138,14 +1138,14 @@ void tracer_poke(struct __test_metadata *_metadata, pid_t tracee, int status,
 	EXPECT_EQ(0, ret);
 }
 
-FIXTURE_DATA(TRACE_poke) {
+FIXTURE_DATA(TRACE_poke_sys_read) {
 	struct sock_fprog prog;
 	pid_t tracer;
 	long poked;
 	struct tracer_args_poke_t tracer_args;
 };
 
-FIXTURE_SETUP(TRACE_poke)
+FIXTURE_SETUP(TRACE_poke_sys_read)
 {
 	struct sock_filter filter[] = {
 		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
@@ -1170,14 +1170,14 @@ FIXTURE_SETUP(TRACE_poke)
 					   &self->tracer_args);
 }
 
-FIXTURE_TEARDOWN(TRACE_poke)
+FIXTURE_TEARDOWN(TRACE_poke_sys_read)
 {
 	teardown_trace_fixture(_metadata, self->tracer);
 	if (self->prog.filter)
 		free(self->prog.filter);
 }
 
-TEST_F(TRACE_poke, read_has_side_effects)
+TEST_F(TRACE_poke_sys_read, read_has_side_effects)
 {
 	ssize_t ret;
 
@@ -1193,7 +1193,7 @@ TEST_F(TRACE_poke, read_has_side_effects)
 	EXPECT_EQ(0x1001, self->poked);
 }
 
-TEST_F(TRACE_poke, getpid_runs_normally)
+TEST_F(TRACE_poke_sys_read, getpid_runs_normally)
 {
 	long ret;
 
-- 
2.8.0.rc3
