Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Mon, 12 Mar 2018 10:21:08 +0100
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH RFC v9 4/7] x86/entry: Erase kernel stack in
 syscall_trace_enter()
Message-ID: <20180312092108.d4ajuj7dk2jxgkon@gmail.com>
References: <CA+55aFwgmTaaA8QqMGm+VzRNbpKxDXbq2MtKyayyq8f+=PqWqA@mail.gmail.com>
 <CAKv+Gu_VaO39h8trgsNhU4JEVkdgoFWGoovBdmAL_YsHe7Nq1Q@mail.gmail.com>
 <CA+55aFxkzxhGaK=sp2CqM1YFEE=fL33wC1TR4KKqsRqPGto6yA@mail.gmail.com>
 <CAK8P3a0bWWZbFW5AFag=vRKC=PbCbwaLNPNiyk1ziJk=fTe0nQ@mail.gmail.com>
 <CA+55aFxTdT11pxKL7oscN=2bu8wkiZbZgDfQd_Emqk1Z1Qqb7A@mail.gmail.com>
 <20180306163616.7e3b6e0e@vmware.local.home>
 <CA+55aFze-do7sAvg1=z=Yb4p8J2EJ5Eyr6MLdMbgQKwMrO5hxQ@mail.gmail.com>
 <CA+55aFyv4wDxLQDbzB14HgW8ddu-w2VFteh5JQ57Jkw46mCVAw@mail.gmail.com>
 <20180312082226.ciggxv37cgcazs3j@gmail.com>
 <CAKv+Gu-N8mZNu5b4X_+dv37R6gLKn-3EdX+xa40t2bB6fgVTZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-N8mZNu5b4X_+dv37R6gLKn-3EdX+xa40t2bB6fgVTZg@mail.gmail.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>, Arnd Bergmann <arnd@arndb.de>, Daniel Micay <danielmicay@gmail.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@linux.intel.com>, Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> > Is it possible to implement this "safe automatic variable initialization" language
> > feature via a GCC plugin robustly, while still keeping code generation sane? (i.e.
> > no forced allocation of stack slots, etc.) It should be a superset of
> > CONFIG_GCC_PLUGIN_STRUCTLEAK=y.
> 
> I think that should be feasible, yes.
> 
> It would be worth trying whether the current code can be simplified, though: it 
> currently takes care not to add such an initialization if it can already spot 
> one, but I wonder whether just blindly adding one at the start and letting the 
> compiler optimize it away again is safer.

Absolutely - followed by:

 - a good look at the resulting code generation with a reasonably uptodate GCC

 - a look at the resulting code with older GCCs, to make sure there's no 
   pathological code generation

... because IMHO in the end it is the practical effects that will make (or break) 
any such attempt.

( BTW., initializing all automatic variables might even speed up certain
  optimization passes, FWIIW. )

Thanks,

	Ingo
