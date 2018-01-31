Subject: Re: [PATCH v6 11/13] kvm, x86: update spectre-v1 mitigation
References: <151727412964.33451.17213780323040673404.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151727419015.33451.13762926723789552997.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4ihnC+ALbvqUWOOZ9zwBv7iy+2pBjLn9ed_duo9Z4TGKQ@mail.gmail.com>
 <alpine.DEB.2.20.1801310902180.2293@nanos>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <376a8a99-db4f-09ec-7c1b-a35ced6209c5@redhat.com>
Date: Wed, 31 Jan 2018 08:49:16 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1801310902180.2293@nanos>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Thomas Gleixner <tglx@linutronix.de>, Dan Williams <dan.j.williams@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Honig <ahonig@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, Alan Cox <alan@linux.intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jim Mattson <jmattson@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 31/01/2018 03:07, Thomas Gleixner wrote:
>> Hi Thomas,
>>
>> I notice this one missing from -tip, I suspect because of the
>> collision with the raw 'lfence' that is in current mainline? No
>> worries, I'll send a rebased fixup to Paolo directly once
>> array_idx_nospec() goes upstream.

Fine by me.  Also, now that x86/pti has been rebased, a version that
replaces the lfence with array_idx_nospec() would apply to both tip and
4.14.

Paolo

> It did not apply for that reason and I'm still trying to keep x86/pti as
> clean as it goes to keep GregKHs backporting hell somehow under control.
