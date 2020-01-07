Return-Path: <SRS0=joPu=24=lists.openwall.com=kernel-hardening-return-17544-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE479C33C99
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jan 2020 10:49:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0BE9C2077B
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jan 2020 10:49:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="LQx8PCda"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0BE9C2077B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17544-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16263 invoked by uid 550); 7 Jan 2020 10:48:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16229 invoked from network); 7 Jan 2020 10:48:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
	s=201909; t=1578394119;
	bh=+8UDms2QJlcRJ69nfRe2grUy1TZCnrnuHpkqQ4GXUeI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=LQx8PCdar/2SnlfPjvPBj095sQXT+zPZaQ5fWbEwiIrY6+cZJ+nPTbGVpEjBODwko
	 h2AFwlYH9XCIR1E82ClgU+L58/c4i2lV4JkmhVVukt3wJeMCKAVY3aotQieKXyyvUa
	 2sbgijeF9a83WtBUCYiZutgr7IBi57zHZt1vTwVeKNc2/riUq077CdM/A9BFb0a8fO
	 yQZoRKo7z/7mh55QK8aKhEGxyFd54yOnqmaTCRgdj7gZOpTnoobk87N/rEm8BeeqnX
	 aeFIiFqoHgazkxS3fc5kWOPo4Z/tQWhNI0ryp9Ax8dSQhEdsj/g9YiG0ctYYWAVUXS
	 EbrBet0A+o4JA==
From: Michael Ellerman <mpe@ellerman.id.au>
To: Christophe Leroy <christophe.leroy@c-s.fr>, Russell Currey <ruscur@russell.cc>
Cc: kernel-hardening@lists.openwall.com, npiggin@gmail.com, dja@axtens.net, ajd@linux.ibm.com, joel@jms.id.au, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v6 3/5] powerpc/mm/ptdump: debugfs handler for W+X checks at runtime
In-Reply-To: <20191231181413.Horde.DSSo7dOhVEixKzJ75Uu9ZA1@messagerie.si.c-s.fr>
References: <20191224055545.178462-1-ruscur@russell.cc> <20191224055545.178462-4-ruscur@russell.cc> <20191231181413.Horde.DSSo7dOhVEixKzJ75Uu9ZA1@messagerie.si.c-s.fr>
Date: Tue, 07 Jan 2020 21:48:33 +1100
Message-ID: <87r20b1r0e.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Christophe Leroy <christophe.leroy@c-s.fr> writes:
> Russell Currey <ruscur@russell.cc> a =C3=A9crit=C2=A0:
>
>> Very rudimentary, just
>>
>> 	echo 1 > [debugfs]/check_wx_pages
>>
>> and check the kernel log.  Useful for testing strict module RWX.
>
> For testing strict module RWX you could instead implement=20=20
> module_arch_freeing_init() and call  ptdump_check_wx() from there.

That could get expensive on large systems, not sure if we want it
enabled by default?

cheers


>> diff --git a/arch/powerpc/Kconfig.debug b/arch/powerpc/Kconfig.debug
>> index 4e1d39847462..7c14c9728bc0 100644
>> --- a/arch/powerpc/Kconfig.debug
>> +++ b/arch/powerpc/Kconfig.debug
>> @@ -370,7 +370,7 @@ config PPC_PTDUMP
>>  	  If you are unsure, say N.
>>
>>  config PPC_DEBUG_WX
>> -	bool "Warn on W+X mappings at boot"
>> +	bool "Warn on W+X mappings at boot & enable manual checks at runtime"
>>  	depends on PPC_PTDUMP
>>  	help
>>  	  Generate a warning if any W+X mappings are found at boot.
>> @@ -384,7 +384,9 @@ config PPC_DEBUG_WX
>>  	  of other unfixed kernel bugs easier.
>>
>>  	  There is no runtime or memory usage effect of this option
>> -	  once the kernel has booted up - it's a one time check.
>> +	  once the kernel has booted up, it only automatically checks once.
>> +
>> +	  Enables the "check_wx_pages" debugfs entry for checking at runtime.
>>
>>  	  If in doubt, say "Y".
>>
>> diff --git a/arch/powerpc/mm/ptdump/ptdump.c=20=20
>> b/arch/powerpc/mm/ptdump/ptdump.c
>> index 2f9ddc29c535..b6cba29ae4a0 100644
>> --- a/arch/powerpc/mm/ptdump/ptdump.c
>> +++ b/arch/powerpc/mm/ptdump/ptdump.c
>> @@ -4,7 +4,7 @@
>>   *
>>   * This traverses the kernel pagetables and dumps the
>>   * information about the used sections of memory to
>> - * /sys/kernel/debug/kernel_pagetables.
>> + * /sys/kernel/debug/kernel_page_tables.
>>   *
>>   * Derived from the arm64 implementation:
>>   * Copyright (c) 2014, The Linux Foundation, Laura Abbott.
>> @@ -409,6 +409,25 @@ void ptdump_check_wx(void)
>>  	else
>>  		pr_info("Checked W+X mappings: passed, no W+X pages found\n");
>>  }
>> +
>> +static int check_wx_debugfs_set(void *data, u64 val)
>> +{
>> +	if (val !=3D 1ULL)
>> +		return -EINVAL;
>> +
>> +	ptdump_check_wx();
>> +
>> +	return 0;
>> +}
>> +
>> +DEFINE_SIMPLE_ATTRIBUTE(check_wx_fops, NULL, check_wx_debugfs_set,=20=20
>> "%llu\n");
>> +
>> +static int ptdump_check_wx_init(void)
>> +{
>> +	return debugfs_create_file("check_wx_pages", 0200, NULL,
>> +				   NULL, &check_wx_fops) ? 0 : -ENOMEM;
>> +}
>> +device_initcall(ptdump_check_wx_init);
>>  #endif
>>
>>  static int ptdump_init(void)
>> --
>> 2.24.1
