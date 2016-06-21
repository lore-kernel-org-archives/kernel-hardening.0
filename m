Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CALCETrWEokFnfjx_LjG_S4TizjVo=YcJNpeoSwxHn0-d2+Aw+A@mail.gmail.com>
References: <cover.1466466093.git.luto@kernel.org> <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
 <CALCETrX0VXZVgy0_6-Jq_sT4yPKYogGjTZvn8VqvMzPtw4-3wg@mail.gmail.com>
 <CA+55aFzBAdM2UGpmVQjhnEtsvfPmJE1aqeoo4e65PrQvsvsFnQ@mail.gmail.com> <CALCETrWEokFnfjx_LjG_S4TizjVo=YcJNpeoSwxHn0-d2+Aw+A@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 21 Jun 2016 11:12:31 -0700
Message-ID: <CAGXu5jLQk8zha3cx158GU6AGN+XDManurTmuC08XjYcJBJhvfg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Andy Lutomirski <luto@amacapital.net>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 21, 2016 at 10:27 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Jun 21, 2016 at 10:16 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Tue, Jun 21, 2016 at 9:45 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>
>>> So I'm leaning toward fewer cache entries per cpu, maybe just one.
>>> I'm all for making it a bit faster, but I think we should weigh that
>>> against increasing memory usage too much and thus scaring away the
>>> embedded folks.
>>
>> I don't think the embedded folks will be scared by a per-cpu cache, if
>> it's just one or two entries.  And I really do think that even just
>> one or two entries will indeed catch a lot of the cases.
>>
>> And yes, fork+execve() is too damn expensive in page table build-up
>> and tear-down. I'm not sure why bash doesn't do vfork+exec for when it
>> has to wait for the process anyway, but it doesn't seem to do that.
>>
>
> I don't know about bash, but glibc very recently fixed a long-standing
> but in posix_spawn and started using clone() in a sensible manner for
> this.
>
> FWIW, it may be a while before this can be enabled in distro kernels.
> There are some code paths (*cough* crypto users *cough*) that think
> that calling sg_init_one with a stack address is a reasonable thing to
> do, and it doesn't work with a vmalloced stack.  grsecurity works

... O_o ...

Why does it not work on a vmalloced stack??

> around this by using a real lowmem higher-order stack, aliasing it
> into vmalloc space, and arranging for virt_to_phys to backtrack the
> alias, but eww.  I think I'd rather find and fix the bugs, assuming
> they're straightforward.

Yeah. That's ugly.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
