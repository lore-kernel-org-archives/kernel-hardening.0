Date: Tue, 22 Jan 2019 11:10:50 +0800
From: Chao Gao <chao.gao@intel.com>
Subject: Re: [RESEND PATCH V8 05/11] KVM: Create architecture independent ROE
 skeleton
Message-ID: <20190122031049.GA18314@gao-cwp>
References: <20190120233940.15282-1-ahmedsoliman@mena.vt.edu>
 <20190120233940.15282-6-ahmedsoliman@mena.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190120233940.15282-6-ahmedsoliman@mena.vt.edu>
To: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
Cc: Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, ahmedsoliman0x666@gmail.com, ovich00@gmail.com, kernel-hardening@lists.openwall.com, nigel.edwards@hpe.com, Boris Lukashev <blukashev@sempervictus.com>, Igor Stoppa <igor.stoppa@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 21, 2019 at 01:39:34AM +0200, Ahmed Abd El Mawgood wrote:
>This patch introduces a hypercall that can assist against subset of kernel
>rootkits, it works by place readonly protection in shadow PTE. The end
>result protection is also kept in a bitmap for each kvm_memory_slot and is
>used as reference when updating SPTEs. The whole goal is to protect the
>guest kernel static data from modification if attacker is running from
>guest ring 0, for this reason there is no hypercall to revert effect of
>Memory ROE hypercall. This patch doesn't implement integrity check on guest
>TLB so obvious attack on the current implementation will involve guest
>virtual address -> guest physical address remapping, but there are plans to
>fix that.

Hello Ahmed,

I don't quite understand the attack. Do you mean that even one guest
page is protected by ROE, an attacker can map the virtual address to
another unprotected guest page by editing guest page table?

Thanks
Chao
