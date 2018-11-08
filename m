MIME-Version: 1.0
References: <20181104171124.5717-1-ahmedsoliman0x666@gmail.com> <24f900ba-6459-c6aa-4e97-92f0ec744896@redhat.com>
In-Reply-To: <24f900ba-6459-c6aa-4e97-92f0ec744896@redhat.com>
From: Ahmed Soliman <ahmedsoliman0x666@gmail.com>
Date: Thu, 8 Nov 2018 22:54:00 +0200
Message-ID: <CAAGnT3Y8SwD-jm2x2k7y2EZMsHdfua4-tnfu8o_ajyV+n4imcA@mail.gmail.com>
Subject: Re: [PATCH V6 0/8] KVM: X86: Introducing ROE Protection Kernel Hardening
Content-Type: text/plain; charset="UTF-8"
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, nathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, =?UTF-8?B?6rmA7J246rK4?= <ovich00@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, nigel.edwards@hpe.com, Boris Lukashev <blukashev@sempervictus.com>, Hossam Hassan <7ossam9063@gmail.com>, Ahmed Lotfy <A7med.lotfey@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hello,

> Do you have patches that enable usage of ROE in the kernel?
> Alternatively you can write testcases in tools/testing/selftests/kvm to
> test how guests should use it.

As for now ROE isn't integrated yet into the kernel, I did have some
tests I will
have them in  selftests/kvm in the next patch set

> I would remove CONFIG_KVM_ROE altogether.  You can enable it
> unconditionally.

Noted, I will have it enabled unconditionally in the next patch set.

> I will continue reviewing the patches soon.
>
> Paolo
