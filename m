Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <151648239535.34747.4422108674633222531.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Sun, 21 Jan 2018 11:16:59 -0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <867402A5-BED8-4A44-9770-7D3B153BEE82@amacapital.net>
References: <151648235823.34747.15181877619346237802.stgit@dwillia2-desk3.amr.corp.intel.com> <151648239535.34747.4422108674633222531.stgit@dwillia2-desk3.amr.corp.intel.com>
Subject: [kernel-hardening] Re: [PATCH v4.1 07/10] x86: narrow out of bounds syscalls to sys_read under speculation
To: Dan Williams <dan.j.williams@intel.com>
Cc: tglx@linutronix.de, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>



> On Jan 20, 2018, at 1:06 PM, Dan Williams <dan.j.williams@intel.com> wrote=
:
>=20
> The syscall table base is a user controlled function pointer in kernel
> space. Like, 'get_user, use 'MASK_NOSPEC' to prevent any out of bounds
> speculation. While retpoline prevents speculating into the user
> controlled target it does not stop the pointer de-reference, the concern
> is leaking memory relative to the syscall table base.
>=20
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> arch/x86/entry/entry_64.S   |    2 ++
> arch/x86/include/asm/smap.h |    9 ++++++++-
> 2 files changed, 10 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index 63f4320602a3..584f6d2236b3 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -35,6 +35,7 @@
> #include <asm/asm.h>
> #include <asm/smap.h>
> #include <asm/pgtable_types.h>
> +#include <asm/smap.h>
> #include <asm/export.h>
> #include <asm/frame.h>
> #include <asm/nospec-branch.h>
> @@ -260,6 +261,7 @@ entry_SYSCALL_64_fastpath:
>    cmpl    $__NR_syscall_max, %eax
> #endif
>    ja    1f                /* return -ENOSYS (already in pt_regs->ax) */
> +    MASK_NOSPEC %r11 %rax            /* sanitize syscall_nr wrt speculati=
on */

What's the threat you're protecting against?  No one does any computation or=
 data dependent loads based on the value being read.  Or are you worried abo=
ut ASLR leaks due to merely speculatively loading from a bogus address.=
