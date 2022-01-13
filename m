Return-Path: <kernel-hardening-return-21533-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id D932CC433EF
	for <kernel-hardening@archiver.kernel.org>; Thu, 13 Jan 2022 21:32:27 +0000 (UTC)
Received: (qmail 19995 invoked by uid 550); 13 Jan 2022 21:32:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19952 invoked from network); 13 Jan 2022 21:32:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1642109525;
	bh=hj29mHHG1QdwbI27RwfBUvkMrE2JljtHYAxHeD3RozE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VB3VA+Q9Q4VAp//nSyPbE/D7jCUAYkDOcvI0Rtb//6OkTbwsqAd98uJG9bDOw1gio
	 SqFEabwiKBkCDf1zVVa72s5SVvndzELh2+7FQ9GxEvj5cbCZRNjtCOG/crWOT++dQz
	 9qETli9kW95feFBygDJl6gjtze6/Ybreizu6EcexeoKxfMMZZ4gzAfF4t+3BflTxTm
	 SGl/9lCLYpc546IcCur46bzoVmh2oKnGeVrBbF+FUdka4yyXwjkDHsnVQ3AT4nOG1S
	 T5C/i/Mf0YlpZLZHCxFJEDP40dBceEJe9EcMaPgnN4iCok4W8qsRiC0HDwPNAF3yGl
	 CYqMVHczJScAA==
Message-ID: <034075bd-aac5-9b97-6d09-02d9dd658a0b@kernel.org>
Date: Thu, 13 Jan 2022 13:31:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3 2/3] selftests/x86/Makefile: Support per-target $(LIBS)
 configuration
Content-Language: en-US
To: Florian Weimer <fweimer@redhat.com>
Cc: linux-arch@vger.kernel.org, Linux API <linux-api@vger.kernel.org>,
 linux-x86_64@vger.kernel.org, kernel-hardening@lists.openwall.com,
 linux-mm@kvack.org, the arch/x86 maintainers <x86@kernel.org>,
 musl@lists.openwall.com, libc-alpha@sourceware.org,
 linux-kernel@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
 Kees Cook <keescook@chromium.org>, Andrei Vagin <avagin@gmail.com>
References: <3a1c8280967b491bf6917a18fbff6c9b52e8df24.1641398395.git.fweimer@redhat.com>
 <54ae0e1f8928160c1c4120263ea21c8133aa3ec4.1641398395.git.fweimer@redhat.com>
From: Andy Lutomirski <luto@kernel.org>
In-Reply-To: <54ae0e1f8928160c1c4120263ea21c8133aa3ec4.1641398395.git.fweimer@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/5/22 08:03, Florian Weimer wrote:
> And avoid compiling PCHs by accident.
> 

The patch seems fine, but I can't make heads or tails of the $SUBJECT. 
Can you help me?

> Signed-off-by: Florian Weimer <fweimer@redhat.com>
> ---
> v3: Patch split out.
> 
>   tools/testing/selftests/x86/Makefile | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
> index 8a1f62ab3c8e..0993d12f2c38 100644
> --- a/tools/testing/selftests/x86/Makefile
> +++ b/tools/testing/selftests/x86/Makefile
> @@ -72,10 +72,12 @@ all_64: $(BINARIES_64)
>   EXTRA_CLEAN := $(BINARIES_32) $(BINARIES_64)
>   
>   $(BINARIES_32): $(OUTPUT)/%_32: %.c helpers.h
> -	$(CC) -m32 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl -lm
> +	$(CC) -m32 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $(filter-out %.h, $^) \
> +		$(or $(LIBS), -lrt -ldl -lm)
>   
>   $(BINARIES_64): $(OUTPUT)/%_64: %.c helpers.h
> -	$(CC) -m64 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl
> +	$(CC) -m64 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $(filter-out %.h, $^) \
> +		$(or $(LIBS), -lrt -ldl -lm)
>   
>   # x86_64 users should be encouraged to install 32-bit libraries
>   ifeq ($(CAN_BUILD_I386)$(CAN_BUILD_X86_64),01)

