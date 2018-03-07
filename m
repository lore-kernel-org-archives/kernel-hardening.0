MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <519fee5268faea09ae550776ce969fa6e88668b0.1520449896.git.luto@kernel.org>
References: <519fee5268faea09ae550776ce969fa6e88668b0.1520449896.git.luto@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 7 Mar 2018 11:23:48 -0800
Message-ID: <CA+55aFx-ZUROd4EER+x-pSWFK9_+NOjBtDmkzjOGZ5uSMbPgAg@mail.gmail.com>
Subject: Re: [PATCH] x86/vsyscall/64: Drop "native" vsyscalls
Content-Type: text/plain; charset="UTF-8"
To: Andy Lutomirski <luto@kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>, Kees Cook <keescook@chromium.org>, Dominik Brodowski <linux@dominikbrodowski.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 7, 2018 at 11:12 AM, Andy Lutomirski <luto@kernel.org> wrote:
>
> For all practical purposes, "native" was really just a chicken bit
> in case something went wrong with the emulation.  It's been over six
> years, and nothing has gone wrong.  Delete it.

Ack.

I guess we';ll hear if anybody might still use it and cares, but..

               Linus
