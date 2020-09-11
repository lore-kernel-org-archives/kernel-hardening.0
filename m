Return-Path: <SRS0=IFC+=CU=lists.openwall.com=kernel-hardening-return-19877-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E32C43461
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Sep 2020 00:02:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 91E332087D
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Sep 2020 00:02:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rnRu5BQ3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91E332087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19877-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15826 invoked by uid 550); 11 Sep 2020 00:02:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15803 invoked from network); 11 Sep 2020 00:02:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JhzWeBi98uxge5Nl6JBsweyqdcSVY7AXtn8+FM0wSrE=;
        b=rnRu5BQ39GIwkamlytlKQmPZIKMfKBaWA1lS6u7txSlp88YIhkgh4Ikh/BkD2VooC0
         Aqx2tV227t/q0hU7LxaBwj94TDuh22rSbw4vLxkEbDFXzYBT7LefF2I/axBOnrs01F42
         X/swFpSTGtknqcSv/1DR81oljlbK606giguTiYPcnfiSe5mxUg9id6uwA1iFWJ02pbfo
         kkwSgpD5Zir6FPSfU4ffjsb5kVWDJ2siaXrOY3Zx4u8daVswlC6DFIAft9zLt98Y8r5e
         XlfvSX71WcoF1DP0i71dEov2Rm7pZ3uhwGvDhxfneGMGVF22rb6/TE0FT31kA4mLg0Y9
         7FFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JhzWeBi98uxge5Nl6JBsweyqdcSVY7AXtn8+FM0wSrE=;
        b=II1ixI9IB0/+OHZ7OMBDl2uBwUmHISU2ixfiYJMKzoaZjSVuU5tF6glTIWBv3eVqG/
         O3lo9uIIZptWHF6gmofJO8MTJO35wKQQNP3WT3nCEf4b5tXmjyhWmkxAQcNdgGOik4+v
         F3YodHvs7omYZHodHUo1910BY5TjUlMYSiQlAjwBUPw+/qBtHe2/O5Q3Z3Q7WjFD9PHR
         zJcqpqNuFpl2e1yLBQs3fjpkkBTqZYOGTNhxh88MwZ7t79sTTYgOyvv/DG7Nfz76nvz2
         WY4u3xkrZE9UcSRtjLzVxL3kyYdiWOnAFb2i2tutxjQYuhj5hBXV7kJbr+HGbuF92M6v
         QikA==
X-Gm-Message-State: AOAM533u8j49CmQnZiOOft1Y6G7fLmMY+Fo+duk7a659rZP6d8Gw1lqM
	/4RpF47HtAFZ+8/TFTNdC1kbC7xSv9B39RfIOaSzEg==
X-Google-Smtp-Source: ABdhPJzqjd13RuBCERWCNKaIjZBQ1L7nXsBk6lxn6abKKBWrWwwFaxOFeoAHNmmQyEOac8m4z/LctrardqgtakRoM9k=
X-Received: by 2002:a17:906:a0c2:: with SMTP id bh2mr11828231ejb.493.1599782542769;
 Thu, 10 Sep 2020 17:02:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200910202107.3799376-1-keescook@chromium.org>
 <20200910202107.3799376-6-keescook@chromium.org> <202009101634.52ED6751AD@keescook>
In-Reply-To: <202009101634.52ED6751AD@keescook>
From: Jann Horn <jannh@google.com>
Date: Fri, 11 Sep 2020 02:01:56 +0200
Message-ID: <CAG48ez2fP7yupg6Th+Hg0tL3o06p2PR1HtQcvy4Ro+Q5T2Nfkw@mail.gmail.com>
Subject: Re: [RFC PATCH 5/6] security/fbfam: Detect a fork brute force attack
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, John Wood <john.wood@gmx.com>, 
	Matthew Wilcox <willy@infradead.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Luis Chamberlain <mcgrof@kernel.org>, Iurii Zaikin <yzaikin@google.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org, 
	kernel list <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Sep 11, 2020 at 1:49 AM Kees Cook <keescook@chromium.org> wrote:
> On Thu, Sep 10, 2020 at 01:21:06PM -0700, Kees Cook wrote:
> > From: John Wood <john.wood@gmx.com>
> >
> > To detect a fork brute force attack it is necessary to compute the
> > crashing rate of the application. This calculation is performed in each
> > fatal fail of a task, or in other words, when a core dump is triggered.
> > If this rate shows that the application is crashing quickly, there is a
> > clear signal that an attack is happening.
> >
> > Since the crashing rate is computed in milliseconds per fault, if this
> > rate goes under a certain threshold a warning is triggered.
> >
> > Signed-off-by: John Wood <john.wood@gmx.com>
> > ---
> >  fs/coredump.c          |  2 ++
> >  include/fbfam/fbfam.h  |  2 ++
> >  security/fbfam/fbfam.c | 39 +++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 43 insertions(+)
> >
> > diff --git a/fs/coredump.c b/fs/coredump.c
> > index 76e7c10edfc0..d4ba4e1828d5 100644
> > --- a/fs/coredump.c
> > +++ b/fs/coredump.c
> > @@ -51,6 +51,7 @@
> >  #include "internal.h"
> >
> >  #include <trace/events/sched.h>
> > +#include <fbfam/fbfam.h>
> >
> >  int core_uses_pid;
> >  unsigned int core_pipe_limit;
> > @@ -825,6 +826,7 @@ void do_coredump(const kernel_siginfo_t *siginfo)
> >  fail_creds:
> >       put_cred(cred);
> >  fail:
> > +     fbfam_handle_attack(siginfo->si_signo);
>
> I don't think this is the right place for detecting a crash -- isn't
> this only for the "dumping core" condition? In other words, don't you
> want to do this in get_signal()'s "fatal" block? (i.e. very close to the
> do_coredump, but without the "should I dump?" check?)
>
> Hmm, but maybe I'm wrong? It looks like you're looking at noticing the
> process taking a signal from SIG_KERNEL_COREDUMP_MASK ?
>
> (Better yet: what are fatal conditions that do NOT match
> SIG_KERNEL_COREDUMP_MASK, and should those be covered?)
>
> Regardless, *this* looks like the only place without an LSM hook. And it
> doesn't seem unreasonable to add one here. I assume it would probably
> just take the siginfo pointer, which is also what you're checking.

Good point, making this an LSM might be a good idea.

> e.g. for include/linux/lsm_hook_defs.h:
>
> LSM_HOOK(int, 0, task_coredump, const kernel_siginfo_t *siginfo);

I guess it should probably be an LSM_RET_VOID hook? And since, as you
said, it's not really semantically about core dumping, maybe it should
be named task_fatal_signal or something like that.
