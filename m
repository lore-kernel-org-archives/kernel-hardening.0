Return-Path: <SRS0=Ay7n=VD=lists.openwall.com=kernel-hardening-return-16368-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	GAPPY_SUBJECT,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5435C0650E
	for <kernel-hardening@archiver.kernel.org>; Sat,  6 Jul 2019 15:39:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2571C20838
	for <kernel-hardening@archiver.kernel.org>; Sat,  6 Jul 2019 15:39:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zk1xeLOy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2571C20838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16368-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29920 invoked by uid 550); 6 Jul 2019 15:39:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29882 invoked from network); 6 Jul 2019 15:39:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=7TQwAzn0J5EXLc+BbiWf8v/R95Wdjh5+dxrOc78SyBQ=; b=zk1xeLOyXqj8CUdxCMPGb5v4O6
	7hsXykVY8BfzjRyGPWIiYyGMnVxn3mN2H9t48yfsDQr2b0t2KsCupiuMaoV3qjEeKnUyIetD1fE5E
	1Ku0V7rf+tU/MCbArHAkSOmlGc/Zj0/pjuIp/N7qSWFohv/1Pkif4/dN2NQDN2MymGp3euW92NUIA
	Mc7fJimKvdws8bLQFAm3bwYo9fNSCQAO+C59n98FSTLsk4D/TjJWDbVVoGYXBWP/337wSBHKhUnQL
	3AFwOHHBGkPtXaEz8acl3Bi2LmaUZZCeImDaFYoBAUz0uGii+Nb43uWaZlXeqb7euZPHBZ9uKr4+7
	n448kLpw==;
Subject: Re: [PATCH v5 06/12] S.A.R.A.: WX protection
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>, linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Brad Spengler <spender@grsecurity.net>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Christoph Hellwig <hch@infradead.org>,
 James Morris <james.l.morris@oracle.com>, Jann Horn <jannh@google.com>,
 Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>,
 "Serge E. Hallyn" <serge@hallyn.com>, Thomas Gleixner <tglx@linutronix.de>
References: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com>
 <1562410493-8661-7-git-send-email-s.mesoraca16@gmail.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <fcbf55e9-78dc-fb1a-e893-4fea8ebdc202@infradead.org>
Date: Sat, 6 Jul 2019 08:38:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562410493-8661-7-git-send-email-s.mesoraca16@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 7/6/19 3:54 AM, Salvatore Mesoraca wrote:
> diff --git a/security/sara/Kconfig b/security/sara/Kconfig
> index b98cf27..54a96e0 100644
> --- a/security/sara/Kconfig
> +++ b/security/sara/Kconfig
> @@ -60,3 +60,77 @@ config SECURITY_SARA_NO_RUNTIME_ENABLE
>  
>  	  If unsure, answer Y.
>  
> +config SECURITY_SARA_WXPROT
> +	bool "WX Protection: W^X and W!->X protections"
> +	depends on SECURITY_SARA
> +	default y
> +	help
> +	  WX Protection aims to improve user-space programs security by applying:
> +	    - W^X memory restriction
> +	    - W!->X (once writable never executable) mprotect restriction
> +	    - Executable MMAP prevention
> +	  See Documentation/admin-guide/LSM/SARA.rst. for further information.

	                                        .rst for further information.

> +
> +	  If unsure, answer Y.
> +
> +choice
> +	prompt "Default action for W^X and W!->X protections"
> +	depends on SECURITY_SARA
> +	depends on SECURITY_SARA_WXPROT
> +	default SECURITY_SARA_WXPROT_DEFAULT_FLAGS_ALL_COMPLAIN_VERBOSE
> +
> +        help

Use tab instead of spaces for indentation above.

> +	  Choose the default behaviour of WX Protection when no config
> +	  rule matches or no rule is loaded.
> +	  For further information on available flags and their meaning
> +	  see Documentation/admin-guide/LSM/SARA.rst.
> +
> +	config SECURITY_SARA_WXPROT_DEFAULT_FLAGS_ALL_COMPLAIN_VERBOSE
> +		bool "Protections enabled but not enforced."
> +		help
> +		  All features enabled except "Executable MMAP prevention",
> +		  verbose reporting, but no actual enforce: it just complains.
> +		  Its numeric value is 0x3f, for more information see
> +		  Documentation/admin-guide/LSM/SARA.rst.
> +
> +        config SECURITY_SARA_WXPROT_DEFAULT_FLAGS_ALL_ENFORCE_VERBOSE
> +		bool "Full protection, verbose."
> +		help
> +		  All features enabled except "Executable MMAP prevention".
> +		  The enabled features will be enforced with verbose reporting.
> +		  Its numeric value is 0x2f, for more information see
> +		  Documentation/admin-guide/LSM/SARA.rst.
> +
> +        config SECURITY_SARA_WXPROT_DEFAULT_FLAGS_ALL_ENFORCE
> +		bool "Full protection, quiet."
> +		help
> +		  All features enabled except "Executable MMAP prevention".
> +		  The enabled features will be enforced quietly.
> +		  Its numeric value is 0xf, for more information see
> +		  Documentation/admin-guide/LSM/SARA.rst.
> +
> +	config SECURITY_SARA_WXPROT_DEFAULT_FLAGS_NONE
> +		bool "No protection at all."
> +		help
> +		  All features disabled.
> +		  Its numeric value is 0, for more information see
> +		  Documentation/admin-guide/LSM/SARA.rst.
> +endchoice
> +
> +config SECURITY_SARA_WXPROT_DISABLED
> +	bool "WX protection will be disabled at boot."
> +	depends on SECURITY_SARA_WXPROT
> +	default n

Omit "default n" please.

> +	help
> +	  If you say Y here WX protection won't be enabled at startup. You can
> +	  override this option via user-space utilities or at boot time via
> +	  "sara.wxprot_enabled=[0|1]" kernel parameter.
> +
> +	  If unsure, answer N.
> +
> +config SECURITY_SARA_WXPROT_DEFAULT_FLAGS
> +	hex
> +	default "0x3f" if SECURITY_SARA_WXPROT_DEFAULT_FLAGS_ALL_COMPLAIN_VERBOSE
> +	default "0x2f" if SECURITY_SARA_WXPROT_DEFAULT_FLAGS_ALL_ENFORCE_VERBOSE
> +	default "0xf" if SECURITY_SARA_WXPROT_DEFAULT_FLAGS_ALL_ENFORCE
> +	default "0" if SECURITY_SARA_WXPROT_DEFAULT_FLAGS_NONE


-- 
~Randy
