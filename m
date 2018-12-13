MIME-Version: 1.0
References: <20181207124803.10828-1-ahmedsoliman@mena.vt.edu> <1544708187.5826.1.camel@amazon.de>
In-Reply-To: <1544708187.5826.1.camel@amazon.de>
From: Ahmed Soliman <ahmedsoliman@mena.vt.edu>
Date: Thu, 13 Dec 2018 18:00:05 +0200
Message-ID: <CANBxJ=FP9GSfMES3e5dSct2qV0Z=uz7uPXufQNqoi5e+sWxvgQ@mail.gmail.com>
Subject: Re: [PATCH V7 0/10] KVM: X86: Introducing ROE Protection Kernel Hardening
Content-Type: text/plain; charset="UTF-8"
To: jsteckli@amazon.de
Cc: Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Ahmed Soliman <ahmedsoliman0x666@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, =?UTF-8?B?6rmA7J246rK4?= <ovich00@gmail.com>, x86@kernel.org, Igor Stoppa <igor.stoppa@gmail.com>, hpa@zytor.com, Ingo Molnar <mingo@redhat.com>, nigel.edwards@hpe.com, Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, kernel-hardening@lists.openwall.com, rkrcmar@redhat.com, linux-doc@vger.kernel.org, Boris Lukashev <blukashev@sempervictus.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hello,

> Given that writes to these areas should be exceptional occurrences,

No not in the case of partially protected page.

> I don't  understand why this path needs to be optimized. To me it seems, a straight-
> forward userspace implementation with no additional code in the kernel achieves
> the same feature. Can you elaborate?

The performance hit I was talking about was when dealing with page with
mixed content, given that page is partially read only and partially writable.
The way this is handled is by emulating the writes from inside kvm, now if this
was done from host's userspace, then every write operating (a size of at most
1 cpu  word I guess ?) will require switching from guest to kvm and then to host
userspace, which is major performance hit. I originally made it for protecting
guest's page table part that shouldn't be remapped ever. Since the page table
gets modified a lot, emulating the writes from host user space instead
of the kernel
would add an unnecessary overhead. Also it doesn't sound right to me
to place the
protection inside the page table when it can be placed inside the
virtualization EPT.

But aside from that, I think I was wrong about hinting that it is
simple when done from
user space, handling cases like THP and huge pages (which I did not support yet)
doesn't seam to be easy when done from user space and when doing Registers
ROE has some arch specific details. That's why I think it is better to
continue doing
it from KVM kernel module.

thanks,
Ahmed
