Subject: Re: [PATCH 3/3] [RFC V3] KVM: X86: Adding skeleton for Memory ROE
References: <20180719213802.17161-1-ahmedsoliman0x666@gmail.com>
 <20180719213802.17161-4-ahmedsoliman0x666@gmail.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <26f2e29b-c016-7140-4fea-853fbbd01459@infradead.org>
Date: Thu, 19 Jul 2018 18:07:59 -0700
MIME-Version: 1.0
In-Reply-To: <20180719213802.17161-4-ahmedsoliman0x666@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>, kvm@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org, x86@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, nathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, hpa@zytor.com, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Hildenbrand <david@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, David Vrabel <david.vrabel@nutanix.com>, nigel.edwards@hpe.com, Rik van Riel <riel@surriel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 07/19/2018 02:38 PM, Ahmed Abd El Mawgood wrote:
> This patch introduces a hypercall implemented for X86 that can assist
> against subset of kernel rootkits, it works by place readonly protection in
> shadow PTE. The end result protection is also kept in a bitmap for each
> kvm_memory_slot and is used as reference when updating SPTEs. The whole
> goal is to protect the guest kernel static data from modification if
> attacker is running from guest ring 0, for this reason there is no
> hypercall to revert effect of Memory ROE hypercall. This patch doesn't
> implement integrity check on guest TLB so obvious attack on the current
> implementation will involve guest virtual address -> guest physical
> address remapping, but there are plans to fix that.
> 
> Signed-off-by: Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>
> ---

> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 92fd433c50b9..8ae822a8dc7a 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -96,6 +96,13 @@ config KVM_MMU_AUDIT
>  	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
>  	 auditing of KVM MMU events at runtime.
>  
> +config KVM_MROE
> +	bool "Hypercall Memory Read-Only Enforcement"
> +	depends on KVM && X86
> +	help
> +	This option add KVM_HC_HMROE hypercall to kvm which as hardening

	            adds                       to kvm as a hardening   (???)


> +	mechanism to protect memory pages from being edited.
> +
>  # OK, it's a little counter-intuitive to do this, but it puts it neatly under
>  # the virtualization menu.
>  source drivers/vhost/Kconfig


-- 
~Randy
