MIME-Version: 1.0
References: <20180802132133.23999-1-ard.biesheuvel@linaro.org>
 <7529eedf-af56-2e94-261e-bc5c86abadaa@arm.com> <CAKv+Gu9X1CDpy+XvrmbSdjBjMb45eBW7JVsvsK_JQdUt2Dbvgw@mail.gmail.com>
 <b0c974a2-4e81-7855-7d4e-22834c5d8997@arm.com> <CAKv+Gu_ZzDbWwHVwOuoheXeN-ta_FjOT4Aj15=r56QZVTUK0FA@mail.gmail.com>
 <CAKv+Gu_wGk2Gdzd6WuOMZqz1tKHAWHL7pWm2Szyt0DZwPTCmOw@mail.gmail.com>
 <31443e6a-56b4-c4fb-82b1-b8eb5d7eebe1@arm.com> <CAGXu5jLj=KP038d-c+xzCx=Oogn1prH__oryQjNZZwNaAHaAAw@mail.gmail.com>
 <CAKv+Gu-9M0yO-rSXiREs11feEro0mJFcNN3Wkp_LSOGrKKd5dg@mail.gmail.com>
 <CAGXu5j+Tddmp_VgyvwTd+StEGtx=oGofeY+KpLD4OuPw+2=S2Q@mail.gmail.com>
 <CAKv+Gu-5ERHvqgXHR626QzKCZJPc0Cp5Ktv+gwucep5ZGvu9Vw@mail.gmail.com>
 <CAN+XpFQCO1nr5tQ4oyPPaSfvnQSvwx-=JCtba2xJXrEN+6=LZg@mail.gmail.com> <CAKv+Gu_jNh7vLfGEdi2BpA42rPJrNr8qV-Xss_toV2fJzUV5jQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu_jNh7vLfGEdi2BpA42rPJrNr8qV-Xss_toV2fJzUV5jQ@mail.gmail.com>
From: Mark Brand <markbrand@google.com>
Date: Wed, 8 Aug 2018 09:09:45 -0700
Message-ID: <CAN+XpFTbqMXiX=dYpK_ExvctkaJjZL9q=n06goujPht35Bieqg@mail.gmail.com>
Subject: Re: [RFC/PoC PATCH 0/3] arm64: basic ROP mitigation
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000f4b3e80572eebde5"
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Julien Thierry <julien.thierry@arm.com>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@fedoraproject.org>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

--000000000000f4b3e80572eebde5
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 7, 2018 at 2:22 AM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On 7 August 2018 at 05:05, Mark Brand <markbrand@google.com> wrote:
> > I think the phrasing of "limit kernel attack surface against ROP attacks" is
> > confusing and misleading. ROP does not describe a class of bugs,
> > vulnerabilities or attacks against the kernel - it's just one of many
> > code-reuse techniques that can be used by an attacker while exploiting a
> > vulnerability. But that's kind of off-topic!
> >
> > I think what this thread is talking about is implementing extremely
> > coarse-grained reverse-edge control-flow-integrity, in that a return can
> > only return to the address following a legitimate call, but it can return to
> > any of those.
> >
>
> Indeed. Apologies for not mastering the lingo, but it is indeed about
> no longer being able to subvert function returns into jumping to
> arbitrary places in the code.
>
> > I suspect there's not much benefit to this, since (as far as I can see) the
> > assumption is that an attacker has the means to direct flow of execution as
> > far as taking complete control of the (el1) stack before executing any ROP
> > payload.
> >
> > At that point, I think it's highly unlikely an attacker needs to chain
> > gadgets through return instructions at all - I suspect there are a few
> > places in the kernel where it is necessary to load the entire register
> > context from a register that is not the stack pointer, and it would likely
> > not be more than a minor inconvenience to an attacker to use these (and
> > chaining through branch register) instructions instead of chaining through
> > return instructions.
> >
> > I'd have to take a closer look at an arm64 kernel image to be sure though -
> > I'll do that when I get a chance and update...
> >
>
> Thanks. Reloading all registers from an arbitrary offset register
> should occur rarely, no? Could we work around that?

 I forgot about the gmail-html-by-default... Hopefully everyone else
can read the quotes though :-/.

