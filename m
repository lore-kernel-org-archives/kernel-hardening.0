MIME-Version: 1.0
In-Reply-To: <CAGXu5jJ2DykaU6bbFGRcOaZK9nn5dFUYQ6UjXCq9Y97DwYpCyA@mail.gmail.com>
References: <1497544976-7856-1-git-send-email-s.mesoraca16@gmail.com>
 <1497544976-7856-7-git-send-email-s.mesoraca16@gmail.com> <CAGXu5jJ2DykaU6bbFGRcOaZK9nn5dFUYQ6UjXCq9Y97DwYpCyA@mail.gmail.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Thu, 29 Jun 2017 21:30:58 +0200
Message-ID: <CAJHCu1JxUA0b3mu4Z=NPBdCRv6SfmCKEQ5jGaMsLg2Q_9tm25g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC v2 6/9] Creation of "pagefault_handler_x86" LSM hook
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux-MM <linux-mm@kvack.org>, "x86@kernel.org" <x86@kernel.org>, Jann Horn <jannh@google.com>, Christoph Hellwig <hch@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

2017-06-28 1:07 GMT+02:00 Kees Cook <keescook@chromium.org>:
> On Thu, Jun 15, 2017 at 9:42 AM, Salvatore Mesoraca
> <s.mesoraca16@gmail.com> wrote:
>> Creation of a new hook to let LSM modules handle user-space pagefaults on
>> x86.
>> It can be used to avoid segfaulting the originating process.
>> If it's the case it can modify process registers before returning.
>> This is not a security feature by itself, it's a way to soften some
>> unwanted side-effects of restrictive security features.
>> In particular this is used by S.A.R.A. can be used to implement what
>> PaX call "trampoline emulation" that, in practice, allow for some specific
>> code sequences to be executed even if they are in non executable memory.
>> This may look like a bad thing at first, but you have to consider
>> that:
>> - This allows for strict memory restrictions (e.g. W^X) to stay on even
>>   when they should be turned off. And, even if this emulation
>>   makes those features less effective, it's still better than having
>>   them turned off completely.
>> - The only code sequences emulated are trampolines used to make
>>   function calls. In many cases, when you have the chance to
>>   make arbitrary memory writes, you can already manipulate the
>>   control flow of the program by overwriting function pointers or
>>   return values. So, in many cases, the "trampoline emulation"
>>   doesn't introduce new exploit vectors.
>> - It's a feature that can be turned on only if needed, on a per
>>   executable file basis.
>
> Can this be made arch-agnostic? It seems a per-arch register-handling
> routine would be needed, though. :(

S.A.R.A.'s "pagefault_handler_x86" implementation is fully arch specific
so it won't benefit too much from this change.
Anyway having a single hook for all archs is probably a cleaner solution,
I'll change it in the v3.
Would it be OK if I make it arch-agnostic while I actually keep it only
in arch/x86/mm/fault.c?
Thank you for your help.

Salvatore
