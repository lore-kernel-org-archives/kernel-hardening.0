Return-Path: <SRS0=oRov=5R=lists.openwall.com=kernel-hardening-return-18363-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EEB9C43331
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 23:52:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 644F320772
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 23:52:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JX+jSiMz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 644F320772
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18363-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22429 invoked by uid 550); 1 Apr 2020 23:52:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22409 invoked from network); 1 Apr 2020 23:52:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H9rQ+4MX6AGqiS4gDh7zcouPJInPh/6Vm7fyt3tgD0k=;
        b=JX+jSiMzF2RZC7X1UHsV906x8DewgkAwWN6EQ17vLXZEJQX6swhg/zVI1vxFEEZxIH
         PbSD0KAyottCcGb/rT1bEA1sm5NRoFsrhBrQoH3A79V86rZeArdSk7sJvXfa6DN/8YJY
         Q2hGYFvnvtsGpe9Mfmd01M2hX1hq6hVJbWiug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H9rQ+4MX6AGqiS4gDh7zcouPJInPh/6Vm7fyt3tgD0k=;
        b=YGDJGDMeTu0kRmqKDEb3qwguLrBvz8rVALvlWVN4l5SrDfZpBos751OVlgXkAb9fJO
         sACd4/9Cv+SYk54Q/2RoZNUfeFPh+zH2390isuQHRVzsqU0siMen/+KQ1cmhySpNuHTk
         enmDfO5T5khjzfyN3bsnn/enpsgs/H1RIpZYrw62a90R1pQ7BAzBFKC1XnF7HmNmuwi4
         L/x0WLhMlUYc8nS+Mhx/XjyOzhshaSos68ANMAwR85+R8AXlyXUAcw3W6RjYQ/I5I9eM
         lK0HMS23iX0t4gtxQHm5w3YWwSBMU01FtoN4EAzXIO0/XjZK7TJnMzTRuGDCnOEGF7GR
         m3xA==
X-Gm-Message-State: AGi0Pua+kg6XjlastQZnTAf20yQndKs8nJxNgHl5lULGKjfugmGC8bi7
	ls7ViA6+l+h7EPbbMLrBJ4blz9aKPOo=
X-Google-Smtp-Source: APiQypJ6PKebZ2J92cswyQGoFWnzCa6ctAjdOjNCnnbH3lYxRYup2Ks7aLiPGWtd+/s/ySS0dsFA0g==
X-Received: by 2002:a2e:9959:: with SMTP id r25mr377692ljj.200.1585785115656;
        Wed, 01 Apr 2020 16:51:55 -0700 (PDT)
X-Received: by 2002:a2e:8652:: with SMTP id i18mr373016ljj.265.1585785113845;
 Wed, 01 Apr 2020 16:51:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200324215049.GA3710@pi3.com.pl> <202003291528.730A329@keescook>
 <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org> <CAG48ez3nYr7dj340Rk5-QbzhsFq0JTKPf2MvVJ1-oi1Zug1ftQ@mail.gmail.com>
In-Reply-To: <CAG48ez3nYr7dj340Rk5-QbzhsFq0JTKPf2MvVJ1-oi1Zug1ftQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Apr 2020 16:51:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjz0LEi68oGJSQzZ--3JTFF+dX2yDaXDRKUpYxtBB=Zfw@mail.gmail.com>
Message-ID: <CAHk-=wjz0LEi68oGJSQzZ--3JTFF+dX2yDaXDRKUpYxtBB=Zfw@mail.gmail.com>
Subject: Re: [PATCH] signal: Extend exec_id to 64bits
To: Jann Horn <jannh@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alan Stern <stern@rowland.harvard.edu>, 
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
	stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Apr 1, 2020 at 4:37 PM Jann Horn <jannh@google.com> wrote:
>
> GCC will generate code for this without complaining, but I think it'll
> probably generate a tearing store on 32-bit platforms:

This is very much a "we don't care" case.

It's literally testing a sequence counter for equality. If you get
tearing in the high bits on the write (or the read), you'd still need
to have the low bits turn around 4G times to get a matching value.

So no. We're not doing atomics for the 32-bit case. That's insane.

               Linus
