Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFy54iDN56FDJAz3A8epRvKECVO+nL5LaMxdmKrFEOm05w@mail.gmail.com>
References: <cover.1466466093.git.luto@kernel.org> <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
 <CALCETrUuG0-tGNQ5iAEO2_gaK1eUq7AoALoBeQKcOP8cvxr=eA@mail.gmail.com>
 <CA+55aFx480bxx7VAmFqdsVGHjoSav4eCvVpcx5ZSpBQuq+=1Mw@mail.gmail.com>
 <20160623143126.GA16664@redhat.com> <CA+55aFwBL5ArLXZ0+YggTbp6Qon+OM+Foihe0yrQOmRRvu96VQ@mail.gmail.com>
 <20160623170352.GA17372@redhat.com> <CA+55aFwHUw+6xEc-M+mZvwOxCsBD6zZDwyAQ-a_xupaH8py7cA@mail.gmail.com>
 <CA+55aFy54iDN56FDJAz3A8epRvKECVO+nL5LaMxdmKrFEOm05w@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 23 Jun 2016 11:00:08 -0700
Message-ID: <CAGXu5jLd=cUa-8Fdp+6hypvn=cVVVkv-MWcZBnEy956fA96aMg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 23, 2016 at 10:52 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jun 23, 2016 at 10:44 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> The thread_info->tsk pointer, that was one of the most critical issues
>> and the main raison d'=C3=AAtre of the thread_info, has been replaced on
>> x86 by just using the per-cpu "current_task". Yes,.there are probably
>> more than a few "ti->task" users left for legacy reasons, harking back
>> to when the thread-info was cheaper to access, but it shouldn't be a
>> big deal.
>
> Ugh. Looking around at this, it turns out that a great example of this
> kind of legacy issue is the debug_mutex stuff.
>
> It uses "struct thread_info *" as the owner pointer, and there is _no_
> existing reason for it. In fact, in every single place it actually
> wants the task_struct, and it does task_thread_info(task) just to
> convert it to the thread-info, and then converts it back with
> "ti->task".

Heh, yeah, that looks like a nice clean-up.

> So the attached patch seems to be the right thing to do regardless of
> this whole discussion.

Why does __mutex_lock_common() have "task" as a stack variable? It's
only assigned at the start, and is always "current". (I only noticed
from the patch changing "current_thread_info()" and
"task_thread_info(task)" both to "task".)

-Kees

--=20
Kees Cook
Chrome OS & Brillo Security
