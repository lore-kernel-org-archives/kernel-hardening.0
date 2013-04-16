Reply-To: kernel-hardening@lists.openwall.com
In-Reply-To: <CAE9FiQU97FHKpKQjZJq+Nfz18eM2n0-V2n4B6m=ozjkycP+Rng@mail.gmail.com>
References: <1365797627-20874-1-git-send-email-keescook@chromium.org> <1365797627-20874-7-git-send-email-keescook@chromium.org> <CAE9FiQXGjJCDAo41jxpy9bZJ2svKy8YY-zX7O4YDZPhKo7M43g@mail.gmail.com> <516A1D49.1050100@zytor.com> <CAG7+5M12cAavi9XBYoe39X=JtpWUu4wxjaAfOZP+=1qaKz7C+A@mail.gmail.com> <516C702C.2030209@zytor.com> <CAGXu5jJkA0y+5-or4vxUHE5GyNODSoefrYJO7scM1Jh56FoUuA@mail.gmail.com> <516C751B.4020505@zytor.com> <CAE9FiQW5X80bxOURTkhnELuV_AzYXBHEudxN1eUg_1jehrcfww@mail.gmail.com> <516CB937.2000305@zytor.com> <CAE9FiQU97FHKpKQjZJq+Nfz18eM2n0-V2n4B6m=ozjkycP+Rng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 15 Apr 2013 20:02:00 -0700
Message-ID: <7f907e0b-c397-460f-a8ec-ce84b119ce84@email.android.com>
Subject: [kernel-hardening] Re: [PATCH 6/6] x86: kaslr: relocate base offset at boot
To: Yinghai Lu <yinghai@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Eric Northup <digitaleric@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

No.  Fixing one bootloader is almost impossible.  Fixing them all is a Sisiphyean task.

Yinghai Lu <yinghai@kernel.org> wrote:

>On Mon, Apr 15, 2013 at 7:36 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 04/15/2013 03:00 PM, Yinghai Lu wrote:
>>>
>>> looks you are trying redo the work for bootloader to pick loaded
>phys addr.
>>>
>>
>> Well, that is exactly what they are doing.  On top of that they also
>> need to randomize the 64-bit virtual mapping.
>>
>> I wonder if we need a bootloader bit to inhibit kaslr in addition to
>the
>> command line...
>
>so let the bootloader to parse kaslr and pick ramdom address,
>and kernel arch/x86/boot/compressed/head_64.S to pick random virtual
>address?
>
>Yinghai

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
