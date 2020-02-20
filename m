Return-Path: <SRS0=nlIO=4I=lists.openwall.com=kernel-hardening-return-17870-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B9C2C11D00
	for <kernel-hardening@archiver.kernel.org>; Thu, 20 Feb 2020 23:00:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9CD1D206F4
	for <kernel-hardening@archiver.kernel.org>; Thu, 20 Feb 2020 23:00:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HsJYplXH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CD1D206F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17870-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18310 invoked by uid 550); 20 Feb 2020 23:00:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18284 invoked from network); 20 Feb 2020 23:00:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oW+dHyuXcdgcpFOp9rkCYNNzyvxL/1mmVUWMW1tVkn8=;
        b=HsJYplXHj9WIosfuyYDxgCIpizr4Q2QTncG0r8kQoBcqx1jdtsR9fFVeYAPGlhnI5Y
         7UWBHhKU9LT9oEd08VowjnmWRULPbdq+faWGzRjHU4lCzwffnnc4X3O8+YTbupxrOXam
         he3lTa6POmGxUb6ylyx451mYPhWfQQq6/MfdM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oW+dHyuXcdgcpFOp9rkCYNNzyvxL/1mmVUWMW1tVkn8=;
        b=HHMbOwWXCuji1vXEHmKU1ahtqXxQCe4Gdzbx27o+eKxkoZyfXHvMFcKNCg+x1GLrDU
         +8puzAEye3+K1JXkblePzS3ca7OhamX21TVtzi9YlH7BnhWsJHaLWnlRfWXuY+/npo71
         edFrA7WPLIyTC/0KCfKHEbzlD2dLxzCiQQcJ6TdX8q6Y8HBbMpghtPlma0VQIi27XhHb
         r5rUC403E+1G20S8i8fM0PrsLpKg33jx6TDRslW/XBlrCWI+mvgLK8hTWk7P2qehuh5L
         R/2Z6aiCoMPUxnFFNP4Am4nS6DnNIDDAy6YcpmO7qdABOJg8FJBCDhmQmgAb7OmlyTe8
         N1/w==
X-Gm-Message-State: APjAAAWscRarrlznI9rkI8qBskqZ+lkjZIr1NqPvn7A5UUy3FKZF1V1U
	vzqLSWfzBeZhReY5mYKm63PQ2G/eajg=
X-Google-Smtp-Source: APXvYqyQETX93j79eDt2soxIL0e2J3Wh7jpRWSXJsqgT6wE5s+DEDtK88e2ZRZlecIn9M82oLfG8AA==
X-Received: by 2002:a05:6512:467:: with SMTP id x7mr3134861lfd.177.1582239631972;
        Thu, 20 Feb 2020 15:00:31 -0800 (PST)
X-Received: by 2002:a2e:88c5:: with SMTP id a5mr20496205ljk.201.1582239629960;
 Thu, 20 Feb 2020 15:00:29 -0800 (PST)
MIME-Version: 1.0
References: <20200212200335.GO23230@ZenIV.linux.org.uk> <CAHk-=wi+1CPShMFvJNPfnrJ8DD8uVKUOQ5TQzQUNGLUkeoahkg@mail.gmail.com>
 <20200212203833.GQ23230@ZenIV.linux.org.uk> <20200212204124.GR23230@ZenIV.linux.org.uk>
 <CAHk-=wi5FOGV_3tALK3n6E2fK3Oa_yCYkYQtCSaXLSEm2DUCKg@mail.gmail.com>
 <87lfp7h422.fsf@x220.int.ebiederm.org> <CAHk-=wgmn9Qds0VznyphouSZW6e42GWDT5H1dpZg8pyGDGN+=w@mail.gmail.com>
 <87pnejf6fz.fsf@x220.int.ebiederm.org> <871rqpaswu.fsf_-_@x220.int.ebiederm.org>
 <87blpt9e6m.fsf_-_@x220.int.ebiederm.org> <20200220225420.GR23230@ZenIV.linux.org.uk>
In-Reply-To: <20200220225420.GR23230@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Feb 2020 15:00:13 -0800
X-Gmail-Original-Message-ID: <CAHk-=whPwMTTaGtphubBXeiKitKigutddx9Fcp4Sf1sw4tpyeA@mail.gmail.com>
Message-ID: <CAHk-=whPwMTTaGtphubBXeiKitKigutddx9Fcp4Sf1sw4tpyeA@mail.gmail.com>
Subject: Re: [PATCH 4/7] proc: Use d_invalidate in proc_prune_siblings_dcache
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, 
	Linux Security Module <linux-security-module@vger.kernel.org>, 
	Akinobu Mita <akinobu.mita@gmail.com>, Alexey Dobriyan <adobriyan@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, 
	"Dmitry V . Levin" <ldv@altlinux.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Ingo Molnar <mingo@kernel.org>, "J . Bruce Fields" <bfields@fieldses.org>, 
	Jeff Layton <jlayton@poochiereds.net>, Jonathan Corbet <corbet@lwn.net>, 
	Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, 
	Solar Designer <solar@openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 20, 2020 at 2:54 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> s/no inode.*/it's a directory inode./

That actually makes my worry go away too. We don't allow aliases for
directory inodes, iirc.

So then it doesn't depend on some /proc implementation issue any more,
then it's fundamental that there's only one dentry.

            Linus
