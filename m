Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1466817192-9586-1-git-send-email-jannh@google.com>
References: <1466817192-9586-1-git-send-email-jannh@google.com>
From: Kees Cook <keescook@google.com>
Date: Fri, 24 Jun 2016 18:59:30 -0700
Message-ID: <CAGXu5j+Re9RgEgh-j_71j=F_0ppx7CKpgs76yXbB=a6hRaH=cQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC] reference count hardening via kref: another attempt
To: Jann Horn <jannh@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Jann Horn <jann@thejh.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 24, 2016 at 6:13 PM, Jann Horn <jannh@google.com> wrote:
> I would like to harden the kernel against reference count
> overflow bugs. The commit message of the patch contains
> a short analysis of code size impact, an explanation why I
> want reference count hardening to land in the kernel, and a
> description of the algorithm I'd want to use.
>
> The reason I'm writing a cover letter is that my patch, on
> its own, is pretty useless: My patch only adds hardening to
> struct kref, but nearly all reference counters are
> currently implemented using atomic_t, which is a generic
> atomic number type. For the patch to be useful, I'll have
> to go through the kernel and, for every atomic_t, decide
> whether it is a reference count and, if so, change it
> (together with all accesses to it) to a kref. According to
> a quick grep, there are currently about 2700 atomic_t
> struct members or variables in the kernel, so it's going to
> be a big amount of work, and the resulting patches will be
> gigantic.
>
> Therefore, before I actually spend lots of time on this,
> I'd like to know:
>
>  - Does the reference count hardening in my patch look
>    okay, and does it have good chances to get accepted
>    when submitted for inclusion in the kernel at a later
>    point in time?
>
>  - If I manually go through the kernel and write a
>    gigantic atomic_t -> struct kref patch (or a few
>    patches coarsely grouped by subsystem), how high is
>    the probability that it will get accepted?

My main concern is atomic_t will continue to get misused. While I have
no problem with wrap-checking kref, I think that we need to follow
grsecurity and introduce a new type (in grsec it is
"atomic_unchecked_t", but I think a more descriptive name would be
"atomic_wrap_t") and add them everywhere they're needed, and then
globally protect atomic_t wrapping. kref would gain the protections
automatically, though it would be arch-dependent...

-Kees

>
> (Note: I won't have much time for kernel work in the next
> four months or so - but afterwards, I could probably
> allocate time for getting this done.)
>
> Jann Horn (1):
>   kref: pin objects with dangerously high reference count
>
>  include/linux/kref.h | 39 +++++++++++++++++++++++++++++++++------
>  init/Kconfig         | 16 ++++++++++++++++
>  kernel/Makefile      |  2 +-
>  kernel/kref.c        | 17 +++++++++++++++++
>  4 files changed, 67 insertions(+), 7 deletions(-)
>  create mode 100644 kernel/kref.c
>
> --
> 2.8.0.rc3.226.g39d4020
>



-- 
Kees Cook
Chrome OS & Brillo Security
