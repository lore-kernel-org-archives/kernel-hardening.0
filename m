Date: Sun, 28 Jan 2018 22:50:31 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20180128225031.GJ13338@ZenIV.linux.org.uk>
References: <cover.1517164461.git.luto@kernel.org>
 <4dd5a4d0f6b694f17eaf64c80c36a2560993b9ea.1517164461.git.luto@kernel.org>
 <CA+55aFxbE6p+3kMumsTfh_E=fR=bteKi4d6WLGaFeBP8JBv_eg@mail.gmail.com>
 <20180128202128.GI13338@ZenIV.linux.org.uk>
 <CA+55aFzScvPkO0JN_OReKMoyRC5KRbn_8bmWKkxVdi9m_X+cgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzScvPkO0JN_OReKMoyRC5KRbn_8bmWKkxVdi9m_X+cgQ@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] Re: [PATCH 3/3] syscalls: Add a bit of documentation to
 __SYSCALL_DEFINE
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jan 28, 2018 at 12:42:24PM -0800, Linus Torvalds wrote:

> The 64-bit argument for 32-bit case would end up having to have a few
> more of those architecture-specific oddities. So not just
> "argument1(ptregs)", but "argument2_32_64(ptregs)" or something that
> says "get me argument 2, when the first argument is 32-bit and I want
> a 64-bit one".

Yeah, but...  You either get to give SYSCALL_DEFINE more than just
the number of arguments (SYSCALL_DEFINE_WDDW) or you need to go
for rather grotty macros to pick that information.  That's pretty
much what I'd tried; it hadn't been fun at all...
