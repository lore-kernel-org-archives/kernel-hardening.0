MIME-Version: 1.0
In-Reply-To: <90e40062-cedb-be32-ab17-56136c78dbad@redhat.com>
References: <20180315180030.20001-1-labbott@redhat.com> <20180315180030.20001-5-labbott@redhat.com>
 <21a2e869-62fb-75ef-ae7b-a27e136696f7@electromag.com.au> <90e40062-cedb-be32-ab17-56136c78dbad@redhat.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 27 Mar 2018 15:41:23 +0200
Message-ID: <CACRpkdafSd0R1czzw8w7bB8Stbvrx6LoP7tR7BQQnB1RSKQysQ@mail.gmail.com>
Subject: Re: [PATCHv2 4/4] gpio: Remove VLA from stmpe driver
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Phil Reid <preid@electromag.com.au>, Kees Cook <keescook@chromium.org>, Patrice Chotard <patrice.chotard@st.com>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Laura,

sorry for slow response :/

On Thu, Mar 22, 2018 at 10:43 PM, Laura Abbott <labbott@redhat.com> wrote:
> On 03/18/2018 06:29 PM, Phil Reid wrote:
>>
>> On 16/03/2018 02:00, Laura Abbott wrote:
>>>
>>> The new challenge is to remove VLAs from the kernel
>>> (see https://lkml.org/lkml/2018/3/7/621)
>>>
>>> This patch replaces a VLA with an appropriate call to kmalloc_array.
>>>
>>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>>> ---
>>> v2: Switch to GFP_KERNEL. There was some discussion about if we should
>>> be doing the allocation at all but given a) the allocation is pretty
>>> small and b) we can possibly take a mutex in a called function I think
>>> this is fine.
>>
>>
>> I still think it's a bad idea. It's simple to preallocate the buffer.
>> But it's up to the maintainer.
>>
>
> I'd feel a lot more confident about doing the global buffer with
> guidance from the maintainer. But looking at the platform data, the
> maximum number of GPIOs is 24, or 3 banks. Maybe we should just always
> stack allocate the maximum since it's fairly small.

Either way works fine, global (in the state container struct stmpe_gpio)
or stack allocation for 24 bits.

I guess I am maintainer for this, I can test it at least.

Yours,
Linus Walleij
