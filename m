Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <516CB8A8.2080007@zytor.com>
Date: Mon, 15 Apr 2013 19:34:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1365797627-20874-1-git-send-email-keescook@chromium.org> <1365797627-20874-7-git-send-email-keescook@chromium.org> <CAE9FiQXGjJCDAo41jxpy9bZJ2svKy8YY-zX7O4YDZPhKo7M43g@mail.gmail.com> <516A1D49.1050100@zytor.com> <CAG7+5M12cAavi9XBYoe39X=JtpWUu4wxjaAfOZP+=1qaKz7C+A@mail.gmail.com> <516C702C.2030209@zytor.com> <CAGXu5jJkA0y+5-or4vxUHE5GyNODSoefrYJO7scM1Jh56FoUuA@mail.gmail.com> <516C751B.4020505@zytor.com> <CAE9FiQW5X80bxOURTkhnELuV_AzYXBHEudxN1eUg_1jehrcfww@mail.gmail.com> <CAGXu5j+KRVmZqSkvoEH70DCb055uSbVzFkoo+E1Ao=e=Yus_bA@mail.gmail.com> <CAE9FiQWosJRz14HgSq0cDYfsdSsMO9Vpbjd4f5UL3R6KHmOK5Q@mail.gmail.com>
In-Reply-To: <CAE9FiQWosJRz14HgSq0cDYfsdSsMO9Vpbjd4f5UL3R6KHmOK5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 6/6] x86: kaslr: relocate base offset at boot
To: Yinghai Lu <yinghai@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Eric Northup <digitaleric@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/15/2013 03:38 PM, Yinghai Lu wrote:
> On Mon, Apr 15, 2013 at 3:07 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Mon, Apr 15, 2013 at 3:00 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> also do not overlap with boot_param, command_line, and initrd.
>>>
>>> and need to double check setup_header.init_size to make sure bss and
>>> etc will not
>>> fall into memory hole or reserved area in e820.
>>>
>>> also may need to setup page table for target position as bootloader may only
>>> has ident mapping only for loaded bzImage 64 areas.
>>>
>>> looks you are trying redo the work for bootloader to pick loaded phys addr.
>>
>> aslr.S's select_aslr_address uses z_extract_offset as the upper bound.

That seems really, really odd.

> so the decompressed image is not moved high?

This really seems wrong in so many ways.

If you relocate pre-decompression the amount of memory you need is given
by init_size:

#define ZO_INIT_SIZE    (ZO__end - ZO_startup_32 + ZO_z_extract_offset)
#define VO_INIT_SIZE    (VO__end - VO__text)
#if ZO_INIT_SIZE > VO_INIT_SIZE
#define INIT_SIZE ZO_INIT_SIZE
#else
#define INIT_SIZE VO_INIT_SIZE
#endif
init_size:              .long INIT_SIZE         # kernel initialization size

In real life, VO_INIT_SIZE dominates almost every time.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
