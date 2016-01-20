Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <569ED87D.7040705@iogearbox.net>
Date: Wed, 20 Jan 2016 01:44:45 +0100
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
References: <2236FBA76BA1254E88B949DDB74E612B41A51095@IRSMSX102.ger.corp.intel.com>	<569CF813.5070306@iogearbox.net> <CAGXu5jKp-1yfyhepf4_CcAz7jPpDijWA-pH9_Uq5FDu_ahVChQ@mail.gmail.com>
In-Reply-To: <CAGXu5jKp-1yfyhepf4_CcAz7jPpDijWA-pH9_Uq5FDu_ahVChQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Understanding the JIT Hardening feature
To: kernel-hardening@lists.openwall.com
Cc: elena.reshetova@intel.com, "Schaufler, Casey" <casey.schaufler@intel.com>, "Leibowitz, Michael" <michael.leibowitz@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 01/20/2016 12:58 AM, Kees Cook wrote:
> Hi,
>
> On Mon, Jan 18, 2016 at 6:34 AM, Daniel Borkmann <daniel@iogearbox.net> wrote:
>> Hi Elena,
>>
>> On 01/18/2016 10:22 AM, Reshetova, Elena wrote:
>> [...]
>>>
>>> I got to spend some time reading the 3.15 grsecurity patch with regards to
>>> JIT hardening feature and wanted to share my thoughts on what the patch
>>> was
>>> attempting to do.
>>>
>>> It seems that the bulk of changes was done in bpf_jit_compile() function
>>> (corresponds to the do_jit() 4.4 function).
>>>
>>> The way how it was done was to generate a random value (randkey =
>>> prandom_u32();) and then use that value to dilute (by xor with this value)
>>> the the four cases of operations:
>>>
>>> case BPF_S_ALU_MUL_K: /* A *= K */
>>>
>>> case BPF_S_ALU_MOD_K: /* A %= K; */
>>>
>>> case BPF_S_ALU_DIV_K: /* A /= K */
>>>
>>> case BPF_S_ALU_AND_X:
>>
>>
>> Hm, you mean BPF_S_ALU_AND_K I presume?
>>
>> Yeah, that mitigation as implemented makes absolute sense to me. You blind
>> at
>> least the 32bit constants away by xor with randkey.
>>
>> [...]
>>>
>>> Another part of the patch was making changes to the bpf_alloc_binary()
>>> function. That part I don't really understand since it didn't seem to make
>>> any security improvements, but merely setting the header length to be 128
>>> ad
>>> changing the bpf_binary_header pointer structure. If this change is to be
>>> moved to the latest kernel, modifications to the
>>> <http://lxr.free-electrons.com/ident?i=bpf_jit_binary_alloc>
>>> bpf_jit_binary_alloc() function (kernel/bpf/core.c) are needed as well as
>>> changes in  <http://lxr.free-electrons.com/ident?i=bpf_binary_header>
>>> bpf_binary_header pointer structure (include/linux/filter.h). But again, I
>>> do not understand what security improvements these changes make and why
>>> they
>>> were done at the first place.
>>
>>
>> I don't know the patch set deeply enough, but that part, I believe, is a PaX
>> specific simplification. It doesn't need the struct bpf_binary_header and
>> can
>> thus remove this bit of code. The image is written with pax_open_kernel()/
>> pax_close_kernel() pair, and f.e. set_memory_ro() can be removed as PaX
>> already
>> comes with native protections that handle such things.
>
> I would agree: this was likely improvements for KERNEXEC and CONSTIFY.
>
> Daniel, did we end up with a generic way to make sure all the JITs end
> up in read-only memory once they're done being built? I know it got
> fixed in a few cases, but it wasn't clear to me if they all got fixed.

'Sort of', so far archs that have DEBUG_SET_MODULE_RONX should be covered
(x86, s390, arm, arm64). 60a3b2253c41 was for eBPF byte code in general,
and JITs need to be converted to use the bpf_jit_binary_alloc() /
bpf_jit_binary_free() helpers and set_memory_ro() resp. set_memory_rw(),
if their archs have it supported (f.e. a conversion could look like
b569c1c622c5), which is the case for the mentioned ones above.

>>> The last change from the patch was done in EMIT_COND_JMP() function (which
>>> in later kernels is included into emit_cond_jmp switch statement), which
>>> was
>>> adding a conditional jz into the flow based on the randkey value. It was
>>> affecting the following cases:
>>>
>>> case BPF_S_ALU_DIV_X: /* A /= X; */
>>> case BPF_S_ALU_MOD_X: /* A %= X; */
>>> case BPF_S_ANC_IFINDEX:
>>
>>
>> (... for the jumps in 'failure' cases.)
>>
>>> as well as conditional branch.
>>
>>
>> Yeah, I think to catch bugs or issues with long jumps, so we effectively BUG
>> in case jump is off by few bytes. If you look at the kernel git history,
>> there
>> was such a case/bug longer time ago that got fixed.
>>
>>> The above doesn't seem to go very much in line with what Daniel suggested
>>> earlier:
>>>
>>> "We agreed that the way to go would be to try mitigating it on a BPF
>>> bytecode level iff feasible. For example, by expanding/rewriting things
>>> like
>>> loading constants into a i) load where the constant is xored with a (each
>>> time newly generated) prandom_u32()/.. value followed by ii) xor on the
>>> same
>>> reg with that prandom value itself."
>>>
>>> It is also very likely that I didn't understand what you mean Daniel. So
>>> some clarification questions:
>>>
>>> -          would you agree with the places where the original grsecurity
>>> patch attempts to add randomization or do you think places should be
>>> different?
>>>
>>> -          for the actual randomization, are you proposing to enhance it
>>> by
>>> not only xor to a prandom_u32() but also xor with the same reg? Could you
>>> explain what do you mean by this part?
>>
>>
>> To answer both, hopefully ...
>>
>> I am simply saying that before we go and change every JIT there is in the
>> kernel, we should give it a try and rewrite BPF instructions first (so BPF
>> byte code, I mean). That way, JITs would /not/ need to be changed, and would
>> effectively emit something similar to the image /transparently/. So changes
>> need to be done in BPF core code instead of JITs. Underlying idea to blind
>> them out is the same, of course (/how/ you blind them is implementation
>> detail).
>> If that path would not be feasible at all for some very good reasons, then
>> we
>> can still look into changing the JITs themselves. If you look into the git
>> history of some of the JITs, there are some rather bad bugs that got fixed.
>> So, we should try hard to solve this on a generic level first, and if it
>> turns out to work well **, then we don't need to add further complexity to
>> each JIT eventually (x86 is just one, but there are arm, arm64, ppc, mips,
>> sparc, s390 as well).
>>
>>   **: Also in terms of performance, what I mean by that is: iff due to all
>> the
>> mitigation/complexity added, we turn out to become almost as slow as
>> interpreter
>> case, then a disabling CONFIG_BPF_JIT in your config might simply be the
>> better
>> mitigation option ;). I think we should still be faster, but it certainly
>> needs to be checked, too.
>>
>>> I was also trying to find more info about how JIT code itself works, but
>>> wasn't able to find anything reasonable, so have to make all my statements
>>> from just reading the code, which turned out isn't the most easiest thing
>>> to
>>> understand for smbd not familiar with topic.  So, any pointers to the
>>> reading material, if exist, are very much appreciated.
>>
>>
>> Here's some rudimentary documentation on the topic in general (yeah, could
>> need some improvements):
>>
>>    Documentation/networking/filter.txt
>
> Elena, as you learn the JIT code, could you improve this
> documentation, too? That would be quite valuable. :)
>
> -Kees
>
