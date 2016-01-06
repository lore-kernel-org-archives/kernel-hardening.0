Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <5679A0CB.3060707@labbott.name>
References: <1450755641-7856-1-git-send-email-laura@labbott.name>
	<1450755641-7856-7-git-send-email-laura@labbott.name>
	<567964F3.2020402@intel.com>
	<alpine.DEB.2.20.1512221023550.2748@east.gentwo.org>
	<567986E7.50107@intel.com>
	<alpine.DEB.2.20.1512221124230.14335@east.gentwo.org>
	<56798851.60906@intel.com>
	<alpine.DEB.2.20.1512221207230.14406@east.gentwo.org>
	<5679943C.1050604@intel.com>
	<5679A0CB.3060707@labbott.name>
Date: Tue, 5 Jan 2016 16:29:21 -0800
Message-ID: <CAGXu5jLe69KvVOGE2kHtJk+Ueik4OX9YyYAk_NhRufOEVkLUdQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC][PATCH 6/7] mm: Add Kconfig option for
 slab sanitization
To: Laura Abbott <laura@labbott.name>
Cc: Dave Hansen <dave.hansen@intel.com>, Christoph Lameter <cl@linux.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Dec 22, 2015 at 11:13 AM, Laura Abbott <laura@labbott.name> wrote:
> On 12/22/15 10:19 AM, Dave Hansen wrote:
>>
>> On 12/22/2015 10:08 AM, Christoph Lameter wrote:
>>>
>>> On Tue, 22 Dec 2015, Dave Hansen wrote:
>>>>>
>>>>> Why would you use zeros? The point is just to clear the information
>>>>> right?
>>>>> The regular poisoning does that.
>>>>
>>>>
>>>> It then allows you to avoid the zeroing at allocation time.
>>>
>>>
>>> Well much of the code is expecting a zeroed object from the allocator and
>>> its zeroed at that time. Zeroing makes the object cache hot which is an
>>> important performance aspect.
>>
>>
>> Yes, modifying this behavior has a performance impact.  It absolutely
>> needs to be evaluated, and I wouldn't want to speculate too much on how
>> good or bad any of the choices are.
>>
>> Just to reiterate, I think we have 3 real choices here:
>>
>> 1. Zero at alloc, only when __GFP_ZERO
>>     (behavior today)
>> 2. Poison at free, also Zero at alloc (when __GFP_ZERO)
>>     (this patch's proposed behavior, also what current poisoning does,
>>      doubles writes)
>> 3. Zero at free, *don't* Zero at alloc (when __GFP_ZERO)
>>     (what I'm suggesting, possibly less perf impact vs. #2)
>>
>>
>
> poisoning with non-zero memory makes it easier to determine that the error
> came from accessing the sanitized memory vs. some other case. I don't think
> the feature would be as strong if the memory was only zeroed vs. some other
> data value.

I would tend to agree. If there are significant perf improvements for
"3" above, that should be easy to add on later as another choice.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
