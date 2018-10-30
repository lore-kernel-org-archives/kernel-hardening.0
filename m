MIME-Version: 1.0
References: <20181026151223.16810-1-ahmedsoliman0x666@gmail.com> <20181029064640.GE128403@gmail.com>
In-Reply-To: <20181029064640.GE128403@gmail.com>
From: Ahmed Soliman <ahmedsoliman0x666@gmail.com>
Date: Tue, 30 Oct 2018 18:49:35 +0200
Message-ID: <CAAGnT3atejrUi6ypZPiDCtMVUP6vx51sKkc2yeQg0SF8-kra8w@mail.gmail.com>
Subject: Re: [PATCH V5 0/5] KVM: X86: Introducing ROE Protection Kernel Hardening
Content-Type: text/plain; charset="UTF-8"
To: mingo@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, nathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, =?UTF-8?B?6rmA7J246rK4?= <ovich00@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, nigel.edwards@hpe.com, Boris Lukashev <blukashev@sempervictus.com>, Hossam Hassan <7ossam9063@gmail.com>, Ahmed Lotfy <A7med.lotfey@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 29 Oct 2018 at 08:46, Ingo Molnar <mingo@kernel.org> wrote:
>
>
> * Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com> wrote:
>
> > This is the 5th version which is 4th version with minor fixes. ROE is a
> > hypercall that enables host operating system to restrict guest's access to its
> > own memory. This will provide a hardening mechanism that can be used to stop
> > rootkits from manipulating kernel static data structures and code. Once a memory
> > region is protected the guest kernel can't even request undoing the protection.
> >
> > Memory protected by ROE should be non-swapable because even if the ROE protected
> > page got swapped out, It won't be possible to write anything in its place.
> >
> > ROE hypercall should be capable of either protecting a whole memory frame or
> > parts of it. With these two, it should be possible for guest kernel to protect
> > its memory and all the page table entries for that memory inside the page table.
> > I am still not sure whether this should be part of ROE job or the guest's job.
> >
> >
> > The reason why it would be better to implement this from inside kvm: instead of
> > (host) user space is the need to access SPTEs to modify the permissions, while
> > mprotect() from user space can work in theory. It will become a big performance
> > hit to vmexit and switch to user space mode on each fault, on the other hand,
> > having the permission handled by EPT should make some remarkable performance
> > gain.
> >
> > Our model assumes that an attacker got full root access to a running guest and
> > his goal is to manipulate kernel code/data (hook syscalls, overwrite IDT ..etc).
> >
> > There is future work in progress to also put some sort of protection on the page
> > table register CR3 and other critical registers that can be intercepted by KVM.
> > This way it won't be possible for an attacker to manipulate any part of the
> > guests page table.
>
> BTW., transparent detection and trapping of attacks would also be nice:
> if ROE is active and something running on the guest still attempts to
> change the pagetables, the guest should be frozen and a syslog warning on
> the hypervisor side should be printed?

I was thinking about logging ROE violations to host's kernel logs too
and I will have it in the next
version of the patch set, but I am not sure if we should really freeze
the guest once a violation
happens, I wanted to completely isolate the mechanism from the policy.
In the current implementation,
the policy followed  is left to users pace host process using kvm. It
will be notified about a Memory IO
error in the guest, and the guest will be waiting for the host to take
actions (vmexit). Of course the
simplest action shall be "do nothing", so the writing operation will
fail but the guest continues to run, or it
can freeze the guest, or maybe do something advanced like cloning the
vm and disconnecting network
interface from the cloned vm, then enable the write operation and keep
track of what is going on somehow.
Because of the many varieties of possible reactions, we decided to
keep the them out of KVM and just let the
user space process decide how should the situation be handled.

> Also, the feature should probably be 'default y' to help spread it on the
> distro side. It's opt-in functionality from the guest side anyway, so
> there's no real cost on the host side other than some minor resident
> memory.

Noted, I will have it `default y` in the next patches set.

Thanks,
Ahmed
