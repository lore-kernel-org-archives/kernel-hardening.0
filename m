Subject: Re: [PATCH 1/2] stackleak: Update for arm64
References: <20180221011303.20392-1-labbott@redhat.com>
 <20180221011303.20392-2-labbott@redhat.com> <20180222165834.GC18421@arm.com>
 <97090ca6-efad-7c03-6084-a97674ae61c7@linux.com>
 <874lm2d96q.fsf@e105548-lin.cambridge.arm.com>
 <5d10c6ad-b4b6-eb27-79f0-ca235b73e7eb@linux.com>
 <87woywxezi.fsf@e105548-lin.cambridge.arm.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <b0575fc6-79f4-9aad-ee31-e761a9cac5d8@linux.com>
Date: Fri, 2 Mar 2018 14:14:36 +0300
MIME-Version: 1.0
In-Reply-To: <87woywxezi.fsf@e105548-lin.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Will Deacon <will.deacon@arm.com>, Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, richard.sandiford@arm.com
Cc: PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

Thanks for your reply, Richard!

On 01.03.2018 13:33, Richard Sandiford wrote:
> Alexander Popov <alex.popov@linux.com> writes:
>> On 27.02.2018 13:21, Richard Sandiford wrote:
>>> Alexander Popov <alex.popov@linux.com> writes:
>>>> Would you be so kind to take a look at the whole STACKLEAK plugin?
>>>> http://www.openwall.com/lists/kernel-hardening/2018/02/16/4
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=kspp/gcc-plugin/stackleak&id=57a0a6763b12e82dd462593d0f42be610e93cdc9
>>>>
>>>> It's not very big. I documented it in detail. I would be really
>>>> grateful for the
>>>> review!
>>>
>>> Looks good to me FWIW.  Just a couple of minor things:
>>>
>>>> +	/*
>>>> +	 * 1. Loop through the GIMPLE statements in each of cfun basic blocks.
>>>> +	 * cfun is a global variable which represents the function that is
>>>> +	 * currently processed.
>>>> +	 */
>>>> +	FOR_EACH_BB_FN(bb, cfun) {
>>>> +		for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
>>>> +			gimple stmt;
>>>> +
>>>> +			stmt = gsi_stmt(gsi);
>>>> +
>>>> +			/* Leaf function is a function which makes no calls */
>>>> +			if (is_gimple_call(stmt))
>>>> +				is_leaf = false;
>>>
>>> It's probably not going to matter in practice, but it might be worth
>>> emphasising in the comments that this leafness is only approximate.
>>
>> That's important, thank you! May I ask why you think it's not going to matter in
>> practice?
> 
> I just thought the kind of calls it misses are going to have very
> shallow frames, but from what you said later I guess that isn't the
> point.  It also might be a bit too hand-wavy for something like this :-)
> 
>>> It will sometimes be a false positive, because we could still
>>> end up creating calls to libgcc functions from non-call statements
>>> (or for target-specific reasons).  It can also be a false negative,
>>> since call statements can be to built-in or internal functions that
>>> end up being open-coded.
>>
>> Oh, that raises the question: how does this leafness inaccuracy affect in my
>> particular case?
>>
>> is_leaf is currently used for finding the special cases to skip the
>> track_stack() call insertion:
>>
>> /*
>>  * Special cases to skip the instrumentation.
>>  *
>>  * Taking the address of static inline functions materializes them,
>>  * but we mustn't instrument some of them as the resulting stack
>>  * alignment required by the function call ABI will break other
>>  * assumptions regarding the expected (but not otherwise enforced)
>>  * register clobbering ABI.
>>  *
>>  * Case in point: native_save_fl on amd64 when optimized for size
>>  * clobbers rdx if it were instrumented here.
>>  *
>>  * TODO: any more special cases?
>>  */
>> if (is_leaf &&
>>     !TREE_PUBLIC(current_function_decl) &&
>>     DECL_DECLARED_INLINE_P(current_function_decl)) {
>> 	return 0;
>> }
>>
>>
>> And now it seems to me that the stackleak plugin should not instrument all
>> static inline functions, regardless of is_leaf. Do you agree?
> 
> OK.  I'd missed that this was just a heuristic to detect certain kinds
> of linux function, so it's probably fine as it is.
> 
> Not sure whether it's safe to punt for general static inline functions.
> E.g. couldn't you have a static inline function that just provides a
> more convenient interface to another function?  But I guess it's a
> linux-specific heuristic, so I can't really say.

Huh, I got the insight! I think that the current approach (originally by PaX
Team) should work fine despite the false positives which you described:

If some static inline function already does explicit calls (so is_leaf is
false), adding the track_stack() call will not introduce anything special that
can break the aforementioned register clobbering ABI in that function.

Does it sound reasonable?

However, I don't know what to with false negatives.

> TBH the paravirt save_fl stuff seems like dancing on the edge,
> but that's another story. :-)

That's interesting. Could you elaborate on that?

>>>> +	/*
>>>> +	 * The stackleak_final pass should be executed before the "final" pass,
>>>> +	 * which turns the RTL (Register Transfer Language) into assembly.
>>>> +	 */
>>>> +	PASS_INFO(stackleak_final, "final", 1, PASS_POS_INSERT_BEFORE);
>>>
>>> This might be too late, since it happens e.g. after addresses have
>>> been calculated for branch ranges, and after machine-specific passes
>>> (e.g. bundling on ia64).
>>>
>>> The stack size is final after reload, so inserting the pass after that
>>> might be better.
>>
>> Thanks for that notice. May I ask for the additional clarification?
>>
>> I specified -fdump-passes and see a lot of passes between reload and final:
...
>>
>> Where exactly would you recommend me to insert the stackleak_final pass, which
>> removes the unneeded track_stack() calls?
> 
> Directly after rtl-reload seems best.  That's the first point at which
> the frame size is final, and reload is one of the few rtl passes that
> always runs.  Doing it there could also help with things like shrink
> wrapping (part of rtl-pro_and_epilogue).
Thanks a lot for your detailed answer. I'll follow your advice in the next
version of the patch series.

Best regards,
Alexander
