References: <1516473386.30886.35.camel@intel.com>
From: Jiri Slaby <jslaby@suse.cz>
Message-ID: <5fffd4e8-90fe-0799-adf0-5376113b268d@suse.cz>
Date: Wed, 24 Jan 2018 15:47:11 +0100
MIME-Version: 1.0
In-Reply-To: <1516473386.30886.35.camel@intel.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [GIT PULL] spectre variant1 mitigations for 4.16
To: "Williams, Dan J" <dan.j.williams@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "alan@linux.intel.com" <alan@linux.intel.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "Reshetova, Elena" <elena.reshetova@intel.com>, "johannes@sipsolutions.net" <johannes@sipsolutions.net>, "will.deacon@arm.com" <will.deacon@arm.com>, "luto@kernel.org" <luto@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "davem@davemloft.net" <davem@davemloft.net>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 01/20/2018, 07:36 PM, Williams, Dan J wrote:
> Dan Williams (9):
>       asm/nospec, array_ptr: sanitize speculative array de-references
>       x86: implement array_ptr_mask()
>       x86: introduce __uaccess_begin_nospec and ifence
>       x86, __get_user: use __uaccess_begin_nospec
>       x86, get_user: use pointer masking to limit speculation
>       x86: narrow out of bounds syscalls to sys_read under speculation
>       vfs, fdtable: prevent bounds-check bypass via speculative execution
>       kvm, x86: update spectre-v1 mitigation
>       nl80211: sanitize array index in parse_txq_params
> 
> Mark Rutland (1):
>       Documentation: document array_ptr
> 
>  Documentation/speculation.txt     | 143 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/entry/entry_64.S         |   2 +
>  arch/x86/include/asm/barrier.h    |  28 ++++++++
>  arch/x86/include/asm/msr.h        |   3 +-
>  arch/x86/include/asm/smap.h       |  24 +++++++
>  arch/x86/include/asm/uaccess.h    |  15 +++-
>  arch/x86/include/asm/uaccess_32.h |   6 +-
>  arch/x86/include/asm/uaccess_64.h |  12 ++--
>  arch/x86/kvm/vmx.c                |  19 ++---
>  arch/x86/lib/getuser.S            |   5 ++
>  arch/x86/lib/usercopy_32.c        |   8 +--
>  include/linux/fdtable.h           |   7 +-
>  include/linux/nospec.h            |  65 +++++++++++++++++
>  net/wireless/nl80211.c            |  10 ++-

Could you update also cpu_show_spectre_v1?

thanks,
-- 
js
suse labs
