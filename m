From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH] staging: vchiq_arm: Clear VLA warning
Date: Fri,  9 Mar 2018 17:21:10 +1100
Message-Id: <1520576470-20628-1-git-send-email-me@tobin.cc>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Anholt <eric@anholt.net>, Stefan Wahren <stefan.wahren@i2se.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

The kernel would like to have all stack VLA usage removed[1].  The
array here is fixed (declared with a const variable) but it appears
like VLA to the compiler.  We can use a pre-processor define to quiet
the compiler.

[1]: https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---

The name of this constant may need changing, there is already a
pre-processor constant VCHIQ_MAX_SERVICES

 .../staging/vc04_services/interface/vchiq_arm/vchiq_arm.c  | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index f5cefda49b22..c972869a0333 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -3434,13 +3434,15 @@ vchiq_release_service(VCHIQ_SERVICE_HANDLE_T handle)
 	return ret;
 }
 
+/* Only dump 64 services */
+#define VCHIQ_LOCAL_MAX_SERVICES 64
+
 void
 vchiq_dump_service_use_state(VCHIQ_STATE_T *state)
 {
 	VCHIQ_ARM_STATE_T *arm_state = vchiq_platform_get_arm_state(state);
 	int i, j = 0;
-	/* Only dump 64 services */
-	static const int local_max_services = 64;
+
 	/* If there's more than 64 services, only dump ones with
 	 * non-zero counts */
 	int only_nonzero = 0;
@@ -3455,7 +3457,7 @@ vchiq_dump_service_use_state(VCHIQ_STATE_T *state)
 		int fourcc;
 		int clientid;
 		int use_count;
-	} service_data[local_max_services];
+	} service_data[VCHIQ_LOCAL_MAX_SERVICES];
 
 	if (!arm_state)
 		return;
@@ -3466,10 +3468,10 @@ vchiq_dump_service_use_state(VCHIQ_STATE_T *state)
 	peer_count = arm_state->peer_use_count;
 	vc_use_count = arm_state->videocore_use_count;
 	active_services = state->unused_service;
-	if (active_services > local_max_services)
+	if (active_services > VCHIQ_LOCAL_MAX_SERVICES)
 		only_nonzero = 1;
 
-	for (i = 0; (i < active_services) && (j < local_max_services); i++) {
+	for (i = 0; (i < active_services) && (j < VCHIQ_LOCAL_MAX_SERVICES); i++) {
 		VCHIQ_SERVICE_T *service_ptr = state->services[i];
 
 		if (!service_ptr)
@@ -3499,7 +3501,7 @@ vchiq_dump_service_use_state(VCHIQ_STATE_T *state)
 		vchiq_log_warning(vchiq_susp_log_level, "Too many active "
 			"services (%d).  Only dumping up to first %d services "
 			"with non-zero use-count", active_services,
-			local_max_services);
+			VCHIQ_LOCAL_MAX_SERVICES);
 
 	for (i = 0; i < j; i++) {
 		vchiq_log_warning(vchiq_susp_log_level,
-- 
2.7.4
