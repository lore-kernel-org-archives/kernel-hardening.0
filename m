Return-Path: <SRS0=v9S1=VS=lists.openwall.com=kernel-hardening-return-16505-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A03CC76191
	for <kernel-hardening@archiver.kernel.org>; Sun, 21 Jul 2019 17:56:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 28DEF20828
	for <kernel-hardening@archiver.kernel.org>; Sun, 21 Jul 2019 17:56:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zditk+EE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 28DEF20828
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16505-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15964 invoked by uid 550); 21 Jul 2019 17:55:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15903 invoked from network); 21 Jul 2019 17:55:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1kSmViq8cmCLQ/gqq383VkiQLEoo1u+lPjehpk+6x40=;
        b=Zditk+EE8AoI0s6SSo+ZL42+o60GiTqnrwxy+JTf2pGGNDVep1v04udF+FHgDuw/ra
         Y4k81z6aj8rSpyzIIbUXQPM6tVb577e7aNaHgUF30R2ff0OWH1Hli2uE6Qx1zr4XJtNW
         hqenafZ21RHq/Ju96cC/2BlsJx2iCjoGzo5SApcfRhVmNUC4vEmF0kdd2Ib+pkYO7u9F
         QdJQNyXPAkfcO3VIBlSQt/RiefUzbFgQ2wsQu3jUYyRxWUKbehLNwNnBXK/Vh6hH1Vap
         Mm1glgSIfCdfrqjc5IwMapj6anz9zzPP8Ri0MVJy1L2/tR9c+bu3bA8WRqG3cFH6sQlc
         ussw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1kSmViq8cmCLQ/gqq383VkiQLEoo1u+lPjehpk+6x40=;
        b=nVnRonb1S6e2VtqEzrKOm9k4zlLy7d214t1k5b84Pxxk6v84NdJvAj71u6lWbnpish
         rWu8po1K0lAExv6Ddb8+Xrv4EWOKwdkDXT503ic6XsLwPdUAMxJosAaJlxV6A2LqQSqv
         DjrY65JQ+a/LLEnLpchosozP3f6WsiqmUwHnDYUCfyuyfa9TugCqUghv9hNk1jJY+pqg
         5HSka8FNM4dLk1hkxyNLUDbLmZKz/hhYhGEkBayJB7QwFToiN70E+pDIFOhoM3qWr5FB
         nT/vDlDKuCJ6+X+WInylkrRXq7SaHgLnZ1A9TfsW+LGbyvsWgSwpZ8b4AO3zGhjubcdp
         RvNw==
X-Gm-Message-State: APjAAAUtIC7jhjRz70cQLJ1d8HgQTP7zRpQkNiEp9fByX9WlSW9hT0EN
	1gjpWlodCPgRo0e+KxJT5InA5s7shG6GJw3xFBI=
X-Google-Smtp-Source: APXvYqwQFCyzOq+kuLCzYzTRmvP++8ZC2fDz6008MK23+PhkhaaijdrDAZpE3GWM8MqQsAL52BtCHoR8vZD/y1tEOrQ=
X-Received: by 2002:a17:90a:17a6:: with SMTP id q35mr72691233pja.118.1563731744562;
 Sun, 21 Jul 2019 10:55:44 -0700 (PDT)
MIME-Version: 1.0
References: <CABgxDoJzu-Pfq78AYJmf61KqJ2A3YXNJ7jMSS6p3kCzhFox0=w@mail.gmail.com>
 <201907020849.FB210CA@keescook> <CABgxDoJ6ra4DoPzEk8w25e0iTSHtNuYanHT-s+30JSzjfWestQ@mail.gmail.com>
 <201907031513.8E342FF@keescook>
In-Reply-To: <201907031513.8E342FF@keescook>
From: Romain Perier <romain.perier@gmail.com>
Date: Sun, 21 Jul 2019 19:55:33 +0200
Message-ID: <CABgxDoLz76_nTqpdqMMH6+i1ia3k2bgiHkTV4Gc9X7vCe=CKRA@mail.gmail.com>
Subject: Re: refactor tasklets to avoid unsigned long argument
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Shyam Saini <mayhs11saini@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ok, thanks for these explanations.

