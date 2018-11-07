Date: Wed, 7 Nov 2018 14:55:11 +0000
From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4 2/2] arm64: mm: apply r/o permissions of VM areas to
 its linear alias as well
Message-ID: <20181107145510.GB2623@brain-police>
References: <20181107103620.16054-1-ard.biesheuvel@linaro.org>
 <20181107103620.16054-3-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181107103620.16054-3-ard.biesheuvel@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, keescook@chromium.org, labbott@redhat.com, jannh@google.com, mark.rutland@arm.com, james.morse@arm.com, catalin.marinas@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 07, 2018 at 11:36:20AM +0100, Ard Biesheuvel wrote:
> On arm64, we use block mappings and contiguous hints to map the linear
> region, to minimize the TLB footprint. However, this means that the
> entire region is mapped using read/write permissions, which we cannot
> modify at page granularity without having to take intrusive measures to
> prevent TLB conflicts.
> 
> This means the linear aliases of pages belonging to read-only mappings
> (executable or otherwise) in the vmalloc region are also mapped read/write,
> and could potentially be abused to modify things like module code, bpf JIT
> code or other read-only data.
> 
> So let's fix this, by extending the set_memory_ro/rw routines to take
> the linear alias into account. The consequence of enabling this is
> that we can no longer use block mappings or contiguous hints, so in
> cases where the TLB footprint of the linear region is a bottleneck,
> performance may be affected.
> 
> Therefore, allow this feature to be runtime en/disabled, by setting
> rodata=full (or 'on' to disable just this enhancement, or 'off' to
> disable read-only mappings for code and r/o data entirely) on the
> kernel command line. Also, allow the default value to be set via a
> Kconfig option.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/Kconfig                   | 14 ++++++++++++++
>  arch/arm64/include/asm/mmu_context.h |  2 ++
>  arch/arm64/mm/mmu.c                  | 16 ++++++++++++++--
>  arch/arm64/mm/pageattr.c             | 15 +++++++++++++++
>  4 files changed, 45 insertions(+), 2 deletions(-)

Acked-by: Will Deacon <will.deacon@arm.com>

Thanks!

Will
