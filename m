MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <3812aec2-682f-e95c-4d61-8e7eac33cc88@huawei.com>
References: <1496180392-98718-1-git-send-email-keescook@chromium.org>
 <1496180392-98718-4-git-send-email-keescook@chromium.org> <3812aec2-682f-e95c-4d61-8e7eac33cc88@huawei.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 29 Jun 2017 15:05:44 -0700
Message-ID: <CAGXu5jLzL3URMvF81EbH1Bt74MnwL9-25AU41yQnbEBcWA7J8Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] [PATCH v5 3/3] x86/refcount: Implement fast
 refcount overflow protection
To: Li Kun <hw.likun@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Peter Zijlstra <peterz@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, PaX Team <pageexec@freemail.hu>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Wangkai (Morgan, Euler)" <morgan.wang@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 28, 2017 at 9:13 PM, Li Kun <hw.likun@huawei.com> wrote:
> =E5=9C=A8 2017/5/31 5:39, Kees Cook =E5=86=99=E9=81=93:
>> +bool ex_handler_refcount(const struct exception_table_entry *fixup,
>> +                        struct pt_regs *regs, int trapnr)
>> +{
>> +       int reset;
>> +
>> +       /*
>> +        * If we crossed from INT_MAX to INT_MIN, the OF flag (result
>> +        * wrapped around) and the SF flag (result is negative) will be
>> +        * set. In this case, reset to INT_MAX in an attempt to leave th=
e
>> +        * refcount usable. Otherwise, we've landed here due to producin=
g
>> +        * a negative result from either decrementing zero or operating =
on
>> +        * a negative value. In this case things are badly broken, so we
>> +        * we saturate to INT_MIN / 2.
>> +        */
>> +       if (regs->flags & (X86_EFLAGS_OF | X86_EFLAGS_SF))
>> +               reset =3D INT_MAX;
>
>     Should it be like this to indicate that the refcount is wapped from
> INT_MAX to INT_MIN ?
>         if (regs->flags & (X86_EFLAGS_OF | X86_EFLAGS_SF)
>                 =3D=3D (X86_EFLAGS_OF | X86_EFLAGS_SF))
>
>                 reset =3D INT_MAX;

Ah yes, thanks for the catch. Yeah, that test is expecting both
condition flags to be set.

I'm still on the fence about the best way to deal with the bad states.
I've been pondering just strictly using a saturation value (INT_MIN /
2), which should offer the same system state protection (except for
the inherent resource leak), but that means there isn't really a good
way to kill an offending process (since after saturation ALL processes
will look like violators). It can be argued that killing the process
doesn't actually provide any benefit since the system is still safe,
though.

>> +       else
>> +               reset =3D INT_MIN / 2;
>> +       *(int *)regs->cx =3D reset;

Thanks for looking at this!

-Kees

--=20
Kees Cook
Pixel Security
