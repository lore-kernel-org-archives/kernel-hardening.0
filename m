MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <03148bcc1b217100e6e8ecf6a5468c45cf4304b6.1517164461.git.luto@kernel.org>
References: <cover.1517164461.git.luto@kernel.org> <03148bcc1b217100e6e8ecf6a5468c45cf4304b6.1517164461.git.luto@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 28 Jan 2018 11:19:38 -0800
Message-ID: <CA+55aFxhPk=9vk0_6XS82Kzxp8ncFzY3pvL8mh-zCYzsBJCFpA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 2/3] x86/asm: Move 'status' from thread_struct to thread_info
To: Andy Lutomirski <luto@kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jan 28, 2018 at 10:38 AM, Andy Lutomirski <luto@kernel.org> wrote:
>
> Linus suggested further changing:
>
>   ti->status &= ~(TS_COMPAT|TS_I386_REGS_POKED);
>
> to:
>
>   if (unlikely(ti->status & (TS_COMPAT|TS_I386_REGS_POKED)))
>           ti->status &= ~(TS_COMPAT|TS_I386_REGS_POKED);
>
> on the theory that frequently dirtying the cacheline even in pure
> 64-bit code that never needs to modify status hurts performance.
> That could be a reasonable followup patch, but I suspect it matters
> less on top of this patch.

Ack, that should be done separately from the movement anyway.

And yes, it's possible that once it's in the same cacheline with the
thread flags, you can't even see the issue anyway. Although I *think*
all those early fields are normally mostly read-only, so that "read
before clear" may end up being a good idea regardless.

                Linus
