Return-Path: <SRS0=e5Lt=2U=lists.openwall.com=kernel-hardening-return-17540-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D07C2D0C3
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Dec 2019 22:03:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 207BC206DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Dec 2019 22:03:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nEQfUB9B"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 207BC206DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17540-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3566 invoked by uid 550); 30 Dec 2019 22:03:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3543 invoked from network); 30 Dec 2019 22:03:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=sWcIwqwAQVaMiL6AbIBVoLXwMM9wjsoCuHsXRphgo8Y=;
        b=nEQfUB9BU7XTfjYvCMI6Yd/qByThVkk2PiHeRSy9HqRXeXx/ACLKilBsXAOBcCROWX
         wuYYWc18pechAi8K+EkPH15KMlWyQ6nb0StYh3i01u248ouxra+l0YzVMzSbAIdPpj32
         8IklPGgLy/ca2jvIWXCX+wjrXBcw+YhdM6dG2drTzpt9BJH4W/VMrXUHA7PFo1I1D0fp
         bV/2HKq3EUqlQLAmrkiIYXp5l16qLryAJoIvQkBet0s7dkrKl35d2kNDuDe+cTkV6CtO
         pdBNwQkWVWBXVmtsGPAeYKEJ7QDU9Bg9dcnJKVDvMxCHqk2OAX0edZ0X4oodFaH8Hq0U
         10lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=sWcIwqwAQVaMiL6AbIBVoLXwMM9wjsoCuHsXRphgo8Y=;
        b=SJuU/KGRQlGhUWSa0HH9VpzSGCJW4Z0a98q/x/UrUxwMD5vv92SEivHcAGr0EIuTgw
         jDf23R/I+ShmCMgLJJER0DlmtE4y4VvPz30tqAs9xq7uNZixk6EOLFJrI5DtLMJvJwia
         EAEqypoNGdG0GL2WtJnbmP01Gpi7rJEory7/zPexAHCf59Rxqosspr6XtqdqI1o23QDD
         ljOGozjoEQDk2DIGxu3IEfqj1KyvGO1u/N9ZAHIWfWXIsDM0MhOmczxPY+IOu8jnw4vt
         6GslmynW+1HVFoZx3mUQzUK/+oyLkHJztMXDYd3iMif6/YDKhM8nj1xjd54MiejfHJFR
         Ky8w==
X-Gm-Message-State: APjAAAXTcekcpDqYvaVjuQRFlrqKX8b4k0WbP5AmqTh2QZpu3ZOFymgH
	uaC34S5uIAssq/YUmJywmGU=
X-Google-Smtp-Source: APXvYqzCT9zC3ZgKpQpD5zdYtsdEacKle/p/witN0yVp/CLOmZS4R1vbOaH6CIUVFPPMG9wX2sUhEg==
X-Received: by 2002:a17:90a:1696:: with SMTP id o22mr1776310pja.78.1577743416953;
        Mon, 30 Dec 2019 14:03:36 -0800 (PST)
Subject: Re: [PATCH v6 07/10] proc: flush task dcache entries from all procfs
 instances
To: Alexey Gladkov <gladkov.alexey@gmail.com>,
 LKML <linux-kernel@vger.kernel.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux API <linux-api@vger.kernel.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 Linux Security Module <linux-security-module@vger.kernel.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Alexey Dobriyan <adobriyan@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski
 <luto@kernel.org>, Daniel Micay <danielmicay@gmail.com>,
 Djalal Harouni <tixxdz@gmail.com>, "Dmitry V . Levin" <ldv@altlinux.org>,
 "Eric W . Biederman" <ebiederm@xmission.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ingo Molnar <mingo@kernel.org>, "J . Bruce Fields" <bfields@fieldses.org>,
 Jeff Layton <jlayton@poochiereds.net>, Jonathan Corbet <corbet@lwn.net>,
 Kees Cook <keescook@chromium.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Oleg Nesterov <oleg@redhat.com>, Solar Designer <solar@openwall.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>
References: <20191225125151.1950142-1-gladkov.alexey@gmail.com>
 <20191225125151.1950142-8-gladkov.alexey@gmail.com>
From: J Freyensee <why2jjj.linux@gmail.com>
Message-ID: <8d85ba43-0759-358e-137d-246107bac747@gmail.com>
Date: Mon, 30 Dec 2019 14:03:29 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191225125151.1950142-8-gladkov.alexey@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US

snip

.

.

.

>   
> +#ifdef CONFIG_PROC_FS
> +static inline void pidns_proc_lock(struct pid_namespace *pid_ns)
> +{
> +	down_write(&pid_ns->rw_proc_mounts);
> +}
> +
> +static inline void pidns_proc_unlock(struct pid_namespace *pid_ns)
> +{
> +	up_write(&pid_ns->rw_proc_mounts);
> +}
> +
> +static inline void pidns_proc_lock_shared(struct pid_namespace *pid_ns)
> +{
> +	down_read(&pid_ns->rw_proc_mounts);
> +}
> +
> +static inline void pidns_proc_unlock_shared(struct pid_namespace *pid_ns)
> +{
> +	up_read(&pid_ns->rw_proc_mounts);
> +}
> +#else /* !CONFIG_PROC_FS */
> +
Apologies for my newbie question. I couldn't help but notice all these 
function calls are assuming that the parameter struct pid_namespace 
*pid_ns will never be NULL.  Is that a good assumption?

I don't have the background in this code to answer on my own, but I 
thought I'd raise the question.

Thanks,
Jay

