MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 27 Jan 2018 10:52:27 -0800
Message-ID: <CA+55aFxDua8mhjOSXTxMNw+XdnFuZSdAN=frh9B==YccgT36Yw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5 00/12] spectre variant1 mitigations for tip/x86/pti
To: Dan Williams <dan.j.williams@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mark Rutland <mark.rutland@arm.com>, Cyril Novikov <cnovikov@lynx.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "H. Peter Anvin" <hpa@zytor.com>, Jiri Slaby <jslaby@suse.cz>, Elena Reshetova <elena.reshetova@intel.com>, linux-arch <linux-arch@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, the arch/x86 maintainers <x86@kernel.org>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Andrew Honig <ahonig@google.com>, Alan Cox <alan@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Jim Mattson <jmattson@google.com>, Christian Lamparter <chunkeey@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Wireless List <linux-wireless@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Johannes Berg <johannes@sipsolutions.net>, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 26, 2018 at 11:55 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>
> Here's another spin of the spectre-v1 mitigations for 4.16.

I see nothing really objectionable here.

And unlike Spectre-v2 and Meltdown, I expect Spectre-v1 to be with us
for a long time. It's not a "CPU did a bad job with checking the
cached information it had" (whether it be from the TLB, BTB or RSB),
it's pretty fundamental to just regular conditional branch prediction.

So ack from me, and I don't expect this to be behind any config options.

I still haven't really seen any numbers for this, but I _assume_ it's
basically not measurable.

                 Linus
