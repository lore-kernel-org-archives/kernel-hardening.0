Message-ID: <5954C262.9000502@iogearbox.net>
Date: Thu, 29 Jun 2017 11:03:30 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
References: <1498717781-29151-1-git-send-email-mpe@ellerman.id.au>
In-Reply-To: <1498717781-29151-1-git-send-email-mpe@ellerman.id.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC PATCH 1/4] Provide linux/set_memory.h
To: Michael Ellerman <mpe@ellerman.id.au>, kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, labbott@redhat.com
List-ID: <kernel-hardening.lists.openwall.com>

On 06/29/2017 08:29 AM, Michael Ellerman wrote:
> Currently code that wants to use set_memory_ro() etc, needs to include
> asm/set_memory.h, which doesn't exist on all arches. Some code knows
> it only builds on arches which have the header, other code guards the
> inclusion with an #ifdef, neither is ideal.
>
> So create linux/set_memory.h. This always exists, so users don't need
> an #ifdef just to include the header.
>
> When CONFIG_ARCH_HAS_SET_MEMORY=y it includes asm/set_memory.h,
> otherwise it provides empty non-failing implementations.
>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Looks good to me, thanks!

Acked-by: Daniel Borkmann <daniel@iogearbox.net>

I'm fine if Andrew or Kees picks up the bpf patch as well, I think
there shouldn't be any conflict with net-next on this one (and even
if so, then looks trivial to resolve).
