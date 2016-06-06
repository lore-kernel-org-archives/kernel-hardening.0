Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160606133801.GA6136@davidb.org>
References: <20160531013029.4c5db8b570d86527b0b53fe4@gmail.com>
 <20160531013145.612696c12f2ef744af739803@gmail.com> <20160601124227.e922af8299168c09308d5e1b@linux-foundation.org>
 <20160603194252.91064b8e682ad988283fc569@gmail.com> <20160606133801.GA6136@davidb.org>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 6 Jun 2016 08:50:38 -0700
Message-ID: <CAGXu5jKDdPsRU+oa8hKpFCyf2Q-BvnNJ0ZrPM_b6frw-h0Cg_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH v2 1/3] Add the latent_entropy gcc plugin
To: David Brown <david.brown@linaro.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux-MM <linux-mm@kvack.org>, Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, bart.vanassche@sandisk.com, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 6, 2016 at 6:38 AM, David Brown <david.brown@linaro.org> wrote:
> On Fri, Jun 03, 2016 at 07:42:52PM +0200, Emese Revfy wrote:
>>
>> On Wed, 1 Jun 2016 12:42:27 -0700
>> Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>>> On Tue, 31 May 2016 01:31:45 +0200 Emese Revfy <re.emese@gmail.com>
>>> wrote:
>>>
>>> > This plugin mitigates the problem of the kernel having too little
>>> > entropy during
>>> > and after boot for generating crypto keys.
>>> >
>>> > It creates a local variable in every marked function. The value of this
>>> > variable is
>>> > modified by randomly chosen operations (add, xor and rol) and
>>> > random values (gcc generates them at compile time and the stack pointer
>>> > at runtime).
>>> > It depends on the control flow (e.g., loops, conditions).
>>> >
>>> > Before the function returns the plugin writes this local variable
>>> > into the latent_entropy global variable. The value of this global
>>> > variable is
>>> > added to the kernel entropy pool in do_one_initcall() and _do_fork().
>>>
>>> I don't think I'm really understanding.  Won't this produce the same
>>> value on each and every boot?
>>
>>
>> No, because of interrupts and intentional data races.
>
>
> Wouldn't that result in the value having one of a small number of
> values, then?  Even if it was just one of thousands or millions of
> values, it would make the search space quite small.

My understanding is that it's not cryptographically secure, but it
provides a way for different machines and different boots to end up
with different seeds here, which is a big improvement over some of the
embedded devices that all boot with the same entropy every time.

I would, however, like to see the documentation improved to describe
the "How" and "Why". The "What" is pretty well covered. Adding
comments to the plugin for kernel developers (not compiler developers)
would help a lot: assume the reader knows nothing about gcc plugins.
:)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
