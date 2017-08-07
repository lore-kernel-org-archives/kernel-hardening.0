MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <867e7dfd-ce67-a8ea-60b8-897b45a6adbc@oracle.com>
References: <a5e688c4-94b8-b0aa-4425-fc687d3aeeca@redhat.com>
 <CAGXu5jLre9QdOWi+-GxcGi=rxp=Emwnaz=MBxDtdd_ZD=VRc2w@mail.gmail.com>
 <87ino04hz5.fsf@rasmusvillemoes.dk> <867e7dfd-ce67-a8ea-60b8-897b45a6adbc@oracle.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 7 Aug 2017 15:18:00 -0700
Message-ID: <CAGXu5jKtSb1h4rbKg2zVxLfJP7VPSvXApi7KWb81nq_Uj151BQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: Format string gcc-plugin?
To: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Laura Abbott <labbott@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 7, 2017 at 3:06 PM, Vaishali Thakkar
<vaishali.thakkar@oracle.com> wrote:
> I was recently looking at gcc's -Wformat-security and realized that there is
> a TODO point on KSPP's wiki page regarding fixing it for const
> strings.
>
> I was wondering that may be we can also try Coccinelle for the type checking
> of %pX extensions? Is there any work done or is someone working on this
> after this discussion?
>
> I'm not sure what is a preferable way over here [GCC plugin or Coccinelle
> scripts] but if noone is working on this then I would like to give it a try.
> Any comments on the same are welcome.

I would prefer a gcc plugin just because that could be enabled for the
regular build (where as a Coccinelle check is a separate build type).
Also I think a gcc plugin would allow for better control of the
checks, since it will actually be in the middle of constructing the
actual instructions and variables, etc. Coccinelle has to guess
sometimes.

-Kees

-- 
Kees Cook
Pixel Security
