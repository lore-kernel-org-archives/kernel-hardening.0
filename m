Return-Path: <SRS0=Fo8R=EE=lists.openwall.com=kernel-hardening-return-20298-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B1DC388F7
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Oct 2020 01:07:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E90AE20790
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Oct 2020 01:07:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CQS/TTCS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E90AE20790
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20298-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1593 invoked by uid 550); 29 Oct 2020 01:06:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1522 invoked from network); 29 Oct 2020 01:06:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pn1ECaKgjWXcAj9IGY9xa/P/urhrG9XYha2Ze81haPI=;
        b=CQS/TTCSV/PXnE8RKTiVdoB9MOH5R7RwtttysBDMDTrgm/gdARB43BDZ0IDwXRbttP
         ztHZD+0ZqXCLCfwhTBFjTJ/tiDFdE5MfzqiqiGCR+7qo4iT6gbpszW4gnmqQCqcjiJpS
         2TE6AWWOiPiIHtCacy+jotlH1GyWUK1IMX8yXc8Mz7No8vs/C8JnIaRhweaK8oe5/GL8
         Jfgwtgs4gp/wo+Iw7O3nmUyVGt/oQ9DoZH/ghQZ47kjp3G1BZkOXJfz4E7+ioxLBPKqf
         wNABOnStf+0wcuigg1mHsL0KxMLpB2iVoTZoknuLmehB39wLMOwYtSz1o0w4ntAQ9dSd
         hmXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pn1ECaKgjWXcAj9IGY9xa/P/urhrG9XYha2Ze81haPI=;
        b=IiFAp1Y0J4v0qxKfvtea7YWPCoe18nCFIOWQvKuDFzKhxZ4k55/S1yWPiFxj6dDyK1
         XIklBnvUiHnzLmY2GbLJp4kaB51WA3nG3peQPyX1NzFQWstOIizy8aRGYE9iNxriylgb
         6g5I5+5XX3dIvKCT/848jj4GFY++BlParKwOXavxJgJlREMDSQ7DOJE2u9ULku4Y+L/Y
         R/ytfICGyYWTd1S5pFlVxFm/OvLXYYEVEGnJ7HSdbc8+2m+snQ5VcWxVBzpOWJ+SR9El
         1LMkRWL74LcEhWS6clDVVaRXiCMF4SzZgZAnIW+2Mg56ZPmEpHwswB57aFjmimuCeJGF
         b4RA==
X-Gm-Message-State: AOAM533lZYAVU83I2kUYMv6v4aPFi122F7SfKGT6CtCiNtM+Cj76IDyd
	Z/NGLrxqxIv9BMmE7C/DHtoM4vdYh2u6WsESCgl5aQ==
X-Google-Smtp-Source: ABdhPJxixA+XOTBfZ3BYWY3Zb24muHdDJFJXA6IB2XijLR/mZHkSGkBIOx58SM+pLP1LMZ2g2O7vRP785516kejacuI=
X-Received: by 2002:a19:e308:: with SMTP id a8mr562788lfh.573.1603933593718;
 Wed, 28 Oct 2020 18:06:33 -0700 (PDT)
MIME-Version: 1.0
References: <20201027200358.557003-1-mic@digikod.net> <20201027200358.557003-5-mic@digikod.net>
In-Reply-To: <20201027200358.557003-5-mic@digikod.net>
From: Jann Horn <jannh@google.com>
Date: Thu, 29 Oct 2020 02:06:06 +0100
Message-ID: <CAG48ez1W2sHBeL4pV4QqUonUJc-snNnxE_jh8FVP=pyhhm0fdg@mail.gmail.com>
Subject: Re: [PATCH v22 04/12] landlock: Add ptrace restrictions
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Jeff Dike <jdike@addtoit.com>, 
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

On Tue, Oct 27, 2020 at 9:04 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
> Using ptrace(2) and related debug features on a target process can lead
> to a privilege escalation.  Indeed, ptrace(2) can be used by an attacker
> to impersonate another task and to remain undetected while performing
> malicious activities.  Thanks to  ptrace_may_access(), various part of
> the kernel can check if a tracer is more privileged than a tracee.
>
> A landlocked process has fewer privileges than a non-landlocked process
> and must then be subject to additional restrictions when manipulating
> processes. To be allowed to use ptrace(2) and related syscalls on a
> target process, a landlocked process must have a subset of the target
> process's rules (i.e. the tracee must be in a sub-domain of the tracer).
>
> Cc: James Morris <jmorris@namei.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Serge E. Hallyn <serge@hallyn.com>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>

Reviewed-by: Jann Horn <jannh@google.com>