I took a look and have put together an example rop chain that doesn't
use any return instructions that you could instrument, that will call
an arbitrary kernel function with controlled parameters (at least x0 -
x4, would have to probably mess with some alignment and add a
repetition of the last gadget to get all register control. It assumes
that the attacker has control over the memory pointed to by x0 at the
point where they get control of pc, and that they know where that
memory is located (but it would also work if they just controlled the
memory pointed to by x0, and had another chunk of kernel memory they
control at a known address. Seems like a pretty reasonable starting
assumption, and I'm sure anyone with a little motivation could produce
similar chains for other starting conditions, this just seemed the
"most likely" reasonable conditions to me.

There are two basic principles used here -

(1) chaining through the mempool_free function, I found this really
quickly when searching for useful gadgets based off x0

void mempool_free(void *element, mempool_t *pool)
{
  unsigned long flags;

  if (unlikely(element == NULL))
    return;

  /* snip */
  smp_rmb();

  /* snip */
  if (unlikely(pool->curr_nr < pool->min_nr)) {
    spin_lock_irqsave(&pool->lock, flags);
    if (likely(pool->curr_nr < pool->min_nr)) {
      add_element(pool, element);
      spin_unlock_irqrestore(&pool->lock, flags);
      wake_up(&pool->wait);
      return;
    }
    spin_unlock_irqrestore(&pool->lock, flags);
  }

  pool->free(element, pool->pool_data);
}

Since the callsites for this function usually load the arguments
through some registers, and the function to call gets pulled out of
one of those arguments, it's easy to get a couple of registers loaded
here and then the chain continue.

(2) loading complete register state using kernel_exit macro.

Since the kernel_exit macro actually loads spsr_el1 and elr_el1 from
registers, I think that you can let the eret return to anywhere in el1
without dropping to el0, since the same handler is used for "exiting
the kernel" when a hardware interrupt interrupts the kernel itself. I
didn't fill out the necessary register values in the chain below,
since I don't anyway have a device around to test this on right now.

I'm not sure that you could really robustly protect this eret; I
suppose that you could try and somehow validate the saved register
state, but given that it would be happening on every exception return,
I suspect it would be expensive.

0:dispatch_io + yy (mempool_free gadget, appears in plenty of other places.)
ffffff8008a340d4  084c41a9   ldp     x8, x19, [x0, #0x10]
ffffff8008a340d8  190040f9   ldr     x25, [x0]
ffffff8008a340dc  1a1040f9   ldr     x26, [x0, #0x20]
ffffff8008a340e0  010140f9   ldr     x1, [x8]
ffffff8008a340e4  ed80dd97   bl      mempool_free

  mempool_free:
  ffffff8008194498  f44fbea9   stp     x20, x19, [sp, #-0x20
{__saved_x20} {__saved_x19}]!
  ffffff800819449c  fd7b01a9   stp     x29, x30, [sp, #0x10
{__saved_x29} {__saved_x30}]
  ffffff80081944a0  fd430091   add     x29, sp, #0x10 {__saved_x29}
  ffffff80081944a4  f30301aa   mov     x19, x1
  ffffff80081944a8  f40300aa   mov     x20, x0
  ffffff80081944ac  340100b4   cbz     x20, 0xffffff80081944d0

  ffffff80081944b0  bf3903d5   dmb     ishld
  ffffff80081944b4  68a64029   ldp     w8, w9, [x19, #0x4]
  ffffff80081944b8  3f01086b   cmp     w9, w8
  ffffff80081944bc  0b010054   b.lt    0xffffff80081944dc

  ffffff80081944c0  681640f9   ldr     x8, [x19, #0x28]
  ffffff80081944c4  610e40f9   ldr     x1, [x19, #0x18]
  ffffff80081944c8  e00314aa   mov     x0, x20
  ffffff80081944cc  00013fd6   blr     x8

  ffffff80081944d0  fd7b41a9   ldp     x29, x30, [sp, #0x10
{__saved_x29} {__saved_x30}]
  ffffff80081944d4  f44fc2a8   ldp     x20, x19, [sp {__saved_x20}
{__saved_x19}], #0x20
  ffffff80081944d8  c0035fd6   ret

ffffff8008a340e8  e00319aa   mov     x0, x25
ffffff8008a340ec  e1031aaa   mov     x1, x26
ffffff8008a340f0  60023fd6   blr     x19

1:el1_irq + xx - (x1, x26) -> sp control
ffffff800808314c  5f030091   mov     sp, x26
ffffff8008083150  fd4fbfa9   stp     x29, x19, [sp, #-0x10]! {__saved_x0}
ffffff8008083154  fd030091   mov     x29, sp
ffffff8008083158  20003fd6   blr     x1

2:ipc_log_extract + xx (sp, x19) -> survival
ffffff800817c35c  e0c30091   add     x0, sp, #0x30 {var_170}
ffffff800817c360  e1430091   add     x1, sp, #0x10 {var_190}
ffffff800817c364  60023fd6   blr     x19

3:dispatch_io + xx (mempool_free gadget, appears in plenty of other places.)
ffffff8008a342cc  084c41a9   ldp     x8, x19, [x0, #0x10]
ffffff8008a342d0  140040f9   ldr     x20, [x0]
ffffff8008a342d4  151040f9   ldr     x21, [x0, #0x20]
ffffff8008a342d8  010140f9   ldr     x1, [x8]
ffffff8008a342dc  6f80dd97   bl      mempool_free

  mempool_free:
  ffffff8008194498  f44fbea9   stp     x20, x19, [sp, #-0x20
{__saved_x20} {__saved_x19}]!
  ffffff800819449c  fd7b01a9   stp     x29, x30, [sp, #0x10
{__saved_x29} {__saved_x30}]
  ffffff80081944a0  fd430091   add     x29, sp, #0x10 {__saved_x29}
  ffffff80081944a4  f30301aa   mov     x19, x1
  ffffff80081944a8  f40300aa   mov     x20, x0
  ffffff80081944ac  340100b4   cbz     x20, 0xffffff80081944d0

  ffffff80081944b0  bf3903d5   dmb     ishld
  ffffff80081944b4  68a64029   ldp     w8, w9, [x19, #0x4]
  ffffff80081944b8  3f01086b   cmp     w9, w8
  ffffff80081944bc  0b010054   b.lt    0xffffff80081944dc

  ffffff80081944c0  681640f9   ldr     x8, [x19, #0x28]
  ffffff80081944c4  610e40f9   ldr     x1, [x19, #0x18]
  ffffff80081944c8  e00314aa   mov     x0, x20
  ffffff80081944cc  00013fd6   blr     x8

  ffffff80081944d0  fd7b41a9   ldp     x29, x30, [sp, #0x10
{__saved_x29} {__saved_x30}]
  ffffff80081944d4  f44fc2a8   ldp     x20, x19, [sp {__saved_x20}
{__saved_x19}], #0x20
  ffffff80081944d8  c0035fd6   ret

ffffff8008a342e0  e00314aa   mov     x0, x20
ffffff8008a342e4  e10315aa   mov     x1, x21
ffffff8008a342e8  60023fd6   blr     x19

4:bus_sort_breadthfirst + xx - (x26)
ffffff8008683cc8  561740f9   ldr     x22, [x26, #0x28]
ffffff8008683ccc  e00315aa   mov     x0, x21
ffffff8008683cd0  e10316aa   mov     x1, x22
ffffff8008683cd4  80023fd6   blr     x20

5:kernel_exit (macro) - (x21, x22, sp) -> full register control & pc control
ffffff8008082f64  354018d5   msr     elr_el1, x21
ffffff8008082f68  164018d5   msr     spsr_el1, x22
ffffff8008082f6c  e00740a9   ldp     x0, x1, [sp {var_130} {var_128}]
ffffff8008082f70  e20f41a9   ldp     x2, x3, [sp, #0x10 {var_120} {var_118}]
ffffff8008082f74  e41742a9   ldp     x4, x5, [sp, #0x20 {var_110} {var_108}]
ffffff8008082f78  e61f43a9   ldp     x6, x7, [sp, #0x30 {var_100} {var_f8}]
ffffff8008082f7c  e82744a9   ldp     x8, x9, [sp, #0x40 {var_f0} {var_e8}]
ffffff8008082f80  ea2f45a9   ldp     x10, x11, [sp, #0x50 {var_e0} {var_d8}]
ffffff8008082f84  ec3746a9   ldp     x12, x13, [sp, #0x60 {var_d0} {var_c8}]
ffffff8008082f88  ee3f47a9   ldp     x14, x15, [sp, #0x70 {var_c0} {var_b8}]
ffffff8008082f8c  f04748a9   ldp     x16, x17, [sp, #0x80 {var_b0} {var_a8}]
ffffff8008082f90  f24f49a9   ldp     x18, x19, [sp, #0x90 {var_a0} {var_98}]
ffffff8008082f94  f4574aa9   ldp     x20, x21, [sp, #0xa0 {var_90} {var_88}]
ffffff8008082f98  f65f4ba9   ldp     x22, x23, [sp, #0xb0 {var_80} {var_78}]
ffffff8008082f9c  f8674ca9   ldp     x24, x25, [sp, #0xc0 {var_70} {var_68}]
ffffff8008082fa0  fa6f4da9   ldp     x26, x27, [sp, #0xd0 {var_60} {var_58}]
ffffff8008082fa4  fc774ea9   ldp     x28, x29, [sp, #0xe0 {var_50} {var_48}]
ffffff8008082fa8  fe7b40f9   ldr     x30, [sp, #0xf0 {var_40}]
ffffff8008082fac  ffc30491   add     sp, sp, #0x130
ffffff8008082fb0  e0039fd6   eret


ptr = 0000414100000000 = initial x0

0000: 2525252525252525 ; (0:40d8) x25
0008: 0000414100000030 ; (0:40e0) x1
0010: 0000414100000000 ; (0:40d4) x8
0018: ffffff8008a342cc ; (0:40d4) x19 -> branch target (2:c364)
0020: 0000414100000070 ; (0:40dc) x26 -> sp (1:314c)
0028:
0030: 8888888899999999 ; (0:44b4) w8, w9
0038:
0040:
0048: ffffff800817c35c ; (0:44c4) x1 -> branch target (1:3158)
0050:
0058: ffffff800808314c ; (0:44c0) x8 -> branch target (0:44c4)
0060: xxxxxxxxxxxxxxxx ; saved x29                               <-- sp@(1:3154)
0068: xxxxxxxxxxxxxxxx ; saved x19
0070:                  ;                                         <--
sp@(1:314c), (5:2f64)
0078:
0080:
0088:
0090:
0098: 2222222222222222 ; (4:3cc8) x22 -> spsr_el1
00a0: ffffff8008082f64 ; (3:42d0) x20 -> branch target (4:3cd4)  <-- x0@(2:c35c)
00a8: 00004141000000d0 ; (3:42d8) x1
00b0: 00004141000000a0 ; (3:42cc) x8
00b8: 1919191919191919 ; (3:42cc) x19
00c0: 2121212121212121 ; (3:42d4) x21 -> elr_el1
00c8:
00d0: 8888888899999999 ; (3:44b4) w8, w9
00d8:
00e0:
00e8: 1111111111111111 ; (3:44c4) x1
00f0:
00f8: ffffff800808314c ; (3:44c0) x8 -> branch target (3:44c4)
>
> > On Mon, 6 Aug 2018 at 19:28, Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > wrote:
> >>
> >> On 6 August 2018 at 21:50, Kees Cook <keescook@chromium.org> wrote:
> >> > On Mon, Aug 6, 2018 at 12:35 PM, Ard Biesheuvel
> >> > <ard.biesheuvel@linaro.org> wrote:
> >> >> On 6 August 2018 at 20:49, Kees Cook <keescook@chromium.org> wrote:
> >> >>> On Mon, Aug 6, 2018 at 10:45 AM, Robin Murphy <robin.murphy@arm.com>
> >> >>> wrote:
> >> >>>> I guess what I'm getting at is that if the protection mechanism is
> >> >>>> "always
> >> >>>> return with SP outside TTBR1", there seems little point in going
> >> >>>> through the
> >> >>>> motions if SP in TTBR0 could still be valid and allow an attack to
> >> >>>> succeed
> >> >>>> anyway; this is basically just me working through a justification for
> >> >>>> saying
> >> >>>> the proposed scheme needs "depends on ARM64_PAN ||
> >> >>>> ARM64_SW_TTBR0_PAN",
> >> >>>> making it that much uglier for v8.0 CPUs...
> >> >>>
> >> >>> I think anyone with v8.0 CPUs interested in this mitigation would also
> >> >>> very much want PAN emulation. If a "depends on" isn't desired, what
> >> >>> about "imply" in the Kconfig?
> >> >>>
> >> >>
> >> >> Yes, but actually, using bit #0 is maybe a better alternative in any
> >> >> case. You can never dereference SP with bit #0 set, regardless of
> >> >> whether the address points to user or kernel space, and my concern
> >> >> about reloading sp from x29 doesn't really make sense, given that x29
> >> >> is always assigned from sp right after pushing x29 and x30 in the
> >> >> function prologue, and sp only gets restored from x29 in the epilogue
> >> >> when there is a stack frame to begin with, in which case we add #1 to
> >> >> sp again before returning from the function.
> >> >
> >> > Fair enough! :)
> >> >
> >> >> The other code gets a lot cleaner as well.
> >> >>
> >> >> So for the return we'll have
> >> >>
> >> >>   ldp     x29, x30, [sp], #nn
> >> >>>>add     sp, sp, #0x1
> >> >>   ret
> >> >>
> >> >> and for the function call
> >> >>
> >> >>   bl      <foo>
> >> >>>>mov      x30, sp
> >> >>>>bic     sp, x30, #1
> >> >>
> >> >> The restore sequence in entry.s:96 (which has no spare registers) gets
> >> >> much simpler as well:
> >> >>
> >> >> --- a/arch/arm64/kernel/entry.S
> >> >> +++ b/arch/arm64/kernel/entry.S
> >> >> @@ -95,6 +95,15 @@ alternative_else_nop_endif
> >> >>          */
> >> >>         add     sp, sp, x0      // sp' = sp + x0
> >> >>         sub     x0, sp, x0      // x0' = sp' - x0 = (sp + x0) - x0 = sp
> >> >> +#ifdef CONFIG_ARM64_ROP_SHIELD
> >> >> +       tbnz    x0, #0, 1f
> >> >> +       .subsection     1
> >> >> +1:     sub     x0, x0, #1
> >> >> +       sub     sp, sp, #1
> >> >> +       b       2f
> >> >> +       .previous
> >> >> +2:
> >> >> +#endif
> >> >>         tbnz    x0, #THREAD_SHIFT, 0f
> >> >>         sub     x0, sp, x0      // x0'' = sp' - x0' = (sp + x0) - sp =
> >> >> x0
> >> >>         sub     sp, sp, x0      // sp'' = sp' - x0 = (sp + x0) - x0 =
> >> >> sp
> >> >
> >> > I get slightly concerned about "add" vs "clear bit", but I don't see a
> >> > real way to chain a lot of "add"s to get to avoid the unaligned
> >> > access. Is "or" less efficient than "add"?
> >> >
> >>
> >> Yes. The stack pointer is special on arm64, and can only be used with
> >> a limited set of ALU instructions. So orring #1 would involve 'mov
> >> <reg>, sp ; orr sp, <reg>, #1' like in the 'bic' case above, which
> >> requires a scratch register as well.

--000000000000f4b3e80572eebde5
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIS7QYJKoZIhvcNAQcCoIIS3jCCEtoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ghBTMIIEXDCCA0SgAwIBAgIOSBtqDm4P/739RPqw/wcwDQYJKoZIhvcNAQELBQAwZDELMAkGA1UE
BhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExOjA4BgNVBAMTMUdsb2JhbFNpZ24gUGVy
c29uYWxTaWduIFBhcnRuZXJzIENBIC0gU0hBMjU2IC0gRzIwHhcNMTYwNjE1MDAwMDAwWhcNMjEw
NjE1MDAwMDAwWjBMMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEiMCAG
A1UEAxMZR2xvYmFsU2lnbiBIViBTL01JTUUgQ0EgMTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBALR23lKtjlZW/17kthzYcMHHKFgywfc4vLIjfq42NmMWbXkNUabIgS8KX4PnIFsTlD6F
GO2fqnsTygvYPFBSMX4OCFtJXoikP2CQlEvO7WooyE94tqmqD+w0YtyP2IB5j4KvOIeNv1Gbnnes
BIUWLFxs1ERvYDhmk+OrvW7Vd8ZfpRJj71Rb+QQsUpkyTySaqALXnyztTDp1L5d1bABJN/bJbEU3
Hf5FLrANmognIu+Npty6GrA6p3yKELzTsilOFmYNWg7L838NS2JbFOndl+ce89gM36CW7vyhszi6
6LqqzJL8MsmkP53GGhf11YMP9EkmawYouMDP/PwQYhIiUO0CAwEAAaOCASIwggEeMA4GA1UdDwEB
/wQEAwIBBjAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwEgYDVR0TAQH/BAgwBgEB/wIB
ADAdBgNVHQ4EFgQUyzgSsMeZwHiSjLMhleb0JmLA4D8wHwYDVR0jBBgwFoAUJiSSix/TRK+xsBtt
r+500ox4AAMwSwYDVR0fBEQwQjBAoD6gPIY6aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9ncy9n
c3BlcnNvbmFsc2lnbnB0bnJzc2hhMmcyLmNybDBMBgNVHSAERTBDMEEGCSsGAQQBoDIBKDA0MDIG
CCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzANBgkqhkiG
9w0BAQsFAAOCAQEACskdySGYIOi63wgeTmljjA5BHHN9uLuAMHotXgbYeGVrz7+DkFNgWRQ/dNse
Qa4e+FeHWq2fu73SamhAQyLigNKZF7ZzHPUkSpSTjQqVzbyDaFHtRBAwuACuymaOWOWPePZXOH9x
t4HPwRQuur57RKiEm1F6/YJVQ5UTkzAyPoeND/y1GzXS4kjhVuoOQX3GfXDZdwoN8jMYBZTO0H5h
isymlIl6aot0E5KIKqosW6mhupdkS1ZZPp4WXR4frybSkLejjmkTYCTUmh9DuvKEQ1Ge7siwsWgA
NS1Ln+uvIuObpbNaeAyMZY0U5R/OyIDaq+m9KXPYvrCZ0TCLbcKuRzCCBB4wggMGoAMCAQICCwQA
AAAAATGJxkCyMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9vdCBDQSAt
IFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTExMDgwMjEw
MDAwMFoXDTI5MDMyOTEwMDAwMFowZDELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24g
bnYtc2ExOjA4BgNVBAMTMUdsb2JhbFNpZ24gUGVyc29uYWxTaWduIFBhcnRuZXJzIENBIC0gU0hB
MjU2IC0gRzIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCg/hRKosYAGP+P7mIdq5NB
Kr3J0tg+8lPATlgp+F6W9CeIvnXRGUvdniO+BQnKxnX6RsC3AnE0hUUKRaM9/RDDWldYw35K+sge
C8fWXvIbcYLXxWkXz+Hbxh0GXG61Evqux6i2sKeKvMr4s9BaN09cqJ/wF6KuP9jSyWcyY+IgL6u2
52my5UzYhnbf7D7IcC372bfhwM92n6r5hJx3r++rQEMHXlp/G9J3fftgsD1bzS7J/uHMFpr4MXua
eoiMLV5gdmo0sQg23j4pihyFlAkkHHn4usPJ3EePw7ewQT6BUTFyvmEB+KDoi7T4RCAZDstgfpzD
rR/TNwrK8/FXoqnFAgMBAAGjgegwgeUwDgYDVR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYBAf8C
AQEwHQYDVR0OBBYEFCYkkosf00SvsbAbba/udNKMeAADMEcGA1UdIARAMD4wPAYEVR0gADA0MDIG
CCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzA2BgNVHR8E
LzAtMCugKaAnhiVodHRwOi8vY3JsLmdsb2JhbHNpZ24ubmV0L3Jvb3QtcjMuY3JsMB8GA1UdIwQY
MBaAFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQACAFVjHihZCV/IqJYt
7Nig/xek+9g0dmv1oQNGYI1WWeqHcMAV1h7cheKNr4EOANNvJWtAkoQz+076Sqnq0Puxwymj0/+e
oQJ8GRODG9pxlSn3kysh7f+kotX7pYX5moUa0xq3TCjjYsF3G17E27qvn8SJwDsgEImnhXVT5vb7
qBYKadFizPzKPmwsJQDPKX58XmPxMcZ1tG77xCQEXrtABhYC3NBhu8+c5UoinLpBQC1iBnNpNwXT
Lmd4nQdf9HCijG1e8myt78VP+QSwsaDT7LVcLT2oDPVggjhVcwljw3ePDwfGP9kNrR+lc8XrfClk
WbrdhC2o4Ui28dtIVHd3MIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAw
TDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24x
EzARBgNVBAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAw
HgYDVQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEG
A1UEAxMKR2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5Bngi
FvXAg7aEyiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X
17YUhhB5uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmm
KPZpO/bLyCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hp
sk+QLjJg6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7
DWzgVGkWqQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQF
MAMBAf8wHQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBL
QNvAUKr+yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25s
bwMpjjM5RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV
3XpYKBovHd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyr
VQ4PkX4268NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E
7gUJTb0o2HLO02JQZR7rkpeDMdmztcpHWD9fMIIEajCCA1KgAwIBAgIMI4UvjeJfrNd3XgIDMA0G
CSqGSIb3DQEBCwUAMEwxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSIw
IAYDVQQDExlHbG9iYWxTaWduIEhWIFMvTUlNRSBDQSAxMB4XDTE4MDcxNTE4NDI0OVoXDTE5MDEx
MTE4NDI0OVowJTEjMCEGCSqGSIb3DQEJAQwUbWFya2JyYW5kQGdvb2dsZS5jb20wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQClcLKV2UreP9B6rZ8hyTf8VA4g0Uvvo/g/qPg3cVW5m/yN
wwzjfF5UGKKcpHCzbQZmC3Q4BcD8TpRwbdLGNXW41tzwEhXBuqBZRa8EV+1jt68hGZNgqODTu0IZ
UKquBrJhCyFx+GeQJn3wVjHXLDQyJiVVQVxdUwwnak64xdlF7TAPD/19EO15luwF8h+OuOR3vuun
rdn7tHPKoYS3OKZh1LguDGhBKMSf9v/YzFkm7WIL0+xktmlgfCGaEoCtK9KCvSgzt3tNTruVjW49
xEUfvQFIQchuLxTKpKcLeljBimvi4wmTExXnmaQ2j4OEK/LxvqDTbiWmgx226pkArtrPAgMBAAGj
ggFxMIIBbTAfBgNVHREEGDAWgRRtYXJrYnJhbmRAZ29vZ2xlLmNvbTBQBggrBgEFBQcBAQREMEIw
QAYIKwYBBQUHMAKGNGh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzaHZzbWlt
ZWNhMS5jcnQwHQYDVR0OBBYEFHBSBDmApw3Xi49XlWZD2iFby5ooMB8GA1UdIwQYMBaAFMs4ErDH
mcB4koyzIZXm9CZiwOA/MEwGA1UdIARFMEMwQQYJKwYBBAGgMgEoMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMDsGA1UdHwQ0MDIwMKAuoCyGKmh0
dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NodnNtaW1lY2ExLmNybDAOBgNVHQ8BAf8EBAMCBaAw
HQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMA0GCSqGSIb3DQEBCwUAA4IBAQCEWxDOz17X
hCYX+4CFh1LQ/77xHmLszAWtuLH4ALDk5P4Wf8vqCwwrlSx0LieV7aGCVklDAwhIa0MeWIa5Wsz+
laequtNQBc2UmnR6okDSnbUBC9MFU11ZQHp66esFXr3svRJUfCVDJ3GR5V3xRAjoJm60hnYK/ypz
rxH6JYeCbsbIxFrly2wF6vYsVXN3+fk351T4z40wrZnbaptm4RI2WsXSDfW7Gq28MyYHyXYra5Yu
kG0zqLbYqxHpnunzHMl/ucHXEr86qs7kyUVoFh3CMnDy497xbm59ihRV429OGCFYW3Qz5NY6SxIA
AT6/iI5s2Jr/GEwMCSFPJyDOeNiEMYICXjCCAloCAQEwXDBMMQswCQYDVQQGEwJCRTEZMBcGA1UE
ChMQR2xvYmFsU2lnbiBudi1zYTEiMCAGA1UEAxMZR2xvYmFsU2lnbiBIViBTL01JTUUgQ0EgMQIM
I4UvjeJfrNd3XgIDMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCAwLJOFmEfFwd0Z
lGKzaIsYkc/8wVBhemF5Hrt4tW7/TjAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3
DQEJBTEPFw0xODA4MDgxNjA5NThaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCG
SAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEB
BzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAAG0Urjemp4HA6C53K88WvIc/0bPoT6PM
+gYf2HFCkXs6NJPMjpnmjzdUnLS8gVomE2GpBtK6mkMRTqKi7yK/Zk4gErLV6WKDUoWKHEHYfBmD
BuAKOn4Yf49XoCu6Od8e/Qc7mDUfwoj5072HlVjZOW6wmQ0oEZVBDOJCXmFNB/3e3MO/iK2lVWdj
lZhhrO3lPOABY3R8rjII3e8VaqZ5T4WrsgWc7QGC4VV4fYsmd0g6/1C12IGYIT8w9B8s3gsYmuoE
M6Y5UntyPrVgjWJd5w3Ky4uwrEJM5/YcuTIKc3HMyihzwiU3HuyBEdlx0cUUuTiagx4Qs0bMbOuF
uIC2+Q==
--000000000000f4b3e80572eebde5--
