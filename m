Return-Path: <SRS0=9Dhm=AD=lists.openwall.com=kernel-hardening-return-19039-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D84F9C433DF
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 19:41:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 276D420767
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 19:41:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j9dDq1D5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 276D420767
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19039-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5406 invoked by uid 550); 22 Jun 2020 19:41:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5368 invoked from network); 22 Jun 2020 19:41:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=Tp0FvdeMkD0In5KDxlOtCuC1dG7VeQNXQJo7C/sHai0=; b=j9dDq1D51Tu300HC9aIqfHqXrc
	5GsiBOxLP8aOZOMTrBrw86raw9grYGO9RU3QoRxrQjM3MbPncZPIaJD7nCx/iEAoDicUJ488gskqF
	eKwEUyWCBQf64/YzbovPa0zFNLCfqtjJnlx19cxHCWZ8896i6pjLHmHKaIqmqVGsz0kSFlRQzk6NS
	mxeKG9aoT9a5UtJ2faJ1aBOjtDzXAhrIfw/e8DdYA26SNjVODiL+Jq5iHY/kkANiCJ7NtGhAFQ7vv
	ia9YZKF88jbmGSh5r/VTE2oYtypW6d/g9eZaFjimuuiyH4z3nX4+kaRhyxw6GQIaL3PT4DMvV0w4d
	aYc+m9vA==;
Subject: Re: [PATCH v4 3/5] stack: Optionally randomize kernel stack offset
 each syscall
To: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Alexander Potapenko
 <glider@google.com>, Alexander Popov <alex.popov@linux.com>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jann Horn <jannh@google.com>,
 kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20200622193146.2985288-1-keescook@chromium.org>
 <20200622193146.2985288-4-keescook@chromium.org>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <87a7b943-ed15-8521-773e-c182a37ee61e@infradead.org>
Date: Mon, 22 Jun 2020 12:40:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622193146.2985288-4-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 6/22/20 12:31 PM, Kees Cook wrote:
> This provides the ability for architectures to enable kernel stack base
> address offset randomization. This feature is controlled by the boot
> param "randomize_kstack_offset=on/off", with its default value set by
> CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT.
> 
> Co-developed-by: Elena Reshetova <elena.reshetova@intel.com>
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> Link: https://lore.kernel.org/r/20190415060918.3766-1-elena.reshetova@intel.com
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  Makefile                         |  4 ++++
>  arch/Kconfig                     | 23 ++++++++++++++++++
>  include/linux/randomize_kstack.h | 40 ++++++++++++++++++++++++++++++++
>  init/main.c                      | 23 ++++++++++++++++++
>  4 files changed, 90 insertions(+)
>  create mode 100644 include/linux/randomize_kstack.h

Hi,
Please add documentation for the new kernel boot parameter to
Documentation/admin-guide/kernel-parameters.txt.


> diff --git a/arch/Kconfig b/arch/Kconfig
> index 1ea61290900a..1f52c9cfefca 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -883,6 +883,29 @@ config VMAP_STACK
>  	  virtual mappings with real shadow memory, and KASAN_VMALLOC must
>  	  be enabled.
>  
> +config HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
> +	def_bool n
> +	help
> +	  An arch should select this symbol if it can support kernel stack
> +	  offset randomization with calls to add_random_kstack_offset()
> +	  during syscall entry and choose_random_kstack_offset() during
> +	  syscall exit. Downgrading of -fstack-protector-strong to
> +	  -fstack-protector should also be applied to the entry code and
> +	  closely examined, as the artificial stack bump looks like an array
> +	  to the compiler, so it will attempt to add canary checks regardless
> +	  of the static branch state.
> +
> +config RANDOMIZE_KSTACK_OFFSET_DEFAULT
> +	bool "Randomize kernel stack offset on syscall entry"
> +	depends on HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
> +	help
> +	  The kernel stack offset can be randomized (after pt_regs) by
> +	  roughly 5 bits of entropy, frustrating memory corruption
> +	  attacks that depend on stack address determinism or
> +	  cross-syscall address exposures. This feature is controlled
> +	  by kernel boot param "randomize_kstack_offset=on/off", and this
> +	  config chooses the default boot state.


thanks.
-- 
~Randy

