MIME-Version: 1.0
References: <20181206083257.9596-1-ard.biesheuvel@linaro.org>
 <201812091807.4emRkZ7L%fengguang.wu@intel.com> <20181209103740.GB30658@n2100.armlinux.org.uk>
 <CAGXu5j+WLpjNq0p41eu+VeZxV3yeTB19uNYxCQevbcDYkv7gJw@mail.gmail.com>
In-Reply-To: <CAGXu5j+WLpjNq0p41eu+VeZxV3yeTB19uNYxCQevbcDYkv7gJw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 12 Dec 2018 13:26:26 -0800
Message-ID: <CAGXu5j+FzZ7FuhLvfR6Lm_d7dN2Pc3qn7xaqV6HLp6xtGy+kGg@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: smp: add support for per-task stack canaries
Content-Type: text/plain; charset="UTF-8"
To: Russell King <linux@armlinux.org.uk>
Cc: kbuild test robot <lkp@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kbuild-all@01.org, LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Emese Revfy <re.emese@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Laura Abbott <labbott@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 10, 2018 at 2:34 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Sun, Dec 9, 2018 at 2:38 AM Russell King - ARM Linux
> <linux@armlinux.org.uk> wrote:
> >
> > On Sun, Dec 09, 2018 at 06:28:11PM +0800, kbuild test robot wrote:
> > > Hi Ard,
> > >
> > > I love your patch! Perhaps something to improve:
> >
> > Hi,
> >
> > This looks to me like a false warning - how can a patch touching arch
> > code affect the result of lib/test_ubsan.c?  Please can you double-
> > check this result?
>
> Yeah, no idea. Do you want me to toss this into the ARM patch queue?
> If not, I can this through the gcc-plugin tree.

Since the ARM changes are relatively small, and it adds a new plugin,
I'll take this via the gcc-plugins tree for -next now. Please yell if
this should be done differently.

Thanks!

-- 
Kees Cook
