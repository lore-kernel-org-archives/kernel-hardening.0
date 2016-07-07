Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1466556426-32664-1-git-send-email-keescook@chromium.org>
References: <1466556426-32664-1-git-send-email-keescook@chromium.org>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 7 Jul 2016 18:24:36 -0400
Message-ID: <CAGXu5jLkq-mRMZ_NtXf6M_4YPrMWVEV3U-iF1qt49LRXPTrxEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v7 0/9] x86/mm: memory area address KASLR
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Garnier <thgarnie@google.com>, Andy Lutomirski <luto@kernel.org>, "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Juergen Gross <jgross@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Dave Young <dyoung@redhat.com>, Joerg Roedel <jroedel@suse.de>, Lv Zheng <lv.zheng@intel.com>, Mark Salter <msalter@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, Stephen Smalley <sds@tycho.nsa.gov>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Jan Beulich <JBeulich@suse.com>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 21, 2016 at 8:46 PM, Kees Cook <keescook@chromium.org> wrote:
> This is v7 of Thomas Garnier's KASLR for memory areas (physical memory
> mapping, vmalloc, vmemmap). It expects to be applied on top of the
> x86/boot tip.
>
> The current implementation of KASLR randomizes only the base address of
> the kernel and its modules. Research was published showing that static
> memory addresses can be found and used in exploits, effectively ignoring
> base address KASLR:
>
>    The physical memory mapping holds most allocations from boot and
>    heap allocators. Knowning the base address and physical memory
>    size, an attacker can deduce the PDE virtual address for the vDSO
>    memory page.  This attack was demonstrated at CanSecWest 2016, in
>    the "Getting Physical: Extreme Abuse of Intel Based Paged Systems"
>    https://goo.gl/ANpWdV (see second part of the presentation). The
>    exploits used against Linux worked successfuly against 4.6+ but fail
>    with KASLR memory enabled (https://goo.gl/iTtXMJ). Similar research
>    was done at Google leading to this patch proposal. Variants exists
>    to overwrite /proc or /sys objects ACLs leading to elevation of
>    privileges.  These variants were tested against 4.6+.
>
> This set of patches randomizes the base address and padding of three
> major memory sections (physical memory mapping, vmalloc, and vmemmap).
> It mitigates exploits relying on predictable kernel addresses in these
> areas. This feature can be enabled with the CONFIG_RANDOMIZE_MEMORY
> option. (This CONFIG, along with CONFIG_RANDOMIZE may be renamed in
> the future, but stands for now as other architectures continue to
> implement KASLR.)
>
> Padding for the memory hotplug support is managed by
> CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING. The default value is 10
> terabytes.
>
> The patches were tested on qemu & physical machines. Xen compatibility was
> also verified. Multiple reboots were used to verify entropy for each
> memory section.
>
> Notable problems that needed solving:
>  - The three target memory sections need to not be at the same place
>    across reboots.
>  - The physical memory mapping can use a virtual address not aligned on
>    the PGD page table.
>  - Reasonable entropy is needed early at boot before get_random_bytes()
>    is available.
>  - Memory hotplug needs KASLR padding.
>
> Patches:
>  - 1: refactor KASLR functions (moves them from boot/compressed/ into lib/)
>  - 2: clarifies the variables used for physical mapping.
>  - 3: PUD virtual address support for physical mapping.
>  - 4: split out the trampoline PGD
>  - 5: KASLR memory infrastructure code
>  - 6: randomize base of physical mapping region
>  - 7: randomize base of vmalloc region
>  - 8: randomize base of vmemmap region
>  - 9: provide memory hotplug padding support
>
> There is no measurable performance impact:
>
>  - Kernbench shows almost no difference (-+ less than 1%).
>  - Hackbench shows 0% difference on average (hackbench 90 repeated 10 times).

Hi again,

Just a friendly ping -- I'd love to get this into -tip for wider testing.

Thanks!

-Kees


-- 
Kees Cook
Chrome OS & Brillo Security
