Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJGGaXysBKbF_-uSwbMys+oYi176q8mFr_NCC6rEBvvSw@mail.gmail.com>
References: <56A48779.3000005@eng.utah.edu> <CAGXu5jJGGaXysBKbF_-uSwbMys+oYi176q8mFr_NCC6rEBvvSw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 28 Jan 2016 15:34:32 -0800
Message-ID: <CALCETrVvCzVLFAiCCMN4Xu0HYpwHKuKAC4GwPAxrnRt7Bn7Yig@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC PATCH 0/2] SROP Mitigation
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andi Kleen <ak@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 28, 2016 at 3:10 PM, Kees Cook <keescook@chromium.org> wrote:
> On Sun, Jan 24, 2016 at 12:12 AM, Scotty Bauer <sbauer@eng.utah.edu> wrote:
>> Erik Bosman previously attempted to upstream some patches which mitigate SROP
>> exploits in userland. Unfortunately he never pursued it further and they never
>> got upstreamed.
>>
>> The previous patches can be seen here:
>> https://lkml.org/lkml/2014/5/15/660
>> https://lkml.org/lkml/2014/5/15/661
>> https://lkml.org/lkml/2014/5/15/657
>> https://lkml.org/lkml/2014/5/15/858
>>
>> In the discussion for those patches Andy Lutomirski and Andi Kleen had a few
>> suggestions which are implemented in my patch series.
>>
>> Andy Lutomirski suggested that the per-process secret be xord and with the location
>> on the stack where the cookie will reside, then hashed. I've taken this approach but
>> have concerns about the safety and collision properties of the hash function I've used.
>>
>> Second, Andi Kleen was concerned that the previous patches broke the ABI. He suggested
>> placing the cookie above the FP state. The code I'm submitting does that by placing the
>> cookie in the padding above the FP state, or if no FP state is available above the
>> padding for the sigframe.
>>
>>
>> Below is an explanation of SROP stolen and slightly modified by me from Erik's patches.
>>
>> These patches are meant to make Sigreturn Oriented Programming (SROP) a much
>> less attractive exploitation path.  In Sigreturn Oriented Programming, an
>> attacker causes a user-space program to call the sigreturn system call in order
>> to get complete control control over the entire userspace context in one go.
>>
>> Previously attackers would have to search for ROP gadgets to get values into registers
>> then call mprotect or mmap. If the ROP gadgets didnt exist well then they'd be in trouble.
>> With SROP however one wouldn't have to search for ROP gadgets to get values into regs.
>> The attacker would simply lay out the ucontext on the stack as they choose then
>> SROP into the mprotect or mmap call.
>>
>> ( see: http://www.cs.vu.nl/~herbertb/papers/srop_sp14.pdf )
>>
>> While mitigating SROP will probably not stop determined attackers from
>> exploiting a program, as there's always the much more well-known Return
>> Oriented Programming, we still think SROP's relative ease warrants mitigation,
>> especially since the mitigation is so cheap.
>
> Cool! Thanks for bringing this series back! I quickly skimmed the
> paper, so I apologize if I missed it, but have there been any public
> exploits that used SROP, or is it considered to be "just" an
> identified weakness in need of fixing?
>
> It seems performance overhead would be lost in the noise of catching
> and processing signals, but have you done any benchmarks?
>

It would also be important to test DOSEMU and CRIU, both of which do
interesting things with signal frames.

--Andy
