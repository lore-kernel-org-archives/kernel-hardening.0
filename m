Return-Path: <SRS0=EAp8=LJ=lists.openwall.com=kernel-hardening-return-21307-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3918C48BE5
	for <kernel-hardening@archiver.kernel.org>; Tue, 15 Jun 2021 21:08:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C509D613B9
	for <kernel-hardening@archiver.kernel.org>; Tue, 15 Jun 2021 21:08:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C509D613B9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=iogearbox.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21307-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32399 invoked by uid 550); 15 Jun 2021 21:08:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32362 invoked from network); 15 Jun 2021 21:08:44 -0000
Subject: Re: [PATCH v5] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
To: Eric Biggers <ebiggers@kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Cc: Kurt Manucredo <fuzzybritches0@gmail.com>,
 syzbot+bed360704c521841c85d@syzkaller.appspotmail.com,
 keescook@chromium.org, yhs@fb.com, dvyukov@google.com, andrii@kernel.org,
 ast@kernel.org, bpf@vger.kernel.org, davem@davemloft.net, hawk@kernel.org,
 john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, songliubraving@fb.com,
 syzkaller-bugs@googlegroups.com, nathan@kernel.org, ndesaulniers@google.com,
 clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com,
 kasan-dev@googlegroups.com
References: <CAADnVQKexxZQw0yK_7rmFOdaYabaFpi2EmF6RGs5bXvFHtUQaA@mail.gmail.com>
 <CACT4Y+b=si6NCx=nRHKm_pziXnVMmLo-eSuRajsxmx5+Hy_ycg@mail.gmail.com>
 <202106091119.84A88B6FE7@keescook>
 <752cb1ad-a0b1-92b7-4c49-bbb42fdecdbe@fb.com>
 <CACT4Y+a592rxFmNgJgk2zwqBE8EqW1ey9SjF_-U3z6gt3Yc=oA@mail.gmail.com>
 <1aaa2408-94b9-a1e6-beff-7523b66fe73d@fb.com> <202106101002.DF8C7EF@keescook>
 <CAADnVQKMwKYgthoQV4RmGpZm9Hm-=wH3DoaNqs=UZRmJKefwGw@mail.gmail.com>
 <85536-177443-curtm@phaethon>
 <bac16d8d-c174-bdc4-91bd-bfa62b410190@gmail.com> <YMkAbNQiIBbhD7+P@gmail.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dbcfb2d3-0054-3ee6-6e76-5bd78023a4f2@iogearbox.net>
Date: Tue, 15 Jun 2021 23:08:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YMkAbNQiIBbhD7+P@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26202/Tue Jun 15 13:21:24 2021)

On 6/15/21 9:33 PM, Eric Biggers wrote:
> On Tue, Jun 15, 2021 at 07:51:07PM +0100, Edward Cree wrote:
>>
>> As I understand it, the UBSAN report is coming from the eBPF interpreter,
>>   which is the *slow path* and indeed on many production systems is
>>   compiled out for hardening reasons (CONFIG_BPF_JIT_ALWAYS_ON).
>> Perhaps a better approach to the fix would be to change the interpreter
>>   to compute "DST = DST << (SRC & 63);" (and similar for other shifts and
>>   bitnesses), thus matching the behaviour of most chips' shift opcodes.
>> This would shut up UBSAN, without affecting JIT code generation.
> 
> Yes, I suggested that last week
> (https://lkml.kernel.org/netdev/YMJvbGEz0xu9JU9D@gmail.com).  The AND will even
> get optimized out when compiling for most CPUs.

Did you check if the generated interpreter code for e.g. x86 is the same
before/after with that?

How does UBSAN detect this in general? I would assume generated code for
interpreter wrt DST = DST << SRC would not really change as otherwise all
valid cases would be broken as well, given compiler has not really room
to optimize or make any assumptions here, in other words, it's only
propagating potential quirks under such cases from underlying arch.

Thanks,
Daniel
