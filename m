Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: yhlu.kernel@gmail.com
In-Reply-To: <CAGXu5jJWxHB-oPjGVV5y2jeSNf0At1+3nFgAR0UET8dzxcjB1g@mail.gmail.com>
References: <1365797627-20874-1-git-send-email-keescook@chromium.org>
	<1365797627-20874-7-git-send-email-keescook@chromium.org>
	<CAE9FiQXGjJCDAo41jxpy9bZJ2svKy8YY-zX7O4YDZPhKo7M43g@mail.gmail.com>
	<516A1D49.1050100@zytor.com>
	<CAG7+5M12cAavi9XBYoe39X=JtpWUu4wxjaAfOZP+=1qaKz7C+A@mail.gmail.com>
	<516C702C.2030209@zytor.com>
	<CAGXu5jJkA0y+5-or4vxUHE5GyNODSoefrYJO7scM1Jh56FoUuA@mail.gmail.com>
	<516C751B.4020505@zytor.com>
	<CAE9FiQW5X80bxOURTkhnELuV_AzYXBHEudxN1eUg_1jehrcfww@mail.gmail.com>
	<CAGXu5j+KRVmZqSkvoEH70DCb055uSbVzFkoo+E1Ao=e=Yus_bA@mail.gmail.com>
	<CAE9FiQWosJRz14HgSq0cDYfsdSsMO9Vpbjd4f5UL3R6KHmOK5Q@mail.gmail.com>
	<CAGXu5jJWxHB-oPjGVV5y2jeSNf0At1+3nFgAR0UET8dzxcjB1g@mail.gmail.com>
Date: Mon, 15 Apr 2013 15:57:09 -0700
Message-ID: <CAE9FiQXZcXpyEqHvON0D3u2ivcWQo1=rC1kkt5GLU4rEYaVoQw@mail.gmail.com>
From: Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 6/6] x86: kaslr: relocate base offset at boot
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Eric Northup <digitaleric@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 15, 2013 at 3:42 PM, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Apr 15, 2013 at 3:38 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>
>> so the decompressed image is not moved high?
>
> No, I mean the size of the relocated image is using z_extract_offset
> as the end size of the relocated memory. See select_aslr_address. It
> takes the chosen aslr offset plus the location of z_extract_offset and
> keeps reducing the offset until it's inside the physical end of
> memory.

My point is:
If you move the decompressed high, for example, before aslr uncompressed
vmlinx is on [1024g+16M, 1024g+256M).
after aslr, it is on [1024g+16M + 32M, 1024g+256M + 32M).

You will need to make sure that 32M is still RAM in e820 memmap.
also those range should not be with boot_param, command line, and initrd.
as bootloader could put boot_param, commandline and initrd in that 32M range.

Yinghai
