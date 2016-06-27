Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFznPpS8rT_GLdAyHsr80B2FCb2Hm-4b9QTqREMCv6_s-Q@mail.gmail.com>
References: <cover.1466974736.git.luto@kernel.org> <f0a81fa3f7f81422cca23c9d6c88a555d89787ab.1466974736.git.luto@kernel.org>
 <CAMzpN2gBgZbBBJ_kAT=fty7=8z3xDyv2gzz9xuGLoK7EUuHh0A@mail.gmail.com>
 <CAMzpN2ggqbwkfNjHtYg3KU5oeerU6NPa0AqzG7PFtJuWy3dyKA@mail.gmail.com>
 <CALCETrWQCpNWum5WofkApw4Ht+KB5H=tmPS5GummTFsSVfNF7g@mail.gmail.com>
 <CALCETrXVtjPQHx2g_O3HRr-DNLWRpDL3Pftt2peoVrfNGiSucA@mail.gmail.com> <CA+55aFznPpS8rT_GLdAyHsr80B2FCb2Hm-4b9QTqREMCv6_s-Q@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 27 Jun 2016 10:30:31 -0700
Message-ID: <CALCETrW9aeSMq7b9OaxnN6zJBnhEDtQ85Q4UC2eoft5v59FvBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 15/29] x86/mm/64: Enable vmapped stacks
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Brian Gerst <brgerst@gmail.com>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 27, 2016 at 10:28 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jun 27, 2016 at 8:54 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> How about:
>>
>>     tsk_stack = (unsigned long)task_stack_page(tsk);
>>     if (regs->rsp <= tsk_stack + 7*8 && regs->rsp > tsk_stack - PAGE_SIZE) {
>
> I'm not at all convinced that regs->rsp will be all that reliable
> under a double-fault scenario either. I'd be more inclined to trusr
> cr2 than the register state.
>
> It's true that double faults can happen for *other* reasons entirely,
> and as such it's not clear that %cr2 is reliable either, but since
> this is all just about a printout, I'd rather go that way anyway.

Fair enough.  The chance that we get #GP-in-#GP or similar while CR2
coincidentally points to the guard page is quite low.  I'll add all
the details to the comment but I'll leave the code alone.

FWIW, the manual only says that CS and RIP are untrustworthy, not that
RSP is untrustworthy, but it doesn't specify *what* RSP would contain
anywhere I can find.  I don't think this is important enough to start
harassing the Intel and AMD folks over.

--Andy
