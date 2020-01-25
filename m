Return-Path: <SRS0=lqZi=3O=lists.openwall.com=kernel-hardening-return-17615-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C37FDC2D0DB
	for <kernel-hardening@archiver.kernel.org>; Sat, 25 Jan 2020 19:01:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1A10F2070A
	for <kernel-hardening@archiver.kernel.org>; Sat, 25 Jan 2020 19:01:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ebrkpC8l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A10F2070A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17615-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30157 invoked by uid 550); 25 Jan 2020 19:00:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25787 invoked from network); 25 Jan 2020 18:52:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=agKBgndk3wOWKqvCTJf0yLyX2bJKGsFMAU50Ri7/n9U=;
        b=ebrkpC8lWGHzj/TTwQVlGmpfBj+LMhP3xc48s3IkdXLpfPBkmBQH8glAibN3NZzhJ7
         eaX+oPyIl6RK4Fcu/p33lei0jipvUcU+PHgqX1Ir4aJDuHlpLIX4SbceygCECD/xiFMl
         QwEsuOsJJnKRw8LKLW82q3yqXp++TF+4Q343k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=agKBgndk3wOWKqvCTJf0yLyX2bJKGsFMAU50Ri7/n9U=;
        b=EesHDfQZ91VwEISrmysZaKNGCmwTbrQS8W8GGMJMGApzpzNrMJV9JwUKLxWHapheXj
         3J30nA+eT+IPLiDejFXNdEbM8yNvzvFLGK22xH+Bl90pmia+Rk5IBGzHTJHAQtNRvWuv
         UVZqXlykel/uMZIxTZtFF8GRG74fU6grwAF5Wbm60wsLrS699vIHecL+trgfcovx4e+N
         WD3mWU0ZCT/RTV7PXoQ43cf+NT28E7m+bQWw3ixdmBhBCaMGK64TtLraO2ZVN7UByFKd
         IgcOa95aoVXXjPjyT2NOax88gG/FH9IHibnzCni1zmgQx3obgskpJdUdhXAIY2Jj0Web
         oJZQ==
X-Gm-Message-State: APjAAAXxlQJM50OkRgS+Y23H0UbNIcZe+TcEOccg0kj3eygTIc0GbKwj
	dPFHwZwT/FSgzFVwPiDqfvrxndFyHzs=
X-Google-Smtp-Source: APXvYqzgLewJR0nE/QNO+U+gC9ccgANoMfkjz5RIYOkgGMagcp6I9g5IA86rGrIB2A+xfVfUHYQKdg==
X-Received: by 2002:a17:906:3518:: with SMTP id r24mr7860556eja.361.1579978342635;
        Sat, 25 Jan 2020 10:52:22 -0800 (PST)
X-Received: by 2002:a05:651c:ce:: with SMTP id 14mr2080983ljr.241.1579977941361;
 Sat, 25 Jan 2020 10:45:41 -0800 (PST)
MIME-Version: 1.0
References: <20200125130541.450409-1-gladkov.alexey@gmail.com> <20200125130541.450409-8-gladkov.alexey@gmail.com>
In-Reply-To: <20200125130541.450409-8-gladkov.alexey@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 25 Jan 2020 10:45:25 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiGNSQCA8TYa1Akp0_GRpe=ELKDPkDX5nzM5R=oDy1U+Q@mail.gmail.com>
Message-ID: <CAHk-=wiGNSQCA8TYa1Akp0_GRpe=ELKDPkDX5nzM5R=oDy1U+Q@mail.gmail.com>
Subject: Re: [PATCH v7 07/11] proc: flush task dcache entries from all procfs instances
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
	Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, 
	Solar Designer <solar@openwall.com>, Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"

On Sat, Jan 25, 2020 at 5:06 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
>
> This allows to flush dcache entries of a task on multiple procfs mounts
> per pid namespace.

From a quick read-through, this is the only one I really react negatively to.

The locking looks odd. It only seems to protect the new proc_mounts
list, but then it's a whole big rwsem, and it's taken over all of
proc_flush_task_mnt(), and the locking is exported to all over as a
result of that - including the dummy functions for "there is no proc"
case.

And proc_flush_task_mnt() itself should need no locking over any of
it, so it's all just for the silly looping over the list.

So

 (a) this looks fishy and feels wrong - I get a very strong feeling
that the locking is wrong to begin with, and could/should have been
done differently

 (b) all the locking should have been internal to /proc, and those
wrappers shouldn't exist in a common header file (and certainly not
for the non-proc case).

Yes, (a) is just a feeling, and I don't have any great suggestions.
Maybe make it an RCU list and use a spinlock for updating it?

But (b) is pretty much a non-starter in this form. Those wrappers
shouldn't be in a globally exported core header file. No way.

               Linus
