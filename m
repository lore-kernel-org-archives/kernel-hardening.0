MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1522267032-6603-1-git-send-email-alex.popov@linux.com>
References: <1522267032-6603-1-git-send-email-alex.popov@linux.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 28 Mar 2018 13:13:48 -0700
Message-ID: <CAGXu5jKRs6Zi7+hDEsH3hW2zsAAQ0aiJoXaOpmxNjHC64ZABTw@mail.gmail.com>
Subject: Re: [PATCH RFC v10 0/6] Introduce the STACKLEAK feature and a test
 for it
Content-Type: text/plain; charset="UTF-8"
To: Alexander Popov <alex.popov@linux.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 28, 2018 at 12:57 PM, Alexander Popov <alex.popov@linux.com> wrote:
> This is the 10th version of the patch series introducing STACKLEAK to the
> mainline kernel. The previous version raised a fervent discussion[0].
> The assembly code introduced by v9 irritated the reviewers.

Thanks for persisting!

> I've found the way to bypass the obstacles[1] of the C implementation.
> So I dare come once again. Let me ask you to look at this code without
> preconception.

The assembly changes are now very minimal; thanks for reworking this.
I hope this addresses both Dave Hansen and Linus's (similar)
objections.

>  1. reduces the information that can be revealed through kernel stack leak bugs.
>     The idea of erasing the thread stack at the end of syscalls is similar to
>     CONFIG_PAGE_POISONING and memzero_explicit() in kernel crypto, which all
>     comply with FDP_RIP.2 (Full Residual Information Protection) of the
>     Common Criteria standard.

Agreed: I continue to believe this is meaningful even if just for
reducing the lifetime of sensitive data on the stack.

-Kees

-- 
Kees Cook
Pixel Security
