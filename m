MIME-Version: 1.0
References: <1548074920-10651-1-git-send-email-alex.popov@linux.com> <2cf80ef9-cacc-c730-7a9e-301703ddc80d@redhat.com>
In-Reply-To: <2cf80ef9-cacc-c730-7a9e-301703ddc80d@redhat.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 5 Feb 2019 14:55:55 -0800
Message-ID: <CALMp9eQ06b-x26GQX1LQ=VQ9dXPvUnEjhJgSU2fYp1xbkOiZhA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: Fix single-step debugging
Content-Type: text/plain; charset="UTF-8"
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexander Popov <alex.popov@linux.com>, Radim Krcmar <rkrcmar@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Andy Lutomirski <luto@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, H Peter Anvin <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, kvm list <kvm@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 25, 2019 at 9:52 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 21/01/19 13:48, Alexander Popov wrote:
> > The single-step debugging of KVM guests on x86 is broken: if we run
> > gdb 'stepi' command at the breakpoint when the guest interrupts are
> > enabled, RIP always jumps to native_apic_mem_write(). Then other
> > nasty effects follow.
> >
> > Long investigation showed that on Jun 7, 2017 the
> > commit c8401dda2f0a00cd25c0 ("KVM: x86: fix singlestepping over syscall")
> > introduced the kvm_run.debug corruption: kvm_vcpu_do_singlestep() can
> > be called without X86_EFLAGS_TF set.
> >
> > Let's fix it. Please consider that for -stable.
> >
> > Signed-off-by: Alexander Popov <alex.popov@linux.com>
> > ---
> >  arch/x86/kvm/x86.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index f049ecf..9686068 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -6407,8 +6407,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
> >               toggle_interruptibility(vcpu, ctxt->interruptibility);
> >               vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
> >               kvm_rip_write(vcpu, ctxt->eip);
> > -             if (r == EMULATE_DONE &&
> > -                 (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
> > +             if (r == EMULATE_DONE && ctxt->tf)
> >                       kvm_vcpu_do_singlestep(vcpu, &r);
> >               if (!ctxt->have_exception ||
> >                   exception_type(ctxt->exception.vector) == EXCPT_TRAP)
> >
>
> Queued, with Cc to stable and the right "Fixes" trailer.
>
> Paolo

This patch seems to imply that userspace is expected to set the
guest's RFLAGS.TF when requesting KVM_GUEST_SINGLESTEP, but the
documentation for KVM_GUEST_SINGLESTEP is not clear about this. Can
someone clarify how KVM_GUEST_SINGLESTEP is supposed to work?
