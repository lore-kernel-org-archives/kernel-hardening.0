Return-Path: <SRS0=ulBu=6G=lists.openwall.com=kernel-hardening-return-18599-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0950C54FCB
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Apr 2020 14:35:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 450DB206D4
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Apr 2020 14:35:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 450DB206D4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18599-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13649 invoked by uid 550); 22 Apr 2020 14:35:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13609 invoked from network); 22 Apr 2020 14:35:42 -0000
Date: Wed, 22 Apr 2020 15:35:27 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Phong Tran <tranmanphong@gmail.com>
Cc: steve.capper@arm.com, steven.price@arm.com, will@kernel.org,
	keescook@chromium.org, greg@kroah.com, akpm@linux-foundation.org,
	alexios.zavras@intel.com, broonie@kernel.org,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de
Subject: Re: [PATCH v2] arm64: add check_wx_pages debugfs for CHECK_WX
Message-ID: <20200422143526.GD54796@lakrids.cambridge.arm.com>
References: <20200307093926.27145-1-tranmanphong@gmail.com>
 <20200421173557.10817-1-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421173557.10817-1-tranmanphong@gmail.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

On Wed, Apr 22, 2020 at 12:35:58AM +0700, Phong Tran wrote:
> follow the suggestion from
> https://github.com/KSPP/linux/issues/35
> 
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> ---
> Change since v1:
> - Update the Kconfig help text
> - Don't check the return value of debugfs_create_file()
> - Tested on QEMU aarch64

As on v1, I think that this should be generic across all architectures
with CONFIG_DEBUG_WX. Adding this only on arm64 under
CONFIG_PTDUMP_DEBUGFS (which does not generally imply a WX check)
doesn't seem right.

Maybe we need a new ARCH_HAS_CHECK_WX config to make that simpler, but
that seems simple to me.

Thanks,
Marm.

> root@qemuarm64:~# zcat /proc/config.gz | grep PTDUMP
> CONFIG_GENERIC_PTDUMP=y
> CONFIG_PTDUMP_CORE=y
> CONFIG_PTDUMP_DEBUGFS=y
> root@qemuarm64:~# uname -a
> Linux qemuarm64 5.7.0-rc2-00001-g20ddb383c313 #3 SMP PREEMPT Tue Apr 21 23:18:56 +07 2020 aarch64 GNU/Linux
> root@qemuarm64:~# echo 1 > /sys/kernel/debug/check_wx_pages
> [   63.261868] Checked W+X mappings: passed, no W+X pages found
> ---
>  arch/arm64/Kconfig.debug        |  5 ++++-
>  arch/arm64/include/asm/ptdump.h |  2 ++
>  arch/arm64/mm/dump.c            |  1 +
>  arch/arm64/mm/ptdump_debugfs.c  | 18 ++++++++++++++++++
>  4 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
> index a1efa246c9ed..cd82c9d3664a 100644
> --- a/arch/arm64/Kconfig.debug
> +++ b/arch/arm64/Kconfig.debug
> @@ -48,7 +48,10 @@ config DEBUG_WX
>  	  of other unfixed kernel bugs easier.
>  
>  	  There is no runtime or memory usage effect of this option
> -	  once the kernel has booted up - it's a one time check.
> +	  once the kernel has booted up - it's a one time check at
> +	  boot, and can also be triggered at runtime by echo "1" to
> +	  "check_wx_pages". The "check_wx_pages" is available only with
> +	  CONFIG_PTDUMP_DEBUGFS is enabled.
>  
>  	  If in doubt, say "Y".
>  
> diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
> index 38187f74e089..c90a6ec6f59b 100644
> --- a/arch/arm64/include/asm/ptdump.h
> +++ b/arch/arm64/include/asm/ptdump.h
> @@ -24,9 +24,11 @@ struct ptdump_info {
>  void ptdump_walk(struct seq_file *s, struct ptdump_info *info);
>  #ifdef CONFIG_PTDUMP_DEBUGFS
>  void ptdump_debugfs_register(struct ptdump_info *info, const char *name);
> +void ptdump_check_wx_init(void);
>  #else
>  static inline void ptdump_debugfs_register(struct ptdump_info *info,
>  					   const char *name) { }
> +static inline void ptdump_check_wx_init(void) { }
>  #endif
>  void ptdump_check_wx(void);
>  #endif /* CONFIG_PTDUMP_CORE */
> diff --git a/arch/arm64/mm/dump.c b/arch/arm64/mm/dump.c
> index 860c00ec8bd3..60c99a047763 100644
> --- a/arch/arm64/mm/dump.c
> +++ b/arch/arm64/mm/dump.c
> @@ -378,6 +378,7 @@ static int ptdump_init(void)
>  #endif
>  	ptdump_initialize();
>  	ptdump_debugfs_register(&kernel_ptdump_info, "kernel_page_tables");
> +	ptdump_check_wx_init();
>  	return 0;
>  }
>  device_initcall(ptdump_init);
> diff --git a/arch/arm64/mm/ptdump_debugfs.c b/arch/arm64/mm/ptdump_debugfs.c
> index d29d722ec3ec..6b0aa16cb17b 100644
> --- a/arch/arm64/mm/ptdump_debugfs.c
> +++ b/arch/arm64/mm/ptdump_debugfs.c
> @@ -20,3 +20,21 @@ void ptdump_debugfs_register(struct ptdump_info *info, const char *name)
>  {
>  	debugfs_create_file(name, 0400, NULL, info, &ptdump_fops);
>  }
> +
> +static int check_wx_debugfs_set(void *data, u64 val)
> +{
> +	if (val != 1ULL)
> +		return -EINVAL;
> +
> +	ptdump_check_wx();
> +
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(check_wx_fops, NULL, check_wx_debugfs_set, "%llu\n");
> +
> +void ptdump_check_wx_init(void)
> +{
> +	debugfs_create_file("check_wx_pages", 0200, NULL,
> +			NULL, &check_wx_fops) ? 0 : -ENOMEM;
> +}
> -- 
> 2.20.1
> 
