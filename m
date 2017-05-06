MIME-Version: 1.0
In-Reply-To: <58E639E0.1010700@iogearbox.net>
References: <CAHgaXd+EKJ0FWaaPojsNJtgY_YpdQXu6eMEp97uOpTFAWs4qTQ@mail.gmail.com>
 <CAGXu5jLo8UvpNSQZBHjWZoO959ha6KFQxFzmg7SK44wz=R_QSg@mail.gmail.com>
 <CAHgaXdJL92XRjHae2Nb9j9SerSe65=N=ErDHTQf23sdBxwthzw@mail.gmail.com>
 <20170315.145512.1542025976162251828.davem@davemloft.net> <CAHgaXd+4QkFxnt-_iCqH8AyCN_Y8gXwr+y=iugz38NKSWspsbA@mail.gmail.com>
 <58DAF908.8010404@iogearbox.net> <CAHgaXdKfbob3WHMho32JSh_dmfp2A=cjcePqk+NfajVpShPE6Q@mail.gmail.com>
 <CAHgaXdJ1M4W3p9=B2hJmtxByPsA5-XHae8U6YtDH_2r_XMaR5A@mail.gmail.com> <58E639E0.1010700@iogearbox.net>
From: Shubham Bansal <illusionist.neo@gmail.com>
Date: Sat, 6 May 2017 22:18:16 +0530
Message-ID: <CAHgaXdK1XjDnhTqtk=nCq2crrigHiuCaLhF+1GupJt9bPThwZw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: arch: arm: bpf: Converting cBPF to eBPF for arm 32 bit
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: David Miller <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Mircea Gherzan <mgherzan@gmail.com>, Network Development <netdev@vger.kernel.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, ast@fb.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Daniel,

Thanks for the last reply about the testing of eBPF JIT.

I have one issue though, I am not able to find what BPF_ABS and
BPF_IND instruction does exactly. It not described on this link -
https://www.kernel.org/doc/Documentation/networking/filter.txt either.
Can you please tell me where I could find the description of these
instructions please?
Best,
Shubham Bansal


On Thu, Apr 6, 2017 at 6:21 PM, Daniel Borkmann <daniel@iogearbox.net> wrote:
> On 04/06/2017 01:05 PM, Shubham Bansal wrote:
>>
>> Gentle Reminder.
>
>
> Sorry for late reply.
>
>> Anybody can tell me how to test the JIT compiler ?
>
>
> There's lib/test_bpf.c, see Documentation/networking/filter.txt +1349
> for some more information. It basically contains various test cases that
> have the purpose to test the JIT with corner cases. If you see a useful
> test missing, please send a patch for it, so all other JITs can benefit
> from this as well. For extracting disassembly from a generated test case,
> check out bpf_jit_disasm (Documentation/networking/filter.txt +486).
>
> Thanks,
> Daniel
