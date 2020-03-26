Return-Path: <SRS0=jOn1=5L=lists.openwall.com=kernel-hardening-return-18247-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA4AC43331
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Mar 2020 23:54:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E83DF20714
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Mar 2020 23:54:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dK4sZYvD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E83DF20714
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18247-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22179 invoked by uid 550); 26 Mar 2020 23:54:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22145 invoked from network); 26 Mar 2020 23:54:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
	Subject:Sender:Reply-To:Content-ID:Content-Description;
	bh=aynR0UVS1u6v72AstwmjORHZT9G2O0P+jTJ7R4PmUNo=; b=dK4sZYvDkNLevoDdXkS4/oyhiU
	F8qajT/Y0c1KSxptgyjGLpiU8BSyPOG7u9i0XBd9reLVgCeE/oNACNqF3+f7tBcl05BU7hhD2fBmn
	U9Y4h1hg5yBKmahrnpRMQZllYKE2dPj3pIfr7SBvecMZmhRnfhnCe/pM6fj0AFHXwoJ4QFQGoe79A
	BpWBgGgxt5fo0OXTHk9ISPwAK9hSkXMzQJUBSk/UxFuVuZNXRUeD1Hnbi8dboIKKVcDZEs52xgv0r
	G5TpVblEuGgkKr674wrV7JQKEJ3UxccIoCcGhDsq7B31oHmLUUwS57DffTYS2oRlInV7M9Q51DbId
	MhvsvZ4w==;
Subject: Re: [PATCH v15 09/10] samples/landlock: Add a sandbox manager example
To: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
 linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>,
 Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
 Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
 "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-security-module@vger.kernel.org, x86@kernel.org
References: <20200326202731.693608-1-mic@digikod.net>
 <20200326202731.693608-10-mic@digikod.net>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <11634607-2fdb-1868-03d0-94096763766f@infradead.org>
Date: Thu, 26 Mar 2020 16:54:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326202731.693608-10-mic@digikod.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit

Hi,

On 3/26/20 1:27 PM, Mickaël Salaün wrote:
> diff --git a/samples/Kconfig b/samples/Kconfig
> index 9d236c346de5..b54408c5bd86 100644
> --- a/samples/Kconfig
> +++ b/samples/Kconfig
> @@ -120,6 +120,13 @@ config SAMPLE_HIDRAW
>  	bool "hidraw sample"
>  	depends on HEADERS_INSTALL
>  
> +config SAMPLE_LANDLOCK
> +	bool "Build Landlock sample code"
> +	select HEADERS_INSTALL

I think that this should be like all of the other users of HEADERS_INSTALL
and depend on that instead of select-ing it.

> +	help
> +	  Build a simple Landlock sandbox manager able to launch a process
> +	  restricted by a user-defined filesystem access-control security policy.
> +
>  config SAMPLE_PIDFD
>  	bool "pidfd sample"
>  	depends on HEADERS_INSTALL

thanks.
-- 
~Randy

