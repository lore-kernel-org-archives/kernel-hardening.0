Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: yhlu.kernel@gmail.com
In-Reply-To: <515F2E81.9000900@zytor.com>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
	<1365106055-22939-4-git-send-email-keescook@chromium.org>
	<515DE0C9.3030709@zytor.com>
	<CAE9FiQVCC2-yF0+bt2MryHDs2vK8bcsU1aE-is_ejDDF0dTbMQ@mail.gmail.com>
	<515F2E81.9000900@zytor.com>
Date: Fri, 5 Apr 2013 13:19:39 -0700
Message-ID: <CAE9FiQU+k0j-CEvJm-D6Dch4wa8ooU8Zcry8sN0RYx=YEadiJw@mail.gmail.com>
From: Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 3/3] x86: kernel base offset ASLR
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 5, 2013 at 1:05 PM, H. Peter Anvin <hpa@zytor.com> wrote:

> That makes zero difference, since the issue at hand is the *virtual*
> addresses the kernel are running at.  Currently, the 64-bit kernel
> always runs at 0xffffffff81000000 virtual.  We can't run out of
> arbitrary bits of the 64-bit address space because of the memory model.

Not sure if I understand this.

when bzImage64 is loaded high,  the kernel high address 0xffffffff81000000
is pointed to phys address above 4G without problem.

Also during arch/x86/boot/compressed/head_64.S, kernel does not parse
e820 yet, so it can not find right place for kernel yet.

bootloader already parse the e820, and it already know kernel run time size.
So it should be easy for them for crazy random range for kernel.

>
> Furthermore, dealing with the boot loaders means dealing with the boot
> loader maintainers, which can be insanely painful.  Consider that Grub2,
> 10 years after this was implemented, still can't load more than one
> initramfs component.

syslinux and pxelinux could do that?

Thanks

Yinghai
