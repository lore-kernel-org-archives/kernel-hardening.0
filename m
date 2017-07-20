Message-ID: <59706B82.1030601@arm.com>
Date: Thu, 20 Jul 2017 09:36:18 +0100
From: James Morse <james.morse@arm.com>
MIME-Version: 1.0
References: <CAKv+Gu8jey+uPSFoCsjQn9BeGiChZpS=iZ0v9nEWvkwcO1gFYg@mail.gmail.com> <20170713104950.GB26194@leverpostej> <CAKv+Gu9eSX-f4uv3gaNw9_eKV0soe2-CqSnMaTjjEhMifxe_8g@mail.gmail.com> <20170713161050.GG26194@leverpostej> <20170713175543.GA32528@leverpostej> <CAKv+Gu_v3PO7=JSgCTb3aZu3sg4cwYYjy68VJnr58vzaMYvhTw@mail.gmail.com> <20170714103258.GA16128@leverpostej> <CAKv+Gu-FvfPFQooCie6HwP=mBng3C0jp9p8WMkFwTxctDu4JBA@mail.gmail.com> <CAKv+Gu96YHXDta7=YdYO4=wtR3mGVdkzAkG6tSzS-vo7toiPXA@mail.gmail.com> <20170714140605.GB16687@leverpostej> <20170714212717.GB1086@leverpostej> <CAKv+Gu9EB1nJPwvZh1Nti8tPVivqbwrE60t2v5zZp02DyaScxA@mail.gmail.com> <39a5ad84-4124-5b33-146a-cd4e48f3762f@redhat.com> <CAKv+Gu8vPNCK0J_bgfPDyos_hDrir_rKc154wfKtF_NqJ0LywQ@mail.gmail.com> <aa086315-722b-bff3-90bb-f479229ed104@redhat.com> <CAKv+Gu_JNNVvLaSt3PTOexJV4HzPUN0mLOm6YYRS8d=UOafopQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu_JNNVvLaSt3PTOexJV4HzPUN0mLOm6YYRS8d=UOafopQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [RFC PATCH 6/6] arm64: add VMAP_STACK
 and detect out-of-bounds SP
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Takahiro Akashi <akashi.takahiro@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <dave.martin@arm.com>, Laura Abbott <labbott@fedoraproject.org>, Will Deacon <will.deacon@arm.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Ard,

On 20/07/17 06:35, Ard Biesheuvel wrote:
> On 20 July 2017 at 00:32, Laura Abbott <labbott@redhat.com> wrote:
>> I didn't notice any performance impact but I also wasn't trying that
>> hard. I did try this with a different configuration and ran into
>> stackspace errors almost immediately:
>>
>> [ 0.358026] smp: Brought up 1 node, 8 CPUs
>> [ 0.359359] SMP: Total of 8 processors activated.
>> [ 0.359542] CPU features: detected feature: 32-bit EL0 Support
>> [    0.361781] Insufficient stack space to handle exception!

[...]

>> [    0.367382] Task stack: [0xffffff8008e80000..0xffffff8008e84000]
>> [    0.367519] IRQ stack:  [0xffffffc03bf62000..0xffffffc03bf66000]
> 
> The IRQ stack is not 16K aligned ...

>> [    0.367687] ESR: 0x00000000 -- Unknown/Uncategorized
>> [    0.367868] FAR: 0x0000000000000000
>> [    0.368059] Kernel panic - not syncing: kernel stack overflow
>> [    0.368252] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 4.12.0-00018-ge9cf49d604ef-dirty #23
>> [    0.368427] Hardware name: linux,dummy-virt (DT)
>> [    0.368612] Call trace:
>> [    0.368774] [<ffffff8008087fd8>] dump_backtrace+0x0/0x228
>> [    0.368979] [<ffffff80080882c8>] show_stack+0x10/0x20
>> [    0.369270] [<ffffff80084602dc>] dump_stack+0x88/0xac
>> [    0.369459] [<ffffff800816328c>] panic+0x120/0x278
>> [    0.369582] [<ffffff8008088b40>] handle_bad_stack+0xd0/0xd8
>> [    0.369799] [<ffffff80080bfb94>] __do_softirq+0x74/0x210
>> [    0.370560] SMP: stopping secondary CPUs
>> [    0.384269] Rebooting in 5 seconds..
>>
>> The config is based on what I use for booting my Hikey android
>> board. I haven't been able to narrow down exactly which
>> set of configs set this off.
>>
> 
> ... so for some reason, the percpu atom size change fails to take effect here.

I'm not completely up to speed with these series, so this may be noise:

When we added the IRQ stack Jungseok Lee discovered that alignment greater than
PAGE_SIZE only applies to CPU0. Secondary CPUs read the per-cpu init data into a
page-aligned area, but any greater alignment requirement is lost.

Because of this the irqstack was only 16byte aligned, and struct thread_info had
to be be discovered without depending on stack alignment.


Thanks,

James
