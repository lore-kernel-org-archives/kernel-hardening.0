Reply-To: kernel-hardening@lists.openwall.com
References: <1453740953-18109-1-git-send-email-labbott@fedoraproject.org>
 <56A70C9D.8060102@oracle.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <56A7D84D.7020101@redhat.com>
Date: Tue, 26 Jan 2016 12:34:21 -0800
MIME-Version: 1.0
In-Reply-To: <56A70C9D.8060102@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC][PATCH 0/3] Sanitization of buddy pages
To: Sasha Levin <sasha.levin@oracle.com>, Laura Abbott <labbott@fedoraproject.org>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 01/25/2016 10:05 PM, Sasha Levin wrote:
> On 01/25/2016 11:55 AM, Laura Abbott wrote:
>> Hi,
>>
>> This is an implementation of page poisoning/sanitization for all arches. It
>> takes advantage of the existing implementation for
>> !ARCH_SUPPORTS_DEBUG_PAGEALLOC arches. This is a different approach than what
>> the Grsecurity patches were taking but should provide equivalent functionality.
>>
>> For those who aren't familiar with this, the goal of sanitization is to reduce
>> the severity of use after free and uninitialized data bugs. Memory is cleared
>> on free so any sensitive data is no longer available. Discussion of
>> sanitization was brough up in a thread about CVEs
>> (lkml.kernel.org/g/<20160119112812.GA10818@mwanda>)
>>
>> I eventually expect Kconfig names will want to be changed and or moved if this
>> is going to be used for security but that can happen later.
>>
>> Credit to Mathias Krause for the version in grsecurity
>>
>> Laura Abbott (3):
>>    mm/debug-pagealloc.c: Split out page poisoning from debug page_alloc
>>    mm/page_poison.c: Enable PAGE_POISONING as a separate option
>>    mm/page_poisoning.c: Allow for zero poisoning
>>
>>   Documentation/kernel-parameters.txt |   5 ++
>>   include/linux/mm.h                  |  13 +++
>>   include/linux/poison.h              |   4 +
>>   mm/Kconfig.debug                    |  35 +++++++-
>>   mm/Makefile                         |   5 +-
>>   mm/debug-pagealloc.c                | 127 +----------------------------
>>   mm/page_alloc.c                     |  10 ++-
>>   mm/page_poison.c                    | 158 ++++++++++++++++++++++++++++++++++++
>>   8 files changed, 228 insertions(+), 129 deletions(-)
>>   create mode 100644 mm/page_poison.c
>>
>
> Should poisoning of this kind be using kasan rather than "old fashioned"
> poisoning?
>
>

The two aren't mutually exclusive. kasan is serving a different purpose even
though it has sanitize in the name. kasan is designed to detect errors, the
purpose of this series is to make sure the memory is really cleared out.
This series also doesn't have the memory overhead of kasan.
  
> Thanks,
> Sasha
>

Thanks,
Laura
