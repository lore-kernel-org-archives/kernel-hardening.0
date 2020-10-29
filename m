Return-Path: <SRS0=3zIb=EE=lists.openwall.com=kernel-hardening-return-20302-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E45C4363A
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Oct 2020 01:08:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F049920714
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Oct 2020 01:07:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MTIV5nTA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F049920714
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20302-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9426 invoked by uid 550); 29 Oct 2020 01:07:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9393 invoked from network); 29 Oct 2020 01:07:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JHdZPPn9wLM8C261Oo5ewV1obQFhVZ5ZdtkoajBWV64=;
        b=MTIV5nTARTLRBj0lxrRgSzGzRPYNAiPZWMkB9ep/3PqQq96Sbvp39GhCCvD9P7C/9G
         jSa0WHMFFRSKIlGXwo17x9mJaZSXNA2WyNRoeARNazqPz6DjPLBNsihFZKJM4DFVZ/CQ
         j3PNJYC6TnyMC9tXn4jy59H788ukVUiTCREIlCJtFaO+tL4gtg47eg+1qCzJX2qAaGf0
         OGl7m75eU0hiHajz8+lj34XqRRj/KyofTQfSSo0wWrl+kguZAe7y41ED4NaXCYy9qrEK
         VBXAJUcNjw8AKl3YDslsCgKie01Tu2Qs1ciqvcEbb3HuzunIQUzDI9drOA7XrORLRfmD
         yjSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JHdZPPn9wLM8C261Oo5ewV1obQFhVZ5ZdtkoajBWV64=;
        b=iCw5z6FWihUPGuNBwjbtNaGy0k+kHI87REpnxYU4aQBs7HzB4tO9BHzHMM/E3wGHoy
         lz5DFqyf+5EUyrXNvL9ew5bF8Px8+qzI0uHyC3auKyNmEqJuS5hqyVNmaKIYae8gB0M7
         xCrutOJaxwtVPM6WdXF09pWqtFZ0ZXtQi3g4Jdjs9GhiNySBiE7garSPMO1zCku8t+S3
         rVdgrsVoSiTLOuqTOnYNk4DkwdcqDPNGt0g/Pf6vIEZey9RAOqyVMCti9dINuYjdAmRB
         eSjjw273BIL8cIr7/HCqkmB0xsO+Btnn8uJuss67rQ2w6lJef+klZ2cjzSlDVZGP/BQ2
         pgrA==
X-Gm-Message-State: AOAM5339AruTEpt/6RrtEQV0baeziV6QOTTtO+7vWtgyLXKW6AUp9LfX
	5X444gnFg6BRDcnaAL1DkbuTLulwE2qQaMTAL1DRfw==
X-Google-Smtp-Source: ABdhPJxZF2osDmUJJYFjNdSuFzFlSzMFSQ07MX9iBFABKWDfUCx38EmD5usneiPJrsJhn41DKD8OlPb4Di5oSfLsrWI=
X-Received: by 2002:a2e:8816:: with SMTP id x22mr663617ljh.377.1603933658573;
 Wed, 28 Oct 2020 18:07:38 -0700 (PDT)
MIME-Version: 1.0
References: <20201027200358.557003-1-mic@digikod.net> <20201027200358.557003-13-mic@digikod.net>
In-Reply-To: <20201027200358.557003-13-mic@digikod.net>
From: Jann Horn <jannh@google.com>
Date: Thu, 29 Oct 2020 02:07:11 +0100
Message-ID: <CAG48ez07p+BtCRo4D75S3xsr76Kj_9Aipv3pBHsc4zyNjEiEmQ@mail.gmail.com>
Subject: Re: [PATCH v22 12/12] landlock: Add user and kernel documentation
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
> This documentation can be built with the Sphinx framework.
>
> Cc: James Morris <jmorris@namei.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Serge E. Hallyn <serge@hallyn.com>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
> Reviewed-by: Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>
[...]
> diff --git a/Documentation/userspace-api/landlock.rst b/Documentation/use=
rspace-api/landlock.rst
[...]
> +Landlock rules
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +A Landlock rule enables to describe an action on an object.  An object i=
s

s/enables to describe/describes/

> +currently a file hierarchy, and the related filesystem actions are defin=
ed in
> +`Access rights`_.  A set of rules is aggregated in a ruleset, which can =
then
> +restrict the thread enforcing it, and its future children.
> +
> +Defining and enforcing a security policy
> +----------------------------------------
> +
> +We first need to create the ruleset that will contain our rules.  For th=
is
> +example, the ruleset will contain rules which only allow read actions, b=
ut
> +write actions will be denied.  The ruleset then needs to handle both of =
these
> +kind of actions.  To have a backward compatibility, these actions should=
 be
> +ANDed with the supported ones.

This sounds as if there is a way for userspace to discover which
actions are supported by the running kernel; but we don't have
anything like that, right?

If we want to make that possible, we could maybe change
sys_landlock_create_ruleset() so that if
ruleset_attr.handled_access_fs contains bits we don't know, we clear
those bits and then copy the struct back to userspace? And then
userspace can retry the syscall with the cleared bits? Or something
along those lines?

[...]
> +We can now add a new rule to this ruleset thanks to the returned file
> +descriptor referring to this ruleset.  The rule will only enable to read=
 the

s/enable to read/allow reading/

> +file hierarchy ``/usr``.  Without another rule, write actions would then=
 be
> +denied by the ruleset.  To add ``/usr`` to the ruleset, we open it with =
the
> +``O_PATH`` flag and fill the &struct landlock_path_beneath_attr with thi=
s file
> +descriptor.
[...]
> +Inheritance
> +-----------
> +
> +Every new thread resulting from a :manpage:`clone(2)` inherits Landlock =
domain
> +restrictions from its parent.  This is similar to the seccomp inheritanc=
e (cf.
> +:doc:`/userspace-api/seccomp_filter`) or any other LSM dealing with task=
's
> +:manpage:`credentials(7)`.  For instance, one process's thread may apply
> +Landlock rules to itself, but they will not be automatically applied to =
other
> +sibling threads (unlike POSIX thread credential changes, cf.
> +:manpage:`nptl(7)`).
> +
> +When a thread sandbox itself, we have the grantee that the related secur=
ity

s/sandbox/sandboxes/
s/grantee/guarantee/

> +policy will stay enforced on all this thread's descendants.  This enable=
s to
> +create standalone and modular security policies per application, which w=
ill

s/enables to create/allows creating/


> +automatically be composed between themselves according to their runtime =
parent
> +policies.
