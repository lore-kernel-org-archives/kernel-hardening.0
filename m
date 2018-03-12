Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 12 Mar 2018 03:03:34 +0000
Message-ID: <lsq.1520823814.163616880@decadent.org.uk>
Subject: [PATCH 3.2 086/104] x86/get_user: Use pointer masking to limit
 speculation
In-Reply-To: <lsq.1520823814.606620518@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-arch@vger.kernel.org, alan@linux.intel.com, Kees Cook <keescook@chromium.org>, Dan Williams <dan.j.williams@intel.com>, kernel-hardening@lists.openwall.com, torvalds@linux-foundation.org
List-ID: <kernel-hardening.lists.openwall.com>

3.2.101-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit c7f631cb07e7da06ac1d231ca178452339e32a94 upstream.

Quoting Linus:

    I do think that it would be a good idea to very expressly document
    the fact that it's not that the user access itself is unsafe. I do
    agree that things like "get_user()" want to be protected, but not
    because of any direct bugs or problems with get_user() and friends,
    but simply because get_user() is an excellent source of a pointer
    that is obviously controlled from a potentially attacking user
    space. So it's a prime candidate for then finding _subsequent_
    accesses that can then be used to perturb the cache.

Unlike the __get_user() case get_user() includes the address limit check
near the pointer de-reference. With that locality the speculation can be
mitigated with pointer narrowing rather than a barrier, i.e.
array_index_nospec(). Where the narrowing is performed by:

	cmp %limit, %ptr
	sbb %mask, %mask
	and %mask, %ptr

With respect to speculation the value of %ptr is either less than %limit
or NULL.

Co-developed-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arch@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com
Cc: gregkh@linuxfoundation.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: torvalds@linux-foundation.org
Cc: alan@linux.intel.com
Link: https://lkml.kernel.org/r/151727417469.33451.11804043010080838495.stgit@dwillia2-desk3.amr.corp.intel.com
[bwh: Backported to 3.2:
 - Drop changes to 32-bit implementation of __get_user_8
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/lib/getuser.S | 10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/x86/lib/getuser.S
+++ b/arch/x86/lib/getuser.S
@@ -40,6 +40,8 @@ ENTRY(__get_user_1)
 	GET_THREAD_INFO(%_ASM_DX)
 	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
+	sbb %_ASM_DX, %_ASM_DX		/* array_index_mask_nospec() */
+	and %_ASM_DX, %_ASM_AX
 1:	movzb (%_ASM_AX),%edx
 	xor %eax,%eax
 	ret
@@ -53,6 +55,8 @@ ENTRY(__get_user_2)
 	GET_THREAD_INFO(%_ASM_DX)
 	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
+	sbb %_ASM_DX, %_ASM_DX		/* array_index_mask_nospec() */
+	and %_ASM_DX, %_ASM_AX
 2:	movzwl -1(%_ASM_AX),%edx
 	xor %eax,%eax
 	ret
@@ -66,6 +70,8 @@ ENTRY(__get_user_4)
 	GET_THREAD_INFO(%_ASM_DX)
 	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
+	sbb %_ASM_DX, %_ASM_DX		/* array_index_mask_nospec() */
+	and %_ASM_DX, %_ASM_AX
 3:	mov -3(%_ASM_AX),%edx
 	xor %eax,%eax
 	ret
@@ -80,6 +86,8 @@ ENTRY(__get_user_8)
 	GET_THREAD_INFO(%_ASM_DX)
 	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
 	jae	bad_get_user
+	sbb %_ASM_DX, %_ASM_DX		/* array_index_mask_nospec() */
+	and %_ASM_DX, %_ASM_AX
 4:	movq -7(%_ASM_AX),%_ASM_DX
 	xor %eax,%eax
 	ret
