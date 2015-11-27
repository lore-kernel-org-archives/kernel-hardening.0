Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20151127075959.GA24991@gmail.com>
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>
	<CA+rthh-euk2hGGWjsDqXogWSmzmJNV1aiUVfnTfrzyQhndgbOQ@mail.gmail.com>
	<565595F5.32536.DB9FE75@pageexec.freemail.hu>
	<20151126085425.GA29848@gmail.com>
	<CALCETrXrvAY+mXx+JULw7W+xokcSPFgWm5-McJf9EKhYehPhbA@mail.gmail.com>
	<20151127075959.GA24991@gmail.com>
Date: Fri, 27 Nov 2015 10:00:36 -0800
Message-ID: <CA+55aFxH+Gy4U8WbGWXh+ybrvng8tw1=2CrjPnJSju3+c5XpbA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH 0/2] introduce post-init read-only memory
To: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, PaX Team <pageexec@freemail.hu>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mathias Krause <minipli@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86-ml <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, linux-arch <linux-arch@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 26, 2015 at 11:59 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Andy Lutomirski <luto@amacapital.net> wrote:
>
>> > Can you see any fragility in such a technique?
>>
>> After Linus shot down my rdmsr/rwmsr decoding patch, good luck...
>
> I think that case was entirely different, but I've Cc:-ed Linus to shoot my idea
> down if it's crap.

Yeah, no, I hate it. I'm with the PaX team on this one - I think there
are three valid responses, and I think we might want to have a dynamic
config option (kernel command line or proc or whatever) to pick
between the two:

 - just oops and kill the machine, like for any other unhandled kernel
page fault. This is probably what you should have on a server

 - print a warning and a backtrace, and just mark the page read-write
so that the machine survives, but we get notified and can fix whatever
broken code

 - have an option to disable the RO data logic.

I think that second option is good for debugging. In some places,
oopses that kill things are just too hard to debug (ie it might be the
modesetting or early boot or whatever).

In fact, I think we should _start_ with the second option - perhaps
just during the rc's - and then when we're pretty sure all the silly
bugs it finds (maybe none, who knows) are handled, we should go to the
first one.

The third option would be purely for "user that cannot fix things
directly and has reported the problem can now turn off the distracting
warning". We should never default to it.

Trying to actually *recover* any other way thanm by turning the area
read-write is just too damn fragile. You can't just skip over the
instruction that does the write - there are flags values etc that get
updated by read-modify-write instructions, but as PaX says, there nmay
also be subsequent logic that gets confused and actually introduces
even *more* problems downstream if the write is just discarded.

So maybe we could have some kind of "mark it read-only again later"
thing that tries to make sure it doesn't stay writable for a long
time, but quite frankly, I don't think it's worth it. Once the write
has been done, and the warning has been emitted, there's likely very
little upside to then trying to close the barn doors after that horse
has bolted.

                 Linus
