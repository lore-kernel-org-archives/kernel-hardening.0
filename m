Date: Thu, 25 Apr 2019 22:38:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 16/23] vmalloc: Add flag for free of special
 permsissions
Message-ID: <20190425203845.GA12232@hirez.programming.kicks-ass.net>
References: <20190422185805.1169-1-rick.p.edgecombe@intel.com>
 <20190422185805.1169-17-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190422185805.1169-17-rick.p.edgecombe@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 22, 2019 at 11:57:58AM -0700, Rick Edgecombe wrote:
> Add a new flag VM_FLUSH_RESET_PERMS, for enabling vfree operations to
> immediately clear executable TLB entries before freeing pages, and handle
> resetting permissions on the directmap. This flag is useful for any kind
> of memory with elevated permissions, or where there can be related
> permissions changes on the directmap. Today this is RO+X and RO memory.
> 
> Although this enables directly vfreeing non-writeable memory now,
> non-writable memory cannot be freed in an interrupt because the allocation
> itself is used as a node on deferred free list. So when RO memory needs to
> be freed in an interrupt the code doing the vfree needs to have its own
> work queue, as was the case before the deferred vfree list was added to
> vmalloc.
> 
> For architectures with set_direct_map_ implementations this whole operation
> can be done with one TLB flush when centralized like this. For others with
> directmap permissions, currently only arm64, a backup method using
> set_memory functions is used to reset the directmap. When arm64 adds
> set_direct_map_ functions, this backup can be removed.
> 
> When the TLB is flushed to both remove TLB entries for the vmalloc range
> mapping and the direct map permissions, the lazy purge operation could be
> done to try to save a TLB flush later. However today vm_unmap_aliases
> could flush a TLB range that does not include the directmap. So a helper
> is added with extra parameters that can allow both the vmalloc address and
> the direct mapping to be flushed during this operation. The behavior of the
> normal vm_unmap_aliases function is unchanged.

> +static inline void set_vm_flush_reset_perms(void *addr)
> +{
> +	struct vm_struct *vm = find_vm_area(addr);
> +
> +	if (vm)
> +		vm->flags |= VM_FLUSH_RESET_PERMS;
> +}

So, previously in the series we added NX to module_alloc() and fixed up
all the usage site. And now we're going through those very same sites to
add set_vm_flush_reset_perms().

Why isn't module_alloc() calling the above function and avoid sprinkling
it all over the place again?
