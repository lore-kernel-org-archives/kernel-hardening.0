Date: Wed, 31 Jan 2018 09:07:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v6 11/13] kvm, x86: update spectre-v1 mitigation
In-Reply-To: <CAPcyv4ihnC+ALbvqUWOOZ9zwBv7iy+2pBjLn9ed_duo9Z4TGKQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1801310902180.2293@nanos>
References: <151727412964.33451.17213780323040673404.stgit@dwillia2-desk3.amr.corp.intel.com> <151727419015.33451.13762926723789552997.stgit@dwillia2-desk3.amr.corp.intel.com> <CAPcyv4ihnC+ALbvqUWOOZ9zwBv7iy+2pBjLn9ed_duo9Z4TGKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Honig <ahonig@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Alan Cox <alan@linux.intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jim Mattson <jmattson@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 30 Jan 2018, Dan Williams wrote:

> On Mon, Jan 29, 2018 at 5:03 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> > Commit 75f139aaf896 "KVM: x86: Add memory barrier on vmcs field lookup"
> > added a raw 'asm("lfence");' to prevent a bounds check bypass of
> > 'vmcs_field_to_offset_table'. We can save an lfence in this path and
> > just use the common array_index_nospec() helper designed for these types
> > of fixes.
> >
> > Cc: Andrew Honig <ahonig@google.com>
> > Cc: Jim Mattson <jmattson@google.com>
> > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> 
> Hi Thomas,
> 
> I notice this one missing from -tip, I suspect because of the
> collision with the raw 'lfence' that is in current mainline? No
> worries, I'll send a rebased fixup to Paolo directly once
> array_idx_nospec() goes upstream.

It did not apply for that reason and I'm still trying to keep x86/pti as
clean as it goes to keep GregKHs backporting hell somehow under control.

Sorry, I wanted to reply on that, but then my brain shut down after pushing
it out.

Thanks,

	tglx
