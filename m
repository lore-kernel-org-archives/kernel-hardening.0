Message-ID: <5899FDDD.3080605@arm.com>
Date: Tue, 07 Feb 2017 17:03:25 +0000
From: James Morse <james.morse@arm.com>
MIME-Version: 1.0
References: <1486296850-16045-1-git-send-email-kpark3469@gmail.com> <1486296850-16045-2-git-send-email-kpark3469@gmail.com> <58999F15.3090807@arm.com>
In-Reply-To: <58999F15.3090807@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3 2/3] arm64: usercopy: Implement stack frame object
 validation
To: kpark3469@gmail.com
Cc: kernel-hardening@lists.openwall.com, catalin.marinas@arm.com, keescook@chromium.org, will.deacon@arm.com, mark.rutland@arm.com, panand@redhat.com, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

Hi Sahara,

On 07/02/17 10:19, James Morse wrote:
> On 05/02/17 12:14, kpark3469@gmail.com wrote:
>> From: Sahara <keun-o.park@darkmatter.ae>
>>
>> This implements arch_within_stack_frames() for arm64 that should
>> validate if a given object is contained by a kernel stack frame.
>>
>> Signed-off-by: Sahara <keun-o.park@darkmatter.ae>

> I'd like to avoid having two sets of code that walk the stack.
> I will have a go at a version of this patch that uses arm64s existing
> walk_stackframe() machinery - lets find out if there is a good reason not to do
> it that way!

The reason turns out to be because LKDTM isn't testing whether we are
overlapping stack frames.
Instead it wants us to tell it whether the original caller somewhere down the
stack pointed into a stack frame that hadn't yet been written. This requires
this function to know how it will be called and unwind some number of frames.
Annoyingly we have to maintain start/end boundaries for each frame in case the
object was neatly contained in a frame that wasn't written at the time.

Ideally we would inline this stack check into the caller, testing object_end
doesn't lie in the range current_stack_pointer : end_of_stack. This would work
even when built without CONFIG_FRAME_POINTER but is probably too-invasive a change.

As is, the walk_stackframe() machinery version looks like this:
---------------------------------------%<---------------------------------------
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 8a552a33c6ef..620fa74201b5 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -25,6 +25,12 @@
 #include <asm/stack_pointer.h>
 #include <asm/stacktrace.h>

+#define FAKE_FRAME(frame, my_func) do {                        \
+       frame.fp = (unsigned long)__builtin_frame_address(0);   \
+       frame.sp = current_stack_pointer;               \
+       frame.pc = (unsigned long)my_func;              \
+} while (0)
+
 /*
  * AArch64 PCS assigns the frame pointer to x29.
  *
@@ -194,9 +200,7 @@ void save_stack_trace_tsk(struct task_struct *tsk, struct
stack_trace *trace)
                frame.pc = thread_saved_pc(tsk);
        } else {
                data.no_sched_functions = 0;
-               frame.fp = (unsigned long)__builtin_frame_address(0);
-               frame.sp = current_stack_pointer;
-               frame.pc = (unsigned long)save_stack_trace_tsk;
+               FAKE_FRAME(frame, save_stack_trace_tsk);
        }
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
        frame.graph = tsk->curr_ret_stack;
@@ -215,3 +219,73 @@ void save_stack_trace(struct stack_trace *trace)
 }
 EXPORT_SYMBOL_GPL(save_stack_trace);
 #endif
+
+struct check_frame_arg {
+       unsigned long obj_start;
+       unsigned long obj_end;
+       unsigned long frame_start;
+       int discard_frames;
+       int err;
+};
+
+static int check_frame(struct stackframe *frame, void *d)
+{
+       struct check_frame_arg *arg = d;
+       unsigned long frame_end = frame->fp;
+
+       /* object overlaps multiple frames */
+       if (arg->obj_start < frame->fp && frame->fp < arg->obj_end) {
+               arg->err = BAD_STACK;
+               return 1;
+       }
+
+       /*
+        * Discard frames and check object is in a frame written early
+        * enough.
+        */
+       if (arg->discard_frames)
+               arg->discard_frames--;
+       else if ((arg->frame_start <= arg->obj_start && arg->obj_start <
frame_end) &&
+                (arg->frame_start < arg->obj_end && arg->obj_end <= frame_end))
+               return 1;
+
+       /* object exists in a previous frame */
+       if (arg->obj_end < arg->frame_start) {
+               arg->err = BAD_STACK;
+               return 1;
+       }
+
+       arg->frame_start = frame_end + 0x10;
+
+       return 0;
+}
+
+/* Check obj doesn't overlap a stack frame record */
+enum stack_type arch_within_stack_frames(const void *stack,
+                                        const void *stack_end,
+                                        const void *obj, unsigned long obj_len)
+{
+       struct stackframe frame;
+       struct check_frame_arg arg;
+
+       if (!IS_ENABLED(CONFIG_FRAME_POINTER))
+               return NOT_STACK;
+
+       arg.err = GOOD_FRAME;
+       arg.obj_start = (unsigned long)obj;
+       arg.obj_end = arg.obj_start + obj_len;
+
+       FAKE_FRAME(frame, arch_within_stack_frames);
+       arg.frame_start = frame.fp;
+
+       /*
+        * Skip 4 non-inlined frames: <fake frame>,
+        * arch_within_stack_frames(), check_stack_object() and
+        * __check_object_size().
+        */
+       arg.discard_frames = 4;
+
+       walk_stackframe(current, &frame, check_frame, &arg);
+
+       return arg.err;
+}
---------------------------------------%<---------------------------------------

This avoids the __builtin_frame_address(!0) problem and doesn't duplicate the
actual stack walking. This can be simplified further if we can get rid of the
time-travel requirements.

It is unfortunately more code, but it is hopefully clearer!


Thanks,

James
