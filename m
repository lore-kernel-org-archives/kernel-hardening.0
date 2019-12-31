Return-Path: <SRS0=gva9=2V=lists.openwall.com=kernel-hardening-return-17541-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B301C2D0C2
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Dec 2019 17:14:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B37FE206D9
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Dec 2019 17:14:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B37FE206D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=c-s.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17541-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 8160 invoked by uid 550); 31 Dec 2019 17:14:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8126 invoked from network); 31 Dec 2019 17:14:22 -0000
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Date: Tue, 31 Dec 2019 18:14:13 +0100
Message-ID: <20191231181413.Horde.DSSo7dOhVEixKzJ75Uu9ZA1@messagerie.si.c-s.fr>
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Russell Currey <ruscur@russell.cc>
Cc: kernel-hardening@lists.openwall.com, npiggin@gmail.com, dja@axtens.net,
 ajd@linux.ibm.com, mpe@ellerman.id.au, joel@jms.id.au,
 linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v6 3/5] powerpc/mm/ptdump: debugfs handler for W+X
 checks at runtime
References: <20191224055545.178462-1-ruscur@russell.cc>
 <20191224055545.178462-4-ruscur@russell.cc>
In-Reply-To: <20191224055545.178462-4-ruscur@russell.cc>
User-Agent: Internet Messaging Program (IMP) H5 (6.2.3)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Russell Currey <ruscur@russell.cc> a =C3=A9crit=C2=A0:

> Very rudimentary, just
>
> 	echo 1 > [debugfs]/check_wx_pages
>
> and check the kernel log.  Useful for testing strict module RWX.

For testing strict module RWX you could instead implement=20=20
module_arch_freeing_init()=20and call  ptdump_check_wx() from there.

Christophe

>
> Updated the Kconfig entry to reflect this.
>
> Also fixed a typo.
>
> Signed-off-by: Russell Currey <ruscur@russell.cc>
> ---
>  arch/powerpc/Kconfig.debug      |  6 ++++--
>  arch/powerpc/mm/ptdump/ptdump.c | 21 ++++++++++++++++++++-
>  2 files changed, 24 insertions(+), 3 deletions(-)
>
> diff --git a/arch/powerpc/Kconfig.debug b/arch/powerpc/Kconfig.debug
> index 4e1d39847462..7c14c9728bc0 100644
> --- a/arch/powerpc/Kconfig.debug
> +++ b/arch/powerpc/Kconfig.debug
> @@ -370,7 +370,7 @@ config PPC_PTDUMP
>  	  If you are unsure, say N.
>
>  config PPC_DEBUG_WX
> -	bool "Warn on W+X mappings at boot"
> +	bool "Warn on W+X mappings at boot & enable manual checks at runtime"
>  	depends on PPC_PTDUMP
>  	help
>  	  Generate a warning if any W+X mappings are found at boot.
> @@ -384,7 +384,9 @@ config PPC_DEBUG_WX
>  	  of other unfixed kernel bugs easier.
>
>  	  There is no runtime or memory usage effect of this option
> -	  once the kernel has booted up - it's a one time check.
> +	  once the kernel has booted up, it only automatically checks once.
> +
> +	  Enables the "check_wx_pages" debugfs entry for checking at runtime.
>
>  	  If in doubt, say "Y".
>
> diff --git a/arch/powerpc/mm/ptdump/ptdump.c=20=20
>=20b/arch/powerpc/mm/ptdump/ptdump.c
> index 2f9ddc29c535..b6cba29ae4a0 100644
> --- a/arch/powerpc/mm/ptdump/ptdump.c
> +++ b/arch/powerpc/mm/ptdump/ptdump.c
> @@ -4,7 +4,7 @@
>   *
>   * This traverses the kernel pagetables and dumps the
>   * information about the used sections of memory to
> - * /sys/kernel/debug/kernel_pagetables.
> + * /sys/kernel/debug/kernel_page_tables.
>   *
>   * Derived from the arm64 implementation:
>   * Copyright (c) 2014, The Linux Foundation, Laura Abbott.
> @@ -409,6 +409,25 @@ void ptdump_check_wx(void)
>  	else
>  		pr_info("Checked W+X mappings: passed, no W+X pages found\n");
>  }
> +
> +static int check_wx_debugfs_set(void *data, u64 val)
> +{
> +	if (val !=3D 1ULL)
> +		return -EINVAL;
> +
> +	ptdump_check_wx();
> +
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(check_wx_fops, NULL, check_wx_debugfs_set,=20=20
>=20"%llu\n");
> +
> +static int ptdump_check_wx_init(void)
> +{
> +	return debugfs_create_file("check_wx_pages", 0200, NULL,
> +				   NULL, &check_wx_fops) ? 0 : -ENOMEM;
> +}
> +device_initcall(ptdump_check_wx_init);
>  #endif
>
>  static int ptdump_init(void)
> --
> 2.24.1


