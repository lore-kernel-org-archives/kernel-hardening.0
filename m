Reply-To: kernel-hardening@lists.openwall.com
References: <1478106169-25770-1-git-send-email-vaishali.thakkar@oracle.com>
 <20161102204453.GA18842@remoulade>
 <CAGXu5j+go+Fr2OeF-R4BtVHRcBRrC0TaU477J4RwEAe4zDRZ9A@mail.gmail.com>
 <581A9D8B.5040200@oracle.com> <20161103042301.GA24968@remoulade>
From: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Message-ID: <581AC389.10507@oracle.com>
Date: Thu, 3 Nov 2016 10:26:41 +0530
MIME-Version: 1.0
In-Reply-To: <20161103042301.GA24968@remoulade>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC PATCH] lib: Harden
 csum_partial_copy_from_user
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Al Viro <viro@zeniv.linux.org.uk>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>



On Thursday 03 November 2016 09:53 AM, Mark Rutland wrote:
> Hi Vaishali,

Hi Mark,
 
> On Thu, Nov 03, 2016 at 07:44:35AM +0530, Vaishali Thakkar wrote:
>> On Thursday 03 November 2016 03:29 AM, Kees Cook wrote:
>>> On Wed, Nov 2, 2016 at 2:44 PM, Mark Rutland <mark.rutland@arm.com> wrote:
>>>> I know that both arm64 and x86 have a check_object_size() call in their
>>>> __copy_from_user() implementations.
> 
>>>> Is that missing on some architectures?
>>>
>>> Every architecture is _slightly_ different. Most put the check in
>>> __copy_from_user() so it's correctly caught. (x86 puts them in both
>>> since copy*() calls _copy*(), not __copy*() ... >_<)
>>
>> I think still there are some architectures which didn't put the check
>> in __copy_from_user() [eg. tile].
> 
> I see. :(
> 
> Looking again, a grep shows many (even those with MMUs) don't do anything at
> all in v4.9-rc2:
> 
> [mark@remoulade:~/src/linux]% for ARCH in arch/*; do
> printf "%d %s\n" $(git grep check_object_size -- "${ARCH}" | wc -l) ${ARCH};
> done | sort -n
> 0 arch/alpha
> 0 arch/arc
> 0 arch/avr32
> 0 arch/blackfin
> 0 arch/c6x
> 0 arch/cris
> 0 arch/frv
> 0 arch/h8300
> 0 arch/hexagon
> 0 arch/Kconfig
> 0 arch/m32r
> 0 arch/m68k
> 0 arch/metag
> 0 arch/microblaze
> 0 arch/mn10300
> 0 arch/nios2
> 0 arch/openrisc
> 0 arch/score
> 0 arch/sh
> 0 arch/tile
> 0 arch/um
> 0 arch/unicore32
> 0 arch/xtensa
> 2 arch/parisc
> 2 arch/s390
> 3 arch/arm
> 4 arch/arm64
> 4 arch/ia64
> 4 arch/powerpc
> 5 arch/sparc
> 6 arch/mips
> 6 arch/x86

Hmm, should we go for sending patches for them? [atleast for the ones with MMUs
and then may be maintainers/developers can check the change]

Also, I think same goes for the the kasan_check. We have only arm64 and x86  
with these checks.

>> I was actually wondering if there are any cases where we need any
>> architecture specific extra check(s)?
> 
> Generally, I'd expect that to be orthogonal to the hardened usercopy work, and
> that check would still be present in the low-level architecture-specific code
> even if we made the check_object_size() checks common.
> 
> Do you have an example of the kind of thing you're worried about?

Ahmm, no. Not at the moment. But I was actually thinking that this might be possible
based on how architecture copies data from the userspace. Probably this can be figure
out later on by architecture maintainers once they have this check ...
 
> Thanks,
> Mark.
> 

-- 
Vaishali
