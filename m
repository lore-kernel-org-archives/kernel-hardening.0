Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160415083105.GG30715@gmail.com>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
	<1460672954-32567-8-git-send-email-keescook@chromium.org>
	<20160415083105.GG30715@gmail.com>
Date: Fri, 15 Apr 2016 12:26:08 -0700
Message-ID: <CAGXu5j+3zO=csJuZkYsqCwD3hgCCUfJtUwGnKJZEBmga6hbJhA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 07/21] x86, boot: Fix run_size calculation
To: Ingo Molnar <mingo@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Junjie Mao <eternal.n08@gmail.com>, Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Dave Young <dyoung@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 15, 2016 at 1:31 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> From: Yinghai Lu <yinghai@kernel.org>
>>
>> Currently, the kernel run_size (size of code plus brk and bss) is
>> calculated via the shell script arch/x86/tools/calc_run_size.sh.
>> It gets the file offset and mem size of for the .bss and .brk sections in
>> vmlinux, and adds them as follows:
>
> 'of for'?
>
>> So, from this we can see that the existing run_size calculation is
>> 0x400000 too high.
>
> Btw., why is it too high? Were some sections discarded?

I'm not sure why it's that specific value, but the old method used the
section's ELF _file_ position, not the virtual address, and that
seemed to cause the problem.

>
>> [...] And, as it turns out, the correct run_size is
>> actually equal to VO_end - VO_text, which is certainly easier to calculate.
>> _end: 0xffffffff8205f000
>> _text:0xffffffff81000000
>>
>> 0xffffffff8205f000 - 0xffffffff81000000 = 0x105f000
>>
>> As a result, run_size is a simple constant, so we don't need to pass it
>> around; we already have voffset.h such things.
>
> (Typo.)
>
>> [...] We can share voffset.h
>> between misc.c and header.S instead of getting run_size in other ways.
>> This patch moves voffset.h creation code to boot/compressed/Makefile,
>> and switches misc.c to use the VO_end - VO_text calculation.
>
> Btw., 'run_size' is a pretty meaningless name, it doesn't really tell us the most
> important thing: that this is the complete size of the uncompressed kernel, the
> total physically continuous size we need to allocate to it so it can execute?
>
> So can we rename it to something more expressive, such as kernel_total_size or so?

You got it. Thanks again for digging through all this!

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
