Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 17 Jan 2017 22:04:20 +0000
From: Dave P Martin <Dave.Martin@arm.com>
Message-ID: <20170117220420.GQ18838@e103592.cambridge.arm.com>
References: <20170113220256.GA57663@beast>
 <587E4FDD.31940.D47F642@pageexec.freemail.hu>
 <20170117180746.GN18838@e103592.cambridge.arm.com>
 <587E6FBD.21621.DC486DE@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <587E6FBD.21621.DC486DE@pageexec.freemail.hu>
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: Add structleak for more stack initialization
To: PaX Team <pageexec@freemail.hu>
Cc: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com, Emese Revfy <re.emese@gmail.com>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, park jinbum <jinb.park7@gmail.com>, Daniel Micay <danielmicay@gmail.com>, linux-kernel@vger.kernel.org, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 17, 2017 at 08:25:49PM +0100, PaX Team wrote:
> On 17 Jan 2017 at 18:07, Dave P Martin wrote:
>
> > On Tue, Jan 17, 2017 at 06:09:49PM +0100, PaX Team wrote:
> > > On 17 Jan 2017 at 10:42, Dave P Martin wrote:
> > >
> > > > This can be read with the interpretation you suggest, but the wordi=
ng
> > > > doesn't seem rock-solid.  For the kernel, I guess it's sufficient i=
f
> > > > GCC commits to this interpretation though.
> > >
> > > note that i'm not a language lawyer, merely an interpreter, so take
> > > the above with a grain of salt.
> >
> > Me neither, but actually I think this interpretation doesn't make sense=
.
> > The implication seems to be that padding initialisation of initialised
> > aggregates with automatic storage is guaranteed _only_ if the
> > initialiser is incomplete.
>
> however illogical it sounds, that's actually what is implied by the stand=
ard
> and gcc behaves this way. my test case with a bit more verbose output tha=
n
> your example (gcc shows in comments what each assignment corresponds to):
>
> ------ cut --------
> gcc -O2 -x c -S -fverbose-asm -o - - <<EOF
> struct s1 {
>         char c;
>         int l;
> };
>
> void f(struct s1*);
>
> void g(void)
> {
>         struct s1 s1 =3D {};
>         struct s1 s2 =3D { .c =3D 1};
>         struct s1 s3 =3D { .l =3D 2};
>         struct s1 s4 =3D { .c =3D 3, .l =3D 4};
>
>         f(&s1);
>         f(&s2);
>         f(&s3);
>         f(&s4);
> }
> EOF
> ------ cut --------
>
> > This may or may not be a bug, and may or may not have been fixed in a
> > more recent version.
>
> i tested 4.5.4, 6.3 and 7.0 from about a month ago on amd64 and had
> consistent results as above. i think it's not a bug but an intentional
> optimization but i don't feel like digging it out from the gcc sources :)=
.

Interesting.  So I guess we're probably stuck with it, good or bad.

Do you know the rationale behind the inconsistency?

> > > both examples would be handled by the plugin if the types involved al=
ready
> > > have a __user annotated field (as neither foo2 nor tv are initialized=
, only
> > > assigned to), otherwise it'd need manual annotation and/or more stati=
c analysis.
> >
> > Do you see any false positives here?  I would expect a fair number of
> > structures that contain __user pointers but that are never copied
> > wholesale to userspace, but I've not reviewed in detail.
>
> false positive depends on what you consider a goal ;). for me the structl=
eak
> plugin had to serve one specific purpose (initialize a local variable tha=
t
> would otherwise leak unintended kernel stack content back to userland), e=
verything
> else didn't matter. now if you want to move the goalpost and initialize t=
hose
> and only those variables that get copied to userland but aren't otherwise
> guaranteed to be completely initialized then you'll need something much s=
marter
> than the current structleak plugin as it doesn't serve that purpose and w=
ill
> both overinitialize and fail to initialize affected variables...

Sure -- the hope was that structleak might cover this sort of thing
without too much extra effort, but it sounds less realistic now.

Cheers
---Dave
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
