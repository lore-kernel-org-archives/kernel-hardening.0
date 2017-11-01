References: <20171026090942.7041-1-mark.rutland@arm.com>
 <77c80381-cf68-aa1a-9112-e057c068eeb6@redhat.com>
 <20171101120555.yvb65g3wgtxskfh3@lakrids.cambridge.arm.com>
 <0f2d5f89-2939-06ec-9b59-b19f828d8968@redhat.com>
 <CAGXu5j+eb+41XRorgAVURKEsixiMYgtcmpKwQzJ3Mct_yw1G6Q@mail.gmail.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <57fa4bef-9540-6fb1-b2a7-5bf8b01c748a@redhat.com>
Date: Wed, 1 Nov 2017 16:05:41 -0700
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+eb+41XRorgAVURKEsixiMYgtcmpKwQzJ3Mct_yw1G6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC PATCH 0/2] arm64: optional paranoid __{get,put}_user checks
To: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 11/01/2017 03:28 PM, Kees Cook wrote:
> On Wed, Nov 1, 2017 at 2:13 PM, Laura Abbott <labbott@redhat.com> wrote:
>> On 11/01/2017 05:05 AM, Mark Rutland wrote:
>>> On Tue, Oct 31, 2017 at 04:56:39PM -0700, Laura Abbott wrote:
>>>> On 10/26/2017 02:09 AM, Mark Rutland wrote:
>>>>> In Prague, Kees mentioned that it would be nice to have a mechanism to
>>>>> catch bad __{get,put}_user uses, such as the recent CVE-2017-5123 [1,2]
>>>>> issue with unsafe_put_user() in waitid().
>>>>>
>>>>> These patches allow an optional access_ok() check to be dropped in
>>>>> arm64's __{get,put}_user() primitives. These will then BUG() if a bad
>>>>> user pointer is passed (which should only happen in the absence of an
>>>>> earlier access_ok() check).
>>>
>>>> Turning on the option fails as soon as we hit userspace. On my buildroot
>>>> based environment I get the help text for ld.so (????) and then a message
>>>> about attempting to kill init.
>>>
>>> Ouch. Thanks for the report, and sorry about this.
>>>
>>> The problem is that I evaluate the ptr argument twice in
>>> __{get,put}_user(), and this may have side effects.
>>>
>>> e.g. when the ELF loader does things like:
>>>
>>>   __put_user((elf_addr_t)p, sp++)
>>>
>>> ... we increment sp twice, and write to the wrong user address, leaving
>>> sp corrupt.
>>>
>>> I have an additional patch [1] to fix this, which is in my
>>> arm64/access-ok branch [2].
>>>
>>> Thanks,
>>> Mark.
>>>
>>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/commit/?h=arm64/access-ok&id=ebb7ff83eb53b8810395d5cf48712a4ae6d678543
>>> [2] https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=arm64/access-ok
>>>
>>
>> Thanks, the updated patch works. I wrote an LKDTM test to verify
>> the expected behavior (__{get,put}_user panic whereas {get,put}_user
>> do not). You're welcome to add Tested-by or I can wait for v2.
> 
> Nice. :) Out of curiosity, can you check if this correctly BUG()s on a
> waitid() call when the fixes are reverted?
> 
> 96ca579a1ecc ("waitid(): Avoid unbalanced user_access_end() on
> access_ok() error")
> 1c9fec470b81 ("waitid(): Add missing access_ok() checks")
> 
> -Kees
> 

Yep, we get a nice bug:

[   34.783912] ------------[ cut here ]------------
[   34.784484] kernel BUG at kernel/exit.c:1614!
[   34.785016] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[   34.785572] Modules linked in:
[   34.786177] CPU: 0 PID: 1324 Comm: a.out Not tainted 4.14.0-rc5-00005-ga3bb7b0f72d3 #69
[   34.786657] Hardware name: linux,dummy-virt (DT)
[   34.787093] task: ffff80003c4ed400 task.stack: ffff00000ade0000
[   34.788196] PC is at SyS_waitid+0x1d4/0x210
[   34.788534] LR is at SyS_waitid+0x20/0x210
[   34.788839] pc : [<ffff0000080cde1c>] lr : [<ffff0000080cdc68>] pstate: a0000145
[   34.789310] sp : ffff00000ade3e00
[   34.789578] x29: ffff00000ade3e00 x28: ffff80003c4ed400 
[   34.790039] x27: ffff0000089e1000 x26: 000000000000005f 
[   34.790397] x25: 0000000000000124 x24: 0000000000000015 
[   34.790649] x23: 0000000080000000 x22: 0000ffffb1eb6b24 
[   34.790897] x21: 00000000ffffffff x20: 000080003600c000 
[   34.791149] x19: ffff800000000000 x18: 0000000000000007 
[   34.791397] x17: 0000000000000001 x16: 0000000000000019 
[   34.791648] x15: 0000000000000033 x14: 000000000000004c 
[   34.791903] x13: 0000000000000068 x12: ffff000008af69d0 
[   34.792156] x11: ffff00000ade3c20 x10: 0000000000000000 
[   34.792451] x9 : 0000000000000000 x8 : 0000000000000000 
[   34.792706] x7 : 0000000000000000 x6 : ffff000008f42f18 
[   34.792965] x5 : dead000000000100 x4 : 0000000000000011 
[   34.793214] x3 : ffff80003c4ed400 x2 : ffff800000000004 
[   34.793462] x1 : 0001000000000000 x0 : 0000000000000000 
[   34.793743] Process a.out (pid: 1324, stack limit = 0xffff00000ade0000)
[   34.794098] Call trace:
[   34.794351] Exception stack(0xffff00000ade3cc0 to 0xffff00000ade3e00)
[   34.794722] 3cc0: 0000000000000000 0001000000000000 ffff800000000004 ffff80003c4ed400
[   34.795034] 3ce0: 0000000000000011 dead000000000100 ffff000008f42f18 0000000000000000
[   34.795297] 3d00: 0000000000000000 0000000000000000 0000000000000000 ffff00000ade3c20
[   34.795549] 3d20: ffff000008af69d0 0000000000000068 000000000000004c 0000000000000033
[   34.795803] 3d40: 0000000000000019 0000000000000001 0000000000000007 ffff800000000000
[   34.796066] 3d60: 000080003600c000 00000000ffffffff 0000ffffb1eb6b24 0000000080000000
[   34.796277] 3d80: 0000000000000015 0000000000000124 000000000000005f ffff0000089e1000
[   34.796477] 3da0: ffff80003c4ed400 ffff00000ade3e00 ffff0000080cdc68 ffff00000ade3e00
[   34.796677] 3dc0: ffff0000080cde1c 00000000a0000145 0000000000000000 ffff80003c4ed400
[   34.796884] 3de0: 0001000000000000 dead000000000100 ffff00000ade3e00 ffff0000080cde1c
[   34.797153] [<ffff0000080cde1c>] SyS_waitid+0x1d4/0x210
[   34.797298] Exception stack(0xffff00000ade3ec0 to 0xffff00000ade4000)
[   34.797470] 3ec0: 0000000000000000 0000000000000000 ffff800000000000 0000000000000004
[   34.797670] 3ee0: 0000000000000000 0400000055550400 0000ffffb1e0a011 0000000000000cbf
[   34.797873] 3f00: 000000000000005f 0000000000000a3b 0000000000000000 16170f120a1a1311
[   34.798073] 3f20: 00000000000001a8 0000ffffb1f8ecb8 0000ffffb1e1c0e0 0000000000000002
[   34.798272] 3f40: 0000ffffb1eb6af0 0000000000420018 0000000000000000 0000000000400740
[   34.798471] 3f60: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[   34.798668] 3f80: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[   34.798870] 3fa0: 0000000000000000 0000fffff7294200 00000000004006fc 0000fffff7294200
[   34.799068] 3fc0: 0000ffffb1eb6b24 0000000080000000 0000000000000000 000000000000005f
[   34.799265] 3fe0: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[   34.799474] [<ffff0000080837b0>] el0_svc_naked+0x24/0x28
[   34.799715] Code: f9400fb4 17ffff9a d503201f f9000fb4 (d4210000) 
[   34.800121] ---[ end trace a14ca5cd5d8f9b30 ]---
