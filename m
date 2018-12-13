Subject: Patch "x86: Introduce __uaccess_begin_nospec() and uaccess_try_nospec" has been added to the 4.4-stable tree
From: <gregkh@linuxfoundation.org>
Date: Thu, 13 Dec 2018 20:13:15 +0100
Message-ID: <154472839510087@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
To: 151727415922.33451.5796614273104346583.stgit@dwillia2-desk3.amr.corp.intel.com, ak@linux.intel.com, alan@linux.intel.com, ben.hutchings@codethink.co.uk, dan.j.williams@intel.com, gregkh@linuxfoundation.org, keescook@chromium.org, kernel-hardening@lists.openwall.com, mingo@redhat.com, tglx@linutronix.de, thomas.lendacky@amd.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Cc: stable-commits@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


This is a note to let you know that I've just added the patch titled

    x86: Introduce __uaccess_begin_nospec() and uaccess_try_nospec

to the 4.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     x86-introduce-__uaccess_begin_nospec-and-uaccess_try_nospec.patch
and it can be found in the queue-4.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From foo@baz Thu Dec 13 20:11:30 CET 2018
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Jan 2018 17:02:39 -0800
Subject: x86: Introduce __uaccess_begin_nospec() and uaccess_try_nospec

From: Dan Williams <dan.j.williams@intel.com>

commit b3bbfb3fb5d25776b8e3f361d2eedaabb0b496cd upstream.

For __get_user() paths, do not allow the kernel to speculate on the value
of a user controlled pointer. In addition to the 'stac' instruction for
Supervisor Mode Access Protection (SMAP), a barrier_nospec() causes the
access_ok() result to resolve in the pipeline before the CPU might take any
speculative action on the pointer value. Given the cost of 'stac' the
speculation barrier is placed after 'stac' to hopefully overlap the cost of
disabling SMAP with the cost of flushing the instruction pipeline.

Since __get_user is a major kernel interface that deals with user
controlled pointers, the __uaccess_begin_nospec() mechanism will prevent
speculative execution past an access_ok() permission check. While
speculative execution past access_ok() is not enough to lead to a kernel
memory leak, it is a necessary precondition.

To be clear, __uaccess_begin_nospec() is addressing a class of potential
problems near __get_user() usages.

Note, that while the barrier_nospec() in __uaccess_begin_nospec() is used
to protect __get_user(), pointer masking similar to array_index_nospec()
will be used for get_user() since it incorporates a bounds check near the
usage.

uaccess_try_nospec provides the same mechanism for get_user_try.

No functional changes.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Andi Kleen <ak@linux.intel.com>
Suggested-by: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arch@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com
Cc: gregkh@linuxfoundation.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: alan@linux.intel.com
Link: https://lkml.kernel.org/r/151727415922.33451.5796614273104346583.stgit@dwillia2-desk3.amr.corp.intel.com
[bwh: Backported to 4.4: use current_thread_info()]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/uaccess.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -146,6 +146,11 @@ extern int __get_user_bad(void);
 
 #define __uaccess_begin() stac()
 #define __uaccess_end()   clac()
+#define __uaccess_begin_nospec()	\
+({					\
+	stac();				\
+	barrier_nospec();		\
+})
 
 /*
  * This is a type: either unsigned long, if the argument fits into
@@ -473,6 +478,10 @@ struct __large_struct { unsigned long bu
 	__uaccess_begin();						\
 	barrier();
 
+#define uaccess_try_nospec do {						\
+	current_thread_info()->uaccess_err = 0;				\
+	__uaccess_begin_nospec();					\
+
 #define uaccess_catch(err)						\
 	__uaccess_end();						\
 	(err) |= (current_thread_info()->uaccess_err ? -EFAULT : 0);	\


Patches currently in stable-queue which might be from dan.j.williams@intel.com are

queue-4.4/x86-introduce-__uaccess_begin_nospec-and-uaccess_try_nospec.patch
queue-4.4/kvm-vmx-emulate-msr_ia32_arch_capabilities.patch
queue-4.4/x86-usercopy-replace-open-coded-stac-clac-with-__uaccess_-begin-end.patch
queue-4.4/x86-uaccess-use-__uaccess_begin_nospec-and-uaccess_try_nospec.patch
queue-4.4/kvm-vmx-allow-direct-access-to-msr_ia32_spec_ctrl.patch
queue-4.4/kvm-x86-add-ibpb-support.patch
queue-4.4/kvm-svm-allow-direct-access-to-msr_ia32_spec_ctrl.patch
