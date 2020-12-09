Return-Path: <SRS0=5TyY=FN=lists.openwall.com=kernel-hardening-return-20552-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2795C4361B
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Dec 2020 10:31:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A827623B6B
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Dec 2020 10:31:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A827623B6B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20552-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15736 invoked by uid 550); 9 Dec 2020 10:31:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1531 invoked from network); 9 Dec 2020 04:56:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yNxPOOK8GUbsNe5moby382MnhA6+vA6WAhboDqo7Axs=;
        b=gVlT6d0N/3N0A44YyPBRrdAxvqWSB7tInBfZYe89aKi6EzHIs7gP38E5CuWbaquJ9Q
         lC1TB2BxZUYHFRIwXjsuezaszTqBj7bKmpzzgY40z0e7LLAFdthLmtnn3YPf/IEXMkLc
         uuaBS0tglR6qOsch4B7MSYVIDFITtcPTJxHeU5A6u96w8NBHLL2cRAa1oSHG0o+gDjES
         LRBnSQST8QVgjW7urPuaJ13hoWEbi3iuyJLUcTkEcPCwBaydpA8W9h+RHDRqv/3BC5QO
         aT3Tn0QBJmvAL3K/fKFdgT/IIZVcAKEdJKnXkXMb7a2aG8QVPIhjtldRqQ/aGIBinoxs
         9hsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yNxPOOK8GUbsNe5moby382MnhA6+vA6WAhboDqo7Axs=;
        b=g/aqxaDqYsgDElXGNUjy+/QKhnNiq9EgAVwpQAdnIvaTHdXmv0Ap1Am2e31i8u3eek
         Bj97LyhX8l+KhqC7n7uaoW9xG2nE1wt5cppENMT+GpzmMUOanZjRcd3VkG2zRS+h4mjN
         hzLcPjhzjDCZ6XgbdiDT9lbB0Af4PgwUYC5zrhuv9SNGiUACdgnA2z6t9xEnkPQD1qEh
         iNUgGX2OLc42ZDddAusiy5hicvonqiXQfHa70ZPlxHVNafjxDlAExX+KniGw4P76yigJ
         sGsNtU73mlgEXb5MbuwYr6qfGGNwLCq8A/ejYoCMP+1zV1+ZHQirQ0I/+D+PgmfiFC/h
         T2oA==
X-Gm-Message-State: AOAM53090aggpd8EFZbymfWwy0h8f6euYVKVJKKqqySNvNH94mnfaLZV
	9+FcKewF4Q/Tt9y9bBZjSjfUMw==
X-Google-Smtp-Source: ABdhPJyVhevtlV182GztPlTk2U6DWLN8px/r+M03xp8sndkyhgLZY0CoPxIqSa+brsrwqARmVo17sA==
X-Received: by 2002:a63:494f:: with SMTP id y15mr405121pgk.364.1607489758368;
        Tue, 08 Dec 2020 20:55:58 -0800 (PST)
Date: Tue, 8 Dec 2020 20:55:54 -0800
From: Fangrui Song <maskray@google.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Arnd Bergmann <arnd@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v8 00/16] Add support for Clang LTO
Message-ID: <20201209045554.fxlzrmxknakl2gdr@google.com>
References: <20201201213707.541432-1-samitolvanen@google.com>
 <CAK8P3a1WEAo2SEgKUEs3SB7n7QeeHa0=cx_nO==rDK0jjDArow@mail.gmail.com>
 <CABCJKueCHo2RYfx_A21m+=d1gQLR9QsOOxCsHFeicCqyHkb-Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CABCJKueCHo2RYfx_A21m+=d1gQLR9QsOOxCsHFeicCqyHkb-Kg@mail.gmail.com>


