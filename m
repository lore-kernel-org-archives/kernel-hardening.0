Subject: Re: [PATCH v2] KVM: x86: Fix single-step debugging
References: <1548074920-10651-1-git-send-email-alex.popov@linux.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <845b834f-3529-056d-4373-312f7c6fc794@linux.com>
Date: Thu, 24 Jan 2019 11:41:22 +0300
MIME-Version: 1.0
In-Reply-To: <1548074920-10651-1-git-send-email-alex.popov@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Paolo Bonzini <pbonzini@redhat.com>, Radim Krcmar <rkrcmar@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Andy Lutomirski <luto@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, H Peter Anvin <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 21.01.2019 15:48, Alexander Popov wrote:
> The single-step debugging of KVM guests on x86 is broken: if we run
> gdb 'stepi' command at the breakpoint when the guest interrupts are
> enabled, RIP always jumps to native_apic_mem_write(). Then other
> nasty effects follow.
> 
> Long investigation showed that on Jun 7, 2017 the
> commit c8401dda2f0a00cd25c0 ("KVM: x86: fix singlestepping over syscall")
> introduced the kvm_run.debug corruption: kvm_vcpu_do_singlestep() can
> be called without X86_EFLAGS_TF set.
> 
> Let's fix it. Please consider that for -stable.

Hello everyone!

Just a friendly ping about this fix.
Looking forward to the feedback.

Best regards,
Alexander
