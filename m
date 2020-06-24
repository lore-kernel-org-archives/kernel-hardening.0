Return-Path: <SRS0=M9a8=AF=lists.openwall.com=kernel-hardening-return-19107-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14FEC433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 15:50:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 271462065F
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 15:50:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 271462065F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rjwysocki.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19107-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32031 invoked by uid 550); 24 Jun 2020 15:50:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31999 invoked from network); 24 Jun 2020 15:50:13 -0000
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jason Yan <yanaijie@huawei.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] ACPI: Eliminate usage of uninitialized_var() macro
Date: Wed, 24 Jun 2020 17:49:59 +0200
Message-ID: <2128012.4yIOnhsQJz@kreacher>
In-Reply-To: <20200615040047.3535543-1-yanaijie@huawei.com>
References: <20200615040047.3535543-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday, June 15, 2020 6:00:47 AM CEST Jason Yan wrote:
> This is an effort to eliminate the uninitialized_var() macro[1].
> 
> The use of this macro is the wrong solution because it forces off ANY
> analysis by the compiler for a given variable. It even masks "unused
> variable" warnings.
> 
> Quoted from Linus[2]:
> 
> "It's a horrible thing to use, in that it adds extra cruft to the
> source code, and then shuts up a compiler warning (even the _reliable_
> warnings from gcc)."
> 
> The gcc option "-Wmaybe-uninitialized" has been disabled and this change
> will not produce any warnnings even with "make W=1".
> 
> [1] https://github.com/KSPP/linux/issues/81
> [2] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
> 
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>  drivers/acpi/acpi_pad.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
> index e7dc0133f817..6cc4c92d9ff9 100644
> --- a/drivers/acpi/acpi_pad.c
> +++ b/drivers/acpi/acpi_pad.c
> @@ -88,7 +88,7 @@ static void round_robin_cpu(unsigned int tsk_index)
>  	cpumask_var_t tmp;
>  	int cpu;
>  	unsigned long min_weight = -1;
> -	unsigned long uninitialized_var(preferred_cpu);
> +	unsigned long preferred_cpu;
>  
>  	if (!alloc_cpumask_var(&tmp, GFP_KERNEL))
>  		return;
> 

Applied as 5.9 material, thanks!




