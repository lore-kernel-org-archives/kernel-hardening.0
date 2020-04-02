Return-Path: <SRS0=6qw/=5S=lists.openwall.com=kernel-hardening-return-18396-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C7CC43331
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 19:06:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 21DEE20719
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 19:06:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hvEITigZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21DEE20719
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18396-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3499 invoked by uid 550); 2 Apr 2020 19:05:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3479 invoked from network); 2 Apr 2020 19:05:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RlBOg0dum66ebZmfIZrWlU1IBkKC8efn4oYc6hOU1L0=;
        b=hvEITigZV32UOF8ubiUjd+p22kCZAiMJFfBqDEEHBqM8+KyLyY3+cjtQPsswx+RUpm
         HJ1KgeDiJRSfzbkwXPk1cZ6pfQGvYJULSwuj6II4fCP3quqyDwcIFxIxB2CVRWFVsr87
         Cmk6cMB40cebsPRptNEHYRfJuiAA45R2UT23k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RlBOg0dum66ebZmfIZrWlU1IBkKC8efn4oYc6hOU1L0=;
        b=npPOe8JtlWsYVM56SbZe1OajDA7qmI68ItMeCakHNdDOAfKA5KNh7xLXYjlFGiVRYf
         LO3LKbMe5oNyKY2YOHYauCbqosOrkxoX7qxtTOTSDTqWo0QUA881Fo4urCVeVSsqgbaq
         fWgoqJMCY4xx++1nrwcNn8gQl5nEtqSCslJcRTBDF15tD5c/1WKKCD3LspOFkU0Ag/In
         ORWMQe3KUZKXL87tiYjHKyMbVWk2lKZOGqhk+7ad3A8QLfTkog3XyssUYPVyQ4G20hLt
         zTeXe8jxruPdghrzJQ/ohXSl/mczXrjPhRhh2BQBNwB1cs3aMMZ2pRANvfLIX6orRgKm
         F1qQ==
X-Gm-Message-State: AGi0PuYDn9FmBFHpQHpDPJ4IRWleBdpS4305nX1XFEPKHa/a2N/Pdot+
	heDObLOx/WhnKWJdSOyw8qtK6vo89Hw=
X-Google-Smtp-Source: APiQypJMrExtBvPPyamiukkhFnrtARNtGE9sboICmKnLC0vTMJowKO/XcMIuRijDJkea1lda2mHX7g==
X-Received: by 2002:a2e:b5d1:: with SMTP id g17mr2666366ljn.139.1585850804156;
        Thu, 02 Apr 2020 11:06:44 -0700 (PDT)
X-Received: by 2002:a2e:8652:: with SMTP id i18mr2793744ljj.265.1585850802219;
 Thu, 02 Apr 2020 11:06:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200324215049.GA3710@pi3.com.pl> <202003291528.730A329@keescook>
 <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org> <CAG48ez3nYr7dj340Rk5-QbzhsFq0JTKPf2MvVJ1-oi1Zug1ftQ@mail.gmail.com>
 <CAHk-=wjz0LEi68oGJSQzZ--3JTFF+dX2yDaXDRKUpYxtBB=Zfw@mail.gmail.com>
 <CAHk-=wgM3qZeChs_1yFt8p8ye1pOaM_cX57BZ_0+qdEPcAiaCQ@mail.gmail.com>
 <CAG48ez1f82re_V=DzQuRHpy7wOWs1iixrah4GYYxngF1v-moZw@mail.gmail.com>
 <CAHk-=whks0iE1f=Ka0_vo2PYg774P7FA8Y30YrOdUBGRH-ch9A@mail.gmail.com> <877dyym3r0.fsf@x220.int.ebiederm.org>
In-Reply-To: <877dyym3r0.fsf@x220.int.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 2 Apr 2020 11:06:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiOS4Fi2tsXQrvLOiW69g4HiJYsqL6RPeTd14b4+2-Ykg@mail.gmail.com>
Message-ID: <CAHk-=wiOS4Fi2tsXQrvLOiW69g4HiJYsqL6RPeTd14b4+2-Ykg@mail.gmail.com>
Subject: Re: [PATCH] signal: Extend exec_id to 64bits
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jann Horn <jannh@google.com>, Alan Stern <stern@rowland.harvard.edu>, 
	Andrea Parri <parri.andrea@gmail.com>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Nicholas Piggin <npiggin@gmail.com>, David Howells <dhowells@redhat.com>, 
	Jade Alglave <j.alglave@ucl.ac.uk>, Luc Maranget <luc.maranget@inria.fr>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Akira Yokosawa <akiyks@gmail.com>, 
	Daniel Lustig <dlustig@nvidia.com>, Adam Zabrocki <pi3@pi3.com.pl>, 
	kernel list <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Oleg Nesterov <oleg@redhat.com>, 
	Andy Lutomirski <luto@amacapital.net>, Bernd Edlinger <bernd.edlinger@hotmail.de>, 
	Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	stable <stable@vger.kernel.org>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Apr 2, 2020 at 6:14 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Linus Torvalds <torvalds@linux-foundation.org> writes:
>
> > tasklist_lock is aboue the hottest lock there is in all of the kernel.
>
> Do you know code paths you see tasklist_lock being hot?

It's generally not bad enough to show up on single-socket machines.

But the problem with tasklist_lock is that it's one of our remaining
completely global locks. So it scales like sh*t in some circumstances.

On single-socket machines, most of the truly nasty hot paths aren't a
huge problem, because they tend to be mostly readers. So you get the
cacheline bounce, but you don't (usually) get much busy looping. The
cacheline bounce is "almost free" on a single socket.

But because it's one of those completely global locks, on big
multi-socket machines people have reported it as a problem forever.
Even just readers can cause problems (because of the cacheline
bouncing even when you just do the reader increment), but you also end
up having more issues with writers scaling badly.

Don't get me wrong - you can get bad scaling on other locks too, even
when they aren't really global - we had that with just the reference
counter increment for the user signal accounting, after all. Neither
of the reference counts were actually global, but they were just
effectively single counters under that particular load (ie the count
was per-user, but the load ran as a single user).

The reason tasklist_lock probably doesn't come up very much is that
it's _always_ been expensive. It has also caused some fundamental
issues (I think it's the main reason we have that rule that
reader-writer locks are unfair to readers, because we have readers
from interrupt context too, but can't afford to make normal readers
disable interrupts).

A lot of the tasklist lock readers end up looping quite a bit inside
the lock (looping over threads etc), which is why it can then be a big
deal when the rare reader shows up.

We've improved a _lot_ of those loops. That has definitely helped for
the common cases. But we've never been able to really fix the lock
itself.

                 Linus
