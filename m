MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <8737amew79.fsf@concordia.ellerman.id.au>
References: <1498154792-49952-1-git-send-email-keescook@chromium.org>
 <1498154792-49952-4-git-send-email-keescook@chromium.org> <87podvp4q1.fsf@concordia.ellerman.id.au>
 <CAGXu5jK7aHHRMZyZyrviBF+cLghWcH_D4PX_vMFOycHuF7EdLA@mail.gmail.com> <8737amew79.fsf@concordia.ellerman.id.au>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 26 Jun 2017 11:26:59 -0700
Message-ID: <CAGXu5jJKtdgRzdiDhA7XBcsaLQhmFgyQahk1F-zscFQY3pNBUQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 3/4] powerpc: Reduce ELF_ET_DYN_BASE
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, Pratyush Anand <panand@redhat.com>, Ingo Molnar <mingo@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 26, 2017 at 6:04 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> Kees Cook <keescook@chromium.org> writes:
>
>> On Fri, Jun 23, 2017 at 12:01 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
>>> Kees Cook <keescook@chromium.org> writes:
>>>
>>>> Now that explicitly executed loaders are loaded in the mmap region,
>>>> position PIE binaries lower in the address space to avoid possible
>>>> collisions with mmap or stack regions. For 64-bit, align to 4GB to
>>>> allow runtimes to use the entire 32-bit address space for 32-bit
>>>> pointers.
>>>
>>> The change log and subject are a bit out of whack with the actual patch
>>> because previously we used 512MB.
>>>
>>> How about?
>>>
>>>   powerpc: Move ELF_ET_DYN_BASE to 4GB / 4MB
>>>
>>>   Now that explicitly executed loaders are loaded in the mmap region,
>>>   we have more freedom to decide where we position PIE binaries in the
>>>   address space to avoid possible collisions with mmap or stack regions.
>>>
>>>   For 64-bit, align to 4GB to allow runtimes to use the entire 32-bit
>>>   address space for 32-bit pointers. On 32-bit use 4MB.
>>
>> Good idea, thanks. I'll resend the series with the commit logs updated.
>>
>>> Is there any particular reasoning behind the 4MB value on 32-bit?
>>
>> So, I've dug around a bit on this, and I *think* the rationale is to
>> avoid mapping a possible 4MB page table entry when it won't be using
>> at least a portion near the lower end (NULL address area covered
>> blocked by mmap_min_addr). It seems to be mainly tradition, though.
>
> OK, that is obscure, especially for CPUs that don't have a 4MB page
> size. But consistency across arches is probably best regardless.

Yeah, I like being not "close" to the NULL address, though the
definition of "close" has been various values like 64K (mmap_min_addr)
and 1M (x86 BIOS junk and new stack-gap size). 4MB is above even that,
so, I think we're fine there. It's what Windows has used, so it's
familiar and any new attack methodologies would at least be shared
across OSes and architectures, so we should "notice" any problem with
the value, and then we can adjust it if we need to.

-Kees

-- 
Kees Cook
Pixel Security
