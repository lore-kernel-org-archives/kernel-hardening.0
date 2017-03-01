MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170301010408.GH21222@n2100.armlinux.org.uk>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org>
 <1488228186-110679-6-git-send-email-keescook@chromium.org> <20170301010408.GH21222@n2100.armlinux.org.uk>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 28 Feb 2017 21:41:07 -0800
Message-ID: <CAGXu5jKq5NYrgYbcP+5rsVzLDfMRwLX027xDfO9_r90zDhJA-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC][PATCH 5/8] ARM: Implement __arch_rare_write_map/unmap()
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, "x86@kernel.org" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 28, 2017 at 5:04 PM, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
> On Mon, Feb 27, 2017 at 12:43:03PM -0800, Kees Cook wrote:
>> Based on grsecurity's ARM pax_{open,close}_kernel() implementation, this
>> allows HAVE_ARCH_RARE_WRITE to work on ARM.
>
> This has the effect that any memory mapped with DOMAIN_KERNEL will
> loose it's NX status, and may end up being read into the I-cache.

Arbitrarily so, or only memory accessed/pre-fetched by the CPU when in
this state? i.e. since this is non-preempt, only touches the needed
memory, and has the original domain state restored within a few
instructions, does this avoid the problem? It seems like the chance
for a speculative prefetch from device memory under these conditions
should be approaching zero.

> We used to do exactly this to support set_fs(KERNEL_DS) but it was
> deemed to be way too problematical (for speculative prefetching)
> to use it on ARMv6+.
>
> As vmalloc space ends up with a random mixture of DOMAIN_KERNEL and
> DOMAIN_IO mappings (due to the order of ioremap() vs vmalloc()), this
> means DOMAIN_KERNEL can cover devices... which with switching
> DOMAIN_KERNEL to manager mode result in the NX being removed for
> device mappings, which (iirc) is unpredictable.

Just to make sure I understand: it was only speculative prefetch vs
icache, right? Would an icache flush restore the correct permissions?
I'm just pondering alternatives. Also, is there a maximum distance the
prefetching spans? i.e. could device memory be guaranteed to be
vmapped far enough away from kernel memory to avoid prefetches?

-Kees

-- 
Kees Cook
Pixel Security
