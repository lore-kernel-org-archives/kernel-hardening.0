References: <151632009605.21271.11304291057104672116.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151632014097.21271.16980532033566583357.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Jiri Slaby <jslaby@suse.cz>
Message-ID: <f858abdb-f142-7157-c785-ca9eca919de1@suse.cz>
Date: Wed, 24 Jan 2018 15:40:40 +0100
MIME-Version: 1.0
In-Reply-To: <151632014097.21271.16980532033566583357.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v4 07/10] x86: narrow out of bounds syscalls to sys_read
 under speculation
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

On 01/19/2018, 01:02 AM, Dan Williams wrote:
> The syscall table base is a user controlled function pointer in kernel
> space. Like, 'get_user, use 'MASK_NOSPEC' to prevent any out of bounds
> speculation. While retpoline prevents speculating into the user
> controlled target it does not stop the pointer de-reference, the concern
> is leaking memory relative to the syscall table base.
> 
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/x86/entry/entry_64.S   |    2 ++
>  arch/x86/include/asm/smap.h |    9 ++++++++-
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index 4f8e1d35a97c..2320017077d4 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -35,6 +35,7 @@
>  #include <asm/asm.h>
>  #include <asm/smap.h>
>  #include <asm/pgtable_types.h>
> +#include <asm/smap.h>

This is already included 2 lines above

thanks,
-- 
js
suse labs
