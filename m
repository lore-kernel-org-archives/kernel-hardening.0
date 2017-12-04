MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20171204155610.GH29619@arm.com>
References: <20171201201000.GA44539@beast> <20171204155610.GH29619@arm.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 4 Dec 2017 10:19:26 -0800
Message-ID: <CAGXu5j+Nj-u3GXDTAoCR0wymMWzOKy3KvRLUybY4ApctCQiL9Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] Kconfig: Make STRICT_DEVMEM default-y on x86 and arm64
To: Will Deacon <will.deacon@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Mark Rutland <mark.rutland@arm.com>, Laura Abbott <labbott@redhat.com>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 4, 2017 at 7:56 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Fri, Dec 01, 2017 at 12:10:00PM -0800, Kees Cook wrote:
>> Distros have been shipping with CONFIG_STRICT_DEVMEM=y for years now. It
>> is probably time to flip this default for x86 and arm64.
>
> Should we be defaulting IO_STRICT_DEVMEM on as well?

I'd love to see that, but I haven't seen a long history on this
setting yet. It may be that arm64 can do it, since it doesn't have the
x86 hardware legacy stuff ... If you're willing to give it a shot, I'm
all for it. :)

-Kees

>
> Will
>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  lib/Kconfig.debug | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
>> index 947d3e2ed5c2..39b123d04a36 100644
>> --- a/lib/Kconfig.debug
>> +++ b/lib/Kconfig.debug
>> @@ -1985,7 +1985,7 @@ config STRICT_DEVMEM
>>       bool "Filter access to /dev/mem"
>>       depends on MMU && DEVMEM
>>       depends on ARCH_HAS_DEVMEM_IS_ALLOWED
>> -     default y if TILE || PPC
>> +     default y if TILE || PPC || X86 || ARM64
>>       ---help---
>>         If this option is disabled, you allow userspace (root) access to all
>>         of memory, including kernel and userspace memory. Accidental
>> --
>> 2.7.4
>>
>>
>> --
>> Kees Cook
>> Pixel Security



-- 
Kees Cook
Pixel Security
