MIME-Version: 1.0
References: <CALS6=qX5TyXFjVnJiamaBhVrfLa0_LYkjH9iN2-WKpVwM0WnGA@mail.gmail.com>
 <CAGXu5j+Yyu+mKK=bN6Ugha06huGY06=s56XLoXRC1-2FEP89fQ@mail.gmail.com>
In-Reply-To: <CAGXu5j+Yyu+mKK=bN6Ugha06huGY06=s56XLoXRC1-2FEP89fQ@mail.gmail.com>
From: Carter Cheng <cartercheng@gmail.com>
Date: Thu, 6 Dec 2018 09:51:43 +0800
Message-ID: <CALS6=qVfuaTSm4V6imhAKEHT_qnF506H3WiE9zcKn+eXErhgmg@mail.gmail.com>
Subject: Re: dynamically allocating memory in the kernel
Content-Type: multipart/alternative; boundary="0000000000003f026a057c50be70"
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--0000000000003f026a057c50be70
Content-Type: text/plain; charset="UTF-8"

Thanks, I'll check them out.

On Thu, Dec 6, 2018 at 7:01 AM Kees Cook <keescook@chromium.org> wrote:

> On Wed, Dec 5, 2018 at 12:46 PM Carter Cheng <cartercheng@gmail.com>
> wrote:
> >
> > Hello,
> >
> > I was wondering if someone here could help me understand something about
> the kernel for a project I am working on tracking dynamically allocated
> memory. How many ways are there to dynamically allocate memory in the
> kernel presently? I know of 4.
> >
> > get_free_pages family of functions
> > kmalloc family (including vmalloc)
>
> vmalloc is quite different from kmalloc (see below).
>
> > slab allocation
>
> kmalloc is a type of slab allocation, so the base parts are the same.
>
> > mempools.
> >
> > Are there others? I am trying to track them all down so I have
> comprehensively know when all allocations occur and all "frees".
>
> I would recommend looking at KASAN hooks (which tracks use-after-free)
> to see if there are any areas you're missing.
>
> -Kees
>
> --
> Kees Cook
>

--0000000000003f026a057c50be70
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks, I&#39;ll check them out.=C2=A0<br></div><br><div c=
lass=3D"gmail_quote"><div dir=3D"ltr">On Thu, Dec 6, 2018 at 7:01 AM Kees C=
ook &lt;<a href=3D"mailto:keescook@chromium.org">keescook@chromium.org</a>&=
gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0=
 .8ex;border-left:1px #ccc solid;padding-left:1ex">On Wed, Dec 5, 2018 at 1=
2:46 PM Carter Cheng &lt;<a href=3D"mailto:cartercheng@gmail.com" target=3D=
"_blank">cartercheng@gmail.com</a>&gt; wrote:<br>
&gt;<br>
&gt; Hello,<br>
&gt;<br>
&gt; I was wondering if someone here could help me understand something abo=
ut the kernel for a project I am working on tracking dynamically allocated =
memory. How many ways are there to dynamically allocate memory in the kerne=
l presently? I know of 4.<br>
&gt;<br>
&gt; get_free_pages family of functions<br>
&gt; kmalloc family (including vmalloc)<br>
<br>
vmalloc is quite different from kmalloc (see below).<br>
<br>
&gt; slab allocation<br>
<br>
kmalloc is a type of slab allocation, so the base parts are the same.<br>
<br>
&gt; mempools.<br>
&gt;<br>
&gt; Are there others? I am trying to track them all down so I have compreh=
ensively know when all allocations occur and all &quot;frees&quot;.<br>
<br>
I would recommend looking at KASAN hooks (which tracks use-after-free)<br>
to see if there are any areas you&#39;re missing.<br>
<br>
-Kees<br>
<br>
-- <br>
Kees Cook<br>
</blockquote></div>

--0000000000003f026a057c50be70--
