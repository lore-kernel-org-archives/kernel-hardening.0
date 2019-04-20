MIME-Version: 1.0
References: <20190414091452.22275-1-shyam.saini@amarulasolutions.com> <C398B8C9-6A54-4590-AA88-58D514BAEB71@oracle.com>
In-Reply-To: <C398B8C9-6A54-4590-AA88-58D514BAEB71@oracle.com>
From: Shyam Saini <mayhs11saini@gmail.com>
Date: Sat, 20 Apr 2019 16:21:00 +0530
Message-ID: <CAOfkYf7vn7UnYzZDh9==agVu61sYyFWzvo6hQBt3KfaKrWC-6Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] include: linux: Regularise the use of FIELD_SIZEOF macro
Content-Type: text/plain; charset="UTF-8"
To: William Kucharski <william.kucharski@oracle.com>
Cc: Shyam Saini <shyam.saini@amarulasolutions.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, dri-devel <dri-devel@lists.freedesktop.org>, Network Development <netdev@vger.kernel.org>, linux-ext4@vger.kernel.org, devel@lists.orangefs.org, linux-mm <linux-mm@kvack.org>, linux-sctp@vger.kernel.org, bpf <bpf@vger.kernel.org>, kvm@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi William,

Sorry for the late reply.

> > Currently, there are 3 different macros, namely sizeof_field, SIZEOF_FIELD
> > and FIELD_SIZEOF which are used to calculate the size of a member of
> > structure, so to bring uniformity in entire kernel source tree lets use
> > FIELD_SIZEOF and replace all occurrences of other two macros with this.
> >
> > For this purpose, redefine FIELD_SIZEOF in include/linux/stddef.h and
> > tools/testing/selftests/bpf/bpf_util.h and remove its defination from
> > include/linux/kernel.h
>
>
> > --- a/include/linux/stddef.h
> > +++ b/include/linux/stddef.h
> > @@ -20,6 +20,15 @@ enum {
> > #endif
> >
> > /**
> > + * FIELD_SIZEOF - get the size of a struct's field
> > + * @t: the target struct
> > + * @f: the target struct's field
> > + * Return: the size of @f in the struct definition without having a
> > + * declared instance of @t.
> > + */
> > +#define FIELD_SIZEOF(t, f) (sizeof(((t *)0)->f))
> > +
> > +/**
> >  * sizeof_field(TYPE, MEMBER)
> >  *
> >  * @TYPE: The structure containing the field of interest
> > @@ -34,6 +43,6 @@ enum {
> >  * @MEMBER: The member within the structure to get the end offset of
> >  */
> > #define offsetofend(TYPE, MEMBER) \
> > -     (offsetof(TYPE, MEMBER) + sizeof_field(TYPE, MEMBER))
> > +     (offsetof(TYPE, MEMBER) + FIELD_SIZEOF(TYPE, MEMBER))
>
> If you're doing this, why are you leaving the definition of sizeof_field() in
> stddef.h untouched?

I have removed definition of sizeof_field in [1/2] patch.

> Given the way this has worked historically, if you are leaving it in place for
> source compatibility reasons, shouldn't it be redefined in terms of
> FIELD_SIZEOF(), e.g.:
>
> #define sizeof_field(TYPE, MEMBER) FIELD_SIZEOF(TYPE, MEMBER)

Actually, never thought this way. So,Thanks a lot for this valuable feedback.

I'll re-spin and post again.
