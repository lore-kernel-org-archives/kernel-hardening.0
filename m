Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFyWJSE3DdoZvtc=tkuqvn1eQC=-dK=kfQ70ZR_7xLTkvA@mail.gmail.com>
References: <CA+55aFy54iDN56FDJAz3A8epRvKECVO+nL5LaMxdmKrFEOm05w@mail.gmail.com>
 <20160623185340.GO30154@twins.programming.kicks-ass.net> <CA+55aFzhUo=2M-y39NOpWAVm1h0ADfjR3dxszJmefvoEYLa2og@mail.gmail.com>
 <CA+55aFxo8tU42+hMjRgs1dUrqn1=rzDnvikRHHWV9HwDVeYkuQ@mail.gmail.com>
 <CAMzpN2i7ve0Rq9BCxjp2FUw5naPLrGDd7Mf3evrrRjUZN75oJQ@mail.gmail.com>
 <CA+55aFwJ1=pyr9fP_UzDjnyX2qJ4mpxg_DTTiOJTv9PFW4dHgg@mail.gmail.com>
 <CA+55aFyu=G09-Qg=M-7CmAudS1Mj+OZMPNerd9VfUwvNk8VL+Q@mail.gmail.com>
 <CA+55aFyKxNZQtCS3VY_8qMS4B=q-ar5ST8RdCTwAC07ZOkBjQA@mail.gmail.com>
 <CA+55aFx=wdH4v7cD2F5Kq+jwDfV5cz9qTANgOwpMTC3MY=99AQ@mail.gmail.com>
 <20160624202530.unmidps4kpebo2na@treble> <20160624205116.4hbnurrnan4afq2t@treble>
 <CA+55aFyWJSE3DdoZvtc=tkuqvn1eQC=-dK=kfQ70ZR_7xLTkvA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 24 Jun 2016 14:25:38 -0700
Message-ID: <CALCETrXUZbsr+ZvcCsffCMGFwX7xs8zqM2WGtfwLd+ws7T5A6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Brian Gerst <brgerst@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 24, 2016 at 2:06 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Jun 24, 2016 at 1:51 PM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>>
>> Found another bug:
>
> Yup. Those two were the ones that kept it from working for me. Thanks.
>
> Anyway, here's the final combined patch that works for me on x86-64.
> No more thread-info on the stack.
>

What's the prognosis for this patch?  Should I queue up all the pieces
and send them out after the vmap-stack thing?

--Andy
