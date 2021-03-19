Return-Path: <SRS0=ogje=IR=lists.openwall.com=kernel-hardening-return-20994-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A460FC433E3
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 18:45:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E9BE061974
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 18:45:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9BE061974
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20994-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19979 invoked by uid 550); 19 Mar 2021 18:45:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19949 invoked from network); 19 Mar 2021 18:45:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Sb8mG2TwoLcJMKUkEkVhAmXUHbnUNYxK1v1iC8KimUA=;
        b=CmUS9RcCmK5o96Fk6zyoSVLADipDZJ38jBX+VRx8vf9lsD2CgWWYfDsPUIj3QczMWR
         AaiQadC5iuMOJEZRtQ6ZIcrfB1K5dnxHEEaSckKGDMsCD0J7OswnuO4wDM0nDIwrNKLj
         2OqV6blXxkO3bm9u9mMktQ68Ql9zMUKo57h4I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Sb8mG2TwoLcJMKUkEkVhAmXUHbnUNYxK1v1iC8KimUA=;
        b=U9Q4hgpBoNgYoEkBEtvc5XxRIJvWZjtCDp7c9iGz4qm9Ps6cfI2vBjNGjBCErMCvM3
         ZSwQb3a0Nk3ksPLPbs4RIZbyBYQipdUMRhyjHl6uHTRTLJG/H6bHQDSutn6/mYGij9mm
         nT7CuMMstgG0FNSwZ1VIoxFd+MInYUV7f2jh623tPSkvQZKjtBH3QqvVMo+56g+KlXRI
         yqZ8c+A3oeLaS1oG8s3IsfSZyaZZFWj3oWfK84PGCN76q3qroVOaptMXLELj7XfWD8em
         3otnPHA9PLp451r5gebskxy/dPBme92dR+Ncg6baJ1Ak3ah+yp+f35JainPLPQ/FTmx7
         LEpA==
X-Gm-Message-State: AOAM531fjNVEbrLmOIWNnjnwbCa2uRGHLRg+8gFvMPFszTilHdYPCwM0
	hcYb3JQdgL/ArYLo3wT6xJVmmA==
X-Google-Smtp-Source: ABdhPJwxrFCu/tr6zG57P/oXPpC7+dmNq8+B1nfLURKK038KTmr5VVbtL8LNWxfd7fIU6Fty2w8R/g==
X-Received: by 2002:a17:902:d481:b029:e4:8afa:8524 with SMTP id c1-20020a170902d481b02900e48afa8524mr15809510plg.52.1616179515805;
        Fri, 19 Mar 2021 11:45:15 -0700 (PDT)
Date: Fri, 19 Mar 2021 11:45:14 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-security-module@vger.kernel.org, x86@kernel.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v30 03/12] landlock: Set up the security framework and
 manage credentials
Message-ID: <202103191140.7D1F10CBFD@keescook>
References: <20210316204252.427806-1-mic@digikod.net>
 <20210316204252.427806-4-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210316204252.427806-4-mic@digikod.net>

On Tue, Mar 16, 2021 at 09:42:43PM +0100, Mickaël Salaün wrote:
>  config LSM
>  	string "Ordered list of enabled LSMs"
> -	default "lockdown,yama,loadpin,safesetid,integrity,smack,selinux,tomoyo,apparmor,bpf" if DEFAULT_SECURITY_SMACK
> -	default "lockdown,yama,loadpin,safesetid,integrity,apparmor,selinux,smack,tomoyo,bpf" if DEFAULT_SECURITY_APPARMOR
> -	default "lockdown,yama,loadpin,safesetid,integrity,tomoyo,bpf" if DEFAULT_SECURITY_TOMOYO
> -	default "lockdown,yama,loadpin,safesetid,integrity,bpf" if DEFAULT_SECURITY_DAC
> -	default "lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor,bpf"
> +	default "landlock,lockdown,yama,loadpin,safesetid,integrity,smack,selinux,tomoyo,apparmor,bpf" if DEFAULT_SECURITY_SMACK
> +	default "landlock,lockdown,yama,loadpin,safesetid,integrity,apparmor,selinux,smack,tomoyo,bpf" if DEFAULT_SECURITY_APPARMOR
> +	default "landlock,lockdown,yama,loadpin,safesetid,integrity,tomoyo,bpf" if DEFAULT_SECURITY_TOMOYO
> +	default "landlock,lockdown,yama,loadpin,safesetid,integrity,bpf" if DEFAULT_SECURITY_DAC
> +	default "landlock,lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor,bpf"
>  	help
>  	  A comma-separated list of LSMs, in initialization order.
>  	  Any LSMs left off this list will be ignored. This can be

There was some discussion long ago about landlock needing to be last
in the list because it was unprivileged. Is that no longer true? (And
what is the justification for its position in the list?)

> diff --git a/security/landlock/common.h b/security/landlock/common.h
> new file mode 100644
> index 000000000000..5dc0fe15707d
> --- /dev/null
> +++ b/security/landlock/common.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Landlock LSM - Common constants and helpers
> + *
> + * Copyright © 2016-2020 Mickaël Salaün <mic@digikod.net>
> + * Copyright © 2018-2020 ANSSI
> + */
> +
> +#ifndef _SECURITY_LANDLOCK_COMMON_H
> +#define _SECURITY_LANDLOCK_COMMON_H
> +
> +#define LANDLOCK_NAME "landlock"
> +
> +#ifdef pr_fmt
> +#undef pr_fmt
> +#endif

When I see "#undef pr_fmt" I think there is a header ordering problem.

> [...]

Everything else looks like regular boilerplate for an LSM. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
