MIME-Version: 1.0
References: <20190510090025.4680-1-chris.packham@alliedtelesis.co.nz> <CAD=FV=UN8rm_40eVz4YVVJ57d_BWkzxs1E4nYhX_mKWe2pwX0Q@mail.gmail.com>
In-Reply-To: <CAD=FV=UN8rm_40eVz4YVVJ57d_BWkzxs1E4nYhX_mKWe2pwX0Q@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu, 16 May 2019 10:47:08 +0200
Message-ID: <CAKv+Gu98jQA7XARghVNXq8qEBm4DG77q3K0j-zw-WX_w-4_Q-Q@mail.gmail.com>
Subject: Re: [PATCH] gcc-plugins: arm_ssp_per_task_plugin: Fix for older GCC < 6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>, Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, 11 May 2019 at 00:42, Doug Anderson <dianders@chromium.org> wrote:
>
> Hi,
>
> > Use gen_rtx_set instead of gen_rtx_SET. The former is a wrapper macro
> > that handles the difference between GCC versions implementing
> > the latter.
> >
> > This fixes the following error on my system with g++ 5.4.0 as the host
> > compiler
> >
> >    HOSTCXX -fPIC scripts/gcc-plugins/arm_ssp_per_task_plugin.o
> >  scripts/gcc-plugins/arm_ssp_per_task_plugin.c:42:14: error: macro "gen=
_rtx_SET" requires 3 arguments, but only 2 given
> >           mask)),
> >                ^
> >  scripts/gcc-plugins/arm_ssp_per_task_plugin.c: In function =E2=80=98un=
signed int arm_pertask_ssp_rtl_execute()=E2=80=99:
> >  scripts/gcc-plugins/arm_ssp_per_task_plugin.c:39:20: error: =E2=80=98g=
en_rtx_SET=E2=80=99 was not declared in this scope
> >     emit_insn_before(gen_rtx_SET
> >
> > Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> > ---
> >  scripts/gcc-plugins/arm_ssp_per_task_plugin.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> I can confirm that I was getting compile errors before this patch and
> applying it allowed me to compile and boot.  Thanks!  :-)
>
> Tested-by: Douglas Anderson <dianders@chromium.org>
>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
