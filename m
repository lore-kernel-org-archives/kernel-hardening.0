MIME-Version: 1.0
In-Reply-To: <151727419015.33451.13762926723789552997.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151727412964.33451.17213780323040673404.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151727419015.33451.13762926723789552997.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 30 Jan 2018 19:22:12 -0800
Message-ID: <CAPcyv4ihnC+ALbvqUWOOZ9zwBv7iy+2pBjLn9ed_duo9Z4TGKQ@mail.gmail.com>
Subject: Re: [PATCH v6 11/13] kvm, x86: update spectre-v1 mitigation
Content-Type: text/plain; charset="UTF-8"
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: linux-arch <linux-arch@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Honig <ahonig@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Alan Cox <alan@linux.intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jim Mattson <jmattson@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 29, 2018 at 5:03 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Commit 75f139aaf896 "KVM: x86: Add memory barrier on vmcs field lookup"
> added a raw 'asm("lfence");' to prevent a bounds check bypass of
> 'vmcs_field_to_offset_table'. We can save an lfence in this path and
> just use the common array_index_nospec() helper designed for these types
> of fixes.
>
> Cc: Andrew Honig <ahonig@google.com>
> Cc: Jim Mattson <jmattson@google.com>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>


Hi Thomas,

I notice this one missing from -tip, I suspect because of the
collision with the raw 'lfence' that is in current mainline? No
worries, I'll send a rebased fixup to Paolo directly once
array_idx_nospec() goes upstream.


> ---
>  arch/x86/kvm/vmx.c |   14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 924589c53422..8514186241d2 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -34,6 +34,7 @@
>  #include <linux/tboot.h>
>  #include <linux/hrtimer.h>
>  #include <linux/frame.h>
> +#include <linux/nospec.h>
>  #include "kvm_cache_regs.h"
>  #include "x86.h"
>
> @@ -883,13 +884,18 @@ static const unsigned short vmcs_field_to_offset_table[] = {
>
>  static inline short vmcs_field_to_offset(unsigned long field)
>  {
> -       BUILD_BUG_ON(ARRAY_SIZE(vmcs_field_to_offset_table) > SHRT_MAX);
> +       const size_t size = ARRAY_SIZE(vmcs_field_to_offset_table);
> +       unsigned short offset;
>
> -       if (field >= ARRAY_SIZE(vmcs_field_to_offset_table) ||
> -           vmcs_field_to_offset_table[field] == 0)
> +       BUILD_BUG_ON(size > SHRT_MAX);
> +       if (field >= size)
>                 return -ENOENT;
>
> -       return vmcs_field_to_offset_table[field];
> +       field = array_index_nospec(field, size);
> +       offset = vmcs_field_to_offset_table[field];
> +       if (offset == 0)
> +               return -ENOENT;
> +       return offset;
>  }
>
>  static inline struct vmcs12 *get_vmcs12(struct kvm_vcpu *vcpu)
>
