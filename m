MIME-Version: 1.0
References: <20190212180441.15340-1-keescook@chromium.org> <20190212180441.15340-2-keescook@chromium.org>
 <CAK8P3a2xC3OVckPnweSjor3AH5LpSzichKxAjkAcgXDtCf0QmQ@mail.gmail.com> <CAKv+Gu_+GZ8Ut0nN+za+V48Eo6O27P_go3Dk1rDe1Wederad1Q@mail.gmail.com>
In-Reply-To: <CAKv+Gu_+GZ8Ut0nN+za+V48Eo6O27P_go3Dk1rDe1Wederad1Q@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 2 Mar 2019 07:43:24 -0800
Message-ID: <CAGXu5jLwEh-_v_aVm35hSqbX3QzdFOy_AwEa4mmKM8JmWtiKGA@mail.gmail.com>
Subject: Re: [PATCH 1/2] gcc-plugins: structleak: Generalize to all variable types
Content-Type: text/plain; charset="UTF-8"
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>, Alexander Popov <alex.popov@linux.com>, Laura Abbott <labbott@redhat.com>, Jann Horn <jannh@google.com>, Alexander Potapenko <glider@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 2, 2019 at 1:05 AM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Thu, 28 Feb 2019 at 21:27, Arnd Bergmann <arnd@arndb.de> wrote:
> > I get similar results with asan-stack=1 but without your plugin, only
> > the combination of the two has the explosive stack size growth.

I can look more closely, but I'm not sure it's entirely worth it:
these two may not make sense to build at the same time. (e.g. the
use-after-scope config was disallowed to work with this plugin.)

> > I can help analyze this further, but maybe you can have a look first,
> > there might be something obvious when you read the input to the
> > plugin.
> >
>
> Is this before or after use-after-scope was disabled entirely?

I was wondering the same thing, but I assumed it didn't matter: it
wasn't possible to use both before it was entirely disabled.

-- 
Kees Cook
