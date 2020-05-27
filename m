Return-Path: <SRS0=P3Nt=7J=lists.openwall.com=kernel-hardening-return-18891-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 267A6C433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 May 2020 09:59:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 74BAE2088E
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 May 2020 09:59:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ecfBllBP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 74BAE2088E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18891-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14172 invoked by uid 550); 27 May 2020 09:59:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3345 invoked from network); 27 May 2020 03:07:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NoLQZ4xLsmiigYDKwkyKj0BqR8pGmA2XjKXfyOFiOGQ=;
        b=ecfBllBPvCa8XsDJLnfADTkGN6+8/grXE/wm7/P7v6KQSOnpvILfr+A6G3RD8gSt1V
         bcG0w7NqoMDFPFyROpM8wFf1TYhiaV8A/yQdMf9lkSv2kwCGRV5h7KxRLIdClrUbpvPy
         Z6M31H9tEWows4qRtj1lW1QCP3kCmsDMg3qLw7KmFS9Pc78lBjjoNaVC2JVWePQNm4ly
         Tidg8o08isU+NfUD2ZB/3QCYh3eoTB5tJsct5E8/E1FGNgWlwWvgNzZltULIrNilc3rv
         IGxIk+BMAQxjIZ0ACpSWUyfugyumeGFBCfSjXGxQ2ryIa+/Q00dCx2AwZR+HOHTOxdHK
         8Teg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NoLQZ4xLsmiigYDKwkyKj0BqR8pGmA2XjKXfyOFiOGQ=;
        b=ps8GOPhnRudJiWb+HlN0JF7m1NszpMPF9C874NKsbitPGhFVIRVbs488Q8GzaEzadR
         QjGhsWpqaI8BnDZCsP9p+D/tne5xi9slonwK2NLlQ45BwFLdA0niKZj2vkcNP3hEjeTo
         VE4JyxgytRhBxyA35S7vP30Eit9/mk5H/aa3Xi7VsZZkG4XMGWE5LqQaksFyU5qgJG0H
         gJLwOiyNvXLpq6VwrnTZ7qshoiUkW+GxDUUNxijTm26T39iuq3f9ECHFIqPPyha1USr7
         gSdzT5P+7vQ5ZLD2+123k7lmxOIGaR7//xRqXVZJ24eGjpK35zMSdweHMuDTwHI9bM9I
         GLpw==
X-Gm-Message-State: AOAM531Xfo7EgFJ7XSlyK4TQeF9X3ZvL0vT8k8FMYmnxEvIBHyr7fvwi
	rIU35YAbEzoVbrOs3IbrTO6XAtf2cNgQhHKKZv8=
X-Google-Smtp-Source: ABdhPJxoQlLUksMMTrEeJnBpX7aUmXahzXq+87mU2xG6zjv9GcII3cRppMGcRbjSLU7EEh3E31xctx4o5xAsG0rwNZg=
X-Received: by 2002:a92:1b86:: with SMTP id f6mr2004630ill.9.1590548860893;
 Tue, 26 May 2020 20:07:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200526205322.23465-1-mic@digikod.net> <20200526205322.23465-8-mic@digikod.net>
In-Reply-To: <20200526205322.23465-8-mic@digikod.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 27 May 2020 06:07:29 +0300
Message-ID: <CAOQ4uxibpDTyjCJWLGG9jr-Gv9PwO==o50b9O8HGQeUfVMDFag@mail.gmail.com>
Subject: Re: [PATCH v18 07/12] landlock: Support filesystem access-control
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Andy Lutomirski <luto@amacapital.net>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <jmorris@namei.org>, 
	Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Jonathan Corbet <corbet@lwn.net>, 
	Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mickael.salaun@ssi.gouv.fr>, 
	Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, 
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, 
	Linux API <linux-api@vger.kernel.org>, linux-arch@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-kselftest@vger.kernel.org, 
	LSM List <linux-security-module@vger.kernel.org>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 27, 2020 at 3:36 AM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
>
> Thanks to the Landlock objects and ruleset, it is possible to identify
> inodes according to a process's domain.  To enable an unprivileged
> process to express a file hierarchy, it first needs to open a directory
> (or a file) and pass this file descriptor to the kernel through
> landlock(2).  When checking if a file access request is allowed, we walk
> from the requested dentry to the real root, following the different
> mount layers.  The access to each "tagged" inodes are collected
> according to their rule layer level, and ANDed to create access to the
> requested file hierarchy.  This makes possible to identify a lot of
> files without tagging every inodes nor modifying the filesystem, while
> still following the view and understanding the user has from the
> filesystem.
>

Hi Mickael,

Nice work! I am interested in the problem of system wide file access
rules based on directory hierarchy [1][2]. Not the same problem, but
with obvious overlaps.

I sketched this untested POC [2] a while ago -
It introduces the concept of "border control" LSM hooks to avoid the
need to check which sections in the hierarchy an inode belongs to
on every syscall.

With this, you could cache a topology with id's per section and
cache the section id + topology generation in the inode's security state.
When inode crosses border control hooks, it's section id is updated.
When directory hierarchy topology changes, some or all of the cached
section id's are invalidated and rules <-> sections relations may need
to be changed.

Do you think something like that could be useful for landlock?

Note that the POC is using d_mountpoint() as the only type of "fence"
mark. It is sufficient for controlling rename in and out of containers, so
I just used an already available dentry flag for "fence".
If the border control hook concept is useful, this could be extended to
a more generic d_border_passing(), with some internal kernel API
to manage it and with all the bike shedding that comes with it...

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/CAOQ4uxhBVhyyJv0+xSFQiGQEj60AbD3S=
ADfKK40uAiC4GF2p9Q@mail.gmail.com/
[2] https://lore.kernel.org/linux-fsdevel/CAOQ4uxgn=3DYNj8cJuccx2KqxEVGZy1z=
3DBVYXrD=3DMc7Dc=3DJe+-w@mail.gmail.com/
[3] https://github.com/amir73il/linux/commits/rename_xmnt
