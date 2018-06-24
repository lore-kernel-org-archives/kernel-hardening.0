Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sun, 24 Jun 2018 09:18:17 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v13 0/6] Introduce the STACKLEAK feature and a test for it
Message-ID: <20180624071817.GA32154@gmail.com>
References: <1527365430-8303-1-git-send-email-alex.popov@linux.com>
 <CAGXu5jJ9F-eZW5qVGebsv=wUh0kSm+edAecpztgvMC3fGeYXXA@mail.gmail.com>
 <CAGXu5jLU4En5Cf6KGf0Adpky-TF7aa=d9MTDqDKwxQuxZSLNEg@mail.gmail.com>
 <20180622013339.GA10129@gmail.com>
 <CAGXu5jJgmvqWzJ1kbq-zTsmwkcc9FPXgBdT9qf+Hc4tLcLh87w@mail.gmail.com>
 <CAGXu5j+bUEPZp1LAc82RDmvCXc=YnsOVP3FdzCX_4WsZTXcCBA@mail.gmail.com>
 <20180622031645.GA26826@gmail.com>
 <feb24168-9528-dfd0-be05-daea3e0b19b9@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <feb24168-9528-dfd0-be05-daea3e0b19b9@linux.com>
To: Alexander Popov <alex.popov@linux.com>
Cc: Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Alexander Popov <alex.popov@linux.com> wrote:

> On 22.06.2018 06:16, Ingo Molnar wrote:
> > 
> > * Kees Cook <keescook@chromium.org> wrote:
> > 
> >> On Thu, Jun 21, 2018 at 7:07 PM, Kees Cook <keescook@chromium.org> wrote:
> >>> It needs rebasing to -rc1 (which I've done already, but I'm still
> >>> doing build tests on it).
> >>
> >> It's passed basic allmodconfig builds:
> >>
> >> tree: https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git
> >> branch: for-next/stackleak
> > 
> > Ok, that's 6 patches - please send the latest for review as emails to lkml the 
> > usual. Thanks!
> 
> I'll resend the rebased v13 shortly.

Well, I assume there were v12->v13 changes, correct?

If yes, and if it's on a different base krnel, then why did you call it a 
'resend'? That will only get fewer people to review it ... Please don't do that 
for future iterations.

Thanks,

	Ingo
