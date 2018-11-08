Subject: Re: [PATCH V6 0/8] KVM: X86: Introducing ROE Protection Kernel
 Hardening
References: <20181104171124.5717-1-ahmedsoliman0x666@gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <24f900ba-6459-c6aa-4e97-92f0ec744896@redhat.com>
Date: Thu, 8 Nov 2018 21:25:37 +0100
MIME-Version: 1.0
In-Reply-To: <20181104171124.5717-1-ahmedsoliman0x666@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>, rkrcmar@redhat.com, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, ovich00@gmail.com, kernel-hardening@lists.openwall.com, nigel.edwards@hpe.com, Boris Lukashev <blukashev@sempervictus.com>, Hossam Hassan <7ossam9063@gmail.com>, "Ahmed Lotfy igor . stoppa @ gmail . com" <A7med.lotfey@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/11/2018 18:11, Ahmed Abd El Mawgood wrote:
> Our model assumes that an attacker got full root access to a running guest and
> his goal is to manipulate kernel code/data (hook syscalls, overwrite IDT ..etc).
> 
> There is future work in progress to also put some sort of protection on the page
> table register CR3 and other critical registers that can be intercepted by KVM.
> This way it won't be possible for an attacker to manipulate any part of the
> guests page table.
> 

Do you have patches that enable usage of ROE in the kernel?
Alternatively you can write testcases in tools/testing/selftests/kvm to
test how guests should use it.

I would remove CONFIG_KVM_ROE altogether.  You can enable it
unconditionally.

I will continue reviewing the patches soon.

Paolo
