Date: Fri, 4 May 2018 12:16:17 +0100
From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 2/2] arm64: Clear the stack
Message-ID: <20180504111616.znz5sphyqb6v57nx@lakrids.cambridge.arm.com>
References: <20180502203326.9491-1-labbott@redhat.com>
 <20180502203326.9491-3-labbott@redhat.com>
 <20180503071917.xm2xvgagvzkworay@salmiak>
 <a8ce3e4d-f0f3-1321-92af-9aed0097d205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8ce3e4d-f0f3-1321-92af-9aed0097d205@redhat.com>
To: Laura Abbott <labbott@redhat.com>
Cc: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 03, 2018 at 12:00:26PM -0700, Laura Abbott wrote:
> On 05/03/2018 12:19 AM, Mark Rutland wrote:
> > On Wed, May 02, 2018 at 01:33:26PM -0700, Laura Abbott wrote:

> > > +asmlinkage void erase_kstack(void)
> > > +{

> > > +
> > > +	/*
> > > +	 * So let's write the poison value to the kernel stack.
> > > +	 * Start from the address in p and move up till the new boundary.
> > > +	 */
> > > +	boundary = current_stack_pointer;
> > 
> > I worry a little that the compiler can move the SP during a function's
> > lifetime, but maybe that's only the case when there are VLAs, or something like
> > that?
> 
> I think that's true and a risk we take writing this in C. Here's
> the disassembly on gcc-7.3.1:
> 
> ffff00000809d4d8 <erase_kstack>:
> ffff00000809d4d8:       a9bf7bfd        stp     x29, x30, [sp, #-16]!
> ffff00000809d4dc:       d5384100        mrs     x0, sp_el0
> ffff00000809d4e0:       910003fd        mov     x29, sp
> ffff00000809d4e4:       f946e400        ldr     x0, [x0, #3528]
> ffff00000809d4e8:       9272c404        and     x4, x0, #0xffffffffffffc000
> ffff00000809d4ec:       eb04001f        cmp     x0, x4
> ffff00000809d4f0:       540002c9        b.ls    ffff00000809d548 <erase_kstack+0x70>  // b.plast
> ffff00000809d4f4:       d2800003        mov     x3, #0x0                        // #0
> ffff00000809d4f8:       9297ddc5        mov     x5, #0xffffffffffff4111         // #-48879
> ffff00000809d4fc:       14000008        b       ffff00000809d51c <erase_kstack+0x44>
> ffff00000809d500:       d1002000        sub     x0, x0, #0x8
> ffff00000809d504:       52800022        mov     w2, #0x1                        // #1
> ffff00000809d508:       eb00009f        cmp     x4, x0
> ffff00000809d50c:       d2800003        mov     x3, #0x0                        // #0
> ffff00000809d510:       1a9f27e1        cset    w1, cc  // cc = lo, ul, last
> ffff00000809d514:       6a01005f        tst     w2, w1
> ffff00000809d518:       54000180        b.eq    ffff00000809d548 <erase_kstack+0x70>  // b.none
> ffff00000809d51c:       f9400001        ldr     x1, [x0]
> ffff00000809d520:       eb05003f        cmp     x1, x5
> ffff00000809d524:       54fffee1        b.ne    ffff00000809d500 <erase_kstack+0x28>  // b.any
> ffff00000809d528:       91000463        add     x3, x3, #0x1
> ffff00000809d52c:       d1002000        sub     x0, x0, #0x8
> ffff00000809d530:       f100407f        cmp     x3, #0x10
> ffff00000809d534:       1a9f87e2        cset    w2, ls  // ls = plast
> ffff00000809d538:       eb00009f        cmp     x4, x0
> ffff00000809d53c:       1a9f27e1        cset    w1, cc  // cc = lo, ul, last
> ffff00000809d540:       6a01005f        tst     w2, w1
> ffff00000809d544:       54fffec1        b.ne    ffff00000809d51c <erase_kstack+0x44>  // b.any
> ffff00000809d548:       eb00009f        cmp     x4, x0
> ffff00000809d54c:       91002001        add     x1, x0, #0x8
> ffff00000809d550:       9a800020        csel    x0, x1, x0, eq  // eq = none
> ffff00000809d554:       910003e1        mov     x1, sp
> ffff00000809d558:       d5384102        mrs     x2, sp_el0
> ffff00000809d55c:       f906e840        str     x0, [x2, #3536]
> ffff00000809d560:       cb000023        sub     x3, x1, x0
> ffff00000809d564:       d287ffe2        mov     x2, #0x3fff                     // #16383
> ffff00000809d568:       eb02007f        cmp     x3, x2
> ffff00000809d56c:       540001a8        b.hi    ffff00000809d5a0 <erase_kstack+0xc8>  // b.pmore
> ffff00000809d570:       9297ddc2        mov     x2, #0xffffffffffff4111         // #-48879
> ffff00000809d574:       eb01001f        cmp     x0, x1
> ffff00000809d578:       54000082        b.cs    ffff00000809d588 <erase_kstack+0xb0>  // b.hs, b.nlast
> ffff00000809d57c:       f8008402        str     x2, [x0], #8
> ffff00000809d580:       eb00003f        cmp     x1, x0
> ffff00000809d584:       54ffffc8        b.hi    ffff00000809d57c <erase_kstack+0xa4>  // b.pmore
> ffff00000809d588:       910003e1        mov     x1, sp
> ffff00000809d58c:       d5384100        mrs     x0, sp_el0
> ffff00000809d590:       f906e401        str     x1, [x0, #3528]
> ffff00000809d594:       a8c17bfd        ldp     x29, x30, [sp], #16
> ffff00000809d598:       d65f03c0        ret
> ffff00000809d59c:       d503201f        nop
> ffff00000809d5a0:       d4210000        brk     #0x800
> ffff00000809d5a4:       00000000        .inst   0x00000000 ; undefined
> 
> It looks to be okay although admittedly that's subject to compiler
> whims. It might be safer to save the stack pointer almost as soon as
> we get into the function and use that?

I think that's still potentially a problem. If the compiler expands the
stack frame after we've taken a snaphot of the stack pointer, we might
end up erasing portions of the active stackframe.

Maybe we should just document we rely on the compiler not doing that,
and if we end up seeing it in practice we rewrite this in asm? I can't
think of a simple way we can auto-detect if this happens. :/

Thanks,
Mark.
