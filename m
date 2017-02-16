Message-ID: <58A5E37A.4020603@arm.com>
Date: Thu, 16 Feb 2017 17:38:02 +0000
From: James Morse <james.morse@arm.com>
MIME-Version: 1.0
References: <1486296850-16045-1-git-send-email-kpark3469@gmail.com> <1486296850-16045-2-git-send-email-kpark3469@gmail.com> <58999F15.3090807@arm.com> <5899FDDD.3080605@arm.com> <CAGXu5jKghXnA8mNQY6wxr-CGLD-fVVmci6Txqzev8akzNGad6A@mail.gmail.com> <589AFE24.8030706@arm.com> <CAGXu5jL3fxTXYxMbAhWLvf_-xGR4c17+vhsFJmupCS0tVUcnpw@mail.gmail.com>
In-Reply-To: <CAGXu5jL3fxTXYxMbAhWLvf_-xGR4c17+vhsFJmupCS0tVUcnpw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3 2/3] arm64: usercopy: Implement stack frame object
 validation
To: Kees Cook <keescook@chromium.org>
Cc: Keun-O Park <kpark3469@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Pratyush Anand <panand@redhat.com>, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,

On 08/02/17 21:38, Kees Cook wrote:
> On Wed, Feb 8, 2017 at 3:16 AM, James Morse <james.morse@arm.com> wrote:
>> do_usercopy_stack_callee() returns its own stack value (while trying to confuse
>> the compiler). We know this value must be after do_usercopy_stack()s frame.
>> do_usercopy_stack() then passes this value to copy_{to,from}_user(), the test
>> expects this to to be rejected.
>>
>> copy_{to,from}_user() then inline a call to __check_object_size(), which in turn
>> calls check_stack_object() (which is marked noinline). These calls will generate
>> stack frames, which will overlap the value do_usercopy_stack_callee() returned.
>>
>> By the time arch_within_stack_frames() is called, the value returned by
>> do_usercopy_stack_callee() is within a stack frame. It just wasn't within a
>> stack frame at the time copy_to_user() was called.
>>
>> Does this make sense, or have I gone off the rails?
> 
> That's true, but those frames should be ignored by the walker, and as
> such, should be rejected. (See below.)

I think that's an odd thing for arch_within_stack_frames() to be doing.


>> One way to fix this is to make the size given to copy_to_user() so large that it
>> must overlap multiple stack frames. 32 bytes is too small given arm64 kernel
>> stacks have to be 16 byte aligned.
>>
>> A better trick would be to inline the 'not after our stack frame' check into
>> do_usercopy_stack(), but that means exposing the report_usercopy() and maybe
>> some more. (I will give it a go).
> 
> Just to make sure I'm on the same page, the call stack is:
> 
> do_usercopy_stack() (or anything calling the uaccess functions)
>   copy_{to,from}_user() <- inlined into do_usercopy_stack()
> __check_object_size()
> check_stack_object()
>   arch_within_stack_frames() <- inlined into check_stack_object()

I think this is where our world-view is different, I don't trust the compiler
not to pull some surprising optimisation that inlines calls differently at
different call-sites.

The compiler won't always inline functions marked inline, [0] has some examples,
(I'm not sure what it means by 'use of nested functions'!).

Expecting a particular layout is fragile, Akashi's example shows gcc doesn't
always place objects and the frame record where we expected. Requiring a
particular layout for copy_to_user() to work is bordering on the 'sleepless
nights' territory.


> Is there any reason the arm64 walker couldn't be identical to the x86 walker?

We would then have two stack walkers.

In the light of Akashi's example, walking the stack and saying 'this object was
allocated by this call' isn't something we can do, arch_within_stack_frames()
shouldn't try.

I have an alternate version of this patch that uses arm64s existing stack walker
to look for fp appearing within an object, and another that tries to inline the
bounds check into the caller. I will post these shortly for comparison...


Thanks,

James


[0] https://gcc.gnu.org/onlinedocs/gcc/Inline.html
