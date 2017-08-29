MIME-Version: 1.0
In-Reply-To: <CAJcbSZFJQMKw21kLwr4QGoSM7DMgKRzzjWxkYBF2c1HciCzvGg@mail.gmail.com>
References: <20170810172615.51965-1-thgarnie@google.com> <20170811124127.kkb5pnkljz4umxuj@gmail.com>
 <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
 <20170815075609.mmzbfwritjzvrpsn@gmail.com> <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170816151235.oamkdva6cwpc4cex@gmail.com> <CAJcbSZFM_zpL1av1JVaow8NdsGeH+6oZKeDnMPdXR0PGfynzsg@mail.gmail.com>
 <20170817080920.5ljlkktngw2cisfg@gmail.com> <CAJcbSZGbtc-i0X1NiBAvZA7cxpGkwSLKNB7oDNCsFxOCdhkR_g@mail.gmail.com>
 <CAJcbSZGhvwt=5ERtBHLJnwS=6AXBZLTMfrafzeUCqYy=-MKWDg@mail.gmail.com>
 <20170825080443.tvvr6wzs362cjcuu@gmail.com> <CAJcbSZFJQMKw21kLwr4QGoSM7DMgKRzzjWxkYBF2c1HciCzvGg@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 29 Aug 2017 12:34:04 -0700
Message-ID: <CAJcbSZH6hwaWKrvUZR33ExYaZaWKMSv4tJJA3yZkniLvLbTFMw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: x86: PIE support and option to extend KASLR randomization
To: Ingo Molnar <mingo@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Christopher Li <sparse@chrisli.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Markus Trippelsdorf <markus@trippelsdorf.de>, Steven Rostedt <rostedt@goodmis.org>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Peter Foley <pefoley2@pefoley.com>, Tim Chen <tim.c.chen@linux.intel.com>, Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, xen-devel <xen-devel@lists.xenproject.org>, kvm list <kvm@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Sparse Mailing-list <linux-sparse@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 25, 2017 at 8:05 AM, Thomas Garnier <thgarnie@google.com> wrote:
> On Fri, Aug 25, 2017 at 1:04 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> * Thomas Garnier <thgarnie@google.com> wrote:
>>
>>> With the fix for function tracing, the hackbench results have an
>>> average of +0.8 to +1.4% (from +8% to +10% before). With a default
>>> configuration, the numbers are closer to 0.8%.
>>>
>>> On the .text size, with gcc 4.9 I see +0.8% on default configuration
>>> and +1.180% on the ubuntu configuration.
>>
>> A 1% text size increase is still significant. Could you look at the disassembly,
>> where does the size increase come from?
>
> I will take a look, in this current iteration I added the .got and
> .got.plt so removing them will remove a big (even if they are small,
> we don't use them to increase perf).
>
> What do you think about the perf numbers in general so far?

I looked at the size increase. I could identify two common cases:

1) PIE sometime needs two instructions to represent a single
instruction on mcmodel=kernel.

For example, this instruction plays on the sign extension (mcmodel=kernel):

mov    r9,QWORD PTR [r11*8-0x7e3da060] (8 bytes)

The address 0xffffffff81c25fa0 can be represented as -0x7e3da060 using
a 32S relocation.

with PIE:

lea    rbx,[rip+<off>] (7 bytes)
mov    r9,QWORD PTR [rbx+r11*8] (6 bytes)

2) GCC does not optimize switches in PIE in order to reduce relocations:

For example the switch in phy_modes [1]:

static inline const char *phy_modes(phy_interface_t interface)
{
    switch (interface) {
    case PHY_INTERFACE_MODE_NA:
        return "";
    case PHY_INTERFACE_MODE_INTERNAL:
        return "internal";
    case PHY_INTERFACE_MODE_MII:
        return "mii";

Without PIE (gcc 7.2.0), the whole table is optimize to be one instruction:

   0x000000000040045b <+27>:    mov    rdi,QWORD PTR [rax*8+0x400660]

With PIE (gcc 7.2.0):

   0x0000000000000641 <+33>:    movsxd rax,DWORD PTR [rdx+rax*4]
   0x0000000000000645 <+37>:    add    rax,rdx
   0x0000000000000648 <+40>:    jmp    rax
....
   0x000000000000065d <+61>:    lea    rdi,[rip+0x264]        # 0x8c8
   0x0000000000000664 <+68>:    jmp    0x651 <main+49>
   0x0000000000000666 <+70>:    lea    rdi,[rip+0x2bc]        # 0x929
   0x000000000000066d <+77>:    jmp    0x651 <main+49>
   0x000000000000066f <+79>:    lea    rdi,[rip+0x2a8]        # 0x91e
   0x0000000000000676 <+86>:    jmp    0x651 <main+49>
   0x0000000000000678 <+88>:    lea    rdi,[rip+0x294]        # 0x913
   0x000000000000067f <+95>:    jmp    0x651 <main+49>

That's a deliberate choice, clang is able to optimize it (clang-3.8):

   0x0000000000000963 <+19>:    lea    rcx,[rip+0x200406]        # 0x200d70
   0x000000000000096a <+26>:    mov    rdi,QWORD PTR [rcx+rax*8]

I checked gcc and the code deciding to fold the switch basically do
not do it for pic to reduce relocations [2].

The switches are the biggest increase on small functions but I don't
think they represent a large portion of the difference (number 1 is).

A side note, while testing gcc 7.2.0 on hackbench I have seen the PIE
kernel being faster by 1% across multiple runs (comparing 50 runs done
across 5 reboots twice). I don't think PIE is faster than a
mcmodel=kernel but recent versions of gcc makes them fairly similar.

[1] http://elixir.free-electrons.com/linux/v4.13-rc7/source/include/linux/phy.h#L113
[2] https://github.com/gcc-mirror/gcc/blob/7977b0509f07e42fbe0f06efcdead2b7e4a5135f/gcc/tree-switch-conversion.c#L828

>
>>
>> Thanks,
>>
>>         Ingo
>
>
>
> --
> Thomas



-- 
Thomas
