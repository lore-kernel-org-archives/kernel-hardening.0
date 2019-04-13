MIME-Version: 1.0
References: <CAOfkYf7di0vusjs-woyqgUD3GGLAuP2drir=Td=3+TuE2sKvvA@mail.gmail.com>
 <CAGXu5jLSW==S9TL28Z7x-=3PCRVXXkxi4ce5YDu+X8nHfb71eQ@mail.gmail.com>
In-Reply-To: <CAGXu5jLSW==S9TL28Z7x-=3PCRVXXkxi4ce5YDu+X8nHfb71eQ@mail.gmail.com>
From: Shyam Saini <mayhs11saini@gmail.com>
Date: Sat, 13 Apr 2019 17:53:31 +0530
Message-ID: <CAOfkYf4G_zV9v+GT4i=W+Zkkq32oPKFXH3E8kmMuDVS84r+AAQ@mail.gmail.com>
Subject: Re: willing to involve in KSPP
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,

> > I'm Shyam, currently working in linux kernel and embedded domain.
> >
> > I'm interested work in Kernel Self Protection Project.
> >
> > Would you please suggest which task should i pick ?
> >
> > I'd like to pick some simple task to get started.
> > I see a list of todo [1] but this page is not updated since 31st October
>
> I've updated this list now. Sorry for the delay!

Thanks for this update.

> > I don't have much experience in linux kernel so I'm not sure to pick which particular task,  please suggest me  some task.
>
> One item on there that looks pretty simple and would get you started
> would be to regularized the use of three different macros that all do
> the same thing: replace sizeof_field() and SIZEOF_FIELD() with the
> more common FIELD_SIZEOF()
>
> $ git grep '\bsizeof_field\b' | wc -l
> 30

These are spreaded all over kernel source tree.

> $ git grep '\bSIZEOF_FIELD\b' | wc -l
> 2

This was added recently and I think we will need a checkpatch entry to
warn developers about this.

> $ git grep '\bFIELD_SIZEOF\b' | wc -l
> 291
>
> Which likely means moving the FIELD_SIZEOF macro into
> include/linux/stddef.h for reuse in offsetofend().

My only concern is, if it picked by different maintainers then it may
break some other trees.
I think it should be picked by single maintainer so which tree should
I submit these changes ?


Thanks a lot,
Shyam
