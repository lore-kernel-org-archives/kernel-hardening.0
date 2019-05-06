MIME-Version: 1.0
References: <CAOMdWSLNUEMux1hXfWP+oxZ3YG=uycDmAomGA1iTxjfyOYA0WQ@mail.gmail.com>
In-Reply-To: <CAOMdWSLNUEMux1hXfWP+oxZ3YG=uycDmAomGA1iTxjfyOYA0WQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 6 May 2019 09:11:30 -0700
Message-ID: <CAGXu5j+Eo-ewWL2_RtBaVN9msAdA3Pgu8H7uBxVcc=b5DMBy5g@mail.gmail.com>
Subject: Re: [RFC] refactor tasklets to avoid unsigned long argument
Content-Type: text/plain; charset="UTF-8"
To: Allen <allen.lkml@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, tglx@linuxtronix.de
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 6, 2019 at 2:32 AM Allen <allen.lkml@gmail.com> wrote:
>   I have been toying with the idea of "refactor tasklets to avoid
> unsigned long argument" since Kees listed on KSPP wiki. I wanted to
> and have kept the implementation very simple. Let me know what you
> guys think.
>
> Note: I haven't really done much of testing besides boot testing with small
> set of files moved to the new api.
>
>   My only concern with the implementation is, in the kernel the combination
> of tasklet_init/DECLARE_TAKSLET is seen in over ~400 plus files.
> With the change(dropping unsigned long argument) there will be huge list
> of patches migrating to the new api.

Yeah, this is the main part of the work for making this change. When
the timer API got changed, I had to do a two-stage change so we could
convert the users incrementally, and then finalize the API change to
drop the old style.

Beyond that, yeah, everything you sent looks good. It's just the
matter of building a series of patches to do it without breaking the
world. (Though if it's small enough, maybe it could be a single patch?
But I doubt that would be doable...)

-- 
Kees Cook
