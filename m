Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAMzpN2jAh4MTdRHfOmG7F7QWjyVeuWj8cjDpCWx8j7hYbQtSjw@mail.gmail.com>
References: <cover.1466974736.git.luto@kernel.org> <9eeb4be3c4e91d4155d0c4c234858f4259c5993d.1466974736.git.luto@kernel.org>
 <CAMzpN2hO-c+dKF+TnEn8GzWVton_=_5jKCU7g6bFb=SC=hfnoA@mail.gmail.com>
 <CALCETrXYtQUtLU-wF5YCxY9ZfNCDMZo1614Tg+FhcybPnCj4kw@mail.gmail.com> <CAMzpN2jAh4MTdRHfOmG7F7QWjyVeuWj8cjDpCWx8j7hYbQtSjw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 26 Jun 2016 17:40:22 -0700
Message-ID: <CALCETrWcRgU9fLYEeUQVv79BwwSF+ehhn_fyUNYg+99nePk+vA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 22/29] x86/asm: Move 'status' from struct thread_info
 to struct thread_struct
To: Brian Gerst <brgerst@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 26, 2016 at 5:36 PM, Brian Gerst <brgerst@gmail.com> wrote:
> On Sun, Jun 26, 2016 at 8:23 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Sun, Jun 26, 2016 at 4:55 PM, Brian Gerst <brgerst@gmail.com> wrote:
>>> On Sun, Jun 26, 2016 at 5:55 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>>> --- a/arch/x86/kernel/asm-offsets.c
>>>> +++ b/arch/x86/kernel/asm-offsets.c
>>>> @@ -30,7 +30,6 @@
>>>>  void common(void) {
>>>>         BLANK();
>>>>         OFFSET(TI_flags, thread_info, flags);
>>>> -       OFFSET(TI_status, thread_info, status);
>>>
>>> TI_status can be deleted.  It's last users were removed in commit ee08c6bd.
>>
>> Indeed.
>>
>> Just to double-check: are you saying that this patch is okay?
>
> It looks OK to me, but I haven't tested it.  Another suggestion is to
> change the compat flag to a bitfield, since there is only one TS_*
> flag now and it's not referenced from asm.

That could also work.

As a silly alternative thought: we just might be able to get away with
shoving the "is ia32" flag into one of the high bits of
pt_regs->orig_ax.  It wouldn't break any 32-bit ptrace users because
they can't see the high bits.  It wouldn't break most 64-bit ptrace
users because they use the silly PTRACE_GETREGSET API that doesn't
show the high bits if the tracee is "32-bit".  It would change
behavior when a 64-bit tracer traces a 64-bit process that does int
$0x80, but at least strace already gets that case completely wrong.

Of course, this proposal has all kinds of problems.

--Andy
