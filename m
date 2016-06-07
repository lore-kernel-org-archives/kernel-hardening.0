Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160607235935.60ef8505b54f052a464bc4de@gmail.com>
References: <20160524000719.b456ed0cd2aafacb4e53f177@gmail.com>
 <CAGXu5jKC=HuCe3FPuuzjAZ+SX6C5AnhMp5BWwLhi8xVXhTGjEg@mail.gmail.com>
 <57458279.6080009@suse.com> <CAGXu5jKw_oQNCVUH+o_k-W+5Z7LDXgJ3UpP24a+y4S0Ny+gvvw@mail.gmail.com>
 <57573559.1010607@suse.com> <CAGXu5j+y-fb7qj+C2xNXzqT1-ob-CJq7D6cLHGNTcpCWMPGA4Q@mail.gmail.com>
 <20160607235935.60ef8505b54f052a464bc4de@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 7 Jun 2016 14:58:27 -0700
Message-ID: <CAGXu5jLGCCoM83wXXasVz=1neBKbfZmrcrT39ZXqXTh7FUgEaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v9 0/4] Introduce GCC plugin infrastructure
To: Emese Revfy <re.emese@gmail.com>
Cc: Michal Marek <mmarek@suse.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>, Dmitry Vyukov <dvyukov@google.com>, LKML <linux-kernel@vger.kernel.org>, David Brown <david.brown@linaro.org>, Masahiro Yamada <yamada.masahiro@socionext.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 7, 2016 at 2:59 PM, Emese Revfy <re.emese@gmail.com> wrote:
> On Tue, 7 Jun 2016 13:59:53 -0700
> Kees Cook <keescook@chromium.org> wrote:
>
>> >
>> > I applied the series to kbuild.git#kbuild now, sorry for the delay.
>>
>> Awesome! Thank you very much. I'll prepare the latent entropy plugin
>> for -next now too.
>
> I'll send a new patch series this week because I'm developing a small feature and
> I'm fixing the handling of tail calls.

Depending on timing, it may be best to send a delta patch from
kbuild.git#kbuild. I assume that would be easier for Michal to carry.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
