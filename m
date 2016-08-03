Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVtD+eBoHEeNWGUnNAtJkDCEsq2JLg0RC9grSG7Eje3tQ@mail.gmail.com>
References: <1470071280-78706-1-git-send-email-thgarnie@google.com>
 <1470071280-78706-2-git-send-email-thgarnie@google.com> <CAE9FiQXPnXa_Ep2nk+y5boZ9Csdk_yoH5Ws8SaExn0-VHU9bBg@mail.gmail.com>
 <CAJcbSZE1kPpL_hWLK70fGhgjP3xRBaZ=r32E9q1SBwhCbqOp5Q@mail.gmail.com> <CAE9FiQVtD+eBoHEeNWGUnNAtJkDCEsq2JLg0RC9grSG7Eje3tQ@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Wed, 3 Aug 2016 08:29:42 -0700
Message-ID: <CAJcbSZGcL9G4edsa3LEr-f0srpZPtsDTOeOjCC_nJddn6SOskg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v1 1/2] x86/power/64: Support unaligned addresses for
 temporary mapping
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 2, 2016 at 12:55 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Aug 2, 2016 at 10:48 AM, Thomas Garnier <thgarnie@google.com> wro=
te:
>> On Tue, Aug 2, 2016 at 10:36 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>>
>>> Looks like we need to change the loop from phys address to virtual
>>> address instead.
>>> to avoid the overflow.
>
> something like attached.

I tested it and it worked well. I just got this warning on build:

In file included from arch/x86/mm/init_64.c:60:0:
arch/x86/mm/ident_map.c: In function =E2=80=98ident_pmd_init=E2=80=99:
arch/x86/mm/ident_map.c:18:29: warning: suggest parentheses around
arithmetic in operand of =E2=80=98|=E2=80=99 [-Wparentheses]
    set_pmd(pmd, __pmd(vaddr - off | info->pmd_flag));

Do you want to resend your version for integration?
