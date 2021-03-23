Return-Path: <SRS0=EmPl=IV=lists.openwall.com=kernel-hardening-return-21032-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B1AC433C1
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Mar 2021 00:14:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E3CAC619AA
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Mar 2021 00:14:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E3CAC619AA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21032-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1294 invoked by uid 550); 23 Mar 2021 00:14:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1274 invoked from network); 23 Mar 2021 00:14:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0Zv/Nh1NwdjT4vNoEgAKJF0+3Ir6H8KTDS01ZyTPf3o=;
        b=MYfMpOlaWILZRe1pDeuZweAI3vdknsgeo67laT+dKd7DkSPJ3kqkICjvz6DoYVVnHZ
         16OeAVHxuQfaEw3tjPMoe7QoNfBgXwLH10I06HQvLQrqH5L2JNBJAwiEQ2JR4BIEX+9S
         mKRD0C7UQTjhxOy/6H8fA1YjCpW2EGV+O/1qAjuqnz/pmrLszTPkOjvS0yYpv/ZZ/qEF
         lAjiGv9YsocO9v0uFbeqK3kItyVLmzZ8XbFjbvISEZUv72q4Dv/aYT92AgSreyZJuLpZ
         d2c1Ghef/K4UviwHxjZHI5pznTsVIQq7ZchuSPAoEZC7/qFfjBKUTKzfd7IBKdOJs9LE
         ySlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0Zv/Nh1NwdjT4vNoEgAKJF0+3Ir6H8KTDS01ZyTPf3o=;
        b=gf7UUwFk6pjGC+LxXLIKHhe6RncC1r8/2v/IFR6QbNZ5FukwCfQU5ehw/1jWA1/qTM
         TsCwKAMIvdJ/BoTsbo08FEBTcjESna0y4wz6CRdRVlgxjnqhhMgdW9hmyjeXWZR0oXEf
         KTAjFnaIDUuiUkAvIx19Q93Q052VZA1b8TSCdo0oDjiRtENNMKI134a/yJNFxk1CM+Tn
         njRf2PoeR0U5yFUdk69nKnW8iPB4nYjqo2suwlh6mXE4q1DQKO0pirAbPfIWm8M6Mnsp
         Iv5cwQp3Ip2pRRA882cIRWowueaQU8VdgC7/2AMI/QKdrH+0fHmPyjR9I1yhZMXPWFWm
         PP0A==
X-Gm-Message-State: AOAM532xrp4Fh+Gy3uFvjpT6tGyhSwoP118yONOtoNRwAHmraNF98S4N
	3IE3ddaQpzPkYhw0Af+jUj4TQTjf/YiDJCDc43i6wQ==
X-Google-Smtp-Source: ABdhPJywL/8xL+s/Wz9PYQqACsNKJlIixpOZzrkkMLprtEmtD0taXBt0RZSmBTlrPE/s8ZHyKoeWgqn3ctd+1W/a4Oo=
X-Received: by 2002:a2e:9bcd:: with SMTP id w13mr1219196ljj.43.1616458434230;
 Mon, 22 Mar 2021 17:13:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210316204252.427806-1-mic@digikod.net> <20210316204252.427806-3-mic@digikod.net>
In-Reply-To: <20210316204252.427806-3-mic@digikod.net>
From: Jann Horn <jannh@google.com>
Date: Tue, 23 Mar 2021 01:13:27 +0100
Message-ID: <CAG48ez3v44du6_qVLa25SOdfLsr5+z-=a0pUP63d=qHP2tf4Pg@mail.gmail.com>
Subject: Re: [PATCH v30 02/12] landlock: Add ruleset and domain management
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@amacapital.net>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, 
	David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>, 
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, 
	Michael Kerrisk <mtk.manpages@gmail.com>, Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>, 
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	kernel list <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 16, 2021 at 9:43 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
> A Landlock ruleset is mainly a red-black tree with Landlock rules as
> nodes.  This enables quick update and lookup to match a requested
> access, e.g. to a file.  A ruleset is usable through a dedicated file
> descriptor (cf. following commit implementing syscalls) which enables a
> process to create and populate a ruleset with new rules.
>
> A domain is a ruleset tied to a set of processes.  This group of rules
> defines the security policy enforced on these processes and their future
> children.  A domain can transition to a new domain which is the
> intersection of all its constraints and those of a ruleset provided by
> the current process.  This modification only impact the current process.
> This means that a process can only gain more constraints (i.e. lose
> accesses) over time.
>
> Cc: James Morris <jmorris@namei.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> Link: https://lore.kernel.org/r/20210316204252.427806-3-mic@digikod.net

Reviewed-by: Jann Horn <jannh@google.com>
