MIME-Version: 1.0
In-Reply-To: <CAG48ez0=-nDmQVQiJtD_6ingdWWVJE+y+5_oWQrggQ9Eqg-UKQ@mail.gmail.com>
References: <20180827185631.163506-1-jannh@google.com> <20180827185631.163506-4-jannh@google.com>
 <CALCETrUeRA63Vt_LBOGmUHc_M9gc3J7+ewK6j+sB8P=9ijk7ag@mail.gmail.com> <CAG48ez0=-nDmQVQiJtD_6ingdWWVJE+y+5_oWQrggQ9Eqg-UKQ@mail.gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 27 Aug 2018 12:25:04 -0700
Message-ID: <CALCETrX6G68o=rjMjG1_02ZjqR9NYz9Byi8XOzqB+R8D=JzFCw@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] x86: stop calling fixup_exception() from kprobe_fault_handler()
Content-Type: text/plain; charset="UTF-8"
To: Jann Horn <jannh@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>, Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, kernel list <linux-kernel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, linux-edac <linux-edac@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 27, 2018 at 12:22 PM, Jann Horn <jannh@google.com> wrote:
> On Mon, Aug 27, 2018 at 9:02 PM Andy Lutomirski <luto@kernel.org> wrote:
>>
>> On Mon, Aug 27, 2018 at 11:56 AM, Jann Horn <jannh@google.com> wrote:
>> > This removes the call into exception fixup that was added in
>> > commit c28f896634f2 ("[PATCH] kprobes: fix broken fault handling for
>> > x86_64").
>> >
>> > On X86, kprobe_fault_handler() is called from two places:
>> > do_general_protection() (for #GP) and kprobes_fault() (for #PF).
>> > In both paths, the fixup_exception() call in the kprobe fault handler is
>> > redundant.
>> >
>> > For #GP, fixup_exception() is called immediately before
>> > kprobe_fault_handler() is invoked - if someone wanted to fix up our #GP,
>> > they've already done so, no need to try again. (This assumes that the
>> > kprobe's fault handler isn't going to do something crazy like changing RIP
>> > so that it suddenly points to an instruction that does userspace access.)
>>
>> This needs review by someone who understands kprobes better than I do.
>> What happens if someone puts a kprobe on a uaccess instruction and the
>> uaccess subsequently faults?
>
> Ugh, good point. I'll admit to not having thought about that properly.
>
> I think that's the "if (unlikely(regs->ip == (unsigned
> long)cur->ainsn.insn))" branch in kprobe_fault_handler(), which I'm
> not touching.
>
> For #PF, both without and with my patch, stuff should get fixed up by
> the normal pagefault handler, since the fixup happens after the kprobe
> handler has fiddled with the exception state.
>
> For #GP, we're already past the fixup call, and I think both without
> and with my patch, nothing will catch it - so I think that's a bug,
> but I don't think it's one I'm introducing.

Fair enough.  If there is indeed a problem, it'll be easier to fix
sanely with your patch applied :)
