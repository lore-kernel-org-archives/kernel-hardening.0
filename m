Return-Path: <SRS0=+kmZ=4A=lists.openwall.com=kernel-hardening-return-17805-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB78EC352A4
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Feb 2020 20:42:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 32B8621734
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Feb 2020 20:42:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IgiKGasr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32B8621734
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17805-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3445 invoked by uid 550); 12 Feb 2020 20:42:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3422 invoked from network); 12 Feb 2020 20:42:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bqyVLATGO6MwZ1NPxpHKDD7nGLBCP8OMxbpMcz0c8xI=;
        b=IgiKGasrvpx5KEqTjK3uSOaiUPZJr6oQaxEeiUKRSC7Mzut+kfrtuMYf7JfgJYo2j9
         r6YHIpl0Oomh/U1TMzjQtQYQDvEFopln06zrn/G9JdYxAN1cr+G4MM7V+yIgIdgHmkT5
         mB2IAKAHrGr3Dq04+09yh6iga9CCs4Dv6Lzfk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bqyVLATGO6MwZ1NPxpHKDD7nGLBCP8OMxbpMcz0c8xI=;
        b=tW9cyO4RSEO6xui7u6ZcbSrO2odfi8dzAcvAw9emES5P0Ub3MeChgRm5m3/0dSpFDB
         AJwXKY+QuE4CNhMvoU11POXUvrb4fe9h/8/1zieaEdQycy3wW64mLc3IwXRwrz2bNbWk
         a3kVPO4iQf+1ETpxwlyplESqro18rimsxkSQtMD6fKSPgFziVFPwcuqQQd5ZAB6Qv6Bk
         OdQMeHpsSjjvTh3y0wlY5siR09I5tD4i2NBf6nCKt4UMUXiuYwEdJWXcdqGADyMVGgRJ
         mtyJ4geZSfOvuR4ySV4DFXfgXRK3e4CW/Svo7p4fIbRf9aUfsfJmuiILmf88sI9Z9jP1
         EIHg==
X-Gm-Message-State: APjAAAW0Fj5Kzx3bhLcOMjYT4+YML1++SIbf1R2k6ZmNb1m+qomNhmU8
	sGHlWV/haMAeF0QSGJeoH9cY60jcYC4=
X-Google-Smtp-Source: APXvYqyRuPeDbseAp1XCX4OmjvoK0SPJ5VAuuHT4U1JqTUG5EQwp6fK5+cRVaRpIjRu1ZWabtvgABw==
X-Received: by 2002:a2e:9218:: with SMTP id k24mr8495172ljg.262.1581540149719;
        Wed, 12 Feb 2020 12:42:29 -0800 (PST)
X-Received: by 2002:a2e:9d92:: with SMTP id c18mr9321452ljj.265.1581539720898;
 Wed, 12 Feb 2020 12:35:20 -0800 (PST)
MIME-Version: 1.0
References: <20200210150519.538333-1-gladkov.alexey@gmail.com>
 <20200210150519.538333-8-gladkov.alexey@gmail.com> <87v9odlxbr.fsf@x220.int.ebiederm.org>
 <20200212144921.sykucj4mekcziicz@comp-core-i7-2640m-0182e6>
 <87tv3vkg1a.fsf@x220.int.ebiederm.org> <CAHk-=wg52stFtUxMOxs3afkwDWmWn1JXC7RJ7dPsTrJbnxpZVg@mail.gmail.com>
 <87v9obipk9.fsf@x220.int.ebiederm.org> <CAHk-=wgwmu4jpmOqW0+Lz0dcem1Fub=ThLHvmLobf_WqCq7bwg@mail.gmail.com>
 <20200212200335.GO23230@ZenIV.linux.org.uk>
In-Reply-To: <20200212200335.GO23230@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Feb 2020 12:35:04 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi+1CPShMFvJNPfnrJ8DD8uVKUOQ5TQzQUNGLUkeoahkg@mail.gmail.com>
Message-ID: <CAHk-=wi+1CPShMFvJNPfnrJ8DD8uVKUOQ5TQzQUNGLUkeoahkg@mail.gmail.com>
Subject: Re: [PATCH v8 07/11] proc: flush task dcache entries from all procfs instances
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

On Wed, Feb 12, 2020 at 12:03 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> What's to prevent racing with fs shutdown while you are doing the second part?

I was thinking that only the proc_flush_task() code would do this.

And that holds a ref to the vfsmount through upid->ns.

So I wasn't suggesting doing this in general - just splitting up the
implementation of d_invalidate() so that proc_flush_task_mnt() could
delay the complex part to after having traversed the RCU-protected
list.

But hey - I missed this part of the problem originally, so maybe I'm
just missing something else this time. Wouldn't be the first time.

               Linus
