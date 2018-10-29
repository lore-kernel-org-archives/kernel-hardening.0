Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Mon, 29 Oct 2018 07:46:40 +0100
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V5 0/5] KVM: X86: Introducing ROE Protection Kernel
 Hardening
Message-ID: <20181029064640.GE128403@gmail.com>
References: <20181026151223.16810-1-ahmedsoliman0x666@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181026151223.16810-1-ahmedsoliman0x666@gmail.com>
To: Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, ovich00@gmail.com, kernel-hardening@lists.openwall.com, nigel.edwards@hpe.com, Boris Lukashev <blukashev@sempervictus.com>, Hossam Hassan <7ossam9063@gmail.com>, Ahmed Lotfy <A7med.lotfey@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com> wrote:

> This is the 5th version which is 4th version with minor fixes. ROE is a 
> hypercall that enables host operating system to restrict guest's access to its
> own memory. This will provide a hardening mechanism that can be used to stop
> rootkits from manipulating kernel static data structures and code. Once a memory
> region is protected the guest kernel can't even request undoing the protection.
> 
> Memory protected by ROE should be non-swapable because even if the ROE protected
> page got swapped out, It won't be possible to write anything in its place.
> 
> ROE hypercall should be capable of either protecting a whole memory frame or
> parts of it. With these two, it should be possible for guest kernel to protect
> its memory and all the page table entries for that memory inside the page table.
> I am still not sure whether this should be part of ROE job or the guest's job.
> 
> 
> The reason why it would be better to implement this from inside kvm: instead of
> (host) user space is the need to access SPTEs to modify the permissions, while
> mprotect() from user space can work in theory. It will become a big performance
> hit to vmexit and switch to user space mode on each fault, on the other hand,
> having the permission handled by EPT should make some remarkable performance
> gain.
> 
> Our model assumes that an attacker got full root access to a running guest and
> his goal is to manipulate kernel code/data (hook syscalls, overwrite IDT ..etc).
> 
> There is future work in progress to also put some sort of protection on the page
> table register CR3 and other critical registers that can be intercepted by KVM.
> This way it won't be possible for an attacker to manipulate any part of the
> guests page table.

BTW., transparent detection and trapping of attacks would also be nice: 
if ROE is active and something running on the guest still attempts to 
change the pagetables, the guest should be frozen and a syslog warning on 
the hypervisor side should be printed?

Also, the feature should probably be 'default y' to help spread it on the 
distro side. It's opt-in functionality from the guest side anyway, so 
there's no real cost on the host side other than some minor resident 
memory.

Thanks,

	Ingo
