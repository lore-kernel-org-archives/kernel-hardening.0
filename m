Message-ID: <589AFE24.8030706@arm.com>
Date: Wed, 08 Feb 2017 11:16:52 +0000
From: James Morse <james.morse@arm.com>
MIME-Version: 1.0
References: <1486296850-16045-1-git-send-email-kpark3469@gmail.com> <1486296850-16045-2-git-send-email-kpark3469@gmail.com> <58999F15.3090807@arm.com> <5899FDDD.3080605@arm.com> <CAGXu5jKghXnA8mNQY6wxr-CGLD-fVVmci6Txqzev8akzNGad6A@mail.gmail.com>
In-Reply-To: <CAGXu5jKghXnA8mNQY6wxr-CGLD-fVVmci6Txqzev8akzNGad6A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3 2/3] arm64: usercopy: Implement stack frame object
 validation
To: Kees Cook <keescook@chromium.org>
Cc: Keun-O Park <kpark3469@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Pratyush Anand <panand@redhat.com>, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,

On 07/02/17 18:13, Kees Cook wrote:
> On Tue, Feb 7, 2017 at 9:03 AM, James Morse <james.morse@arm.com> wrote:
>> On 07/02/17 10:19, James Morse wrote:
>> The reason turns out to be because LKDTM isn't testing whether we are
>> overlapping stack frames.
>> Instead it wants us to tell it whether the original caller somewhere down the
>> stack pointed into a stack frame that hadn't yet been written. This requires
>> this function to know how it will be called and unwind some number of frames.
>> Annoyingly we have to maintain start/end boundaries for each frame in case the
>> object was neatly contained in a frame that wasn't written at the time.
> 
> "hadn't yet been written"? This doesn't make sense.

Sorry, "wasn't contained by a frame at the time copy_to_user() was called, even
if it is now...".


> The hardened
> usercopy stack frame check (which is what LKDTM is exercising) wants
> to simply walk from the current frame up, making sure that the object
> in question is entirely contained by any single stack frame. Any
> dynamic stack allocations should already be covered since it would be
> within the caller's frame.

Sure, maybe I'm looking at the wrong lkdtm test then. I see this happening:

do_usercopy_stack_callee() returns its own stack value (while trying to confuse
the compiler). We know this value must be after do_usercopy_stack()s frame.
do_usercopy_stack() then passes this value to copy_{to,from}_user(), the test
expects this to to be rejected.

copy_{to,from}_user() then inline a call to __check_object_size(), which in turn
calls check_stack_object() (which is marked noinline). These calls will generate
stack frames, which will overlap the value do_usercopy_stack_callee() returned.

By the time arch_within_stack_frames() is called, the value returned by
do_usercopy_stack_callee() is within a stack frame. It just wasn't within a
stack frame at the time copy_to_user() was called.

Does this make sense, or have I gone off the rails?


One way to fix this is to make the size given to copy_to_user() so large that it
must overlap multiple stack frames. 32 bytes is too small given arm64 kernel
stacks have to be 16 byte aligned.

A better trick would be to inline the 'not after our stack frame' check into
do_usercopy_stack(), but that means exposing the report_usercopy() and maybe
some more. (I will give it a go).


> This doesn't seem to sanity-check that the frame is still within the
> process stack. We'd want to make sure it can't walk off into la-la
> land. :) (We could just add "stack" and "stack_end" to the
> check_frame_arg struct along with checks?)

The arch unwind_frame() machinery does this for us, in particular the cryptic:
>	if (fp < low || fp > high || fp & 0xf)
>		return -EINVAL;

Is testing that the freshly read 'fp' is between the 'top' of this frame and the
'bottom' of the stack.

The only corner case would be if you called this and object wasn't on the stack
at all to begin with, but core code already checks this. Before calling
arch_within_stack_frames(),
mm/usercopy.c:check_stack_object():
>	/* Object is not on the stack at all. */
>	if (obj + len <= stack || stackend <= obj)
>		return NOT_STACK;



Thanks,

James
