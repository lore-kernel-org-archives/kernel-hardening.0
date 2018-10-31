MIME-Version: 1.0
References: <20181026151223.16810-1-ahmedsoliman0x666@gmail.com> <1b3eb10e-c492-dc77-cbe6-3a3e692326d7@gmail.com>
In-Reply-To: <1b3eb10e-c492-dc77-cbe6-3a3e692326d7@gmail.com>
From: Ahmed Soliman <ahmedsoliman0x666@gmail.com>
Date: Thu, 1 Nov 2018 01:21:00 +0200
Message-ID: <CAAGnT3ao2YugWW_1TuZw4+OiLQsBYLXtcYjARagZ3pGwFhvGZg@mail.gmail.com>
Subject: Re: [PATCH V5 0/5] KVM: X86: Introducing ROE Protection Kernel Hardening
Content-Type: text/plain; charset="UTF-8"
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, nathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, =?UTF-8?B?6rmA7J246rK4?= <ovich00@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, nigel.edwards@hpe.com, Boris Lukashev <blukashev@sempervictus.com>, Hossam Hassan <7ossam9063@gmail.com>, Ahmed Lotfy <A7med.lotfey@gmail.com>, Mohamed Azab <mazab@vt.edu>
List-ID: <kernel-hardening.lists.openwall.com>

Hello Igor,
> This is very interesting, because it seems a very good match to the work
> I'm doing, for supporting the creation of more targets for protection:
>
> https://www.openwall.com/lists/kernel-hardening/2018/10/23/3
>
> In my case the protection would extend also to write-rate type of data.
> There is an open problem of identifying legitimate write-rare
> operations, however it should be possible to provide at least a certain
> degree of confidence.

I have checked your patch set. In our work we were originally planning to do
something similar to write_rare just so we can differentiate between memory
chunks that may be modified and those that will be set once and never modify.
I see you are planning to do a white paper too, actually we are doing
an academic
paper based on our work. If you would like to collaborate, so that ROE
and write_rare
would integrate well from the beginning, we will be glad to do so.

Thanks,
--
Ahmed
Junior Researcher , IoT and Cyber Security lab, SmartCI , Alexandria
University, & CIS @  VMI
