Message-ID: <58DCC280.5030608@arm.com>
Date: Thu, 30 Mar 2017 09:32:00 +0100
From: James Morse <james.morse@arm.com>
MIME-Version: 1.0
References: <20170216182917.19637-1-james.morse@arm.com> <20170216182917.19637-4-james.morse@arm.com> <CA+KhAHavP2eg4Ci-ZMWo_6-0X9UFoyz2j+tmvxMqyyBwUu9=yQ@mail.gmail.com>
In-Reply-To: <CA+KhAHavP2eg4Ci-ZMWo_6-0X9UFoyz2j+tmvxMqyyBwUu9=yQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH v4 3/3] arm64/uaccess: Add hardened
 usercopy check for bad stack accesses
To: Keun-O Park <kpark3469@gmail.com>
Cc: kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Pratyush Anand <panand@redhat.com>, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On 17/02/17 18:09, Keun-O Park wrote:
>> diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
>> index 46da3ea638bb..d3494840a61c 100644
>> --- a/arch/arm64/include/asm/uaccess.h
>> +++ b/arch/arm64/include/asm/uaccess.h
>> @@ -356,6 +356,22 @@ do {                                                                       \

>> +static inline void check_obj_in_unused_stack(const void *obj, unsigned long len)
>> +{
>> +       unsigned long stack = (unsigned long)task_stack_page(current);
>> +
>> +       if (__builtin_constant_p(len) || !IS_ENABLED(CONFIG_HARDENED_USERCOPY) || !len)
>> +               return;
>> +
>> +       /*
>> +        * If current_stack_pointer is on the task stack, obj must not lie
>> +        * between current_stack_pointer and the last stack address.
>> +        */
>> +       if ((current_stack_pointer & ~(THREAD_SIZE-1)) == stack)
>> +               BUG_ON(stack <= (unsigned long)obj &&
>> +                      (unsigned long)obj < current_stack_pointer);
>> +}
>> +
> 
> It looks to me that this function is just doing the similar check that
> check_stack_object() may do.
> Probably I guess you had a problem in checking the correct fp of
> caller's function while you tried to use walk_stackframe().

The value needs to be taken in a hopefully-inlined function if you want to catch
LKDTMs 'just off the stack' writes. Doing it like this saved meddling with the
generic code.


> Instead of creating check_obj_in_unused_stack(), how about handing
> over current_stack_pointer to check_stack_object();

Sure, do you want to give this a go? (I have my hands full at the moment)

It might not be the right check on all architectures, x86 redzone comes to mind,
but it doesn't look like they use this in the kernel.


There is also Al Viro's uaccess unification work that may affect whether this is
worth doing now:
https://lkml.org/lkml/2015/12/3/494



Thanks,

James
