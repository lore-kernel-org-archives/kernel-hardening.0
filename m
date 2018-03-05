Subject: Re: [PATCH RFC v9 0/7] Introduce the STACKLEAK feature and a test for
 it
References: <1520107232-14111-1-git-send-email-alex.popov@linux.com>
 <CAGXu5jKvTUkU5qLf+j9aB8G2xqKm7n3QLPBXaGnk_ewhG6=i_g@mail.gmail.com>
From: Dave Hansen <dave.hansen@linux.intel.com>
Message-ID: <39c52c1d-dba5-07f6-0838-2e8b368b40ed@linux.intel.com>
Date: Mon, 5 Mar 2018 11:42:07 -0800
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKvTUkU5qLf+j9aB8G2xqKm7n3QLPBXaGnk_ewhG6=i_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>, Alexander Popov <alex.popov@linux.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/05/2018 11:34 AM, Kees Cook wrote:
> Boris, Andy, and Dave (Hansen), you've all looked at this; would you
> be willing to give an Ack on the x86 parts? (Though I do now see a new
> comment from Dave was just sent.) And if not, what changes would you
> like to see?

I think it could definitely use another cleanup and de-#ifdef'ing pass.
It seems to have inherited the style from the original code and it's a
bit more than we're used to in mainline.
