Return-Path: <SRS0=dJL7=GW=lists.openwall.com=kernel-hardening-return-20668-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA6FC433E6
	for <kernel-hardening@archiver.kernel.org>; Tue, 19 Jan 2021 04:35:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 70891207A0
	for <kernel-hardening@archiver.kernel.org>; Tue, 19 Jan 2021 04:35:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 70891207A0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kaiwantech.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20668-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13761 invoked by uid 550); 19 Jan 2021 04:35:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13741 invoked from network); 19 Jan 2021 04:35:38 -0000
X-CMAE-Analysis: v=2.4 cv=VMcYI/DX c=1 sm=1 tr=0 ts=6006618d
 a=62Vrlwq93dyS4LaSTMevfw==:117 a=IkcTkHD0fZMA:10 a=EmqxpYm9HcoA:10
 a=pGLkceISAAAA:8 a=9vr8BnzVG96gFNSbxsUA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: kaiwan@kaiwantech.com
X-Gm-Message-State: AOAM530nyqfj75y4k16jy+DdJArpsvY+GRyC94xVYBAuMKSwvvMPfVq0
	893xT9mhs2UrIKd+tT4RGk+nnZ6pOZy36LMKOOo=
X-Google-Smtp-Source: ABdhPJz0r7vrYUw3z7gsYPwKEPEVuiSgalGCOodz7zAs+w8wsmDs5ru5RxydNPiwFhVZ8XJd00vziAdKjyYOqXKV72E=
X-Received: by 2002:a9d:2c43:: with SMTP id f61mr2091626otb.329.1611030919638;
 Mon, 18 Jan 2021 20:35:19 -0800 (PST)
MIME-Version: 1.0
References: <cover.1610722473.git.gladkov.alexey@gmail.com>
 <116c7669744404364651e3b380db2d82bb23f983.1610722473.git.gladkov.alexey@gmail.com>
 <CAHk-=wjsg0Lgf1Mh2UiJE4sqBDDo0VhFVBUbhed47ot2CQQwfQ@mail.gmail.com>
 <20210118194551.h2hrwof7b3q5vgoi@example.org> <CAHk-=wiNpc5BS2BfZhdDqofJx1G=uasBa2Q1eY4cr8O59Rev2A@mail.gmail.com>
 <20210118205629.zro2qkd3ut42bpyq@example.org>
In-Reply-To: <20210118205629.zro2qkd3ut42bpyq@example.org>
From: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Date: Tue, 19 Jan 2021 10:05:03 +0530
X-Gmail-Original-Message-ID: <CAPDLWs-fefTqAe+z-7BeALFpinanfPPd-9rmjKwUQ6WRP3_1Tg@mail.gmail.com>
Message-ID: <CAPDLWs-fefTqAe+z-7BeALFpinanfPPd-9rmjKwUQ6WRP3_1Tg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/8] Use refcount_t for ucounts reference counting
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, 
	io-uring <io-uring@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux Containers <containers@lists.linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Christian Brauner <christian.brauner@ubuntu.com>, "Eric W . Biederman" <ebiederm@xmission.com>, 
	Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>, Kees Cook <keescook@chromium.org>, 
	Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-CMAE-Envelope: MS4xfAshLg472alXoq+qTWuLcCL3KRKQEFcimIj1NXp6PTvMXUAW/i/lIPVVFb3EWSdaL0i73YnZV3WRE51kqi1RdOS3K/jfQVAFAwo4ehNjdn+/vNg7gO+r
 lYOk7pgWeyBvYZuIIyvNjeyfPx14ZZQul8ODv63Jea96mcXPd1zlLa4+naUAMXWkPPhC93UO9ueqw105EOyeHgs+3sPrLqQY9WdlYQ5QaCfAjuacY9qgWqRS

(Sorry for the gmail client)
My 0.2, HTH:
a) AFAIK, refcount_inc() (and similar friends) don't return any value
b) they're designed to just WARN() if they saturate or if you're
attempting to increment the value 0 (as it's possibly a UAF bug)
c) refcount_inc_checked() is documented as "Similar to atomic_inc(),
but will saturate at UINT_MAX and WARN"
d) we should avoid using the __foo() when foo() 's present as far as
is sanely possible...

So is one expected to just fix things when they break? - as signalled
by the WARN firing?

--
Regards, kaiwan.


On Tue, Jan 19, 2021 at 2:26 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
>
> On Mon, Jan 18, 2021 at 12:34:29PM -0800, Linus Torvalds wrote:
> > On Mon, Jan 18, 2021 at 11:46 AM Alexey Gladkov
> > <gladkov.alexey@gmail.com> wrote:
> > >
> > > Sorry about that. I thought that this code is not needed when switching
> > > from int to refcount_t. I was wrong.
> >
> > Well, you _may_ be right. I personally didn't check how the return
> > value is used.
> >
> > I only reacted to "it certainly _may_ be used, and there is absolutely
> > no comment anywhere about why it wouldn't matter".
>
> I have not found examples where checked the overflow after calling
> refcount_inc/refcount_add.
>
> For example in kernel/fork.c:2298 :
>
>    current->signal->nr_threads++;
>    atomic_inc(&current->signal->live);
>    refcount_inc(&current->signal->sigcnt);
>
> $ semind search signal_struct.sigcnt
> def include/linux/sched/signal.h:83             refcount_t              sigcnt;
> m-- kernel/fork.c:723 put_signal_struct                 if (refcount_dec_and_test(&sig->sigcnt))
> m-- kernel/fork.c:1571 copy_signal              refcount_set(&sig->sigcnt, 1);
> m-- kernel/fork.c:2298 copy_process                             refcount_inc(&current->signal->sigcnt);
>
> It seems to me that the only way is to use __refcount_inc and then compare
> the old value with REFCOUNT_MAX
>
> Since I have not seen examples of such checks, I thought that this is
> acceptable. Sorry once again. I have not tried to hide these changes.
>
> --
> Rgrds, legion
>
>
