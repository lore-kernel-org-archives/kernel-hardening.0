MIME-Version: 1.0
References: <20181026151223.16810-1-ahmedsoliman0x666@gmail.com>
 <20181026151223.16810-2-ahmedsoliman0x666@gmail.com> <20181029164229.GA27144@linux.intel.com>
In-Reply-To: <20181029164229.GA27144@linux.intel.com>
From: Ahmed Soliman <ahmedsoliman0x666@gmail.com>
Date: Wed, 31 Oct 2018 18:02:59 +0200
Message-ID: <CAAGnT3bJUSEnoZotJsMx1ZEMzKF94Fnx8jo=zx4q+uA7mjfLQg@mail.gmail.com>
Subject: Re: gRe: [PATCH V5 1/5] KVM: X86: Memory ROE documentation
Content-Type: text/plain; charset="UTF-8"
To: sean.j.christopherson@intel.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, nathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, =?UTF-8?B?6rmA7J246rK4?= <ovich00@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, nigel.edwards@hpe.com, Boris Lukashev <blukashev@sempervictus.com>, Hossam Hassan <7ossam9063@gmail.com>, Ahmed Lotfy <A7med.lotfey@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 29 Oct 2018 at 18:42, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Oct 26, 2018 at 05:12:19PM +0200, Ahmed Abd El Mawgood wrote:
> > Following up with my previous threads on KVM assisted Anti rootkit
> > protections.
>
> All of the changelogs in this series need to be rewritten to adhere to
> Documentation/process[1].  In particular, use imperative mood and
> describe why/what is being done in a self-contained manner, e.g. the
> above line isn't very helpful without a lot of prior context.
>
> [1] https://github.com/torvalds/linux/blob/master/Documentation/process/submitting-patches.rst#2-describe-your-changes
>
> > The current version doesn't address the attacks involving pages
> > remapping. It is still design in progress, nevertheless, it will be in
> > my later patch sets.
>
> This series should be tagged RFC if its design is a WIP.
Ops my bad, the current description is obsolete and I forgot to remove
it. I will have this fixed as well as your other comments in the next
patch series.
