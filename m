Return-Path: <SRS0=9BVu=CY=lists.openwall.com=kernel-hardening-return-19899-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD579C43461
	for <kernel-hardening@archiver.kernel.org>; Tue, 15 Sep 2020 17:38:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7E57E20678
	for <kernel-hardening@archiver.kernel.org>; Tue, 15 Sep 2020 17:38:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="eeQDvAac"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E57E20678
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19899-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26241 invoked by uid 550); 15 Sep 2020 17:38:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26221 invoked from network); 15 Sep 2020 17:38:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1600191432;
	bh=NJ6O5rFyFRlQXoAS3XFVS8BQi/rApnd7lWRwhfK2Xlg=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eeQDvAacH1VlXwy4iH3Fxv2qyTjt32iVfeKBKyzgI7+LGScpg5JNVDryxc0pkFL7N
	 zqoJ1hZ3D0VN3JGismE3Z9ckMhtWuP06kvJvEVLGhRUkTahazF+9UvM7UneJRJLpW9
	 Z5eKxS0WNWMmopdQzAW4AkXHnNEFwNzlLAhdqHfM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Tue, 15 Sep 2020 19:36:27 +0200
From: John Wood <john.wood@gmx.com>
To: Jann Horn <jannh@google.com>
Cc: John Wood <john.wood@gmx.com>, Kees Cook <keescook@chromium.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Iurii Zaikin <yzaikin@google.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [RFC PATCH 5/6] security/fbfam: Detect a fork brute force attack
Message-ID: <20200915173627.GA2900@ubuntu>
References: <20200910202107.3799376-1-keescook@chromium.org>
 <20200910202107.3799376-6-keescook@chromium.org>
 <202009101634.52ED6751AD@keescook>
 <CAG48ez2fP7yupg6Th+Hg0tL3o06p2PR1HtQcvy4Ro+Q5T2Nfkw@mail.gmail.com>
 <20200913152724.GB2873@ubuntu>
 <CAG48ez3aQXb3EuGRVvLLo7BxycqJ4Y2mL83QhY9-QMK_qkfCuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez3aQXb3EuGRVvLLo7BxycqJ4Y2mL83QhY9-QMK_qkfCuQ@mail.gmail.com>
X-Provags-ID: V03:K1:+Tv9EY0th3c1INR7wYqsaQT1v7XmqULQmf1mCMF8tBv7us+6tmw
 383m5XxCtjIbCae841iMOqJ2Kb5mfB5OzM0d7bWnQ/N2gDAhnuzMcocEglMiEwyJSk3JQJY
 A8urH8HcByeEI58owhYnERH7vdI+cm29w8O8VDx8RuXDp3riBg1FpBliC3UfpGBZw8KurB1
 T/YoWfU4tpzRllQytfgJQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:4Yu2qoJjF0U=:HHZzV9mfG2ygAGqXu5SlIO
 b6fw//682jHONr9ldrDNb1XyJothxmBz6Vmqu5LRz+VzKi+Iobvg71yk1utVXXrr4ydn7w1i4
 Bo8DAIv8PN4nGmuQR0RWyRtNXdKVtbVhLrZ0aZNjY74rEbgcOZ5GvhU03dXUlp6uiVNWc8TqQ
 NGsPryfvIf3RXG18FTT4H8dvxc9A/Y6QFhgEv/z1GGEUNFkqS52ZarT2g5pt9KF1UNKJUNOG+
 rV2I1k1OS49aa+PEZcbx+C4I/mT7T2mB15tgn+t42ZMBKUYChBtQS1VZvuP2v29vNARx+8vUH
 McELVzXcPTYr5DuNcjjTYcfmow++F314PGCjv8akNZxqbrdRa+8sZ++pA9sKQ5XvRpsHrM2Ak
 KSxXaA5SjItMhrt9SttV05Zd4wVNNa5IK6KSAoESbQCF7XT3dscdb+CCO3cWaiqoeZCRLCFqi
 o4bOlv01jjtpTBD3UboqgTQBIPAcZsAMi8D8rzM7A/mJID5///rWiIPwQVccM8/0VBsdgBqOR
 e/kEkRQ6ngbozYc1hfQ2g3zEJEUe/wx7fc/IB0FE8cmZhQDiN23foVrbrebSKdIJO5j0pgk1a
 jz3wW4Y/A3oyDGMpsmuzCG4JkhpXEnVH0qogH2t8jb/sxii946biEIJX1YJiMxMugB0e0BAm9
 w8iZuq1aeviwjREDIGBOK/znjdQSDs8mDTxlEsRgYKpjebiHBtnkZlzRu/k+JJ5xOwR9kc0Y9
 mO0Fdl3Hh34SSKOiutb8SORvzXNnIRVpc3M7Vp/WyLRJLQ8PgL2znh+Iz3HzSxiwrW11BCiCv
 6SOjKvurvS/n5cvweUytu7zv3ZGkGcyT1Ysuee/GfgH809X/ExdqBIb3914Q6GdRH1pZGh+1F
 UPo7Ir5FJsba4vmFFpTTRycPRNP7YuiC7w89snTutAfOrHXwiQIzbqoJE5eX54BP11hzCOu+o
 kfSX6Q627hloSFcUUu+Qa4FeNLTSCDId4gHZ4s6PuDotn6DGIvbzvuB35j3FgZxZrgZshZg0+
 U/rivOUkkySAi5J9pHKIWcY4Pe+pZYs+5viKmvT1uqldov+53m53Bq8tnNzUNi1vA778qzrd8
 afJ7aIRJOoUeCmyAcuT0SrwjKu2GPVZZWN7iiuRHqHjcjLfxaoUq+Br+e2i2VF67MG0wFHoIf
 K71Wpu1k0LR0wCuAoUFm2wXJOIl+tFJMKd5Riwoy7QO8/52Tfoke+fdGEv7LLWDUZxPoEN1TX
 78MvWsWqHA0c669IvrfXYcskGlGCPN7xB8N4Bfg==
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 14, 2020 at 09:39:10PM +0200, Jann Horn wrote:
> On Sun, Sep 13, 2020 at 6:56 PM John Wood <john.wood@gmx.com> wrote:
> > On Fri, Sep 11, 2020 at 02:01:56AM +0200, Jann Horn wrote:
> > > On Fri, Sep 11, 2020 at 1:49 AM Kees Cook <keescook@chromium.org> wr=
ote:
> > > > On Thu, Sep 10, 2020 at 01:21:06PM -0700, Kees Cook wrote:
> > > > [...]
> > > > I don't think this is the right place for detecting a crash -- isn=
't
> > > > this only for the "dumping core" condition? In other words, don't =
you
> > > > want to do this in get_signal()'s "fatal" block? (i.e. very close =
to the
> > > > do_coredump, but without the "should I dump?" check?)
> > > >
> > > > Hmm, but maybe I'm wrong? It looks like you're looking at noticing=
 the
