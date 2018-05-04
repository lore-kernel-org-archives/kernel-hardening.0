Subject: Re: [PATCH 2/2] arm64: Clear the stack
References: <20180502203326.9491-1-labbott@redhat.com>
 <20180502203326.9491-3-labbott@redhat.com>
 <20180503071917.xm2xvgagvzkworay@salmiak>
 <dd6ad26c-1d2c-88f3-8f01-e68d2b31d6ea@linux.com>
 <5b654bb4-64cc-dc64-afd7-135971b54c98@redhat.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <b2f4f5c4-ab19-b7c9-a564-02d54d17fd49@linux.com>
Date: Fri, 4 May 2018 11:30:31 +0300
MIME-Version: 1.0
In-Reply-To: <5b654bb4-64cc-dc64-afd7-135971b54c98@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 03.05.2018 22:09, Laura Abbott wrote:
> On 05/03/2018 10:33 AM, Alexander Popov wrote:
>> On 03.05.2018 10:19, Mark Rutland wrote:
>>> On Wed, May 02, 2018 at 01:33:26PM -0700, Laura Abbott wrote:
>>>> +	/* Reset the lowest_stack value for the next syscall */
>>>> +	current->thread.lowest_stack = current_stack_pointer;
>>
>> Laura, that might be wrong and introduce huge performance impact.
>>
>> I think, lowest_stack should be reset similarly to the original version.
>>
> 
> Sorry, I'm not understanding here. What's the performance impact and
> what do you mean by original version?

I meant the code for x86:
	/* Reset the lowest_stack value for the next syscall */
	current->thread.lowest_stack = current_top_of_stack() - 256;

...Now when I'm writing about the performance impact, I see that I was wrong
about "huge". Excuse me.

Let me describe the implications of this code change.

So we are at the end of a syscall. We've just erased the used part of the kernel
stack. The current stack pointer is near to the top of stack. On x86_64 I see
that the stack pointer is stack top minus 56 bytes (just before switching onto
the trampoline stack).

I took the idea of resetting lowest_stack to stack top minus 256 from the
original PaX Team's code. It should give the speedup when lowest_stack is not
updated during a syscall (a lot of functions are not instrumented) and we start
to search for the poison value from that reasonable point.

If we speak about the common erase_kstack() code, this code change can break
x86, because this function can be called from the trampoline stack (separate
from the thread stack).

>>>> +}
>>>
>>> Once this function returns, its data is left on the stack. Is that not a problem?
>>>
>>> No strong feelings either way, but it might be worth mentioning in the commit
>>> message.
>>
>> I managed to bypass that with "register" specifier. Although it doesn't give an
>> absolute guarantee.
>>
> 
> I guess I was assuming gcc would be smart enough not to spill stuff
> on the stack. I also intentionally removed the register keyword
> since it wasn't clear gcc does much with it on a modern system? I
> could be completely off base here though so please correct me if
> I'm wrong. It probably is worth documenting what we are assuming about
> the compiler here.

I think having register storage class specifier here is a bit better than
nothing. And yes, I'll add a comment. Right now don't see a better solution.

>>>> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
>>>> index a34e9290a699..25dd2a14560d 100644
>>>> --- a/drivers/firmware/efi/libstub/Makefile
>>>> +++ b/drivers/firmware/efi/libstub/Makefile
>>>> @@ -20,7 +20,8 @@ cflags-$(CONFIG_EFI_ARMSTUB)	+= -I$(srctree)/scripts/dtc/libfdt
>>>>   KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
>>>>   				   -D__NO_FORTIFY \
>>>>   				   $(call cc-option,-ffreestanding) \
>>>> -				   $(call cc-option,-fno-stack-protector)
>>>> +				   $(call cc-option,-fno-stack-protector) \
>>>> +				   $(DISABLE_STACKLEAK_PLUGIN)
>>>>   
>>>>   GCOV_PROFILE			:= n
>>>>   KASAN_SANITIZE			:= n
>>>
>>> I believe we'll also need to do this for the KVM hyp code in arch/arm64/kvm/hyp/.
>>
>> Could you please give more details on that? Why STACKLEAK breaks it?
>>
> 
> For reference, I originally added this for the efistub because
> it would not compile.

I guess it was a linkage error, right?

> I did compile this against my Fedora tree which has KVM enabled.

Looked through this big article about ARM, KVM and HYP mode:
https://lwn.net/Articles/557132/

So we have some limited amount of kernel code which runs in HYP mode. Is it only
in arch/arm64/kvm/hyp/ directory?

Mark, could you give a clue what trouble will we have if we call track_stack()
or check_alloca() from that code?

Thanks in advance!

--
Alexander
