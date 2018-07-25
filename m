Subject: Re: [PATCH RFC V4 3/3] KVM: X86: Adding skeleton for Memory ROE
References: <20180720233130.14129-1-ahmedsoliman0x666@gmail.com>
 <20180720233130.14129-4-ahmedsoliman0x666@gmail.com>
From: David Hildenbrand <david@redhat.com>
Message-ID: <61b16167-33cf-f435-6a9b-c20ab299e8d2@redhat.com>
Date: Wed, 25 Jul 2018 11:36:23 +0200
MIME-Version: 1.0
In-Reply-To: <20180720233130.14129-4-ahmedsoliman0x666@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>, kvm@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org, x86@kernel.org, xen-devel@lists.xensource.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, nathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, hpa@zytor.com, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Lukashev <blukashev@sempervictus.com>, David Vrabel <david.vrabel@nutanix.com>, nigel.edwards@hpe.com, Rik van Riel <riel@surriel.com>
List-ID: <kernel-hardening.lists.openwall.com>


>  		if (kvm_x86_ops->slot_disable_log_dirty)
>  			kvm_x86_ops->slot_disable_log_dirty(kvm, new);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 4ee7bc548a83..82c5780e11d9 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -297,6 +297,9 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
>  struct kvm_memory_slot {
>  	gfn_t base_gfn;
>  	unsigned long npages;
> +#ifdef CONFIG_KVM_MROE
> +	unsigned long *mroe_bitmap;
> +#endif

Yet another problematic bitmap when it comes to splitting/resizing
memory slots atomically :(


-- 

Thanks,

David / dhildenb
