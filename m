Date: Mon, 23 Oct 2017 17:06:14 -0400 (EDT)
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1024881182.14288556.1508792774084.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAGXu5jKoLP8jN4ZtRQnFpy6RWK1JJTa7eBuA2p9huBfh11bWvg@mail.gmail.com>
References: <20171020232525.7387-1-pbonzini@redhat.com> <20171021184545.2497-1-christoffer.dall@linaro.org> <CAGXu5jKJ2jPz2540ZLCwmcdVZxrgnhVPHs0uumiJm2o0ZgpVag@mail.gmail.com> <20171022074418.GA3805@cbox> <d2a7dcec-060b-6279-1c1d-a18b3eedb394@redhat.com> <CAGXu5jKoLP8jN4ZtRQnFpy6RWK1JJTa7eBuA2p9huBfh11bWvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] R: Re: [PATCH] KVM: arm/arm64: Allow usercopy to vcpu->arch.ctxt
 and arm64 debug
To: Kees Cook <keescook@chromium.org>
Cc: Christoffer Dall <cdall@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, KVM <kvm@vger.kernel.org>, kernel-hardening@lists.openwall.com, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>


----- Kees Cook <keescook@chromium.org> ha scritto:
> On Mon, Oct 23, 2017 at 7:14 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> > On 22/10/2017 09:44, Christoffer Dall wrote:
> >> However, I think it's much clearer if I
> >> rewrite these to use get_user() and put_user().  v2 incoming.
> >
> > I'd actually prefer if you all do a trivial conversion to
> > kvm_init_usercopy to begin with.  In fact, we could just change the
> > default from "0, 0" to "0, sizeof (kvm_arch_vcpu)" in kvm_init.  Any
> > other change can be applied after the patches are merged to Linus's
> > tree, especially with KVM Forum and the merge window both coming soon.
> >
> > I'll send a v2 myself later this week.
> 
> Okay, which patches would you like me to carry in the usercopy
> whitelisting tree for the coming merge window?

v2 of mine, which shall come in the next couple of days.

Paolo


> 
> -Kees
> 
> -- 
> Kees Cook
> Pixel Security