> > > > process taking a signal from SIG_KERNEL_COREDUMP_MASK ?
> > > >
> > > > (Better yet: what are fatal conditions that do NOT match
> > > > SIG_KERNEL_COREDUMP_MASK, and should those be covered?)
> > > >
> > > > Regardless, *this* looks like the only place without an LSM hook. =
And it
> > > > doesn't seem unreasonable to add one here. I assume it would proba=
bly
> > > > just take the siginfo pointer, which is also what you're checking.
> > >
> > > Good point, making this an LSM might be a good idea.
> > >
> > > > e.g. for include/linux/lsm_hook_defs.h:
> > > >
> > > > LSM_HOOK(int, 0, task_coredump, const kernel_siginfo_t *siginfo);
> > >
> > > I guess it should probably be an LSM_RET_VOID hook? And since, as yo=
u
> > > said, it's not really semantically about core dumping, maybe it shou=
ld
> > > be named task_fatal_signal or something like that.
> >
> > If I understand correctly you propose to add a new LSM hook without re=
turn
> > value and place it here:
> >
> > diff --git a/kernel/signal.c b/kernel/signal.c
> > index a38b3edc6851..074492d23e98 100644
> > --- a/kernel/signal.c
> > +++ b/kernel/signal.c
> > @@ -2751,6 +2751,8 @@ bool get_signal(struct ksignal *ksig)
> >                         do_coredump(&ksig->info);
> >                 }
> >
> > +               // Add the new LSM hook here
> > +
> >                 /*
> >                  * Death signals, no core dump.
> >                  */
>
> It should probably be in the "if (sig_kernel_coredump(signr)) {"
> branch. And I'm not sure whether it should be before or after
> do_coredump() - if you do it after do_coredump(), the hook will have
> to wait until the core dump file has been written, which may take a
> little bit of time.

But if the LSM hook is placed in the "if (sig_kernel_coredump(signr)) {"
branch, then only the following signals will be passed to it.

SIGQUIT, SIGILL, SIGTRAP, SIGABRT, SIGFPE, SIGSEGV, SIGBUS, SIGSYS,
SIGXCPU, SIGXFSZ, SIGEMT

The above signals are extracted from SIG_KERNEL_COREDUMP_MASK macro, and
are only related to coredump.

So, if we add a new LSM hook (named task_fatal_signal) to detect a fatal
signal it would be better to place it just above the if statement.

diff --git a/kernel/signal.c b/kernel/signal.c
index a38b3edc6851..406af87f2f96 100644
=2D-- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2736,6 +2736,8 @@ bool get_signal(struct ksignal *ksig)
                 */
                current->flags |=3D PF_SIGNALED;

+               // Place the new LSM hook here
+
                if (sig_kernel_coredump(signr)) {
                        if (print_fatal_signals)
                                print_fatal_signal(ksig->info.si_signo);

This way all the fatal signals are caught and we also avoid the commented
delay if a core dump is necessary.

Thanks,
John Wood

