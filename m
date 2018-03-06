Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Tue, 6 Mar 2018 08:56:07 +0100
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [OLD PATCH] net: recvmsg: Unconditionally zero struct
 sockaddr_storage Re: [PATCH RFC v9 4/7] x86/entry: Erase kernel stack in
 syscall_trace_enter()
Message-ID: <20180306075607.57t7eab2zkquhssm@gmail.com>
References: <1520107232-14111-1-git-send-email-alex.popov@linux.com>
 <1520107232-14111-5-git-send-email-alex.popov@linux.com>
 <b52a2cca-cb5c-d47f-131e-7db297f78958@linux.intel.com>
 <CAGXu5jLRpJ7ktij4TpaSG-RZLOou=RWyY_=jTMNE87+E4Xp2Ag@mail.gmail.com>
 <CA+55aFxEAYyrUkApo-dtZvxcYbvWBZJpUytjbm7e2wruTvbYjQ@mail.gmail.com>
 <CAGXu5j+-AjMKxOYDOpbmJ4X357JRGWViAOmqyqd6bu_w47mffw@mail.gmail.com>
 <CA+55aFxpzgQiJg8XyQTH-hDHd7A0jRAtOJ8b6krrvNDQX96Vrw@mail.gmail.com>
 <CAGXu5jJaTR25zZp5sGqc6m3nv3AunYhEZhxtB_JuP2WFbv_pfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJaTR25zZp5sGqc6m3nv3AunYhEZhxtB_JuP2WFbv_pfg@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>, Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> In defense of the series, it's hardly "mindless". :) The primary
> feature is that it has run-time tracking of stack depth to clear only
> the minimum needed portion of the stack.

The stack-tracer has been able to do that for years, right?

> > And it doesn't necessarily generate any worse code.
> 
> I agree, though some performance-sensitive subsystem (e.g. networking)
> get very defensive about an always-on stack initialization[2].

> [2] Both these cases, and so many more, are solved with the byref
> initialization plugin, but have been NAKed by -net:
>      https://lkml.org/lkml/2013/4/9/641
>      https://lkml.org/lkml/2017/10/31/699

> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2188,6 +2188,7 @@ static int ___sys_recvmsg(struct socket *sock, struct user_msghdr __user *msg,
> 	struct sockaddr __user *uaddr;
> 	int __user *uaddr_len = COMPAT_NAMELEN(msg);
> 
> +	memset(&addr, 0, sizeof(addr));
> 	msg_sys->msg_name = &addr;
> 
> 	if (MSG_CMSG_COMPAT & flags)

In defense of DaveM and Eric, that networking patch is just pure, utter garbage 
and I'll NACK it just as much: it adds an unconditional 128-byte memset() to a hot 
path!!

  NACKed-by: Ingo Molnar <mingo@kernel.org>

The changelog is also infuriatingly misleading:

> Some protocols do not correctly wipe the contents of the on-stack
> struct sockaddr_storage sent down into recvmsg() (e.g. SCTP), and leak
> kernel stack contents to userspace. This wipes it unconditionally before
> per-protocol handlers run.
>
> Note that leaks like this are mitigated by building with
> CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL=y

It's just a scary, passive-aggressive lie about "some protocols" and ignores the 
desired case where all protocol handlers are correctly implemented.

Did you *really* expect this patch to be applied? The on-stack struct clearing GCC 
plugins (CONFIG_GCC_PLUGIN_STRUCTLEAK*=y) are a nice feature which fix a bad 
oversight in the C standard, but this particular unconditional memset() patch is 
just garbage.

Also, this characterization of the patch review process of the networking 
subsystem:

> though some performance-sensitive subsystem (e.g. networking)
> get very defensive about an always-on stack initialization[2].

... is thus very unfair as well: they didn't NAK or resist the 
CONFIG_GCC_PLUGIN_STRUCTLEAK* compiler feature at all, they NAK-ed a poorly 
thought out, unconditional memset() which adds unconditional overhead, which is 
their job to NAK!

Please refrain from using such unfair pressure tactics to get harebrained security 
patches upstream...

Thanks,

	Ingo
