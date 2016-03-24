Reply-To: kernel-hardening@lists.openwall.com
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Thu, 24 Mar 2016 03:53:54 +0100
Message-Id: <1458788042-26173-1-git-send-email-mic@digikod.net>
In-Reply-To: <1458784008-16277-1-git-send-email-mic@digikod.net>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [RFC v1 09/17] selftest/seccomp: Extend seccomp_data until matches[6]
To: linux-security-module@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk@man7.org>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Will Drewry <wad@chromium.org>, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paul Moore <pmoore@redhat.com>
Cc: Will Drewry <wad@chromium.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 023717bf3185..edaa405111aa 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -84,13 +84,21 @@ struct seccomp_data {
 	__u32 arch;
 	__u64 instruction_pointer;
 	__u64 args[6];
+	__u32 is_valid_syscall; /* SECCOMP_DATA_VALIDSYS_PRESENT */
+	__u32 checker_group; /* SECCOMP_DATA_ARGEVAL_PRESENT */
+	__u64 arg_matches[6]; /* SECCOMP_DATA_ARGEVAL_PRESENT */
 };
+
+#define SECCOMP_DATA_ARGEVAL_PRESENT
 #endif
 
 #if __BYTE_ORDER == __LITTLE_ENDIAN
 #define syscall_arg(_n) (offsetof(struct seccomp_data, args[_n]))
+#define match_arg(_n) (offsetof(struct seccomp_data, arg_matches[_n]))
 #elif __BYTE_ORDER == __BIG_ENDIAN
 #define syscall_arg(_n) (offsetof(struct seccomp_data, args[_n]) + sizeof(__u32))
+#define match_arg(_n) \
+	(offsetof(struct seccomp_data, arg_matches[_n]) + sizeof(__u32))
 #else
 #error "wut? Unknown __BYTE_ORDER?!"
 #endif
@@ -502,7 +510,11 @@ TEST_SIGNAL(KILL_one_arg_six, SIGSYS)
 TEST(arg_out_of_range)
 {
 	struct sock_filter filter[] = {
+#ifdef SECCOMP_DATA_ARGEVAL_PRESENT
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS, match_arg(6)),
+#else
 		BPF_STMT(BPF_LD|BPF_W|BPF_ABS, syscall_arg(6)),
+#endif
 		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
 	};
 	struct sock_fprog prog = {
-- 
2.8.0.rc3
