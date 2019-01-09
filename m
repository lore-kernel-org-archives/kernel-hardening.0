MIME-Version: 1.0
References: <20181206083257.9596-1-ard.biesheuvel@linaro.org>
 <201812091807.4emRkZ7L%fengguang.wu@intel.com> <20181209103740.GB30658@n2100.armlinux.org.uk>
 <47a91e5a-0e97-334c-2f36-a0bd966a0050@intel.com> <235f0830-a293-5b00-4510-7d7d4c829d26@intel.com>
In-Reply-To: <235f0830-a293-5b00-4510-7d7d4c829d26@intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 9 Jan 2019 13:37:49 -0800
Message-ID: <CAGXu5jLYG=UBrJXmrtoZVCka-w4_k_op8c7M1cQXmZs702fZ5Q@mail.gmail.com>
Subject: Re: [kbuild-all] [PATCH v3] ARM: smp: add support for per-task stack canaries
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Rong Chen <rong.a.chen@intel.com>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>, kbuild test robot <lkp@intel.com>, Arnd Bergmann <arnd@arndb.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, LKML <linux-kernel@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>, kbuild-all@01.org, Laura Abbott <labbott@redhat.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 8, 2019 at 10:30 PM Rong Chen <rong.a.chen@intel.com> wrote:
> I tested the commit on another machine and the warnings are exist.
> I found " -Wno-vla" was lost after the commit, so I think it's a real pro=
blem.
>
> -Werror=3Ddesignated-init -fplugin-arg-arm_ssp_per_task_plugin-tso=3D1 -f=
plugin-arg-arm_ssp_per_task_plugin-offset=3D24 -fsanitize=3Dshift -fsanitiz=
e=3Dinteger-divide-by-zero -fsanitize=3Dunreachable -fsanitize=3Dvla-bound =
-fsanitize=3Dsigned-integer-overflow -fsanitize=3Dbounds -fsanitize=3Dobjec=
t-size -fsanitize=3Dbool -fsanitize=3Denum -fsanitize=3Dalignment -Wno-mayb=
e-uninitialized -fsanitize-coverage=3Dtrace-pc -DMODULE -DKBUILD_BASENAME=
=3D'"test_ubsan"' -DKBUILD_MODNAME=3D'"test_ubsan"' -c -o lib/.tmp_test_ubs=
an.o lib/test_ubsan.c
>
> -Werror=3Ddesignated-init -Wno-vla -fsanitize=3Dshift -fsanitize=3Dintege=
r-divide-by-zero -fsanitize=3Dunreachable -fsanitize=3Dvla-bound -fsanitize=
=3Dsigned-integer-overflow -fsanitize=3Dbounds -fsanitize=3Dobject-size -fs=
anitize=3Dbool -fsanitize=3Denum -fsanitize=3Dalignment -Wno-maybe-uninitia=
lized -fsanitize-coverage=3Dtrace-pc -DMODULE -DKBUILD_BASENAME=3D'"test_ub=
san"' -DKBUILD_MODNAME=3D'"test_ubsan"' -c -o lib/.tmp_test_ubsan.o lib/tes=
t_ubsan.c

Hm, so the -Wno-vla is getting clobbered.

in lib/Makefile, I see "+=3D", so I wouldn't expect a clobber:
CFLAGS_test_kasan.o +=3D $(call cc-disable-warning, vla)
...
CFLAGS_test_ubsan.o +=3D $(call cc-disable-warning, vla)

and scripts/Makefile.gcc-plugins is using +=3D against KBUILD_CFLAGS:
KBUILD_CFLAGS +=3D $(GCC_PLUGINS_CFLAGS)

I'm not sure where the per-target CFLAGS are built, but it seems like
something has gone wrong there?

--=20
Kees Cook
