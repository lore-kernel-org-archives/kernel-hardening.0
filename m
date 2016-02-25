Reply-To: kernel-hardening@lists.openwall.com
References: <1455844533-24787-1-git-send-email-labbott@fedoraproject.org>
 <CAGXu5jLREPiCHSwk1LGKJm0pPGpD8O4S+4xu5=Aw_x+COLBXWg@mail.gmail.com>
 <56C79301.5040003@redhat.com>
 <CAGXu5jJ9py=VTyPDzAzD87XXUuMAOE-f+x+5eLUns_yxtkDWiA@mail.gmail.com>
 <56C7A02F.7070902@redhat.com>
 <CAGXu5jLdQNx7ineLf0zv67O30ituQ3a8WHKLBN5FzGVjMz27Bg@mail.gmail.com>
 <56CB866A.8070306@redhat.com>
 <CAGXu5jLXDmyGqXWqFp4dzmKmmfmZ+dW53200OByS2+0_63CT+Q@mail.gmail.com>
 <CAGXu5jJz-dWvHFV9jeQhT-r-bTFGxYypBniTjwnw9qp_LhLJ-w@mail.gmail.com>
 <56CE072F.7060804@redhat.com>
 <CAGXu5jKq-A+ysyP0TZSK1qT5Scu_9ekHU_GgYaQQJm9ftNjEqw@mail.gmail.com>
 <CAGXu5jLVwbaGpeHuMuZOc2H3gc=_pQ=Mao6jD71r3ZJ+6eDu_A@mail.gmail.com>
 <56CE58BA.3080900@redhat.com>
 <CAGXu5jLWqyhspaeoMs+UBu34340OfmKB8EpWRab5=c1uHwKRqw@mail.gmail.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <56CF8B0D.40402@redhat.com>
Date: Thu, 25 Feb 2016 15:15:25 -0800
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLWqyhspaeoMs+UBu34340OfmKB8EpWRab5=c1uHwKRqw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCHv2] lkdtm: Add READ_AFTER_FREE test
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@fedoraproject.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 02/25/2016 09:35 AM, Kees Cook wrote:
> On Wed, Feb 24, 2016 at 5:28 PM, Laura Abbott <labbott@redhat.com> wrote:
>> On 02/24/2016 03:37 PM, Kees Cook wrote:
>>>
>>> On Wed, Feb 24, 2016 at 1:48 PM, Kees Cook <keescook@chromium.org> wrote:
>>>>
>>>> On Wed, Feb 24, 2016 at 11:40 AM, Laura Abbott <labbott@redhat.com>
>>>> wrote:
>>>>>
>>>>> Yep, looks like the v1 patches and not the v2 patches which fix
>>>>> a known issue with the zeroing.
>>>>
>>>>
>>>> Ah-ha, I'll go find those and retest.
>>>
>>>
>>> I sent out a series that was rebased. It works for me, but I want to
>>> make sure I didn't make any glaring issues. I've also sent some fixes
>>> to the lkdtm tests. One thing that stands out to me still is that the
>>> READ_AFTER_FREE never shows poisoning. I remain confused, since
>>> obviously if zeroing is working, it's being correctly poisoned...
>>>
>>> -Kees
>>>
>>
>> I'll review the rebased series you sent out for the page poisoning patches.
>> If it's okay with you, I'll pull in the updates to the LKDTM test.
>
> Yes, please feel free!
>
>> If you
>> test with slub_debug=P on the command line do you see the READ_AFTER_FREE
>> test working as expected? Setting that on the command line will set up
>> the poisoning which should make the READ_AFTER_FREE test fail.
>
> Ah-ha, yes, that was one of the missing pieces:
>
> [   10.790970] lkdtm: Performing direct entry READ_AFTER_FREE
> [   10.790992] lkdtm: Value in memory before free: 12345678
> [   10.790996] lkdtm: Attempting bad read from freed memory
> [   10.790998] lkdtm: Memory correctly poisoned, calling BUG
> [   10.791067] ------------[ cut here ]------------
> [   10.792037] kernel BUG at drivers/misc/lkdtm.c:465!
>
> I see that "F" is also needed to do the sanity checks, but the poison
> ends up being different again from what I was expected:
>
> [    8.643902] lkdtm: Performing direct entry WRITE_AFTER_FREE
> [    8.645215] lkdtm: Allocated memory ffff88007b446850-ffff88007b446c50
> [    8.646700] lkdtm: Attempting bad write to freed memory at ffff88007b446a50
> [    8.648295] =============================================================================
> [    8.649275] BUG kmalloc-1024 (Tainted: G      D        ): Poison overwritten
> [    8.649275] -----------------------------------------------------------------------------
> [    8.649275]
> [    8.649275] INFO: 0xffff88007b446a50-0xffff88007b446a53. First byte
> 0xf0 instead of 0x6b
>
> 0x6b is POISON_FREE:
>
> #define POISON_INUSE    0x5a    /* for use-uninitialised poisoning */
> #define POISON_FREE     0x6b    /* for use-after-free poisoning */
> #define POISON_END      0xa5    /* end-byte of poisoning */
>

Yep, 0x6b is a magic number I've seen all too frequently before ;)

The current poisoning with slub_debug=P covers multiple cases. On
alloc, the memory is set with POISON_INUSE to catch uninitailized
usage. on free, the memory is set to POISON_FREE To catch use after
free bugs. The last bit POISON_END is set at the end of the block
to catch users who might run off the end of the buffer. Having the
different values makes it easier to determine which bug it is.
  
> So it seems like there are separate poisonings going on? Modifying
> READ_AFTER_FREE a bit more, I see that it looks like only the buddy
> allocator is getting the zero poisoning?
>

Yes. The buddy allocator and SL*B allocators are two separate pieces
of code which need independent poisoning mechanisms. Currently, only
the buddy allocator has the zero poisoning. The same functionality
can be added to SL*B allocator as well if it seems beneficial.
  
> [   61.755450] lkdtm: Performing direct entry READ_AFTER_FREE
> [   61.757436] lkdtm: Value in memory before free: 12345678
> [   61.759390] lkdtm: Attempting bad read from freed memory
> [   61.761649] lkdtm: Memory correctly poisoned (6b6b6b6b)
>
> [   62.139408] lkdtm: Performing direct entry READ_BUDDY_AFTER_FREE
> [   62.140766] lkdtm: Value in memory before free: 12345678
> [   62.141989] lkdtm: Attempting to read from freed memory
> [   62.143225] lkdtm: Memory correctly poisoned (0)
>
> Once this series is in, we need to find a way to make a single CONFIG
> to be more friendly than needing to add "page_poison=on slub_debug=FP"
> to the command line. :)

Yep. We can probably use CONFIG_SLUB_DEBUG_ON as an example of what to
do.

On a side note, what's your opinion on the necessity of 'F' for the
checks? 'P' by itself will ensure the memory is cleared. The sanity
checks had a notable imapct on performance.

>
> -Kees
>

Thanks,
Laura
