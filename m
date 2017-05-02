MIME-Version: 1.0
In-Reply-To: <8708035924881b2aceb280d9a6bdd14e@cs.tu-darmstadt.de>
References: <CAPLrYES-1WDi0TTdWG7Ds-u1URNeiahNhE9VAE4rLHMw7oYktg@mail.gmail.com>
 <CAGXu5j+Oncz0SgEH4QYx_dhLhits9d8ixQxGwScYCGrNVfdjAQ@mail.gmail.com>
 <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com> <8708035924881b2aceb280d9a6bdd14e@cs.tu-darmstadt.de>
From: Mathias Krause <minipli@googlemail.com>
Date: Tue, 2 May 2017 23:27:03 +0200
Message-ID: <CA+rthh_Tx+XeZmuCGebe5zXTadYRo_YOqaPfoM7LKbdZNYUtFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] It looks like there will be no more public
 versions of PaX and Grsec.
To: David Gens <david.gens@cs.tu-darmstadt.de>
Cc: Kees Cook <keescook@chromium.org>, =?UTF-8?Q?Daniel_Cegie=C5=82ka?= <daniel.cegielka@gmail.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 2 May 2017 at 13:11, David Gens <david.gens@cs.tu-darmstadt.de> wrote:
> So tell me how exactly a PaX-hardened kernel with a memory-corruption bug
> prevents an adversary from modifying critical data, such as the page tables
> in a data-only attack?

It doesn't as it has not mitigation for data-only attacks yet. But
neither does a vanilla kernel. It's even worse on vanilla Linux where
the page tables simply can be written to with a write-what-where
primitive. PaX can, however, protect the page tables from getting
modified by having them write-protected. So yes, that makes it more
secure.

> IMHO the "PaX mitigates Memory-corruption" argument
> is wishful thinking, and now that PaX is gone users cannot fool themselves
> any longer into thinking "My System is Secure". That awareness is actually
> good no?

What about KERNEXEC and CONSTIFY taking care of protecting a lot of
data structures? What about SIZE_OVERFLOW successfully preventing know
overflow bugs, like the various keys related ones? What about RAP,
ensuring control flow integrity? That's nothing, you say? Ridiculous.


Thanks,
Mathias
