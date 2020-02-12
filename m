Return-Path: <SRS0=S/EY=4A=lists.openwall.com=kernel-hardening-return-17798-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE90C352A4
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Feb 2020 18:45:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4F7E224680
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Feb 2020 18:45:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E/vN3AE3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F7E224680
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17798-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9977 invoked by uid 550); 12 Feb 2020 18:45:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9954 invoked from network); 12 Feb 2020 18:45:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8S2w7jKfhj8nqr2BEN6cbFr7nckGF3MBI5pTAOk2Bgk=;
        b=E/vN3AE3iyzGDOzjrhIyYOh5wyK5H3COrkDAy4Yb/0fuIwlyf50yEW7S/x5cDf9tHW
         zWbCuDLoLaAGtRSBjikTyE8yY06byotE/cGEhEbxOklsxfNCa9G0PsCjeYAs62WP1DSa
         M2BG1IabKnVo1IvqnOENDDauUUlMg+SJyMK4U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8S2w7jKfhj8nqr2BEN6cbFr7nckGF3MBI5pTAOk2Bgk=;
        b=mDiWsS1zbXumAtH6xw7daYDSB25pmcZ7QH8ouCX/beYtZOtm0nm2QXcN5SkLmlZzfM
         EYgGUR26ncUdqgjlkl8wsjeuTgY1U3KgHrPTG8I1F6keqoySGdOKXFPozMT4IukJ6s7N
         F5am+9XxRXj3n1JgMNQFmfiKwlqkQhWJ53AjinWw+wrp2NmeCcVFXM2wWqhz5+9hunFb
         9/Byeo4DATd4szdZ8Oja1GXbLmcfOfEIXEYmHJahAt6e6op+ynanWMryrDp/QmQU/sP2
         aj/vThST1PUXnuwCGLT6oUdP15HRnGBwF6NjGiATCfNkpX+uZ6z/Cn/bqmxJ4PDvuQHm
         a3wQ==
X-Gm-Message-State: APjAAAVYuiuOjagQgKRZtj6ouXvQbcdmeE0cPg5np/J93ggRSJrTNeL0
	/kV/5F3i8Y8AFYGX4bpKe4OtxbBW7fs=
X-Google-Smtp-Source: APXvYqzAX6l3297axlS1lTYXG2/KJK8zs/9BAol15HKsqOLRe8T1CD8M0c0DqZ0ZoU31LpHSE6YBkQ==
X-Received: by 2002:a05:6512:284:: with SMTP id j4mr7307015lfp.109.1581533124558;
        Wed, 12 Feb 2020 10:45:24 -0800 (PST)
X-Received: by 2002:a2e:97cc:: with SMTP id m12mr8440902ljj.241.1581533122702;
 Wed, 12 Feb 2020 10:45:22 -0800 (PST)
MIME-Version: 1.0
References: <20200210150519.538333-1-gladkov.alexey@gmail.com>
 <20200210150519.538333-8-gladkov.alexey@gmail.com> <87v9odlxbr.fsf@x220.int.ebiederm.org>
 <20200212144921.sykucj4mekcziicz@comp-core-i7-2640m-0182e6> <87tv3vkg1a.fsf@x220.int.ebiederm.org>
In-Reply-To: <87tv3vkg1a.fsf@x220.int.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Feb 2020 10:45:06 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg52stFtUxMOxs3afkwDWmWn1JXC7RJ7dPsTrJbnxpZVg@mail.gmail.com>
Message-ID: <CAHk-=wg52stFtUxMOxs3afkwDWmWn1JXC7RJ7dPsTrJbnxpZVg@mail.gmail.com>
Subject: Re: [PATCH v8 07/11] proc: flush task dcache entries from all procfs instances
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, 
	Linux Security Module <linux-security-module@vger.kernel.org>, 
	Akinobu Mita <akinobu.mita@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Daniel Micay <danielmicay@gmail.com>, 
	Djalal Harouni <tixxdz@gmail.com>, "Dmitry V . Levin" <ldv@altlinux.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, 
	"J . Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, 
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, 
	Solar Designer <solar@openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 12, 2020 at 7:01 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Fundamentally proc_flush_task is an optimization.  Just getting rid of
> dentries earlier.  At least at one point it was an important
> optimization because the old process dentries would just sit around
> doing nothing for anyone.

I'm pretty sure it's still important. It's very easy to generate a
_ton_ of dentries with /proc.

> I wonder if instead of invalidating specific dentries we could instead
> fire wake up a shrinker and point it at one or more instances of proc.

It shouldn't be the dentries themselves that are a freeing problem.
They're being RCU-free'd anyway because of lookup. It's the
proc_mounts list that is the problem, isn't it?

So it's just fs_info that needs to be rcu-delayed because it contains
that list. Or is there something else?

               Linus
