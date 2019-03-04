MIME-Version: 1.0
References: <20190212180441.15340-1-keescook@chromium.org> <20190212180441.15340-2-keescook@chromium.org>
 <CAK8P3a2xC3OVckPnweSjor3AH5LpSzichKxAjkAcgXDtCf0QmQ@mail.gmail.com>
 <CAKv+Gu_+GZ8Ut0nN+za+V48Eo6O27P_go3Dk1rDe1Wederad1Q@mail.gmail.com>
 <CAGXu5jLwEh-_v_aVm35hSqbX3QzdFOy_AwEa4mmKM8JmWtiKGA@mail.gmail.com> <CAK8P3a3r-VV=xwuUgC5kMoNsOymjzSoZ4h-ks_p7AzNDfPa4oA@mail.gmail.com>
In-Reply-To: <CAK8P3a3r-VV=xwuUgC5kMoNsOymjzSoZ4h-ks_p7AzNDfPa4oA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 4 Mar 2019 09:32:41 -0800
Message-ID: <CAGXu5j+zZdgeBg6kkh-oC4qfJAgaOm04Lpni4HkkGKNRZ6BU9A@mail.gmail.com>
Subject: Re: [PATCH 1/2] gcc-plugins: structleak: Generalize to all variable types
Content-Type: text/plain; charset="UTF-8"
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>, Alexander Popov <alex.popov@linux.com>, Laura Abbott <labbott@redhat.com>, Jann Horn <jannh@google.com>, Alexander Potapenko <glider@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 2, 2019 at 2:16 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Sat, Mar 2, 2019 at 4:43 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Sat, Mar 2, 2019 at 1:05 AM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > >
> > > On Thu, 28 Feb 2019 at 21:27, Arnd Bergmann <arnd@arndb.de> wrote:
> > > > I get similar results with asan-stack=1 but without your plugin, only
> > > > the combination of the two has the explosive stack size growth.
> >
> > I can look more closely, but I'm not sure it's entirely worth it:
> > these two may not make sense to build at the same time. (e.g. the
> > use-after-scope config was disallowed to work with this plugin.)
>
> Well, I still want to make sure all 'randconfig' builds complete without
> warnings, and without having to turn off the otherwise useful
> stack overflow warnings.
>
> One thing I noticed is that your patch removes the 'depends on
> !COMPILE_TEST' check for GCC_PLUGIN_STRUCTLEAK_BYREF_ALL,
> so if we add that back in, it would at least take care of the
> allmodconfig and randconfig cases.

Okay, I'll add this back in the next few days.

-- 
Kees Cook
