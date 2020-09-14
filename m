Return-Path: <SRS0=aCS9=CX=lists.openwall.com=kernel-hardening-return-19896-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8955EC433E2
	for <kernel-hardening@archiver.kernel.org>; Mon, 14 Sep 2020 19:39:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 930882193E
	for <kernel-hardening@archiver.kernel.org>; Mon, 14 Sep 2020 19:39:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KMb8YL82"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 930882193E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19896-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28304 invoked by uid 550); 14 Sep 2020 19:39:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28283 invoked from network); 14 Sep 2020 19:39:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lG5XGf95bwNJOiL8PcjSLhdHd8W32J8QXR/kZviOKdg=;
        b=KMb8YL82jYt+MdR+06nAv1SDjyBvY4xZgeT/ZSDzaA/sIk4BMgBJiDBRB+e1bufy3+
         8ZUWjMH8ilySI8ll0tpW9SGHNcwfcXvuO/ogAr+JiAJ+gLYB2oFiAISVMsXaZiFZKhG6
         rNV9jXE4AzKiGnJtbZ01dTfsAaRXm01QgaG5C8WCbA0mkKFr6J1uj1+DZPrJ9hzkpFLt
         7CafX7kXEWTa72gmB4FzIyzXC1KrE0sLckGmAtvfbSZqoUxrNCh+knJSNyZnBMhxAxTx
         dNPT5gnmXVGLWsSSXLj6HwJ+ZnTlIAmp/gH/hWa2wQfaMmrOBh6HBlLkbN6H+zlGsjQ8
         UTIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lG5XGf95bwNJOiL8PcjSLhdHd8W32J8QXR/kZviOKdg=;
        b=uZRG72dk8uL/KcPOPPk5TezHdPh/kvIzX2RKM+9Sc3Il0Oc3ccmIOIwAuYNY+oxVGa
         sn0PD33mAppWqu9RVrKS+mWiG0nb0YHG8NpxyUyj7rZqVwQ7HaGefqjs4hBA4UlYTx4b
         +zoc/87KDGDQs88Y7wRKlozwRyY6n0pkwOXh9RPpIu3wkYj0NZtBHSDGKGp2hC8mbtjZ
         BB8vfYfryZSNuCHwecBhBh8Py/fz44s6yOugSZNpj/IgehpeHgHB8L4XHWMFBnH0CDWZ
         xEq7Nl0R2fW8z+M0m8bzRkSqb803EI1ZO1kYEyQRAjqJukW2MorAUDKF/ss071fd1d+9
         ZlUw==
X-Gm-Message-State: AOAM533Qf2bXph5daNRJzRIrczCuW0ffMoaKaaHDswSe6ZJOLBsZX/0Y
	76lEfHzAYB/ZM3Mpa+N9VY+TVyy6lQXdQWxMjmw5sg==
X-Google-Smtp-Source: ABdhPJxc/PtfgEbkD4fcsDei9QMBxurLSxbpcXluh3HHDXLs/uUkzi3B73RmIjNWnbIXKDpCIS3Fg5qNSvIHPX0J6v4=
X-Received: by 2002:a50:e807:: with SMTP id e7mr19255309edn.84.1600112376719;
 Mon, 14 Sep 2020 12:39:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200910202107.3799376-1-keescook@chromium.org>
 <20200910202107.3799376-6-keescook@chromium.org> <202009101634.52ED6751AD@keescook>
 <CAG48ez2fP7yupg6Th+Hg0tL3o06p2PR1HtQcvy4Ro+Q5T2Nfkw@mail.gmail.com> <20200913152724.GB2873@ubuntu>
In-Reply-To: <20200913152724.GB2873@ubuntu>
From: Jann Horn <jannh@google.com>
Date: Mon, 14 Sep 2020 21:39:10 +0200
Message-ID: <CAG48ez3aQXb3EuGRVvLLo7BxycqJ4Y2mL83QhY9-QMK_qkfCuQ@mail.gmail.com>
Subject: Re: [RFC PATCH 5/6] security/fbfam: Detect a fork brute force attack
To: John Wood <john.wood@gmx.com>
Cc: Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Matthew Wilcox <willy@infradead.org>, 
	Jonathan Corbet <corbet@lwn.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Luis Chamberlain <mcgrof@kernel.org>, Iurii Zaikin <yzaikin@google.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org, 
	kernel list <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, Sep 13, 2020 at 6:56 PM John Wood <john.wood@gmx.com> wrote:
> On Fri, Sep 11, 2020 at 02:01:56AM +0200, Jann Horn wrote:
> > On Fri, Sep 11, 2020 at 1:49 AM Kees Cook <keescook@chromium.org> wrote:
> > > On Thu, Sep 10, 2020 at 01:21:06PM -0700, Kees Cook wrote:
> > > > diff --git a/fs/coredump.c b/fs/coredump.c
> > > > index 76e7c10edfc0..d4ba4e1828d5 100644
> > > > --- a/fs/coredump.c
> > > > +++ b/fs/coredump.c
> > > > @@ -51,6 +51,7 @@
> > > >  #include "internal.h"
> > > >
> > > >  #include <trace/events/sched.h>
> > > > +#include <fbfam/fbfam.h>
> > > >
> > > >  int core_uses_pid;
> > > >  unsigned int core_pipe_limit;
> > > > @@ -825,6 +826,7 @@ void do_coredump(const kernel_siginfo_t *siginfo)
> > > >  fail_creds:
> > > >       put_cred(cred);
> > > >  fail:
> > > > +     fbfam_handle_attack(siginfo->si_signo);
> > >
> > > I don't think this is the right place for detecting a crash -- isn't
> > > this only for the "dumping core" condition? In other words, don't you
> > > want to do this in get_signal()'s "fatal" block? (i.e. very close to the
> > > do_coredump, but without the "should I dump?" check?)
> > >
> > > Hmm, but maybe I'm wrong? It looks like you're looking at noticing the
> > > process taking a signal from SIG_KERNEL_COREDUMP_MASK ?
> > >
> > > (Better yet: what are fatal conditions that do NOT match
> > > SIG_KERNEL_COREDUMP_MASK, and should those be covered?)
> > >
> > > Regardless, *this* looks like the only place without an LSM hook. And it
> > > doesn't seem unreasonable to add one here. I assume it would probably
> > > just take the siginfo pointer, which is also what you're checking.
> >
> > Good point, making this an LSM might be a good idea.
> >
> > > e.g. for include/linux/lsm_hook_defs.h:
> > >
> > > LSM_HOOK(int, 0, task_coredump, const kernel_siginfo_t *siginfo);
> >
> > I guess it should probably be an LSM_RET_VOID hook? And since, as you
> > said, it's not really semantically about core dumping, maybe it should
> > be named task_fatal_signal or something like that.
>
> If I understand correctly you propose to add a new LSM hook without return
> value and place it here:
>
> diff --git a/kernel/signal.c b/kernel/signal.c
> index a38b3edc6851..074492d23e98 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2751,6 +2751,8 @@ bool get_signal(struct ksignal *ksig)
>                         do_coredump(&ksig->info);
>                 }
>
> +               // Add the new LSM hook here
> +
>                 /*
>                  * Death signals, no core dump.
>                  */

It should probably be in the "if (sig_kernel_coredump(signr)) {"
branch. And I'm not sure whether it should be before or after
do_coredump() - if you do it after do_coredump(), the hook will have
to wait until the core dump file has been written, which may take a
little bit of time.
