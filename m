Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFw+JFfy+dfMbAdB3ueA1O-w--EBwMF4WKrGp754trHBDA@mail.gmail.com>
References: <20160406194404.GA11150@www.outflux.net>
	<20160406201716.GA14241@amd>
	<CA+55aFw+JFfy+dfMbAdB3ueA1O-w--EBwMF4WKrGp754trHBDA@mail.gmail.com>
Date: Wed, 6 Apr 2016 14:25:12 -0700
Message-ID: <CAGXu5jJ+8v_hMkV91jqNGwFdzbpoKL=gZv-92hGMF8d4o8DswQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] Prefer kASLR over Hibernation
To: Linus Torvalds <torvalds@linux-foundation.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Pavel Machek <pavel@denx.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, Yves-Alexis Perez <corsac@debian.org>, Emrah Demir <ed@abdsec.com>, Jonathan Corbet <corbet@lwn.net>, the arch/x86 maintainers <x86@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 6, 2016 at 1:56 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Apr 6, 2016 at 1:17 PM, Pavel Machek <pavel@denx.de> wrote:
>>
>> Why is kASLR incompatible with hibernation? We can hibernate have
>> 4.3 kernel resume hibernation image of 4.2 kernel (on x86-64, and I
>> have patches for x86). Resuming kernel with different randomization
>> does not look that much different...
>
> Oh, I'd absolutely prefer to just allow kaslr together with
> hibernation if it actually works.
>
> Could the people who piped up to say that they actually use
> hibernation just try passing in the "kaslr" command line option on
> their machine, and see if it works for them? We could just remove the
> "no kaslr with hibername" code - or at least limit it to 32-bit for
> now..
>
> Because that would be lovely.

This is where our original investigation of having them coexist ended:
https://lkml.org/lkml/2014/6/15/180

To quote Rafael Wysocki:
> We're jumping from the boot kernel into the image kernel.  The virtual address
> comes from the image kernel, but the boot kernel has to use it.  The only way
> we can ensure that we'll jump to the right place is to pass the physical address
> in the header (otherwise we de facto assume that the virtual address of the
> target page frame will be the same in both the boot and the image kernels).
>
> The missing piece is that the code in swsusp_arch_resume() sets up temporary
> page tables to ensure that they won't be overwritten while copying the last
> remaining image kernel pages to the right page frames (those page tables
> have to be stored in page frames that are free from the kernel image perspective).
>
> But if the kernel address space is randomized, set_up_temporary_mappings()
> really should duplicate the existing layout instead of creating a new one from
> scratch.  Otherwise, virtual addresses before set_up_temporary_mappings() may
> be different from the ones after it.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
