Date: Mon, 29 Oct 2018 09:42:29 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: gRe: [PATCH V5 1/5] KVM: X86: Memory ROE documentation
Message-ID: <20181029164229.GA27144@linux.intel.com>
References: <20181026151223.16810-1-ahmedsoliman0x666@gmail.com>
 <20181026151223.16810-2-ahmedsoliman0x666@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181026151223.16810-2-ahmedsoliman0x666@gmail.com>
To: Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, ovich00@gmail.com, kernel-hardening@lists.openwall.com, nigel.edwards@hpe.com, Boris Lukashev <blukashev@sempervictus.com>, Hossam Hassan <7ossam9063@gmail.com>, Ahmed Lotfy <A7med.lotfey@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 26, 2018 at 05:12:19PM +0200, Ahmed Abd El Mawgood wrote:
> Following up with my previous threads on KVM assisted Anti rootkit
> protections.

All of the changelogs in this series need to be rewritten to adhere to
Documentation/process[1].  In particular, use imperative mood and
describe why/what is being done in a self-contained manner, e.g. the
above line isn't very helpful without a lot of prior context.

[1] https://github.com/torvalds/linux/blob/master/Documentation/process/submitting-patches.rst#2-describe-your-changes

> The current version doesn't address the attacks involving pages
> remapping. It is still design in progress, nevertheless, it will be in
> my later patch sets.

This series should be tagged RFC if its design is a WIP.
