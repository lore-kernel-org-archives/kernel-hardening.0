Return-Path: <SRS0=JikI=AS=lists.openwall.com=kernel-hardening-return-19242-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97352C433DF
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jul 2020 20:12:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E703E206BE
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jul 2020 20:12:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yoQ6HpvM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E703E206BE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19242-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21606 invoked by uid 550); 7 Jul 2020 20:12:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21571 invoked from network); 7 Jul 2020 20:12:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=B/o5Uj7bv1uKmlSBwdGS6cD2I4R/nsJYtW8ks3eYCiY=; b=yoQ6HpvMh/27T/sXK71yFTTfje
	wz1bO443OdeoeMKq6jb+govoxFts4nlmoEYVMaUMslznkdIIVdHi4593t91yqrOxUYEiJU0QgYJop
	HqXF3TwlrPyLRSzUITc+u6bPEDTSJLmRyIcHci7+5iPz+lH5G/rAxSfh/KEwsyO/LIpP67tsYzMsR
	5/eNbab17s5Yi3XneR2K88y+YYj3l9JAmgUSGZatk/lEmJpwujMJoecbtyfSmt9GeLIBW0MPq89QB
	4Hvx5tEcJ7jvnTmtr7DjjuryhIZS/8xGA9wV0M2WORXS8s4w7B9cifC/ERNsr8MJuujfNiYuTlJSL
	KBfyLNdw==;
Subject: Re: [PATCH v19 07/12] landlock: Support filesystem access-control
To: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
 linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
 Jeff Dike <jdike@addtoit.com>, Jonathan Corbet <corbet@lwn.net>,
 Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
 Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>,
 Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-security-module@vger.kernel.org, x86@kernel.org
References: <20200707180955.53024-1-mic@digikod.net>
 <20200707180955.53024-8-mic@digikod.net>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <6a80b712-a7b9-7b47-083a-08b7769016f8@infradead.org>
Date: Tue, 7 Jul 2020 13:11:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200707180955.53024-8-mic@digikod.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit

Hi--

On 7/7/20 11:09 AM, Mickaël Salaün wrote:
> ---
>  arch/Kconfig                  |   7 +
>  arch/um/Kconfig               |   1 +
>  include/uapi/linux/landlock.h |  78 +++++
>  security/landlock/Kconfig     |   2 +-
>  security/landlock/Makefile    |   2 +-
>  security/landlock/fs.c        | 609 ++++++++++++++++++++++++++++++++++
>  security/landlock/fs.h        |  60 ++++
>  security/landlock/setup.c     |   7 +
>  security/landlock/setup.h     |   2 +
>  9 files changed, 766 insertions(+), 2 deletions(-)
>  create mode 100644 include/uapi/linux/landlock.h
>  create mode 100644 security/landlock/fs.c
>  create mode 100644 security/landlock/fs.h
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 8cc35dc556c7..483b7476ac69 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -845,6 +845,13 @@ config COMPAT_32BIT_TIME
>  config ARCH_NO_PREEMPT
>  	bool
>  
> +config ARCH_EPHEMERAL_STATES
> +	def_bool n
> +	help
> +	  An arch should select this symbol if it do not keep an internal kernel

	                                       it does not

> +	  state for kernel objects such as inodes, but instead rely on something

	                                               instead relies on

> +	  else (e.g. the host kernel for an UML kernel).
> +
>  config ARCH_SUPPORTS_RT
>  	bool
>  

thanks.
-- 
~Randy

