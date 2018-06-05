MIME-Version: 1.0
References: <20180529221625.33541-1-thgarnie@google.com> <20180529221625.33541-22-thgarnie@google.com>
 <20180604161612.6d48d8d2@gandalf.local.home> <CAJcbSZG1dVBVeOjEDeTm4mwXS60wMi-5ej_FB+YyS7iwXoebOQ@mail.gmail.com>
 <20180604174431.4aabfbf1@gandalf.local.home> <CAJcbSZGc7PjLTaoosZFPHpzfDGteE0fWrYS9g_GMBxMAegjfwQ@mail.gmail.com>
In-Reply-To: <CAJcbSZGc7PjLTaoosZFPHpzfDGteE0fWrYS9g_GMBxMAegjfwQ@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 5 Jun 2018 14:19:40 -0700
Message-ID: <CAJcbSZGDuJWuKKHkSi9N9iG12gzBQXawHtmmA4CtHPiP_uPRMA@mail.gmail.com>
Subject: Re: [PATCH v4 21/27] x86/ftrace: Adapt function tracing for PIE support
Content-Type: text/plain; charset="UTF-8"
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Francis Deslauriers <francis.deslauriers@efficios.com>, Greg KH <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Guenter Roeck <linux@roeck-us.net>, nixiaoming <nixiaoming@huawei.com>, James Hogan <jhogan@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 5, 2018 at 9:56 AM Thomas Garnier <thgarnie@google.com> wrote:
>
> On Mon, Jun 4, 2018 at 2:44 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Mon, 4 Jun 2018 14:06:03 -0700
> > Thomas Garnier <thgarnie@google.com> wrote:
> >
> > > On Mon, Jun 4, 2018 at 1:16 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> > > >
> > > > On Tue, 29 May 2018 15:15:22 -0700
> > > > Thomas Garnier <thgarnie@google.com> wrote:
> > > >
> > > > > When using -fPIE/PIC with function tracing, the compiler generates a
> > > > > call through the GOT (call *__fentry__@GOTPCREL). This instruction
> > > > > takes 6 bytes instead of 5 on the usual relative call.
> > > > >
> > > > > If PIE is enabled, replace the 6th byte of the GOT call by a 1-byte nop
> > > > > so ftrace can handle the previous 5-bytes as before.
> > > > >
> > > > > Position Independent Executable (PIE) support will allow to extend the
> > > > > KASLR randomization range 0xffffffff80000000.
> > > >
> > > > I thought you were going to write a update to recordmcount.c to handle
> > > > this at compile time?
> > >
> > > I can correctly calculate the start of the call instruction with
> > > recordmcount (no need for addr-1) but I still need to handle the
> > > different size of the instructions. I don't think I can completely
> > > replace the GOT call with a relative call. Maybe I am missing
> > > something on the way recordmcount is used? Should it replace all
> > > mcount locations with a nop slide? Why is it done at runtime too then?
> >
> > Because we need to figure out the "ideal nop" thus we need to change it
> > regardless.
>
> I see what you mean looking at the different ideal_nops based on configurations.
>
> >
> > We could have recordmcount.c replace everything with the default nop
> > (I've thought of that before), and then we could update with the ideal
> > nop at run time, if that helps with this.
>
> I don't think that's necessary. In proposed implementation of PIE,
> kernel modules would not use a GOT call. In the current implementation
> the __fentry__ call is always GOT based (6-bytes). I will simplify the
> runtime implementation in the next patch set to just swap the expected
> size and ideal_nop when PIE is enabled.

Actually moving the logic from 5-bytes to 6-bytes is much more
complicated, that's why I went with this approach before. I don't
think it can be improved much more beyond creating a nop slide in
mrecordcount but that's a different approach. I will clean-up the code
a bit for the next iteration but that's about it. Let me know what you
think.

>
> >
> > -- Steve
>
>
>
> --
> Thomas



-- 
Thomas
