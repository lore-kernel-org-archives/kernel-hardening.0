References: <20171020232525.7387-1-pbonzini@redhat.com>
 <20171021184545.2497-1-christoffer.dall@linaro.org>
 <CAGXu5jKJ2jPz2540ZLCwmcdVZxrgnhVPHs0uumiJm2o0ZgpVag@mail.gmail.com>
 <20171022074418.GA3805@cbox>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d2a7dcec-060b-6279-1c1d-a18b3eedb394@redhat.com>
Date: Mon, 23 Oct 2017 16:14:35 +0200
MIME-Version: 1.0
In-Reply-To: <20171022074418.GA3805@cbox>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] KVM: arm/arm64: Allow usercopy to vcpu->arch.ctxt and
 arm64 debug
To: Christoffer Dall <cdall@linaro.org>, Kees Cook <keescook@chromium.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, KVM <kvm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 22/10/2017 09:44, Christoffer Dall wrote:
> However, I think it's much clearer if I
> rewrite these to use get_user() and put_user().  v2 incoming.

I'd actually prefer if you all do a trivial conversion to
kvm_init_usercopy to begin with.  In fact, we could just change the
default from "0, 0" to "0, sizeof (kvm_arch_vcpu)" in kvm_init.  Any
other change can be applied after the patches are merged to Linus's
tree, especially with KVM Forum and the merge window both coming soon.

I'll send a v2 myself later this week.

Thanks all,

Paolo
