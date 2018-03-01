From: kpark3469@gmail.com
Subject: [PATCH 3/4] arm64: usercopy: consider dynamic array stack variable
Date: Thu,  1 Mar 2018 14:19:50 +0400
Message-Id: <1519899591-29761-4-git-send-email-kpark3469@gmail.com>
In-Reply-To: <1519899591-29761-3-git-send-email-kpark3469@gmail.com>
References: <1519899591-29761-1-git-send-email-kpark3469@gmail.com>
 <1519899591-29761-2-git-send-email-kpark3469@gmail.com>
 <1519899591-29761-3-git-send-email-kpark3469@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, james.morse@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

From: Sahara <keun-o.park@darkmatter.ae>

When an array is dynamically declared, the array may be placed
at next frame. If this variable is used for usercopy, then it
will cause an Oops because the current check code does not allow
this exceptional case.

 low -----------------------------------------------------> high
 [__check_object_size fp][lr][args][local vars][caller_fp][lr]
                             ^----------------^
                     dynamically allocated stack variable of
                     caller frame copies are allowed within here

 < example code snippet >
 array_size = get_random_int() & 0x0f;
 if (to_user) {
         unsigned char array[array_size];
         if (copy_to_user((void __user *)user_addr, array,
                          unconst + sizeof(array))) {

Signed-off-by: Sahara <keun-o.park@darkmatter.ae>
---
 arch/arm64/kernel/stacktrace.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 6d37fad..75a8f20 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -162,8 +162,13 @@ int arch_within_stack_frames(const void *stack,
 	 * Skip 4 non-inlined frames: <fake frame>,
 	 * arch_within_stack_frames(), check_stack_object() and
 	 * __check_object_size().
+	 *
+	 * From Akashi's report, an object may be placed between next caller's
+	 * frame, when the object is created as dynamic array.
+	 * Setting the discard_frames to 3 is proper to catch this exceptional
+	 * case.
 	 */
-	arg.discard_frames = 4;
+	arg.discard_frames = 3;
 
 	walk_stackframe(current, &frame, check_frame, &arg);
 
-- 
2.7.4
