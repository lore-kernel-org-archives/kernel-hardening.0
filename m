MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAHgaXdL7GcVzs+ANPke_NywhcgHbe_fzi1sTDEy+Ni1-o82GYQ@mail.gmail.com>
References: <CAHgaXdKsO2xoKYp7g91g+n+d_1KHSSByLjzBB-WjVXSjhB7qxw@mail.gmail.com>
 <20170510.212952.1440495072777358778.davem@davemloft.net> <CAHgaXdK8LEEUPm4jTRRzCnjwdWAauHmmB=caZsSFY8MmStH89Q@mail.gmail.com>
 <20170510.215218.2185526627014393313.davem@davemloft.net> <CAHgaXdKZ_v+iO7uqEDx7PA7D+xcp1FngGvJ1SRSsGXNQ-iWWDQ@mail.gmail.com>
 <CAHgaXdLJoVUXXGTYs7FYXay5wx=sA-O+=dYhX+r7AQT7vSNfGQ@mail.gmail.com>
 <CAGXu5j+2q4Wwfhuk_DnDaV894A9ZOD=A_AvAU_OZG6KQv0_KMg@mail.gmail.com> <CAHgaXdL7GcVzs+ANPke_NywhcgHbe_fzi1sTDEy+Ni1-o82GYQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 15 May 2017 10:44:07 -0700
Message-ID: <CAGXu5jLeCB-H0nkVtpJN5SSz4r4idnKJbnV+rO610nw-o98wCQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: arch: arm: bpf: Converting cBPF to eBPF for arm 32 bit
To: Shubham Bansal <illusionist.neo@gmail.com>
Cc: David Miller <davem@davemloft.net>, Mircea Gherzan <mgherzan@gmail.com>, Network Development <netdev@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, ast@fb.com, Daniel Borkmann <daniel@iogearbox.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, May 13, 2017 at 2:38 PM, Shubham Bansal
<illusionist.neo@gmail.com> wrote:
> Finally finished testing.
>
> "test_bpf: Summary: 314 PASSED, 0 FAILED, [274/306 JIT'ed]"

Nice work! Glad you've been chipping away at this. Thanks!

-Kees

>
> Will send the patch after code refactoring. Thanks for all the help
> you guys. I really really appreciate it.
>
> Special thanks to Kees and Daniel. :)
>
> Best,
> Shubham Bansal
>
>
> On Thu, May 11, 2017 at 9:00 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Thu, May 11, 2017 at 2:32 AM, Shubham Bansal
>> <illusionist.neo@gmail.com> wrote:
>>> What do you guys suggest i should implement it? I am almost done with
>>> my current implementation but if you think I should change it to the
>>> way David suggested, its better to suggest now before I send the
>>> patch.
>>
>> I'd say send what you have right now, as it's a good starting point
>> for future work. I'll be curious to see the benchmarks, etc. It can be
>> a base for further optimization.
>>
>> Thanks for chipping away at this!
>>
>> -Kees
>>
>> --
>> Kees Cook
>> Pixel Security



-- 
Kees Cook
Pixel Security
