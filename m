Subject: Re: [PATCH v2] KVM: x86: Fix single-step debugging
References: <1548074920-10651-1-git-send-email-alex.popov@linux.com>
 <20190121142427.GA26671@kroah.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4db72046-7510-34cc-5ec4-254f7847cd80@redhat.com>
Date: Fri, 25 Jan 2019 18:38:59 +0100
MIME-Version: 1.0
In-Reply-To: <20190121142427.GA26671@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Greg KH <gregkh@linuxfoundation.org>, Alexander Popov <alex.popov@linux.com>
Cc: Radim Krcmar <rkrcmar@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Andy Lutomirski <luto@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, H Peter Anvin <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 21/01/19 15:24, Greg KH wrote:
> On Mon, Jan 21, 2019 at 03:48:40PM +0300, Alexander Popov wrote:
>> The single-step debugging of KVM guests on x86 is broken: if we run
>> gdb 'stepi' command at the breakpoint when the guest interrupts are
>> enabled, RIP always jumps to native_apic_mem_write(). Then other
>> nasty effects follow.
>>
>> Long investigation showed that on Jun 7, 2017 the
>> commit c8401dda2f0a00cd25c0 ("KVM: x86: fix singlestepping over syscall")
>> introduced the kvm_run.debug corruption: kvm_vcpu_do_singlestep() can
>> be called without X86_EFLAGS_TF set.
>>
>> Let's fix it. Please consider that for -stable.
>>
>> Signed-off-by: Alexander Popov <alex.popov@linux.com>
>> ---
>>  arch/x86/kvm/x86.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>
> 

Yup, will take care of doing this properly. :)

Paolo
