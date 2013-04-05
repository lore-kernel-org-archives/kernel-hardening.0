Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 5 Apr 2013 09:11:44 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20130405071144.GB26889@gmail.com>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
 <1365106055-22939-4-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365106055-22939-4-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH 3/3] x86: kernel base offset ASLR
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> This creates CONFIG_RANDOMIZE_BASE, so that the base offset of the kernel
> can be randomized at boot.
> 
> This makes kernel vulnerabilities harder to reliably exploit, especially
> from remote attacks and local processes in seccomp containers. Keeping
> the location of kernel addresses secret becomes very important when using
> this feature, so enabling kptr_restrict and dmesg_restrict is recommended.
> Besides direct address leaks, several other attacks are possible to bypass
> this on local systems, including cache timing[1]. However, the benefits of
> this feature in certain environments exceed the perceived weaknesses[2].
> 
> An added security benefit is making the IDT read-only.
> 
> Current entropy is low, since the kernel has basically a minimum 2MB
> alignment and has been built with -2G memory addressing. As a result,
> available entropy will be 8 bits in the best case. The e820 entries on
> a given system may further limit the available memory.
> 
> This feature is presently incompatible with hibernation.
> 
> When built into the kernel, the "noaslr" kernel command line option will
> disable the feature.
> 
> Heavily based on work by Dan Rosenberg[3] and Neill Clift.
> 
> [1] http://www.internetsociety.org/sites/default/files/Practical%20Timing%20Side%20Channel%20Attacks%20Against%20Kernel%20Space%20ASLR.pdf
> [2] http://forums.grsecurity.net/viewtopic.php?f=7&t=3367
> [3] http://lkml.indiana.edu/hypermail/linux/kernel/1105.3/index.html#00520
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: Eric Northup <digitaleric@google.com>
> ---
>  Documentation/kernel-parameters.txt  |    4 +
>  arch/x86/Kconfig                     |   51 +++++++++++--
>  arch/x86/Makefile                    |    3 +
>  arch/x86/boot/compressed/head_32.S   |   21 +++++-
>  arch/x86/boot/compressed/head_64.S   |  135 ++++++++++++++++++++++++++++++++--
>  arch/x86/include/asm/fixmap.h        |    4 +
>  arch/x86/include/asm/page_32_types.h |    2 +
>  arch/x86/include/asm/page_64_types.h |    4 -
>  arch/x86/include/asm/page_types.h    |    4 +
>  arch/x86/kernel/asm-offsets.c        |   14 ++++
>  arch/x86/kernel/setup.c              |   24 ++++++
>  arch/x86/kernel/traps.c              |    6 ++
>  12 files changed, 251 insertions(+), 21 deletions(-)

Before going into the details, I have a structural request: could you 
please further increase the granularity of the patch-set?

In particular I'd suggest introducing a helper Kconfig bool that makes the 
IDT readonly - instead of using CONFIG_RANDOMIZE_BASE for that. 
CONFIG_RANDOMIZE_BASE can then select this helper Kconfig switch.

Users could also select a readonly-IDT - even if they don't want a 
randomized kernel.

With that done, it would be nice to implement the read-only IDT changes in 
a separate, preparatory patch. If it causes any problems it will be easier 
to isolate.

Thanks,

	Ingo
