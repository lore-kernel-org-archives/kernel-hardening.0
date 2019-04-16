MIME-Version: 1.0
References: <CAOfkYf7di0vusjs-woyqgUD3GGLAuP2drir=Td=3+TuE2sKvvA@mail.gmail.com>
 <CAGXu5jLSW==S9TL28Z7x-=3PCRVXXkxi4ce5YDu+X8nHfb71eQ@mail.gmail.com>
 <CAOfkYf4G_zV9v+GT4i=W+Zkkq32oPKFXH3E8kmMuDVS84r+AAQ@mail.gmail.com> <CAGXu5jJJbnhUMovTaG_U=vJijEWuWkM1dMoh6Mm4gUmN4Ua_Dg@mail.gmail.com>
In-Reply-To: <CAGXu5jJJbnhUMovTaG_U=vJijEWuWkM1dMoh6Mm4gUmN4Ua_Dg@mail.gmail.com>
From: Shyam Saini <mayhs11saini@gmail.com>
Date: Tue, 16 Apr 2019 09:14:12 +0530
Message-ID: <CAOfkYf4SiLvReac4H0-w1nZLwXQqZD8xAbN_dffzppcmH3S2Gg@mail.gmail.com>
Subject: Re: willing to involve in KSPP
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,


> > Hi Kees,
> >
> > > > I'm Shyam, currently working in linux kernel and embedded domain.
> > > >
> > > > I'm interested work in Kernel Self Protection Project.
> > > >
> > > > Would you please suggest which task should i pick ?
> > > >
> > > > I'd like to pick some simple task to get started.
> > > > I see a list of todo [1] but this page is not updated since 31st October
> > >
> > > I've updated this list now. Sorry for the delay!
> >
> > Thanks for this update.
> >
> > > > I don't have much experience in linux kernel so I'm not sure to pick which particular task,  please suggest me  some task.
> > >
> > > One item on there that looks pretty simple and would get you started
> > > would be to regularized the use of three different macros that all do
> > > the same thing: replace sizeof_field() and SIZEOF_FIELD() with the
> > > more common FIELD_SIZEOF()
> > >
> > > $ git grep '\bsizeof_field\b' | wc -l
> > > 30
> >
> > These are spreaded all over kernel source tree.
> >
> > > $ git grep '\bSIZEOF_FIELD\b' | wc -l
> > > 2
> >
> > This was added recently and I think we will need a checkpatch entry to
> > warn developers about this.
> >
> > > $ git grep '\bFIELD_SIZEOF\b' | wc -l
> > > 291
> > >
> > > Which likely means moving the FIELD_SIZEOF macro into
> > > include/linux/stddef.h for reuse in offsetofend().
> >
> > My only concern is, if it picked by different maintainers then it may
> > break some other trees.
> > I think it should be picked by single maintainer so which tree should
> > I submit these changes ?
>
> I would just make this a pair of patches: one that does the treewide
> changes in all files, and then one that removes the unused macros. I
> would CC Andrew Morton on the patch; he would likely be willing to
> take it.

Thanks a lot for your suggestion.

As you may already know that I've submitted the patch as per your
suggestion but I'm still not
sure how this FIELD macro uniformity in kernel is related to security.
Is there any future plans
based on this cleanup ?  Please excuse my lack of knowledge on the subject.
