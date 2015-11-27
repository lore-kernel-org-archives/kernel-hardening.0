Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+mvknX69Kk1S8u54LR4T+KED8zZdkqQWA9KMrOvtVQtQ@mail.gmail.com>
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>
 <CA+rthh-euk2hGGWjsDqXogWSmzmJNV1aiUVfnTfrzyQhndgbOQ@mail.gmail.com>
 <565595F5.32536.DB9FE75@pageexec.freemail.hu> <20151126085425.GA29848@gmail.com>
 <CALCETrXrvAY+mXx+JULw7W+xokcSPFgWm5-McJf9EKhYehPhbA@mail.gmail.com>
 <20151127075959.GA24991@gmail.com> <CA+55aFxH+Gy4U8WbGWXh+ybrvng8tw1=2CrjPnJSju3+c5XpbA@mail.gmail.com>
 <CAGXu5j+mvknX69Kk1S8u54LR4T+KED8zZdkqQWA9KMrOvtVQtQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 27 Nov 2015 12:09:23 -0800
Message-ID: <CALCETrVVYMUgxABoEVfJgLtE+nB44aijqG5saq8dTQSTVWxbMA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH 0/2] introduce post-init read-only memory
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, PaX Team <pageexec@freemail.hu>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mathias Krause <minipli@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86-ml <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, linux-arch <linux-arch@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 27, 2015 at 12:03 PM, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Nov 27, 2015 at 10:00 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Thu, Nov 26, 2015 at 11:59 PM, Ingo Molnar <mingo@kernel.org> wrote:
>>>
>>> * Andy Lutomirski <luto@amacapital.net> wrote:
>>>
>>>> > Can you see any fragility in such a technique?
>>>>
>>>> After Linus shot down my rdmsr/rwmsr decoding patch, good luck...
>>>
>>> I think that case was entirely different, but I've Cc:-ed Linus to shoot my idea
>>> down if it's crap.
>>
>> Yeah, no, I hate it. I'm with the PaX team on this one - I think there
>> are three valid responses, and I think we might want to have a dynamic
>> config option (kernel command line or proc or whatever) to pick
>> between the two:
>>
>>  - just oops and kill the machine, like for any other unhandled kernel
>> page fault. This is probably what you should have on a server
>
> This is how the v2 series works now.
>
>>  - print a warning and a backtrace, and just mark the page read-write
>> so that the machine survives, but we get notified and can fix whatever
>> broken code
>
> This seems very easy to add. Should I basically reverse the effects of
> mark_rodata_ro(), or should I only make the new ro-after-init section
> as RW? (I think the former would be easier.)

I'd suggest verifying that the page in question is
.data..ro_after_init and, if so, marking that one page RW.

--Andy
