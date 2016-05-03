Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41AF69D8@IRSMSX102.ger.corp.intel.com>
References: <2236FBA76BA1254E88B949DDB74E612B41AF69D8@IRSMSX102.ger.corp.intel.com>
Date: Tue, 3 May 2016 10:01:47 -0700
Message-ID: <CAGXu5jK7O=h7zO4xw7YaVMxNK0sHgPOoncimKXM0pWiS=j4qVQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: BPF JIT spray attack - proof of concept code for modern kernel
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Daniel Borkmann <daniel@iogearbox.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 2, 2016 at 11:38 PM, Reshetova, Elena
<elena.reshetova@intel.com> wrote:
> Following Kees=E2=80=99s suggestion, I am posting here a link to the poc =
code that I
> did to show the need of further BPF JIT hardening:
> https://github.com/01org/jit-spray-poc-for-ksp
>
> This poc is based on the 2012 poc done by McAllister:
> https://github.com/kmcallister/alameda I have kept his commits untouched =
and
> only added mine on top that you can easily see what was modified.
>
> Some description of what it does and why it does work:
>
> The original 2012 poc stopped working after the address offset randomizat=
ion
> for loading the BPF was added:
> http://lingrok.org/xref/linux-net-next/kernel/bpf/core.c#143
>
> This was due to the fact that McAllister code relied on random page guess=
ing
> and was assuming filter to start at the page start. This approach clearly
> doesn=E2=80=99t work with new random address allocation since one would n=
eed to
> guess both page and offset and incorrect guess most commonly results in a
> full restart need for normal machine (after which filter address has chan=
ged
> and you don=E2=80=99t gain any knowledge).
>
>
>
> The main changes I did was to extend the filter size to spawn longer than=
 1
> full page (to make sure it would overrun into the next page) and then rep=
eat
> the =E2=80=9Cget root payload=E2=80=9D there in circles with enough of =
=E2=80=9Cnope=E2=80=9D instructions
> to render it for most success. Also, when jumping to a new random page, I
> would try to execute the payload a number of times on the same page chang=
ing
> just an offset that is less than 10
> (https://github.com/01org/jit-spray-poc-for-ksp/blob/master/alameda.c#L32=
5 )
> to make sure to walk through the =E2=80=9Cnopes=E2=80=9D and invoke the p=
ayload if the page
> guess was correct.
>
>
>
> I have tried the poc on virtual machine with Ubuntu with 4.4 upstream ker=
nel
> and it works quite well. It can still in some cases completely stall the
> machine that reboot is required, but it does reach its root goal in most =
of
> the cases.
>
> Also, please note that similarly as 2012 poc code, this is not a real exp=
loit
> because it requires an =E2=80=9Cinsecure ko=E2=80=9D kernel module to act=
ually make a jump,
> but it illustrates the need for further JIT hardening that Daniel is
> currently working now on.

This is great! Thanks for updating this research. It strongly helps
illustrate why instruction blinding is an important defense. I'm
looking forward to Daniel's work landing.

Thanks!

-Kees

--=20
Kees Cook
Chrome OS & Brillo Security
