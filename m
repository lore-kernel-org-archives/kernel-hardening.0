Reply-To: kernel-hardening@lists.openwall.com
References: <20160524000719.b456ed0cd2aafacb4e53f177@gmail.com>
 <CAGXu5jKC=HuCe3FPuuzjAZ+SX6C5AnhMp5BWwLhi8xVXhTGjEg@mail.gmail.com>
 <57458279.6080009@suse.com>
 <CAGXu5jKw_oQNCVUH+o_k-W+5Z7LDXgJ3UpP24a+y4S0Ny+gvvw@mail.gmail.com>
 <57573559.1010607@suse.com>
 <CAGXu5j+y-fb7qj+C2xNXzqT1-ob-CJq7D6cLHGNTcpCWMPGA4Q@mail.gmail.com>
 <20160607235935.60ef8505b54f052a464bc4de@gmail.com>
 <CAGXu5jLGCCoM83wXXasVz=1neBKbfZmrcrT39ZXqXTh7FUgEaA@mail.gmail.com>
From: Michal Marek <mmarek@suse.com>
Message-ID: <5757C262.4010000@suse.com>
Date: Wed, 8 Jun 2016 08:59:46 +0200
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLGCCoM83wXXasVz=1neBKbfZmrcrT39ZXqXTh7FUgEaA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v9 0/4] Introduce GCC plugin infrastructure
To: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>, Dmitry Vyukov <dvyukov@google.com>, LKML <linux-kernel@vger.kernel.org>, David Brown <david.brown@linaro.org>, Masahiro Yamada <yamada.masahiro@socionext.com>
List-ID: <kernel-hardening.lists.openwall.com>

Dne 7.6.2016 v 23:58 Kees Cook napsal(a):
> On Tue, Jun 7, 2016 at 2:59 PM, Emese Revfy <re.emese@gmail.com> wrote:
>> On Tue, 7 Jun 2016 13:59:53 -0700
>> Kees Cook <keescook@chromium.org> wrote:
>>
>>>>
>>>> I applied the series to kbuild.git#kbuild now, sorry for the delay.
>>>
>>> Awesome! Thank you very much. I'll prepare the latent entropy plugin
>>> for -next now too.
>>
>> I'll send a new patch series this week because I'm developing a small feature and
>> I'm fixing the handling of tail calls.
> 
> Depending on timing, it may be best to send a delta patch from
> kbuild.git#kbuild. I assume that would be easier for Michal to carry.

Right.

Michal
