Date: Tue, 8 Aug 2017 10:23:48 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170808092348.GA19207@leverpostej>
References: <20170807203948.GA22298@beast>
 <20170807220056.GA29059@remoulade>
 <0e9a80c2-3e5e-db98-dff6-b45e9e4817fd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e9a80c2-3e5e-db98-dff6-b45e9e4817fd@redhat.com>
Subject: [kernel-hardening] Re: [PATCH] lkdtm: Test VMAP_STACK allocates leading/trailing guard
 pages
To: Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, luto@amacapital.net, matt@codeblueprint.co.uk, will.deacon@arm.com, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 07, 2017 at 03:55:22PM -0700, Laura Abbott wrote:
> On 08/07/2017 03:00 PM, Mark Rutland wrote:
> > On Mon, Aug 07, 2017 at 01:39:48PM -0700, Kees Cook wrote:

> >> Do these tests both trip with the new arm64 VMAP_STACK code?
> > 
> >> +/* Test that VMAP_STACK is actually allocating with a leading guard page */
> >> +void lkdtm_STACK_GUARD_PAGE_LEADING(void)

> >> +/* Test that VMAP_STACK is actually allocating with a trailing guard page */
> >> +void lkdtm_STACK_GUARD_PAGE_TRAILING(void)

> > I can give these a go tomorrow.
> > 
> > These *should* fault, and IIUC should trigger the usual "Unable to handle
> > kernel %s at virtual address %08lx\n" splat from arm64's __do_kernel_fault(),
> > which should end up with an Oops().

> I gave these a quick test in QEMU and they seem to do the correct thing:

> # echo STACK_GUARD_PAGE_LEADING > /sys/kernel/debug/provoke-crash/DIRECT 
> [   24.593306] lkdtm: Performing direct entry STACK_GUARD_PAGE_LEADING
> [   24.593780] lkdtm: attempting bad read from page below current stack
> [   24.594289] Unable to handle kernel paging request at virtual address ffff000009b77fff
> [   24.594747] swapper pgtable: 4k pages, 48-bit VAs, pgd = ffff000009050000
> [   24.595443] [ffff000009b77fff] *pgd=000000007effe003, *pud=000000007effd003, *pmd=000000007cc43003, *pte=0000000000000000
> [   24.596743] Internal error: Oops: 96000007 [#1] PREEMPT SMP

> # echo STACK_GUARD_PAGE_TRAILING > /sys/kernel/debug/provoke-crash/DIRECT 
> [  103.144313] lkdtm: Performing direct entry STACK_GUARD_PAGE_TRAILING
> [  103.144749] lkdtm: attempting bad read from page above current stack
> [  103.145100] Unable to handle kernel paging request at virtual address ffff000009c2c000
> [  103.145477] swapper pgtable: 4k pages, 48-bit VAs, pgd = ffff000009050000
> [  103.145836] [ffff000009c2c000] *pgd=000000007effe003, *pud=000000007effd003, *pmd=000000007d014003, *pte=0000000000000000
> [  103.146445] Internal error: Oops: 96000007 [#2] PREEMPT SMP

Great! thanks for giving those a spin.

I can confirm likewise on Juno with 64K pages (not that this should make
any difference).

Mark.
