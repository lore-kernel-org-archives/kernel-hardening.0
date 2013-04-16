Reply-To: kernel-hardening@lists.openwall.com
In-Reply-To: <20130416130854.GA20961@gmail.com>
References: <CAE9FiQXGjJCDAo41jxpy9bZJ2svKy8YY-zX7O4YDZPhKo7M43g@mail.gmail.com> <516A1D49.1050100@zytor.com> <CAG7+5M12cAavi9XBYoe39X=JtpWUu4wxjaAfOZP+=1qaKz7C+A@mail.gmail.com> <516C702C.2030209@zytor.com> <CAGXu5jJkA0y+5-or4vxUHE5GyNODSoefrYJO7scM1Jh56FoUuA@mail.gmail.com> <516C751B.4020505@zytor.com> <CAE9FiQW5X80bxOURTkhnELuV_AzYXBHEudxN1eUg_1jehrcfww@mail.gmail.com> <516CB937.2000305@zytor.com> <CAE9FiQU97FHKpKQjZJq+Nfz18eM2n0-V2n4B6m=ozjkycP+Rng@mail.gmail.com> <7f907e0b-c397-460f-a8ec-ce84b119ce84@email.android.com> <20130416130854.GA20961@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 16 Apr 2013 06:27:06 -0700
Message-ID: <13e14f5c-d221-4f2f-84e3-6c2dea48cdaa@email.android.com>
Subject: [kernel-hardening] Re: [PATCH 6/6] x86: kaslr: relocate base offset at boot
To: Ingo Molnar <mingo@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Kees Cook <keescook@chromium.org>, Eric Northup <digitaleric@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Well... G**** is it's own problem (doing actively broken thinks for political reasons), but the real issue mostly is that there are a lot of them simply because there are a lot of ways one may want to load the kernel.

This is why things like decompression and the BIOS and EFI stubs are part of the kernel and not the bootloader.  In this case moving the randomization into the decompressor send like the right thing to do - C code, and no additional copy.

Ingo Molnar <mingo@kernel.org> wrote:

>
>* H. Peter Anvin <hpa@zytor.com> wrote:
>
>> No.  Fixing one bootloader is almost impossible.  Fixing them all is
>a 
>> Sisiphyean task.
>
>It's a self inflicted wound really: if only we had a reference
>bootloader in the 
>kernel tree, which we could fix. The effort that went into fixing
>various 
>bootloader interactions would have been enough to write two new
>bootloaders from 
>scratch.
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
