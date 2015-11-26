Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20151126085425.GA29848@gmail.com>
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>
 <CA+rthh-euk2hGGWjsDqXogWSmzmJNV1aiUVfnTfrzyQhndgbOQ@mail.gmail.com>
 <565595F5.32536.DB9FE75@pageexec.freemail.hu> <20151126085425.GA29848@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 26 Nov 2015 08:11:41 -0800
Message-ID: <CALCETrXrvAY+mXx+JULw7W+xokcSPFgWm5-McJf9EKhYehPhbA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH 0/2] introduce post-init read-only memory
To: Ingo Molnar <mingo@kernel.org>
Cc: PaX Team <pageexec@freemail.hu>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mathias Krause <minipli@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86-ml <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, linux-arch <linux-arch@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 26, 2015 at 12:54 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * PaX Team <pageexec@freemail.hu> wrote:
>
>> On 25 Nov 2015 at 10:13, Mathias Krause wrote:
>>
>> > I myself had some educating experience seeing my machine triple fault
>> > when resuming from a S3 sleep. The root cause was a variable that was
>> > annotated __read_only but that was (unnecessarily) modified during CPU
>> > bring-up phase. Debugging that kind of problems is sort of a PITA, you
>> > could imagine.
>
> ( Sidenote: I don't think a ro-faults typically result in triple faults, but yeah,
>   even having a regular oops (followed by a hang or reboot) during such an
>   undebuggable state of the system is a major PITA. )
>
>> actually the kernel could silently recover from this given how the page fault
>> handler could easily determine that the fault address fell into the
>> data..read_only section and just silently undo the read-only property, log the
>> event to dmesg and retry the faulting access.
>
> So a safer method would be to decode the faulting instruction, to skip it by
> fixing up the return RIP and to log the event. It would be mostly equivalent to
> trying to write to ROM (which get ignored as well), so it's a recoverable (and
> debuggable) event.
>
> We have all the necessary code in place in the kprobes code, see
> arch/x86/lib/insn.c, it's a simplified x86 decoder that knows about instruction
> length (but not about semantics).
>
> Simple skipping plus setting arithmetic flags to init value should be enough I
> think: I don't think we use fancy instructions to write to ro variables, such as
> PUSH/POP with other side effects. If such instructions exist we could minimally
> extend the decoder to do those fixups as well - in addition to double checking
> that we skip simple instructions only with no side effects.
>
> Can you see any fragility in such a technique?
>

After Linus shot down my rdmsr/rwmsr decoding patch, good luck...

More seriously, though, I think this is mostly just like any other
in-kernel fault.  We failed, me might be under attack, let's oops.  In
the particular case of suspend/resume, we could consider a debug flag
to allow writes to these variables during suspend/resume.  In fact,
that might even be a reasonable default.  We might want to allow
writes during module unload as well.

For everything else, we should probably focus more on getting OOPSes
to display reliably, which is supposed to work but, on my shiny new
i915-based laptop, is clearly not ready yet (I oopsed it yesterday due
to my own bug and all I had to show for it was a blinking capslock
key, and yes, modesetting works).

--Andy
