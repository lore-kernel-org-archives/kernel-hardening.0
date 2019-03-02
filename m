MIME-Version: 1.0
References: <20190212180441.15340-1-keescook@chromium.org> <20190212180441.15340-2-keescook@chromium.org>
 <CAK8P3a2xC3OVckPnweSjor3AH5LpSzichKxAjkAcgXDtCf0QmQ@mail.gmail.com>
 <CAKv+Gu_+GZ8Ut0nN+za+V48Eo6O27P_go3Dk1rDe1Wederad1Q@mail.gmail.com> <CAGXu5jLwEh-_v_aVm35hSqbX3QzdFOy_AwEa4mmKM8JmWtiKGA@mail.gmail.com>
In-Reply-To: <CAGXu5jLwEh-_v_aVm35hSqbX3QzdFOy_AwEa4mmKM8JmWtiKGA@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Sat, 2 Mar 2019 23:15:53 +0100
Message-ID: <CAK8P3a3r-VV=xwuUgC5kMoNsOymjzSoZ4h-ks_p7AzNDfPa4oA@mail.gmail.com>
Subject: Re: [PATCH 1/2] gcc-plugins: structleak: Generalize to all variable types
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>, Alexander Popov <alex.popov@linux.com>, Laura Abbott <labbott@redhat.com>, Jann Horn <jannh@google.com>, Alexander Potapenko <glider@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 2, 2019 at 4:43 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Sat, Mar 2, 2019 at 1:05 AM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> > On Thu, 28 Feb 2019 at 21:27, Arnd Bergmann <arnd@arndb.de> wrote:
> > > I get similar results with asan-stack=1 but without your plugin, only
> > > the combination of the two has the explosive stack size growth.
>
> I can look more closely, but I'm not sure it's entirely worth it:
> these two may not make sense to build at the same time. (e.g. the
> use-after-scope config was disallowed to work with this plugin.)

Well, I still want to make sure all 'randconfig' builds complete without
warnings, and without having to turn off the otherwise useful
stack overflow warnings.

One thing I noticed is that your patch removes the 'depends on
!COMPILE_TEST' check for GCC_PLUGIN_STRUCTLEAK_BYREF_ALL,
so if we add that back in, it would at least take care of the
allmodconfig and randconfig cases.

> > > I can help analyze this further, but maybe you can have a look first,
> > > there might be something obvious when you read the input to the
> > > plugin.
> > >
> >
> > Is this before or after use-after-scope was disabled entirely?
>
> I was wondering the same thing, but I assumed it didn't matter: it
> wasn't possible to use both before it was entirely disabled.

Right. I already had the use-after-scope stuff disabled for
build testing, using the same 'depends on !COMPILE_TEST'
check, so one more reason it did not make a difference.

      Arnd
