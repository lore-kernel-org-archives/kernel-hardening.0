References: <1499883471-23822-1-git-send-email-alex.popov@linux.com>
 <e604f541-084d-53e0-7f5c-d87e3729068b@redhat.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <796148b8-471f-1a55-b5eb-b870cb5ca33d@linux.com>
Date: Mon, 24 Jul 2017 15:15:32 +0300
MIME-Version: 1.0
In-Reply-To: <e604f541-084d-53e0-7f5c-d87e3729068b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH RFC v3 1/1] gcc-plugins: Add stackleak feature erasing the
 kernel stack at the end of syscalls
To: Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com, keescook@chromium.org, pageexec@freemail.hu, spender@grsecurity.net, tycho@docker.com, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, x86@kernel.org, Andy Lutomirski <luto@amacapital.net>
List-ID: <kernel-hardening.lists.openwall.com>

Hello Laura,

On 15.07.2017 00:44, Laura Abbott wrote:
> On 07/12/2017 11:17 AM, Alexander Popov wrote:
>> This is the third version of the patch introducing STACKLEAK to the
>> mainline kernel. STACKLEAK is a security feature developed by Grsecurity/PaX
>> (kudos to them again), which:
>>  - reduces the information that can be revealed by some kernel stack leak bugs
>>     (e.g. CVE-2016-4569 and CVE-2016-4578);
>>  - blocks some uninitialized stack variable attacks (e.g. CVE-2010-2963);
>>  - introduces some runtime checks for kernel stack overflow detection.
>>
>> Changes in v3 (rebased on the recent rc)
>>
>> 1. Added the detailed comments describing the STACKLEAK gcc plugin.
>>    Read the plugin from bottom up, like you do for Linux kernel drivers.
>>    Additional information:
>>     - gcc internals documentation, which is available from gcc sources;
>>     - wonderful slides by Diego Novillo
>>        https://www.airs.com/dnovillo/200711-GCC-Internals/
>>     - nice introduction to gcc plugins at LWN
>>        https://lwn.net/Articles/457543/
>>
>> 2. Improved the commit message and Kconfig description according the
>>    feedback from Kees Cook. Also added the original notice describing
>>    the performance impact of the STACKLEAK feature.
>>
>> 3. Removed arch-specific ix86_cmodel check from stackleak_track_stack_gate().
>>    It caused skipping the kernel code instrumentation for i386.
>>
>> 4. Fixed a minor mistake in stackleak_tree_instrument_execute().
>>    First versions of the plugin used ENTRY_BLOCK_PTR_FOR_FN(cfun)->next_bb
>>    to get the basic block with the function prologue. That was not correct
>>    since the control flow graph edge from the ENTRY_BLOCK_PTR doesn't always
>>    go to that basic block.
>>
>>    So later it was changed it to single_succ(ENTRY_BLOCK_PTR_FOR_FN(cfun)),
>>    but not completely. next_bb was still used for entry_bb assignment,
>>    which could cause the wrong value of the prologue_instrumented variable.
>>
>>    I've reported this issue to Grsecurity and proposed the fix for it, but
>>    unfortunately didn't get any reply.
>>
>> 5. Introduced the STACKLEAK_POISON macro and renamed the config option
>>    according the feedback from Kees Cook.
>>
>> More things to be done:
>>  - carefully look into the assertions in track_stack() and check_alloca();
>>  - find answers to the questions marked with TODO in the comments;
>>  - think of erasing the kernel stack after invoking EFI runtime services;
>>  - update self-protection.rst.
>>
>> Parallel work (thanks for that!):
>>  - Tycho Andersen is developing tests for STACKLEAK;
>>  - Laura Abbott is working on porting STACKLEAK to arm64.
>>
>> -- >8 --

[...]

>> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>> +	p->thread.lowest_stack = (unsigned long)task_stack_page(p) +
>> +						2 * sizeof(unsigned long);
>> +#endif
>> +
> 
> Do you know why this initialization value was chosen? In clear_kstack,
> this gets reset to sp0. It seems like this forces a clear of the entire
> stack on the first call of clear_kstack?

Do you mean erase_kstack()?

The first erase_kstack() call will clear almost whole stack anyway. But
initializing lowest_stack with that value helps to skip first useless searching
for STACKLEAK_POISON.

>>  	savesegment(gs, p->thread.gsindex);
>>  	p->thread.gsbase = p->thread.gsindex ? 0 : me->thread.gsbase;
>>  	savesegment(fs, p->thread.fsindex);
>> diff --git a/fs/exec.c b/fs/exec.c
>> index 62175cb..22ba66d 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1949,3 +1949,20 @@ COMPAT_SYSCALL_DEFINE5(execveat, int, fd,
>>  				  argv, envp, flags);
>>  }
>>  #endif
>> +
>> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>> +void __used track_stack(void)
>> +{
>> +	unsigned long sp = (unsigned long)&sp;
>> +
> 
> Mark Rutland pointed out in the review of my arm64 draft that
> using current_stack_pointer() is cleaner.

Ok.

>> +	if (sp < current->thread.lowest_stack &&
>> +	    sp >= (unsigned long)task_stack_page(current) +
>> +					2 * sizeof(unsigned long)) {
>> +		current->thread.lowest_stack = sp;
>> +	}
>> +
>> +	if (unlikely((sp & ~(THREAD_SIZE - 1)) < (THREAD_SIZE / 16)))
>> +		BUG();
>> +}
> 
> All of the above checks have the x86-isms. Can this either be
> cleaned up or made architecture specific?

Excuse me, I didn't understand what you mean. I can describe these checks a bit.

The conditions on setting lowest_stack are caused by the fact that x86 has some
specialized stacks associated with each CPU in addition to the per thread stacks
(see Documentation/x86/kernel-stacks for more info).

As I understand, the following assertion detects stack exhaustion. It's
important, although I don't like how it looks: it is checked for different
kernel stacks (which have different size), but involves THREAD_SIZE macro.

>> +EXPORT_SYMBOL(track_stack);
>> +#endif
>> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
>> index 219f82f..a97d334 100644
>> --- a/include/linux/compiler.h
>> +++ b/include/linux/compiler.h
>> @@ -585,4 +585,8 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
>>  	(_________p1); \
>>  })
>>  
>> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>> +# define STACKLEAK_POISON -0xBEEF
>> +#endif
>> +
> 
> Pulling out the poison to be common is certainly good, compiler.h doesn't seem
> quite right though. I don't have a strong opinion if there are no other
> objections or better ideas.

Ok.

>>  #endif /* __LINUX_COMPILER_H */
>> diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
>> index 2e0e2ea..aab824d 100644
>> --- a/scripts/Makefile.gcc-plugins
>> +++ b/scripts/Makefile.gcc-plugins
>> @@ -33,6 +33,9 @@ ifdef CONFIG_GCC_PLUGINS
>>    gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_RANDSTRUCT)	+= -DRANDSTRUCT_PLUGIN
>>    gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_RANDSTRUCT_PERFORMANCE)	+= -fplugin-arg-randomize_layout_plugin-performance-mode
>>  
>> +  gcc-plugin-$(CONFIG_GCC_PLUGIN_STACKLEAK)	+= stackleak_plugin.so
>> +  gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STACKLEAK)	+= -DSTACKLEAK_PLUGIN -fplugin-arg-stackleak_plugin-track-lowest-sp=100
>> +
> 
> Might be useful to make the bytes limit a Kconfig
> for tuning.

Nice idea, thanks! Added to TODO for the next version.

Best regards,
Alexander
