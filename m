Return-Path: <kernel-hardening-return-21928-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 86638C02199
	for <kernel-hardening@archiver.kernel.org>; Sun,  9 Feb 2025 03:45:43 +0000 (UTC)
Received: (qmail 24267 invoked by uid 550); 9 Feb 2025 03:45:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24244 invoked from network); 9 Feb 2025 03:45:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ethancedwards.com;
	s=MBO0001; t=1739072722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=agZpKSsd5fdzyN9OBz2BDTXHlW6w6QtZAvyhXYpYcrU=;
	b=xy12khePBAai55WERQUGDfslclILql6MXbEtnoXVKCyvjPqujf2x3RhV5bUkk/77kKQY0w
	EHEKeCYvdbIHcAMDSQkhsn5ZfWO5JPeDvHp69UJq1zEVvvcqcib7UyJfMK73p2ddzTaUh/
	MldDJBNlpMl3Z6sqAg51L9JGGh4FPdRsytWn3l9Yx28pN9YTIQikfIeflsLRe2CPDN9Zat
	EONVFUcLfvVTbZ288ysFzDlkRkLkqGDvgkGlyxwfVyRjRq02DvI4sWRamvr/TFEnG/s6Nr
	nJtadRDXeNHYcvOsuL9AL6zLuPirPBXVq+areDnTQCfzYX/P8C44vKhEb6iBhg==
Date: Sat, 8 Feb 2025 22:45:20 -0500
From: Ethan Carter Edwards <ethan@ethancedwards.com>
To: mingo@redhat.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, 
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "bsegall@google.com" <bsegall@google.com>, 
	"peterz@infradead.org" <peterz@infradead.org>
Subject: Re: [PATCH v2] sched/topology: change kzalloc to kcalloc
Message-ID: <pqhk3i5byxj3ygnh7jp3irmluykrocwdmfudfb3lm6xm3enygg@cezu6wjo3a2l>
References: <wayfdq456uccu2kzujdokp5kklbl7evp432rmnxcdh2222wwlp@67idbpxoy32u>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wayfdq456uccu2kzujdokp5kklbl7evp432rmnxcdh2222wwlp@67idbpxoy32u>
X-Rspamd-Queue-Id: 4YrDBB4k0gz9swN

I wanted to check in on this. Anything I need to change?

Thanks,
Ethan

On 25/01/19 01:23PM, Ethan Carter Edwards wrote:
> We are replacing any instances of kzalloc(size * count, ...) with
> kcalloc(count, size, ...) due to risk of overflow [1].
> 
> [1] https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
> Link: https://github.com/KSPP/linux/issues/162
> 
> Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
> ---
>  V2: fix email client formatting.
>  kernel/sched/topology.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index 9748a4c8d668..17eb12819563 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -1920,7 +1920,7 @@ void sched_init_numa(int offline_node)
>  	 */
>  	sched_domains_numa_levels = 0;
>  
> -	masks = kzalloc(sizeof(void *) * nr_levels, GFP_KERNEL);
> +	masks = kcalloc(nr_levels, sizeof(void *), GFP_KERNEL);
>  	if (!masks)
>  		return;
>  
> @@ -1929,7 +1929,7 @@ void sched_init_numa(int offline_node)
>  	 * CPUs of nodes that are that many hops away from us.
>  	 */
>  	for (i = 0; i < nr_levels; i++) {
> -		masks[i] = kzalloc(nr_node_ids * sizeof(void *), GFP_KERNEL);
> +		masks[i] = kcalloc(nr_node_ids, sizeof(void *), GFP_KERNEL);
>  		if (!masks[i])
>  			return;
>  
> -- 
> 2.47.1
> 
