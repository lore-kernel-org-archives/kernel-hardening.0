MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+KhAHamqhzzjs+vvPs3UbioFxvwz-OmW12Djhi+6hdy5D_phQ@mail.gmail.com>
References: <1485351983-13873-1-git-send-email-kpark3469@gmail.com>
 <20170125135410.GF27026@arm.com> <20170126071010.GE23406@linaro.org>
 <CA+KhAHbdYEdwqo5EspmkEPnvyucS2jStR_rhCe9H497T9jJ9aA@mail.gmail.com>
 <CAGXu5j+PjVG-KQJwMke4X3=Vmr1ECjU0s2v-S0d3a+BotOrC_Q@mail.gmail.com> <CA+KhAHamqhzzjs+vvPs3UbioFxvwz-OmW12Djhi+6hdy5D_phQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 31 Jan 2017 09:56:12 -0800
Message-ID: <CAGXu5jJxbqXQot9JsB1ed7pkNp4LMDQEm9j6vEnxuK57k+Pjxw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] arm64: usercopy: Implement stack frame object validation
To: Keun-O Park <kpark3469@gmail.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, Will Deacon <will.deacon@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Pratyush Anand <panand@redhat.com>, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 31, 2017 at 1:10 AM, Keun-O Park <kpark3469@gmail.com> wrote:
> On Tue, Jan 31, 2017 at 2:19 AM, Kees Cook <keescook@chromium.org> wrote:
>> On Mon, Jan 30, 2017 at 4:42 AM, Keun-O Park <kpark3469@gmail.com> wrote:
>>> Thanks so much for the example code. Basically I totally missed this case.
>>> I modified do_usercopy_stack() slightly following your code snippet.
>>> Like your comment, I could see the similar result.
>>> ....
>>>         array_size = get_random_int() & 0x0F;
>>>         if (to_user) {
>>>                 unsigned char array[array_size];
>>> ....
>>>                 pr_info("attempting bad copy_to_user of distant stack 2\n");
>>>                 if (copy_to_user((void __user *)user_addr, array,
>>>                                  unconst + sizeof(array))) {
>>>                         pr_warn("copy_to_user failed, but lacked Oops\n");
>>>                         goto free_user;
>>>                 }
>>> ....
>>> # echo USERCOPY_STACK_FRAME_TO > DIRECT
>>> [ 1999.832209] Before dynamic alloc: ffffffc079013d40
>>> [ 1999.832309] After dynamic alloc: ffffffc079013d40
>>> [ 1999.832370] lkdtm: attempting good copy_to_user of local stack
>>> [ 1999.832476] lkdtm: attempting bad copy_to_user of distant stack
>>> [ 1999.832562] usercopy: kernel memory exposure attempt detected from
>>> ffffffc079013d20 (<process stack>) (32 bytes)
>>> [ 1999.832636] usercopy: BUG()!!!
>>> [ 1999.832693] lkdtm: attempting bad copy_to_user of distant stack 2
>>> [ 1999.832779] usercopy: kernel memory exposure attempt detected from
>>> ffffffc079013d30 (<process stack>) (6 bytes)
>>> [ 1999.832853] usercopy: BUG()!!!
>>>
>>> This is output of GCC 4.9, so maybe the sp value is not expected one.
>>> Anyway it looks to me that the object should be scanned from oldframe.
>>
>> Am I correct in understanding that your code worked correctly? I.e.
>> Access to "array" worked, but stepping beyond it failed? (Does
>> sizeof() work with dynamic stack allocations?)
>
> My implementation can not detect this case. LKDTM stack test regards
> that this array is out of stackframe.
> So BUG() is called.
>
> sizeof() works fine with dynamic stack allocations for me.

Can you send the patch you used to extends the LKDTM test? The stack
layout looks the same as x86; shouldn't x86 fail in the same way?

-Kees

-- 
Kees Cook
Pixel Security
