Return-Path: <SRS0=oHW8=LL=lists.openwall.com=kernel-hardening-return-21313-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96010C2B9F4
	for <kernel-hardening@archiver.kernel.org>; Thu, 17 Jun 2021 10:10:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9B58B611CE
	for <kernel-hardening@archiver.kernel.org>; Thu, 17 Jun 2021 10:10:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B58B611CE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=iogearbox.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21313-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7939 invoked by uid 550); 17 Jun 2021 10:09:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7901 invoked from network); 17 Jun 2021 10:09:58 -0000
Subject: Re: [PATCH v5] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
To: Eric Biggers <ebiggers@kernel.org>
Cc: Edward Cree <ecree.xilinx@gmail.com>,
 Kurt Manucredo <fuzzybritches0@gmail.com>,
 syzbot+bed360704c521841c85d@syzkaller.appspotmail.com,
 keescook@chromium.org, yhs@fb.com, dvyukov@google.com, andrii@kernel.org,
 ast@kernel.org, bpf@vger.kernel.org, davem@davemloft.net, hawk@kernel.org,
 john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, songliubraving@fb.com,
 syzkaller-bugs@googlegroups.com, nathan@kernel.org, ndesaulniers@google.com,
 clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com,
 kasan-dev@googlegroups.com
References: <1aaa2408-94b9-a1e6-beff-7523b66fe73d@fb.com>
 <202106101002.DF8C7EF@keescook>
 <CAADnVQKMwKYgthoQV4RmGpZm9Hm-=wH3DoaNqs=UZRmJKefwGw@mail.gmail.com>
 <85536-177443-curtm@phaethon>
 <bac16d8d-c174-bdc4-91bd-bfa62b410190@gmail.com> <YMkAbNQiIBbhD7+P@gmail.com>
 <dbcfb2d3-0054-3ee6-6e76-5bd78023a4f2@iogearbox.net>
 <YMkcYn4dyZBY/ze+@gmail.com> <YMkdx1VB0i+fhjAY@gmail.com>
 <4713f6e9-2cfb-e2a6-c42d-b2a62f035bf2@iogearbox.net>
 <YMkkr5G6E8lcFymG@gmail.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <845ad31f-ca3f-0326-e64b-423a09ea4bea@iogearbox.net>
Date: Thu, 17 Jun 2021 12:09:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YMkkr5G6E8lcFymG@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26203/Wed Jun 16 13:07:58 2021)

On 6/16/21 12:07 AM, Eric Biggers wrote:
> On Tue, Jun 15, 2021 at 11:54:41PM +0200, Daniel Borkmann wrote:
>> On 6/15/21 11:38 PM, Eric Biggers wrote:
>>> On Tue, Jun 15, 2021 at 02:32:18PM -0700, Eric Biggers wrote:
>>>> On Tue, Jun 15, 2021 at 11:08:18PM +0200, Daniel Borkmann wrote:
>>>>> On 6/15/21 9:33 PM, Eric Biggers wrote:
>>>>>> On Tue, Jun 15, 2021 at 07:51:07PM +0100, Edward Cree wrote:
>>>>>>>
>>>>>>> As I understand it, the UBSAN report is coming from the eBPF interpreter,
>>>>>>>     which is the *slow path* and indeed on many production systems is
>>>>>>>     compiled out for hardening reasons (CONFIG_BPF_JIT_ALWAYS_ON).
>>>>>>> Perhaps a better approach to the fix would be to change the interpreter
>>>>>>>     to compute "DST = DST << (SRC & 63);" (and similar for other shifts and
>>>>>>>     bitnesses), thus matching the behaviour of most chips' shift opcodes.
>>>>>>> This would shut up UBSAN, without affecting JIT code generation.
>>>>>>
>>>>>> Yes, I suggested that last week
>>>>>> (https://lkml.kernel.org/netdev/YMJvbGEz0xu9JU9D@gmail.com).  The AND will even
>>>>>> get optimized out when compiling for most CPUs.
>>>>>
>>>>> Did you check if the generated interpreter code for e.g. x86 is the same
>>>>> before/after with that?
>>>>
>>>> Yes, on x86_64 with gcc 10.2.1, the disassembly of ___bpf_prog_run() is the same
>>>> both before and after (with UBSAN disabled).  Here is the patch I used:
>>>>
>>>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>>>> index 5e31ee9f7512..996db8a1bbfb 100644
>>>> --- a/kernel/bpf/core.c
>>>> +++ b/kernel/bpf/core.c
>>>> @@ -1407,12 +1407,30 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
>>>>    		DST = (u32) DST OP (u32) IMM;	\
>>>>    		CONT;
>>>> +	/*
>>>> +	 * Explicitly mask the shift amounts with 63 or 31 to avoid undefined
>>>> +	 * behavior.  Normally this won't affect the generated code.
>>
>> The last one should probably be more specific in terms of 'normally', e.g. that
>> it is expected that the compiler is optimizing this away for archs like x86. Is
>> arm64 also covered by this ... do you happen to know on which archs this won't
>> be the case?
>>
>> Additionally, I think such comment should probably be more clear in that it also
>> needs to give proper guidance to JIT authors that look at the interpreter code to
>> see what they need to implement, in other words, that they don't end up copying
>> an explicit AND instruction emission if not needed there.
> 
> Same result on arm64 with gcc 10.2.0.
> 
> On arm32 it is different, probably because the 64-bit shifts aren't native in
> that case.  I don't know about other architectures.  But there aren't many ways
> to implement shifts, and using just the low bits of the shift amount is the most
> logical way.
> 
> Please feel free to send out a patch with whatever comment you want.  The diff I
> gave was just an example and I am not an expert in BPF.
> 
>>
>>>> +	 */
>>>> +#define ALU_SHIFT(OPCODE, OP)		\
>>>> +	ALU64_##OPCODE##_X:		\
>>>> +		DST = DST OP (SRC & 63);\
>>>> +		CONT;			\
>>>> +	ALU_##OPCODE##_X:		\
>>>> +		DST = (u32) DST OP ((u32)SRC & 31);	\
>>>> +		CONT;			\
>>>> +	ALU64_##OPCODE##_K:		\
>>>> +		DST = DST OP (IMM & 63);	\
>>>> +		CONT;			\
>>>> +	ALU_##OPCODE##_K:		\
>>>> +		DST = (u32) DST OP ((u32)IMM & 31);	\
>>>> +		CONT;
>>
>> For the *_K cases these are explicitly rejected by the verifier already. Is this
>> required here nevertheless to suppress UBSAN false positive?
> 
> No, I just didn't know that these constants are never out of range.  Please feel
> free to send out a patch that does this properly.

Summarized and fixed via:

https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=28131e9d933339a92f78e7ab6429f4aaaa07061c

Thanks everyone,
Daniel
