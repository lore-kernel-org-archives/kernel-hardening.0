Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
References: <20190612170834.14855-1-mhillenb@amazon.de>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
Date: Wed, 12 Jun 2019 12:55:38 -0700
MIME-Version: 1.0
In-Reply-To: <20190612170834.14855-1-mhillenb@amazon.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Marius Hillenbrand <mhillenb@amazon.de>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>, the arch/x86 maintainers <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 6/12/19 10:08 AM, Marius Hillenbrand wrote:
> This patch series proposes to introduce a region for what we call
> process-local memory into the kernel's virtual address space. 

It might be fun to cc some x86 folks on this series.  They might have
some relevant opinions. ;)

A few high-level questions:

Why go to all this trouble to hide guest state like registers if all the
guest data itself is still mapped?

Where's the context-switching code?  Did I just miss it?

We've discussed having per-cpu page tables where a given PGD is only in
use from one CPU at a time.  I *think* this scheme still works in such a
case, it just adds one more PGD entry that would have to context-switched.
