MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <5954C262.9000502@iogearbox.net>
References: <1498717781-29151-1-git-send-email-mpe@ellerman.id.au> <5954C262.9000502@iogearbox.net>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 29 Jun 2017 09:11:10 -0700
Message-ID: <CAGXu5jKFq5hO7Z0YD797X6a0i-4=yD_wL5is3J6FyjEGj9msMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [RFC PATCH 1/4] Provide linux/set_memory.h
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>, Michael Ellerman <mpe@ellerman.id.au>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 29, 2017 at 2:03 AM, Daniel Borkmann <daniel@iogearbox.net> wrote:
> On 06/29/2017 08:29 AM, Michael Ellerman wrote:
>>
>> Currently code that wants to use set_memory_ro() etc, needs to include
>> asm/set_memory.h, which doesn't exist on all arches. Some code knows
>> it only builds on arches which have the header, other code guards the
>> inclusion with an #ifdef, neither is ideal.
>>
>> So create linux/set_memory.h. This always exists, so users don't need
>> an #ifdef just to include the header.
>>
>> When CONFIG_ARCH_HAS_SET_MEMORY=y it includes asm/set_memory.h,
>> otherwise it provides empty non-failing implementations.
>>
>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>
>
> Looks good to me, thanks!
>
> Acked-by: Daniel Borkmann <daniel@iogearbox.net>
>
> I'm fine if Andrew or Kees picks up the bpf patch as well, I think
> there shouldn't be any conflict with net-next on this one (and even
> if so, then looks trivial to resolve).

I nominate Andrew. ;) This should go in early in the merge window and
the users can go late in the window. If Andrew has enough to do, I can
carry it too; just say the word.

This is a sane addition and allows for lines-of-code reduction in a
few places. Thanks!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Pixel Security
