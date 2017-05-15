Message-ID: <591A07A1.1030006@iogearbox.net>
Date: Mon, 15 May 2017 21:55:13 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
References: <CAHgaXdKsO2xoKYp7g91g+n+d_1KHSSByLjzBB-WjVXSjhB7qxw@mail.gmail.com> <20170510.212952.1440495072777358778.davem@davemloft.net> <CAHgaXdK8LEEUPm4jTRRzCnjwdWAauHmmB=caZsSFY8MmStH89Q@mail.gmail.com> <20170510.215218.2185526627014393313.davem@davemloft.net> <CAHgaXdKZ_v+iO7uqEDx7PA7D+xcp1FngGvJ1SRSsGXNQ-iWWDQ@mail.gmail.com> <CAHgaXdLJoVUXXGTYs7FYXay5wx=sA-O+=dYhX+r7AQT7vSNfGQ@mail.gmail.com> <CAGXu5j+2q4Wwfhuk_DnDaV894A9ZOD=A_AvAU_OZG6KQv0_KMg@mail.gmail.com> <CAHgaXdL7GcVzs+ANPke_NywhcgHbe_fzi1sTDEy+Ni1-o82GYQ@mail.gmail.com>
In-Reply-To: <CAHgaXdL7GcVzs+ANPke_NywhcgHbe_fzi1sTDEy+Ni1-o82GYQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: arch: arm: bpf: Converting cBPF to eBPF for arm 32 bit
To: Shubham Bansal <illusionist.neo@gmail.com>, Kees Cook <keescook@chromium.org>
Cc: David Miller <davem@davemloft.net>, Mircea Gherzan <mgherzan@gmail.com>, Network Development <netdev@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, ast@fb.com
List-ID: <kernel-hardening.lists.openwall.com>

On 05/13/2017 11:38 PM, Shubham Bansal wrote:
> Finally finished testing.
>
> "test_bpf: Summary: 314 PASSED, 0 FAILED, [274/306 JIT'ed]"

What are the missing pieces and how is the performance compared
to the interpreter?

Thanks,
Daniel
