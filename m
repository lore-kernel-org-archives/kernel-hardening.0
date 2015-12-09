Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <565CCCBB.1070500@zytor.com>
References: <1448494286-16029-1-git-send-email-keescook@chromium.org>
	<1448494286-16029-3-git-send-email-keescook@chromium.org>
	<56564F0F.3158.108D0B78@pageexec.freemail.hu>
	<565CCCBB.1070500@zytor.com>
Date: Wed, 9 Dec 2015 11:35:11 -0800
Message-ID: <CAGXu5jLNpccwENe7c=uPeqFV+5ZFe+xOxS5djffPuEuCEw8gHQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 2/4] introduce post-init read-only memory
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: PaX Team <pageexec@freemail.hu>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 30, 2015 at 2:24 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/25/15 16:15, PaX Team wrote:
>> On 25 Nov 2015 at 15:31, Kees Cook wrote:
>>
>>> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
>>> index c4bd0e2c173c..772c784ba763 100644
>>> --- a/include/asm-generic/vmlinux.lds.h
>>> +++ b/include/asm-generic/vmlinux.lds.h
>>> @@ -256,6 +256,7 @@
>>>   .rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {              \
>>>    VMLINUX_SYMBOL(__start_rodata) = .;                       \
>>>    *(.rodata) *(.rodata.*)                                   \
>>> +            *(.data..ro_after_init) /* Read only after init */      \
>>    ^^^^^^^^^^^
>> looks like it's tabs vs. spaces...

Not sure what caused that, but I see it as tabs in my tree.

> One more thing... double dots I think has special meanings to gcc, so it
> might be better to avoid.

Hrm, I could find no information about this, so I've left it as-is.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
