Return-Path: <SRS0=8upJ=36=lists.openwall.com=kernel-hardening-return-17756-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 488FCC35254
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 18:23:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9670D2080C
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 18:23:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="iiK85FFk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9670D2080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17756-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28080 invoked by uid 550); 10 Feb 2020 18:23:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28057 invoked from network); 10 Feb 2020 18:23:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581359017;
	bh=t3Wks9ek7HdZAz6PJfkKNyateIsqhC1vSgHRd0AbOp8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=iiK85FFk1llSss7Y+WKoCQhsXOljBpzzUvKnMT33O/2Qb4MLgmoMZsRb/ugOpUOYA
	 maNfzqkY1lGCPD+4umyoaW2df4LcCztXq2pR9ffElISHzDdNZQQxIkNB+SStreUyHy
	 kWIfoQZJbKDHzCBnaTfwpRYalPutSU3oG+LzdppA=
X-Gm-Message-State: APjAAAU5o8zTzkb63+y9r+0Y/mF+8uCf3dgTwdX7K2BtcGbzGIkWsZ/u
	R8G8i2WH4NUbrgr2vOGYI6bcXYmym3YsB9pp825dng==
X-Google-Smtp-Source: APXvYqyvQmNAMgah8c6tQsJZ+XZQiG6GIX/jTddr8+dPCUtkW0/ytdNqMktRK7dZRNI8z6/OdYPguTtbJfJo4KyutMo=
X-Received: by 2002:a7b:cbcf:: with SMTP id n15mr262021wmi.21.1581359015424;
 Mon, 10 Feb 2020 10:23:35 -0800 (PST)
MIME-Version: 1.0
References: <20200210150519.538333-1-gladkov.alexey@gmail.com> <20200210150519.538333-4-gladkov.alexey@gmail.com>
In-Reply-To: <20200210150519.538333-4-gladkov.alexey@gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 10 Feb 2020 10:23:23 -0800
X-Gmail-Original-Message-ID: <CALCETrWGpRr86tVKJU-sEMcg+x0Yzp+TbiBhrAc71RaO8=DYGQ@mail.gmail.com>
Message-ID: <CALCETrWGpRr86tVKJU-sEMcg+x0Yzp+TbiBhrAc71RaO8=DYGQ@mail.gmail.com>
Subject: Re: [PATCH v8 03/11] proc: move /proc/{self|thread-self} dentries to proc_fs_info
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, 
	Linux Security Module <linux-security-module@vger.kernel.org>, 
	Akinobu Mita <akinobu.mita@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Daniel Micay <danielmicay@gmail.com>, 
	Djalal Harouni <tixxdz@gmail.com>, "Dmitry V . Levin" <ldv@altlinux.org>, 
	"Eric W . Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Ingo Molnar <mingo@kernel.org>, "J . Bruce Fields" <bfields@fieldses.org>, 
	Jeff Layton <jlayton@poochiereds.net>, Jonathan Corbet <corbet@lwn.net>, 
	Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Oleg Nesterov <oleg@redhat.com>, Solar Designer <solar@openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Feb 10, 2020 at 7:06 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
>
> This is a preparation patch that moves /proc/{self|thread-self} dentries
> to be stored inside procfs fs_info struct instead of making them per pid
> namespace. Since we want to support multiple procfs instances we need to
> make sure that these dentries are also per-superblock instead of
> per-pidns,

The changelog makes perfect sense so far...

> unmounting a private procfs won't clash with other procfs
> mounts.

This doesn't parse as part of the previous sentence.  I'm also not
convinced that this really involves unmounting per se.  Maybe just
delete these words.
