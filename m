Return-Path: <SRS0=/WjQ=36=lists.openwall.com=kernel-hardening-return-17751-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA55C352A5
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 17:19:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 143F220715
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 17:19:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 143F220715
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17751-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25742 invoked by uid 550); 10 Feb 2020 17:19:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25717 invoked from network); 10 Feb 2020 17:19:15 -0000
From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v7 09/11] arm64: disable SCS for hypervisor code
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Mark Rutland <mark.rutland@arm.com>, Dave Martin <Dave.Martin@arm.com>,
 Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
 Jann Horn <jannh@google.com>, Miguel Ojeda
 <miguel.ojeda.sandonis@gmail.com>,
 Masahiro Yamada <yamada.masahiro@socionext.com>,
 clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200128184934.77625-1-samitolvanen@google.com>
 <20200128184934.77625-10-samitolvanen@google.com>
Message-ID: <6f62b3c0-e796-e91c-f53b-23bd80fcb065@arm.com>
Date: Mon, 10 Feb 2020 17:18:58 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200128184934.77625-10-samitolvanen@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit

Hi Sami,

On 28/01/2020 18:49, Sami Tolvanen wrote:
> Filter out CC_FLAGS_SCS and -ffixed-x18 for code that runs at a
> different exception level.

Hmmm, there are two things being disabled here.

Stashing the lr in memory pointed to by VA won't work transparently at EL2 ... but
shouldn't KVM's C code still treat x18 as a fixed register?


As you have an __attribute__((no_sanitize("shadow-call-stack"))), could we add that to
__hyp_text instead? (its a smaller hammer!) All of KVM's EL2 code is marked __hyp_text,
but that isn't everything in these files. Doing it like this would leave KVM's VHE-only
paths covered.

As an example, with VHE the kernel and KVM both run at EL2, and KVM behaves differently:
kvm_vcpu_put_sysregs() in kvm/hyp/sysreg-sr.c is called from a preempt notifier as
the EL2 registers are always accessible.


Thanks,

James

> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> index ea710f674cb6..5843adef9ef6 100644
> --- a/arch/arm64/kvm/hyp/Makefile
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -28,3 +28,6 @@ GCOV_PROFILE	:= n
>  KASAN_SANITIZE	:= n
>  UBSAN_SANITIZE	:= n
>  KCOV_INSTRUMENT	:= n
> +
> +# remove the SCS flags from all objects in this directory
> +KBUILD_CFLAGS := $(filter-out -ffixed-x18 $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
