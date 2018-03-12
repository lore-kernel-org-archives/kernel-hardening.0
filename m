From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH v2] staging: vchiq_arm: Clear VLA warning
Date: Mon, 12 Mar 2018 12:37:53 +1100
Message-Id: <1520818673-14084-1-git-send-email-me@tobin.cc>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Anholt <eric@anholt.net>, Stefan Wahren <stefan.wahren@i2se.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

The kernel would like to have all stack VLA usage removed[1].  The array
here is fixed (declared with a const variable) but it appears like a VLA
to the compiler.  Also, currently we are putting 768 bytes on the
stack.  This function is only called on the error path so performance is
not critical, let's just allocate the memory instead of using the
stack.  This saves stack space and removes the VLA build warning.

kmalloc a buffer for dumping state instead of using the stack.

[1]: https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---

v1 of this patch already merged into staging-testing branch of Greg's
staging tree.  This patch depends on v1 being removed, can re-do this
one on top of tip of staging-testing if required.

v2:
 - Use kmalloc() instead of the stack

Patch is untested.  

 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index f5cefda49b22..408ea73f8da7 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -3455,11 +3455,15 @@ vchiq_dump_service_use_state(VCHIQ_STATE_T *state)
 		int fourcc;
 		int clientid;
 		int use_count;
-	} service_data[local_max_services];
+	} *service_data;
 
 	if (!arm_state)
 		return;
 
+	service_data = kmalloc_array(local_max_services, sizeof(*service_data), GFP_KERNEL);
+	if (!service_data)
+		return;
+
 	read_lock_bh(&arm_state->susp_res_lock);
 	vc_suspend_state = arm_state->vc_suspend_state;
 	vc_resume_state  = arm_state->vc_resume_state;
-- 
2.7.4
