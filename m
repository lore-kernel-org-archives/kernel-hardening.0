Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <517AF5F2.50404@zytor.com>
Date: Fri, 26 Apr 2013 14:47:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1367003005-5560-1-git-send-email-keescook@chromium.org> <1367003005-5560-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1367003005-5560-4-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 3/6] x86: kaslr: return location from decompress_kernel
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/26/2013 12:03 PM, Kees Cook wrote:
> This allows decompress_kernel to return a new location for the kernel to
> be relocated to. With CONFIG_RANDOMIZE_BASE, the choose_kernel_location
> routine will select a new location to decompress the kernel, and is
> presently a no-op. The logic for bypassing this routine with "noaslr"
> on the kernel command line is handled.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  Documentation/kernel-parameters.txt |    4 ++++
>  arch/x86/boot/compressed/Makefile   |    2 +-
>  arch/x86/boot/compressed/aslr.c     |   21 +++++++++++++++++++++
>  arch/x86/boot/compressed/cmdline.c  |    2 +-
>  arch/x86/boot/compressed/head_32.S  |    2 +-
>  arch/x86/boot/compressed/head_64.S  |    2 +-
>  arch/x86/boot/compressed/misc.c     |    7 +++++--
>  arch/x86/boot/compressed/misc.h     |   22 ++++++++++++++++------
>  8 files changed, 50 insertions(+), 12 deletions(-)
>  create mode 100644 arch/x86/boot/compressed/aslr.c
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 8ccbf27..eb1c62c 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1862,6 +1862,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  	noapic		[SMP,APIC] Tells the kernel to not make use of any
>  			IOAPICs that may be present in the system.
>  
> +	noaslr		[X86]
> +			Disable kernel base offset ASLR (Address Space
> +			Layout Randomization) if built into the kernel.
> +
>  	noautogroup	Disable scheduler automatic task group creation.
>  
>  	nobats		[PPC] Do not use BATs for mapping kernel lowmem

Calling it "nokaslr" might be useful to note that it is specifically
about the kernel.

	-hpa
