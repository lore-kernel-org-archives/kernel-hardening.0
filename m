Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Thu, 26 Nov 2015 09:54:25 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20151126085425.GA29848@gmail.com>
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>
 <CA+rthh-euk2hGGWjsDqXogWSmzmJNV1aiUVfnTfrzyQhndgbOQ@mail.gmail.com>
 <565595F5.32536.DB9FE75@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <565595F5.32536.DB9FE75@pageexec.freemail.hu>
Subject: Re: [kernel-hardening] [PATCH 0/2] introduce post-init read-only
 memory
To: PaX Team <pageexec@freemail.hu>
Cc: kernel-hardening@lists.openwall.com, Mathias Krause <minipli@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86-ml <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, linux-arch@vger.kernel.org, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


* PaX Team <pageexec@freemail.hu> wrote:

> On 25 Nov 2015 at 10:13, Mathias Krause wrote:
> 
> > I myself had some educating experience seeing my machine triple fault
> > when resuming from a S3 sleep. The root cause was a variable that was
> > annotated __read_only but that was (unnecessarily) modified during CPU
> > bring-up phase. Debugging that kind of problems is sort of a PITA, you
> > could imagine.

( Sidenote: I don't think a ro-faults typically result in triple faults, but yeah, 
  even having a regular oops (followed by a hang or reboot) during such an 
  undebuggable state of the system is a major PITA. )

> actually the kernel could silently recover from this given how the page fault 
> handler could easily determine that the fault address fell into the 
> data..read_only section and just silently undo the read-only property, log the 
> event to dmesg and retry the faulting access.

So a safer method would be to decode the faulting instruction, to skip it by 
fixing up the return RIP and to log the event. It would be mostly equivalent to 
trying to write to ROM (which get ignored as well), so it's a recoverable (and 
debuggable) event.

We have all the necessary code in place in the kprobes code, see 
arch/x86/lib/insn.c, it's a simplified x86 decoder that knows about instruction 
length (but not about semantics).

Simple skipping plus setting arithmetic flags to init value should be enough I 
think: I don't think we use fancy instructions to write to ro variables, such as 
PUSH/POP with other side effects. If such instructions exist we could minimally 
extend the decoder to do those fixups as well - in addition to double checking 
that we skip simple instructions only with no side effects.

Can you see any fragility in such a technique?

Thanks,

	Ingo
