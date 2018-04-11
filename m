MIME-Version: 1.0
In-Reply-To: <CAGXu5jKXMx1hzQX6g=Y51mdTgHoYp4vuVUvri3=s7Fn9NgmZmA@mail.gmail.com>
References: <1519729200-16056-1-git-send-email-s.mesoraca16@gmail.com>
 <CAGXu5jKYSRqsHo8rqvyR1ZLQ2MT+UnG=F4_RTEp7Sq9q9qsPtw@mail.gmail.com>
 <CAGXu5j+RELwBqkLrpQ0zHdHM3u2FxgcKokumtSS8KpkCeUgT2g@mail.gmail.com>
 <CAJHCu1LAvw5N8cXr-L8goEXUN5+jAdC4aUv3jNW0FxO9W_VH1w@mail.gmail.com> <CAGXu5jKXMx1hzQX6g=Y51mdTgHoYp4vuVUvri3=s7Fn9NgmZmA@mail.gmail.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Wed, 11 Apr 2018 08:09:49 +0200
Message-ID: <CAJHCu1LCwxRmcMr0V4GavxT4DEiS1PMUTSQ_XyVrcXYHCcQdBQ@mail.gmail.com>
Subject: Re: [PATCH v4] Protected FIFOs and regular files
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Alexander Viro <viro@zeniv.linux.org.uk>, David Laight <David.Laight@aculab.com>, Ian Campbell <ijc@hellion.org.uk>, Jann Horn <jannh@google.com>, Matthew Wilcox <willy@infradead.org>, Pavel Vasilyev <dixlor@gmail.com>, Solar Designer <solar@openwall.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Tobin C. Harding" <me@tobin.cc>
List-ID: <kernel-hardening.lists.openwall.com>

2018-04-10 23:23 GMT+02:00 Kees Cook <keescook@chromium.org>:
> On Wed, Feb 28, 2018 at 1:22 AM, Salvatore Mesoraca
> <s.mesoraca16@gmail.com> wrote:
>> 2018-02-27 21:22 GMT+01:00 Kees Cook <keescook@chromium.org>:
>>> On Tue, Feb 27, 2018 at 11:47 AM, Kees Cook <keescook@chromium.org> wrote:
>>>> [...]
>>>>
>>>> I think this looks great.
>>>>
>>>> Acked-by: Kees Cook <keescook@chromium.org>
>>>
>>> Tested-by: Kees Cook <keescook@chromium.org>
>>
>> Awesome! Thank you very much for your help!
>
> Salvatore, do you want to send this again as a v5 with my two
> follow-up patches, as I have them here:
> https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=kspp/userspace/protected-creat
>
> or would you like me to send those?

I have no preference. You can send them, if you want to.
I have no problem in either case.

> I would expect this series to land
> via the -mm tree, since that tends to be the catch-all. (In which
> case, the series should be To: akpm with everyone else in Cc.)

Salvatore
