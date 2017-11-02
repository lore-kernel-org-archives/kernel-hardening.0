References: <20171026090942.7041-1-mark.rutland@arm.com>
 <77c80381-cf68-aa1a-9112-e057c068eeb6@redhat.com>
 <20171101120555.yvb65g3wgtxskfh3@lakrids.cambridge.arm.com>
 <0f2d5f89-2939-06ec-9b59-b19f828d8968@redhat.com>
 <CAGXu5j+eb+41XRorgAVURKEsixiMYgtcmpKwQzJ3Mct_yw1G6Q@mail.gmail.com>
 <57fa4bef-9540-6fb1-b2a7-5bf8b01c748a@redhat.com>
 <CAGXu5jLhU7si5d3=e5ixhh67fY+6ZGJQBnLxQLMFfcZsB8GJvg@mail.gmail.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <dd734498-7b03-005c-647b-eec66479cfa1@redhat.com>
Date: Wed, 1 Nov 2017 18:25:53 -0700
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLhU7si5d3=e5ixhh67fY+6ZGJQBnLxQLMFfcZsB8GJvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [RFC PATCH 0/2] arm64: optional paranoid __{get,put}_user checks
To: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 11/01/2017 04:29 PM, Kees Cook wrote:
> On Wed, Nov 1, 2017 at 4:05 PM, Laura Abbott <labbott@redhat.com> wrote:
>> On 11/01/2017 03:28 PM, Kees Cook wrote:
>>> On Wed, Nov 1, 2017 at 2:13 PM, Laura Abbott <labbott@redhat.com> wrote:
>>>> On 11/01/2017 05:05 AM, Mark Rutland wrote:
>>>>> On Tue, Oct 31, 2017 at 04:56:39PM -0700, Laura Abbott wrote:
>>>>>> On 10/26/2017 02:09 AM, Mark Rutland wrote:
>>>>>>> In Prague, Kees mentioned that it would be nice to have a mechanism to
>>>>>>> catch bad __{get,put}_user uses, such as the recent CVE-2017-5123 [1,2]
>>>>>>> issue with unsafe_put_user() in waitid().
>>>>>>>
>>>>>>> These patches allow an optional access_ok() check to be dropped in
>>>>>>> arm64's __{get,put}_user() primitives. These will then BUG() if a bad
>>>>>>> user pointer is passed (which should only happen in the absence of an
>>>>>>> earlier access_ok() check).
>>>>>
>>>>>> Turning on the option fails as soon as we hit userspace. On my buildroot
>>>>>> based environment I get the help text for ld.so (????) and then a message
>>>>>> about attempting to kill init.
>>>>>
>>>>> Ouch. Thanks for the report, and sorry about this.
>>>>>
>>>>> The problem is that I evaluate the ptr argument twice in
>>>>> __{get,put}_user(), and this may have side effects.
>>>>>
>>>>> e.g. when the ELF loader does things like:
>>>>>
>>>>>   __put_user((elf_addr_t)p, sp++)
>>>>>
>>>>> ... we increment sp twice, and write to the wrong user address, leaving
>>>>> sp corrupt.
>>>>>
>>>>> I have an additional patch [1] to fix this, which is in my
>>>>> arm64/access-ok branch [2].
>>>>>
>>>>> Thanks,
>>>>> Mark.
>>>>>
>>>>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/commit/?h=arm64/access-ok&id=ebb7ff83eb53b8810395d5cf48712a4ae6d678543
>>>>> [2] https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=arm64/access-ok
>>>>>
>>>>
>>>> Thanks, the updated patch works. I wrote an LKDTM test to verify
>>>> the expected behavior (__{get,put}_user panic whereas {get,put}_user
>>>> do not). You're welcome to add Tested-by or I can wait for v2.
>>>
>>> Nice. :) Out of curiosity, can you check if this correctly BUG()s on a
>>> waitid() call when the fixes are reverted?
>>>
>>> 96ca579a1ecc ("waitid(): Avoid unbalanced user_access_end() on
>>> access_ok() error")
>>> 1c9fec470b81 ("waitid(): Add missing access_ok() checks")
>>>
>>> -Kees
>>>
>>
>> Yep, we get a nice bug:
>>
>> [   34.783912] ------------[ cut here ]------------
>> [   34.784484] kernel BUG at kernel/exit.c:1614!
> 
> Awesome! :)
> 
> I wonder how hard it might be to make this happen on x86 too (or
> generically). Hmmm
x86 looks like it needs the same ptr_argument fixup as arm64 but
seems to have a separate unsafe path so it's actually easier to
fix up. I have version of this that seems to work so I'll clean
it up and send it out tomorrow.

Thanks,
Laura
