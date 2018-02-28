Subject: Re: [PATCH 1/2] stackleak: Update for arm64
References: <20180221011303.20392-1-labbott@redhat.com>
 <20180221011303.20392-2-labbott@redhat.com> <20180222165834.GC18421@arm.com>
 <97090ca6-efad-7c03-6084-a97674ae61c7@linux.com>
 <874lm2d96q.fsf@e105548-lin.cambridge.arm.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <5d10c6ad-b4b6-eb27-79f0-ca235b73e7eb@linux.com>
Date: Wed, 28 Feb 2018 18:09:54 +0300
MIME-Version: 1.0
In-Reply-To: <874lm2d96q.fsf@e105548-lin.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Will Deacon <will.deacon@arm.com>, Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, richard.sandiford@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On 27.02.2018 13:21, Richard Sandiford wrote:
> Hi Alexander,
> 
> Sorry for the slow reply, been caught up in an office move.

Thank you very much for the review, Richard!

> Alexander Popov <alex.popov@linux.com> writes:
>> Would you be so kind to take a look at the whole STACKLEAK plugin?
>> http://www.openwall.com/lists/kernel-hardening/2018/02/16/4
>> https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=kspp/gcc-plugin/stackleak&id=57a0a6763b12e82dd462593d0f42be610e93cdc9
>>
>> It's not very big. I documented it in detail. I would be really grateful for the
>> review!
> 
> Looks good to me FWIW.  Just a couple of minor things:
> 
>> +	/*
>> +	 * 1. Loop through the GIMPLE statements in each of cfun basic blocks.
>> +	 * cfun is a global variable which represents the function that is
>> +	 * currently processed.
>> +	 */
>> +	FOR_EACH_BB_FN(bb, cfun) {
>> +		for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
>> +			gimple stmt;
>> +
>> +			stmt = gsi_stmt(gsi);
>> +
>> +			/* Leaf function is a function which makes no calls */
>> +			if (is_gimple_call(stmt))
>> +				is_leaf = false;
> 
> It's probably not going to matter in practice, but it might be worth
> emphasising in the comments that this leafness is only approximate.

That's important, thank you! May I ask why you think it's not going to matter in
practice?

> It will sometimes be a false positive, because we could still
> end up creating calls to libgcc functions from non-call statements
> (or for target-specific reasons).  It can also be a false negative,
> since call statements can be to built-in or internal functions that
> end up being open-coded.

Oh, that raises the question: how does this leafness inaccuracy affect in my
particular case?

is_leaf is currently used for finding the special cases to skip the
track_stack() call insertion:

/*
 * Special cases to skip the instrumentation.
 *
 * Taking the address of static inline functions materializes them,
 * but we mustn't instrument some of them as the resulting stack
 * alignment required by the function call ABI will break other
 * assumptions regarding the expected (but not otherwise enforced)
 * register clobbering ABI.
 *
 * Case in point: native_save_fl on amd64 when optimized for size
 * clobbers rdx if it were instrumented here.
 *
 * TODO: any more special cases?
 */
if (is_leaf &&
    !TREE_PUBLIC(current_function_decl) &&
    DECL_DECLARED_INLINE_P(current_function_decl)) {
	return 0;
}


And now it seems to me that the stackleak plugin should not instrument all
static inline functions, regardless of is_leaf. Do you agree?

>> +	/*
>> +	 * The stackleak_final pass should be executed before the "final" pass,
>> +	 * which turns the RTL (Register Transfer Language) into assembly.
>> +	 */
>> +	PASS_INFO(stackleak_final, "final", 1, PASS_POS_INSERT_BEFORE);
> 
> This might be too late, since it happens e.g. after addresses have
> been calculated for branch ranges, and after machine-specific passes
> (e.g. bundling on ia64).
> 
> The stack size is final after reload, so inserting the pass after that
> might be better.

Thanks for that notice. May I ask for the additional clarification?

I specified -fdump-passes and see a lot of passes between reload and final:
  ...
  rtl-sched1                                       :  OFF
  rtl-ira                                          :  ON
  rtl-reload                                       :  ON
  rtl-vzeroupper                                   :  OFF
  *all-postreload                                  :  OFF
     rtl-postreload                                :  OFF
     rtl-gcse2                                     :  OFF
     rtl-split2                                    :  ON
     rtl-ree                                       :  ON
     rtl-cmpelim                                   :  OFF
     rtl-btl1                                      :  OFF
     rtl-pro_and_epilogue                          :  ON
     rtl-dse2                                      :  ON
     rtl-csa                                       :  ON
     rtl-jump2                                     :  ON
     rtl-compgotos                                 :  ON
     rtl-sched_fusion                              :  OFF
     rtl-peephole2                                 :  ON
     rtl-ce3                                       :  ON
     rtl-rnreg                                     :  OFF
     rtl-cprop_hardreg                             :  ON
     rtl-rtl_dce                                   :  ON
     rtl-bbro                                      :  ON
     rtl-btl2                                      :  OFF
     *leaf_regs                                    :  ON
     rtl-split4                                    :  ON
     rtl-sched2                                    :  ON
     *stack_regs                                   :  ON
        rtl-split3                                 :  OFF
        rtl-stack                                  :  ON
  *all-late_compilation                            :  OFF
     rtl-alignments                                :  ON
     rtl-vartrack                                  :  ON
     *free_cfg                                     :  ON
     rtl-mach                                      :  ON
     rtl-barriers                                  :  ON
     rtl-dbr                                       :  OFF
     rtl-split5                                    :  OFF
     rtl-eh_ranges                                 :  OFF
     rtl-shorten                                   :  ON
     rtl-nothrow                                   :  ON
     rtl-dwarf2                                    :  ON
     rtl-stackleak_final                           :  ON
     rtl-final                                     :  ON
  rtl-dfinish                                      :  ON
clean_state                                        :  ON

Where exactly would you recommend me to insert the stackleak_final pass, which
removes the unneeded track_stack() calls?

Best regards,
Alexander
