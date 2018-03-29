Subject: Re: [PATCH RFC v10 2/6] x86/entry: Add STACKLEAK erasing the kernel
 stack at the end of syscalls
References: <1522267032-6603-1-git-send-email-alex.popov@linux.com>
 <1522267032-6603-3-git-send-email-alex.popov@linux.com>
 <77fab6ea-0bbf-d68b-a38e-3e22d1ae6093@linux.intel.com>
 <16a56461-6501-7eb9-e1a4-761c9eff9386@linux.com>
 <ad614e86-7e39-e9b7-4a8f-3ea1f5a7b61d@linux.intel.com>
 <CAFUG7Cd7cSqSHCrqxKUFwBBQLuix0Mi5-=V6pq_U7KtFh20Kqg@mail.gmail.com>
 <ccb76413-0740-0f20-89fc-7a1c9053b06c@linux.com>
From: Dave Hansen <dave.hansen@linux.intel.com>
Message-ID: <df64b4d8-7780-4cb4-4b05-bd5842ea1a39@linux.intel.com>
Date: Thu, 29 Mar 2018 14:00:28 -0700
MIME-Version: 1.0
In-Reply-To: <ccb76413-0740-0f20-89fc-7a1c9053b06c@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: alex.popov@linux.com, Boris Lukashev <blukashev@sempervictus.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 03/29/2018 01:56 PM, Alexander Popov wrote:
> 
> If STACKLEAK is not banned, would you like me to introduce ERASE_KSTACK (for
> cases 1 and 3) and ERASE_KSTACK_NOCLOBBER (for case 2) in
> arch/x86/entry/calling.h?

Yes, please.  But, whatever you do, I think having each name have
constant behavior is a must.  Please don't have "ERASE_KSTACK" in one
file clobber and another not clobber (even if one is 32-bit and the
other is not).
