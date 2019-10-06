Return-Path: <SRS0=gZbS=X7=lists.openwall.com=kernel-hardening-return-16992-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,GAPPY_SUBJECT,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38431C4360C
	for <kernel-hardening@archiver.kernel.org>; Sun,  6 Oct 2019 16:49:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 806A020835
	for <kernel-hardening@archiver.kernel.org>; Sun,  6 Oct 2019 16:49:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DRCGlzEt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 806A020835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16992-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18210 invoked by uid 550); 6 Oct 2019 16:49:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18162 invoked from network); 6 Oct 2019 16:49:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gitR6prE2tnQKW2d8vwg8C75oWlKUdv67rXVU7q0QOQ=;
        b=DRCGlzEtnAKAXsK/2hn1rAPa+00ur0pwb7bfnsPV4inoX1EZo9f+x/DVaJh3kTSbvi
         EwRDB6fUbQk1/rsy5egGmgH7bYlcXmGHzRajWercwPT1mZvXWa4HpuUmfY4pFtU0/3IC
         Somjz9/4ecpl/+/yIkZ7GAORqGj8k8bdBaTZWXsRp4KXVc2ycIcMdGM2IbFKi+Pxg31W
         kFatCmY+0Dy9QUmOdHaVpCrY2A2KPq+lIYzAbToHi0nxs6dptrLB9wgohM3H3Zr/nZm/
         PVEq146Ba46kpeaoXCqP1UbN7ZSRrQsxVJailmMq0xQbY9qTMOUGx0WvMQvJoH86IJJl
         s7ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gitR6prE2tnQKW2d8vwg8C75oWlKUdv67rXVU7q0QOQ=;
        b=hE6R5iSV5WNjVrb+MwzdBkUp27WFLAr5c2TclR8oVYGcZQF582dBkRivgpZVtvFjPo
         GUSEDykTBrRJQOGUHTfeIEIX6LT/HhPU2sncD4oc6+UkSPQ3SIMaaFn2l7YI/tVMHCwz
         czX18XsFbOMFql6HHcOr+fg2LOU5xeCYQ7fu+mZTzP4bVvgyLdHcBlHz857F+qS0Q1ro
         JYqJPBK94EwbVxcvJcPxflvmfclGn20VErYUL2bm70RGX1HeCRgXhDrDgzXe21hxV3SE
         TaZbG3IRF+RP4xcCuoFwOqA/sjdThm1SVng7ZN2Q6EXeDE1iCwMX5vl3HVXkAz5oJlq+
         pYwQ==
X-Gm-Message-State: APjAAAWf9t+7XESsWNz7z30SWGsOykBZlOibxBnDERuqqkWibZ9VKtZX
	vZEuq1sIXqy2+5Meap9V24iDMRMRM9dMCJ0NJrQ=
X-Google-Smtp-Source: APXvYqzGZYdzHVT/2p6rnwPtcBhy8+JdFhrM+z5AfNJSgF/qYn5iG9mbEGZsWcc2vspca5ATINmbfjn4WGtO7qG9mW4=
X-Received: by 2002:a05:6602:10d:: with SMTP id s13mr12183510iot.244.1570380576506;
 Sun, 06 Oct 2019 09:49:36 -0700 (PDT)
MIME-Version: 1.0
References: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com>
 <1562410493-8661-5-git-send-email-s.mesoraca16@gmail.com> <CAG48ez35oJhey5WNzMQR14ko6RPJUJp+nCuAHVUJqX7EPPPokA@mail.gmail.com>
 <CAJHCu1+35GhGJY8jDMPEU8meYhJTVgvzY5sJgVCuLrxCoGgHEg@mail.gmail.com>
In-Reply-To: <CAJHCu1+35GhGJY8jDMPEU8meYhJTVgvzY5sJgVCuLrxCoGgHEg@mail.gmail.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Sun, 6 Oct 2019 17:49:24 +0100
Message-ID: <CAJHCu1JobL7aj51=4gvaoXPfWH8aNdYXgcBDq90wV4_jN2iUfw@mail.gmail.com>
Subject: Re: [PATCH v5 04/12] S.A.R.A.: generic DFA for string matching
To: Jann Horn <jannh@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Brad Spengler <spender@grsecurity.net>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christoph Hellwig <hch@infradead.org>, 
	Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Thomas Gleixner <tglx@linutronix.de>, James Morris <jmorris@namei.org>, 
	John Johansen <john.johansen@canonical.com>
Content-Type: text/plain; charset="UTF-8"

Salvatore Mesoraca <s.mesoraca16@gmail.com> wrote:
>
> Jann Horn <jannh@google.com> wrote:
> >
> > On Sat, Jul 6, 2019 at 12:55 PM Salvatore Mesoraca
> > <s.mesoraca16@gmail.com> wrote:
> > > Creation of a generic Discrete Finite Automata implementation
> > > for string matching. The transition tables have to be produced
> > > in user-space.
> > > This allows us to possibly support advanced string matching
> > > patterns like regular expressions, but they need to be supported
> > > by user-space tools.
> >
> > AppArmor already has a DFA implementation that takes a DFA machine
> > from userspace and runs it against file paths; see e.g.
> > aa_dfa_match(). Did you look into whether you could move their DFA to
> > some place like lib/ and reuse it instead of adding yet another
> > generic rule interface to the kernel?
>
> Yes, using AppArmor DFA cloud be a possibility.
> Though, I didn't know how AppArmor's maintainers feel about this.
> I thought that was easier to just implement my own.
> Anyway I understand that re-using that code would be the optimal solution.
> I'm adding in CC AppArmor's maintainers, let's see what they think about this.

I don't want this to prevent SARA from being up-streamed.
Do you think that having another DFA here could be acceptable anyway?
Would it be better if I just drop the DFA an go back to simple string
matching to speed up things?

Thank you,

Salvatore
