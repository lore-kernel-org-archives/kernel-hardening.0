MIME-Version: 1.0
In-Reply-To: <CAG48ez3EyU=ROBczUdHEuOYBtZghYqOpq3K16Bs4RQLO1OO6oA@mail.gmail.com>
References: <20180719213802.17161-1-ahmedsoliman0x666@gmail.com>
 <20180719213802.17161-4-ahmedsoliman0x666@gmail.com> <CAG48ez3EyU=ROBczUdHEuOYBtZghYqOpq3K16Bs4RQLO1OO6oA@mail.gmail.com>
From: Ahmed Soliman <ahmedsoliman0x666@gmail.com>
Date: Fri, 20 Jul 2018 02:26:46 +0200
Message-ID: <CAAGnT3aQhvHJ4H1vaTYiYotN022wh1if76=xywTVGqA5o_UQrA@mail.gmail.com>
Subject: Re: [PATCH 3/3] [RFC V3] KVM: X86: Adding skeleton for Memory ROE
Content-Type: text/plain; charset="UTF-8"
To: Jann Horn <jannh@google.com>
Cc: kvm@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Hildenbrand <david@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, David Vrabel <david.vrabel@nutanix.com>, nigel.edwards@hpe.com, Rik van Riel <riel@surriel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 20 July 2018 at 00:59, Jann Horn <jannh@google.com> wrote:
> On Thu, Jul 19, 2018 at 11:40 PM Ahmed Abd El Mawgood

> Why are you implementing this in the kernel, instead of doing it in
> host userspace?

I thought about implementing it completely in QEMU but It won't be
possible for few reasons:

- After talking to QEMU folks I came up to conclusion that it when it
 comes to managing memory allocated for guest, it is always better to let
 KVM handles everything, unless there is a good reason to play with that
 memory chunk inside QEMU itself.
- But actually there is a good reason for implementing ROE in kernel space,
 it is that ROE is architecture dependent to great extent. I should have
 emphasized that the only currently supported architecture is X86. I am
 not sure how deep the dependency on architecture goes. But as for now
 the current set of patches does a SPTE enumeration as part of the process.
 To my best knowledge, this isn't exposed outside arch/x68/kvm let alone
 having a host user space interface for it. Also the way I am planning to
 protect TLB from malicious gva -> gpa mapping is by knowing that in x86
 it is possible to VMEXIT on page faults, I am not sure if it will safe to
 assume that all kvm supported architectures will behave this way.

For these reasons I thought it will be better if arch dependent stuff (the
mechanism implementation) is kept in arch/*/kvm folder and with minimal
modifications to virt/kvm/* after setting a kconfig variable to enable ROE.
But I left room for the user space app using kvm to decide the rightful policy
for handling ROE violations. The way it works by KVM_EXIT_MMIO error to user
space, keeping all the architectural details hidden away from user space.

A last note is that I didn't create this from scratch, instead I extended
KVM_MEM_READONLY implementation to also allow R/O per page instead
R/O per whole slot which is already done in kernel space.
