Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 17 Jan 2017 10:42:39 +0000
From: Dave P Martin <Dave.Martin@arm.com>
Message-ID: <20170117104239.GG18838@e103592.cambridge.arm.com>
References: <20170113220256.GA57663@beast>
 <20170116115435.GB5908@leverpostej>
 <587D1D70.26193.89AFE10@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <587D1D70.26193.89AFE10@pageexec.freemail.hu>
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: Add structleak for more stack initialization
To: PaX Team <pageexec@freemail.hu>
Cc: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com, Emese Revfy <re.emese@gmail.com>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, park jinbum <jinb.park7@gmail.com>, Daniel Micay <danielmicay@gmail.com>, linux-kernel@vger.kernel.org, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 16, 2017 at 08:22:24PM +0100, PaX Team wrote:
> On 16 Jan 2017 at 11:54, Mark Rutland wrote:

[...]

> > I assume that this is only guaranteed to initialise fields in a struct,
> > and not padding, is that correct? I ask due to the issue described in:
> >
> > https://lwn.net/Articles/417989/
>
> the 'issue' is that before C11 the standard didn't make it clear that in
> case of a partial initializer list the compiler has to initialize not onl=
y
> the remaining fields but also padding as well.

Which version of the C11 spec clarifies this?

The one I'm looking at (n1570, Apr 12 2011) says:

"6.7.9 21 If there are fewer initializers in a brace-enclosed list than
there are elements or members of an aggregate, or fewer characters in a
string literal used to initialize an array of known size than there are
elements in the array, the remainder of the aggregate shall be
initialized implicitly the same as objects that have static storage
duration."

What is meant by "the remainder of the object" is unclear.  Is this
just the tail of the object, or all unitialised members --
which may be sparse in the case of an initialiser with designators?
And is padding (and if so, which padding) considered to be part of (the
remainder of) the object for the purpose of this paragraph?

This can be read with the interpretation you suggest, but the wording
doesn't seem rock-solid.  For the kernel, I guess it's sufficient if
GCC commits to this interpretation though.


A related, perhaps more interesting issue is that C11 still explicitly
states that padding is undefined after assignment:

"6.2.6.1 6 When a value is stored in an object of structure or union
type, including in a member object, the bytes of the object
representation that correspond to any padding bytes take unspecified
values.  51)"

"51) Thus, for example, structure assignment need not copy any padding
bits."

which means that in:

{
        struct foo foo1 =3D FOO1_INTIALIZER;
        struct foo foo2;

        foo2 =3D foo1;
}

the contents of padding in foo2 is unspecified.

Similarly, piecemeal initialisation of an object by assigning to every
member leaves the padding unspecified, e.g.:

{
        struct timeval tv;

        tv.tv_sec =3D secs;
        tv.tv_usec =3D usecs;
}

(On most or all arches struct timeval contains no padding, but relying
implicitly on this is still a bit iffy.)


It's highly likely that the kernel passes objects resulting from one of
the above to put_user() and friends.  It would be good if we had a way
to catch at least some of these.

(I don't know whether that falls naturally under this plugin.)

Cheers
---Dave
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
