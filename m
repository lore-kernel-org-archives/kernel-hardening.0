Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: yhlu.kernel@gmail.com
In-Reply-To: <1367003005-5560-6-git-send-email-keescook@chromium.org>
References: <1367003005-5560-1-git-send-email-keescook@chromium.org>
	<1367003005-5560-6-git-send-email-keescook@chromium.org>
Date: Fri, 26 Apr 2013 14:51:54 -0700
Message-ID: <CAE9FiQVA17TGuY5_DFGUL8OSMLx+yJQV1fhe7JDkaoq1a9-oSw@mail.gmail.com>
From: Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 5/6] x86: kaslr: select memory region from e820 maps
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 26, 2013 at 12:03 PM, Kees Cook <keescook@chromium.org> wrote:
> This chooses the largest contiguous RAM region for the KASLR offset
> to live in.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v2:
>  - make sure to exclude e820 regions outside the 32-bit memory range.

Do you need to execlude range that is used for initrd and possible
command_line and boot_param ?

Yinghai
