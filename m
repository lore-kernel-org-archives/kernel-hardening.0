Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAE9FiQW5X80bxOURTkhnELuV_AzYXBHEudxN1eUg_1jehrcfww@mail.gmail.com>
References: <1365797627-20874-1-git-send-email-keescook@chromium.org>
	<1365797627-20874-7-git-send-email-keescook@chromium.org>
	<CAE9FiQXGjJCDAo41jxpy9bZJ2svKy8YY-zX7O4YDZPhKo7M43g@mail.gmail.com>
	<516A1D49.1050100@zytor.com>
	<CAG7+5M12cAavi9XBYoe39X=JtpWUu4wxjaAfOZP+=1qaKz7C+A@mail.gmail.com>
	<516C702C.2030209@zytor.com>
	<CAGXu5jJkA0y+5-or4vxUHE5GyNODSoefrYJO7scM1Jh56FoUuA@mail.gmail.com>
	<516C751B.4020505@zytor.com>
	<CAE9FiQW5X80bxOURTkhnELuV_AzYXBHEudxN1eUg_1jehrcfww@mail.gmail.com>
Date: Mon, 15 Apr 2013 15:07:17 -0700
Message-ID: <CAGXu5j+KRVmZqSkvoEH70DCb055uSbVzFkoo+E1Ao=e=Yus_bA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 6/6] x86: kaslr: relocate base offset at boot
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Eric Northup <digitaleric@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 15, 2013 at 3:00 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Apr 15, 2013 at 2:46 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 04/15/2013 02:41 PM, Kees Cook wrote:
>
>> Please read what I wrote.
>>
>> The 2 GB limit is for the *virtual* mapping.
>>
>> The *physical* mapping, where it lands in RAM, is completely
>> independent, and if you're going to randomize the latter, there is no
>> reason it has to match the former.  Instead, randomize it freely.
>>
>> That is different from the i386 kernel which runs at its
>> physical-mapping address.
>>
>> Incidentally, for performance reasons please avoid locating the kernel
>> below CONFIG_PHYSICAL_ADDRESS if possible.
>>
>> Also make sure your code works with more than 128 e820 entries.
>
> also do not overlap with boot_param, command_line, and initrd.
>
> and need to double check setup_header.init_size to make sure bss and
> etc will not
> fall into memory hole or reserved area in e820.
>
> also may need to setup page table for target position as bootloader may only
> has ident mapping only for loaded bzImage 64 areas.
>
> looks you are trying redo the work for bootloader to pick loaded phys addr.

aslr.S's select_aslr_address uses z_extract_offset as the upper bound.

-Kees

--
Kees Cook
Chrome OS Security