On 2020-12-08, 'Sami Tolvanen' via Clang Built Linux wrote:
>On Tue, Dec 8, 2020 at 4:15 AM Arnd Bergmann <arnd@kernel.org> wrote:
>>
>> On Tue, Dec 1, 2020 at 10:37 PM 'Sami Tolvanen' via Clang Built Linux
>> <clang-built-linux@googlegroups.com> wrote:
>> >
>> > This patch series adds support for building the kernel with Clang's
>> > Link Time Optimization (LTO). In addition to performance, the primary
>> > motivation for LTO is to allow Clang's Control-Flow Integrity (CFI)
>> > to be used in the kernel. Google has shipped millions of Pixel
>> > devices running three major kernel versions with LTO+CFI since 2018.
>> >
>> > Most of the patches are build system changes for handling LLVM
>> > bitcode, which Clang produces with LTO instead of ELF object files,
>> > postponing ELF processing until a later stage, and ensuring initcall
>> > ordering.
>> >
>> > Note that arm64 support depends on Will's memory ordering patches
>> > [1]. I will post x86_64 patches separately after we have fixed the
>> > remaining objtool warnings [2][3].
>> >
>> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/log/?h=for-next/lto
>> > [2] https://lore.kernel.org/lkml/20201120040424.a3wctajzft4ufoiw@treble/
>> > [3] https://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git/log/?h=objtool-vmlinux
>> >
>> > You can also pull this series from
>> >
>> >   https://github.com/samitolvanen/linux.git lto-v8
>>
>> I've tried pull this into my randconfig test tree to give it a spin.
>
>Great, thank you for testing this!
>
>> So far I have
>> not managed to get a working build out of it, the main problem so far being
>> that it is really slow to build because the link stage only uses one CPU.
>> These are the other issues I've seen so far:

ld.lld ThinLTO uses the number of (physical cores enabled by affinity) by default.

>You may want to limit your testing only to ThinLTO at first, because
>full LTO is going to be extremely slow with larger configs, especially
>when building arm64 kernels.
>
>> - one build seems to take even longer to link. It's currently at 35GB RAM
>>   usage and 40 minutes into the final link, but I'm worried it might
>> not complete
>>   before it runs out of memory.  I only have 128GB installed, and google-chrome
>>   uses another 30GB of that, and I'm also doing some other builds in parallel.
>>   Is there a minimum recommended amount of memory for doing LTO builds?
>
>When building arm64 defconfig, the maximum memory usage I measured
>with ThinLTO was 3.5 GB, and with full LTO 20.3 GB. I haven't measured
>larger configurations, but I believe LLD can easily consume 3-4x that
>much with full LTO allyesconfig.
>
>> - One build failed with
>>  ld.lld -EL -maarch64elf -mllvm -import-instr-limit=5 -r -o vmlinux.o
>> -T .tmp_initcalls.lds --whole-archive arch/arm64/kernel/head.o
>> init/built-in.a usr/built-in.a arch/arm64/built-in.a kernel/built-in.a
>> certs/built-in.a mm/built-in.a fs/built-in.a ipc/built-in.a
>> security/built-in.a crypto/built-in.a block/built-in.a
>> arch/arm64/lib/built-in.a lib/built-in.a drivers/built-in.a
>> sound/built-in.a net/built-in.a virt/built-in.a --no-whole-archive
>> --start-group arch/arm64/lib/lib.a lib/lib.a
>> ./drivers/firmware/efi/libstub/lib.a --end-group
>>   "ld.lld: error: arch/arm64/kernel/head.o: invalid symbol index"
>>   after about 30 minutes
>
>That's interesting. Did you use LLVM_IAS=1?

May be worth checking which relocation or (SHT_GROUP section's sh_info) in arch/arm64/kernel/head.o is incorrect.

>> - CONFIG_CPU_BIG_ENDIAN doesn't seem to work with lld, and LTO
>>   doesn't work with ld.bfd.
>>   I've added a CPU_LITTLE_ENDIAN dependency to
>>   ARCH_SUPPORTS_LTO_CLANG{,THIN}
>
>Ah, good point. I'll fix this in v9.

Full/Thin LTO should work with GNU ld and gold with LLVMgold.so built from
llvm-project (https://llvm.org/docs/GoldPlugin.html ). You'll need to make sure
that LLVMgold.so is newer than clang. (Newer clang may introduce bitcode
attributes which are unrecognizable by older LLVMgold.so/ld.lld)

>[...]
>> Not sure if these are all known issues. If there is one you'd like me try
>> take a closer look at for finding which config options break it, I can try
>
>No, none of these are known issues. I would be happy to take a closer
>look if you can share configs that reproduce these.
>
>Sami
>
>-- 
>You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
>To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
>To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/CABCJKueCHo2RYfx_A21m%2B%3Dd1gQLR9QsOOxCsHFeicCqyHkb-Kg%40mail.gmail.com.
