From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 26 Jan 2018 23:55:45 -0800
Message-ID: <151703974570.26578.3809646715924406820.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v5 06/12] x86,
 get_user: use pointer masking to limit speculation
To: tglx@linutronix.de
Cc: linux-arch@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

Quoting Linus:

    I do think that it would be a good idea to very expressly document
    the fact that it's not that the user access itself is unsafe. I do
    agree that things like "get_user()" want to be protected, but not
    because of any direct bugs or problems with get_user() and friends,
    but simply because get_user() is an excellent source of a pointer
    that is obviously controlled from a potentially attacking user
    space. So it's a prime candidate for then finding _subsequent_
    accesses that can then be used to perturb the cache.

Unlike the '__get_user' case 'get_user' includes the address limit check
near the pointer de-reference. With that locality the speculation can be
mitigated with pointer narrowing rather than a barrier. Where the
narrowing is performed by:

	cmp %limit, %ptr
	sbb %mask, %mask
	and %mask, %ptr

With respect to speculation the value of %ptr is either less than %limit
or NULL.

Co-developed-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/lib/getuser.S |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/lib/getuser.S b/arch/x86/lib/getuser.S
index c97d935a29e8..e7a1a9421998 100644
--- a/arch/x86/lib/getuser.S
+++ b/arch/x86/lib/getuser.S
@@ -40,6 +40,8 @@ ENTRY(__get_user_1)
 	mov PER_CPU_VAR(current_task), %_ASM_DX
 	cmp TASK_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
+	sbb %_ASM_DX, %_ASM_DX		/* 0 - (uptr < addr_limit) */
+	and %_ASM_DX, %_ASM_AX
 	ASM_STAC
 1:	movzbl (%_ASM_AX),%edx
 	xor %eax,%eax
@@ -54,6 +56,8 @@ ENTRY(__get_user_2)
 	mov PER_CPU_VAR(current_task), %_ASM_DX
 	cmp TASK_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
+	sbb %_ASM_DX, %_ASM_DX		/* 0 - (uptr < addr_limit) */
+	and %_ASM_DX, %_ASM_AX
 	ASM_STAC
 2:	movzwl -1(%_ASM_AX),%edx
 	xor %eax,%eax
@@ -68,6 +72,8 @@ ENTRY(__get_user_4)
 	mov PER_CPU_VAR(current_task), %_ASM_DX
 	cmp TASK_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
+	sbb %_ASM_DX, %_ASM_DX		/* 0 - (uptr < addr_limit) */
+	and %_ASM_DX, %_ASM_AX
 	ASM_STAC
 3:	movl -3(%_ASM_AX),%edx
 	xor %eax,%eax
@@ -83,6 +89,8 @@ ENTRY(__get_user_8)
 	mov PER_CPU_VAR(current_task), %_ASM_DX
 	cmp TASK_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
+	sbb %_ASM_DX, %_ASM_DX		/* 0 - (uptr < addr_limit) */
+	and %_ASM_DX, %_ASM_AX
 	ASM_STAC
 4:	movq -7(%_ASM_AX),%rdx
 	xor %eax,%eax
@@ -94,6 +102,8 @@ ENTRY(__get_user_8)
 	mov PER_CPU_VAR(current_task), %_ASM_DX
 	cmp TASK_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user_8
+	sbb %_ASM_DX, %_ASM_DX		/* 0 - (uptr < addr_limit) */
+	and %_ASM_DX, %_ASM_AX
 	ASM_STAC
 4:	movl -7(%_ASM_AX),%edx
 5:	movl -3(%_ASM_AX),%ecx