The task is in progress, you can follow the status here :
https://salsa.debian.org/rperier-guest/linux-tree/tree/tasklet_init
(the commit messages are tagged WIP, I will add a long message and
signed-off-by , when it's done)

Regards,
Romain

Le jeu. 4 juil. 2019 =C3=A0 00:46, Kees Cook <keescook@chromium.org> a =C3=
=A9crit :
>
> On Wed, Jul 03, 2019 at 05:48:42PM +0200, Romain Perier wrote:
> > Mhhh, so If I understand it right, the purpose of this task is to
> > remove the "unsigned long data"  argument passed to tasklet_init() ,
> > that
> > is mostly used to pass the pointer of the parent structure that
> > contains the tasklet_struct to the handler.
>
> Right. The idea being that when a tasklet is stored in memory, it no
> longer contains both the callback function pointer AND the argument to
> pass it. This is the same problem that existed for struct timer_list.
> You can see more details about this in at the start of the timer_list
> refactoring:
> https://git.kernel.org/linus/686fef928bba6be13cabe639f154af7d72b63120
>
> > We don't change the API of tasklet, we simply remove the code that use
> > this "unsigned long data" wrongly to pass the pointer of the parent
> > structure
> > (by using container_of() or something equivalent).
>
> Kind of. In the timer_list case, there were some places were actual data
> (and not a pointer) was being passed -- those needed some thought to
> convert sanely. I'm hoping that the tasklets are a much smaller part of
> the kernel and won't pose as much of a problem, but I haven't studied
> it.
>
> > For example this is the case in:   drivers/firewire/ohci.c   or
> > drivers/s390/block/dasd.c  .
>
> Right:
>
> struct ar_context {
>         ...
>         struct tasklet_struct tasklet;
> };
>
> static void ar_context_tasklet(unsigned long data)
> {
>         struct ar_context *ctx =3D (struct ar_context *)data;
> ...
>
> static int ar_context_init(...)
> {
>         ...
>         tasklet_init(&ctx->tasklet, ar_context_tasklet, (unsigned long)ct=
x);
>
>
> this could instead be:
>
> static void ar_context_tasklet(struct tasklet_struct *tasklet)
> {
>         struct ar_context *ctx =3D container_of(tasklet, typeof(*ctx), ta=
sklet);
> ...
>
> static int ar_context_init(...)
> {
>         ...
>         tasklet_setup(&ctx->tasklet, ar_context_tasklet);
>
> > Several question come:
> >
> > 1. I am not sure but, do we need to modify the prototype of
> > tasklet_init() ?  well, this "unsigned long data" might be use for
> > something else that pass the pointer of the parent struct. So I would
> > say "no"
>
> Yes, the final step in the refactoring would be to modify the tasklet_ini=
t()
> prototype. I've included some example commits from the timer_list
> refactoring, but look at the history of include/linux/timer.h and
> kernel/time/timer.c for more details.
>
> I would expect the refactoring to follow similar changes to timer_list:
>
> - add a new init API (perhaps tasklet_setup() to follow timer_setup()?)
>   that passes the tasklet pointer to tasklet_init(), and casts the
>   callback.
>         https://git.kernel.org/linus/686fef928bba6be13cabe639f154af7d72b6=
3120
> - convert all users to the new prototype
>         https://git.kernel.org/linus/e99e88a9d2b067465adaa9c111ada99a041b=
ef9a
> - remove the "data" member and convert the callback infrastructure to
>   pass the tasklet pointer
>         https://git.kernel.org/linus/c1eba5bcb6430868427e0b9d1cd1205a0730=
2f06
> - and then clean up anything (cast macros, etc)
>         https://git.kernel.org/linus/354b46b1a0adda1dd5b7f0bc2a5604cca091=
be5f
>
> Hopefully tasklet doesn't have a lot of open-coded initialization. This
> is what made timer_list such a challenge. Stuff like this:
>         https://git.kernel.org/linus/b9eaf18722221ef8b2bd6a67240ebe668622=
152a
>
> > 2. In term of security, this is a problem ? Or this is just an
> > improvement to force developpers to do things correctly ?
>
> It's a reduction in attack surface (attacker has less control
> over the argument if the function pointer is overwritten) and it
> provides a distinct prototype for CFI, to make is separate from other
> functions that take a single unsigned long argument (e.g. before the
> timer_list refactoring, all timer callbacks had the same prototype as
> native_write_cr4(), making them a powerful target to control on x86).
>
> For examples of the timer_list attacks (which would likely match a
> tasklet attack if one got targeted), see "retire_blk_timer" in:
> https://googleprojectzero.blogspot.com/2017/05/exploiting-linux-kernel-vi=
a-packet.html
>
> There's also some more detail on the timer_list work in my blog post
> for v4.15:
> https://outflux.net/blog/archives/2018/02/05/security-things-in-linux-v4-=
15/
>
> > I will update the WIKI
>
> Awesome!
>
> Thanks for looking at this! I hope it's not at bad as timer_list. :)
>
> --
> Kees Cook
