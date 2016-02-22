Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <56C7A02F.7070902@redhat.com>
References: <1455844533-24787-1-git-send-email-labbott@fedoraproject.org>
	<CAGXu5jLREPiCHSwk1LGKJm0pPGpD8O4S+4xu5=Aw_x+COLBXWg@mail.gmail.com>
	<56C79301.5040003@redhat.com>
	<CAGXu5jJ9py=VTyPDzAzD87XXUuMAOE-f+x+5eLUns_yxtkDWiA@mail.gmail.com>
	<56C7A02F.7070902@redhat.com>
Date: Mon, 22 Feb 2016 11:27:42 -0800
Message-ID: <CAGXu5jLdQNx7ineLf0zv67O30ituQ3a8WHKLBN5FzGVjMz27Bg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCHv2] lkdtm: Add READ_AFTER_FREE test
To: Laura Abbott <labbott@redhat.com>
Cc: Laura Abbott <labbott@fedoraproject.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 19, 2016 at 3:07 PM, Laura Abbott <labbott@redhat.com> wrote:
> On 02/19/2016 02:19 PM, Kees Cook wrote:
>>
>> On Fri, Feb 19, 2016 at 2:11 PM, Laura Abbott <labbott@redhat.com> wrote:
>>>
>>> On 02/19/2016 11:12 AM, Kees Cook wrote:
>>>>
>>>>
>>>> On Thu, Feb 18, 2016 at 5:15 PM, Laura Abbott
>>>> <labbott@fedoraproject.org>
>>>> wrote:
>>>>>
>>>>>
>>>>>
>>>>> In a similar manner to WRITE_AFTER_FREE, add a READ_AFTER_FREE
>>>>> test to test free poisoning features. Sample output when
>>>>> no sanitization is present:
>>>>>
>>>>> [   22.414170] lkdtm: Performing direct entry READ_AFTER_FREE
>>>>> [   22.415124] lkdtm: Value in memory before free: 12345678
>>>>> [   22.415900] lkdtm: Attempting to read from freed memory
>>>>> [   22.416394] lkdtm: Successfully read value: 12345678
>>>>>
>>>>> with sanitization:
>>>>>
>>>>> [   25.874585] lkdtm: Performing direct entry READ_AFTER_FREE
>>>>> [   25.875527] lkdtm: Value in memory before free: 12345678
>>>>> [   25.876382] lkdtm: Attempting to read from freed memory
>>>>> [   25.876900] general protection fault: 0000 [#1] SMP
>>>>>
>>>>> Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
>>>>
>>>>
>>>>
>>>> Excellent! Could you mention in the changelog which CONFIG (or runtime
>>>> values) will change the lkdtm test? (I thought there was a poisoning
>>>> style that would result in a zero-read instead of a GP?)
>>>>
>>>
>>> There was a zeroing patch in the first draft but given the direction
>>> things are going, I don't see it going in. I'll mention the debug
>>> options which will show this though.
>>
>>
>> Ah! Okay, I was having trouble following what was happening. What's
>> the current state of the use-after-free protections you've been
>> working on?
>
>
> Based on discussion, the SL*B maintainers want to use the existing
> slab poisoning features instead adding in new hooks. They also don't
> want the fast path to be affected at all. This means most of the
> actual work there is improving the performance of slub_debug=P. I
> sent out patches for some low hanging fruit in SLUB which improved
> the performance by a good bit. Those have been Acked and are sitting
> in Andrew's tree. The next performance work involves more in depth
> tinkering with the SLUB allocator. Apart from just performance, the
> other work would be poisoning for caches with ctors in SLUB and
> poisoning in SLOB. I could use some help with benchmarking some
> actual use cases to see how usable slub_debug=P would be on some
> use cases.
>
> I did sent out patches for the buddy allocator as well. The last

This must be where my confusion stems. :) IIUC, the buddy allocator is
used within the SL*B logic when splitting/joining regions? Can we add
an lkdtm test for this too?

> version I sent out didn't get much in the way of feedback except
> for some requests for benchmarks on the zeroing. I was planning
> on following up on that next week to see if there was any more feedback
> and beg for Acks.

If you can point me at the current tree, I'd be happy to run some benchmarks.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
