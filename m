MIME-Version: 1.0
References: <20180719213802.17161-1-ahmedsoliman0x666@gmail.com> <20180719213802.17161-4-ahmedsoliman0x666@gmail.com>
In-Reply-To: <20180719213802.17161-4-ahmedsoliman0x666@gmail.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 20 Jul 2018 00:59:43 +0200
Message-ID: <CAG48ez3EyU=ROBczUdHEuOYBtZghYqOpq3K16Bs4RQLO1OO6oA@mail.gmail.com>
Subject: Re: [PATCH 3/3] [RFC V3] KVM: X86: Adding skeleton for Memory ROE
Content-Type: text/plain; charset="UTF-8"
To: ahmedsoliman0x666@gmail.com
Cc: kvm@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, david@redhat.com, Boris Lukashev <blukashev@sempervictus.com>, david.vrabel@nutanix.com, nigel.edwards@hpe.com, riel@surriel.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 19, 2018 at 11:40 PM Ahmed Abd El Mawgood
<ahmedsoliman0x666@gmail.com> wrote:
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

Why are you implementing this in the kernel, instead of doing it in
host userspace?
