Message-ID: <5954C0FC.9040804@iogearbox.net>
Date: Thu, 29 Jun 2017 10:57:32 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
References: <1498717781-29151-1-git-send-email-mpe@ellerman.id.au> <1498717781-29151-4-git-send-email-mpe@ellerman.id.au>
In-Reply-To: <1498717781-29151-4-git-send-email-mpe@ellerman.id.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC PATCH 4/4] bpf: Use linux/set_memory.h
To: Michael Ellerman <mpe@ellerman.id.au>, kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, labbott@redhat.com
List-ID: <kernel-hardening.lists.openwall.com>

On 06/29/2017 08:29 AM, Michael Ellerman wrote:
> This header always exists, so doesn't require an ifdef around its
> inclusion. When CONFIG_ARCH_HAS_SET_MEMORY=y it includes the asm header,
> otherwise it provides empty versions of the set_memory_xx() routines.
>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Acked-by: Daniel Borkmann <daniel@iogearbox.net>
