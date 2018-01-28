Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sun, 28 Jan 2018 20:00:35 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20180128190035.q2bqchwhc2fww6io@gmail.com>
References: <cover.1517164461.git.luto@kernel.org>
 <462dff8d4d64dfbfc851fbf3130641809d980ecd.1517164461.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462dff8d4d64dfbfc851fbf3130641809d980ecd.1517164461.git.luto@kernel.org>
Subject: [kernel-hardening] Re: [PATCH 1/3] x86/entry/64: Remove the SYSCALL64 fast path
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>


* Andy Lutomirski <luto@kernel.org> wrote:

> The SYCALLL64 fast path was a nice, if small, optimization back in
> the good old days when syscalls were actually reasonably fast.  Now
> we have PTI to slow everything down, and indirect branches are
> verboten, making everything messier.  The retpoline code in the fast
> path was particularly nasty.
> 
> Just get rid of the fast path.  The slow path is barely slower.
> 
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
> 
> This isn't quite identical to Linus' patch.  I cleaned up the
> SYSCALL64 entry code to use all pushes rather than pushing all but 6
> regs and moving the rest.

Hm, could we please have this in two parts please, out of general paranoia?

One patch doing the easy fast path removal, the other doing the mov/push 
conversion?

Bisectability, reviewability and all that.

Exact same patch result.

Thanks,

	Ingo
