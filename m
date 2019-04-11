MIME-Version: 1.0
References: <CAOfkYf7di0vusjs-woyqgUD3GGLAuP2drir=Td=3+TuE2sKvvA@mail.gmail.com>
In-Reply-To: <CAOfkYf7di0vusjs-woyqgUD3GGLAuP2drir=Td=3+TuE2sKvvA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 11 Apr 2019 14:55:16 -0700
Message-ID: <CAGXu5jLSW==S9TL28Z7x-=3PCRVXXkxi4ce5YDu+X8nHfb71eQ@mail.gmail.com>
Subject: Re: willing to involve in KSPP
Content-Type: text/plain; charset="UTF-8"
To: Shyam Saini <mayhs11saini@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 10, 2019 at 6:34 AM Shyam Saini <mayhs11saini@gmail.com> wrote:
>  Hello Everyone,

Hi!

> I'm Shyam, currently working in linux kernel and embedded domain.
>
> I'm interested work in Kernel Self Protection Project.
>
> Would you please suggest which task should i pick ?
>
> I'd like to pick some simple task to get started.
> I see a list of todo [1] but this page is not updated since 31st October

I've updated this list now. Sorry for the delay!

> I don't have much experience in linux kernel so I'm not sure to pick which particular task,  please suggest me  some task.

One item on there that looks pretty simple and would get you started
would be to regularized the use of three different macros that all do
the same thing: replace sizeof_field() and SIZEOF_FIELD() with the
more common FIELD_SIZEOF()

$ git grep '\bsizeof_field\b' | wc -l
30
$ git grep '\bSIZEOF_FIELD\b' | wc -l
2
$ git grep '\bFIELD_SIZEOF\b' | wc -l
291

Which likely means moving the FIELD_SIZEOF macro into
include/linux/stddef.h for reuse in offsetofend().

> Looking forward to hearing from you.
>
> [1] https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Work
>
>
> Thanks a lot,

Thanks for reaching out!

-- 
Kees Cook
