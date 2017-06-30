From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <CAGXu5jKFq5hO7Z0YD797X6a0i-4=yD_wL5is3J6FyjEGj9msMg@mail.gmail.com>
References: <1498717781-29151-1-git-send-email-mpe@ellerman.id.au> <5954C262.9000502@iogearbox.net> <CAGXu5jKFq5hO7Z0YD797X6a0i-4=yD_wL5is3J6FyjEGj9msMg@mail.gmail.com>
Date: Fri, 30 Jun 2017 11:43:18 +1000
Message-ID: <87d19mqmh5.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] [RFC PATCH 1/4] Provide linux/set_memory.h
To: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:

> On Thu, Jun 29, 2017 at 2:03 AM, Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 06/29/2017 08:29 AM, Michael Ellerman wrote:
>>>
>>> Currently code that wants to use set_memory_ro() etc, needs to include
>>> asm/set_memory.h, which doesn't exist on all arches. Some code knows
>>> it only builds on arches which have the header, other code guards the
>>> inclusion with an #ifdef, neither is ideal.
>>>
>>> So create linux/set_memory.h. This always exists, so users don't need
>>> an #ifdef just to include the header.
>>>
>>> When CONFIG_ARCH_HAS_SET_MEMORY=y it includes asm/set_memory.h,
>>> otherwise it provides empty non-failing implementations.
>>>
>>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>>
>>
>> Looks good to me, thanks!
>>
>> Acked-by: Daniel Borkmann <daniel@iogearbox.net>
>>
>> I'm fine if Andrew or Kees picks up the bpf patch as well, I think
>> there shouldn't be any conflict with net-next on this one (and even
>> if so, then looks trivial to resolve).
>
> I nominate Andrew. ;) This should go in early in the merge window and
> the users can go late in the window. If Andrew has enough to do, I can
> carry it too; just say the word.
>
> This is a sane addition and allows for lines-of-code reduction in a
> few places. Thanks!

Andrew's picked them up in mmotm, thanks everyone.

cheers
