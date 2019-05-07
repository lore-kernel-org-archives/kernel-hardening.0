MIME-Version: 1.0
References: <CAOMdWSLNUEMux1hXfWP+oxZ3YG=uycDmAomGA1iTxjfyOYA0WQ@mail.gmail.com>
 <CAGXu5j+Eo-ewWL2_RtBaVN9msAdA3Pgu8H7uBxVcc=b5DMBy5g@mail.gmail.com>
In-Reply-To: <CAGXu5j+Eo-ewWL2_RtBaVN9msAdA3Pgu8H7uBxVcc=b5DMBy5g@mail.gmail.com>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 7 May 2019 11:25:21 +0530
Message-ID: <CAOMdWSJPHks4GkzDFk1_M5HLZUoT9G_P=MiEAwGSp2zJ6-NM=A@mail.gmail.com>
Subject: Re: [RFC] refactor tasklets to avoid unsigned long argument
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, tglx@linuxtronix.de
List-ID: <kernel-hardening.lists.openwall.com>

> >   My only concern with the implementation is, in the kernel the combination
> > of tasklet_init/DECLARE_TAKSLET is seen in over ~400 plus files.
> > With the change(dropping unsigned long argument) there will be huge list
> > of patches migrating to the new api.
>
> Yeah, this is the main part of the work for making this change. When
> the timer API got changed, I had to do a two-stage change so we could
> convert the users incrementally, and then finalize the API change to
> drop the old style.
>
> Beyond that, yeah, everything you sent looks good. It's just the
> matter of building a series of patches to do it without breaking the
> world. (Though if it's small enough, maybe it could be a single patch?
> But I doubt that would be doable...)

 Thank you.

 I like the idea of two-stage approach. For first stage, I was thinking of all
the architectures with their default configs(Nothing gets broken when
defconf's are tried) and for second stage the rest of drivers etc..

Thoughts?

Either ways, I will convert and get them pushed to github, we could see how
best it could be taken to upstream once it's done.

       - Allen
