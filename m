Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CA+55aFyu=G09-Qg=M-7CmAudS1Mj+OZMPNerd9VfUwvNk8VL+Q@mail.gmail.com>
References: <cover.1466466093.git.luto@kernel.org> <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
 <CALCETrUuG0-tGNQ5iAEO2_gaK1eUq7AoALoBeQKcOP8cvxr=eA@mail.gmail.com>
 <CA+55aFx480bxx7VAmFqdsVGHjoSav4eCvVpcx5ZSpBQuq+=1Mw@mail.gmail.com>
 <20160623143126.GA16664@redhat.com> <CA+55aFwBL5ArLXZ0+YggTbp6Qon+OM+Foihe0yrQOmRRvu96VQ@mail.gmail.com>
 <20160623170352.GA17372@redhat.com> <CA+55aFwHUw+6xEc-M+mZvwOxCsBD6zZDwyAQ-a_xupaH8py7cA@mail.gmail.com>
 <CA+55aFy54iDN56FDJAz3A8epRvKECVO+nL5LaMxdmKrFEOm05w@mail.gmail.com>
 <20160623185340.GO30154@twins.programming.kicks-ass.net> <CA+55aFzhUo=2M-y39NOpWAVm1h0ADfjR3dxszJmefvoEYLa2og@mail.gmail.com>
 <CA+55aFxo8tU42+hMjRgs1dUrqn1=rzDnvikRHHWV9HwDVeYkuQ@mail.gmail.com>
 <CAMzpN2i7ve0Rq9BCxjp2FUw5naPLrGDd7Mf3evrrRjUZN75oJQ@mail.gmail.com>
 <CA+55aFwJ1=pyr9fP_UzDjnyX2qJ4mpxg_DTTiOJTv9PFW4dHgg@mail.gmail.com> <CA+55aFyu=G09-Qg=M-7CmAudS1Mj+OZMPNerd9VfUwvNk8VL+Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 24 Jun 2016 10:51:35 -0700
Message-ID: <CA+55aFyKxNZQtCS3VY_8qMS4B=q-ar5ST8RdCTwAC07ZOkBjQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Brian Gerst <brgerst@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 24, 2016 at 10:40 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I think I have a few new places to look at..

Yeah, making the 'stack' pointer be 'unsigned long *' rather than
'void *' shows a number of places where we were very confused about
things.

And in particular, the init_task stack initialization initialized it
to the init_thread pointer. Which was definitely deadly.

Let's see if that was it..

                  Linus
