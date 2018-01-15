Date: Mon, 15 Jan 2018 09:46:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20180115084611.GK6176@hirez.programming.kicks-ass.net>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151571801681.27429.15417813964230837664.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180112091246.GP32035@hirez.programming.kicks-ass.net>
 <CAPcyv4j++bw8dO1cbEZpf3u+wDGM89A7d06MTHtugHHJs8CJ5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4j++bw8dO1cbEZpf3u+wDGM89A7d06MTHtugHHJs8CJ5g@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 06/19] asm-generic/barrier: mask speculative execution
 flows
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, Catalin Marinas <catalin.marinas@arm.com>, X86 ML <x86@kernel.org>, Will Deacon <will.deacon@arm.com>, Alexei Starovoitov <ast@kernel.org>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 12, 2018 at 04:41:37PM -0800, Dan Williams wrote:
> This certainly needs a Kconfig "depends on JUMP_LABEL" to turn on the
> dynamic switching at all, and a HAVE_JUMP_LABEL compile time failure
> if the compiler lacks support.

We're ready to drop all compilers that don't support asm-goto on the
floor for x86. So don't over engineer it just to avoid that.
